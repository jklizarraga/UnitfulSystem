################################################################################
################################# Definition ###################################
################################################################################

struct UnitfulQuantity{T<:Real,U<:Unit}
    val::T
    UnitfulQuantity(x::T,::Type{U}) where {T<:Real,U<:Unit} = new{T,U}(x)
end
UnitfulQuantity(x::Real        )      = UnitfulQuantity(x, Unitless )
( ::Type{U})(x::Real) where {U<:Unit} = UnitfulQuantity(x, U        )

# const ScalarQuantity    = UnitfulQuantity{T, S} where {T<:Real, S<:Scalar}
ScalarQuantity(x::Real) = UnitfulQuantity(x, Unitless)

isunit(x::UnitfulQuantity{<:Real,U1},  ::Type{U2}) where {U1<:Unit,U2<:Unit} = (U1<:U2)

 getunit(x::UnitfulQuantity{<:Real,U     }) where {U<:Unit} = U
quantity(x::UnitfulQuantity{<:Real,<:Unit})                 = x.val

export UnitfulQuantity, ScalarQuantity, isunit, getunit, quantity

# Pretty printing
import Base: show
function show(io::IO,x::UnitfulQuantity{<:Real,U}) where {U<:Unit}
    show(io,x.val)
    print(io," ")
    show(io,U)
end

function show(io::IO, ::MIME"text/plain", x::UnitfulQuantity{T,U}) where {T<:Real,U<:Unit}
    print("{"); show(T); print("} ")
    show(io,x.val)
    print(io," ")
    show(io,U)
end

################################################################################
########################## Conversion and Promotion ############################
################################################################################
import Base: convert, promote_rule, *

*(x::Real,  ::Type{U}) where {U<:Unit} = UnitfulQuantity(x,U)

convert(::Type{UnitfulQuantity}     , x::Real                     )                         = ScalarQuantity(x)
convert(::Type{UnitfulQuantity{T,U}}, x::Real                     ) where {T<:Real,U<:Unit} = UnitfulQuantity(convert(T,x    ),U)
convert(::Type{UnitfulQuantity{T,U}}, x::UnitfulQuantity{<:Real,U}) where {T<:Real,U<:Unit} = UnitfulQuantity(convert(T,x.val),U)

promote_rule(::Type{UnitfulQuantity{T,U}}, ::Type{<:Real}              ) where {T<:Real,U<:Unit} = UnitfulQuantity
promote_rule(::Type{UnitfulQuantity{T,U}}, ::Type{UnitfulQuantity{R,U}}) where {T<:Real,R<:Real,U<:Unit} = UnitfulQuantity{promote_type(T,R),U}

################################################################################
################################# Operations ###################################
################################################################################
if @isdefined Units
    # Unary operations
    const operationsUnary_Quantity_sameUnit       = Units.operationsUnary_sameUnit
    const operationsUnary_Quantity_sameUnit_other = Units.operationsUnary_sameUnit_other
    const operationsUnary_Quantity_otherUnit      = Units.operationsUnary_otherUnit
    const operationsUnary_info                    = (:sign, :signbit, :isinteger, :isinf, :isfinite, :isnan) # --> These do not produce a quantity, but they need a quantity and do not depend on the Unit.
    # Operations between quantities
    const operationsBetweenQuantities_sameUnit    = Units.operationsBetweenUnits_sameUnit
    const operationsBetweenQuantities_otherUnit   = Units.operationsBetweenUnits_otherUnit
    # Operations with scalars
    const operationsQuantityScalar                = Units.operationsUnitScalar
    const operationsQuantityScalar_other          = (:^,)
    const operationsScalarQuantity                = Units.operationsBetweenUnits_otherUnit
    # Operations for comparison of quantities
    const operationsComparison                    = (Symbol("=="), :≠, :<, :≤, :>, :≥, :isless) # --> These do not produce a quantity, but they need a quantity and DO depend on the Unit. They are taken care of at method() level.
    const operationsComparison_other              = (:isapprox,)                                # --> These do not produce a quantity, but they need a quantity and DO depend on the Unit. They are taken care of at method() level.
