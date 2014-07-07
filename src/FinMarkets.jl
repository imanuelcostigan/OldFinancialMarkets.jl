module FinMarkets

using Datetime

export
    isweekend,
    isnewyearsday

include("calendars/calendars.jl")

end # module
