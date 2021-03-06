{-# LANGUAGE GADTs #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE FlexibleInstances #-}

module ExistentialTypes where

import Data.Kind (Constraint, Type)

data Any where Any :: a -> Any

-- The caller of elimAny gets to decide the result r
-- but a is determined by the inside of the Any
elimAny :: (forall a. a -> r) -> Any -> r
elimAny f (Any a) = f a

-- The function does not seem really interesting,
-- because A has no constraint there is not much
-- to do for the caller, given that a is decided
-- by Any

data HasShow where
  HasShow :: Show t => t -> HasShow

instance Show HasShow where
--  show (HasShow s) = "HasShow " ++ show s
  show = elimHasShow ((<>) "HasShow" . show)

elimHasShow
    :: (forall a. Show a => a -> r)
    -> HasShow
    -> r
elimHasShow f (HasShow a) = f a

f' :: String
f' = elimHasShow ((<>) "Hola" . show) (HasShow (1 :: Integer))

data Has (c :: Type -> Constraint) where Has :: c t => t -> Has c

elimHas
  :: (forall a. c a => a -> r)
  -> Has c
  -> r
elimHas f (Has a) = f a

type HasShow' = Has Show
instance Show (Has Show) where show = elimHas show
