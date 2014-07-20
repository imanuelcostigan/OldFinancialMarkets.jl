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
easter(dt::Date, day = Sun, c = NoFCalendar()) = easter(year(dt), day, c)
isweekend(dt::Date, c = NoFCalendar()) = dayofweek(dt) in [Sat, Sun]
isnewyearsday(dt::Date, c = NoFCalendar()) = dayofyear(dt) == 1
isaustraliaday(dt::Date, c = NoFCalendar()) = (month(dt) == Jan &&
    day(dt) == 26)
isanzacday(dt::Date, c = NoFCalendar()) = (month(dt) == Apr && day(dt) == 25)
iseaster(dt::Date, day = Sun, c = NoFCalendar()) = dt == easter(dt, day, c)
ischristmasday(dt::Date, c = NoFCalendar()) = (month(dt) == Dec &&
    day(dt) == 25)
isboxingday(dt::Date, c = NoFCalendar()) = (month(dt) == Dec &&
    day(dt) == 26)

#####
# Holiday functions
#####

function isnewyearsholiday(dt::Date, substitutedays::Array{Int64, 1})
    isnewyearsday(dt) || (month(dt) == Jan && dayofweek(dt) == Mon &&
        ((day(dt) == 2 && Sun in substitutedays) ||
            (day(dt) == 3 && Sat in substitutedays)))
end
function isaustraliadayholiday(dt::Date, substitutedays::Array{Int64, 1})
    isaustraliaday(dt) || (month(dt) == Jan && dayofweek(dt) == Mon &&
        ((day(dt) == 27 && Sun in substitutedays) ||
            (day(dt) == 28 && Sat in substitutedays)))
end
function isanzacdayholiday(dt::Date, substitutedays::Array{Int64, 1})
    isanzacday(dt) || (month(dt) == April && dayofweek(dt) == Mon &&
        ((day(dt) == 26 && Sun in substitutedays) ||
            (day(dt) == 27 && Sat in substitutedays)))
end
function iseasterholiday(dt::Date, days::Array{Int64, 1})
    any([iseaster(dt, day) for day in days])
end
function ischristmasdayholiday(dt::Date, substitute::Bool)
    ischristmasday(dt) || (substitute && month(dt) == Dec &&
        day(dt) == 27 && dayofweek(dt) in [Mon, Tue])
end
function isboxingdayholiday(dt::Date, substitute::Bool)
     isboxingday(dt::Date) || (substitute && month(dt) == Dec &&
        day(dt) == 28 && dayofweek(dt) in [Mon, Tue])
end

#####
# isgoodday methods
#####

isgoodday(dt::Date) = true
isgoodday(dt::Date, c = NoFCalendar()) = !isweekend(dt, c)

#####
# Other calendar methods
#####

include("calendars_sydney.jl")
