# Sources:
# 1. Opengamma: Interest rate instruments and market conventions guide
# 2. Quantlib.org

function shift(dt::TimeType, p::Period, bdc = Unadjusted(), c = NoFCalendar(),
    eom = true)
    result = dt
    # Extract period details
    n = p.value
    pt = typeof(p)
    # Zero length period
    n == 0 && return adjust(result, bdc, c)
    # Non-zero length period
    if pt == Day
        while abs(n) > 0
            result += Day(sign(n))
            isgoodday(result, c) && (n -= sign(n))
        end
        return result
    elseif pt == Week
        result += p
        return adjust(result, bdc, c)
    else
        # End of month convention applies to Month & Year shifter
        result += p
        isldom = lastdayofmonth(dt) == dt
        if eom && isldom
            return adjust(lastdayofmonth(result), Preceding(), c)
        else
            return adjust(result, bdc, c)
        end
    end
end

function tonthdayofweek(dt::TimeType, n::Int, dow::Int)
    dt + Day(7 * (n - 1) + mod(dow - dayofweek(dt), 7))
end
