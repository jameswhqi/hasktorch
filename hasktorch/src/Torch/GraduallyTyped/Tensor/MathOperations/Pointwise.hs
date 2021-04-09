{-# LANGUAGE DataKinds #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

module Torch.GraduallyTyped.Tensor.MathOperations.Pointwise where

import System.IO.Unsafe (unsafePerformIO)
import Torch.DType (DType (Bool))
import Torch.GraduallyTyped.DType (DataType (DataType))
import Torch.GraduallyTyped.RequiresGradient (RequiresGradient (..))
import Torch.GraduallyTyped.Scalar (Scalar)
import Torch.GraduallyTyped.Shape (BroadcastShapesF)
import Torch.GraduallyTyped.Tensor.Type (Tensor)
import Torch.GraduallyTyped.Unify (type (<+>), type (<|>))
import Torch.Internal.Cast (cast1, cast2, cast3, cast4)
import qualified Torch.Internal.Managed.Native as ATen
import Prelude hiding (abs)

-- | Computes the element-wise absolute value of the given 'input' tensor:
-- \[
-- \mathrm{output}_i = \left|\mathrm{input}_i\right|.
-- \]
-- The result is returned as a new tensor.
abs ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
abs = unsafePerformIO . cast1 ATen.abs_t

-- | Alias for 'abs'.
absolute ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
absolute = abs

-- | Returns a new tensor with the arccosine of the elements of 'input':
-- \[
-- \mathrm{output}_i = \cos^{-1} \left(\mathrm{input}_i\right).
-- \]
acos ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
acos = unsafePerformIO . cast1 ATen.acos_t

-- | Returns a new tensor with the arccosine of the elements of 'input':
-- \[
-- \mathrm{output}_i = \cosh^{-1} \left(\mathrm{input}_i\right).
-- \]
--
-- Note that the domain of the inverse hyperbolic cosine is \([1, \infty)\), and
-- values outside this range will be mapped to \(\mathrm{NaN}\),
-- except for \(+\infty\) for which the output is mapped to \(+\infty\).
acosh ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
acosh = unsafePerformIO . cast1 ATen.acosh_t

-- | Element-wise addition of one tensor and another:
-- \[
-- \mathrm{output}_i = \mathrm{input}_i + \mathrm{other}_i.
-- \]
-- The result is returned as a new tensor.
--
-- The shape of 'other' must be broadcastable with the shape of 'input'.
-- See 'addScalar' for a version of this function where
-- the 'other' input is a scalar.
--
-- >>> g <- generator @('Device 'CPU) 0
-- >>> (a, g) = randn @'Dependent @('Layout 'Dense) @('Device 'CPU) @('DataType 'Float) @('Shape '[ 'Dim ('NamedSized "feature" 4)]) g
-- >>> (b, _) = randn @'Dependent @('Layout 'Dense) @('Device 'CPU) @('DataType 'Float) @('Shape '[ 'Dim ('Sized 4), 'Dim ('Sized 1)]) g
-- >>> :type a `add` b
-- a `add` b
--   :: Tensor
--        'Dependent
--        ('Layout 'Dense)
--        ('Device 'CPU)
--        ('DataType 'Float)
--        ('Shape '[ 'Dim ('Sized 4), 'Dim ('NamedSized "feature" 4)])
add ::
  forall requiresGradient layout device dataType shape requiresGradient' layout' device' dataType' shape'.
  -- | input tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | other tensor
  Tensor requiresGradient' layout' device' dataType' shape' ->
  -- | output tensor
  Tensor
    (requiresGradient <|> requiresGradient')
    (layout <+> layout')
    (device <+> device')
    (dataType <+> dataType')
    (BroadcastShapesF shape shape')
input `add` other = unsafePerformIO $ cast2 ATen.add_tt input other

-- | Adds a scalar 'other' to a tensor 'input':
-- \[
-- \mathrm{output}_i = \mathrm{input}_i + \mathrm{other}.
-- \]
-- The result is returned as a new tensor.
-- See 'add' for a version of this function where
-- the second argument is a tensor.
--
-- TODO: add data type unification of @other@ and @dataType@.
addScalar ::
  forall other requiresGradient layout device dataType shape.
  (Scalar other) =>
  -- | input tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | input scalar
  other ->
  -- | output
  Tensor requiresGradient layout device dataType shape
input `addScalar` other = unsafePerformIO $ cast2 ATen.add_ts input other

-- | Performs the element-wise division of 'tensor1' by 'tensor2',
-- multiply the result by a scalar 'value' and add it to 'input':
-- \[
-- \mathrm{output}_i = \mathrm{input}_i + \mathrm{value} \times \frac{\mathrm{tensor1}_i}{\mathrm{tensor2}_i}.
-- \]
--
-- See 'addcmul' for a version of this function where 'tensor1' and 'tensor2'
-- are multiplied rather than divided.
--
-- Note further that for inputs of type 'Float' or 'Double',
-- 'value' must be a real number, otherwise it must be an integer.
addcdiv ::
  forall value requiresGradient layout device dataType shape.
  (Scalar value) =>
  -- | input scalar
  value ->
  -- | first other tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | second other tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | input tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | output tensor
  Tensor requiresGradient layout device dataType shape
addcdiv value tensor1 tensor2 input = unsafePerformIO $ cast4 ATen.addcdiv_ttts input tensor1 tensor2 value

-- | Performs the element-wise multiplication of 'tensor1' by 'tensor2',
-- multiply the result by the scalar 'value' and add it to 'input':
-- \[
-- \mathrm{output}_i = \mathrm{input}_i + \mathrm{value} \times \mathrm{tensor1}_i \times \mathrm{tensor2}_i.
-- \]
--
-- See 'addcdiv' for a version of this function where 'tensor1' and 'tensor2'
-- are divided rather than multiplied.
--
-- Note further that for inputs of type 'Float' or 'Double',
-- 'value' must be a real number, otherwise it must be an integer.
addcmul ::
  forall scalar requiresGradient layout device dataType shape.
  (Scalar scalar) =>
  -- | input scalar
  scalar ->
  -- | first other tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | second other tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | input tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
addcmul scalar tensor1 tensor2 input = unsafePerformIO $ cast4 ATen.addcmul_ttts input tensor1 tensor2 scalar

-- | Returns a new tensor with the arcsine of the elements of 'input':
-- \[
-- \mathrm{output}_i = \sin^{-1} \left(\mathrm{input}_i\right).
-- \]
asin ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
asin = unsafePerformIO . cast1 ATen.asin_t

-- | Returns a new tensor with the inverse hyperbolic sine of the elements of 'input':
-- \[
-- \mathrm{output}_i = \sinh^{-1} \left(\mathrm{input}_i\right).
-- \]
asinh ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
asinh = unsafePerformIO . cast1 ATen.asinh_t

-- | Returns a new tensor with the arctangent of the elements of 'input':
-- \[
-- \mathrm{output}_i = \tan^{-1} \left(\mathrm{input}_i\right).
-- \]
atan ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
atan = unsafePerformIO . cast1 ATen.atan_t

-- | Returns a new tensor with the inverse hyperbolic tangent of the elements of 'input':
-- \[
-- \mathrm{output}_i = \tanh^{-1} \left(\mathrm{input}_i\right).
-- \]
--
-- Note that the domain of the inverse hyperbolic tangent is \((-1, 1)\), and
-- values outside this range will be mapped to \(\mathrm{NaN}\),
-- except for the values \(1\) and \(-1\) for which the output is mapped to
-- \(\pm \infty\) respectively.
atanh ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
atanh = unsafePerformIO . cast1 ATen.atanh_t

-- | Element-wise arctangent of 'input' and 'other' with consideration of the quadrant.
-- Returns a new tensor where each element is the signed angle in radians between
-- the vectors \(\mathrm{other}_i, \mathrm{input}_i)\) and \((1,0)\).
-- Here $\mathrm{other}_i$, the \(i\)-th element of the second argument of this function,
-- is the x coordinate while $\mathrm{input}_i$, the \(i\)-th element of the first argument,
-- is the y coordinate.
--
-- Note that the shapes of 'input' and 'other' must be broadcastable.
atan2 ::
  forall requiresGradient layout device dataType shape requiresGradient' layout' device' dataType' shape'.
  -- | input tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | other input tensor
  Tensor requiresGradient' layout' device' dataType' shape' ->
  -- | output tensor
  Tensor
    (requiresGradient <|> requiresGradient')
    (layout <+> layout')
    (device <+> device')
    (dataType <+> dataType')
    (BroadcastShapesF shape shape')
atan2 input other = unsafePerformIO $ cast2 ATen.atan2_tt input other

-- | Computes the bitwise NOT of the given 'input' tensor.
-- The data type of the 'input' tensor must be 'Bool' or an integral data type.
-- For 'Bool' tensors, the function computes the logical NOT.
bitwiseNot ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device ( 'DataType 'Bool) shape
bitwiseNot = unsafePerformIO . cast1 ATen.bitwise_not_t

-- | Computes the bitwise AND of the 'input' and the 'other' tensor.
-- The data type of the tensors must be 'Bool' or an integral data type.
-- For 'Bool' tensors, the function computes the logical AND.
--
-- See 'bitwiseAndScalar' for a version of this function where 'other'
-- is a scalar.
bitwiseAnd ::
  forall requiresGradient layout device dataType shape.
  -- | input tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | other tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | output tensor
  Tensor requiresGradient layout device dataType shape
input `bitwiseAnd` other = unsafePerformIO $ cast2 ATen.bitwise_and_tt input other

-- | Computes the bitwise AND of the tensor 'input' and the scalar 'other'.
-- The data type of the inputs must be 'Bool' or an integral data type.
-- If the data type is 'Bool', then the function computes the logical AND.
--
-- See 'bitwiseAnd' for a version of this function where 'other'
-- is a tensor.
bitwiseAndScalar ::
  forall other requiresGradient layout device dataType shape.
  (Scalar other) =>
  -- | input tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | other scalar
  other ->
  -- | output
  Tensor requiresGradient layout device dataType shape
input `bitwiseAndScalar` other = unsafePerformIO $ cast2 ATen.bitwise_and_ts input other

-- | Computes the bitwise OR of the 'input' and the 'other' tensor.
-- The data type of the tensors must be 'Bool' or an integral data type.
-- For 'Bool' tensors, the function computes the logical OR.
--
-- See 'bitwiseOrScalar' for a version of this function where 'other'
-- is a scalar.
bitwiseOr ::
  forall requiresGradient layout device dataType shape.
  -- | input tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | other tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | output tensor
  Tensor requiresGradient layout device dataType shape
input `bitwiseOr` other = unsafePerformIO $ cast2 ATen.bitwise_or_tt input other

-- | Computes the bitwise OR of the tensor 'input' and the scalar 'other'.
-- The data type of the inputs must be 'Bool' or an integral data type.
-- If the data type is 'Bool', then the function computes the logical OR.
--
-- See 'bitwiseOr' for a version of this function where 'other'
-- is a tensor.
bitwiseOrScalar ::
  forall other requiresGradient layout device dataType shape.
  (Scalar other) =>
  -- | input tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | other scalar
  other ->
  -- | output tensor
  Tensor requiresGradient layout device dataType shape
input `bitwiseOrScalar` other = unsafePerformIO $ cast2 ATen.bitwise_or_ts input other

-- | Computes the bitwise XOR of the 'input' and the 'other' tensor.
-- The data type of the tensors must be 'Bool' or an integral data type.
-- For 'Bool' tensors, the function computes the logical XOR.
--
-- See 'bitwiseXorScalar' for a version of this function where 'other'
-- is a scalar.
bitwiseXor ::
  forall requiresGradient layout device dataType shape.
  -- | input tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | other tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | output tensor
  Tensor requiresGradient layout device dataType shape
input `bitwiseXor` other = unsafePerformIO $ cast2 ATen.bitwise_xor_tt input other

-- | Computes the bitwise XOR of the tensor 'input' and the scalar 'other'.
-- The data type of the inputs must be 'Bool' or an integral data type.
-- If the data type is 'Bool', then the function computes the logical XOR.
--
-- See 'bitwiseXor' for a version of this function where 'other'
-- is a tensor.
bitwiseXorScalar ::
  forall other requiresGradient layout device dataType shape.
  (Scalar other) =>
  -- | input tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | other scalar
  other ->
  -- | output tensor
  Tensor requiresGradient layout device dataType shape
input `bitwiseXorScalar` other = unsafePerformIO $ cast2 ATen.bitwise_xor_ts input other

-- | Returns a new tensor with the ceil of the elements of 'input',
-- that is, the smallest integer greater than or equal to each element:
-- \[
-- \mathrm{output}_i = \lceil\mathrm{input}_i\rceil = \lfloor\mathrm{input}_i\rfloor + 1,
-- \]
-- where \(\lfloor\mathrm{input}_i\rfloor\) is the floor of the \(i\)-th element of 'input'
-- which can be computed with 'floor'.
ceil ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
ceil = unsafePerformIO . cast1 ATen.ceil_t

-- | Clamp all elements in input into the range [ min, max ]
-- and return the result as a new tensor.
clamp ::
  forall min max requiresGradient layout device dataType shape.
  (Scalar min, Scalar max) =>
  -- | min
  min ->
  -- | max
  max ->
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
clamp min max input = unsafePerformIO $ cast3 ATen.clamp__tss input min max

cos ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
cos = unsafePerformIO . cast1 ATen.cos_t

cosh ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
cosh = unsafePerformIO . cast1 ATen.cosh_t

deg2rad ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
deg2rad = unsafePerformIO . cast1 ATen.deg2rad_t

-- | Element-wise division of the first input tensor, the 'dividend',
-- by the second input tensor, the 'divisor'.
-- \[
-- \mathrm{output}_i = \frac{dividend_i}{divisor_i}
-- \]
-- The result is returned as a new tensor.
--
-- See 'divScalar' for a version of this function where
-- the 'divisor' is a scalar.
--
-- Note further that "true divisions" can be computed with
-- 'trueDivide' or 'trueDivideScalar' which can come in handy
-- when both the 'dividend' and the 'divisor' have 'Bool' or integer data types.
div ::
  forall requiresGradient layout device dataType shape requiresGradient' layout' device' dataType' shape'.
  -- | tensor dividend
  Tensor requiresGradient layout device dataType shape ->
  -- | tensor divisor
  Tensor requiresGradient' layout' device' dataType' shape' ->
  -- | tensor output
  Tensor
    (requiresGradient <|> requiresGradient')
    (layout <+> layout')
    (device <+> device')
    (dataType <+> dataType')
    (BroadcastShapesF shape shape')
dividend `div` divisor = unsafePerformIO $ cast2 ATen.div_tt dividend divisor

-- | Element-wise division of the first input, the 'dividend' tensor,
-- by the second input, the 'divisor' scalar.
-- \[
-- \mathrm{output}_i = \frac{dividend_i}{divisor}
-- \]
-- The result is returned as a new tensor.
--
-- See 'div' for a version of this function where
-- the divisor is a tensor.
--
-- Note further that "true divisions" can be computed with
-- 'trueDivide' or 'trueDivideScalar' which can come in handy
-- when both the dividend and the divisor have 'Bool' or integer data types.
divScalar ::
  forall divisor requiresGradient layout device dataType shape.
  (Scalar divisor) =>
  -- | tensor dividend
  Tensor requiresGradient layout device dataType shape ->
  -- | scalar divisor
  divisor ->
  -- | tensor output
  Tensor requiresGradient layout device dataType shape
dividend `divScalar` divisor = unsafePerformIO $ cast2 ATen.div_ts dividend divisor

-- | Computes the logarithmic derivative of the gamma function on 'input':
-- \[
-- \mathrm{output}_i = \psi\left(\mathrm{input}_i\right) = \frac{d}{d\mathrm{input}_i} \ln\left(\gamma\left(\mathrm{input}_i\right)\right).
-- \]
digamma ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
digamma = unsafePerformIO . cast1 ATen.digamma_t

-- | Computes and returns the error function of each element of 'input':
-- \[
-- \mathrm{output}_i = \mathop{erf}\left(\mathrm{input}_i\right) = \frac{2}{\sqrt{\pi}} \int_0^{\mathrm{output}_i} \exp\left(- t^2\right) dt.
-- \]
--
-- See also 'erfc' that computes the complementary error function
-- to high numerical accuracy
-- and 'erfinv' that computes the inverse of the error function.
erf ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
erf = unsafePerformIO . cast1 ATen.erf_t

-- | Computes the complementary error function of each element of 'input':
-- \[
-- \mathrm{output}_i = 1 - \mathop{erf}\left(\mathrm{input}_i\right) = 1 - \frac{2}{\sqrt{\pi}} \int_0^{\mathrm{output}_i} \exp\left(- t^2\right) dt.
-- \]
--
-- See also 'erf' that computes the error function
-- and 'erfinv' that computes the inverse of the error function.
erfc ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
erfc = unsafePerformIO . cast1 ATen.erfc_t

-- | Computes the inverse error function of each element of 'input':
-- \[
-- \mathrm{output}_i = \mathop{erfinv}\left(\mathrm{input}_i\right)
-- \]
-- where \(\mathop{erfinv}\left(\mathop{erf}\left(x\right)\right) = x\)
-- for \(x \in (-1, 1)\). 'erfinv' is not defined outside this interval.
--
-- See also 'erf' that computes the error function
-- and 'erfc' that computes the complementary error function.
erfinv ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
erfinv = unsafePerformIO . cast1 ATen.erfinv_t

-- | Returns a new tensor with the exponential of the elements of the input tensor 'input':
-- \[
-- \mathrm{output}_i = \exp\left(\mathrm{input}_i\right).
-- \]
--
-- See also 'expm1' for a high-accuracy calculation of
-- the exponential of the elements of 'input' minus 1.
exp ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
exp = unsafePerformIO . cast1 ATen.exp_t

-- | Returns a new tensor with the exponential of the elements minus 1 of 'input':
-- \[
-- \mathrm{output}_i = \exp\left(\mathrm{input}_i\right) - 1.
-- \]
--
-- See also 'exp' for the exponential function.
expm1 ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
expm1 = unsafePerformIO . cast1 ATen.expm1_t

-- | Returns a new tensor with the floor of the elements of 'input',
-- that is, the largest integer less than or equal to each element.:
-- \[
-- \mathrm{output}_i = \lfloor\mathrm{input}_i\rfloor = \lceil\mathrm{input}_i\rceil - 1,
-- \]
-- where \(\lceil\mathrm{input}_i\rceil\) is the ceil of the \(i\)-th element of 'input'
-- which can be computed with 'ceil'.
floor ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
floor = unsafePerformIO . cast1 ATen.floor_t

-- | Return the element-wise division of the tensor 'dividend' by the tensor 'divisor'
-- rounded down to the nearest integer:
-- \[
-- \mathrm{output}_i = \left\lfloor\frac{\mathrm{dividend}_i}{\mathrm{divisor}_i}\right\rfloor.
-- \]
--
-- See 'floorDivideScalar' for a version of this function where
-- 'divisor' is a scalar.
floorDivide ::
  forall requiresGradient layout device dataType shape.
  -- | dividend tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | divisor tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | output tensor
  Tensor requiresGradient layout device dataType shape
dividend `floorDivide` divisor = unsafePerformIO $ cast2 ATen.floor_divide_tt dividend divisor

-- | Return the division of the tensor 'dividend' by the scalar 'divisor'
-- rounded down to the nearest integer:
-- \[
-- \mathrm{output}_i = \left\lfloor\frac{\mathrm{dividend}_i}{\mathrm{divisor}}\right\rfloor.
-- \]
--
-- See 'floorDivide' for a version of this function where
-- 'divisor' is a tensor.
floorDivideScalar ::
  forall divisor requiresGradient layout device dataType shape.
  (Scalar divisor) =>
  -- | dividend tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | divisor scalar
  divisor ->
  -- | output tensor
  Tensor requiresGradient layout device dataType shape
dividend `floorDivideScalar` divisor = unsafePerformIO $ cast2 ATen.floor_divide_ts dividend divisor

-- | Computes the element-wise remainder of the division of
-- the tensor 'dividend' by the tensor 'divisor'.
-- The dividend and divisor may contain both for integer and floating point numbers.
-- The remainder has the same sign as the 'dividend' input.
--
-- See 'fmodScalar' for a version of this function where
-- 'divisor' is a scalar.
fmod ::
  forall requiresGradient layout device dataType shape.
  -- | dividend tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | divisor scalar
  Tensor requiresGradient layout device dataType shape ->
  -- | output tensor
  Tensor requiresGradient layout device dataType shape
dividend `fmod` divisor = unsafePerformIO $ cast2 ATen.fmod_tt dividend divisor

-- | Computes the element-wise remainder of the division of
-- the tensor 'dividend' by the scalar 'divisor'.
-- The dividend and divisor may contain both for integer and floating point numbers.
-- The remainder has the same sign as the 'dividend' input.
--
-- See 'fmodScalar' for a version of this function where
-- 'divisor' is a scalar.
fmodScalar ::
  forall divisor requiresGradient layout device dataType shape.
  (Scalar divisor) =>
  -- | divisor scalar
  divisor ->
  -- | dividend tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | output tensor
  Tensor requiresGradient layout device dataType shape
fmodScalar scalar tensor = unsafePerformIO $ cast2 ATen.fmod_ts tensor scalar

-- | Computes the fractional portion of each element in 'input':
-- \[
-- \mathrm{output}_i = \mathrm{input}_i - \left\lfloor\left|\mathrm{input}_i\right|\right\rfloor \times \sgn\left(\mathrm{input}_i\right).
-- \]
frac ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
frac = unsafePerformIO . cast1 ATen.frac_t

-- | Linear interpolation of two tensors, 'start' and 'end', based on a tensor 'weight'.
-- For linear interpolations based on a scalar see 'lerpScalar'.
--
-- Returned is the result of the following computation as a tensor:
-- \[
--   \mathrm{output}_i = \mathrm{start}_i + \mathrm{weight}_i \times \left(\mathrm{end}_i - \mathrm{start}_i\right).
-- \]
--
-- Note that the shapes of 'start', 'end', and also 'weight' must be broadcastable.
lerp ::
  forall requiresGradient layout device dataType shape.
  -- | weight
  Tensor requiresGradient layout device dataType shape ->
  -- | start
  Tensor requiresGradient layout device dataType shape ->
  -- | end
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
lerp weight start end = unsafePerformIO $ cast3 ATen.lerp_ttt start end weight

-- | Linear interpolation of two tensors, 'start' and 'end', based on a scalar 'weight'.
-- For linear interpolations based on a tensor see 'lerp'.
--
-- Returned is the result of the following computation as a tensor:
-- \[
--   \mathrm{output}_i = \mathrm{start}_i + \mathrm{weight} \times \left(\mathrm{end}_i - \mathrm{start}_i\right).
-- \]
--
-- Note that the shapes of 'start' and 'end' must be broadcastable.
lerpScalar ::
  forall weight requiresGradient layout device dataType shape.
  (Scalar weight) =>
  -- | weight
  weight ->
  -- | start
  Tensor requiresGradient layout device dataType shape ->
  -- | end
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
lerpScalar weight start end = unsafePerformIO $ cast3 ATen.lerp_tts start end weight

-- | Computes the logarithm of the gamma function on 'input':
-- \[
-- \mathrm{output}_i = \log \Gamma\left(\mathrm{input}_i\right).
-- \]
lgamma ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
lgamma = unsafePerformIO . cast1 ATen.lgamma_t

-- | Returns a new tensor with the natural logarithm of the elements of 'input':
-- \[
-- \mathrm{output}_i = \ln \left(\mathrm{input}_i\right) = \log_{\mathrm{e}} \left(\mathrm{input}_i\right).
-- \]
log ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
log = unsafePerformIO . cast1 ATen.log_t

-- | Returns a new tensor with the decimal logarithm of the elements of 'input':
-- \[
-- \mathrm{output}_i = \mathop{lg} \left(\mathrm{input}_i\right) = \log_{10} \left(\mathrm{input}_i\right).
-- \]
log10 ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
log10 = unsafePerformIO . cast1 ATen.log10_t

-- | Returns a new tensor with the natural logarithm of \(1 + \mathrm{input}\):
-- \[
-- \mathrm{output}_i = \ln \left(1 + \mathrm{input}_i\right).
-- \]
--
-- Consider using this function over a literal implementation using 'log'.
-- 'log1p' is much more accurate for small values of 'input'.
log1p ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
log1p = unsafePerformIO . cast1 ATen.log1p_t

-- | Returns a new tensor with the logarithm to the base 2 of the elements of 'input':
-- \[
-- \mathrm{output}_i = \log_2 \left(\mathrm{input}_i\right).
-- \]
log2 ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
log2 = unsafePerformIO . cast1 ATen.log2_t

-- | Logarithm of the sum of exponentiations of the inputs.
-- Calculates pointwise the function \(\log \left(\exp x + \exp y\right)\).
--
-- This function is useful in statistics where the calculated probabilities of
-- events may be so small as to exceed the range of normal floating point numbers.
-- In such cases the logarithm of the calculated probability is stored.
-- This function allows adding probabilities stored in such a fashion.
--
-- 'logaddexp' must not be confused with 'logsumexp' which performs a reduction on a single tensor.
logaddexp ::
  forall requiresGradient layout device dataType shape.
  -- | other
  Tensor requiresGradient layout device dataType shape ->
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
logaddexp other input = unsafePerformIO $ cast2 ATen.logaddexp_tt input other

-- | Logarithm of the sum of exponentiations of the inputs in base-2.
-- Calculates pointwise the function \(\log_2 \left(2^x + 2^y\right)\).
--
-- See 'logaddexp' for further details.
logaddexp2 ::
  forall requiresGradient layout device dataType shape.
  -- | other
  Tensor requiresGradient layout device dataType shape ->
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
logaddexp2 other input = unsafePerformIO $ cast2 ATen.logaddexp2_tt input other

-- | Computes the element-wise logical AND of the given input tensors.
-- The output tensor will have the 'Bool' data type.
-- If the input tensors are not a bool tensors,
-- then zeros are treated as 'False' and nonzeros are treated as 'True'.
logicalAnd ::
  forall requiresGradient layout device dataType shape.
  -- | the input tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | the tensor to compute AND with
  Tensor requiresGradient layout device dataType shape ->
  -- | the output tensor
  Tensor requiresGradient layout device ( 'DataType 'Bool) shape
input `logicalAnd` other = unsafePerformIO $ cast2 ATen.logical_and_tt input other

-- | Computes the element-wise logical NOT of the given input tensor.
-- The output tensor will have the 'Bool' data type.
-- If the input tensor is not a bool tensor,
-- zeros are treated as 'False' and non-zeros are treated as 'True'.
logicalNot ::
  forall requiresGradient layout device dataType shape.
  -- | the input tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | the output tensor
  Tensor 'WithoutGradient layout device ( 'DataType 'Bool) shape
logicalNot = unsafePerformIO . cast1 ATen.logical_not_t

-- | Computes the element-wise logical OR of the given input tensors.
-- The output tensor will have the 'Bool' data type.
-- If the input tensors are not a bool tensors,
-- then zeros are treated as 'False' and nonzeros are treated as 'True'.
logicalOr ::
  forall requiresGradient layout device dataType shape requiresGradient' layout' device' dataType' shape'.
  -- | the input tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | the tensor to compute OR with
  Tensor requiresGradient' layout' device' dataType' shape' ->
  -- | the output tensor
  Tensor
    'WithoutGradient
    (layout <+> layout')
    (device <+> device')
    ( 'DataType 'Bool)
    (BroadcastShapesF shape shape')
input `logicalOr` other = unsafePerformIO $ cast2 ATen.logical_or_tt input other

-- | Computes the element-wise logical XOR of the given input tensors.
-- The output tensor will have the 'Bool' data type.
-- If the input tensors are not a bool tensors,
-- then zeros are treated as 'False' and nonzeros are treated as 'True'.
logicalXor ::
  forall requiresGradient layout device dataType shape.
  -- | the input tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | the tensor to compute XOR with
  Tensor requiresGradient layout device dataType shape ->
  -- | the output tensor
  Tensor requiresGradient layout device ( 'DataType 'Bool) shape
input `logicalXor` other = unsafePerformIO $ cast2 ATen.logical_xor_tt input other

-- | Element-wise multiplication of two tensors:
-- \[
-- \mathrm{output}_i = \mathrm{input}_i \times \mathrm{other}_i.
-- \]
-- The result is returned as a new tensor.
--
-- The shape of 'other' must be broadcastable with the shape of 'input'.
-- See 'mulScalar' for a version of this function where
-- the 'other' input is a scalar.
mul ::
  forall requiresGradient layout device dataType shape requiresGradient' layout' device' dataType' shape'.
  -- | input tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | other tensor
  Tensor requiresGradient' layout' device' dataType' shape' ->
  -- | output tensor
  Tensor
    (requiresGradient <|> requiresGradient')
    (layout <+> layout')
    (device <+> device')
    (dataType <+> dataType')
    (BroadcastShapesF shape shape')
input `mul` other = unsafePerformIO $ cast2 ATen.mul_tt input other

-- Multiplies each element of the input 'input' with the scalar 'other' and returns a new resulting tensor:
-- \[
-- \mathrm{output}_i = \mathrm{input}_i \times \mathrm{other}.
-- \]
--
-- If 'input' is of the data type 'Float' or 'Double', 'other' should be a real number,
-- otherwise it should be an 'integer'.
-- See 'mul' for a version of this function where
-- the 'other' input is a tensor.
mulScalar ::
  forall other requiresGradient layout device dataType shape.
  (Scalar other) =>
  -- | tensor input
  Tensor requiresGradient layout device dataType shape ->
  -- | scalar other input
  other ->
  -- | tensor output
  Tensor requiresGradient layout device dataType shape
input `mulScalar` other = unsafePerformIO $ cast2 ATen.mul_ts input other

-- | Computes the multivariate log-gamma function with dimension 'p' element-wise, given by
-- \[
-- \log(\Gamma_p(\mathrm{input})) = C + \sum_{i=1}^{p} \log \left(\Gamma\left(\mathrm{input} - \frac{i-1}{2}\right)\right)
-- \]
-- where \(C = \log(\pi) \times \frac{p(p-1)}{4}\) and \(\Gamma(\dot)\) is the gamma function.
--
-- All elements of the input tensor must be greater than \(\frac{p-1}{2}\).
-- Otherwise, the computation is halted and an exception is thrown.
mvlgamma ::
  forall requiresGradient layout device dataType shape.
  -- | the number of dimensions 'p'
  Int ->
  -- | the input tensor to compute the the multivariate log-gamma function for
  Tensor requiresGradient layout device dataType shape ->
  -- | the output tensor
  Tensor requiresGradient layout device dataType shape
mvlgamma p input = unsafePerformIO $ cast2 ATen.mvlgamma_tl input p

-- | Returns a new tensor with the negative of the elements of 'input':
-- \[
-- \mathrm{output}_i = - \mathrm{input}_i.
-- \]
neg ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
neg = unsafePerformIO . cast1 ATen.neg_t

-- | Computes the \(n\)-th derivative of the digamma function \(\psi\) on the 'input',
-- where \(n \ge 0\).
-- \(n\) is called the order of the polygamma function \(\psi^{(n)}\)
-- that is defined as:
-- \[
-- \psi^{(n)}(\mathrm{input}) = \frac{d^{(n)}}{d\mathrm{input}^{(n)}} \psi(\mathrm{input})
-- \]
-- where \(\psi(\mathrm{input}) = \log(\Gamma(\mathrm{input}))\).
polygamma ::
  forall requiresGradient layout device dataType shape.
  -- | the order of the polygamma function
  Int ->
  -- | the input tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | the output tensor
  Tensor requiresGradient layout device dataType shape
polygamma n input = unsafePerformIO $ cast2 ATen.polygamma_lt n input

-- | Takes the power of each element in the tensor 'input'
-- with the corresponding element in the tensor 'exponent' and
-- returns a tensor with the result.
--
-- Note that the 'exponent' and the 'input' must be tensors
-- with broadcastable shapes.
-- See 'powScalar' for a version that takes a scalar 'exponent' as argument
-- and 'powTensor' for a version where the 'input' is a scalar and the 'exponent' a tensor.
--
-- The following operation is applied:
-- \[
-- \mathrm{output}_i = \mathrm{input}_i^{\mathrm{exponent}_i}.
-- \]
pow ::
  forall requiresGradient layout device dataType shape requiresGradient' layout' device' dataType' shape'.
  -- | tensor exponent
  Tensor requiresGradient layout device dataType shape ->
  -- | tensor input
  Tensor requiresGradient' layout' device' dataType' shape' ->
  -- | tensor output
  Tensor
    (requiresGradient <|> requiresGradient')
    (layout <+> layout')
    (device <+> device')
    (dataType <+> dataType')
    (BroadcastShapesF shape shape')
pow exponent input = unsafePerformIO $ cast2 ATen.pow_tt input exponent

-- | Takes the power of each element in the tensor 'input' with the scalar 'exponent' and
-- returns a tensor with the result.
--
-- Note that the 'exponent' is a scalar.
-- See 'pow' for a version that takes a tensor 'exponent' as argument
-- and 'powTensor' for a version where the 'input' is a scalar and the 'exponent' a tensor.
--
-- The following operation is applied:
-- \[
-- \mathrm{output}_i = \mathrm{input}_i^{\mathrm{exponent}}.
-- \]
powScalar ::
  forall exponent requiresGradient layout device dataType shape.
  (Scalar exponent) =>
  -- | scalar exponent
  exponent ->
  -- | tensor input
  Tensor requiresGradient layout device dataType shape ->
  -- | tensor output
  Tensor requiresGradient layout device dataType shape
powScalar exponent input = unsafePerformIO $ cast2 ATen.pow_ts input exponent

-- | Takes the power of the scalar 'input' with each element in the tensor 'exponent' and
-- returns a tensor with the result.
--
-- Note that the 'exponent' is a tensor while the 'input' is a scalar.
-- See 'pow' for a version that takes a tensor 'input' as argument
-- and 'powScalar' for a version where the 'input' is a tensor and the 'exponent' a scalar.
--
-- The following operation is applied:
-- \[
-- \mathrm{output}_i = \mathrm{input}^{\mathrm{exponent}_i}.
-- \]
powTensor ::
  forall input requiresGradient layout device dataType shape.
  (Scalar input) =>
  -- | tensor exponent
  Tensor requiresGradient layout device dataType shape ->
  -- | scalar input
  input ->
  -- | tensor output
  Tensor requiresGradient layout device dataType shape
powTensor exponent input = unsafePerformIO $ cast2 ATen.pow_st input exponent

-- | Returns a new tensor with each of the elements of 'input'
-- converted from angles in radians to degrees.
rad2deg ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
rad2deg = unsafePerformIO . cast1 ATen.rad2deg_t

-- | Returns a new tensor with the reciprocal of the elements of 'input':
-- \[
-- \mathrm{output}_i = \frac{1}{\mathrm{input}_i}
-- \]
reciprocal ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
reciprocal = unsafePerformIO . cast1 ATen.reciprocal_t

-- | Computes the element-wise remainder of division.
--
-- The dividend and divisor may contain integer and floating point numbers.
-- The remainder has the same sign as the divisor other.
--
-- When other is a tensor, the shapes of input and other must be broadcastable.
remainder ::
  forall requiresGradient layout device dataType shape.
  -- | dividend
  Tensor requiresGradient layout device dataType shape ->
  -- | divisor
  Tensor requiresGradient layout device dataType shape ->
  Tensor requiresGradient layout device dataType shape
dividend `remainder` divisor = unsafePerformIO $ cast2 ATen.remainder_tt dividend divisor

-- | Returns a new tensor with each of the elements of 'input' rounded to the closest integer.
-- Note that the data type is unchanged.
round ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
round = unsafePerformIO . cast1 ATen.round_t

-- | Returns a new tensor with the reciprocal of the square-root of
-- each of the elements of 'input':
-- \[
-- \mathrm{output}_i = \frac{1}{\sqrt{\mathrm{input}_i}}.
-- \]
rsqrt ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
rsqrt = unsafePerformIO . cast1 ATen.rsqrt_t

-- | Returns a new tensor with the sigmoid of the elements of 'input':
-- \[
-- \mathrm{output}_i = \frac{1}{1 + \exp \left(-\mathrm{input}_i\right)}
-- \]
sigmoid ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
sigmoid = unsafePerformIO . cast1 ATen.sigmoid_t

-- | Returns a new tensor with the signs of the elements of 'input':
-- \[
-- \mathrm{output}_i = \begin{cases}
--   -1 & \text{if } \mathrm{input}_i < 0 \\
--   0  & \text{if } \mathrm{input}_i = 0 \\
--   1  & \text{if } \mathrm{input}_i > 0.
-- \end{cases}
-- \]
sign ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
sign = unsafePerformIO . cast1 ATen.sign_t

-- | Returns a new tensor with the sine of the elements of 'input':
-- \[
-- \mathrm{output}_i = \sin \left(\mathrm{input}_i\right).
-- \]
sin ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
sin = unsafePerformIO . cast1 ATen.sin_t

-- | Returns a new tensor with the hyperbolic sine of the elements of 'input':
-- \[
-- \mathrm{output}_i = \sinh \left(\mathrm{input}_i\right).
-- \]
sinh ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
sinh = unsafePerformIO . cast1 ATen.sinh_t

-- | Element-wise subtraction of one tensor from another:
-- \[
-- \mathrm{output}_i = \mathrm{input}_i - \mathrm{other}_i.
-- \]
-- The result is returned as a new tensor.
--
-- The shape of 'other' must be broadcastable with the shape of 'input'.
-- See 'subScalar' for a version of this function where
-- the 'other' input is a scalar.
sub ::
  forall requiresGradient layout device dataType shape requiresGradient' layout' device' dataType' shape'.
  -- | input tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | other tensor
  Tensor requiresGradient' layout' device' dataType' shape' ->
  -- | output tensor
  Tensor
    (requiresGradient <|> requiresGradient)
    (layout <+> layout')
    (device <+> device')
    (dataType <+> dataType')
    (BroadcastShapesF shape shape')
input `sub` other = unsafePerformIO $ cast2 ATen.sub_tt input other

-- | Subtracts a scalar 'other' from a tensor 'input':
-- \[
-- \mathrm{output}_i = \mathrm{input}_i - \mathrm{other}.
-- \]
-- The result is returned as a new tensor.
-- See 'sub' for a version of this function where
-- the second argument is a tensor.
subScalar ::
  forall other requiresGradient layout device dataType shape.
  (Scalar other) =>
  -- | input tensor
  Tensor requiresGradient layout device dataType shape ->
  -- | input scalar
  other ->
  -- | output tensor
  Tensor requiresGradient layout device dataType shape
input `subScalar` other = unsafePerformIO $ cast2 ATen.sub_ts input other

-- | Returns a new tensor with the square-root of the elements of 'input':
-- \[
-- \mathrm{output}_i = \sqrt{\mathrm{input}_i}.
-- \]
sqrt ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
sqrt = unsafePerformIO . cast1 ATen.sqrt_t

-- | Returns a new tensor with the square of the elements of 'input':
-- \[
-- \mathrm{output}_i = \mathrm{input}_i^2.
-- \]
--
-- See 'pow', 'powScalar', or 'powTensor' for exponentiation with respect to arbitrary exponents.
square ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
square = unsafePerformIO . cast1 ATen.square_t

-- | Returns a new tensor with the tangent of the elements of 'input':
-- \[
-- \mathrm{output}_i = \tan \left(\mathrm{input}_i\right).
-- \]
tan ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
tan = unsafePerformIO . cast1 ATen.tan_t

-- | Returns a new tensor with the hyperbolic tangent of the elements of 'input':
-- \[
-- \mathrm{output}_i = \tanh \left(\mathrm{input}_i\right).
-- \]
tanh ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
tanh = unsafePerformIO . cast1 ATen.tanh_t

-- | Performs “true division”
-- that always computes the division in floating point:
-- \[
-- \mathrm{output}_i = \frac{\mathrm{dividend}_i}{\mathrm{divisor}_i}.
-- \]
--
-- 'trueDivide' is completely equivalent to division using 'div'
-- except when both inputs have 'Bool' or integer data types,
-- in which case the inputs are converted to floating data types
-- before performing the division.
--
-- See 'trueDivideScalar' for a version of this function
-- where the divisor is a scalar.
trueDivide ::
  forall requiresGradient layout device dataType shape requiresGradient' layout' device' dataType' shape'.
  -- | tensor dividend
  Tensor requiresGradient layout device dataType shape ->
  -- | tensor divisor
  Tensor requiresGradient' layout' device' dataType' shape' ->
  -- | tensor output
  Tensor
    (requiresGradient <|> requiresGradient')
    (layout <+> layout')
    (device <+> device')
    (dataType <+> dataType')
    (shape <+> shape')
dividend `trueDivide` divisor = unsafePerformIO $ cast2 ATen.true_divide_tt dividend divisor

-- | Performs “true division”
-- that always computes the division in floating point:
-- \[
-- \mathrm{output}_i = \frac{\mathrm{dividend}_i}{\mathrm{divisor}}.
-- \]
--
-- 'trueDivideScalar' is completely equivalent to division using 'divScalar'
-- except when both inputs have 'Bool' or integer data types,
-- in which case the inputs are converted to floating data types
-- before performing the division.
--
-- See 'trueDivide' for a version of this function
-- where the divisor is a tensor.
trueDivideScalar ::
  forall other requiresGradient layout device dataType shape.
  (Scalar other) =>
  -- | tensor dividend
  Tensor requiresGradient layout device dataType shape ->
  -- | scalar divisor
  other ->
  -- | tensor output
  Tensor requiresGradient layout device dataType shape
dividend `trueDivideScalar` divisor = unsafePerformIO $ cast2 ATen.true_divide_ts dividend divisor

-- Returns a new tensor with the truncated integer values of the elements of 'input'.
--
-- Note that the data type of the 'output' tensor matches that of the 'input'.
trunc ::
  forall requiresGradient layout device dataType shape.
  -- | input
  Tensor requiresGradient layout device dataType shape ->
  -- | output
  Tensor requiresGradient layout device dataType shape
trunc = unsafePerformIO . cast1 ATen.trunc_t
