{-# LANGUAGE DataKinds #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE PartialTypeSignatures #-}
{-# LANGUAGE TypeInType #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE DefaultSignatures #-}
{-# OPTIONS_GHC -Wno-partial-type-signatures #-}

module Torch.Typed.Parameter where

import           Control.Monad.State.Strict
import           Data.HList
import           Data.Kind                    (Type)
import           GHC.TypeLits
import           GHC.TypeLits.Extra
import           GHC.Generics

import qualified Torch.NN                      as A
import qualified Torch.Autograd                as A
import qualified Torch.Tensor                  as A
import qualified Torch.DType                   as D
import qualified Torch.Device                  as D
import           Torch.Typed.Aux
import           Torch.Typed.Factories
import           Torch.Typed.Native
import           Torch.Typed.Tensor

newtype Parameter (device :: (D.DeviceType, Nat)) (dtype :: D.DType) (shape :: [Nat]) = Parameter A.IndependentTensor
  deriving (Show)

toDependent
  :: forall shape dtype device
   . Parameter device dtype shape
  -> Tensor device dtype shape
toDependent (Parameter t) = UnsafeMkTensor $ A.toDependent t

makeIndependent
  :: forall shape dtype device
   . Tensor device dtype shape
  -> IO (Parameter device dtype shape)
makeIndependent t = Parameter <$> A.makeIndependent (toDynamic t)

class Parameterized
  (f :: Type)
  (as :: [Type]) | f -> as where

  flattenParameters :: f -> HList as
  -- default flattenParameters :: (Generic f, GParameterized (Rep f) as) => f -> HList as
  -- flattenParameters f = gFlattenParameters (from f)

  replaceParameters :: f -> HList as -> f
  -- default replaceParameters :: (Generic f, GParameterized (Rep f) as) => f -> HList as -> f
  -- replaceParameters f as = to (gReplaceParameters (from f) as)

instance
  ( Generic f
  , GParameterized (Rep f) as
  ) => Parameterized f as where
  flattenParameters f = gFlattenParameters (from f)
  replaceParameters f as = to (gReplaceParameters (from f) as)

class GParameterized
  (f :: Type -> Type)
  (as :: [Type]) | f -> as where

  gFlattenParameters :: f a -> HList as
  gReplaceParameters :: f a -> HList as -> f a

instance
  ( GParameterized l as
  , GParameterized r bs
  , HAppendFD as bs cs
  , cs ~ (as ++ bs)
  ) => GParameterized (l :*: r) cs where
  gFlattenParameters (l :*: r) =
    let as = gFlattenParameters l
        bs = gFlattenParameters r
    in  as `hAppendFD` bs
  gReplaceParameters (l :*: r) cs =
    let (as, bs) = hUnappendFD cs
        l'       = gReplaceParameters l as
        r'       = gReplaceParameters r bs
    in  l' :*: r'

instance {-# OVERLAPS #-}
  GParameterized (K1 R (Tensor device dtype shape)) '[] where
  gFlattenParameters _ = HNil
  gReplaceParameters = const

instance {-# OVERLAPS #-}
  GParameterized (K1 R (Parameter device dtype shape)) '[Parameter device dtype shape] where
  gFlattenParameters = (:. HNil) . unK1
  gReplaceParameters _ (parameter :. HNil) = K1 parameter

instance {-# OVERLAPS #-}
  GParameterized (K1 R Double) '[] where
  gFlattenParameters _ = HNil
  gReplaceParameters = const

instance {-# OVERLAPPABLE #-}
  ( Generic f
  , GParameterized (Rep f) as
  ) => GParameterized (K1 i f) as where
  gFlattenParameters = gFlattenParameters . from . unK1
  gReplaceParameters (K1 f) = K1 . to . gReplaceParameters (from f)

instance (GParameterized f as) => GParameterized (M1 i t f) as where
  gFlattenParameters = gFlattenParameters . unM1
  gReplaceParameters (M1 f) = M1 . gReplaceParameters f

instance GParameterized U1 '[] where
  gFlattenParameters _ = HNil
  gReplaceParameters = const

-- instance Parameterized (HList '[]) '[] where
--   flattenParameters _ = HNil
--   replaceParameters _ _ = HNil

-- instance
--   ( Parameterized a as
--   , Parameterized (HList bs) bs
--   , HAppendFD as bs cs
--   , cs ~ (as ++ bs)
--   ) => Parameterized (HList cs) cs where
--   flattenParameters = id
--   replaceParameters _ = id

-- instance A.Parameterized (Parameter device dtype shape) where
--   flattenParameters (Parameter x) = [x]
--   replaceOwnParameters _ = Parameter <$> A.nextParameter

-- instance A.Parameterized (HList '[]) where
--   flattenParameters _ = []
--   replaceOwnParameters = return

-- instance (A.Parameterized x, A.Parameterized (HList xs))
--   => A.Parameterized (HList (x ': xs))
--  where
--   flattenParameters (x :. xs) = A.flattenParameters x <> A.flattenParameters xs
--   replaceOwnParameters (x :. xs) = do
--     x' <- A.replaceOwnParameters x
--     xs' <- A.replaceOwnParameters xs
--     return $ x' :. xs'

instance A.Randomizable (HList '[]) (HList '[]) where
  sample = return

instance (A.Randomizable xSpec x, A.Randomizable (HList xsSpec) (HList xs))
  => A.Randomizable (HList (xSpec ': xsSpec)) (HList (x ': xs))
 where
  sample (xSpec :. xsSpec) = do
    x <- A.sample xSpec
    xs <- A.sample xsSpec
    return $ x :. xs

data ToDependent = ToDependent

instance Apply ToDependent (Parameter device dtype shape) (Tensor device dtype shape) where
  apply _ = toDependent
