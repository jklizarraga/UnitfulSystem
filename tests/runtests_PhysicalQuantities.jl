using UnitfulSystem.PhysicalBase
using UnitfulSystem
using Test

TestUnit = PhysicalUnit(Int.(rand(Int8,1,7)).*6...)
TestUnitSqrt = √TestUnit
TestUnitCbrt = ∛TestUnit
TestUnitInverse = inv(TestUnit)

include("runtests_UnitfulQuantitiesCore.jl")

TestUnit2 = PhysicalUnit(Int.(rand(Int8,1,7))...)

ResultUnit = Dict(:* => PhysicalUnit((  PhysicalBase.physicalunittuple(TestUnit).+PhysicalBase.physicalunittuple(TestUnit2))...),
                  :/ => PhysicalUnit((  PhysicalBase.physicalunittuple(TestUnit).-PhysicalBase.physicalunittuple(TestUnit2))...),
                  :\ => PhysicalUnit((.-PhysicalBase.physicalunittuple(TestUnit).+PhysicalBase.physicalunittuple(TestUnit2))...))

@testset "Operations between PHY quantities of different units" begin
    x = rand(Float64)
    y = rand(Int8)

    for op in PhysicalBase.operationsBetweenQuantities_otherUnit
        @test eval(:(  $op(UnitfulQuantity($x,TestUnit),UnitfulQuantity($y,TestUnit2)) === UnitfulQuantity($op($x,$y),$(ResultUnit[op]))  ))
    end
end
