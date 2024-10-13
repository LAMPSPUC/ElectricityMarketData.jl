var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = ElectricityMarketData","category":"page"},{"location":"#ElectricityMarketData","page":"Home","title":"ElectricityMarketData","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for ElectricityMarketData.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [ElectricityMarketData]","category":"page"},{"location":"#ElectricityMarketData.ElectricityMarket","page":"Home","title":"ElectricityMarketData.ElectricityMarket","text":"ElectricityMarket\n\nAbstract type representing an electricity market.\n\n\n\n\n\n","category":"type"},{"location":"#TimeZones.ZonedDateTime-Tuple{Dates.DateTime, ElectricityMarket}","page":"Home","title":"TimeZones.ZonedDateTime","text":"ZonedDateTime(date::DateTime, timezone::TimeZone) :: ZonedDateTime\n\nReturn a ZonedDateTime object with the given date and timezone from the market.\n\n\n\n\n\n","category":"method"},{"location":"#ElectricityMarketData._async_download-Tuple{AbstractString, AbstractString}","page":"Home","title":"ElectricityMarketData._async_download","text":"_async_download(url::AbstractString, filename::AbstractString)::Task\n\nDownloads the 'url' and saves it to 'filename' asynchronously. Return the tasks.\n\n\n\n\n\n","category":"method"},{"location":"#ElectricityMarketData._async_download-Union{Tuple{T}, Tuple{Vector{T}, Vector{T}, AbstractString, AbstractString}} where T<:AbstractString","page":"Home","title":"ElectricityMarketData._async_download","text":"function _async_download(urls::Vector{T}, filenames::Vector{T}, url_zip::AbstractString, filename_zip::AbstractString)::Vector{Task} where T <: AbstractString\n\nDownloads the 'urls' and saves it to 'filenames' asynchronously. If the file is not available, uses the zipped version. Return the tasks.\n\n\n\n\n\n","category":"method"},{"location":"#ElectricityMarketData._async_get_raw_data-Tuple{ElectricityMarketData.MisoMarket, AbstractString, AbstractString, AbstractString, ZonedDateTime, ZonedDateTime}","page":"Home","title":"ElectricityMarketData._async_get_raw_data","text":"_async_get_raw_data(market::MisoMarket, url_folder::AbstractString, file_base::AbstractString, extension::AbstractString, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString=tempdir())\n\nDownload the 'filebase' raw data for the given market in the given 'urlfolder' and start_date to end_date and save it in folder.\n\n\n\n\n\n","category":"method"},{"location":"#ElectricityMarketData._download-Tuple{AbstractString, AbstractString}","page":"Home","title":"ElectricityMarketData._download","text":"_download(url::AbstractString, filename::AbstractString)::AbstractString\n\nDownloads the return of url if the file filename does not exist, and saves it in filename.\n\n\n\n\n\n","category":"method"},{"location":"#ElectricityMarketData.available_time_series-Tuple{ElectricityMarketData.MisoMarket}","page":"Home","title":"ElectricityMarketData.available_time_series","text":"available_time_series(::MisoMarket) :: Vector{NamedTuple}\n\nReturn Vector of NamedTuple of available time series for the given market.\n\nEx:\n\n[\n    (name=\"RT-load\", unit=\"MW\", resolution=Hour(1), first_date=DateTime(\"2021-01-01T00:00:00\"), method=get_real_time_load_data, description=\"Real-time load data\"),\n    (name=\"RT-LMP\", unit=\"MWh\", resolution=Hour(1), first_date=DateTime(\"2021-01-01T00:00:00\"), method=get_real_time_lmp, description=\"Real-time Locational Marginal Price data\"),\n]\n\n\n\n\n\n","category":"method"},{"location":"#ElectricityMarketData.available_time_series-Tuple{ElectricityMarket}","page":"Home","title":"ElectricityMarketData.available_time_series","text":"available_time_series(market::ElectricityMarket) :: Vector{NamedTuple}\n\nReturn Vector of NamedTuple of available time series for the given market.\n\nEx:\n\n[\n    (name=\"RT-load\", unit=\"MW\", resolution=Hour(1), first_date=DateTime(\"2021-01-01T00:00:00\"), method=get_real_time_load_data, description=\"Real-time load data\"),\n    (name=\"RT-LMP\", unit=\"MWh\", resolution=Hour(1), first_date=DateTime(\"2021-01-01T00:00:00\"), method=get_real_time_lmp, description=\"Real-time Locational Marginal Price data\"),\n]\n\n\n\n\n\n","category":"method"},{"location":"#ElectricityMarketData.get_real_time_lmp-Tuple{ElectricityMarket, ZonedDateTime, ZonedDateTime}","page":"Home","title":"ElectricityMarketData.get_real_time_lmp","text":"get_real_time_lmp(market::ElectricityMarket, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString=tempdir(), parser::Function=(args...) -> nothing) :: Tables.table\n\nReturn a table with Real-Time (RT) Locational Marginal Price (LMP) data for the given market and start_date to end_date. Parse the data using parser if provided. If the data is not available, download it and save it in folder. \n\n\n\n\n\n","category":"method"},{"location":"#ElectricityMarketData.get_real_time_lmp-Tuple{ElectricityMarketData.MisoMarket, ZonedDateTime, ZonedDateTime}","page":"Home","title":"ElectricityMarketData.get_real_time_lmp","text":"get_real_time_lmp(market::MisoMarket, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString=tempdir(), parser::Function=(args...) -> nothing) :: Tables.table\n\nReturn a table with Real-Time (RT) Locational Marginal Price (LMP) data for the given market and start_date to end_date. Parse the data using parser if provided. If the data is not available, download it and save it in folder. \n\n\n\n\n\n","category":"method"},{"location":"#ElectricityMarketData.get_real_time_lmp_raw_data-Tuple{ElectricityMarket, ZonedDateTime, ZonedDateTime}","page":"Home","title":"ElectricityMarketData.get_real_time_lmp_raw_data","text":"get_real_time_lmp_raw_data(market::ElectricityMarket, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString=tempdir(), parser::Function=(args...) -> nothing)\n\nDownload raw data for Real-Time (RT) Locational Marginal Price (LMP) for the given market and start_date to end_date and save it in folder. Parse the data using parser if provided.\n\n\n\n\n\n","category":"method"},{"location":"#ElectricityMarketData.get_real_time_lmp_raw_data-Tuple{ElectricityMarketData.MisoMarket, ZonedDateTime, ZonedDateTime}","page":"Home","title":"ElectricityMarketData.get_real_time_lmp_raw_data","text":"get_real_time_lmp_raw_data(market::MisoMarket, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString=tempdir(), parser::Function=(args...) -> nothing)\n\nDownload raw data for Real-Time (RT) Locational Marginal Price (LMP) for the given market and start_date to end_date and save it in folder. Parse the data using parser if provided.\n\n\n\n\n\n","category":"method"},{"location":"#ElectricityMarketData.get_timezone-Tuple{ElectricityMarketData.MisoMarket}","page":"Home","title":"ElectricityMarketData.get_timezone","text":"get_timezone(market::MisoMarket) :: TimeZone\n\nReturn the timezone of the given market.\n\n\n\n\n\n","category":"method"},{"location":"#ElectricityMarketData.get_timezone-Tuple{ElectricityMarket}","page":"Home","title":"ElectricityMarketData.get_timezone","text":"get_timezone(market::ElectricityMarket) :: TimeZone\n\nReturn the timezone of the given market.\n\n\n\n\n\n","category":"method"},{"location":"#ElectricityMarketData.list_markets-Tuple{}","page":"Home","title":"ElectricityMarketData.list_markets","text":"list_markets() :: Vector{ElectricityMarket}\n\nReturn a vector of all available electricity markets.\n\n\n\n\n\n","category":"method"}]
}