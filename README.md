# FinancialMarkets

FinancialMarkets.jl will help you describe and model financial market objects in
Julia.

For example:

```julia
# Load packages
using Dates, FinancialMarkets
# Create US Dollar object
USD = USD()
# Create 3m USD LIBOR
depo = Deposit(USD, Month(3), 0.05)
# Price depo at trade date
price(depo)
```
## Features

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

## Installation

Install FinancialMarkets.jl by running:

```julia
Pkg.clone("https://github.com/imanuelcostigan/FinancialMarkets.jl")
```

## Obligatory badges

[![Build Status](https://travis-ci.org/imanuelcostigan/FinancialMarkets.jl.png)](https://travis-ci.org/imanuelcostigan/FinancialMarkets.jl)
[![Coverage Status](https://coveralls.io/repos/imanuelcostigan/FinancialMarkets.jl/badge.svg?branch=release%2F0.2)](https://coveralls.io/r/imanuelcostigan/FinancialMarkets.jl?branch=release%2F0.2)
[![Documentation Status](https://readthedocs.org/projects/finmarketsjl/badge/?version=latest)](https://readthedocs.org/projects/finmarketsjl/?badge=latest)
