if @isdefined PhysicalUnits
    operationsBetweenQuantities_sameUnit  = PhysicalUnits.operationsBetweenUnits_sameUnit
    operationsBetweenQuantities_otherUnit = PhysicalUnits.operationsBetweenUnits_otherUnit
    @generatecode_phyunit_names "PhysicalUnit" ["𝐋","𝐌","𝐓","𝐈","𝚯","𝐍","𝐉"]
elseif @isdefined UnitfulSystem
    operationsBetweenQuantities_sameUnit  = UnitfulSystem.operationsBetweenQuantities_sameUnit
    operationsBetweenQuantities_otherUnit = UnitfulSystem.operationsBetweenQuantities_otherUnit
else
    operationsBetweenQuantities_sameUnit  = (:+,:-)
    operationsBetweenQuantities_otherUnit = (:*, :/, :\)
end

export @generatecode_phyquantity_operations
macro generatecode_phyquantity_operations()
    esc(quote

        for op in operationsBetweenQuantities_sameUnit
            eval(:(import Base: $op))
            eval(:($op(x::UnitfulQuantity{<:Real,$unit}, y::UnitfulQuantity{<:Real,$unit}) where {$(uTuple...)} = UnitfulQuantity($op(x.val,y.val),$unit)))
        end

        eval(:(import Base: isapprox))
        eval(:(isapprox(x::UnitfulQuantity{<:Real,$unit}, y::UnitfulQuantity{<:Real,$unit}; kvarag...) where {$(uTuple...)} = isapprox(x.val,y.val; kvarg...)))

        for op in operationsBetweenQuantities_otherUnit
            eval(:(import Base: $op))
            eval(:($op(x::UnitfulQuantity{<:Real,$unit1}, y::UnitfulQuantity{<:Real,$unit2}) where {$(uTuple1Tuple2...)} = UnitfulQuantity($op(x.val,y.val),$op($unit1,$unit2))))
        end

    end)
end

@generatecode_phyquantity_operations

for op in operationsBetweenQuantities_sameUnit
    @eval $op(x::UnitfulQuantity{<:Real,<:$unit}, y::UnitfulQuantity{<:Real,<:$unit}) where {$(uTuple...)} = $op(promote(x,y)...)
end

for op in operationsBetweenQuantities_otherUnit
    @eval $op(x::UnitfulQuantity{<:Real,<:$unit1}, y::UnitfulQuantity{<:Real,<:$unit2}) where {$(uTuple1Tuple2...)} = $op(promote(x,y)...)
end
