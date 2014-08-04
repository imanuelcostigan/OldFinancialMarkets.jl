####
# Types
####

abstract Currency
immutable AUD <: Currency
    calendar::(FinCalendar, FinCalendar)
    function AUD(calendar)
        cals = (AUSYFCalendar(), AUMEFCalendar())
        valid_cals = all([ c in cals for c in calendar ])
        valid_cals ? new(calendar) : error("Must use AUSY & AUME calendars.")
    end
end
AUD() = AUD((AUSYFCalendar(), AUMEFCalendar()))

immutable EUR <: Currency
    calendar::FinCalendar
    function EUR(calendar)
        valid_cals = calendar == EUTAFCalendar()
        valid_cals ? new(calendar) : error("Must use EUTA calendar.")
    end
end
EUR() = EUR(EUTAFCalendar())

immutable GBP <: Currency
    calendar::FinCalendar
    function GBP(calendar)
        valid_cals = calendar == GBLOFCalendar()
        valid_cals ? new(calendar) : error("Must use GBLO calendar.")
    end
end
GBP() = GBP(GBLOFCalendar())

immutable NZD <: Currency
    calendar::(FinCalendar, FinCalendar)
    function NZD(calendar)
        cals = (NZAUFCalendar(), NZWEFCalendar())
        valid_cals = all([ c in cals for c in calendar ])
        valid_cals ? new(calendar) : error("Must use NZAU & NZWE calendars.")
    end
end
NZD() = NZD((NZAUFCalendar(), NZWEFCalendar()))

immutable USD <: Currency
    calendar::FinCalendar
    function USD(calendar)
        valid_cals = calendar == USNYFCalendar()
        valid_cals ? new(calendar) : error("Must use USNY calendar.")
    end
end
USD() = USD(USNYFCalendar())

