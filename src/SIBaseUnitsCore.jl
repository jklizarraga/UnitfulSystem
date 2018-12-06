################################################################################
################################## Definition ##################################
################################################################################

abstract type SIBaseUnit{𝐋<:Int,𝐌<:Int,𝐓<:Int,𝐈<:Int,𝚯<:Int,𝐍<:Int,𝐉<:Int} <: PhysicalUnit{𝐋,𝐌,𝐓,𝐈,𝚯,𝐍,𝐉} end
SIBaseUnit(𝐋::Int    ,𝐌::Int    ,𝐓::Int    ,𝐈::Int    ,𝚯::Int    ,𝐍::Int    ,𝐉::Int    ) = SIBaseUnit{Type{    𝐋 },Type{    𝐌 },Type{    𝐓 },Type{    𝐈 },Type{    𝚯 },Type{    𝐍 },Type{    𝐉 }}
SIBaseUnit(𝐋::Integer,𝐌::Integer,𝐓::Integer,𝐈::Integer,𝚯::Integer,𝐍::Integer,𝐉::Integer) = SIBaseUnit{Type{Int(𝐋)},Type{Int(𝐌)},Type{Int(𝐓)},Type{Int(𝐈)},Type{Int(𝚯)},Type{Int(𝐍)},Type{Int(𝐉)}}
SIBaseUnit(𝐋::Real   ,𝐌::Real   ,𝐓::Real   ,𝐈::Real   ,𝚯::Real   ,𝐍::Real   ,𝐉::Real   ) = SIBaseUnit{Type{Int(𝐋)},Type{Int(𝐌)},Type{Int(𝐓)},Type{Int(𝐈)},Type{Int(𝚯)},Type{Int(𝐍)},Type{Int(𝐉)}}


const SIScalar                              = SIBaseUnit(0,0,0,0,0,0,0)
const Meter    = const meter    = const m   = SIBaseUnit(1,0,0,0,0,0,0)
const Kilogram = const kilogram = const kg  = SIBaseUnit(0,1,0,0,0,0,0)
const Second   = const second   = const s   = SIBaseUnit(0,0,1,0,0,0,0)
const Ampere   = const ampere   = const A   = SIBaseUnit(0,0,0,1,0,0,0)
const Kelvin   = const kelvin   = const K   = SIBaseUnit(0,0,0,0,1,0,0)
const Mole     = const mole     = const mol = SIBaseUnit(0,0,0,0,0,1,0)
const Candela  = const candela  = const cd  = SIBaseUnit(0,0,0,0,0,0,1)

export SIBaseUnit, SIScalar

const siUnitID = (:Meter, :Kilogram, :Second, :Ampere, :Kelvin, :Mole, :Candela)
const siUnitSY = (:m    , :kg      , :s     , :A     , :K     , :mol           )
const siUnitid = Symbol.(lowercase.(String.(siUnitID)))

for siUnit in (siUnitID..., siUnitid..., siUnitSY...)
   @eval export $siUnit
end

# Generation of metaprogramming facilities required by: @generatecode_phyunit_showmethod, @generatecode_phyunit_operations
# From this point, the following substitutions within an @eval or eval(:( fooExpr )) may be made:
# $unit               --> SIBaseUnit{Type{m},Type{kg},Type{s},Type{A},Type{K},Type{mol},Type{cd}}
# $(uTuple...)        --> m,kg,s,A,K,mol,cd
# $(uTuple1...)       --> m1,kg1,s1,A1,K1,mol1,cd1
# $(uTuple2...)       --> m2,kg2,s2,A2,K2,mol2,cd2
# $(uTuple1Tuple2...) --> m1,kg1,s1,A1,K1,mol1,cd1,m2,kg2,s2,A2,K2,mol2,cd2
@generatecode_phyunit_names "SIBaseUnit" ["m","kg","s","A","K","mol","cd"]

# Pretty printing
@generatecode_phyunit_showmethod

import Base: show
function show(io::IO,::Type{SIScalar})
   print("(SIScalar)")
end

################################################################################
################################## Operations ##################################
################################################################################

if @isdefined Units
   operationsBetweenQuantities_sameUnit = Units.operationsBetweenQuantities_sameUnit
   operationsBetweenUnits_otherUnit     = Units.operationsBetweenUnits_otherUnit
elseif @isdefined PhysicalBase
   operationsBetweenQuantities_sameUnit = PhysicalBase.operationsBetweenQuantities_sameUnit
   operationsBetweenUnits_otherUnit     = PhysicalBase.operationsBetweenUnits_otherUnit
else
   operationsBetweenQuantities_sameUnit = (:+,:-)
   operationsBetweenUnits_otherUnit     = (:*, :/, :\)
end

@generatecode_phyunit_operations 

################################################################################
#################################### Other  ####################################
################################################################################

macro generatenumeratoranddenominatorcode(suffix, tupleOfUnits...)
   expressionsArray = []
   for unit in tupleOfUnits
      functionParameter = Symbol(unit,suffix)
      unitString  = "\\text{$unit}"
      latexString = :($unitString * (abs($functionParameter) == 1 ? "\\," : "^{" * string(abs($functionParameter)) * "}"))
      ex = esc(:($functionParameter ≠ 0 && ($functionParameter ≥ 1 ? num *= $latexString : den *= $latexString)))
      push!(expressionsArray, ex)
   end

   return quote $(tuple(expressionsArray...)...) end
end

export latexstring
function latexstring(::Type{SIBaseUnit{Type{m},Type{kg},Type{s},Type{A},Type{K},Type{mol},Type{cd}}}) where {m,kg,s,A,K,mol,cd}
   num = ""
   den = ""
   out = ""

   @generatenumeratoranddenominatorcode("", m,kg,s,A,K,mol,cd)

   if !isempty(den)
      (length(den)>1 && den[end-1:end]=="\\,") ? den=den[1:end-2] : nothing
      if isempty(num)
         out = "\$\\frac{1}{" * den * "}\$"
      else
         (length(num)>1 && num[end-1:end]=="\\,") ? num=num[1:end-2] : nothing
         out = "\$\\frac{" * num * "}{" * den * "}\$"
      end
   else
      (length(num)>1 && num[end-1:end]=="\\,") ? num=num[1:end-2] : nothing
      out = "\$" * num * "\$"
   end
   return out

end
