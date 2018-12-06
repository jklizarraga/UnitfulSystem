if @isdefined Units
   operationsUnary_otherUnit        = Units.operationsUnary_otherUnit
   operationsBetweenUnits_otherUnit = Units.operationsBetweenUnits_otherUnit
elseif @isdefined UnitfulSystem
   operationsUnary_otherUnit        = UnitfulSystem.operationsUnary_otherUnit
   operationsBetweenUnits_otherUnit = UnitfulSystem.operationsBetweenUnits_otherUnit
else
   operationsUnary_otherUnit        = (:√, :∛, :inv, :one)
   operationsBetweenUnits_otherUnit = (:*, :/, :\)
end

################################################################################
################################# Definition ###################################
################################################################################

abstract type Angle2D <: Unit end
abstract type Angle3D <: Unit end

struct Degree <: Angle2D end
const degree      = Degree
const deg = º = ° = Degree()

struct Radian <: Angle2D end
const radian = Radian
const rad    = Radian()

################################################################################
################################## Operations ##################################
################################################################################

# Unary operations which are not covered by module Units.
const resultUnary = Dict(:√   => :(error("Square root of Angle2D units is not allowed.")),
                         :∛   => :(error("Cubic root of Angle2D units is not allowed." )),
                         :inv => :(error("Inverse of Angle2D units is not allowed."    )),
                         :one => :(Unitless                                             ))

for op in operationsUnary_otherUnit #(:√, :∛, :inv, :one)
    @eval import Base: $op
    @eval $op( ::Type{<:Angle2D}) = $(resultUnary[op])
    @eval $op(a::Angle2D        ) = $(resultUnary[op])
end

# Operations between Angles2D of the same Type, which are not covered by module Units.
const resultNotUnary = Dict(:* => :(error("Multiplication of Angle2D units is not allowed.")),
                            :/ => :(Unitless                                                ),
                            :\ => :(Unitless                                                ))

for op in operationsBetweenUnits_otherUnit #(:*, :/, :\)
    @eval import Base: $op
    @eval $op( ::Type{U},  ::Type{U}) where {U<:Angle2D} = $(resultNotUnary[op])
    @eval $op(u::U      ,  ::Type{U}) where {U<:Angle2D} = $(resultNotUnary[op])
    @eval $op( ::Type{U}, u::U      ) where {U<:Angle2D} = $(resultNotUnary[op])
    @eval $op(u::U      , v::U      ) where {U<:Angle2D} = $(resultNotUnary[op])
end

import Base: ^
^(::Type{U}, i::Union{Integer,Rational}) where {U<:Angle2D} = error("Powers of Angle2D are not allowed.")
^(     ::U , i::Union{Integer,Rational}) where {U<:Angle2D} = error("Powers of Angle2D are not allowed.")

################################################################################
################################## Exports #####################################
################################################################################

const toExport = (:Angle2D, :Degree, :degree, :deg, :º, :°, :Radian, :radian, :rad)
for item in toExport
    @eval export $item
end
