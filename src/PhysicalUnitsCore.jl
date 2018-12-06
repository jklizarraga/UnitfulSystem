################################################################################
################################## Definition ##################################
################################################################################

abstract type PhysicalUnit{𝐋<:Int,𝐌<:Int,𝐓<:Int,𝐈<:Int,𝚯<:Int,𝐍<:Int,𝐉<:Int} <: Unit end

PhysicalUnit(𝐋::Int    ,𝐌::Int    ,𝐓::Int    ,𝐈::Int    ,𝚯::Int    ,𝐍::Int    ,𝐉::Int    ) = PhysicalUnit{Type{    𝐋 },Type{    𝐌 },Type{    𝐓 },Type{    𝐈 },Type{    𝚯 },Type{    𝐍 },Type{    𝐉 }}
PhysicalUnit(𝐋::Integer,𝐌::Integer,𝐓::Integer,𝐈::Integer,𝚯::Integer,𝐍::Integer,𝐉::Integer) = PhysicalUnit{Type{Int(𝐋)},Type{Int(𝐌)},Type{Int(𝐓)},Type{Int(𝐈)},Type{Int(𝚯)},Type{Int(𝐍)},Type{Int(𝐉)}}
PhysicalUnit(𝐋::Real   ,𝐌::Real   ,𝐓::Real   ,𝐈::Real   ,𝚯::Real   ,𝐍::Real   ,𝐉::Real   ) = PhysicalUnit{Type{Int(𝐋)},Type{Int(𝐌)},Type{Int(𝐓)},Type{Int(𝐈)},Type{Int(𝚯)},Type{Int(𝐍)},Type{Int(𝐉)}}

# Base PHY units according to the SI system.
const Scalar      =            PhysicalUnit(0,0,0,0,0,0,0)
const Length      = const 𝐋 =  PhysicalUnit(1,0,0,0,0,0,0)
const Mass        = const 𝐌 =  PhysicalUnit(0,1,0,0,0,0,0)
const Time        = const 𝐓 =  PhysicalUnit(0,0,1,0,0,0,0)
const Current     = const 𝐈 =   PhysicalUnit(0,0,0,1,0,0,0)
const Temperature = const 𝚯 =  PhysicalUnit(0,0,0,0,1,0,0)
const Substance   = const 𝐍 =  PhysicalUnit(0,0,0,0,0,1,0)
const Luminosity  = const 𝐉 =   PhysicalUnit(0,0,0,0,0,0,1)

export PhysicalUnit,
       Scalar      ,
       Length      , 𝐋,
       Mass        , 𝐌,
       Time        , 𝐓,
       Current     , 𝐈,
       Temperature , 𝚯,
       Substance   , 𝐍,
       Luminosity  , 𝐉

# Other PHY units defined for convenience

                                #PhysicalUnit{ 𝐋,𝐌, 𝐓, 𝐈, 𝚯, 𝐍, 𝐉}
