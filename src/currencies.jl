####
# Types
####

abstract Currency

# Sources:
# 1. ISDA 2006 definitions
# 2. Opengamma: Interest rate instruments and market conventions guide

immutable AUD <: Currency
    calendar::JointFCalendar
    AUD(calendar::AUSYFCalendar) = new(calendar)
end
AUD() = AUD(AUSYFCalendar())

immutable EUR <: Currency
    calendar::JointFCalendar
    EUR(calendar::EUTAFCalendar) = new(calendar)
end
EUR() = EUR(EUTAFCalendar())

immutable GBP <: Currency
    calendar::JointFCalendar
    GBP(calendar::GBLOFCalendar) = new(calendar)
end
GBP() = GBP(GBLOFCalendar())

immutable JPY <: Currency
    calendar::JointFCalendar
    JPY(calendar::JPTOFCalendar) = new(calendar)
end
JPY() = JPY(JPTOFCalendar())

immutable NZD <: Currency
    calendar::JointFCalendar
    NZD(calendar::Union(NZAUFCalendar, NZWEFCalendar)) = new(calendar)
end
NZD() = NZD(+(NZAUFCalendar(), NZWEFCalendar()))

immutable USD <: Currency
    calendar::JointFCalendar
    USD(calendar::USNYFCalendar) = new(calendar)
end
USD() = USD(USNYFCalendar())

# Source:
# 2. Opengamma: Interest rate instruments and market conventions guide

const CCY_STRENGTH = [EUR => 1,  GBP => 2, AUD => 3, NZD => 4, USD => 5,
    JPY => 6]

Base.isless(x::Currency, y::Currency) = (CCY_STRENGTH[typeof(x)] >
    CCY_STRENGTH[typeof(y)])

=={T<:Currency}(ccy1::T, ccy2::T) = true
==(ccy1::Currency, ccy2::Currency) = false
Base.string(ccy::Currency) = string(typeof(ccy))
Base.show(io::IO, ccy::Currency) = print(string(ccy))
@vectorize_1arg Currency Base.string
