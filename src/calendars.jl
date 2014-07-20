#####
# Type declarations
#####

abstract FinCalendar <: ISOCalendar
abstract NoFCalendar <: FinCalendar

#####
# Epochs and their checkers
#####

isweekend(dt::Date, c = NoFCalendar()) = dayofweek(dt) in [Sat, Sun]
isnewyearsday(dt::Date, c = NoFCalendar()) = dayofyear(dt) == 1
isaustraliaday(dt::Date, c = NoFCalendar()) = (month(dt) == Jan &&
    day(dt) == 26)
isanzacday(dt::Date, c = NoFCalendar()) = (month(dt) == Apr && day(dt) == 25)
function easter(y::Integer, day = Sun, c = NoFCalendar())
    # Using Meeus/Jones/Butcher algorithm
    # https://en.wikipedia.org/wiki/Computus#Anonymous_Gregorian_algorithm
    a = mod(y, 19)
    b = div(y, 100)
    c = mod(y, 100)
    d = div(b, 4)
    e = mod(b, 4)
    f = div(b + 8, 25)
    g = div(b - f + 1, 3)
    h = mod(19a + b - d - g + 15, 30)
    i = div(c, 4)
    k = mod(c, 4)
    l = mod(32 + 2e + 2i - h - k, 7)
    m = div(a + 11h + 22l, 451)
    n = div(h + 1 - 7m + 114, 31)
    p = mod(h + 1 - 7m + 114, 31)
    dt = Date(y, n, p + 1)
    if day == Fri
        dt += Day(-2)
    elseif day == Sat
        dt += Day(-1)
    elseif day == Mon
        dt += Day(1)
    else
        info("day must be Fri, Sat, Sun or Mon only. Defaulted to Sun.")
    end
    return dt
end
easter(dt::Date, day = Sun, c = NoFCalendar()) = easter(year(dt), day, c)
iseaster(dt::Date, day = Sun, c = NoFCalendar()) = dt == easter(dt, day, c)
ischristmasday(dt::Date, c = NoFCalendar()) = (month(dt) == Dec &&
    day(dt) == 25)
isboxingday(dt::Date, c::NoFCalendar()) = (month(dt) == Dec &&
    day(dt) == 26)

#####
# Holiday functions
#####

function isnewyearholiday(dt::Date, substitutedays::Array{Integer})
    isnewyearsday(dt) || (month(dt) == Jan && dayofweek(dt) == Mon &&
        ((day(dt) == 2 && Sun in substitutedays) ||
            (day(dt) == 3 && Sat in substitutedays)))
end
function isaustraliadayholiday(dt::Date, substitutedays::Array{Integer})
    isaustraliaday(dt) || (month(dt) == Jan && dayofweek(dt) == Mon &&
        ((day(dt) == 27 && Sun in substitutedays) ||
            (day(dt) == 28 && Sat in substitutedays)))
end
function isanzacdayholiday(dt::Date, substitutedays::Array{Integer})
    isanzacday(dt) || (month(dt) == April && dayofweek(dt) == Mon &&
        ((day(dt) == 26 Sun in substitutedays) ||
            (day(dt) == 27 && Sat in substitutedays)))
end
function iseasterholiday(dt::Date, days::Array{Integer})
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

include("calendar_sydney.jl")
