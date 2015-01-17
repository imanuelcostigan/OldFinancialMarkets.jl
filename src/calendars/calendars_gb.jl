#####
# Type declarations
#####

abstract GBFCalendar <: SingleCalendar
immutable GBLOFCalendar <: GBFCalendar end

#####
# Methods
#####

function isnewyearsholiday(dt::TimeType, c::GBFCalendar)
    (dayofyear(dt) == 1 || # Sat, Sun are Mondayised
        (dayofweek(dt) == Mon && (dayofyear(dt) in [2, 3])))
end
function iseasterholiday(dt::TimeType, c::GBFCalendar)
    iseaster(dt, Fri) || iseaster(dt, Mon)
end
function isbankholiday(dt::TimeType, c::GBFCalendar)
    # May Day
    ismayday = (dayofweek(dt) == Mon && dayofweekofmonth(dt) == 1 &&
        month(dt) == May && year(dt) >= 1978)
    # Spring
    isspring = (dayofweek(dt) == Mon && dayofweekofmonth(dt) >= 4 &&
        month(dt) == May && year(dt) >= 1971 && !(year(dt) in [2002, 2012]))
    # Last summer
    issummer = (dayofweek(dt) == Mon && dayofweekofmonth(dt) >= 4 &&
        month(dt) == Aug && year(dt) >= 1971)
    # Alternative for Queen's golden and diamond Jubilee
    isalt = day(dt) == 4 && month(dt) == Jun && year(dt) in [2002, 2012]
    return ismayday || isspring || issummer || isalt
end
function isqueensjubileeholiday(dt::TimeType, c::GBFCalendar)
    day(dt) == 5 && month(dt) == Jun && year(dt) == 2012
end
function ischristmasdayholiday(dt::TimeType, c::GBFCalendar)
    month(dt) == Dec && day(dt) == 25
end
function isboxingdayholiday(dt::TimeType, c::GBFCalendar)
    (month(dt) == Dec && (day(dt) == 26 ||
        # Mondayised accounting for Christmas day possibly being Mondayised
        (day(dt) == 27 && dayofweek(dt) in [Mon, Tue])))
end
function isroyalweddingholiday(dt::TimeType, c::GBFCalendar)
    day(dt) == 29 && month(dt) == 4 && year(dt) == 2011
end
function isgood(dt::TimeType, c::GBFCalendar)
    # http://en.wikipedia.org/wiki/Public_holidays_in_the_United_Kingdom
    # http://en.wikipedia.org/wiki/Bank_holiday [2002, 2012 spring bank hol moved
    # to 4 Jun for Queen's jubilee]
    # http://www.timeanddate.com/holidays/uk/spring-bank-holiday#obs
    # http://www.legislation.gov.uk/ukpga/1971/80
    !(isweekend(dt) || isnewyearsholiday(dt, c) ||
        iseasterholiday(dt, c) || isbankholiday(dt, c) ||
        isqueensjubileeholiday(dt, c) || isbankholiday(dt, c) ||
        ischristmasdayholiday(dt, c) || isboxingdayholiday(dt, c) ||
        isroyalweddingholiday(dt, c))
end
