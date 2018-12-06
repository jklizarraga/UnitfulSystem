################################################################################
################################## Definition ##################################
################################################################################

const Joule   = const joule   = const J  = Kilogram*Meter^2/Second^2
const Coulomb = const coulomb = const C  = Ampere*Second
const Volt    = const volt    = const V  = Joule/Coulomb
const Farad   = const farad   = const F  = Coulomb^2/Joule
const Newton  = const newton  = const N  = Kilogram*Meter/Second^2
const Ohm     = const ohm     = const Ω  = Volt/Ampere
const Hertz   = const hertz   = const Hz = inv(Second)
const Siemens = const siemens = const S  = inv(Ohm)
const Watt    = const watt    = const W  = Joule/Second
const Pascal  = const pascal  = const Pa = Newton/Meter^2

const siUnitID = (:Joule, :Coulomb, :Volt, :Farad, :Newton, :Ohm, :Hertz, :Siemens, :Watt, :Pascal)
const siUnitSY = (:J    , :C      , :V   , :F    , :N     , :Ω  , :Hz   , :S      , :W   , :Pa    )

const siUnitSYDic = Dict(map((x,y)-> x=> y, siUnitID, siUnitSY))

import Base: show
for siUnit in siUnitID
    unitid = Symbol(lowercase(String(siUnit)))
    siUnitSY = String(siUnitSYDic[siUnit])

    @eval export $siUnit, $unitid, $(siUnitSYDic[siUnit])
    @eval Base.show(io::IO,::Type{$siUnit}) =  print($siUnitSY)
end

################################################################################
################################## Operations ##################################
################################################################################
