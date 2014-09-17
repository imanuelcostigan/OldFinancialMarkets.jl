#####
# Type declarations
#####

abstract FinCalendar
abstract SingleFCalendar <: FinCalendar
immutable JointFCalendar <: FinCalendar
    calendars::Vector{SingleFCalendar}
    onbad::Bool
end
immutable NoFCalendar <: SingleFCalendar end


#####
# Methods
#####

JointFCalendar(c::SingleFCalendar...) = JointFCalendar([ ci for ci in c ], true)
+(c1::SingleFCalendar, c2::SingleFCalendar) = JointFCalendar([c1, c2], true)
*(c1::SingleFCalendar, c2::SingleFCalendar) = JointFCalendar([c1, c2], false)
+(jc::JointFCalendar, c::SingleFCalendar) = JointFCalendar([jc.calendars, c],
    jc.onbad)
Base.convert(::Type{JointFCalendar}, c::SingleFCalendar) = JointFCalendar(c)

####
# Temporal methods
####

isweekend(dt::TimeType, c = NoFCalendar()) = dayofweek(dt) in [Sat, Sun]
isnewyearsday(dt::TimeType, c = NoFCalendar()) = dayofyear(dt) == 1
isaustraliaday(dt::TimeType, c = NoFCalendar()) = (month(dt) == Jan &&
    day(dt) == 26)
isanzacday(dt::TimeType, c = NoFCalendar()) = (month(dt) == Apr &&
    day(dt) == 25)
iseaster(dt::TimeType, day = Sun, c = NoFCalendar()) = (Date(dt) ==
    easter(dt, day))
ischristmasday(dt::TimeType, c = NoFCalendar()) = (month(dt) == Dec &&
    day(dt) == 25)
isboxingday(dt::TimeType, c = NoFCalendar()) = (month(dt) == Dec &&
    day(dt) == 26)
isseasonstart(dt::DateTime, m::Integer, c = NoFCalendar()) = (dt ==
    seasonstart(dt, m))
isseasonstart(dt::Date, m::Integer, c = NoFCalendar()) = (dt ==
    seasonstart(dt, m))


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
isseasonstartholiday(dt::TimeType, m::Integer) = isseasonstart(Date(dt), m)
function isseasonstartholiday(dt::TimeType, m::Integer,
    substitutedays::Array{Int, 1})
isseasonstart(Date(dt), m) || (dayofweek(dt) == Mon &&
    ((dt == Date(seasonstart(dt, m)) + Day(1) && Sun in substitutedays) ||
        (dt == Date(seasonstart(dt, m)) + Day(2) && Sat in substitutedays)))
end

#####
# isgood methods
#####

isgood(dt::TimeType, c = NoFCalendar()) = !isweekend(dt, c)
function isgood(dt::TimeType, c::JointFCalendar)
    rule = c.onbad ? all : any
    rule([ isgood(dt, ci) for ci in c.calendars ])
end

#####
# Other calendar methods
#####

include("calendars/epochs.jl")
include("calendars/calendars_au.jl")
include("calendars/calendars_us.jl")
include("calendars/calendars_gb.jl")
include("calendars/calendars_euta.jl")
include("calendars/calendars_jp.jl")
include("calendars/calendars_nz.jl")
