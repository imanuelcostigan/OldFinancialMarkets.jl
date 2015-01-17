####
# Types
####

abstract Currency

# Sources:
# 1. ISDA 2006 definitions
# 2. Opengamma: Interest rate instruments and market conventions guide

immutable AUD <: Currency
    calendar::JointCalendar
    AUD(calendar::AUSYCalendar) = new(calendar)
end
AUD() = AUD(AUSYCalendar())

immutable EUR <: Currency
    calendar::JointCalendar
    EUR(calendar::EUTACalendar) = new(calendar)
end
EUR() = EUR(EUTACalendar())

immutable GBP <: Currency
    calendar::JointCalendar
    GBP(calendar::GBLOCalendar) = new(calendar)
end
GBP() = GBP(GBLOCalendar())

immutable JPY <: Currency
    calendar::JointCalendar
    JPY(calendar::JPTOCalendar) = new(calendar)
end
JPY() = JPY(JPTOCalendar())

immutable NZD <: Currency
    calendar::JointCalendar
    function NZD(calendar::JointCalendar)
        cals = [NZAUCalendar(), NZWECalendar()]
        valid_cals = all([ c in cals for c in calendar.calendars ])
        msg = "Must use NZAU & NZWE calendars."
        valid_cals ? new(calendar) : throw(ArgumentError(msg))
    end
end
NZD() = NZD(join(NZAUCalendar(), NZWECalendar()))

immutable USD <: Currency
    calendar::JointCalendar
    USD(calendar::USNYCalendar) = new(calendar)
end
USD() = USD(USNYCalendar())

# Source:
# 2. Opengamma: Interest rate instruments and market conventions guide

const CCY_STRENGTH = [EUR => 1,  GBP => 2, AUD => 3, NZD => 4, USD => 5,
    JPY => 6]

Base.isless(x::Currency, y::Currency) = (CCY_STRENGTH[typeof(x)] >
    CCY_STRENGTH[typeof(y)])

=={T<:Currency}(ccy1::T, ccy2::T) = true
==(ccy1::Currency, ccy2::Currency) = false
Base.string(ccy::Currency) = string(typeof(ccy))
Base.show(io::IO, ccy::Currency) = print(io, string(ccy))
@vectorize_1arg Currency Base.string
