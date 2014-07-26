#####
# Type declarations
#####

abstract FinCalendar
immutable NoFCalendar <: FinCalendar end

#####
# Epochs and their checkers
#####
function easter(y::Integer, day = Sun, c = NoFCalendar())
    # Using Meeus/Jones/Butcher algorithm
    # https://en.wikipedia.org/wiki/Computus#Anonymous_Gregorian_algorithm
    a = mod(y, 19)
    b = div(y, 100)
    cc = mod(y, 100)
    d = div(b, 4)
    e = mod(b, 4)
    f = div(b + 8, 25)
    g = div(b - f + 1, 3)
    hh = mod(19a + b - d - g + 15, 30)
    i = div(cc, 4)
    k = mod(cc, 4)
    ll = mod(32 + 2e + 2i - hh - k, 7)
    m = div(a + 11hh + 22ll, 451)
    n = div(hh + ll - 7m + 114, 31)
    p = mod(hh + ll - 7m + 114, 31)
    dt = Date(y, n, p + 1)
    if day == Fri
        return dt + Day(-2)
    elseif day == Sat
        return dt + Day(-1)
    elseif day == Sun
        return dt
    elseif day == Mon
        return dt + Day(1)
    else
        info("day must be Fri, Sat, Sun or Mon only. Defaulted to Sun.")
        return dt
    end
end
easter(dt::TimeType, day = Sun, c = NoFCalendar()) = easter(year(dt), day, c)
isweekend(dt::TimeType, c = NoFCalendar()) = dayofweek(dt) in [Sat, Sun]
isnewyearsday(dt::TimeType, c = NoFCalendar()) = dayofyear(dt) == 1
isaustraliaday(dt::TimeType, c = NoFCalendar()) = (month(dt) == Jan &&
    day(dt) == 26)
isanzacday(dt::TimeType, c = NoFCalendar()) = (month(dt) == Apr &&
    day(dt) == 25)
iseaster(dt::TimeType, day = Sun, c = NoFCalendar()) = (Date(dt) ==
    easter(dt, day, c))
ischristmasday(dt::TimeType, c = NoFCalendar()) = (month(dt) == Dec &&
    day(dt) == 25)
isboxingday(dt::TimeType, c = NoFCalendar()) = (month(dt) == Dec &&
    day(dt) == 26)

#####
# Holiday functions
#####

isnewyearsholiday(dt::TimeType) = isnewyearsday(dt)
function isnewyearsholiday(dt::TimeType, substitutedays::Array{Int, 1})
    isnewyearsday(dt) || (month(dt) == Jan && dayofweek(dt) == Mon &&
        ((day(dt) == 2 && Sun in substitutedays) ||
            (day(dt) == 3 && Sat in substitutedays)))
end
isaustraliadayholiday(dt::TimeType) = isaustraliaday(dt)
function isaustraliadayholiday(dt::TimeType, substitutedays::Array{Int, 1})
    isaustraliaday(dt) || (month(dt) == Jan && dayofweek(dt) == Mon &&
        ((day(dt) == 27 && Sun in substitutedays) ||
            (day(dt) == 28 && Sat in substitutedays)))
end
isanzacdayholiday(dt::TimeType) = isanzacday(dt)
function isanzacdayholiday(dt::TimeType, substitutedays::Array{Int, 1})
    isanzacday(dt) || (month(dt) == April && dayofweek(dt) == Mon &&
        ((day(dt) == 26 && Sun in substitutedays) ||
            (day(dt) == 27 && Sat in substitutedays)))
end
iseasterholiday(dt::TimeType) = iseaster(dt)
function iseasterholiday(dt::TimeType, days::Array{Int, 1})
    any([iseaster(dt, day) for day in days])
end
ischristmasdayholiday(dt::TimeType) = ischristmasday(dt)
function ischristmasdayholiday(dt::TimeType, substitute::Bool)
    ischristmasday(dt) || (substitute && month(dt) == Dec &&
        day(dt) == 27 && dayofweek(dt) in [Mon, Tue])
end
isboxingdayholiday(dt::TimeType) = isboxingday(dt)
function isboxingdayholiday(dt::TimeType, substitute::Bool)
    isboxingday(dt) || (substitute && month(dt) == Dec && day(dt) == 28 &&
        dayofweek(dt) in [Mon, Tue])
end

#####
# isgoodday methods
#####

isgoodday(dt::TimeType, c = NoFCalendar()) = !isweekend(dt, c)

#####
# Other calendar methods
#####

include("calendars_au.jl")
include("calendars_us.jl")
