module Purs.Buddy.Derive(
  fieldOptions
) where

import Data.Aeson.TH (defaultOptions, Options, fieldLabelModifier)

fieldOptions :: Options
fieldOptions = defaultOptions { fieldLabelModifier = tail . dropWhile (/= '\'') }
