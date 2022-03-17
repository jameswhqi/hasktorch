
-- generated by using spec/Declarations.yaml

{-# LANGUAGE DataKinds #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}

module Torch.Internal.Managed.Native.Native15 where


import Foreign.C.String
import Foreign.C.Types
import Foreign
import Torch.Internal.Type
import Torch.Internal.Class
import Torch.Internal.Cast
import Torch.Internal.Objects
import qualified Torch.Internal.Unmanaged.Native.Native15 as Unmanaged


_det_lu_based_helper_t
  :: ForeignPtr Tensor
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor,Tensor)))
_det_lu_based_helper_t = cast1 Unmanaged._det_lu_based_helper_t

_det_lu_based_helper_backward_helper_ttttt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
_det_lu_based_helper_backward_helper_ttttt = cast5 Unmanaged._det_lu_based_helper_backward_helper_ttttt

linalg_lstsq_ttds
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> CDouble
  -> ForeignPtr StdString
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor,Tensor,Tensor)))
linalg_lstsq_ttds = cast4 Unmanaged.linalg_lstsq_ttds

linalg_lstsq_ttd
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> CDouble
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor,Tensor,Tensor)))
linalg_lstsq_ttd = cast3 Unmanaged.linalg_lstsq_ttd

linalg_lstsq_tt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor,Tensor,Tensor)))
linalg_lstsq_tt = cast2 Unmanaged.linalg_lstsq_tt

linalg_lstsq_out_ttttttds
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> CDouble
  -> ForeignPtr StdString
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor,Tensor,Tensor)))
linalg_lstsq_out_ttttttds = cast8 Unmanaged.linalg_lstsq_out_ttttttds

linalg_lstsq_out_ttttttd
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> CDouble
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor,Tensor,Tensor)))
linalg_lstsq_out_ttttttd = cast7 Unmanaged.linalg_lstsq_out_ttttttd

linalg_lstsq_out_tttttt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor,Tensor,Tensor)))
linalg_lstsq_out_tttttt = cast6 Unmanaged.linalg_lstsq_out_tttttt

linalg_matmul_tt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_matmul_tt = cast2 Unmanaged.linalg_matmul_tt

linalg_matmul_out_ttt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_matmul_out_ttt = cast3 Unmanaged.linalg_matmul_out_ttt

linalg_matrix_exp_t
  :: ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_matrix_exp_t = cast1 Unmanaged.linalg_matrix_exp_t

linalg_slogdet_t
  :: ForeignPtr Tensor
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor)))
linalg_slogdet_t = cast1 Unmanaged.linalg_slogdet_t

linalg_slogdet_out_ttt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor)))
linalg_slogdet_out_ttt = cast3 Unmanaged.linalg_slogdet_out_ttt

linalg_eig_t
  :: ForeignPtr Tensor
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor)))
linalg_eig_t = cast1 Unmanaged.linalg_eig_t

linalg_eig_out_ttt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor)))
linalg_eig_out_ttt = cast3 Unmanaged.linalg_eig_out_ttt

linalg_eigvals_t
  :: ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_eigvals_t = cast1 Unmanaged.linalg_eigvals_t

linalg_eigvals_out_tt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_eigvals_out_tt = cast2 Unmanaged.linalg_eigvals_out_tt

linalg_eigh_ts
  :: ForeignPtr Tensor
  -> ForeignPtr StdString
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor)))
linalg_eigh_ts = cast2 Unmanaged.linalg_eigh_ts

linalg_eigh_t
  :: ForeignPtr Tensor
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor)))
linalg_eigh_t = cast1 Unmanaged.linalg_eigh_t

linalg_eigh_out_ttts
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr StdString
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor)))
linalg_eigh_out_ttts = cast4 Unmanaged.linalg_eigh_out_ttts

linalg_eigh_out_ttt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor)))
linalg_eigh_out_ttt = cast3 Unmanaged.linalg_eigh_out_ttt

