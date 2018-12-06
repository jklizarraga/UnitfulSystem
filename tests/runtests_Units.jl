using UnitfulSystem
using Test

struct TestUnit <: Unit end
struct TestUnitInverse <: Unit end

import Base: inv
inv(::Type{TestUnit}) = TestUnitInverse
inv(::Type{TestUnitInverse}) = TestUnit

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

################################################################################
################################### SCALARS ####################################
################################################################################

struct TestScalar <: Unitless end

@testset "Scalars: special unary operations" begin
    for op in UnitfulSystem.operationsUnary_otherUnit
        @test eval(:($op(TestScalar)===TestScalar))
    end
end

@testset "Scalars: operations Unit Scalar" begin
    for op in UnitfulSystem.operationsUnitScalar #(:*, :/, :÷, :%, :mod, :fld, :cld)
        @test eval(:($op(TestUnit,TestScalar)===TestUnit))
    end
    @test TestUnit\TestScalar===TestUnitInverse
end

@testset "Scalar: operations Scalar Unit" begin
    for op in (:*, :\)
        @test eval(:($op(TestScalar,TestUnit)===TestUnit))
    end
    @test TestScalar/TestUnit===TestUnitInverse
end
