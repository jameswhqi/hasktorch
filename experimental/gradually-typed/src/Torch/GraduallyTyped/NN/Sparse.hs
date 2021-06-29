{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE PatternSynonyms #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE UndecidableInstances #-}
{-# OPTIONS_GHC -Wall #-}

module Torch.GraduallyTyped.NN.Sparse where

import Control.Monad.Indexed (IxPointed (ireturn), (>>>=))
import Control.Monad.Indexed.State (IxState (..))
import Data.Data (Proxy (..))
import Data.Singletons.Prelude.List (SList (..))
import GHC.TypeLits (KnownNat, Nat, Symbol, natVal)
import Torch.DType (DType (..))
import Torch.GraduallyTyped.DType (DataType (..), SDataType (..))
import Torch.GraduallyTyped.Device (Device (..), DeviceType, SDevice (..))
import Torch.GraduallyTyped.Layout (Layout (..), LayoutType (..), SLayout (..))
import Torch.GraduallyTyped.NN.Class (HasForward (..), HasInitialize (..))
import Torch.GraduallyTyped.NN.Functional.Sparse (EmbeddingF, embedding)
import Torch.GraduallyTyped.Prelude (Seq)
import Torch.GraduallyTyped.Random (Generator)
import Torch.GraduallyTyped.RequiresGradient (RequiresGradient (..), SRequiresGradient (..))
import Torch.GraduallyTyped.Shape (Dim (..), Name, SDim (..), SShape (..), Shape (..), Size, pattern (:|:))
import Torch.GraduallyTyped.Tensor.Creation (sRandn)
import Torch.GraduallyTyped.Tensor.Type (SGetLayout, Tensor)
import Torch.GraduallyTyped.Unify (type (<+>))

data
  Embedding
    (layout :: Layout LayoutType)
    (device :: Device (DeviceType Nat))
    (dataType :: DataType DType)
    (embedNumDim :: Dim (Name Symbol) (Size Nat))
    (embedDim :: Dim (Name Symbol) (Size Nat))
    (paddingIdx :: Maybe Nat)
  where
  Embedding ::
    forall layout device dataType embedNumDim embedDim paddingIdx.
    { embeddingWeight :: Tensor 'WithGradient layout device dataType ('Shape '[embedNumDim, embedDim])
    } ->
    Embedding layout device dataType embedNumDim embedDim paddingIdx

instance
  (device'' ~ (device <+> device')) =>
  HasInitialize
    (Embedding layout device dataType embedNumDim embedDim 'Nothing)
    ( SLayout layout,
      SDevice device,
      SDataType dataType,
      SDim embedNumDim,
      SDim embedDim
    )
    (Generator device')
    (Generator device'')
  where
  initialize (layout, device, dataType, embedNumDim, embedDim) =
    runIxState $
      IxState (sRandn SWithGradient layout device dataType (SShape $ embedNumDim :|: embedDim :|: SNil))
        >>>= ireturn . Embedding

-- TODO: padding embedding vector may need to be set to zeros
instance
  (device'' ~ (device <+> device')) =>
  HasInitialize
    (Embedding layout device dataType embedNumDim embedDim ('Just paddingIdx))
    ( SLayout layout,
      SDevice device,
      SDataType dataType,
      SDim embedNumDim,
      SDim embedDim
    )
    (Generator device')
    (Generator device'')
  where
  initialize (layout, device, dataType, embedNumDim, embedDim) =
    runIxState $
      IxState (sRandn SWithGradient layout device dataType (SShape $ embedNumDim :|: embedDim :|: SNil))
        >>>= ireturn . Embedding

instance
  ( SGetLayout layout,
    output
      ~ Tensor
          'WithGradient
          (layout <+> layout')
          (device <+> device')
          (Seq (dataType' <+> 'DataType 'Int64) dataType)
          (EmbeddingF ('Shape '[embedNumDim, embedDim]) shape')
  ) =>
  HasForward
    (Embedding layout device dataType embedNumDim embedDim 'Nothing)
    (Tensor requiresGradient' layout' device' dataType' shape')
    generator
    output
    generator
  where
  forward (Embedding weight) input g = (embedding Nothing False weight input, g)

instance
  ( SGetLayout layout,
    KnownNat paddingIdx,
    output
      ~ Tensor
          'WithGradient
          (layout <+> layout')
          (device <+> device')
          (Seq (dataType' <+> 'DataType 'Int64) dataType)
          (EmbeddingF ('Shape '[embedNumDim, embedDim]) shape')
  ) =>
  HasForward
    (Embedding layout device dataType embedNumDim embedDim ('Just paddingIdx))
    (Tensor requiresGradient' layout' device' dataType' shape')
    generator
    output
    generator
  where
  forward Embedding {..} input g = (embedding (Just . fromIntegral . natVal $ Proxy @paddingIdx) False embeddingWeight input, g)