linalg_eigvalsh_ts
  :: ForeignPtr Tensor
  -> ForeignPtr StdString
  -> IO (ForeignPtr Tensor)
linalg_eigvalsh_ts = cast2 Unmanaged.linalg_eigvalsh_ts

linalg_eigvalsh_t
  :: ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_eigvalsh_t = cast1 Unmanaged.linalg_eigvalsh_t

linalg_eigvalsh_out_tts
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr StdString
  -> IO (ForeignPtr Tensor)
linalg_eigvalsh_out_tts = cast3 Unmanaged.linalg_eigvalsh_out_tts

linalg_eigvalsh_out_tt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_eigvalsh_out_tt = cast2 Unmanaged.linalg_eigvalsh_out_tt

linalg_householder_product_tt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_householder_product_tt = cast2 Unmanaged.linalg_householder_product_tt

linalg_householder_product_out_ttt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_householder_product_out_ttt = cast3 Unmanaged.linalg_householder_product_out_ttt

_linalg_inv_out_helper__ttt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
_linalg_inv_out_helper__ttt = cast3 Unmanaged._linalg_inv_out_helper__ttt

linalg_inv_ex_tb
  :: ForeignPtr Tensor
  -> CBool
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor)))
linalg_inv_ex_tb = cast2 Unmanaged.linalg_inv_ex_tb

linalg_inv_ex_t
  :: ForeignPtr Tensor
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor)))
linalg_inv_ex_t = cast1 Unmanaged.linalg_inv_ex_t

linalg_inv_ex_out_tttb
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> CBool
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor)))
linalg_inv_ex_out_tttb = cast4 Unmanaged.linalg_inv_ex_out_tttb

linalg_inv_ex_out_ttt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor)))
linalg_inv_ex_out_ttt = cast3 Unmanaged.linalg_inv_ex_out_ttt

linalg_inv_t
  :: ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_inv_t = cast1 Unmanaged.linalg_inv_t

linalg_inv_out_tt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_inv_out_tt = cast2 Unmanaged.linalg_inv_out_tt

inner_tt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
inner_tt = cast2 Unmanaged.inner_tt

inner_out_ttt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
inner_out_ttt = cast3 Unmanaged.inner_out_ttt

outer_tt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
outer_tt = cast2 Unmanaged.outer_tt

outer_out_ttt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
outer_out_ttt = cast3 Unmanaged.outer_out_ttt

ger_tt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
ger_tt = cast2 Unmanaged.ger_tt

ger_out_ttt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
ger_out_ttt = cast3 Unmanaged.ger_out_ttt

linalg_norm_tslbs
  :: ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> ForeignPtr IntArray
  -> CBool
  -> ScalarType
  -> IO (ForeignPtr Tensor)
linalg_norm_tslbs = cast5 Unmanaged.linalg_norm_tslbs

linalg_norm_tslb
  :: ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> ForeignPtr IntArray
  -> CBool
  -> IO (ForeignPtr Tensor)
linalg_norm_tslb = cast4 Unmanaged.linalg_norm_tslb

linalg_norm_tsl
  :: ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> ForeignPtr IntArray
  -> IO (ForeignPtr Tensor)
linalg_norm_tsl = cast3 Unmanaged.linalg_norm_tsl

linalg_norm_ts
  :: ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> IO (ForeignPtr Tensor)
linalg_norm_ts = cast2 Unmanaged.linalg_norm_ts

linalg_norm_t
  :: ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_norm_t = cast1 Unmanaged.linalg_norm_t

linalg_norm_out_ttslbs
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> ForeignPtr IntArray
  -> CBool
  -> ScalarType
  -> IO (ForeignPtr Tensor)
linalg_norm_out_ttslbs = cast6 Unmanaged.linalg_norm_out_ttslbs

linalg_norm_out_ttslb
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> ForeignPtr IntArray
  -> CBool
  -> IO (ForeignPtr Tensor)
linalg_norm_out_ttslb = cast5 Unmanaged.linalg_norm_out_ttslb

