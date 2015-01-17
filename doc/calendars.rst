Financial calendars
===============================================================================

Introduction
-------------------------------------------------------------------------------

In an earlier section, I explained why calculating the length of time between financial events was important to financial mathematics. In this section, I will describe how the dates of those financial events are a function of time periods interacting with financial calendars.

Motivation
-------------------------------------------------------------------------------

Most financial market contracts have a termination date at which all obligations amongst the financially interested parties are extinguished. These termination dates are typically defined as occuring a certain time period after the effective date of the contract.

For example, a deposit's termination date may occur three months after the deposit's effective date. At the deposit's effective date, the capital amount is transferred between the counterparties and at the termination date the capital amount is returned with interest. If the 3 month (3m) deposit's effective date were the 25th of September, then it's termination date would be the 25th of December. However, notice that the 25th of December is Christmas Day. Banks are typically closed for business in most financial centres on Christmas Day and as a consequence the termination date must be adjusted.

In general, financial events must occur on *good days* as defined by the applicable *financial calendar*. If the calculated date of a financial event is not a good day in the applicable financial centre, then it must be *adjusted* by a *business day convention*.


Financial calendars
-------------------------------------------------------------------------------

*Good days* are those for which banks are open and able to settle transactions in a given financial centre. Generally speaking, all days are good excepting weekends, generally observed public holidays (e.g. Christmas day) or those applying specifically to banks (e.g. a bank holiday). As a consequence, good days are tied to a financial centre's location (New York, London, Sydney etc) which defines a *financial calendar*.

FinancialMarkets.jl implements financial calendars as subtypes of the abstract ``SingleCalendar`` abstract type which is itself a subtype of the abstract ``Calendar`` type.

Additionally, the concrete ``JointCalendar`` subtype of ``Calendar`` represents a vector of ``SingleCalendar`` instances (the ``calendars`` field) and flags whether the calendars are joined by on the intersection of good or bad days (the ``onbad`` boolean typed field).

A number of commonly used locale-specific ``SingleCalendar`` subtypes are defined by FinancialMarkets.jl.

=====================   =====================  ==========  ======================
Name                    Locale                 Concrete    Supertype
=====================   =====================  ==========  ======================
``AUCalendar``         Australia              ``false``   ``SingleCalendar``
``AUSYCalendar``       Sydney/Australia       ``true``    ``AUCalendar``
``AUMECalendar``       Melbourne/Australia    ``true``    ``AUCalendar``
``EUCalendar``         Europe                 ``false``   ``SingleCalendar``
``EUTACalendar``       TARGET                 ``true``    ``EUCalendar``
``EULIBORCalendar``    EUR LIBOR              ``true``    ``EUCalendar``
``GBCalendar``         Great Britain          ``false``   ``SingleCalendar``
``GBLOCalendar``       London/GB              ``true``    ``GBCalendar``
``JPCalendar``         Japan                  ``false``   ``SingleCalendar``
``JPTOCalendar``       Tokyo/Japan            ``true``    ``JPCalendar``
``NZCalendar``         New Zealand            ``false``   ``SingleCalendar``
``NZAUCalendar``       Auckland/NZ            ``true``    ``NZCalendar``
``NZWECalendar``       Wellington/NZ          ``true``    ``NZCalendar``
``USCalendar``         United States          ``false``   ``SingleCalendar``
``USNYCalendar``       New York/US            ``true``    ``USCalendar``
``USLIBORCalendar``    US LIBOR               ``true``    ``USCalendar``
=====================   =====================  ==========  ======================

Good day methods have been implemented for these financial calendar types and for joint calendars::

    using Dates, FinancialMarkets
    # NSW Labour Day
    d1 = Date(2014,10,6)
    # No calendars => all weekdays are good; weekends bad
    isgood(d1)
    # Sydney calendar
    isgood(d1, AUSYCalendar())
    # Sydney, Melbourne calendar joined on bad days
    isgood(d1, +(AUSYCalendar(), AUMECalendar()))
    # Sydney, Melbourne calendar joined on good days
    isgood(d1, *(AUSYCalendar(), AUMECalendar()))


Business day conventions
-------------------------------------------------------------------------------

Where a date falls on a bad day (i.e. one that is not a good day), it is adjusted to a good day using a business day convention. These are defined in glorious legalise in the 2006 ISDA definitions and interpreted well into plain English elswhere [ogconventions]_ and won't be detailed again here.

FinancialMarkets.jl implements these business day conventions as immutable subtypes of the abstract ``BusinessDayConvention`` type. These conventions include: ``Unadjusted``, ``Preceding``, ``ModifiedPreceding``, ``Following``, ``ModifiedFollowing`` and ``Succeeding``.

Bad day can be adjusted using ``adjust`` methods using these business day conventions::

    # Christmas Day
    d2 = Date(2014,12,25)
    adjust(d2, Unadjusted(), AUSYCalendar())
    adjust(d2, Following(), AUSYCalendar())

