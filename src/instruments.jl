####
# Types
####

abstract type Instrument end

include("instruments/cash.jl")
include("instruments/deposit.jl")
include("instruments/futures.jl")
