#####
# Type declarations
#####

abstract AUCalendar <: SingleCalendar

#####
# Methods
#####

function isnewyearsholiday(dt::TimeType, c::AUCalendar)
    (dayofyear(dt) == 1 || # Sat, Sun are Mondayised
        (dayofweek(dt) == Mon && (dayofyear(dt) in [2, 3])))
end
function isaustraliadayholiday(dt::TimeType, c::AUCalendar)
    (dayofyear(dt) == 26 || # Sat, Sun are Mondayised
        (dayofweek(dt) == Mon && (dayofyear(dt) in [27, 28])))
end
function isanzacdayholiday(dt::TimeType, c::AUCalendar)
    # Not mondayised in either Syd or Mel
    month(dt) == Apr && day(dt) == 25
end
function iseasterholiday(dt::TimeType, c::AUCalendar)
    iseaster(dt, Fri) || iseaster(dt, Mon)
end
function isqueensbirthdayholiday(dt::TimeType, c::AUCalendar)
    dayofweek(dt) == Mon && dayofweekofmonth(dt) == 2 && month(dt) == Jun
end
function ischristmasdayholiday(dt::TimeType, c::AUCalendar)
    (month(dt) == Dec && (day(dt) == 25 ||
        # Mondayised accounting for Boxing day
        (day(dt) == 27 && dayofweek(dt) in [Mon, Tue])))
end
function isboxingdayholiday(dt::TimeType, c::AUCalendar)
    (month(dt) == Dec && (day(dt) == 26 ||
        # Mondayised accounting for Christmas day possibly being Mondayised
        (day(dt) == 28 && dayofweek(dt) in [Mon, Tue])))
end

include("calendars_ausy.jl")
include("calendars_aume.jl")
