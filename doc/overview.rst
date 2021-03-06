Overview
===============================================================================

FinancialMarkets.jl will help you describe and model financial market objects in
Julia.

For example::

    # Load packages
    using Dates, FinancialMarkets
    # Create US Dollar object
    USD = USD()
    # Create 3m USD LIBOR
    depo = Deposit(USD, Month(3), 0.05)
    # Price depo at trade date
    price(depo)

Features
-------------------------------------------------------------------------------

Objects such as:

- Compounding constants, interest rates, discount factors
- Financial market calendars, day counters and roll conventions
- Currencies
- Stub types
- Schedules
- Cash flows
- Interest rate indices
- Instruments

Modelling such as:

- Year fraction calculations
- Conversion between interest rates and discount factors and between different interest rates
- Identifying good (and bad) days
- Adjusting and shifting dates
- Creating swap date schedules
- Pricing instruments

Installation
-------------------------------------------------------------------------------

Install FinancialMarkets.jl by running::

    Pkg.clone("https://github.com/imanuelcostigan/FinancialMarkets.jl")

Contribute
-------------------------------------------------------------------------------

- `Issue tracker`_
- `Source code`_

License
-------------------------------------------------------------------------------

The project is licensed under the GPL-2 license.



.. _Issue tracker: https://github.com/imanuelcostigan/FinancialMarkets.jl/issues
.. _Source code: https://github.com/imanuelcostigan/FinancialMarkets.jl


