module Main where

import Control.Monad
import Infix
import Parser (Parser, parse)
import System.IO (hFlush, hSetBuffering, stdin, stdout, BufferMode(NoBuffering))

prompt :: IO ()
prompt = forM_ [1..] $ \it -> do
    putStr $ show it ++ " > "
    str <- getLine
    let res = parse expr str
    if length res == 1 then
        print $ eval $ snd $ head res
    else
        putStrLn "Parse error!"

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering
    prompt
