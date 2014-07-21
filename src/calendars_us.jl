#####
# Type declarations
#####

abstract USFCalendar <: FinCalendar
immutable USNYFCalendar <: USFCalendar end

#####
# Methods
#####

function isnewyearsholiday(dt::Date, c::USFCalendar)
    (isnewyearsday(dt) ||
        (day(dt) == 31 && month(dt) == Dec && dayofweek(dt) == Fri) ||
        (day(dt) == 2 && month(dt) == Jan && dayofweek(dt) == Mon))
end
function ismlkdayholiday(dt::Date, c::USFCalendar)
    dayofweekofmonth(dt) == 3 && dayofweek(dt) == Mon && month(dt) == Jan
end
function iswashingtonsbdayholiday(dt::Date, c::USFCalendar)
    dayofweekofmonth(dt) == 3 && dayofweek(dt) == Mon && month(dt) == Feb
end
function ismemorialdayholiday(dt::Date, c::USFCalendar)
    day(dt) > 24 && dayofweek(dt) == Mon && month(dt) == May
end
function isindependencedayholiday(dt::Date, c::USFCalendar)
    ((day(dt) == 4 ||
        (day(dt) == 3 && dayofweek(dt) == Fri) ||
        (day(dt) == 5 && dayofweek(dt) == Mon)) && month(dt) == Jul)
end
function islabourdayholiday(dt::Date, c::USFCalendar)
    dayofweekofmonth(dt) == 1 && dayofweek(dt) == Mon && month(dt) == Sep
end
function iscolumbusdayholiday(dt::Date, c::USFCalendar)
    dayofweekofmonth(dt) == 2 && dayofweek(dt) == Mon && month(dt) == Oct
end
function isveteransdayholiday(dt::Date, c::USFCalendar)
    ((day(dt) == 11 ||
        (day(dt) == 10 && dayofweek(dt) == Fri) ||
        (day(dt) == 12 && dayofweek(dt) == Mon)) && month(dt) == Nov)
end
function isthanksgivingdayholiday(dt::Date, c::USFCalendar)
    dayofweekofmonth(dt) == 4 && dayofweek(dt) == Thu && month(dt) == Nov
end
function ischristmasdayholiday(dt::Date, c::USFCalendar)
    (ischristmasday(dt) ||
        (((day(dt) == 24 && dayofweek(dt) == Fri) ||
            (day(dt) == 26 && dayofweek(dt) == Mon)) && month(dt) == Dec))
end
function isgoodday(dt::Date, c::USFCalendar)
    !(isweekend(dt) || isnewyearsholiday(dt, c) ||
        ismlkdayholiday(dt, c) || iswashingtonsbdayholiday(dt, c) ||
        ismemorialdayholiday(dt, c) || isindependencedayholiday(dt, c) ||
        islabourdayholiday(dt, c) || iscolumbusdayholiday(dt, c) ||
        isveteransdayholiday(dt, c) || isthanksgivingdayholiday(dt, c) ||
        ischristmasdayholiday(dt, c))
end


