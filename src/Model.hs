{-# LANGUAGE QuasiQuotes, OverloadedStrings, TypeFamilies #-}
{-# LANGUAGE TemplateHaskell, FlexibleContexts, GADTs #-}

module Model where

import Database.Persist.MongoDB
import Database.Persist.TH
import Database.Persist.Quasi

mkPersist sqlSettings [persist|
User
    name String
    password String
    deriving Show
|]