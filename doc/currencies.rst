Currencies
===============================================================================

Introduction
-------------------------------------------------------------------------------

Currencies are another key building block to building a coherent financial mathematics library. As currencies are the basis for transactions, they bring together different conventions in a unique manner and are used in primarily to this end in ``FinMarkets.jl``.

Details
-------------------------------------------------------------------------------

The abstract ``Currency`` type is extended by the immutable concrete types ``AUD``, ``EUR``, ``GBP``, ``JPY``, ``NZD`` and ``USD``. The 2006 ISDA definitions map these currencies to financial centres for the purposes of determining whether banks and FX markets settle payments on a given date.

=========    ======================    ========================
Type         Currency                  Calendar
=========    ======================    ========================
``AUD``      Australian Dollar         Sydney
``EUR``      Euro                      TARGET
``GBP``      Sterling                  London
``JPY``      Yen                       Tokyo
``NZD``      New Zealand Dollar        Auckland, Wellington
``USD``      United States Dollar      New York
=========    ======================    ========================

It is impossible to create a currency with the incorrect calendar field type as the inner constructor enforces type invariance. For example::

    using FinMarkets
    # No calendar, uses default calendar
    AUD()
    # Use correct calendar
    AUD(AUSYFCalendar())
    # Use incorrect calendar
    AUD(AUMEFCalendar())

I have overloaded the equality operator (``==``) for currency objects and provided methods to represent a currency as a string and to print this pretty string to output. Additionally it is possible to determine the comparative "strength" of two or more currencies [ogconventions]_::

    EUR() > GBP() > AUD() > NZD() > USD() > JPY()

Interface
-------------------------------------------------------------------------------

.. function:: AUD(calendar::AUSYFCalendar) -> AUD
              EUR(calendar::EUTAFCalendar) -> EUR
              GBP(calendar::GBLOFCalendar) -> GBP
              JPY(calendar::JPTOFCalendar) -> JPY
              NZD(calendar::JointFCalendar) -> NZD
              USD(calendar::USNYFCalendar) -> USD
              AUD() -> AUD
              EUR() -> EUR
              GBP() -> GBP
              JPY() -> JPY
              NZD() -> NZD
              USD() -> USD

