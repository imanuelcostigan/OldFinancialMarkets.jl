#####
# Type declarations
#####

abstract GBFCalendar <: FinCalendar
immutable GBLOFCalendar <: GBFCalendar end

#####
# Methods
#####

function isnewyearsholiday(dt::TimeType, c::GBFCalendar)
    isnewyearsholiday(dt, [Sat, Sun])
end
function iseasterholiday(dt::TimeType, c::GBFCalendar)
    iseasterholiday(dt, [Fri, Mon])
end
function isbankholiday(dt::TimeType, c::GBFCalendar)
    # May Day
    ismayday = (dayofweek(dt) == Mon && dayofweekofmonth(dt) == 1 &&
        month(dt) == May && year(dt) >= 1978 && !(year(dt) in [2002, 2012]))
    # Spring
    isspring = (dayofweek(dt) == Mon && dayofweekofmonth(dt) >= 4 &&
        month(dt) == May && year(dt) >= 1971 && !(year(dt) in [2002, 2012]))
    # Last summer
    issummer = (dayofweek(dt) == Mon && dayofweekofmonth(dt) >= 4 &&
        month(dt) == Aug && year(dt) >= 1971)
    # Alternative for Queen's golden and diamond Jubilee
    isalt = day(dt) == 4 && month(dt) == Jun && year(dt) in [2002, 2012]
    return ismayday || isspring || isalt
end
function isqueensjubileeholiday(dt::TimeType, c::GBFCalendar)
    day(dt) == 5 && month(dt) == Jun && year(dt) == 2012
end
function ischristmasdayholiday(dt::TimeType, c::GBFCalendar)
    ischristmasdayholiday(dt, false)
end
function isboxingdayholiday(dt::TimeType, c::GBFCalendar)
    isboxingdayholiday(dt, true)
end
function isroyalweddingholiday(dt::TimeType, c::GBFCalendar)
    day(dt) == 29 && month(dt) == 4 && year(dt) == 2011
end
function isgoodday(dt::TimeType, c::GBFCalendar)
    !(isweekend(dt) || isnewyearsholiday(dt, c) ||
        iseasterholiday(dt, c) || isbankholiday(dt, c) ||
        isqueensjubileeholiday(dt, c) || isbankholiday(dt, c) ||
        ischristmasdayholiday(dt, c) || isboxingdayholiday(dt, c) ||
        isroyalweddingholiday(dt, c))
end
