{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_Calculator (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/anai/.cabal/bin"
libdir     = "/home/anai/.cabal/lib/x86_64-linux-ghc-8.6.5/Calculator-0.1.0.0-3Hee4cZEdzkHUDUuuq2KN9-Calculator-exe"
dynlibdir  = "/home/anai/.cabal/lib/x86_64-linux-ghc-8.6.5"
datadir    = "/home/anai/.cabal/share/x86_64-linux-ghc-8.6.5/Calculator-0.1.0.0"
libexecdir = "/home/anai/.cabal/libexec/x86_64-linux-ghc-8.6.5/Calculator-0.1.0.0"
sysconfdir = "/home/anai/.cabal/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "Calculator_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "Calculator_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "Calculator_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "Calculator_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "Calculator_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "Calculator_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
