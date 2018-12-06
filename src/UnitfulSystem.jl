module UnitfulSystem

# module Units
# include("UnitsCore.jl")
# end
#
# using .Units
# include("UnitfulQuantitiesCore.jl")

include("UnitsCore.jl")
include("UnitfulQuantitiesCore.jl")

################################################################################
########################## Unit System Extensions ##############################
################################################################################
module PhysicalBase
   using ..UnitfulSystem
   include("PhysicalUnitsCore.jl")
   include("PhysicalQuantitiesCore.jl")
end #PhysicalBase

module SIBase
    using ..PhysicalBase
    include("SIBaseUnitsCore.jl")
#
#     import Base: convert, promote_rule
#     Base.convert(::Type{UnitfulQuantity{T,SIBaseUnit}}, x::UnitfulQuantity{<:Real,SIBaseUnit{Type{m},Type{kg},Type{s},Type{A},Type{K},Type{mol},Type{cd}}}) where {T<:Real,m,kg,s,A,K,mol,cd} = UnitfulQuantity(convert(T,x.val),SIBaseUnit(m,kg,s,A,K,mol,cd))
#     Base.convert(::Type{UnitfulQuantity{T,Unitless  }}, x::UnitfulQuantity{<:Real,SIScalar}) where {T<:Real} = UnitfulQuantity(convert(T,x.val),Unitless)
#
#     promote_rule(::Type{UnitfulQuantity{T,Unitless}},::Type{UnitfulQuantity{R,SIScalar}}) where {T<:Real,R<:Real} = UnitfulQuantity{promote_type(T,R), Unitless}
#
#     if @isdefined Units
#        operationsBetweenUnits_otherUnit      = Units.operationsBetweenUnits_otherUnit
#        operationsBetweenQuantities_sameUnit  = Units.operationsBetweenUnits_sameUnit
#        operationsBetweenQuantities_otherUnit = Units.operationsBetweenUnits_otherUnit
#     elseif @isdefined UnitfulSystem
#        operationsBetweenUnits_otherUnit      = UnitfulSystem.operationsBetweenUnits_otherUnit
#        operationsBetweenQuantities_sameUnit  = UnitfulSystem.operationsBetweenQuantities_sameUnit
#        operationsBetweenQuantities_otherUnit = UnitfulSystem.operationsBetweenQuantities_otherUnit
#     else
#        operationsBetweenUnits_otherUnit      = (:*, :/, :\)
#        operationsBetweenQuantities_sameUnit  = (:+,:-)
#        operationsBetweenQuantities_otherUnit = operationsBetweenUnits_otherUnit
#     end
#     @generatecode_operations_quantity "SIBaseUnit" ["m","kg","s","A","K","mol","cd"]
#
#     Base.show(io::IO,x::UnitfulQuantity{<:Real,U}) where {U<:SIBaseUnit} = print(io, x.val, " ", U )

end # module SIBase
#
# module SIDerived
#     using ..UnitfulSystem
#     using ..SIBase
#     include("SIDerivedCore.jl")
# end
#
# module SIPrefixes
#     using ..UnitfulSystem
#     using ..SIBase
#     include("SIPrefixesCore.jl")
# end
#
# module Angles
#     using ..UnitfulSystem
#
#     include("AngularUnitsCore.jl")
#     include("AnglesCore.jl")
# end # module Angles

################################################################################
############################## Unit Extensions #################################
################################################################################

# module SIBaseUnits
#     using ..Units
#     export Unit
#
#     include("SIBaseUnitsCore.jl")
#
#     addunit_scalar(SIScalar)
#     export Scalar
#     for phyUnit in Units.physicalUnits
#         func = Symbol("addunit_"*lowercase(String(phyUnit)))
#         @eval $func($(siUnitDic[phyUnit]))
#         @eval export $phyUnit
#     end
# end #SIBaseUnits
#
# module AngularUnits
#     using ..Units
#     include("AngularUnitsCore.jl")
# end #AngularUnits

# module IMBaseUnits
#     using ..Units
#     struct IMScalar <: Unit end
#     addunit_scalar(IMScalar)
#     export Unit, Scalar
# end

################################################################################
############################ Quantity Extensions ###############################
################################################################################

# module Angles
#     # using ..AngularUnits
#     using ..Units
#     include("AngularUnitsCore.jl")
#
#     using ..UnitfulQuantities
#
#     include("AnglesCore.jl")
# end #Angles


end # module UnitfulSystem
