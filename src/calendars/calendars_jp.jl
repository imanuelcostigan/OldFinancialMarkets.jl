#####
# Type declarations
#####


abstract JPFCalendar <: SingleFCalendar
immutable JPTOFCalendar <: JPFCalendar end

#####
# Methods
#####

function isnewyearsholiday(dt::TimeType, c::JPFCalendar)
    isnewyearsholiday(dt)
end
function isbankholiday(dt::TimeType, c::JPFCalendar)
    ((month(dt) == Jan && day(dt) in [2, 3]) ||
        month(dt) == Dec && day(dt) == 31)
end
function iscomingofageholiday(dt::TimeType, c::JPFCalendar)
    ((dayofweekofmonth(dt) == 2 && dayofweek(dt) == Mon && month(dt) == Jan &&
        year(dt) >= 2000) ||
    ((day(dt) == 15 || (day(dt) == 16 && dayofweek(dt) == Mon)) &&
        month(dt) == Jan && year(dt) < 2000))
end
function isfoundationdayholiday(dt::TimeType, c::JPFCalendar)
    ((day(dt) == 11 || (day(dt) == 12 && dayofweek(dt) == Mon)) &&
        month(dt) == Feb)
end
function isshowadayholiday(dt::TimeType, c::JPFCalendar)
    ((day(dt) == 29 || (day(dt) == 30 && dayofweek(dt) == Mon)) &&
        month(dt) == Apr)
end
function ismayholiday(dt::TimeType, c::JPFCalendar)
    # Constitution, Greenery & Children's days
    month(dt) == May && (day(dt) in 3:5 || (day(dt) == 6 &&
        dayofweek(dt) in [Mon, Tue, Wed]))
end
function ismarinedayholiday(dt::TimeType, c::JPFCalendar)
    (month(dt) == Jul && (year(dt) >= 2003 && dayofweek(dt) == Mon &&
        dayofweekofmonth(dt) == 3) || (year(dt) < 2003 && (day(dt) == 20 ||
            (day(dt) == 21 && dayofweek(dt) == Mon))))
end
function isrespectforagedholiday(dt::TimeType, c::JPFCalendar)
    (month(dt) == Sep && ((dayofweek(dt) == Mon && dayofweekofmonth(dt) == 3 &&
        year(dt) >= 2003) || (day(dt) == 15 || (day(dt) == 16 &&
            dayofweek(dt) == Mon)) && year(dt) < 2003))
end
function iscitizensdayholiday(dt::TimeType, c::JPFCalendar)
    (year(dt) >= 2003 && month(dt) == Sep && dayofweek(dt) == Tue &&
        dayofweekofmonth(dt) == 3 && isseasonstartholiday(dt + Day(1), Sep))
end
function isseasonstartholiday(dt::TimeType, c::JPFCalendar)
    # Vernal & autumnal equinoxes (both Mondayised)
    (isseasonstartholiday(Date(dt), Mar, [Sun]) ||
        isseasonstartholiday(Date(dt), Sep, [Sun]))
end
function ishealthandsportsdayholiday(dt::TimeType, c::JPFCalendar)
    (month(dt) == Oct && ((year(dt) >= 2000 && dayofweek(dt) == Mon &&
        dayofweekofmonth(dt) == 2) || (year(dt) < 2000 && (day(dt) == 10 ||
            day(dt) == 11 && dayofweek(dt) == Mon))))
end
function isculturedayholiday(dt::TimeType, c::JPFCalendar)
    month(dt) == Nov && (day(dt) == 3 || (day(dt) == 4 && dayofweek(dt) == Mon))
end
function islabourdayholiday(dt::TimeType, c::JPFCalendar)
    (month(dt) == Nov && (day(dt) == 23 ||
        (day(dt) == 24 && dayofweek(dt) == Mon)))
end
function isemperorsbirthdayholiday(dt::TimeType, c::JPFCalendar)
    (month(dt) == Dec && (day(dt) == 23 ||
        (day(dt) == 24 && dayofweek(dt) == Mon)))
end
function isgood(dt::TimeType, c::JPFCalendar)
    #   http://en.wikipedia.org/wiki/Public_holidays_in_Japan
    !(isweekend(dt) || isnewyearsholiday(dt, c) || isbankholiday(dt, c) ||
        iscomingofageholiday(dt, c) || isfoundationdayholiday(dt, c) ||
        isseasonstartholiday(dt, c) || isshowadayholiday(dt, c) ||
        ismayholiday(dt, c) || ismarinedayholiday(dt, c) ||
        isrespectforagedholiday(dt, c) || iscitizensdayholiday(dt, c) ||
        ishealthandsportsdayholiday(dt, c) || isculturedayholiday(dt, c) ||
        islabourdayholiday(dt, c) || isemperorsbirthdayholiday(dt, c))
end