const Area                     = PhysicalUnit( 2, 0, 0, 0, 0, 0, 0) #𝐋^2
const Volume                   = PhysicalUnit( 3, 0, 0, 0, 0, 0, 0) #𝐋^3
const Frequency                = PhysicalUnit( 0, 0,-1, 0, 0, 0, 0) #inv(𝐓)
const Force                    = PhysicalUnit( 1, 1,-2, 0, 0, 0, 0) #𝐌*𝐋/𝐓^2
const Pressure                 = PhysicalUnit(-1, 1,-2, 0, 0, 0, 0) #𝐌*𝐋^-1*𝐓^-2
const Energy                   = PhysicalUnit( 2, 1,-2, 0, 0, 0, 0) #𝐌*𝐋^2/𝐓^2
const Momentum                 = PhysicalUnit( 1, 1,-1, 0, 0, 0, 0) #𝐌*𝐋/𝐓
const Power                    = PhysicalUnit( 2, 1,-3, 0, 0, 0, 0) #𝐋^2*𝐌*𝐓^-3
const Charge                   = PhysicalUnit( 0, 0, 1, 1, 0, 0, 0) #𝐈*𝐓
const Voltage                  = PhysicalUnit( 2, 1,-3,-1, 0, 0, 0) #𝐈^-1*𝐋^2*𝐌*𝐓^-3
const ElectricalResistance     = PhysicalUnit( 2, 1,-3,-2, 0, 0, 0) #𝐈^-2*𝐋^2*𝐌*𝐓^-3
const ElectricalResistivity    = PhysicalUnit( 3, 1,-3,-2, 0, 0, 0) #𝐈^-2*𝐋^3*𝐌*𝐓^-3
const ElectricalConductance    = PhysicalUnit(-2,-1, 3, 2, 0, 0, 0) #𝐈^2*𝐋^-2*𝐌^-1*𝐓^3
const ElectricalConductivity   = PhysicalUnit(-3,-1, 3, 2, 0, 0, 0) #𝐈^2*𝐋^-3*𝐌^-1*𝐓^3
const Capacitance              = PhysicalUnit(-2,-1, 4, 2, 0, 0, 0) #𝐈^2*𝐋^-2*𝐌^-1*𝐓^4
const Inductance               = PhysicalUnit( 2, 1,-2,-2, 0, 0, 0) #𝐈^-2*𝐋^2*𝐌*𝐓^-2
const MagneticFlux             = PhysicalUnit( 2, 1,-2,-1, 0, 0, 0) #𝐈^-1*𝐋^2*𝐌*𝐓^-2
const DField                   = PhysicalUnit(-2, 0, 1, 1, 0, 0, 0) #𝐈*𝐓/𝐋^2
const EField                   = PhysicalUnit( 1, 1,-3,-1, 0, 0, 0) #𝐋*𝐌*𝐓^-3*𝐈^-1
const HField                   = PhysicalUnit(-1, 0, 0, 1, 0, 0, 0) #𝐈/𝐋
const BField                   = PhysicalUnit( 0, 1,-2,-1, 0, 0, 0) #𝐈^-1*𝐌*𝐓^-2
const Action                   = PhysicalUnit( 2, 1,-1, 0, 0, 0, 0) #𝐋^2*𝐌*𝐓^-1
const DynamicViscosity         = PhysicalUnit(-1, 1,-1, 0, 0, 0, 0) #𝐌*𝐋^-1*𝐓^-1
const KinematicViscosity       = PhysicalUnit( 2, 0,-1, 0, 0, 0, 0) #𝐋^2*𝐓^-1
const Wavenumber               = PhysicalUnit(-1, 0, 0, 0, 0, 0, 0) #inv(𝐋)
const ElectricDipoleMoment     = PhysicalUnit( 1, 0, 1, 1, 0, 0, 0) #𝐋*𝐓*𝐈
const ElectricQuadrupoleMoment = PhysicalUnit( 2, 0, 1, 1, 0, 0, 0) #𝐋^2*𝐓*𝐈
const MagneticDipoleMoment     = PhysicalUnit( 2, 0, 0, 1, 0, 0, 0) #𝐋^2*𝐈

export Area                    ,
       Volume                  ,
       Frequency               ,
       Force                   ,
       Pressure                ,
       Energy                  ,
       Momentum                ,
       Power                   ,
       Charge                  ,
       Voltage                 ,
       ElectricalResistance    ,
       ElectricalResistivity   ,
       ElectricalConductance   ,
       ElectricalConductivity  ,
       Capacitance             ,
       Inductance              ,
       MagneticFlux            ,
       DField                  ,
       EField                  ,
       HField                  ,
       BField                  ,
       Action                  ,
       DynamicViscosity        ,
       KinematicViscosity      ,
       Wavenumber              ,
       ElectricDipoleMoment    ,
       ElectricQuadrupoleMoment,
       MagneticDipoleMoment

# The following macro creates metaprogramming facilities.
# Those facilities are required by: @generatecode_phyunit_showmethod, @generatecode_phyunit_operations 
export @generatecode_phyunit_names
macro generatecode_phyunit_names(unitNameIn, uArrayBaseIn)

   suffixList   = ["","1","2"]

   esc(quote

      const unitName   = $unitNameIn
      const uArrayBase = $uArrayBaseIn

      # Generate variables uArray, uArray1, uArray2, uTuple, uTuple1, uTuple2, unit, unit1, unit2
      for suffix in $suffixList
         uArrayX, uTupleX, uUnitX  = Symbol("uArray"*suffix), Symbol("uTuple"*suffix), Symbol("unit" *suffix)
         eval(:( const $uArrayX = $($uArrayBaseIn).*$suffix   ))
         eval(:( const $uTupleX = tuple(Symbol.($uArrayX)...) ))
         eval(:( const $uUnitX  = Meta.parse( unitName * "{Type{" * join($uTupleX,"},Type{") * "}}" )))#:($(Symbol(unitName)){$(($uTupleX)...)}) ))
      end

      # Operation not covered by module Units
      const uTuple1Tuple2 = (uTuple1...,uTuple2...)

   end)
end
@generatecode_phyunit_names "PhysicalUnit" ["𝐋","𝐌","𝐓","𝐈","𝚯","𝐍","𝐉"]

# import Base: show
# @eval Base.show(io::IO,::Type{$unit}) where {$(uTuple...)} = print("PhysicalUnit{",𝐋,",",𝐌,",",𝐓,",",𝐈,",",𝚯,",",𝐍,",",𝐉,"}")

