@testset "Construction" begin
    for x in [5,5.0,Int8(5),Int16(5),Int32(5),5//1]
        @test isa(UnitfulQuantity(x), UnitfulQuantity{typeof(x),Unitless})
        @test isa( ScalarQuantity(x), UnitfulQuantity{typeof(x),Unitless})
        @test isa(TestUnit(x)       , UnitfulQuantity{typeof(x),TestUnit})
        @test isunit(ScalarQuantity(x),Unitless)
        @test getunit(ScalarQuantity(x)) === Unitless
        @test quantity(ScalarQuantity(x)) === x
    end
end

################################################################################
########################## Conversion and Promotion ############################
################################################################################

@testset "Conversion and promotion" begin
    x = 5

    @test x*TestUnit === UnitfulQuantity(x,TestUnit)
    @test convert(UnitfulQuantity,x) === ScalarQuantity(x)
    @test convert(UnitfulQuantity{Float64,TestUnit},x) === UnitfulQuantity(Float64(x),TestUnit)
    @test convert(UnitfulQuantity{Float64,TestUnit}, UnitfulQuantity(x,TestUnit)) === UnitfulQuantity(Float64(x),TestUnit)
    @test_throws MethodError convert(UnitfulQuantity{Float64,TestUnit}, UnitfulQuantity(x,Unitless))

    @test promote_type(UnitfulQuantity{Float64,TestUnit},Int) === UnitfulQuantity
    @test promote_type(UnitfulQuantity{Float64,TestUnit},UnitfulQuantity{Int64,TestUnit}) === UnitfulQuantity{promote_type(Float64,Int64),TestUnit}
end

################################################################################
################################# Operations ###################################
################################################################################

@testset "Unary operations" begin
    x = 10.1

    for op in UnitfulSystem.operationsUnary_Quantity_sameUnit
        @test eval(:( $op(UnitfulQuantity($x,TestUnit)) === UnitfulQuantity($op($x),TestUnit) ))
    end
    @test zero(UnitfulQuantity(x,TestUnit)) === UnitfulQuantity(zero(x),TestUnit)

    for op in UnitfulSystem.operationsUnary_Quantity_sameUnit_other
        @test eval(:(  $op(UnitfulQuantity($x,TestUnit)) === UnitfulQuantity($op($x),TestUnit)  ))
    end

    @test   √(UnitfulQuantity(x,TestUnit)) == UnitfulQuantity(√x    ,TestUnitSqrt   )
    @test   ∛(UnitfulQuantity(x,TestUnit)) == UnitfulQuantity(∛x    ,TestUnitCbrt   )
    @test inv(UnitfulQuantity(x,TestUnit)) == UnitfulQuantity(inv(x),TestUnitInverse)
    @test one(UnitfulQuantity(x,TestUnit)) == UnitfulQuantity(one(x),one(TestUnit)  )

    for op in UnitfulSystem.operationsUnary_info
        @test eval(:( $op(UnitfulQuantity($x,TestUnit))  === $op($x)  ))
        @test eval(:( $op(UnitfulQuantity(Inf,TestUnit)) === $op(Inf) ))
        @test eval(:( $op(UnitfulQuantity(NaN,TestUnit)) === $op(NaN) ))
        @test eval(:( $op(UnitfulQuantity(100,TestUnit)) === $op(100) ))
        @test eval(:( $op(UnitfulQuantity(-99,TestUnit)) === $op(-99) ))
    end
end

@testset "Operations between quantities of same units" begin
    x = rand(Float64)
    y = rand(Int8)

    for op in UnitfulSystem.operationsBetweenQuantities_sameUnit
        @test eval(:(  $op(UnitfulQuantity($x,TestUnit),UnitfulQuantity($y,TestUnit)) === UnitfulQuantity($op($x,$y),TestUnit)  ))
    end

end
