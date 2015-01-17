#####
# Type declarations
#####

immutable NZAUCalendar <: NZCalendar end

#####
# Methods
#####

function isanniversarydayholiday(dt::TimeType, c::NZAUCalendar)
    (dayofweek(dt) == Mon && ((day(dt) >= 26 && month(dt) == Jan) ||
        (day(dt) == 1 && month(dt) == Feb)))
end

function isgood(dt::TimeType, c::NZAUCalendar)
    # http://en.wikipedia.org/wiki/Public_holidays_in_New_Zealand
    # http://www.dol.govt.nz/er/holidaysandleave/publicholidays/publicholidaydates/future-dates.asp
    !(isweekend(dt) || isnewyearsholiday(dt, c) ||
        isanniversarydayholiday(dt, c) || iswaitangidayholiday(dt, c) ||
        iseasterholiday(dt, c) || isanzacdayholiday(dt, c) ||
        isqueensbirthdayholiday(dt, c) || islabourdayholiday(dt, c) ||
        ischristmasdayholiday(dt, c) || isboxingdayholiday(dt, c))
end
