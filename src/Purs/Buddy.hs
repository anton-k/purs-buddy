module Purs.Buddy(
  runApp,
  rebuild,
  rebuildJson,
  findPursFiles,
  applySuggestions,
  applyToFile,
) where

-- import Control.Foldl qualified as Fold
import Control.Monad.IO.Class
import Data.Aeson (encode, decode)
import Data.Aeson.QQ
import Data.ByteString.Lazy (ByteString, fromStrict, toStrict)
import Data.List qualified as L
import Data.Maybe (fromJust, maybeToList)
import Data.Text qualified as T
import Data.Text.IO qualified as T
import Data.Text.Encoding qualified as T
import Purs.Buddy.Types
import System.Directory
import Turtle qualified as Turtle
import Turtle.Pattern qualified as P
import Purs.Buddy.Args
import Data.String

rebuildJson :: FilePath -> ByteString
rebuildJson file = encode $
  [aesonQQ|
    {"command": "rebuild",
     "params": {"file": #{file},"codegen": ["js", "corefn"]}
    }
  |]

rebuild :: FilePath -> Turtle.Shell Build
rebuild file = liftIO $
  fromJust . decode . fromStrict . T.encodeUtf8 . snd
  <$> Turtle.shellStrict "purs ide client" (pure $ Turtle.unsafeTextToLine $ T.decodeUtf8 (toStrict $ rebuildJson file))

findPursFiles :: FilePath -> Turtle.Shell FilePath
findPursFiles dir = do
  Turtle.cd dir
  line <- Turtle.grep isPurs $ Turtle.inshell "git ls-files" Turtle.mzero
  pure $ T.unpack $ Turtle.lineToText line
  where
    isPurs = P.ends $ fmap (T.pack . pure) P.dot <> "purs"

runApp :: Args -> IO ()
runApp args = Turtle.sh $
  applySuggestions args =<< findPursFiles =<< liftIO getCurrentDirectory

applySuggestions :: Args -> FilePath -> Turtle.Shell ()
applySuggestions Args{..} file = do
  results <- build'result . onPrelude <$> rebuild file
  let sugs = maybeToList . result'suggestion =<< results
  liftIO $ applyToFile sugs file
  Turtle.echo $ fromString $ "Replace in file: " <> file
  where
    onPrelude
      | args'skipPrelude = skipPreludeImports
      | otherwise        = id

applyToFile :: [Suggestion] -> FilePath -> IO ()
applyToFile suggestions file = do
  fileLines <- zip [1..] . T.lines <$> T.readFile file
  let sortedSugs = L.sortOn replacementOrder suggestions
  T.writeFile file $ T.unlines $ merge sortedSugs fileLines
  where
    replacementOrder Suggestion{..} =
      ( replaceRange'startLine suggestion'replaceRange
      , replaceRange'startColumn suggestion'replaceRange)

    merge sugs locs = case sugs of
      [] -> fmap snd locs
      sug : restSugs -> case locs of
        [] -> []
        loc : restLocs -> mergeLine sug loc restSugs restLocs

    mergeLine sug@Suggestion{..} (loc, content) restSugs restLocs
      | loc < startLine = content : merge (sug : restSugs)  restLocs
      | loc == startLine && loc == endLine = (T.take (startColumn - 1) content <> suggestion'replacement <> T.drop endColumn content) : merge restSugs restLocs
      | loc == startLine = (T.take (startColumn - 1) content <> suggestion'replacement) : merge (sug : restSugs) restLocs
      | loc > startLine && loc < endLine = merge (sug : restSugs) restLocs
      | loc == endLine = (T.drop endColumn content) : merge restSugs restLocs
      | otherwise = content : merge restSugs restLocs
      where
        (ReplaceRange startLine endLine startColumn endColumn) = suggestion'replaceRange

