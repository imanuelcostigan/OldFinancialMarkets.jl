module FinMarkets

using Dates

export
    isweekend,
    isnewyearsday

include("times.jl")
include("calendars.jl")

end
