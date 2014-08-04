#####
# Type declarations
#####

immutable NZAUFCalendar <: NZFCalendar end

#####
# Methods
#####

function isanniversarydayholiday(dt::TimeType, c::NZAUFCalendar)
    (dayofweek(dt) == Mon && ((day(dt) >= 26 && month(dt) == Jan) ||
        (day(dt) == 1 && month(dt) == Feb)))
end

function isgoodday(dt::TimeType, c::NZAUFCalendar)
    !(isweekend(dt) || isnewyearsholiday(dt, c) ||
        isanniversarydayholiday(dt, c) || iswaitangidayholiday(dt, c) ||
        iseasterholiday(dt, c) || isanzacdayholiday(dt, c) ||
        isqueensbirthdayholiday(dt, c) || islabourdayholiday(dt, c) ||
        ischristmasdayholiday(dt, c) || isboxingdayholiday(dt, c))
end
