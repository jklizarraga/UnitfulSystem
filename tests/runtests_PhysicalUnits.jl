using UnitfulSystem.PhysicalBase
using Test

@testset "PhysicalUnit operations" begin
    n = 10
    unitTuple1 = Int.(rand(Int8,n,7))
    unitTuple2 = Int.(rand(Int8,n,7))
    for i = 1:n
        for op in PhysicalBase.operationsBetweenUnits_sameUnit
            @test eval(:($op(PhysicalUnit($(unitTuple1[i,:])...),PhysicalUnit($(unitTuple1[i,:])...))==PhysicalUnit($(unitTuple1[i,:])...)))
        end

        @test PhysicalUnit(unitTuple1[i,:]...)^i      == PhysicalUnit(( unitTuple1[i,:]*i)...)
        @test √(PhysicalUnit((unitTuple1[i,:]*2)...)) == PhysicalUnit(  unitTuple1[i,:]...   )
        @test_throws InexactError √(PhysicalUnit((unitTuple1[i,:] .*2 .+ 1)...))
        @test ∛(PhysicalUnit((unitTuple1[i,:]*3)...)) == PhysicalUnit(  unitTuple1[i,:]...   )
        @test_throws InexactError ∛(PhysicalUnit((unitTuple1[i,:] .*3 .+ 1)...))
        @test inv(PhysicalUnit(unitTuple1[i,:]...))   == PhysicalUnit((-unitTuple1[i,:]  )...)

        @test PhysicalUnit(unitTuple1[i,:]...) * PhysicalUnit(unitTuple2[i,:]...) == PhysicalUnit(( unitTuple1[i,:]+unitTuple2[i,:])...)
        @test PhysicalUnit(unitTuple1[i,:]...) / PhysicalUnit(unitTuple2[i,:]...) == PhysicalUnit(( unitTuple1[i,:]-unitTuple2[i,:])...)
        @test PhysicalUnit(unitTuple1[i,:]...) \ PhysicalUnit(unitTuple2[i,:]...) == PhysicalUnit((-unitTuple1[i,:]+unitTuple2[i,:])...)
    end
end

@testset "UnitsCore: Derived Units Construction" begin
    @test Area                     === 𝐋^2
    @test Volume                   === 𝐋^3
    @test Frequency                === inv(𝐓)
    @test Force                    === 𝐌*𝐋/𝐓^2
    @test Pressure                 === 𝐌*𝐋^-1*𝐓^-2
    @test Energy                   === 𝐌*𝐋^2/𝐓^2
    @test Momentum                 === 𝐌*𝐋/𝐓
    @test Power                    === 𝐋^2*𝐌*𝐓^-3
    @test Charge                   === 𝐈*𝐓
    @test Voltage                  === 𝐈^-1*𝐋^2*𝐌*𝐓^-3
    @test ElectricalResistance     === 𝐈^-2*𝐋^2*𝐌*𝐓^-3
    @test ElectricalResistivity    === 𝐈^-2*𝐋^3*𝐌*𝐓^-3
    @test ElectricalConductance    === 𝐈^2*𝐋^-2*𝐌^-1*𝐓^3
    @test ElectricalConductivity   === 𝐈^2*𝐋^-3*𝐌^-1*𝐓^3
    @test Capacitance              === 𝐈^2*𝐋^-2*𝐌^-1*𝐓^4
    @test Inductance               === 𝐈^-2*𝐋^2*𝐌*𝐓^-2
    @test MagneticFlux             === 𝐈^-1*𝐋^2*𝐌*𝐓^-2
    @test DField                   === 𝐈*𝐓/𝐋^2
    @test EField                   === 𝐋*𝐌*𝐓^-3*𝐈^-1
    @test HField                   === 𝐈/𝐋
    @test BField                   === 𝐈^-1*𝐌*𝐓^-2
    @test Action                   === 𝐋^2*𝐌*𝐓^-1
    @test DynamicViscosity         === 𝐌*𝐋^-1*𝐓^-1
    @test KinematicViscosity       === 𝐋^2*𝐓^-1
    @test Wavenumber               === inv(𝐋)
    @test ElectricDipoleMoment     === 𝐋*𝐓*𝐈
    @test ElectricQuadrupoleMoment === 𝐋^2*𝐓*𝐈
    @test MagneticDipoleMoment     === 𝐋^2*𝐈
end
