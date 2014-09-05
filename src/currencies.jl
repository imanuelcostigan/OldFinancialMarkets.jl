####
# Types
####

abstract Currency

# Sources:
# 1. ISDA 2006 definitions
# 2. Opengamma: Interest rate instruments and market conventions guide

immutable AUD <: Currency
    calendar::JointFCalendar
    function AUD(calendar)
        valid_cals = calendar == AUSYFCalendar()
        valid_cals ? new(calendar) : error("Must use AUSY calendar.")
    end
end
AUD() = AUD(AUSYFCalendar())

immutable EUR <: Currency
    calendar::JointFCalendar
    function EUR(calendar)
        valid_cals = calendar == EUTAFCalendar()
        valid_cals ? new(calendar) : error("Must use EUTA calendar.")
    end
end
EUR() = EUR(EUTAFCalendar())

immutable GBP <: Currency
    calendar::JointFCalendar
    function GBP(calendar)
        valid_cals = calendar == GBLOFCalendar()
        valid_cals ? new(calendar) : error("Must use GBLO calendar.")
    end
end
GBP() = GBP(GBLOFCalendar())

immutable JPY <: Currency
    calendar::JointFCalendar
    function JPY(calendar)
        valid_cals = calendar == JPTOFCalendar()
        valid_cals ? new(calendar) : error("Must use JPTO calendar.")
    end
end
JPY() = JPY(JPTOFCalendar())

immutable NZD <: Currency
    calendar::JointFCalendar
    function NZD(calendar)
        cals = [NZAUFCalendar(), NZWEFCalendar()]
        valid_cals = all([ c in cals for c in calendar.calendars ])
        valid_cals ? new(calendar) : error("Must use NZAU & NZWE calendars.")
    end
end
NZD() = NZD(+(NZAUFCalendar(), NZWEFCalendar()))

immutable USD <: Currency
    calendar::JointFCalendar
    function USD(calendar)
        valid_cals = calendar == USNYFCalendar()
        valid_cals ? new(calendar) : error("Must use USNY calendar.")
    end
end
USD() = USD(USNYFCalendar())

# Source:
# 2. Opengamma: Interest rate instruments and market conventions guide

const CCY_STRENGTH = [EUR => 1,  GBP => 2, AUD => 3, NZD => 4, USD => 5,
    JPY => 6]

Base.isless(x::Currency, y::Currency) = (CCY_STRENGTH[typeof(x)] >
    CCY_STRENGTH[typeof(y)])
