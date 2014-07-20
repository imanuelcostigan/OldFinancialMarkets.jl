#####
# Type declarations
#####

immutable AUSYFCalendar <: FinCalendar end

#####
# Methods
#####
function isnewyearsholiday(dt::Date, c::AUSYFCalendar())
    isnewyearsholiday(dt, [Sat, Sun])
end
function isaustraliadayholiday(dt::Date, c::AUSYFCalendar())
    isaustraliadayholiday(dt, [Sat, Sun])
end
function iseasterholiday(dt::Date, c::AUSYFCalendar())
    iseasterholiday(dt, [Fri, Mon])
end
function isanzacdayholiday(dt::Date, c::AUSYFCalendar())
    isanzacdayholiday(dt, [Sat, Sun])
end
function isqueensbirthdayholiday(dt::Date, c::AUSYFCalendar())
    dayofweek(dt) == Mon && dayofweekofmonth(dt) == 2 && month(dt) == Jun
end
function isbankholiday(dt::Date, c::AUSYFCalendar())
    dayofweek(dt) == Mon && dayofweekofmonth(dt) == 1 && month(dt) == Aug
end
function islabourdayholiday(dt::Date, c::AUSYFCalendar())
    dayofweek(dt) == Mon && dayofweekofmonth(dt) == 1 && month(dt) == Oct
end
function ischristmasdayholiday(dt::Date, c::AUSYFCalendar())
    ischristmasdayholiday(dt, true)
end
function isboxingdayholiday(dt::Date, c::AUSYFCalendar())
    isboxingdayholiday(dt, true)
end
function isgoodday(dt::Date, c::AUSYFCalendar())
    !(isweekend(dt) || isnewyearsholiday(dt, c) ||
        isaustraliadayholiday(dt, c) || isanzacdayholiday(dt, c) ||
        ischristmasdayholiday(dt, c) || isboxingdayholiday(dt, c) ||
        iseasterholiday(dt, c) || isqueensbirthdayholiday(dt, c) ||
        isqueensbirthdayholiday(dt, c) || isbankholiday(dt, c))
end

