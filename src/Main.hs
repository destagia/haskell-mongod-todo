{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}

module Main (main) where

import Database.MongoDB    (Action, Document, Document, Value, access,
                            close, connect, delete, exclude, find,
                            host, insertMany, insert_, master, project, rest,
                            select, sort, (=:))
import Control.Monad.Trans (liftIO)
import System.Environment (getArgs)
import Prelude
import System.IO

data Command = Insert  { getTag :: String, getData :: String }
             | Delete  { getTag :: String }
             | Update  { getTag :: String }
             | Find    { getTag :: String }
             | FindAll
             | Illegal
             deriving Show

main :: IO ()
main = do
    args <- getArgs
    database (argsToCommand args)

database :: Command -> IO ()
database command = do
    pipe <- connect (host "127.0.0.1")
    e <- access pipe master "todohaskell" (runTodo command)
    close pipe

-- コマンドラインの命令を振り分けます
argsToCommand :: [String] -> Command
argsToCommand []         = FindAll
argsToCommand (x:[])     = Find x
argsToCommand (x:(y:[])) = if x == "fin"
                            then Delete y
                            else Insert  x y
argsToCommand _          = Illegal

runTodo :: Command -> Action IO ()
runTodo FindAll = do
                findAllTodo >>= printDocs "All Todo"
runTodo (Find tag) = do
                (findTodo tag) >>= printDocs ("Tag:" ++ tag)
runTodo (Insert tag mes) = do
                insertTodo tag mes
runTodo (Delete tag) = do
                deleteTodo tag
                liftIO $ (putStrLn $ "delete Tag:" ++ tag)

deleteTodo :: String -> Action IO ()
deleteTodo tag = delete (select ["tag" =: tag] "list")

insertTodo :: String -> String -> Action IO ()
insertTodo tag mes = insert_ "list" ["tag" =: tag, "message" =: mes]

findAllTodo :: Action IO [Document]
findAllTodo = rest =<< find (select [] "list")

findTodo :: String -> Action IO [Document]
findTodo tag = rest =<< find (select ["tag" =: tag] "list")

printDocs :: String -> [Document] -> Action IO ()
printDocs title docs = liftIO $ putStrLn title >> mapM_ (print . exclude ["_id"]) docs

