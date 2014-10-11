#####
# Type declarations
#####

immutable AUMEFCalendar <: AUFCalendar end

#####
# Methods
#####
function islabourdayholiday(dt::TimeType, c::AUMEFCalendar)
    dayofweek(dt) == Mon && dayofweekofmonth(dt) == 2 && month(dt) == Mar
end
function ismelbournecupholiday(dt::TimeType, c::AUMEFCalendar)
    dayofweek(dt) == Tue && dayofweekofmonth(dt) == 1 && month(dt) == Nov
end
function isgood(dt::TimeType, c::AUMEFCalendar)
    # http://en.wikipedia.org/wiki/Public_holidays_in_Australia
    !(isweekend(dt) || isnewyearsholiday(dt, c) ||
        isaustraliadayholiday(dt, c) || isanzacdayholiday(dt, c) ||
        ischristmasdayholiday(dt, c) || isboxingdayholiday(dt, c) ||
        iseasterholiday(dt, c) || isqueensbirthdayholiday(dt, c) ||
        ismelbournecupholiday(dt, c) || islabourdayholiday(dt, c))
end

