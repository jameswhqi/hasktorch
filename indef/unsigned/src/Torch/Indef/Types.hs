-------------------------------------------------------------------------------
-- |
-- Module    :  Torch.Indef.Dynamic.Types
-- Copyright :  (c) Sam Stites 2017
-- License   :  BSD3
-- Maintainer:  sam@stites.io
-- Stability :  experimental
-- Portability: non-portable
-------------------------------------------------------------------------------
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE InstanceSigs #-}
module Torch.Indef.Types
  ( module X
  , module Sig

  , (.:), shuffle2, shuffle3

  , withIx, withMask
  , mkCPUIx
  , mkCPUIxStorage
  , withCPUIxStorage

  , ptrArray2hs

  , withState
  , withDynamicState, withStorageState, withDynamicStateAndStorage
  , with2DynamicState
  , with3DynamicState
  , mkDynamic, mkStorage
  , mkDynamicIO, mkStorageIO

  , newForeignPtrEnv, withForeignPtr
  , Ptr, ForeignPtr
  ) where

import Foreign as X
import Foreign.Ptr as X
import qualified Foreign.Marshal.Array as FM

import Control.Monad.IO.Class as X
import Control.Monad.Reader.Class as X
import Torch.Types.TH as X (C'THState)

import Torch.Sig.State as Sig
import Torch.Sig.Types as Sig
import Torch.Sig.Types.Global as Sig

import qualified Torch.Types.TH as TH
import qualified Torch.FFI.TH.Long.Storage as LongStorage
import qualified Torch.FFI.TH.Long.Tensor as LongTensor
import qualified Torch.Class.Types as Class
import qualified Torch.Sig.Tensor.Memory as SigTen
import qualified Torch.Sig.Storage.Memory as SigStore

type CPUIndex = TH.LongDynamic
type CPUIndexStorage = TH.LongStorage

-- (stites): This happens often enough that I'm pulling in the blackbird
(.:) :: (b -> c) -> (a0 -> a1 -> b) -> a0 -> a1 -> c
(.:) = (.) . (.)
infixl 5 .:

shuffle2 :: (a -> b -> c -> d) -> c -> a -> b -> d
shuffle2 fn c a b = fn a b c

shuffle3 :: (a -> b -> c -> d -> e) -> d -> a -> b -> c -> e
shuffle3 fn d a b c = fn a b c d

withIx :: Sig.IndexTensor -> (Ptr CIndexTensor -> IO x) -> IO x
withIx ix fn = withForeignPtr (snd $ Sig.longDynamicState ix) fn

withMask :: Sig.MaskTensor -> (Ptr CMaskTensor -> IO x) -> IO x
withMask ix fn = withForeignPtr (snd $ Sig.byteDynamicState ix) fn

mkCPUIx :: Ptr TH.C'THLongTensor -> IO CPUIndex
mkCPUIx p = fmap TH.LongDynamic
  $ (,)
  <$> (TH.newCState >>= TH.manageState)
  <*> newForeignPtr LongTensor.p_free p

withCPUIxStorage :: CPUIndexStorage -> (Ptr TH.C'THLongStorage -> IO x) -> IO x
withCPUIxStorage ix fn = withForeignPtr (snd $ TH.longStorageState ix) fn

mkCPUIxStorage :: Ptr TH.C'THLongStorage -> IO CPUIndexStorage
mkCPUIxStorage p = fmap TH.LongStorage
  $ (,)
  <$> (TH.newCState >>= TH.manageState)
  <*> newForeignPtr LongStorage.p_free p

-- helper function to work with pointer arrays
ptrArray2hs :: (Ptr a -> IO (Ptr Sig.CReal)) -> (Ptr a -> IO Int) -> ForeignPtr a -> IO [Sig.HsReal]
ptrArray2hs updPtrArray toSize fp = do
  sz <- withForeignPtr fp toSize
  creals <- withForeignPtr fp updPtrArray
  (fmap.fmap) Sig.c2hsReal (FM.peekArray sz creals)

-- working with dynamic and storage types:
withState :: Sig.State -> (Ptr Sig.CState ->IO x) -> IO x
withState s = withForeignPtr (Sig.asForeign s)

withDynamicState :: Sig.Dynamic -> (Ptr Sig.CState -> Ptr Sig.CTensor -> IO x) -> IO x
withDynamicState t fn = do
  withForeignPtr (Sig.dynamicStateRef t) $ \sref ->
    withForeignPtr (Sig.ctensor t) $ \tref ->
      fn sref tref

with2DynamicState
  :: Sig.Dynamic
  -> Sig.Dynamic
  -> (Ptr Sig.CState -> Ptr Sig.CTensor -> Ptr Sig.CTensor -> IO x)
  -> IO x
with2DynamicState t0 t1 fn = do
  withDynamicState t0 $ \s' t0' ->
    withForeignPtr (Sig.ctensor t1) $ \t1' ->
      fn s' t0' t1'

with3DynamicState
  :: Sig.Dynamic
  -> Sig.Dynamic
  -> Sig.Dynamic
  -> (Ptr Sig.CState -> Ptr Sig.CTensor -> Ptr Sig.CTensor -> Ptr Sig.CTensor -> IO x)
  -> IO x
with3DynamicState t0 t1 t2 fn = do
  with2DynamicState t0 t1 $ \s' t0' t1' ->
    withForeignPtr (Sig.ctensor t2) $ \t2' ->
      fn s' t0' t1' t2'

mkDynamic :: Ptr Sig.CState -> Ptr Sig.CTensor -> IO Sig.Dynamic
mkDynamic s t = Sig.dynamic
  <$> Sig.manageState s
  <*> newForeignPtrEnv SigTen.p_free s t

mkDynamicIO :: (Ptr Sig.CState -> IO (Ptr Sig.CTensor)) -> IO Sig.Dynamic
mkDynamicIO builder = Sig.newCState >>= \s ->
  builder s >>= mkDynamic s

withStorageState :: Sig.Storage -> (Ptr Sig.CState -> Ptr Sig.CStorage -> IO x) -> IO x
withStorageState t fn = do
  withForeignPtr (Sig.storageStateRef t) $ \sref ->
    withForeignPtr (Sig.cstorage t) $ \tref ->
      fn sref tref

mkStorage :: Ptr Sig.CState -> Ptr Sig.CStorage -> IO Sig.Storage
mkStorage s t = Sig.storage
  <$> Sig.manageState s
  <*> newForeignPtrEnv SigStore.p_free s t

mkStorageIO :: (Ptr Sig.CState -> IO (Ptr Sig.CStorage)) -> IO Sig.Storage
mkStorageIO builder = Sig.newCState >>= \s ->
  builder s >>= mkStorage s

withDynamicStateAndStorage :: Sig.Dynamic -> Sig.Storage -> (Ptr Sig.CState -> Ptr Sig.CTensor -> Ptr Sig.CStorage -> IO x) -> IO x
withDynamicStateAndStorage t s fn =
  withDynamicState t $ \state' t' ->
    withForeignPtr (Sig.cstorage s) (fn state' t')

-------------------------------------------------------------------------------
-- Storage type family instances

type instance Class.Allocator    Sig.Storage = Sig.Allocator
type instance Class.Generator    Sig.Storage = Sig.Generator
type instance Class.DescBuff     Sig.Storage = Sig.DescBuff

type instance Class.HsReal       Sig.Storage = Sig.HsReal
type instance Class.HsAccReal    Sig.Storage = Sig.HsAccReal

-------------------------------------------------------------------------------
-- Dynamic type family instances

type instance Class.AsDynamic    Sig.Dynamic = Sig.Dynamic
type instance Class.HsStorage    Sig.Dynamic = Sig.Storage
type instance Class.IndexTensor  Sig.Dynamic = Sig.IndexTensor
type instance Class.IndexStorage Sig.Dynamic = Sig.IndexStorage
type instance Class.MaskTensor   Sig.Dynamic = Sig.MaskTensor
type instance Class.StridesStorage Sig.Dynamic = TH.IndexStorage
type instance Class.SizesStorage   Sig.Dynamic = TH.IndexStorage

type instance Class.Allocator    Sig.Dynamic = Sig.Allocator
type instance Class.Generator    Sig.Dynamic = Sig.Generator
type instance Class.DescBuff     Sig.Dynamic = Sig.DescBuff

type instance Class.HsReal       Sig.Dynamic = Sig.HsReal
type instance Class.HsAccReal    Sig.Dynamic = Sig.HsAccReal


-------------------------------------------------------------------------------
-- Static type family instances

type instance Class.AsDynamic    (Sig.Tensor d) = Sig.Dynamic
type instance Class.HsStorage    (Sig.Tensor d) = Sig.Storage

type instance Class.IndexTensor  (Sig.Tensor d) = Sig.IndexTensor
type instance Class.IndexStorage (Sig.Tensor d) = Sig.IndexStorage
type instance Class.MaskTensor   (Sig.Tensor d) = Sig.MaskTensor
type instance Class.StridesStorage (Sig.Tensor d) = TH.IndexStorage
type instance Class.SizesStorage   (Sig.Tensor d) = TH.IndexStorage

type instance Class.Allocator    (Sig.Tensor d) = Sig.Allocator
type instance Class.Generator    (Sig.Tensor d) = Sig.Generator
type instance Class.DescBuff     (Sig.Tensor d) = Sig.DescBuff

type instance Class.HsReal       (Sig.Tensor d) = Sig.HsReal
type instance Class.HsAccReal    (Sig.Tensor d) = Sig.HsAccReal

instance Class.IsStatic (Sig.Tensor d) where
  asDynamic = Sig.asDynamic
  asStatic = Sig.asStatic
