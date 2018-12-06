using UnitfulSystem
using UnitfulSystem.PhysicalBase
using UnitfulSystem.SIBase
using Test

@testset "SI base units are subtypes of the general PHY units" begin
    @test SIBaseUnit <: Unit
    @test SIBaseUnit <: PhysicalUnit
    @test m          <: Length
    @test kg         <: Mass
    @test s          <: Time
    @test A          <: Current
    @test K          <: Temperature
    @test mol        <: Substance
    @test candela    <: Luminosity
end

TestUnit = meter
struct TestScalar <: Unitless end

@testset "Unary Operations yielding the same unit" begin
    for op in UnitfulSystem.operationsUnary_sameUnit
        @test eval(:($op(TestUnit)===TestUnit))
    end
    @test round(TestUnit) === TestUnit
end

@testset "Operations between units yielding the same unit" begin
    for op in UnitfulSystem.operationsBetweenUnits_sameUnit
        @test eval(:($op(TestUnit,TestUnit)===TestUnit))
    end
end

@testset "SIScalars: special unary operations" begin
    for op in UnitfulSystem.operationsUnary_otherUnit
        @test eval(:($op(SIScalar)===SIScalar))
    end
end

@testset "Scalars: operations SIUnit Scalar" begin
    for op in UnitfulSystem.operationsUnitScalar #(:*, :/, :÷, :%, :mod, :fld, :cld)
        @test eval(:($op(TestUnit,TestScalar)===TestUnit))
    end
    @test TestUnit\TestScalar===inv(TestUnit)
end

@testset "Scalar: operations Scalar SIUnit" begin
    for op in (:*, :\)
        @test eval(:($op(TestScalar,TestUnit)===TestUnit))
    end
    @test TestScalar/TestUnit===inv(TestUnit)
end

@testset "SIBaseUnit operations" begin
    n = 10
    unitTuple1 = Int.(rand(Int8,n,7))
    unitTuple2 = Int.(rand(Int8,n,7))
    for i = 1:n
        for op in UnitfulSystem.operationsBetweenUnits_sameUnit
            @test eval(:($op(SIBaseUnit($(unitTuple1[i,:])...),SIBaseUnit($(unitTuple1[i,:])...))==SIBaseUnit($(unitTuple1[i,:])...)))
        end

        @test SIBaseUnit(unitTuple1[i,:]...)^i      == SIBaseUnit(( unitTuple1[i,:]*i)...)
        @test √(SIBaseUnit((unitTuple1[i,:]*2)...)) == SIBaseUnit(  unitTuple1[i,:]...   )
        @test_throws InexactError √(SIBaseUnit((unitTuple1[i,:].*2 .+1)...))
        @test ∛(SIBaseUnit((unitTuple1[i,:]*3)...)) == SIBaseUnit(  unitTuple1[i,:]...   )
        @test_throws InexactError ∛(SIBaseUnit((unitTuple1[i,:].*3 .+1)...))
        @test inv(SIBaseUnit(unitTuple1[i,:]...))   == SIBaseUnit((-unitTuple1[i,:]  )...)

        @test SIBaseUnit(unitTuple1[i,:]...) * SIBaseUnit(unitTuple2[i,:]...) == SIBaseUnit(( unitTuple1[i,:]+unitTuple2[i,:])...)
        @test SIBaseUnit(unitTuple1[i,:]...) / SIBaseUnit(unitTuple2[i,:]...) == SIBaseUnit(( unitTuple1[i,:]-unitTuple2[i,:])...)
        @test SIBaseUnit(unitTuple1[i,:]...) \ SIBaseUnit(unitTuple2[i,:]...) == SIBaseUnit((-unitTuple1[i,:]+unitTuple2[i,:])...)
    end
end
