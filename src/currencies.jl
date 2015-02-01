####
# Types
####

abstract Currency

# Sources:
# 1. ISDA 2006 definitions
# 2. Opengamma: Interest rate instruments and market conventions guide

immutable AUD <: Currency
    calendar::JointCalendar
    AUD(calendar::AUSYCalendar = AUSYCalendar()) = new(calendar)
end

immutable EUR <: Currency
    calendar::JointCalendar
    EUR(calendar::EUTACalendar = EUTACalendar()) = new(calendar)
end

immutable GBP <: Currency
    calendar::JointCalendar
    GBP(calendar::GBLOCalendar = GBLOCalendar()) = new(calendar)
end

immutable JPY <: Currency
    calendar::JointCalendar
    JPY(calendar::JPTOCalendar = JPTOCalendar()) = new(calendar)
end

immutable NZD <: Currency
    calendar::JointCalendar
    function NZD(calendar::JointCalendar = join(NZAUCalendar(), NZWECalendar()))
        cals = [NZAUCalendar(), NZWECalendar()]
        valid_cals = all([ c in cals for c in calendar.calendars ])
        msg = "Must use NZAU & NZWE calendars."
        valid_cals ? new(calendar) : throw(ArgumentError(msg))
    end
end

immutable USD <: Currency
    calendar::JointCalendar
    USD(calendar::USNYCalendar = USNYCalendar()) = new(calendar)
end

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
