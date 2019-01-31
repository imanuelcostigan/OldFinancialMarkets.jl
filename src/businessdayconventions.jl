#####
# Types
#####


abstract type BusinessDayConvention end

# Sources:
# 1. ISDA 2006 definitions
# 2. Opengamma: Interest rate instruments and market conventions guide

struct Unadjusted <: BusinessDayConvention end
struct Preceding <: BusinessDayConvention end
struct ModifiedPreceding <: BusinessDayConvention end
struct Following <: BusinessDayConvention end
struct ModifiedFollowing <: BusinessDayConvention end
struct Succeeding <: BusinessDayConvention end

#####
# Methods
#####

adjust(dt::TimeType, bdc::Unadjusted, c::FinCalendar = NoFCalendar()) = dt
function adjust(dt::TimeType, bdc::Preceding, c::FinCalendar = NoFCalendar())
    while !isgood(dt, c)
        dt -= Day(1)
    end
    return dt
end
function adjust(dt::TimeType, bdc::Following, c::FinCalendar = NoFCalendar())
    while !isgood(dt, c)
        dt += Day(1)
    end
    return dt
end
function adjust(dt::TimeType, bdc::ModifiedPreceding,
    c::FinCalendar = NoFCalendar())
    pre_dt = adjust(dt, Preceding(), c)
    month(dt) != month(pre_dt) ? adjust(dt, Following(), c) : pre_dt
end
function adjust(dt::TimeType, bdc::ModifiedFollowing,
    c::FinCalendar = NoFCalendar())
    follow_dt = adjust(dt, Following(), c)
    month(dt) != month(follow_dt) ? adjust(dt, Preceding(), c) : follow_dt
end
function adjust(dt::TimeType, bdc::Succeeding, c::FinCalendar = NoFCalendar())
    follow_dt = adjust(dt, Following(), c)
    is_barrier_crossed = (month(follow_dt) != month(dt) ||
        day(dt) ≤ 15 && day(follow_dt) > 15)
    is_barrier_crossed ? adjust(dt, Preceding(), c) : follow_dt
end
