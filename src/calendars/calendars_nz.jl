#####
# Type declarations
#####

abstract NZFCalendar <: SingleCalendar

#####
# Methods
#####

function isnewyearsholiday(dt::TimeType, c::NZFCalendar)
    (dayofyear(dt) in [1, 2] ||
        (dayofyear(dt) == 3 && dayofweek(dt) in [Mon, Tue]) ||
        (dayofyear(dt) == 4 && dayofweek(dt) in [Mon, Tue]))
end
function iswaitangiday(dt::TimeType, c = NoFCalendar())
    day(dt) == 6 && month(dt) == Feb
end
function iswaitangidayholiday(dt::TimeType, c::NZFCalendar)
    (month(dt) == Feb && (day(dt) == 6 || # Mondayised since 2013
        (dayofweek(dt) == Mon && day(dt) in [7, 8] && year(dt) > 2013)))
end
function isanzacdayholiday(dt::TimeType, c::NZFCalendar)
    (month(dt) == Apr && (day(dt) == 25 || # Sat, Sun Mondayised since 2013
        (dayofweek(dt) == Mon && day(dt) in [26, 27]) && year(dt) > 2013))
end
function iseasterholiday(dt::TimeType, c::NZFCalendar)
    iseaster(dt, Fri) || iseaster(dt, Mon)
end
function isqueensbirthdayholiday(dt::TimeType, c::NZFCalendar)
    dayofweek(dt) == Mon && dayofweekofmonth(dt) == 1 && month(dt) == Jun
end
function islabourdayholiday(dt::TimeType, c::NZFCalendar)
    dayofweek(dt) == Mon && dayofweekofmonth(dt) == 4 && month(dt) == Oct
end
function ischristmasdayholiday(dt::TimeType, c::NZFCalendar)
    (month(dt) == Dec && (day(dt) == 25 ||
        # Mondayised accounting for Boxing day
        (day(dt) == 27 && dayofweek(dt) in [Mon, Tue])))
end
function isboxingdayholiday(dt::TimeType, c::NZFCalendar)
    (month(dt) == Dec && (day(dt) == 26 ||
        # Mondayised accounting for Christmas day possibly being Mondayised
        (day(dt) == 28 && dayofweek(dt) in [Mon, Tue])))
end

include("calendars_nzau.jl")
include("calendars_nzwe.jl")
