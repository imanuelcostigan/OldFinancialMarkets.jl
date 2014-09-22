#####
# Type declarations
#####

immutable AUSYFCalendar <: AUFCalendar end

#####
# Methods
#####
function isbankholiday(dt::TimeType, c::AUSYFCalendar)
    dayofweek(dt) == Mon && dayofweekofmonth(dt) == 1 && month(dt) == Aug
end
function islabourdayholiday(dt::TimeType, c::AUSYFCalendar)
    dayofweek(dt) == Mon && dayofweekofmonth(dt) == 1 && month(dt) == Oct
end
function isgood(dt::TimeType, c::AUSYFCalendar)
    # http://en.wikipedia.org/wiki/Public_holidays_in_Australia
    # http://www.legislation.nsw.gov.au/maintop/view/inforce/act+115+2010+cd+0+N
    !(isweekend(dt) || isnewyearsholiday(dt, c) ||
        isaustraliadayholiday(dt, c) || isanzacdayholiday(dt, c) ||
        ischristmasdayholiday(dt, c) || isboxingdayholiday(dt, c) ||
        iseasterholiday(dt, c) || isqueensbirthdayholiday(dt, c) ||
        isbankholiday(dt, c) || islabourdayholiday(dt, c))
end

