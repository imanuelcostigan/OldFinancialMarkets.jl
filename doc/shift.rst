Shifting dates
===============================================================================

Introduction
-------------------------------------------------------------------------------

Shifting dates is a very common procedure in financial mathematics. For example, the termination date of a contract is usually calculating by shifting the contract's effective date by a certain period (e.g. 3 months in the case of a deposit or 30 years in the case of a swap).

The ``Dates.jl`` includes a fairly comprehensive date/time arithmetic that encompasses shifting date/time instants by periods. The ``FinMarkets.jl`` package encapsulates and extends this to reflect some financial market conventions in the ``shift`` method.


Details
-------------------------------------------------------------------------------

The ``shift`` method encapsulates and extends ``Dates.jl`` date/time arithmetic in two ways:

1. It is *financial calendar aware*. This means, for example, that when a date is shifted by ``Day(n)``, it is shifted by ``n`` business days rather than calendar days. It also means that a bad resulting date is adjusted to a good date using a business day convention.
2. It is *end-of-month convention aware*. This only applies when a date is shifted by a monthly or yearly period. In these cases, when the unadjusted start date is the last calendar day of the month, the shifted end date is also the last calendar day of that month. Adjustments to good days occurs after this [wilmotteom]_.


Interface
-------------------------------------------------------------------------------

.. function:: shift(dt::TimeType, p::Period, bdc = Unadjusted(), c = NoFCalendar(),
    eom = true) -> TimeType

    Shifts ``dt`` by ``p`` observing the end-of-month conventions where appropriate when ``eom = true``. The resulting date is adjusted in accordance with ``bdc`` using the calendar ``c``.

.. [wilmotteom] `Wilmott Forums: End of month convention <http://www.wilmott.com/messageview.cfm?catid=3&threadid=95080>`_, Accessed 2 October 2014.
