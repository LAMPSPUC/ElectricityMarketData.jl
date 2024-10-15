# ElectricityMarketData

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://LAMPSPUC.github.io/ElectricityMarketData.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://LAMPSPUC.github.io/ElectricityMarketData.jl/dev/)
[![Build Status](https://github.com/LAMPSPUC/ElectricityMarketData.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/LAMPSPUC/ElectricityMarketData.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/LAMPSPUC/ElectricityMarketData.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/LAMPSPUC/ElectricityMarketData.jl)

|     Data      |  PJM  | MISO  | CAISO |
| ------------- | :---: | :---: | :---: |
| Real Time LMP |  ❌  |  ✔️   |   ❌   |
| Day-ahead LMP |  ✔️  |  ✔️   |   ❌   |
| Load          |  ❌  |   ❌   |   ❌   |

Example of getting data from PJM

```julia 
using ElectricityMarketData
using Dates
using TimeZones
import TimeZones: ZonedDateTime
market = ElectricityMarketData.PjmMarket()
df_raw = ElectricityMarketData.get_day_ahead_lmp(
    market,
    ZonedDateTime(DateTime(2024, 1, 1, 0, 0), tz"UTC-4"),
    ZonedDateTime(DateTime(2024, 1, 1, 1, 0), tz"UTC-4"),
)
parsed_data = ElectricityMarketData.parse_df_format(
            df,
            ElectricityMarketData.PJMDayAheadHourlyLMP_values_keys,
            ElectricityMarketData.PJMDayAheadHourlyLMP_meta_keys,
        )
```

Example of getting data from MISO

```julia 
using ElectricityMarketData
using Dates
market = ElectricityMarketData.MisoMarket()
df = ElectricityMarketData.get_real_time_lmp(
    market,
    DateTime(2024, 1, 1, 0, 0),
    DateTime(2024, 1, 1, 1, 0),
)
```