linalg_norm_out_ttsl
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> ForeignPtr IntArray
  -> IO (ForeignPtr Tensor)
linalg_norm_out_ttsl = cast4 Unmanaged.linalg_norm_out_ttsl

linalg_norm_out_tts
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> IO (ForeignPtr Tensor)
linalg_norm_out_tts = cast3 Unmanaged.linalg_norm_out_tts

linalg_norm_out_tt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_norm_out_tt = cast2 Unmanaged.linalg_norm_out_tt

linalg_vector_norm_tslbs
  :: ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> ForeignPtr IntArray
  -> CBool
  -> ScalarType
  -> IO (ForeignPtr Tensor)
linalg_vector_norm_tslbs = cast5 Unmanaged.linalg_vector_norm_tslbs

linalg_vector_norm_tslb
  :: ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> ForeignPtr IntArray
  -> CBool
  -> IO (ForeignPtr Tensor)
linalg_vector_norm_tslb = cast4 Unmanaged.linalg_vector_norm_tslb

linalg_vector_norm_tsl
  :: ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> ForeignPtr IntArray
  -> IO (ForeignPtr Tensor)
linalg_vector_norm_tsl = cast3 Unmanaged.linalg_vector_norm_tsl

linalg_vector_norm_ts
  :: ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> IO (ForeignPtr Tensor)
linalg_vector_norm_ts = cast2 Unmanaged.linalg_vector_norm_ts

linalg_vector_norm_t
  :: ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_vector_norm_t = cast1 Unmanaged.linalg_vector_norm_t

linalg_vector_norm_out_ttslbs
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> ForeignPtr IntArray
  -> CBool
  -> ScalarType
  -> IO (ForeignPtr Tensor)
linalg_vector_norm_out_ttslbs = cast6 Unmanaged.linalg_vector_norm_out_ttslbs

linalg_vector_norm_out_ttslb
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> ForeignPtr IntArray
  -> CBool
  -> IO (ForeignPtr Tensor)
linalg_vector_norm_out_ttslb = cast5 Unmanaged.linalg_vector_norm_out_ttslb

linalg_vector_norm_out_ttsl
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> ForeignPtr IntArray
  -> IO (ForeignPtr Tensor)
linalg_vector_norm_out_ttsl = cast4 Unmanaged.linalg_vector_norm_out_ttsl

linalg_vector_norm_out_tts
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> IO (ForeignPtr Tensor)
linalg_vector_norm_out_tts = cast3 Unmanaged.linalg_vector_norm_out_tts

linalg_vector_norm_out_tt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_vector_norm_out_tt = cast2 Unmanaged.linalg_vector_norm_out_tt

linalg_matrix_norm_tslbs
  :: ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> ForeignPtr IntArray
  -> CBool
  -> ScalarType
  -> IO (ForeignPtr Tensor)
linalg_matrix_norm_tslbs = cast5 Unmanaged.linalg_matrix_norm_tslbs

linalg_matrix_norm_tslb
  :: ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> ForeignPtr IntArray
  -> CBool
  -> IO (ForeignPtr Tensor)
linalg_matrix_norm_tslb = cast4 Unmanaged.linalg_matrix_norm_tslb

linalg_matrix_norm_tsl
  :: ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> ForeignPtr IntArray
  -> IO (ForeignPtr Tensor)
linalg_matrix_norm_tsl = cast3 Unmanaged.linalg_matrix_norm_tsl

linalg_matrix_norm_ts
  :: ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> IO (ForeignPtr Tensor)
linalg_matrix_norm_ts = cast2 Unmanaged.linalg_matrix_norm_ts

linalg_matrix_norm_out_ttslbs
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> ForeignPtr IntArray
  -> CBool
  -> ScalarType
  -> IO (ForeignPtr Tensor)
linalg_matrix_norm_out_ttslbs = cast6 Unmanaged.linalg_matrix_norm_out_ttslbs

linalg_matrix_norm_out_ttslb
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> ForeignPtr IntArray
  -> CBool
  -> IO (ForeignPtr Tensor)
