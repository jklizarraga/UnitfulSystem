################################################################################
################################## Definition ##################################
################################################################################

abstract type KiloMeter{𝐋} <: PhysicalUnit{𝐋,0,0,0,0,0,0} end
const Kilometer = const kilometer = const km = KiloMeter{1}

export Kilometer, kilometer, km

import Base: convert, promote_rule, show

convert(::Type{UnitfulQuantity{T,SIBaseUnit{𝐋,0,0,0,0,0,0}}}, x::UnitfulQuantity{<:Real,KiloMeter{𝐋}}) where {T<:Real,𝐋} = UnitfulQuantity(convert(T,x.val * 1000^𝐋),SIBaseUnit{𝐋,0,0,0,0,0,0})
convert(::Type{UnitfulQuantity{T,SIBaseUnit               }}, x::UnitfulQuantity{<:Real,KiloMeter{𝐋}}) where {T<:Real,𝐋} = UnitfulQuantity(convert(T,x.val * 1000^𝐋),SIBaseUnit{𝐋,0,0,0,0,0,0})
# convert(::Type{UnitfulQuantity{T,SIBaseUnit{m,kg,s,A,K,mol,cd}}}, x::UnitfulQuantity{<:Real,Kilometer}) where {T<:Real,m,kg,s,A,K,mol,cd} = Meter(convert(T,x.val * 1000))

promote_rule(::Type{UnitfulQuantity{T,SIBaseUnit{𝐋,0 ,0,0,0,0  ,0 }}},::Type{UnitfulQuantity{R,KiloMeter{𝐋}}}) where {T<:Real,R<:Real,                  𝐋} = UnitfulQuantity{promote_type(T,R), SIBaseUnit{𝐋,0,0,0,0,0,0}}
promote_rule(::Type{UnitfulQuantity{T,SIBaseUnit{m,kg,s,A,K,mol,cd}}},::Type{UnitfulQuantity{R,KiloMeter{𝐋}}}) where {T<:Real,R<:Real,m,kg,s,A,K,mol,cd,𝐋} = UnitfulQuantity{promote_type(T,R), SIBaseUnit               }

Base.show(io::IO,::Type{KiloMeter{𝐋}}) where {𝐋} = (print("km"*(𝐋==1 ? "" : SIBase.tosuperscript(𝐋))))

################################################################################
################################## Operations ##################################
################################################################################
if @isdefined Units
   operationsBetweenUnits_otherUnit      = Units.operationsBetweenUnits_otherUnit
   operationsBetweenQuantities_sameUnit  = Units.operationsBetweenUnits_sameUnit
   operationsBetweenQuantities_otherUnit = Units.operationsBetweenUnits_otherUnit
elseif @isdefined UnitfulSystem
   operationsBetweenUnits_otherUnit      = UnitfulSystem.operationsBetweenUnits_otherUnit
   operationsBetweenQuantities_sameUnit  = UnitfulSystem.operationsBetweenQuantities_sameUnit
   operationsBetweenQuantities_otherUnit = UnitfulSystem.operationsBetweenQuantities_otherUnit
else
   operationsBetweenUnits_otherUnit      = (:*, :/, :\)
   operationsBetweenQuantities_sameUnit  = (:+,:-)
   operationsBetweenQuantities_otherUnit = operationsBetweenUnits_otherUnit
end
# 
# const operationsBetweenUnits_otherUnit      = UnitfulSystem.operationsBetweenUnits_otherUnit
# const operationsBetweenQuantities_otherUnit = UnitfulSystem.operationsBetweenQuantities_otherUnit

@generatecode_operations_unit "KiloMeter" ["km"]
@generatecode_operations_quantity "KiloMeter" ["km"]