else
    # Unary operations
    const operationsUnary_Quantity_sameUnit       = operationsUnary_sameUnit
    const operationsUnary_Quantity_sameUnit_other = operationsUnary_sameUnit_other
    const operationsUnary_Quantity_otherUnit      = operationsUnary_otherUnit
    const operationsUnary_info                    = (:sign, :signbit, :isinteger, :isinf, :isfinite, :isnan) # --> These do not produce a quantity, but they need a quantity and do not depend on the Unit.
    # Operations between quantities
    const operationsBetweenQuantities_sameUnit    = operationsBetweenUnits_sameUnit
    const operationsBetweenQuantities_otherUnit   = operationsBetweenUnits_otherUnit
    # Operations with scalars
    const operationsQuantityScalar                = operationsUnitScalar
    const operationsQuantityScalar_other          = (:^,)
    const operationsScalarQuantity                = operationsBetweenUnits_otherUnit
    # Operations for comparison of quantities
    const operationsComparison                    = (Symbol("=="), :≠, :<, :≤, :>, :≥, :isless) # --> These do not produce a quantity, but they need a quantity and DO depend on the Unit. They are taken care of at method() level.
    const operationsComparison_other              = (:isapprox,)                                # --> These do not produce a quantity, but they need a quantity and DO depend on the Unit. They are taken care of at method() level.
end

############################### Unary operations ###############################

for op in operationsUnary_Quantity_sameUnit
    @eval import Base: $op
    @eval $op(x::UnitfulQuantity{<:Real,U}) where {U<:Unit} = UnitfulQuantity($op(x.val),U)
end
zero(::Type{UnitfulQuantity{T,U}}) where {T<:Real,U<:Unit} = UnitfulQuantity(zero(T),U)

for op in operationsUnary_Quantity_sameUnit_other
    @eval import Base: $op
    @eval $op(x::UnitfulQuantity{<:Real,U}, varargs...) where {U<:Unit} = UnitfulQuantity($op(x.val, varargs...),U)
end
#round(x::UnitfulQuantity{T,U}, r::RoundingMode) where {T<:Real,U<:Unit} = UnitfulQuantity(round(x.val,r), U)

for op in operationsUnary_Quantity_otherUnit
    @eval import Base: $op
    @eval $op(x::UnitfulQuantity{<:Real,U}) where {U<:Unit} = UnitfulQuantity($op(x.val),$op(U))
end
one(::Type{UnitfulQuantity{T,<:Unit}}) where {T<:Real} = ScalarQuantity(one(T))

for op in operationsUnary_info
    @eval import Base: $op
    @eval $op(x::UnitfulQuantity) = $op(x.val)
end

############################# Non-Unary operations #############################

for op in operationsBetweenQuantities_sameUnit
    @eval import Base: $op
    @eval $op(x::UnitfulQuantity{<:Real,U}, y::UnitfulQuantity{<:Real,U}) where {U<:Unit} = UnitfulQuantity($op(x.val,y.val),U)
end

################################################################################
################################### SCALARS ####################################
################################################################################

for op in operationsQuantityScalar
    @eval import Base: $op
    @eval $op(x::UnitfulQuantity{<:Real,U}, y::UnitfulQuantity{<:Real,<:Unitless}) where {U<:Unit} = UnitfulQuantity($op(x.val,y.val),U)
    @eval $op(x::UnitfulQuantity{<:Real,U}, y::Real                              ) where {U<:Unit} = UnitfulQuantity($op(x.val,y    ),U)
    # The line above could be replaced by the more elegant, but probably less peformant:
    # @eval $op(x::UnitfulQuantity{T,U}, y::Real) where {T<:Real,U<:Unit} = $op(promote(x,y)...)
end

import Base: \, ^
\(x::UnitfulQuantity{<:Real,U}, y::UnitfulQuantity{<:Real  ,<:Unitless}) where {U<:Unit} = UnitfulQuantity(x.val\y.val,inv(U) )
\(x::UnitfulQuantity{<:Real,U}, y::Real                                ) where {U<:Unit} = UnitfulQuantity(x.val\y    ,inv(U) )
^(x::UnitfulQuantity{<:Real,U}, y::UnitfulQuantity{Integer ,<:Unitless}) where {U<:Unit} = UnitfulQuantity(x.val^y.val,U^y.val)
^(x::UnitfulQuantity{<:Real,U}, y::UnitfulQuantity{Rational,<:Unitless}) where {U<:Unit} = UnitfulQuantity(x.val^y.val,U^y.val)
^(x::UnitfulQuantity{<:Real,U}, y::Integer                             ) where {U<:Unit} = UnitfulQuantity(x.val^y    ,U^y    )
^(x::UnitfulQuantity{<:Real,U}, y::Rational                            ) where {U<:Unit} = UnitfulQuantity(x.val^y    ,U^y    )

