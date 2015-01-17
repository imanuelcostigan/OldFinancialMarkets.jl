#####
# Type declarations
#####

abstract Calendar
abstract SingleFCalendar <: Calendar
immutable JointFCalendar <: Calendar
    calendars::Vector{SingleFCalendar}
    is_good_on_rule::Function
    function JointFCalendar(c, r = all)
        msg = "is_good_on_rule must be either `any` or `all`"
        r in [any, all] || throw(ArgumentError(msg))
        new(unique(c), r)
    end
end
immutable NoFCalendar <: SingleFCalendar end


#####
# Methods
#####

join(c1::SingleFCalendar, c2::SingleFCalendar, r::Function = all) =
    JointFCalendar([c1, c2], r)
join(c1::JointFCalendar, c2::SingleFCalendar) =
    JointFCalendar([c1.calendars, c2], c1.is_good_on_rule)
join(c1::SingleFCalendar, c2::JointFCalendar) =
    join(c2, c1)
join(c1::JointFCalendar, c2::JointFCalendar) =
    JointFCalendar([c1.calendars, c2.calendars], c1.is_good_on_rule)
join{T<:SingleFCalendar}(c::Vector{T}, r::Function = all) =
    JointFCalendar([ ci for ci in c ], r)
join{T<:JointFCalendar}(jcs::Vector{T}) =
    JointFCalendar([ jc.calendars for jc in jcs ], jcs[1].is_good_on_rule)
Base.convert(::Type{JointFCalendar}, c::SingleFCalendar) = JointFCalendar(c)

#####
# isgood methods
#####

isweekend(dt::TimeType) = dayofweek(dt) in [Sat, Sun]
isgood(dt::TimeType, ::NoFCalendar) = !isweekend(dt)
isgood(dt::TimeType) = isgood(dt, NoFCalendar())
function isgood(dt::TimeType, c::JointFCalendar)
    c.is_good_on_rule([ isgood(dt, ci) for ci in c.calendars ])
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
