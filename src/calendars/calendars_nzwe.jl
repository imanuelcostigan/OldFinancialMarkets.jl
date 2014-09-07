#####
# Type declarations
#####

immutable NZWEFCalendar <: NZFCalendar end

#####
# Methods
#####

function isanniversarydayholiday(dt::TimeType, c::NZWEFCalendar)
    dayofweek(dt) == Mon && 19 <= day(dt) <= 25 && month(dt) == Jan
end

function isgood(dt::TimeType, c::NZWEFCalendar)
    # http://en.wikipedia.org/wiki/Public_holidays_in_New_Zealand
    # http://www.dol.govt.nz/er/holidaysandleave/publicholidays/publicholidaydates/future-dates.asp
    # Same as Auckland except for different provincial anniversary holiday
    # Extract date atoms
    !(isweekend(dt) || isnewyearsholiday(dt, c) ||
        isanniversarydayholiday(dt, c) || iswaitangidayholiday(dt, c) ||
        iseasterholiday(dt, c) || isanzacdayholiday(dt, c) ||
        isqueensbirthdayholiday(dt, c) || islabourdayholiday(dt, c) ||
        ischristmasdayholiday(dt, c) || isboxingdayholiday(dt, c))
end
