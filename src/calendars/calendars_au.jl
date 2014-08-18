#####
# Type declarations
#####

abstract AUFCalendar <: JointFCalendar

#####
# Methods
#####

function isnewyearsholiday(dt::TimeType, c::AUFCalendar)
    isnewyearsholiday(dt, [Sat, Sun])
end
function isaustraliadayholiday(dt::TimeType, c::AUFCalendar)
    isaustraliadayholiday(dt, [Sat, Sun])
end
function isanzacdayholiday(dt::TimeType, c::AUFCalendar)
    isanzacdayholiday(dt)
end
function iseasterholiday(dt::TimeType, c::AUFCalendar)
    iseasterholiday(dt, [Fri, Mon])
end
function isqueensbirthdayholiday(dt::TimeType, c::AUFCalendar)
    dayofweek(dt) == Mon && dayofweekofmonth(dt) == 2 && month(dt) == Jun
end
function ischristmasdayholiday(dt::TimeType, c::AUFCalendar)
    ischristmasdayholiday(dt, true)
end
function isboxingdayholiday(dt::TimeType, c::AUFCalendar)
    isboxingdayholiday(dt, true)
end

include("calendars_ausy.jl")
include("calendars_aume.jl")
