module Purs.Buddy.Types where

import Data.Aeson.TH (deriveJSON)
import Data.List qualified as L
import Data.Text (Text)
import Data.Text qualified as T
import Purs.Buddy.Derive (fieldOptions)

data Build = Build
  { build'resultType :: Text
  , build'result     :: [Result]
  }
  deriving (Show)

data Result = Result
  { result'suggestion  :: Maybe Suggestion
  , result'errorCode   :: Text
  }
  deriving (Show)

data Suggestion = Suggestion
  { suggestion'replaceRange :: ReplaceRange
  , suggestion'replacement  :: Text
  }
  deriving (Show)

data ReplaceRange = ReplaceRange
  { replaceRange'startLine   :: Int
  , replaceRange'endLine     :: Int
  , replaceRange'startColumn :: Int
  , replaceRange'endColumn   :: Int
  }
  deriving (Show)

-- | Removes one ImplicitImport item that has more items to import
skipPreludeImports :: Build -> Build
skipPreludeImports build =
  build { build'result = (fmap snd $ L.deleteBy (const isPrelude) undefined impsSized) <> noImps }
  where
    (imps, noImps) = L.partition ((== "ImplicitImport") . result'errorCode) $ build'result build
    impsSized = fmap (\x -> (maybe 0 (T.length . suggestion'replacement) $ result'suggestion x, x)) imps
    preludeSize = maximum $ fmap fst impsSized

    isPrelude = (== preludeSize) . fst

$(deriveJSON fieldOptions ''ReplaceRange)
$(deriveJSON fieldOptions ''Suggestion)
$(deriveJSON fieldOptions ''Result)
$(deriveJSON fieldOptions ''Build)