export @generatecode_phyunit_showmethod
macro generatecode_phyunit_showmethod()

   # println("Type of unitMacro: ", typeof(unitMacro), "; value: ", unitMacro, "; exec: ", eval(unitMacro))
   # println("Type of tupleOfUnits: ", typeof(tupleOfUnits), "; value: ", tupleOfUnits, "; exec: ", eval(tupleOfUnits))

   esc(quote
      # The following does not work because unitMacro and tupleOfUnits do not exist in the modules that invoke this macro.
      # println("Type of unitMacro: ", typeof(unitMacro), "; value: ", unitMacro)
      # println("Type of tupleOfUnits: ", typeof(tupleOfUnits), "; value: ", tupleOfUnits)

      # The following lines DO work, because unitMacro and tupleOfUnits are interpolated.
      # println("Type of unitMacro: "   , typeof($unitMacro)   , "; value: ", $unitMacro   ) 
      # println("Type of tupleOfUnits: ", typeof($tupleOfUnits), "; value: ", $tupleOfUnits)

      # To execute the code in the invoking module:
      # eval(:( $( $unitMacro       ) ))
      # eval(:( $(($tupleOfUnits)...) ))
      # In the invoking module after expression interpolation
      # eval(:( $((unit  )   ) ))
      # eval(:( $((uTuple)...) ))

      eval(quote 
      
         suffix = ""

         expressionsArray = []
         for u in $uTuple
            functionParameter = Symbol(u,suffix)
            ex = :($functionParameter ≠ 0 && print(io, $(String(u)), ($functionParameter == 1 ? ' ' : tosuperscript($functionParameter))))
            push!(expressionsArray, ex)
         end

      end) #quote, eval
   

      eval(quote

         import Base: show

         function show(io::IO,::Type{$unit}) where {$(uTuple...)}
            tosuperscript(number::Union{Integer,AbstractFloat}) = map(repr(number)) do c
               c  ==  '-' ? '\u207b' :
               c  ==  '1' ? '\u00b9' :
               c  ==  '2' ? '\u00b2' :
               c  ==  '3' ? '\u00b3' :
               c  ==  '4' ? '\u2074' :
               c  ==  '5' ? '\u2075' :
               c  ==  '6' ? '\u2076' :
               c  ==  '7' ? '\u2077' :
               c  ==  '8' ? '\u2078' :
               c  ==  '9' ? '\u2079' :
               c  ==  '0' ? '\u2070' :
               c  ==  '+' ? '\u207a' :
               c  ==  '.' ? '\u22c5' :
               error("Unexpected Chatacter")
            end

            $(tuple(expressionsArray...)...)

         end # function show()

      end) #quote, eval
   
   end) #quote, esc
   

end

@generatecode_phyunit_showmethod

@eval physicalunittuple(::Type{$unit}) where {$(uTuple...)} = tuple($(uTuple...))

################################################################################
################################## Operations ##################################
################################################################################
if @isdefined Units
   operationsBetweenUnits_sameUnit  = Units.operationsBetweenUnits_sameUnit
   operationsBetweenUnits_otherUnit = Units.operationsBetweenUnits_otherUnit
elseif @isdefined UnitfulSystem
   operationsBetweenUnits_sameUnit  = UnitfulSystem.operationsBetweenQuantities_sameUnit
   operationsBetweenUnits_otherUnit = UnitfulSystem.operationsBetweenUnits_otherUnit
else
   operationsBetweenUnits_sameUnit  = (:+,:-)
   operationsBetweenUnits_otherUnit = (:*, :/, :\)
end

export @generatecode_phyunit_operations
macro generatecode_phyunit_operations()

   esc(quote

      resultExpression(uTupleArray::Array{String,1}) = Meta.parse(unitName*"("*join(uTupleArray, ",")*")")

      unitResult = Dict(:* => resultExpression(uArray1 .* "+" .* uArray2), # -> :((m1 + m2, kg1 + kg2, s1 + s2, A1 + A2, K1 + K2, mol1 + mol2, cd1 + cd2))
                        :/ => resultExpression(uArray1 .* "-" .* uArray2),
                        :\ => resultExpression(uArray2 .* "-" .* uArray1))

      for op in operationsBetweenUnits_otherUnit
         eval(:(import Base: $op))
         eval(:($op(::Type{$unit1}, ::Type{$unit2}) where {$(uTuple1Tuple2...)} = $(unitResult[op])))
      end

      import Base: ^
      unitResult = resultExpression(uArray.*"*i")
      eval(:(^(::Type{$unit}, i::Integer) where {$(uTuple...)} = $unitResult))
      unitResult = resultExpression("Int(".*uArray.*"*i)")
      eval(:(^(::Type{$unit}, i::Rational) where {$(uTuple...)} = $unitResult))

      import Base: inv
      unitResult = resultExpression("-".*uArray)
      eval(:(inv(::Type{$unit}) where {$(uTuple...)} = $unitResult))

      import Base: √
      eval(:(√(::Type{$unit}) where {$(uTuple...)} = ($unit)^(1//2)))

      import Base: ∛
      eval(:(∛(::Type{$unit}) where {$(uTuple...)} = ($unit)^(1//3)))

      import Base: one
      eval(:(one(::Type{$unit}) where {$(uTuple...)} = $(Symbol(unitName))(zeros(Int,1,$(length(uArray)))...)))

   end) #quote, esc
end

@generatecode_phyunit_operations
