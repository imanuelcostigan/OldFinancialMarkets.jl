#####
# Type declarations
#####
abstract GoodDayReducer
immutable AllDaysGood <: GoodDayReducer end
immutable AnyDaysGood <: GoodDayReducer end

abstract Calendar
abstract SingleCalendar <: Calendar
immutable JointCalendar <: Calendar
    calendars::Vector{SingleCalendar}
    rule::GoodDayReducer
    JointCalendar(c, r = AllDaysGood()) = new(unique(c), r)
end
immutable NoCalendar <: SingleCalendar end


#####
# Methods
#####

Base.join(c1::SingleCalendar, c2::SingleCalendar, r::GoodDayReducer = AllDaysGood()) =
    JointCalendar([c1, c2], r)
Base.join(c1::JointCalendar, c2::SingleCalendar) =
    JointCalendar([c1.calendars, c2], c1.rule)
Base.join(c1::SingleCalendar, c2::JointCalendar) =
    join(c2, c1)
Base.join(c1::JointCalendar, c2::JointCalendar) =
    JointCalendar([c1.calendars, c2.calendars], c1.rule)
Base.convert(::Type{JointCalendar}, c::SingleCalendar) = JointCalendar(c)

#####
# isgood methods
#####

isweekend(dt::TimeType) = dayofweek(dt) in [Sat, Sun]
isgood(dt::TimeType, ::NoCalendar) = !isweekend(dt)
isgood(dt::TimeType) = isgood(dt, NoCalendar())
function isgood(dt::TimeType, c::JointCalendar)
    c.rule([ isgood(dt, ci) for ci in c.calendars ])
end

#####
# Other calendar methods
#####

include("calendars/epochs.jl")
include("calendars/calendars_au.jl")
include("calendars/calendars_gb.jl")
include("calendars/calendars_us.jl")
include("calendars/calendars_euta.jl")
include("calendars/calendars_jp.jl")
include("calendars/calendars_nz.jl")
