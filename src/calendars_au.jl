#####
# Type declarations
#####

abstract AUFCalendar <: FinCalendar

#####
# Methods
#####
function isnewyearsholiday(dt::Date, c::AUFCalendar)
    isnewyearsholiday(dt, [Sat, Sun])
end
function isaustraliadayholiday(dt::Date, c::AUFCalendar)
    isaustraliadayholiday(dt, [Sat, Sun])
end
function isanzacdayholiday(dt::Date, c::AUFCalendar)
    isanzacdayholiday(dt)
end
function iseasterholiday(dt::Date, c::AUFCalendar)
    iseasterholiday(dt, [Fri, Mon])
end
function isqueensbirthdayholiday(dt::Date, c::AUFCalendar)
    dayofweek(dt) == Mon && dayofweekofmonth(dt) == 2 && month(dt) == Jun
end
function ischristmasdayholiday(dt::Date, c::AUFCalendar)
    ischristmasdayholiday(dt, true)
end
function isboxingdayholiday(dt::Date, c::AUFCalendar)
    isboxingdayholiday(dt, true)
end
function isgoodday(dt::Date, c::AUFCalendar)
    !(isweekend(dt) || isnewyearsholiday(dt, c) ||
        isaustraliadayholiday(dt, c) || isanzacdayholiday(dt, c) ||
        ischristmasdayholiday(dt, c) || isboxingdayholiday(dt, c) ||
        iseasterholiday(dt, c) || isqueensbirthdayholiday(dt, c) ||
        isqueensbirthdayholiday(dt, c) || isbankholiday(dt, c) ||
        islabourdayholiday(dt, c))
end

include("calendars_ausy.jl")
include("calendars_aume.jl")
