module Purs.Buddy.Example where

import Data.Aeson (Value)
import Data.Aeson.QQ

example :: Value
example = [aesonQQ|
{
  "result": [
    {
      "suggestion": {
        "replaceRange": {
          "startLine": 5,
          "endLine": 5,
          "startColumn": 1,
          "endColumn": 16
        },
        "replacement": "import Contract (Contract, CurrencySymbol, Unit, adaOf, bigInt, bind, discard, fromMaybeContract, getWalletBalance, map, ownPubKeyHash, ownStakePubKeyHash, privateStakeKeyFromFile, pubKeyHashString, pure, show, stakePubKeyHashString, withKeyWallet, ($), (<$>), (<<<), (<>), (=<<), (==))"
      },
      "moduleName": "Suite.WalletInfo",
      "errorLink": "https://github.com/purescript/documentation/blob/master/errors/ImplicitImport.md",
      "errorCode": "ImplicitImport",
      "message": "  Module Contract has unspecified imports, consider using the explicit form:\n\n    import Contract (Contract, CurrencySymbol, Unit, adaOf, bigInt, bind, discard, fromMaybeContract, getWalletBalance, map, ownPubKeyHash, ownStakePubKeyHash, privateStakeKeyFromFile, pubKeyHashString, pure, show, stakePubKeyHashString, withKeyWallet, ($), (<$>), (<<<), (<>), (=<<), (==))\n",
      "allSpans": [
        {
          "start": [
            5,
            1
          ],
          "name": "/home/anton/dev/mlabs/equine/test/Suite/WalletInfo.purs",
          "end": [
            5,
            16
          ]
        }
      ],
      "filename": "/home/anton/dev/mlabs/equine/test/Suite/WalletInfo.purs",
      "position": {
        "startLine": 5,
        "endLine": 5,
        "startColumn": 1,
        "endColumn": 16
      }
    },
    {
      "suggestion": {
        "replaceRange": {
          "startLine": 8,
          "endLine": 8,
          "startColumn": 1,
          "endColumn": 20
        },
        "replacement": "import Plutip.Types (InitialUTxOs, PlutipConfig)"
      },
      "moduleName": "Suite.WalletInfo",
      "errorLink": "https://github.com/purescript/documentation/blob/master/errors/ImplicitImport.md",
      "errorCode": "ImplicitImport",
      "message": "  Module Plutip.Types has unspecified imports, consider using the explicit form:\n\n    import Plutip.Types (InitialUTxOs, PlutipConfig)\n",
      "allSpans": [
        {
          "start": [
            8,
            1
          ],
          "name": "/home/anton/dev/mlabs/equine/test/Suite/WalletInfo.purs",
          "end": [
            8,
            20
          ]
        }
      ],
      "filename": "/home/anton/dev/mlabs/equine/test/Suite/WalletInfo.purs",
      "position": {
        "startLine": 8,
        "endLine": 8,
        "startColumn": 1,
        "endColumn": 20
      }
    }
  ],
  "resultType": "success"
}
  |]
