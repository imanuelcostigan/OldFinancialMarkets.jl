module FinMarkets

using Dates

export
    A365, A360, ActActISDA, Thirty360, ThirtyE360, ThirtyEP360,
    daysinyear,
    years,
    isweekend,
    isnewyearsday

include("calendars.jl")
include("times.jl")

end
