################################################################################
################################## Definition ##################################
################################################################################
abstract type Unit end
export Unit

import Base: show
Base.show(io::IO,::Type{Unit}) = print("(Generic Unit)")

################################################################################
################################## Operations ##################################
################################################################################

# Unary operations
const operationsUnary_sameUnit        = (:+, :-, :abs, :abs2, :floor, :ceil, :trunc, :zero)      # --> It is safe for the module Units to defien these operations
const operationsUnary_sameUnit_other  = (:round,)                                                # --> It is safe for the module Units to defien these operations
# Operations between units
const operationsBetweenUnits_sameUnit = (:+, :-)                                                 # --> It is safe for the module Units to defien these operations

# Generic support of operations between Units regardless the specific Unit
for op in (operationsUnary_sameUnit..., operationsUnary_sameUnit_other...)
   @eval import Base: $op
   @eval $op(::Type{U}) where {U<:Unit} = U
end

for op in operationsBetweenUnits_sameUnit
   @eval import Base: $op
   @eval $op(::Type{U}, ::Type{U}) where {U<:Unit} = U
end

# Interface: the following operations need to be defined by any new set of Units
const operationsUnary_otherUnit        = (:√, :∛, :inv, :one)
const operationsBetweenUnits_otherUnit = (:*, :/, :\)

################################################################################
################################### SCALARS ####################################
################################################################################

include("ScalarsCore.jl")
