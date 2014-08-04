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

function isgoodday(dt::TimeType, c::NZWEFCalendar)
    !(isweekend(dt) || isnewyearsholiday(dt, c) ||
        isanniversarydayholiday(dt, c) || iswaitangidayholiday(dt, c) ||
        iseasterholiday(dt, c) || isanzacdayholiday(dt, c) ||
        isqueensbirthdayholiday(dt, c) || islabourdayholiday(dt, c) ||
        ischristmasdayholiday(dt, c) || isboxingdayholiday(dt, c))
end