# The operations between a scalar and a quantity (contained in operationsScalarQuantity) need to be treated case by case. They cannot be addressed systematically.
import Base: *, /, \
*(y::UnitfulQuantity{<:Real,<:Unitless}, x::UnitfulQuantity{<:Real,U}) where {U<:Unit} = UnitfulQuantity(y.val*x.val,    U )
*(y::Real                              , x::UnitfulQuantity{<:Real,U}) where {U<:Unit} = UnitfulQuantity(y    *x.val,    U )
/(y::UnitfulQuantity{<:Real,<:Unitless}, x::UnitfulQuantity{<:Real,U}) where {U<:Unit} = UnitfulQuantity(y.val/x.val,inv(U))
/(y::Real                              , x::UnitfulQuantity{<:Real,U}) where {U<:Unit} = UnitfulQuantity(y    /x.val,inv(U))
\(y::UnitfulQuantity{<:Real,<:Unitless}, x::UnitfulQuantity{<:Real,U}) where {U<:Unit} = UnitfulQuantity(y.val/x.val,    U )
\(y::Real                              , x::UnitfulQuantity{<:Real,U}) where {U<:Unit} = UnitfulQuantity(y    /x.val,    U )

################################################################################
#################################### ARRAYS ####################################
################################################################################

UnitfulQuantity(a::T, ::Type{U}) where {T<:AbstractArray{S,D} where {S<:Real,D},U<:Unit} = UnitfulQuantity.(a,U)
UnitfulQuantity(a::T,u::U      ) where {T<:AbstractArray{S,D} where {S<:Real,D},U<:Unit} = UnitfulQuantity.(a,U)
(::Type{U})(a::T)                where {U<:Unit,T<:AbstractArray{S,D} where {S<:Real,D}} = UnitfulQuantity.(a,U)
*(a::T,  ::Type{U} )             where {T<:AbstractArray{S,D} where {S<:Real,D},U<:Unit} = UnitfulQuantity.(a,U)
*(a::T, u::U       )             where {T<:AbstractArray{S,D} where {S<:Real,D},U<:Unit} = UnitfulQuantity.(a,U)

################################################################################
#################################### RANGES ####################################
################################################################################

import Base: iterate, IteratorSize, IteratorEltype, eltype, length, size, step, getindex
export UnitfulQuantityRange

struct UnitfulQuantityRange{T<:Real, U<:Unit}
    r::AbstractRange{T}
    UnitfulQuantityRange(r::AbstractRange{T},::Type{U}) where {T<:Real,U<:Unit} = new{T,U}(r)
end
UnitfulQuantityRange(r::AbstractRange{T},u::U) where {T<:Real,U<:Unit} = UnitfulQuantityRange(r,U)

(::Type{U})(r::AbstractRange{<:Real}   ) where {U<:Unit} = UnitfulQuantityRange(r,U)
*(r::AbstractRange{<:Real},  ::Type{U} ) where {U<:Unit} = UnitfulQuantityRange(r,U)
*(r::AbstractRange{<:Real}, u::U       ) where {U<:Unit} = UnitfulQuantityRange(r,U)

function iterate(rangeOfUnitfulQuantities::UnitfulQuantityRange{T,U}) where {T<:Real,U<:Unit}
    result = iterate(rangeOfUnitfulQuantities.r)
    result ≠ nothing ? (return (U(result[1]), result[2])) : (return nothing)
end

function iterate(rangeOfUnitfulQuantities::UnitfulQuantityRange{T,U}, state) where {T<:Real,U<:Unit}
    result = iterate(rangeOfUnitfulQuantities.r, state)
    result ≠ nothing ? (return (U(result[1]), result[2])) : (return nothing)
end

    step(rangeOfUnitfulQuantities::UnitfulQuantityRange{T,U}         ) where {T<:Real,U<:Unit} = U(    step(rangeOfUnitfulQuantities.r         ))
getindex(rangeOfUnitfulQuantities::UnitfulQuantityRange{T,U}, inds...) where {T<:Real,U<:Unit} = U(getindex(rangeOfUnitfulQuantities.r, inds...))

Base.eltype(                   ::Type{UnitfulQuantityRange{T,U}}) where {T<:Real,U<:Unit} = UnitfulQuantity{T,U}
Base.IteratorSize(             ::Type{UnitfulQuantityRange{T,U}}) where {T<:Real,U<:Unit} = Base.IteratorSize(AbstractRange{Real})
Base.IteratorEltype(           ::Type{UnitfulQuantityRange{T,U}}) where {T<:Real,U<:Unit} = Base.HasEltype()
Base.length(rangeOfUnitfulQuantities::UnitfulQuantityRange{T,U} ) where {T<:Real,U<:Unit} = length(rangeOfUnitfulQuantities.r)
Base.size(  rangeOfUnitfulQuantities::UnitfulQuantityRange{T,U} ) where {T<:Real,U<:Unit} = size(rangeOfUnitfulQuantities.r)
