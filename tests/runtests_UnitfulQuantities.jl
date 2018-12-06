using UnitfulSystem
using Test

struct TestUnit        <: Unit end
struct TestUnitSqrt    <: Unit end
struct TestUnitCbrt    <: Unit end
struct TestUnitInverse <: Unit end

import Base: √, ∛, inv, one
  √(::Type{TestUnit}) = TestUnitSqrt
  ∛(::Type{TestUnit}) = TestUnitCbrt
inv(::Type{TestUnit}) = TestUnitInverse
one(::Type{TestUnit}) = Unitless

struct TestUnit2      <: Unit end
struct ResultUnitMult <: Unit end
struct ResultUnitDiv  <: Unit end
struct ResultUnitVid  <: Unit end


include("runtests_UnitfulQuantitiesCore.jl")
