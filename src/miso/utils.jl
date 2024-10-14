"""
    _async_get_raw_data(market::MisoMarket, url_folder::AbstractString, file_base::AbstractString, extension::AbstractString, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString=tempdir())

Download the 'file_base' raw data for the given `market` in the given 'url_folder' and `start_date` to `end_date` and save it in `folder`.
"""
function _async_get_raw_data(
    market::MisoMarket,
    url_folder::AbstractString,
    file_base::AbstractString,
    extension::AbstractString,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
)::Vector{Task}
    directory = mkpath(joinpath(folder, market.directory))
    start = astimezone(start_date, market.timezone)
    stop = astimezone(end_date, market.timezone) + Day(1)
    tasks = Vector{Task}()
    base_url = joinpath(market.url, url_folder)
    current_year_month = "000000"
    file_zip = ""
    urls = Vector{String}()
    paths = Vector{String}()
    date = start
    # Loop over each day
    while date < stop
        # Gets the part offile name for the current day
        yyyymmdd = Dates.format(date, "yyyymmdd")
        # Build the file name
        file = yyyymmdd * file_base * "." * extension
        # We will call the async download for each set of days in a same month, because MISO archive the data for each month
        if current_year_month != yyyymmdd[1:6]
            if length(urls) > 0
                # Build the file name zip
                file_zip = current_year_month * file_base * "_" * extension * ".zip"
                # Call the async download for a month batch
                append!(
                    tasks,
                    _async_download(
                        urls,
                        paths,
                        base_url * "/" * file_zip,
                        joinpath(directory, file_zip),
                    ),
                )
                # Reset
                urls = Vector{String}()
                paths = Vector{String}()
            end
            # Updates the current month
            current_year_month = yyyymmdd[1:6]
        end
        # Add the url and path
        push!(urls, base_url * "/" * file)
        push!(paths, joinpath(directory, file))
        # Updates the date
        date = date + Day(1)
    end
    # Calls the async download for the last month
    append!(
        tasks,
        _async_download(
            urls,
            paths,
            base_url * "/" * file_zip,
            joinpath(directory, file_zip),
        ),
    )
    return tasks
end

"""
    _get_raw_data(market::MisoMarket, url_folder::AbstractString, file_base::AbstractString, extension::AbstractString, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString=tempdir(), parser::Function=(args...) -> nothing)

Download raw data for Real-Time (RT) Locational Marginal Price (LMP) for the given `market` and `start_date` to `end_date` and save it in `folder`.
"""
function _get_raw_data(
    market::MisoMarket,
    url_folder::AbstractString,
    file_base::AbstractString,
    extension::AbstractString,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
    parser::Function = (args...) -> nothing,
)::Nothing
    tasks = _async_get_raw_data(
        market,
        url_folder,
        file_base,
        extension,
        start_date,
        end_date;
        folder = folder,
    )
    for task in tasks
        wait(task)
    end
    return nothing
end

"""
    _get_data(market::MisoMarket, url_folder::AbstractString, file_base::AbstractString, extension::AbstractString, type::AbstractString, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString=tempdir(), parser::Function=(args...) -> nothing) :: Tables.table

Return a table with Real-Time (RT) Locational Marginal Price (LMP) data for the given `market` and `start_date` to `end_date`.
Parse the data using `parser` if provided.
If the data is not available, download it and save it in `folder`. 
"""
function _get_data(
    market::MisoMarket,
    url_folder::AbstractString,
    file_base::AbstractString,
    extension::AbstractString,
    type::AbstractString,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
    parser::Function = (args...) -> nothing,
)
    tasks = _async_get_raw_data(
        market,
        url_folder,
        file_base,
        extension,
        start_date,
        end_date;
        folder = folder,
    )
    df = DataFrame(
        Time = ZonedDateTime[],
        Market = String[],
        Node = String[],
        Type = String[],
        LMP = Float64[],
        Energy = Float64[],
        Congestion = Float64[],
        Loss = Float64[],
    )
    for task in tasks
        file_name = fetch(task)
        csv = CSV.read(file_name, DataFrame)
        # Gets the date from A2 (line 1 is empty)
        date = ZonedDateTime(DateTime(csv[1, 1], "m/d/y"), market.timezone)
        # Gets the matrix starting in A6 (line 1 and 3 are empty)
        values = csv[4:end, :]
        # Each node appears in 3 rows (lmp, congestion, loss)
        number_of_nodes = Int(nrow(values) / 3)
        # Loop over each hour
        for i = 1:24
            # Update the date
            date = date + Hour(1)
            # Loop over each node
            for j = 1:number_of_nodes
                # Check that the nodes have the same order
                @assert values[j, 1] ==
                        values[j+number_of_nodes, 1] ==
                        values[j+2*number_of_nodes, 1]
                # Gets the lmp, congestion and loss
                lmp = parse(Float64, values[j, 3+i])
                congestion = parse(Float64, values[j+number_of_nodes, 3+i])
                loss = parse(Float64, values[j+2*number_of_nodes, 3+i])
                # Gets the energy
                energy = lmp - congestion - loss
                # Push the data
                push!(
                    df,
                    [date, type, values[j, 1], values[j, 2], lmp, energy, congestion, loss],
                )
            end
        end
    end
    return df
end
