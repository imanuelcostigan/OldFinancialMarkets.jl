module FinMarkets

using Dates

export
    years,
    isweekend,
    isnewyearsday

include("times.jl")
include("calendars.jl")

end
