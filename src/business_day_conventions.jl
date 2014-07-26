#####
# Types
#####

abstract BusinessDayConvention
immutable Unadjusted <: BusinessDayConvention end
immutable Preceding <: BusinessDayConvention end
immutable ModifiedPreceding <: BusinessDayConvention end
immutable Following <: BusinessDayConvention end
immutable ModifiedFollowing <: BusinessDayConvention end
immutable Succeeding <: BusinessDayConvention end

#####
# Methods
#####

adjust(dt::Date, bdc::Unadjusted) = dt
function adjust(dt::Date, bdc::Preceding, c = NoFCalendar())
    while !isgoodday(dt, c)
        dt -= Day(1)
    end
    return dt
end
function adjust(dt::Date, bdc::Following, c = NoFCalendar())
    while !isgoodday(dt, c)
        dt += Day(1)
    end
    return dt
end
function adjust(dt::Date, bdc::ModifiedPreceding, c = NoFCalendar())
    pre_dt = adjust(dt, Preceding(), c)
    month(dt) != month(pre_dt) ? adjust(dt, Following(), c) : pre_dt
end
function adjust(dt::Date, bdc::ModifiedFollowing, c = NoFCalendar())
    follow_dt = adjust(dt, Following(), c)
    month(dt) != month(follow_dt) ? adjust(dt, Preceding(), c) : follow_dt
end
function adjust(dt::Date, bdc::Succeeding, c = NoFCalendar())
    follow_dt = adjust(dt, Following(), c)
    is_barrier_crossed = (month(follow_dt) != month(dt) ||
        day(dt) ≤ 15 && day(follow_dt) > 15)
    is_barrier_crossed ? adjust(dt, Preceding(), c) : follow_dt
end
