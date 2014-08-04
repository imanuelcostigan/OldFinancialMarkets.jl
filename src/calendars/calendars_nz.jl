#####
# Type declarations
#####

abstract NZFCalendar <: FinCalendar

#####
# Methods
#####

function isnewyearsholiday(dt::TimeType, c::NZFCalendar)
    (isnewyearsholiday(dt) || (month(dt) == Jan &&
        ((day(dt) == 3 && dayofweek(dt) in [Mon, Tue]) ||
            (day(dt) == 2 || (day(dt) == 4 && dayofweek(dt) in [Mon, Tue])))))
end
iswaitangiday(dt::TimeType, c = NoFCalendar()) = (day(dt) == 6 &&
    month(dt) == Feb)
function iswaitangidayholiday(dt::TimeType, c::NZFCalendar)
    (iswaitangiday(dt) || (month(dt) == Feb && day(dt) in [7, 8] &&
        dayofweek(dt) == Mon && year(dt) > 2013))
end
function isanzacdayholiday(dt::TimeType, c::NZFCalendar)
    (isanzacdayholiday(dt) || (month(dt) == Apr && day(dt) in [26, 27] &&
        dayofweek(dt) == Mon && year(dt) > 2013))
end
function iseasterholiday(dt::TimeType, c::NZFCalendar)
    iseasterholiday(dt, [Fri, Mon])
end
function isqueensbirthdayholiday(dt::TimeType, c::NZFCalendar)
    dayofweek(dt) == Mon && dayofweekofmonth(dt) == 1 && month(dt) == Jun
end
function islabourdayholiday(dt::TimeType, c::NZFCalendar)
    dayofweek(dt) == Mon && dayofweekofmonth(dt) == 4 && month(dt) == Oct
end
function ischristmasdayholiday(dt::TimeType, c::NZFCalendar)
    ischristmasdayholiday(dt, true)
end
function isboxingdayholiday(dt::TimeType, c::NZFCalendar)
    isboxingdayholiday(dt, true)
end

include("calendars_nzau.jl")
include("calendars_nzwe.jl")
