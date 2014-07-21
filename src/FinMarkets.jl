module FinMarkets

using Dates

export
    # times.j;
    A365, A360, ActActISDA, Thirty360, ThirtyE360, ThirtyEP360, years,
    # calendars.jl
    FinCalendar, NoFCalendar,
    easter,
    isweekend, isnewyearsday, isaustraliaday, isanzacday, iseaster,
    ischristmasday, isboxingday,
    isnewyearsholiday, isaustraliadayholiday, isanzacdayholiday, iseasterholiday,
    ischristmasdayholiday, isboxingdayholiday,
    isgoodday,
    # calendars_au.jl
    AUFCalendar, AUSYFCalendar, AUMEFCalendar,
    isqueensbirthdayholiday, isbankholiday, islabourdayholiday,
    ismelbournecupholiday,
    # calendars_us.jl
    USFCalendar, USNYFCalendar,
    ismlkdayholiday, iswashingtonsbdayholiday, ismemorialdayholiday,
    isindependencedayholiday, iscolumbusdayholiday, isveteransdayholiday,
    isthanksgivingdayholiday

include("calendars.jl")
include("times.jl")

end
