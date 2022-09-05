module Main (main) where

import Purs.Buddy
import Purs.Buddy.Args

main :: IO ()
main = runApp (Args { args'skipPrelude = True })
