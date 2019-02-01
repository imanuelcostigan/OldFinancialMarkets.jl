#####
# Type declarations
#####

abstract type FinCalendar end
abstract type SingleFCalendar <: FinCalendar end
struct JointFCalendar <: FinCalendar
    calendars::Vector{SingleFCalendar}
    onbad::Bool
end
struct NoFCalendar <: SingleFCalendar end


#####
# Methods
#####

JointFCalendar(c::SingleFCalendar...) = JointFCalendar([ ci for ci in c ], true)
Base.:+(c1::SingleFCalendar, c2::SingleFCalendar) = JointFCalendar([c1, c2], true)
Base.:*(c1::SingleFCalendar, c2::SingleFCalendar) = JointFCalendar([c1, c2], false)
Base.:+(jc::JointFCalendar, c::SingleFCalendar) = JointFCalendar([jc.calendars, c],
    jc.onbad)
Base.convert(::Type{JointFCalendar}, c::SingleFCalendar) = JointFCalendar(c)

#####
# isgood methods
#####

isweekend(dt::TimeType) = dayofweek(dt) in [Sat, Sun]
isgood(dt::TimeType, c::NoFCalendar = NoFCalendar()) = !isweekend(dt)
function isgood(dt::TimeType, c::JointFCalendar)
    rule = c.onbad ? all : any
    rule([ isgood(dt, ci) for ci in c.calendars ])
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