linalg_matrix_norm_out_ttslb = cast5 Unmanaged.linalg_matrix_norm_out_ttslb

linalg_matrix_norm_out_ttsl
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> ForeignPtr IntArray
  -> IO (ForeignPtr Tensor)
linalg_matrix_norm_out_ttsl = cast4 Unmanaged.linalg_matrix_norm_out_ttsl

linalg_matrix_norm_out_tts
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> IO (ForeignPtr Tensor)
linalg_matrix_norm_out_tts = cast3 Unmanaged.linalg_matrix_norm_out_tts

linalg_matrix_norm_t
  :: ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_matrix_norm_t = cast1 Unmanaged.linalg_matrix_norm_t

linalg_matrix_norm_out_tt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_matrix_norm_out_tt = cast2 Unmanaged.linalg_matrix_norm_out_tt

_linalg_svd_tbb
  :: ForeignPtr Tensor
  -> CBool
  -> CBool
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor,Tensor)))
_linalg_svd_tbb = cast3 Unmanaged._linalg_svd_tbb

_linalg_svd_tb
  :: ForeignPtr Tensor
  -> CBool
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor,Tensor)))
_linalg_svd_tb = cast2 Unmanaged._linalg_svd_tb

_linalg_svd_t
  :: ForeignPtr Tensor
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor,Tensor)))
_linalg_svd_t = cast1 Unmanaged._linalg_svd_t

_linalg_svd_out_ttttbb
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> CBool
  -> CBool
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor,Tensor)))
_linalg_svd_out_ttttbb = cast6 Unmanaged._linalg_svd_out_ttttbb

_linalg_svd_out_ttttb
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> CBool
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor,Tensor)))
_linalg_svd_out_ttttb = cast5 Unmanaged._linalg_svd_out_ttttb

_linalg_svd_out_tttt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor,Tensor)))
_linalg_svd_out_tttt = cast4 Unmanaged._linalg_svd_out_tttt

linalg_svd_tb
  :: ForeignPtr Tensor
  -> CBool
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor,Tensor)))
linalg_svd_tb = cast2 Unmanaged.linalg_svd_tb

linalg_svd_t
  :: ForeignPtr Tensor
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor,Tensor)))
linalg_svd_t = cast1 Unmanaged.linalg_svd_t

linalg_svd_out_ttttb
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> CBool
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor,Tensor)))
linalg_svd_out_ttttb = cast5 Unmanaged.linalg_svd_out_ttttb

linalg_svd_out_tttt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor,Tensor)))
linalg_svd_out_tttt = cast4 Unmanaged.linalg_svd_out_tttt

linalg_svdvals_t
  :: ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_svdvals_t = cast1 Unmanaged.linalg_svdvals_t

linalg_svdvals_out_tt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_svdvals_out_tt = cast2 Unmanaged.linalg_svdvals_out_tt

linalg_cond_ts
  :: ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> IO (ForeignPtr Tensor)
linalg_cond_ts = cast2 Unmanaged.linalg_cond_ts

linalg_cond_t
  :: ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_cond_t = cast1 Unmanaged.linalg_cond_t

linalg_cond_out_tts
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> IO (ForeignPtr Tensor)
linalg_cond_out_tts = cast3 Unmanaged.linalg_cond_out_tts

linalg_cond_out_tt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_cond_out_tt = cast2 Unmanaged.linalg_cond_out_tt

linalg_pinv_tttb
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> CBool
  -> IO (ForeignPtr Tensor)
linalg_pinv_tttb = cast4 Unmanaged.linalg_pinv_tttb

linalg_pinv_ttt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_pinv_ttt = cast3 Unmanaged.linalg_pinv_ttt

linalg_pinv_tt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_pinv_tt = cast2 Unmanaged.linalg_pinv_tt

linalg_pinv_t
  :: ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_pinv_t = cast1 Unmanaged.linalg_pinv_t

linalg_pinv_out_ttttb
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> CBool
  -> IO (ForeignPtr Tensor)
