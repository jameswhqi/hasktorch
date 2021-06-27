{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE PartialTypeSignatures #-}
{-# LANGUAGE PatternSynonyms #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE StandaloneKindSignatures #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE NoStarIsType #-}
{-# OPTIONS_GHC -fplugin TypeLevel.Rewrite
                -fplugin-opt=TypeLevel.Rewrite:Torch.GraduallyTyped.Unify.UnifyRightAssociativeL
                -fplugin-opt=TypeLevel.Rewrite:Torch.GraduallyTyped.Unify.UnifyIdempotenceL2
                -fplugin-opt=TypeLevel.Rewrite:Torch.GraduallyTyped.Unify.UnifyIdempotenceL2C
                -fplugin-opt=TypeLevel.Rewrite:Torch.GraduallyTyped.Unify.UnifyIdempotenceL3
                -fplugin-opt=TypeLevel.Rewrite:Torch.GraduallyTyped.Unify.UnifyIdempotenceL3C
                -fplugin-opt=TypeLevel.Rewrite:Torch.GraduallyTyped.Unify.UnifyIdempotenceL4
                -fplugin-opt=TypeLevel.Rewrite:Torch.GraduallyTyped.Unify.UnifyIdempotenceL4C
                -fplugin-opt=TypeLevel.Rewrite:Torch.GraduallyTyped.Unify.UnifyIdempotenceL5
                -fplugin-opt=TypeLevel.Rewrite:Torch.GraduallyTyped.Unify.UnifyIdempotenceL5C
                -fplugin-opt=TypeLevel.Rewrite:Torch.GraduallyTyped.Unify.UnifyIdempotenceL6
                -fplugin-opt=TypeLevel.Rewrite:Torch.GraduallyTyped.Unify.UnifyIdempotenceL6C
                -fplugin-opt=TypeLevel.Rewrite:Torch.GraduallyTyped.Unify.UnifyIdempotenceL7
                -fplugin-opt=TypeLevel.Rewrite:Torch.GraduallyTyped.Unify.UnifyIdempotenceL7C
                -fplugin-opt=TypeLevel.Rewrite:Torch.GraduallyTyped.Unify.UnifyIdempotenceL8
                -fplugin-opt=TypeLevel.Rewrite:Torch.GraduallyTyped.Unify.UnifyIdempotenceL8C #-}
{-# OPTIONS_GHC -v2 -Wall #-}

module Torch.GraduallyTyped.NN.Transformer.CrossAttention where

import Control.Monad.Indexed (ireturn, (>>>=))
import Control.Monad.Indexed.State (IxState (..))
import Control.Monad.Reader (MonadIO, MonadReader)
import Control.Monad.State.Strict (MonadState (state), runState)
import Data.Kind (Type)
import Data.Singletons (SingI, sing)
import Data.Singletons.Prelude.List (SList (SNil))
import GHC.TypeLits (Nat, Symbol)
import Torch.DType (DType (..))
import Torch.GraduallyTyped.DType (DataType, KnownDataType, SDataType)
import Torch.GraduallyTyped.Device (Device (..), DeviceType (..), KnownDevice, SDevice)
import Torch.GraduallyTyped.Layout (Layout (Layout), LayoutType (Dense))
import Torch.GraduallyTyped.NN.Class (HasForward (..), HasInitialize (..))
import Torch.GraduallyTyped.NN.Dropout (Dropout)
import Torch.GraduallyTyped.NN.Functional.Normalization (LayerNormWithBiasF, LayerNormWithoutBiasF)
import Torch.GraduallyTyped.NN.Normalization (LayerNorm (..))
import Torch.GraduallyTyped.NN.Transformer.MultiHeadAttention (MultiHeadAttention, lookupMultiHeadAttention)
import Torch.GraduallyTyped.NN.Transformer.Type (STransformerStyle (..), TensorDict, TransformerStyle (..), lookupTensor)
import Torch.GraduallyTyped.NN.Type (HasBias (..))
import Torch.GraduallyTyped.Random (Generator)
import Torch.GraduallyTyped.RequiresGradient (RequiresGradient (..))
import Torch.GraduallyTyped.Scalar (Scalar)
import Torch.GraduallyTyped.Shape.Class (BroadcastShapesF)
import Torch.GraduallyTyped.Shape.Type (Dim (..), KnownDim, Name (..), SDim, SShape (..), Shape (..), Size (..), pattern (:|:))
import Torch.GraduallyTyped.Tensor.MathOperations.Pointwise (add)
import Torch.GraduallyTyped.Tensor.Type (Tensor, SGetDim, SGetShape)
import Torch.GraduallyTyped.Unify (type (<+>))

-- | Generic cross-attention layer.
-- Needs to be specialized to a given transformer type, e.g. 'T5'.
-- See 'CrossAttention'.
data
  GCrossAttention
    (mha :: Type)
    (layerNorm :: Type)
    (dropout :: Type)
  where
  GCrossAttention ::
    forall mha layerNorm dropout.
    { -- | cross-attention
      caMultiheadAttention :: mha,
      -- | layer norm
      caLayerNorm :: layerNorm,
      -- | dropout
      caDropout :: dropout
    } ->
    GCrossAttention mha layerNorm dropout

-- | Cross-attention layer.
newtype
  CrossAttention
    (style :: TransformerStyle)
    (device :: Device (DeviceType Nat))
    (dataType :: DataType DType)
    (headDim :: Dim (Name Symbol) (Size Nat))
    (headEmbedDim :: Dim (Name Symbol) (Size Nat))
    (embedDim :: Dim (Name Symbol) (Size Nat))
    (queryEmbedDim :: Dim (Name Symbol) (Size Nat))
    (keyEmbedDim :: Dim (Name Symbol) (Size Nat))
    (dropoutP :: Type)
  where
  CrossAttention ::
    forall style device dataType headDim headEmbedDim embedDim queryEmbedDim keyEmbedDim dropoutP.
    GCrossAttentionF style device dataType headDim headEmbedDim embedDim queryEmbedDim keyEmbedDim dropoutP ->
    CrossAttention style device dataType headDim headEmbedDim embedDim queryEmbedDim keyEmbedDim dropoutP

type GCrossAttentionF
  (style :: TransformerStyle)
  (device :: Device (DeviceType Nat))
  (dataType :: DataType DType)
  (headDim :: Dim (Name Symbol) (Size Nat))
  (headEmbedDim :: Dim (Name Symbol) (Size Nat))
  (embedDim :: Dim (Name Symbol) (Size Nat))
  (queryEmbedDim :: Dim (Name Symbol) (Size Nat))
  (keyEmbedDim :: Dim (Name Symbol) (Size Nat))
  (dropoutP :: Type) =
  GCrossAttention
    (CAMultiheadAttentionF style device dataType headDim headEmbedDim embedDim queryEmbedDim keyEmbedDim dropoutP)
    (CALayerNormF style device dataType queryEmbedDim)
    (CADropoutF style dropoutP)

type family
  CAMultiheadAttentionF
    (style :: TransformerStyle)
    (device :: Device (DeviceType Nat))
    (dataType :: DataType DType)
    (headDim :: Dim (Name Symbol) (Size Nat))
    (headEmbedDim :: Dim (Name Symbol) (Size Nat))
    (embedDim :: Dim (Name Symbol) (Size Nat))
    (queryEmbedDim :: Dim (Name Symbol) (Size Nat))
    (keyEmbedDim :: Dim (Name Symbol) (Size Nat))
    (dropoutP :: Type) ::
    Type
  where
  CAMultiheadAttentionF style device dataType headDim headEmbedDim embedDim queryEmbedDim keyEmbedDim dropoutP =
    MultiHeadAttention style device dataType headDim headEmbedDim embedDim queryEmbedDim keyEmbedDim keyEmbedDim dropoutP

type family
  CALayerNormF
    (style :: TransformerStyle)
    (device :: Device (DeviceType Nat))
    (dataType :: DataType DType)
    (queryEmbedDim :: Dim (Name Symbol) (Size Nat)) ::
    Type
  where
  CALayerNormF 'T5 device dataType queryEmbedDim =
    LayerNorm 'WithoutBias device dataType ('Shape '[queryEmbedDim])
  CALayerNormF 'Pegasus device dataType queryEmbedDim =
    LayerNorm 'WithBias device dataType ('Shape '[queryEmbedDim])
  CALayerNormF 'BART device dataType queryEmbedDim =
    LayerNorm 'WithBias device dataType ('Shape '[queryEmbedDim])

type family
  CADropoutF
    (style :: TransformerStyle)
    (dropoutP :: Type) ::
    Type
  where
  CADropoutF _ dropoutP =
    Dropout dropoutP

instance
  ( Scalar dropoutP,
    multiHeadAttention ~ CAMultiheadAttentionF style device dataType headDim headEmbedDim embedDim queryEmbedDim keyEmbedDim dropoutP,
    HasInitialize multiHeadAttention,
    layerNorm ~ CALayerNormF style device dataType queryEmbedDim,
    HasInitialize layerNorm,
    InitializeF layerNorm ~ (SDevice device -> SDataType dataType -> SShape ('Shape '[queryEmbedDim]) -> Double -> layerNorm),
    dropout ~ CADropoutF style dropoutP,
    HasInitialize dropout
  ) =>
  HasInitialize (CrossAttention style device dataType headDim headEmbedDim embedDim queryEmbedDim keyEmbedDim dropoutP)
  where
  type
    InitializeF (CrossAttention style device dataType headDim headEmbedDim embedDim queryEmbedDim keyEmbedDim dropoutP) =
      SDevice device ->
      SDataType dataType ->
      SDim headDim ->
      SDim headEmbedDim ->
      SDim embedDim ->
      SDim queryEmbedDim ->
      SDim keyEmbedDim ->
      dropoutP ->
      Double ->
      Generator device ->
      (CrossAttention style device dataType headDim headEmbedDim embedDim queryEmbedDim keyEmbedDim dropoutP, Generator device)
  initialize device dataType headDim headEmbedDim embedDim queryEmbedDim keyEmbedDim dropoutP eps =
    runState $ do
      multiHeadAttention <-
        state $ initialize @multiHeadAttention device dataType headDim headEmbedDim embedDim queryEmbedDim keyEmbedDim keyEmbedDim dropoutP
      let layerNorm = initialize @layerNorm device dataType (SShape $ queryEmbedDim :|: SNil) eps
      let dropout = initialize @dropout dropoutP
      pure . CrossAttention $ GCrossAttention multiHeadAttention layerNorm dropout

lookupCrossAttention ::
  forall style device dataType headDim headEmbedDim embedDim queryEmbedDim keyEmbedDim dropoutP m.
  ( SingI style,
    MonadReader TensorDict m,
    MonadIO m,
    MonadFail m,
    KnownDevice device,
    KnownDataType dataType,
    KnownDim embedDim,
    KnownDim queryEmbedDim,
    KnownDim keyEmbedDim,
    Scalar dropoutP
  ) =>
  SDim headDim ->
  SDim headEmbedDim ->
  SDim embedDim ->
  dropoutP ->
  Double ->
  String ->
  m (CrossAttention style device dataType headDim headEmbedDim embedDim queryEmbedDim keyEmbedDim dropoutP)
lookupCrossAttention headDim headEmbedDim embedDim dropoutP eps prefix =
  let crossAttention ST5 = lookupMultiHeadAttention headDim headEmbedDim embedDim dropoutP (prefix <> "EncDecAttention.")
      crossAttention SPegasus = lookupMultiHeadAttention headDim headEmbedDim embedDim dropoutP (prefix <> "encoder_attn.")
      crossAttention SBART = lookupMultiHeadAttention headDim headEmbedDim embedDim dropoutP (prefix <> "encoder_attn.")
      layerNorm ST5 =
        LayerNormWithoutBias
          <$> lookupTensor (prefix <> "layer_norm.weight")
          <*> pure eps
      layerNorm SPegasus =
        LayerNormWithBias
          <$> lookupTensor (prefix <> "encoder_attn_layer_norm.weight")
          <*> lookupTensor (prefix <> "encoder_attn_layer_norm.bias")
          <*> pure eps
      layerNorm SBART =
        LayerNormWithBias
          <$> lookupTensor (prefix <> "encoder_attn_layer_norm.weight")
          <*> lookupTensor (prefix <> "encoder_attn_layer_norm.bias")
          <*> pure eps
      dropout _ = pure (initialize @(Dropout dropoutP) dropoutP)
   in CrossAttention
        <$> ( GCrossAttention
                <$> crossAttention (sing @style)
                <*> layerNorm (sing @style)
                <*> dropout (sing @style)
            )

-- | 'HasForward' instance for @CrossAttention 'T5@.
--
-- @
--    ┌───────┐  ┌─────┐  ┌───────────────┐
--    │ query │  │ key │  │ attentionBias │
--    └───┬───┘  └──┬──┘  └───────┬───────┘
--        │         │             │
-- ┌──────┤         │             │
-- │      │         │             │
-- │      ▼         │             │
-- │ caLayerNorm    │             │
-- │      │         │             │
-- │      │      ┌──┴──┐          │
-- │      │      │     │          │
-- │      ▼      ▼     ▼          │
-- │   caMultiheadAttention◄──────┘
-- │             │
-- │             ▼
-- │         caDropout
-- │             │
-- └────►add◄────┘
--        │
--        ▼
--    ┌───────┐
--    │ query │
--    └───────┘
-- @
instance
  ( SGetDim queryEmbedDim,
    SGetShape queryShape,
    Scalar dropoutP,
    query ~ Tensor queryRequiresGradient queryLayout queryDevice queryDataType queryShape,
    key ~ Tensor keyRequiresGradient keyLayout keyDevice keyDataType keyShape,
    attentionBias ~ Tensor attentionBiasRequiresGradient attentionBiasLayout attentionBiasDevice attentionBiasDataType attentionBiasShape,
    normedQueryLayout ~ ('Layout 'Dense <+> queryLayout),
    normedQueryDevice ~ (device <+> queryDevice),
    normedQueryDataType ~ (dataType <+> queryDataType),
    normedQueryShape ~ LayerNormWithoutBiasF ('Shape '[queryEmbedDim]) queryShape,
    normedQuery ~ Tensor 'WithGradient normedQueryLayout normedQueryDevice normedQueryDataType normedQueryShape,
    HasForward
      (MultiHeadAttention 'T5 device dataType headDim headEmbedDim embedDim queryEmbedDim keyEmbedDim keyEmbedDim dropoutP)
      ( normedQuery,
        key,
        key,
        attentionBias
      )
      (Generator generatorDevice)
      ( Tensor
          'WithGradient
          (queryLayout <+> 'Layout 'Dense <+> keyLayout <+> attentionBiasLayout)
          (queryDevice <+> device <+> keyDevice <+> attentionBiasDevice <+> generatorDevice)
          (queryDataType <+> dataType <+> keyDataType <+> attentionBiasDataType)
          mhaOutputShape
      )
      (Generator (queryDevice <+> device <+> keyDevice <+> attentionBiasDevice <+> generatorDevice)),
    output
      ~ Tensor
          'WithGradient
          (queryLayout <+> 'Layout 'Dense <+> keyLayout <+> attentionBiasLayout)
          (queryDevice <+> device <+> keyDevice <+> attentionBiasDevice <+> generatorDevice)
          (queryDataType <+> dataType <+> keyDataType <+> attentionBiasDataType)
          (BroadcastShapesF queryShape mhaOutputShape),
    generatorOutput ~ Generator (queryDevice <+> device <+> keyDevice <+> attentionBiasDevice <+> generatorDevice)
  ) =>
  HasForward
    (CrossAttention 'T5 device dataType headDim headEmbedDim embedDim queryEmbedDim keyEmbedDim dropoutP)
    (query, key, attentionBias)
    (Generator generatorDevice)
    output
    generatorOutput
  where
  forward (CrossAttention ca) (query, key, attentionBias) =
    runIxState $
      ireturn query
        >>>= IxState . forward (caLayerNorm ca)
        >>>= (\query' -> IxState $ forward (caMultiheadAttention ca) (query', key, key, attentionBias))
        >>>= IxState . forward (caDropout ca)
        >>>= ireturn . (query `add`)

-- | 'HasForward' instance for @CrossAttenton 'BART@.
--
-- @
--    ┌───────┐  ┌─────┐  ┌───────────────┐
--    │ query │  │ key │  │ attentionBias │
--    └───┬───┘  └──┬──┘  └───────┬───────┘
--        │         │             │
-- ┌──────┤      ┌──┴──┐          │
-- │      │      │     │          │
-- │      ▼      ▼     ▼          │
-- │   caMultiheadAttention◄──────┘
-- │             │
-- │             ▼
-- │         caDropout
-- │             │
-- └────►add◄────┘
--        │
--        ▼
--   caLayerNorm
--        │
--        ▼
--    ┌───────┐
--    │ query │
--    └───────┘
-- @
instance
  ( SGetDim queryEmbedDim,
    Scalar dropoutP,
    query ~ Tensor queryRequiresGradient queryLayout queryDevice queryDataType queryShape,
    key ~ Tensor keyRequiresGradient keyLayout keyDevice keyDataType keyShape,
    attentionBias ~ Tensor attentionBiasRequiresGradient attentionBiasLayout attentionBiasDevice attentionBiasDataType attentionBiasShape,
    HasForward
      (MultiHeadAttention 'BART device dataType headDim headEmbedDim embedDim queryEmbedDim keyEmbedDim keyEmbedDim dropoutP)
      (query, key, key, attentionBias)
      (Generator generatorDevice)
      ( Tensor
          'WithGradient
          ('Layout 'Dense <+> queryLayout <+> keyLayout <+> attentionBiasLayout)
          (device <+> queryDevice <+> keyDevice <+> attentionBiasDevice <+> generatorDevice)
          (dataType <+> queryDataType <+> keyDataType <+> attentionBiasDataType)
          mhaOutputShape
      )
      (Generator (device <+> queryDevice <+> keyDevice <+> attentionBiasDevice <+> generatorDevice)),
    output
      ~ Tensor
          'WithGradient
          ('Layout 'Dense <+> queryLayout <+> keyLayout <+> attentionBiasLayout)
          (device <+> queryDevice <+> keyDevice <+> attentionBiasDevice <+> generatorDevice)
          (dataType <+> queryDataType <+> keyDataType <+> attentionBiasDataType)
          ( LayerNormWithBiasF
              ('Shape '[queryEmbedDim])
              ('Shape '[queryEmbedDim])
              (BroadcastShapesF queryShape mhaOutputShape)
          ),
    generatorOutput ~ Generator (device <+> queryDevice <+> keyDevice <+> attentionBiasDevice <+> generatorDevice)
  ) =>
  HasForward
    (CrossAttention 'BART device dataType headDim headEmbedDim embedDim queryEmbedDim keyEmbedDim dropoutP)
    (query, key, attentionBias)
    (Generator generatorDevice)
    output
    generatorOutput
  where
  forward (CrossAttention ca) (query, key, attentionBias) =
    runIxState $
      ireturn query
        >>>= (\query' -> IxState $ forward (caMultiheadAttention ca) (query', key, key, attentionBias))
        >>>= IxState . forward (caDropout ca)
        >>>= ireturn . (query `add`)
        >>>= IxState . forward (caLayerNorm ca)

-- | 'HasForward' instance for @CrossAttention 'Pegasus@.
--
-- @
--    ┌───────┐  ┌─────┐  ┌───────────────┐
--    │ query │  │ key │  │ attentionBias │
--    └───┬───┘  └──┬──┘  └───────┬───────┘
--        │         │             │
-- ┌──────┤         │             │
-- │      │         │             │
-- │      ▼         │             │
-- │ caLayerNorm    │             │
-- │      │         │             │
-- │      │      ┌──┴──┐          │
-- │      │      │     │          │
-- │      ▼      ▼     ▼          │
-- │   caMultiheadAttention◄──────┘
-- │             │
-- │             ▼
-- │         caDropout
-- │             │
-- └────►add◄────┘
--        │
--        ▼
--    ┌───────┐
--    │ query │
--    └───────┘
-- @
instance
  ( SGetDim queryEmbedDim,
    Scalar dropoutP,
    query ~ Tensor queryRequiresGradient queryLayout queryDevice queryDataType queryShape,
    key ~ Tensor keyRequiresGradient keyLayout keyDevice keyDataType keyShape,
    attentionBias ~ Tensor attentionBiasRequiresGradient attentionBiasLayout attentionBiasDevice attentionBiasDataType attentionBiasShape,
    normedQueryLayout ~ ('Layout 'Dense <+> queryLayout),
    normedQueryDevice ~ (device <+> queryDevice),
    normedQueryDataType ~ (dataType <+> queryDataType),
    normedQueryShape ~ LayerNormWithBiasF ('Shape '[queryEmbedDim]) ('Shape '[queryEmbedDim]) queryShape,
    normedQuery ~ Tensor 'WithGradient normedQueryLayout normedQueryDevice normedQueryDataType normedQueryShape,
    HasForward
      (MultiHeadAttention 'Pegasus device dataType headDim headEmbedDim embedDim queryEmbedDim keyEmbedDim keyEmbedDim dropoutP)
      ( normedQuery,
        key,
        key,
        attentionBias
      )
      (Generator generatorDevice)
      ( Tensor
          'WithGradient
          (queryLayout <+> 'Layout 'Dense <+> keyLayout <+> attentionBiasLayout)
          (queryDevice <+> device <+> keyDevice <+> attentionBiasDevice <+> generatorDevice)
          (queryDataType <+> dataType <+> keyDataType <+> attentionBiasDataType)
          mhaOutputShape
      )
      (Generator (queryDevice <+> device <+> keyDevice <+> attentionBiasDevice <+> generatorDevice)),
    output
      ~ Tensor
          'WithGradient
          (queryLayout <+> 'Layout 'Dense <+> keyLayout <+> attentionBiasLayout)
          (queryDevice <+> device <+> keyDevice <+> attentionBiasDevice <+> generatorDevice)
          (queryDataType <+> dataType <+> keyDataType <+> attentionBiasDataType)
          (BroadcastShapesF queryShape mhaOutputShape),
    generatorOutput ~ Generator (queryDevice <+> device <+> keyDevice <+> attentionBiasDevice <+> generatorDevice)
  ) =>
  HasForward
    (CrossAttention 'Pegasus device dataType headDim headEmbedDim embedDim queryEmbedDim keyEmbedDim dropoutP)
    (query, key, attentionBias)
    (Generator generatorDevice)
    output
    generatorOutput
  where
  forward (CrossAttention ca) (query, key, attentionBias) =
    runIxState $
      ireturn query
        >>>= IxState . forward (caLayerNorm ca)
        >>>= (\query' -> IxState $ forward (caMultiheadAttention ca) (query', key, key, attentionBias))
        >>>= IxState . forward (caDropout ca)
        >>>= ireturn . (query `add`)
