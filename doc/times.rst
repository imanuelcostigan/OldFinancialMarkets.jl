Day count conventions
===============================================================================

Introduction
-------------------------------------------------------------------------------

The calculation of lengths of times between financial events is one of the most basic elements of financial mathematics. For example, the interest earned on money lent will depend on the length of time over which it has been lent out. A number of different day count conventions have been developed and documented (e.g. ISDA 2006 definitions). Generally speaking each convention consists of two components: first, a rule that defines how days are counted (hence **day count** convention); and second, a rule that defines the number of days in a year. For example, 30/360 day count conventions (yes, there are a few different types) count each month to consist of 30 days and each year to consist of 360 days.

Each of the day count conventions that are supported by FinMarkets.jl are documented extensively in the `OpenGamma Interest Rate Instruments and Market Conventions Guide (Edition 2.0)`_.

Supported conventions
-------------------------------------------------------------------------------

FinMarkets supports six of the main day count conventions: Actual/365 Fixed, Actual/360, Actual/Actual (ISDA), 30/360, 30E/360 and 30E+/360. These are defined as immutable types.

==========  ============
OG section  Type name
==========  ============
3.8         A365
3.7         A360
3.12        ActActISDA
3.3         Thirty360
3.4         ThirtyE360
3.6         ThirtyEP360
==========  ============


Time calculations
-------------------------------------------------------------------------------

The ``years`` method will let you calculate the times (in years) between two dates according to the day count convention you specify. For example::

    d1 = Date(2014, 1, 1)
    d2 = Date(2015, 1, 1)
    years(d1, d2, A365()) # 1.0
    years(d1, d2, A360()) # 365/360

.. _OpenGamma Interest Rate Instruments and Market Conventions Guide (Edition 2.0): http://developers.opengamma.com/quantitative-research/Interest-Rate-Instruments-and-Market-Conventions.pdf