linalg_pinv_out_ttttb = cast5 Unmanaged.linalg_pinv_out_ttttb

linalg_pinv_out_tttt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_pinv_out_tttt = cast4 Unmanaged.linalg_pinv_out_tttt

linalg_pinv_out_ttt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_pinv_out_ttt = cast3 Unmanaged.linalg_pinv_out_ttt

linalg_pinv_out_tt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_pinv_out_tt = cast2 Unmanaged.linalg_pinv_out_tt

linalg_pinv_tddb
  :: ForeignPtr Tensor
  -> CDouble
  -> CDouble
  -> CBool
  -> IO (ForeignPtr Tensor)
linalg_pinv_tddb = cast4 Unmanaged.linalg_pinv_tddb

linalg_pinv_tdd
  :: ForeignPtr Tensor
  -> CDouble
  -> CDouble
  -> IO (ForeignPtr Tensor)
linalg_pinv_tdd = cast3 Unmanaged.linalg_pinv_tdd

linalg_pinv_td
  :: ForeignPtr Tensor
  -> CDouble
  -> IO (ForeignPtr Tensor)
linalg_pinv_td = cast2 Unmanaged.linalg_pinv_td

linalg_pinv_out_ttddb
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> CDouble
  -> CDouble
  -> CBool
  -> IO (ForeignPtr Tensor)
linalg_pinv_out_ttddb = cast5 Unmanaged.linalg_pinv_out_ttddb

linalg_pinv_out_ttdd
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> CDouble
  -> CDouble
  -> IO (ForeignPtr Tensor)
linalg_pinv_out_ttdd = cast4 Unmanaged.linalg_pinv_out_ttdd

linalg_pinv_out_ttd
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> CDouble
  -> IO (ForeignPtr Tensor)
linalg_pinv_out_ttd = cast3 Unmanaged.linalg_pinv_out_ttd

linalg_pinv_tdb
  :: ForeignPtr Tensor
  -> CDouble
  -> CBool
  -> IO (ForeignPtr Tensor)
linalg_pinv_tdb = cast3 Unmanaged.linalg_pinv_tdb

linalg_pinv_ttb
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> CBool
  -> IO (ForeignPtr Tensor)
linalg_pinv_ttb = cast3 Unmanaged.linalg_pinv_ttb

linalg_pinv_out_ttdb
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> CDouble
  -> CBool
  -> IO (ForeignPtr Tensor)
linalg_pinv_out_ttdb = cast4 Unmanaged.linalg_pinv_out_ttdb

linalg_pinv_out_tttb
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> CBool
  -> IO (ForeignPtr Tensor)
linalg_pinv_out_tttb = cast4 Unmanaged.linalg_pinv_out_tttb

linalg_solve_tt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_solve_tt = cast2 Unmanaged.linalg_solve_tt

linalg_solve_out_ttt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_solve_out_ttt = cast3 Unmanaged.linalg_solve_out_ttt

linalg_tensorinv_tl
  :: ForeignPtr Tensor
  -> Int64
  -> IO (ForeignPtr Tensor)
linalg_tensorinv_tl = cast2 Unmanaged.linalg_tensorinv_tl

linalg_tensorinv_t
  :: ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_tensorinv_t = cast1 Unmanaged.linalg_tensorinv_t

linalg_tensorinv_out_ttl
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> Int64
  -> IO (ForeignPtr Tensor)
linalg_tensorinv_out_ttl = cast3 Unmanaged.linalg_tensorinv_out_ttl

linalg_tensorinv_out_tt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_tensorinv_out_tt = cast2 Unmanaged.linalg_tensorinv_out_tt

linalg_tensorsolve_ttl
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr IntArray
  -> IO (ForeignPtr Tensor)
linalg_tensorsolve_ttl = cast3 Unmanaged.linalg_tensorsolve_ttl

linalg_tensorsolve_tt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_tensorsolve_tt = cast2 Unmanaged.linalg_tensorsolve_tt

linalg_tensorsolve_out_tttl
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr IntArray
  -> IO (ForeignPtr Tensor)
