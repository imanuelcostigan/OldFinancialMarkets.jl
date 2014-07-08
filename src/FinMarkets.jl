module FinMarkets

using Dates

export
    A365, A360, ActAct, Thirty360, ThirtyE360,
    daysinyear,
    years,
    isweekend,
    isnewyearsday

include("times.jl")
include("calendars.jl")

end
