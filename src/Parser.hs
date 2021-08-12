module Parser(
    Parser (Parser),
    parse,

    fmap,
    return,
    (>>=),
    pure,
    (<*>),
    (<|>),
    empty,
    mzero,
    mplus,

    item,
    token,
    satisfy,
    oneOf,
    spaces,
    string,
    digit,
    natural,
    chainl,
    chainl1
) where

import Control.Applicative
import Control.Monad

newtype Parser a = Parser { parse :: String -> [(String, a)] }

instance Functor Parser where
    fmap f p = Parser (map (\(s, obj) -> (s, f obj)) . parse p)

instance Applicative Parser where
    pure    = return
    x <*> y = do
        fx <- x
        obj <- y
        return $ fx obj

instance Monad Parser where
    return x = Parser (\str -> [(str, x)])
    p >>= f  = Parser q where
        q str0 = parse p str0 >>= (\(str1, obj) -> parse (f obj) str1)

instance Alternative Parser where
    empty   = Parser $ const []
    x <|> y = Parser $ \str -> let (px, py) = (parse x str, parse y str)
                               in if null px then py else px

instance MonadPlus Parser where
    mzero     = empty
    mplus x y = Parser $ \str -> let (px, py) = (parse x str, parse y str) in px ++ py


-- a | f

item :: Char -> Parser Char
item ch = Parser $ \str -> case str of ""     -> []
                                       (c:cs) -> if c == ch then [(cs, c)] else []

token :: Char -> Parser Char
token ch = do
    spaces
    item ch

satisfy :: (Char -> Bool) -> Parser Char
satisfy p = Parser $ \str -> if str == "" then [] else let (c:cs) = str in if p c then [(cs, c)] else []

oneOf :: [Char] -> Parser Char
oneOf cs = satisfy (`elem` cs)

spaces :: Parser [Char]
spaces = many $ oneOf [' ', '\n', '\r']

string :: String -> Parser String
string ""     = return ""
string (c:cs) = do
                    h <- item c
                    t <- string cs
                    return (h:t)

digit :: Parser Char
digit = oneOf ['0'..'9']

natural :: Parser String
natural = some digit

chainl :: Parser a -> Parser (a -> a -> a) -> a -> Parser a
chainl p op a = (p `chainl1` op) <|> return a

chainl1 :: Parser a -> Parser (a -> a -> a) -> Parser a
p `chainl1` op = do {a <- p; rest a} where
    rest a = (do
                f <- op
                b <- p
                rest (f a b))
             <|> return a
