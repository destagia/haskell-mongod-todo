module Paths_todo (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch


version :: Version
version = Version {versionBranch = [0,1,0,0], versionTags = []}
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/shohei/.cabal/bin"
libdir     = "/Users/shohei/.cabal/lib/x86_64-osx-ghc-7.8.3/MongoHaskell-0.1.0.0"
datadir    = "/Users/shohei/.cabal/share/x86_64-osx-ghc-7.8.3/MongoHaskell-0.1.0.0"
libexecdir = "/Users/shohei/.cabal/libexec"
sysconfdir = "/Users/shohei/.cabal/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "todo_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "todo_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "todo_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "todo_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "todo_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
