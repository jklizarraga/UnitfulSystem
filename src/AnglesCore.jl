if @isdefined UnitfulQuantities
    operationsBetweenQuantities_sameUnit  = UnitfulQuantities.operationsBetweenQuantities_sameUnit
    operationsBetweenQuantities_otherUnit = UnitfulQuantities.operationsBetweenQuantities_otherUnit
elseif @isdefined UnitfulSystem
    operationsBetweenQuantities_sameUnit  = UnitfulSystem.operationsBetweenQuantities_sameUnit
    operationsBetweenQuantities_otherUnit = UnitfulSystem.operationsBetweenQuantities_otherUnit
else
    operationsBetweenQuantities_sameUnit  = (:+,:-)
    operationsBetweenQuantities_otherUnit = (:*,:/,:\)
end

import Base: deg2rad, rad2deg
import Base: convert, promote_rule, show

const asciiRepresentation = Dict("Degree"=>"º"   , "Radian"=>"rad")
const  htmlRepresentation = Dict("Degree"=>"&deg", "Radian"=>"rad")

for angularUnit in (:Degree, :Radian)
    @eval begin
        # Pretty printing
        Base.show(io::IO,                     x::UnitfulQuantity{<:Real,$angularUnit})                 = print(io, x.val, asciiRepresentation[$(String(angularUnit))])
        Base.show(io::IO, ::MIME"text/plain", x::UnitfulQuantity{T     ,$angularUnit}) where {T<:Real} = print(io, "Angle in ",$(String(angularUnit)*"s"),"{$T}: ", x, "\n")
        Base.show(io::IO, ::MIME"text/html" , x::UnitfulQuantity{T     ,$angularUnit}) where {T<:Real} = print(io, x.val, htmlRepresentation[$(String(angularUnit)*"s")] ," [<code>",$(String(angularUnit)),"{$T}</code>]")
    end
end

################################################################################
########################## Conversion and Promotion ############################
################################################################################

deg2rad(x::UnitfulQuantity{<:Real,Degree}) = Radian(deg2rad(x.val))
rad2deg(x::UnitfulQuantity{<:Real,Radian}) = Degree(rad2deg(x.val))
convert(::Type{UnitfulQuantity{T,Radian}}, x::UnitfulQuantity{<:Real,Degree}) where {T<:Real} = Radian(convert(T,deg2rad(x.val)))
convert(::Type{UnitfulQuantity{T,Degree}}, x::UnitfulQuantity{<:Real,Radian}) where {T<:Real} = Degree(convert(T,rad2deg(x.val)))

promote_rule(::Type{UnitfulQuantity{T,Radian}},::Type{UnitfulQuantity{R,Degree}}) where {T<:Real,R<:Real} = UnitfulQuantity{AbstractFloat,Radian}

################################################################################
################################## Operations ##################################
################################################################################

# Arithmetic operations
for op in operationsBetweenQuantities_sameUnit
    @eval import Base: $op
    @eval $op(x::UnitfulQuantity{<:Real,U},y::UnitfulQuantity{<:Real,U}) where {U<:Angle2D} = U($op(x.val,y.val))
    @eval $op(x::UnitfulQuantity{<:Real,U},y::UnitfulQuantity{<:Real,V}) where {U<:Angle2D,V<:Angle2D} = $op(promote(x,y)...) # This case forces to redefine the operation with the line above to avoid overflow.
end

for op in operationsBetweenQuantities_otherUnit
    @eval import Base: $op
    @eval $op(x::UnitfulQuantity{<:Real,U},y::UnitfulQuantity{<:Real,U}) where {U<:Angle2D} = UnitfulQuantity($op(x.val,y.val),$op(U,U))
    @eval $op(x::UnitfulQuantity{<:Real,U},y::UnitfulQuantity{<:Real,V}) where {U<:Angle2D,V<:Angle2D} = $op(promote(x,y)...) # This case forces to redefine the operation with the line above to avoid overflow.
end

# Trigonometric operations
const operationsTrigonometric = ( :sin,  :cos,  :tan,  :csc,  :sec,  :cot)
const operationsTrigoOther    = (:sinpi, :cospi, :sinc, :cosc)
const operationsOther         = (:sincos,:rem2pi)

const operationsTrigoInvRad   = (:asin, :acos, :atan, :acsc, :asec, :acot)
const operationsTrigoInvDeg   = Symbol.(operationsTrigoInvRad,"d")
const operationsTrigoInverse  = (operationsTrigoInvRad..., operationsTrigoInvDeg...)
const operationsInverse       = (operationsTrigoInverse..., :angle)

## Basic Trigonometric operations
for fun in operationsTrigonometric
    @eval import Base: $fun
    @eval $fun(x::UnitfulQuantity{<:Real,Radian}) = $fun(x.val)
    @eval $fun(x::UnitfulQuantity{<:Real,Degree}) = $(Symbol(fun,'d'))(x.val)
end

import Base: sincos
sincos(x::UnitfulQuantity{<:Real,<:Angle2D}) = (sin(x),cos(x))

## Other Trigonometric operations
for fun in operationsTrigoOther
    @eval import Base: $fun
    @eval $fun(x::UnitfulQuantity{<:Real,Radian}) = $fun(x.val)
end

import Base: rem2pi
rem2pi(x::UnitfulQuantity{<:Real,Degree}, r::RoundingMode) = Degree(rad2deg(rem2pi(deg2rad(x.val),r)))
rem2pi(x::UnitfulQuantity{<:Real,Radian}, r::RoundingMode) = Radian(rem2pi(x.val,r))

## Inverse Trigonometric operations
for op in operationsInverse
    @eval export $(Symbol(op,'_'))
end

for fun in operationsTrigoInvRad
    @eval $(Symbol(fun,'_'))(x::Real) = Radian(Base.Math.$fun(x))
end

for fun in operationsTrigoInvDeg
    @eval $(Symbol(fun,'_'))(x::Real) = Degree(Base.Math.$fun(x))
end

atan_( y::Real, x::Real) = Radian(Base.Math.atan( x,y))
atand_(y::Real, x::Real) = Degree(Base.Math.atand(x,y))

angle_( x::Complex) = Radian(Base.Math.angle(x))
angled_(x::Complex) = Degree(Base.Math.angle(x))