Interface
-------------------------------------------------------------------------------

.. function:: NoCalendar() -> NoCalendar

    Constructs a ``NoCalendar`` type, a sub-type of ``SingleCalendar``.

.. function:: AUMECalendar() -> AUMECalendar

    Constructs a ``AUMECalendar`` type, a sub-type of ``AUCalendar``.

.. function:: AUSYCalendar() -> AUSYCalendar

    Constructs a ``AUSYCalendar`` type, a sub-type of ``AUCalendar`` which is a subtype of ``SingleCalendar``.

.. function:: AUSYCalendar() -> AUSYCalendar

    Constructs a ``AUSYCalendar`` type, a sub-type of ``AUCalendar`` which is a subtype of ``SingleCalendar``.

.. function:: EUTACalendar() -> EUTACalendar

    Constructs a ``EUTACalendar`` type, a sub-type of ``EUCalendar`` which is a subtype of ``SingleCalendar``.

.. function:: EULIBORCalendar() -> EULIBORCalendar

    Constructs a ``EULIBORCalendar`` type, a sub-type of ``EUCalendar`` which is a subtype of ``SingleCalendar``.

.. function:: GBLOCalendar() -> GBLOCalendar

    Constructs a ``GBLOCalendar`` type, a sub-type of ``GBCalendar`` which is a subtype of ``SingleCalendar``.

.. function:: JPTOCalendar() -> JPCalendar

    Constructs a ``JPTOCalendar`` type, a sub-type of ``JPCalendar`` which is a subtype of ``SingleCalendar``.

.. function:: NZAUCalendar() -> NZAUCalendar

    Constructs a ``NZAUCalendar`` type, a sub-type of ``NZCalendar`` which is a subtype of ``SingleCalendar``.

.. function:: NZWECalendar() -> NZWECalendar

    Constructs a ``NZWECalendar`` type, a sub-type of ``NZCalendar`` which is a subtype of ``SingleCalendar``.

.. function:: USNYCalendar() -> USNYCalendar

    Constructs a ``USNYCalendar`` type, a sub-type of ``USCalendar`` which is a subtype of ``SingleCalendar``.

.. function:: USLIBORCalendar() -> USLIBORCalendar

    Constructs a ``USLIBORCalendar`` type, a sub-type of ``USCalendar`` which is a subtype of ``SingleCalendar``.

.. function:: JointCalendar(calendars::Vector{SingleCalendar}, onbad::Bool) -> JointCalendar

    Construct a ``JointCalendar`` type. If ``onbad`` is ``true`` then the joint calendar's bad days are the union of the bad days of its constituent calendars. Otherwise, a calendar's bad days are the intersection of the bad days of its constituent calendars. ``JointCalendar`` is a subtype of ``Calendar``

.. function:: +(c1::SingleCalendar, c2::SingleCalendar) -> JointCalendar

    Equivalent to calling ``JointCalendar([c1, c2], true)``

.. function:: *(c1::SingleCalendar, c2::SingleCalendar) -> JointCalendar

    Equivalent to calling ``JointCalendar([c1, c2], false)``

.. function:: +(jc::JointCalendar, c::SingleCalendar) -> JointCalendar

    Equivalent to calling ``JointCalendar([jc.calendars, c],
    jc.onbad)``

.. function:: convert(::Type{JointCalendar}, c::SingleCalendar) -> JointCalendar

    Equivalent to ``JointCalendar(c)``

.. function:: isweekend(dt::TimeType) -> Boolean

    Returns ``true`` if ``dt`` is on a weekend and vice-versa.

.. function:: isgood(dt::TimeType, c::NoCalendar = NoCalendar()) -> Boolean
              isgood(dt::TimeType, c::AUMECalendar) -> Boolean
              isgood(dt::TimeType, c::AUSYCalendar) -> Boolean
              isgood(dt::TimeType, c::EUTACalendar) -> Boolean
              isgood(dt::TimeType, c::EULIBORCalendar) -> Boolean
              isgood(dt::TimeType, c::GBCalendar) -> Boolean
              isgood(dt::TimeType, c::JPCalendar) -> Boolean
              isgood(dt::TimeType, c::NZAUCalendar) -> Boolean
              isgood(dt::TimeType, c::NZWECalendar) -> Boolean
              isgood(dt::TimeType, c::USCalendar) -> Boolean
              isgood(dt::TimeType, c::USLIBORCalendar) -> Boolean

    Returns ``true`` if ``dt`` is good day in ``c``. This is ``true`` only if ``dt`` does not fall on a weekend (where ``c`` is ``NoCalendar``) or a weekend or public holiday.

.. function:: isgood(dt::TimeType, c::JointCalendar) -> Boolean

    Returns ``true`` if ``dt`` is good in ``c`` where ``c.onbad`` determines how to check across each of the calendars in the joint calendar. If ``c.onbad`` is ``true`` then ``dt`` must be good in each of the financial calendars making up ``c`` and vice-versa.
