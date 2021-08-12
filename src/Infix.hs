module Infix (
    expr,
    term,
    factor,
    addition,
    multiplication,
    val,
    eval
) where

import Parser

-- Abstract
data Expr = Val Double | Add Expr Expr | Sub Expr Expr | Mul Expr Expr | Div Expr Expr

expr :: Parser Expr
expr = addition term expr <|> substraction term expr <|> term <|> val

term :: Parser Expr
term = multiplication factor expr <|> division factor expr <|> factor

factor :: Parser Expr
factor = val <|> bracket expr

bracket :: Parser Expr -> Parser Expr
bracket p = do
    token '('
    spaces
    ret <- p
    token ')'
    return ret

addition :: Parser Expr -> Parser Expr -> Parser Expr
addition p q = do
    v1 <- p
    spaces 
    item '+'
    spaces
    v2 <- q
    return $ Add v1 v2

substraction :: Parser Expr -> Parser Expr -> Parser Expr
substraction p q = do
    v1 <- p
    spaces 
    item '-'
    spaces
    v2 <- q
    return $ Sub v1 v2

multiplication :: Parser Expr -> Parser Expr -> Parser Expr
multiplication p q = do
    v1 <- p
    spaces 
    item '*'
    spaces
    v2 <- q
    return $ Mul v1 v2

division :: Parser Expr -> Parser Expr -> Parser Expr
division p q = do
    v1 <- p
    spaces 
    item '/'
    spaces
    v2 <- q
    return $ Div v1 v2

val :: Parser Expr
val = floating <|> integral where
    integral = Val . read <$> natural
    floating = do
        x <- natural
        item '.'
        y <- natural
        return $ Val $ read $ x ++ "." ++ y

eval :: Expr -> Double
eval (Val x) = x
eval (Add x y) = eval x + eval y
eval (Sub x y) = eval x - eval y
eval (Mul x y) = eval x * eval y
eval (Div x y) = eval x / eval y
