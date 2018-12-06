################################################################################
################################## Definition ##################################
################################################################################

abstract type Unitless <: Unit end
export Unitless

import Base: show
Base.show(io::IO,::Type{Unitless}) = print("(Unitless)")

################################################################################
################################## Operations ##################################
################################################################################

#################### Module Units interface implementation #####################

## Unary operations
# In the particular case of Scalars, the unary operations that would normally
# produce a different unit (e.g. √, ∛, inv, one), produce a Scalar
# (i.e. otherUnit = Scalar = sameUnit).
for op in operationsUnary_otherUnit
   @eval import Base: $op
   @eval $op(::Type{S}) where {S<:Unitless} = S
end

## Operations ScalarUnit
# In the particular case of Scalars, the operations between a Scalar and a Unit
# need to be treated case by case because they do not produce the same result.
for op in operationsBetweenUnits_otherUnit #(:*, :/, :\)
   @eval import Base: $op
end
*(::Type{<:Unitless}, ::Type{U}) where {U<:Unit} = U
\(::Type{<:Unitless}, ::Type{U}) where {U<:Unit} = U
/(::Type{<:Unitless}, ::Type{U}) where {U<:Unit} = inv(U)

########## Implementation of operations which are specific of Scalars ##########

## Operations UnitScalar
# Generic support to operations between a Unit and a Scalar
const operationsUnitScalar = (:*, :/, :÷, :%, :mod, :fld, :cld) # :rem already covered by :%

for op in operationsUnitScalar
   @eval import Base: $op
   @eval $op(::Type{U}, ::Type{<:Unitless}) where {U<:Unit} = U
end
\(::Type{U}, ::Type{<:Unitless}) where {U<:Unit} = inv(U) # --> Any Unit needs to support inv()

# The ^() operator needs a quantity, therefore it is not defined here
