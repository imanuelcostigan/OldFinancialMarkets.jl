#####
# Type declarations
#####

abstract EUFCalendar <: FinCalendar
immutable EUTAFCalendar <: EUFCalendar end

#####
# Methods
#####

function isnewyearsholiday(dt::TimeType, c::EUFCalendar)
    isnewyearsholiday(dt)
end
function iseasterholiday(dt::TimeType, c::EUFCalendar)
    iseasterholiday(dt, [Fri, Mon]) && year(dt) >= 2000
end
function islabourdayholiday(dt::TimeType, c::EUTAFCalendar)
    day(dt) == 1 && month(dt) == May && year(dt) >= 2000
end
function ischristmasdayholiday(dt::TimeType, c::EUFCalendar)
    day(dt) in [25, 26] && month(dt) == Dec
end
function istargetclosed(dt::TimeType, c::EUTAFCalendar)
    day(dt) == 31 && month(dt) == 12 && year(dt) in [1999, 2001]
end
function isgoodday(dt::TimeType, c::EUTAFCalendar)
    year(dt) <= 1998 && error("TARGET only existed after 1998.")
    !(isweekend(dt) || isnewyearsholiday(dt, c) ||
        iseasterholiday(dt, c) || ischristmasdayholiday(dt, c) ||
        islabourdayholiday(dt, c) || istargetclosed(dt, c))
end
