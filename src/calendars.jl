#####
# Type declarations
#####

abstract Calendar
abstract SingleCalendar <: Calendar
immutable JointCalendar <: Calendar
    calendars::Vector{SingleCalendar}
    is_good_on_rule::Function
    function JointCalendar(c, r = all)
        msg = "is_good_on_rule must be either `any` or `all`"
        r in [any, all] || throw(ArgumentError(msg))
        new(unique(c), r)
    end
end
immutable NoCalendar <: SingleCalendar end


#####
# Methods
#####

join(c1::SingleCalendar, c2::SingleCalendar, r::Function = all) =
    JointCalendar([c1, c2], r)
join(c1::JointCalendar, c2::SingleCalendar) =
    JointCalendar([c1.calendars, c2], c1.is_good_on_rule)
join(c1::SingleCalendar, c2::JointCalendar) =
    join(c2, c1)
join(c1::JointCalendar, c2::JointCalendar) =
    JointCalendar([c1.calendars, c2.calendars], c1.is_good_on_rule)
join{T<:SingleCalendar}(c::Vector{T}, r::Function = all) =
    JointCalendar([ ci for ci in c ], r)
join{T<:JointCalendar}(jcs::Vector{T}) =
    JointCalendar([ jc.calendars for jc in jcs ], jcs[1].is_good_on_rule)
Base.convert(::Type{JointCalendar}, c::SingleCalendar) = JointCalendar(c)

#####
# isgood methods
#####

isweekend(dt::TimeType) = dayofweek(dt) in [Sat, Sun]
isgood(dt::TimeType, ::NoCalendar) = !isweekend(dt)
isgood(dt::TimeType) = isgood(dt, NoCalendar())
function isgood(dt::TimeType, c::JointCalendar)
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