linalg_tensorsolve_out_tttl = cast4 Unmanaged.linalg_tensorsolve_out_tttl

linalg_tensorsolve_out_ttt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_tensorsolve_out_ttt = cast3 Unmanaged.linalg_tensorsolve_out_ttt

linalg_qr_ts
  :: ForeignPtr Tensor
  -> ForeignPtr StdString
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor)))
linalg_qr_ts = cast2 Unmanaged.linalg_qr_ts

linalg_qr_t
  :: ForeignPtr Tensor
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor)))
linalg_qr_t = cast1 Unmanaged.linalg_qr_t

linalg_qr_out_ttts
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr StdString
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor)))
linalg_qr_out_ttts = cast4 Unmanaged.linalg_qr_out_ttts

linalg_qr_out_ttt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor)))
linalg_qr_out_ttt = cast3 Unmanaged.linalg_qr_out_ttt

_linalg_qr_helper_ts
  :: ForeignPtr Tensor
  -> ForeignPtr StdString
  -> IO (ForeignPtr (StdTuple '(Tensor,Tensor)))
_linalg_qr_helper_ts = cast2 Unmanaged._linalg_qr_helper_ts

linalg_matrix_power_tl
  :: ForeignPtr Tensor
  -> Int64
  -> IO (ForeignPtr Tensor)
linalg_matrix_power_tl = cast2 Unmanaged.linalg_matrix_power_tl

linalg_matrix_power_out_ttl
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> Int64
  -> IO (ForeignPtr Tensor)
linalg_matrix_power_out_ttl = cast3 Unmanaged.linalg_matrix_power_out_ttl

linalg_matrix_rank_tttb
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> CBool
  -> IO (ForeignPtr Tensor)
linalg_matrix_rank_tttb = cast4 Unmanaged.linalg_matrix_rank_tttb

linalg_matrix_rank_ttt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_matrix_rank_ttt = cast3 Unmanaged.linalg_matrix_rank_ttt

linalg_matrix_rank_tt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_matrix_rank_tt = cast2 Unmanaged.linalg_matrix_rank_tt

linalg_matrix_rank_t
  :: ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_matrix_rank_t = cast1 Unmanaged.linalg_matrix_rank_t

linalg_matrix_rank_out_ttttb
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> CBool
  -> IO (ForeignPtr Tensor)
linalg_matrix_rank_out_ttttb = cast5 Unmanaged.linalg_matrix_rank_out_ttttb

linalg_matrix_rank_out_tttt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_matrix_rank_out_tttt = cast4 Unmanaged.linalg_matrix_rank_out_tttt

linalg_matrix_rank_out_ttt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_matrix_rank_out_ttt = cast3 Unmanaged.linalg_matrix_rank_out_ttt

linalg_matrix_rank_out_tt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
linalg_matrix_rank_out_tt = cast2 Unmanaged.linalg_matrix_rank_out_tt

linalg_matrix_rank_tddb
  :: ForeignPtr Tensor
  -> CDouble
  -> CDouble
  -> CBool
  -> IO (ForeignPtr Tensor)
linalg_matrix_rank_tddb = cast4 Unmanaged.linalg_matrix_rank_tddb

linalg_matrix_rank_tdd
  :: ForeignPtr Tensor
  -> CDouble
  -> CDouble
  -> IO (ForeignPtr Tensor)
linalg_matrix_rank_tdd = cast3 Unmanaged.linalg_matrix_rank_tdd

linalg_matrix_rank_td
  :: ForeignPtr Tensor
  -> CDouble
  -> IO (ForeignPtr Tensor)
linalg_matrix_rank_td = cast2 Unmanaged.linalg_matrix_rank_td

linalg_matrix_rank_out_ttddb
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> CDouble
  -> CDouble
  -> CBool
  -> IO (ForeignPtr Tensor)
linalg_matrix_rank_out_ttddb = cast5 Unmanaged.linalg_matrix_rank_out_ttddb

linalg_matrix_rank_out_ttdd
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> CDouble
  -> CDouble
  -> IO (ForeignPtr Tensor)
linalg_matrix_rank_out_ttdd = cast4 Unmanaged.linalg_matrix_rank_out_ttdd

linalg_matrix_rank_out_ttd
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> CDouble
  -> IO (ForeignPtr Tensor)
linalg_matrix_rank_out_ttd = cast3 Unmanaged.linalg_matrix_rank_out_ttd

linalg_matrix_rank_tdb
  :: ForeignPtr Tensor
  -> CDouble
  -> CBool
  -> IO (ForeignPtr Tensor)
linalg_matrix_rank_tdb = cast3 Unmanaged.linalg_matrix_rank_tdb

linalg_matrix_rank_out_ttdb
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> CDouble
  -> CBool
  -> IO (ForeignPtr Tensor)
linalg_matrix_rank_out_ttdb = cast4 Unmanaged.linalg_matrix_rank_out_ttdb

linalg_matrix_rank_ttb
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> CBool
  -> IO (ForeignPtr Tensor)
linalg_matrix_rank_ttb = cast3 Unmanaged.linalg_matrix_rank_ttb

linalg_matrix_rank_out_tttb
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> CBool
  -> IO (ForeignPtr Tensor)
linalg_matrix_rank_out_tttb = cast4 Unmanaged.linalg_matrix_rank_out_tttb

linalg_multi_dot_l
  :: ForeignPtr TensorList
  -> IO (ForeignPtr Tensor)
linalg_multi_dot_l = cast1 Unmanaged.linalg_multi_dot_l

linalg_multi_dot_out_tl
  :: ForeignPtr Tensor
  -> ForeignPtr TensorList
  -> IO (ForeignPtr Tensor)
linalg_multi_dot_out_tl = cast2 Unmanaged.linalg_multi_dot_out_tl

_test_serialization_subcmul_tts
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Scalar
  -> IO (ForeignPtr Tensor)
_test_serialization_subcmul_tts = cast3 Unmanaged._test_serialization_subcmul_tts

_test_serialization_subcmul_tt
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
_test_serialization_subcmul_tt = cast2 Unmanaged._test_serialization_subcmul_tt

_test_optional_intlist_tl
  :: ForeignPtr Tensor
  -> ForeignPtr IntArray
  -> IO (ForeignPtr Tensor)
_test_optional_intlist_tl = cast2 Unmanaged._test_optional_intlist_tl

_test_optional_filled_intlist_tl
  :: ForeignPtr Tensor
  -> ForeignPtr IntArray
  -> IO (ForeignPtr Tensor)
_test_optional_filled_intlist_tl = cast2 Unmanaged._test_optional_filled_intlist_tl

_test_optional_floatlist_ta
  :: ForeignPtr Tensor
  -> ForeignPtr (StdVector CDouble)
  -> IO (ForeignPtr Tensor)
_test_optional_floatlist_ta = cast2 Unmanaged._test_optional_floatlist_ta

_test_string_default_tss
  :: ForeignPtr Tensor
  -> ForeignPtr StdString
  -> ForeignPtr StdString
  -> IO (ForeignPtr Tensor)
_test_string_default_tss = cast3 Unmanaged._test_string_default_tss

_test_string_default_ts
  :: ForeignPtr Tensor
  -> ForeignPtr StdString
  -> IO (ForeignPtr Tensor)
_test_string_default_ts = cast2 Unmanaged._test_string_default_ts

_test_string_default_t
  :: ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
_test_string_default_t = cast1 Unmanaged._test_string_default_t

_test_ambiguous_defaults_tll
  :: ForeignPtr Tensor
  -> Int64
  -> Int64
  -> IO (ForeignPtr Tensor)
_test_ambiguous_defaults_tll = cast3 Unmanaged._test_ambiguous_defaults_tll

_test_ambiguous_defaults_tl
  :: ForeignPtr Tensor
  -> Int64
  -> IO (ForeignPtr Tensor)
_test_ambiguous_defaults_tl = cast2 Unmanaged._test_ambiguous_defaults_tl

_test_ambiguous_defaults_t
  :: ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
_test_ambiguous_defaults_t = cast1 Unmanaged._test_ambiguous_defaults_t

_test_ambiguous_defaults_tls
  :: ForeignPtr Tensor
  -> Int64
  -> ForeignPtr StdString
  -> IO (ForeignPtr Tensor)
_test_ambiguous_defaults_tls = cast3 Unmanaged._test_ambiguous_defaults_tls

_test_warn_in_autograd_t
  :: ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
_test_warn_in_autograd_t = cast1 Unmanaged._test_warn_in_autograd_t

segment_reduce_tsttlbs
  :: ForeignPtr Tensor
  -> ForeignPtr StdString
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> Int64
  -> CBool
  -> ForeignPtr Scalar
  -> IO (ForeignPtr Tensor)
segment_reduce_tsttlbs = cast7 Unmanaged.segment_reduce_tsttlbs

segment_reduce_tsttlb
  :: ForeignPtr Tensor
  -> ForeignPtr StdString
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> Int64
  -> CBool
  -> IO (ForeignPtr Tensor)
segment_reduce_tsttlb = cast6 Unmanaged.segment_reduce_tsttlb

segment_reduce_tsttl
  :: ForeignPtr Tensor
  -> ForeignPtr StdString
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> Int64
  -> IO (ForeignPtr Tensor)
segment_reduce_tsttl = cast5 Unmanaged.segment_reduce_tsttl

segment_reduce_tstt
  :: ForeignPtr Tensor
  -> ForeignPtr StdString
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
segment_reduce_tstt = cast4 Unmanaged.segment_reduce_tstt

segment_reduce_tst
  :: ForeignPtr Tensor
  -> ForeignPtr StdString
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
segment_reduce_tst = cast3 Unmanaged.segment_reduce_tst

segment_reduce_ts
  :: ForeignPtr Tensor
  -> ForeignPtr StdString
  -> IO (ForeignPtr Tensor)
segment_reduce_ts = cast2 Unmanaged.segment_reduce_ts

_segment_reduce_backward_tttstl
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr StdString
  -> ForeignPtr Tensor
  -> Int64
  -> IO (ForeignPtr Tensor)
_segment_reduce_backward_tttstl = cast6 Unmanaged._segment_reduce_backward_tttstl

_segment_reduce_backward_tttst
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr StdString
  -> ForeignPtr Tensor
  -> IO (ForeignPtr Tensor)
_segment_reduce_backward_tttst = cast5 Unmanaged._segment_reduce_backward_tttst

_segment_reduce_backward_ttts
  :: ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr Tensor
  -> ForeignPtr StdString
  -> IO (ForeignPtr Tensor)
_segment_reduce_backward_ttts = cast4 Unmanaged._segment_reduce_backward_ttts

pad_sequence_lbd
  :: ForeignPtr TensorList
  -> CBool
  -> CDouble
  -> IO (ForeignPtr Tensor)
pad_sequence_lbd = cast3 Unmanaged.pad_sequence_lbd

pad_sequence_lb
  :: ForeignPtr TensorList
  -> CBool
  -> IO (ForeignPtr Tensor)
pad_sequence_lb = cast2 Unmanaged.pad_sequence_lb

pad_sequence_l
  :: ForeignPtr TensorList
  -> IO (ForeignPtr Tensor)
pad_sequence_l = cast1 Unmanaged.pad_sequence_l

flatten_dense_tensors_l
  :: ForeignPtr TensorList
  -> IO (ForeignPtr Tensor)
flatten_dense_tensors_l = cast1 Unmanaged.flatten_dense_tensors_l

unflatten_dense_tensors_tl
  :: ForeignPtr Tensor
  -> ForeignPtr TensorList
  -> IO (ForeignPtr TensorList)
unflatten_dense_tensors_tl = cast2 Unmanaged.unflatten_dense_tensors_tl

