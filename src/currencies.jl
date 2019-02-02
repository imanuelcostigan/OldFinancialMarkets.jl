####
# Types
####

abstract type Currency end

# Sources:
# 1. ISDA 2006 definitions
# 2. Opengamma: Interest rate instruments and market conventions guide

struct AUD <: Currency
    calendar::JointFCalendar
    AUD(calendar::AUSYFCalendar) = new(calendar)
end
AUD() = AUD(AUSYFCalendar())

struct EUR <: Currency
    calendar::JointFCalendar
    EUR(calendar::EUTAFCalendar) = new(calendar)
end
EUR() = EUR(EUTAFCalendar())

struct GBP <: Currency
    calendar::JointFCalendar
    GBP(calendar::GBLOFCalendar) = new(calendar)
end
GBP() = GBP(GBLOFCalendar())

struct JPY <: Currency
    calendar::JointFCalendar
    JPY(calendar::JPTOFCalendar) = new(calendar)
end
JPY() = JPY(JPTOFCalendar())

struct NZD <: Currency
    calendar::JointFCalendar
    function NZD(calendar::JointFCalendar)
        cals = [NZAUFCalendar(), NZWEFCalendar()]
        valid_cals = all([ c in cals for c in calendar.calendars ])
        msg = "Must use NZAU & NZWE calendars."
        valid_cals ? new(calendar) : throw(ArgumentError(msg))
    end
end
NZD() = NZD(+(NZAUFCalendar(), NZWEFCalendar()))

struct USD <: Currency
    calendar::JointFCalendar
    USD(calendar::USNYFCalendar) = new(calendar)
end
USD() = USD(USNYFCalendar())

# Source:
# 2. Opengamma: Interest rate instruments and market conventions guide

const CCY_STRENGTH = Dict(EUR => 1,  GBP => 2, AUD => 3, NZD => 4, USD => 5,
    JPY => 6)

Base.isless(x::Currency, y::Currency) = (CCY_STRENGTH[typeof(x)] >
    CCY_STRENGTH[typeof(y)])

==(ccy1::T, ccy2::T) where {T<:Currency} = true
==(ccy1::Currency, ccy2::Currency) = false
Base.string(ccy::Currency) = string(typeof(ccy))
Base.show(io::IO, ccy::Currency) = print(io, string(ccy))
