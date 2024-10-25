"""
    _download(url::AbstractString, filename::AbstractString)::AbstractString

Downloads the return of `url` if the file `filename` does not exist, and saves it in `filename`.
"""
function _download(
    url::AbstractString,
    filename::AbstractString,
    headers::Dict = Dict(),
)::AbstractString
    if !isfile(filename)
        response = HTTP.get(url; status_exception = false, headers = headers)
        if response.status != 200
            return ""
        end
        open(filename, "w") do file
            write(file, response.body)
        end
    end
    return filename
end

"""
    _async_download(url::AbstractString, filename::AbstractString, headers::Dict)::Task

Downloads the 'url' and saves it to 'filename' asynchronously. Return the tasks.
"""
function _async_download(
    url::AbstractString,
    filename::AbstractString,
    headers::Dict = Dict(),
)::Task
    return @async _download(url, filename, headers)
end

"""
    function _async_download(urls::Vector{T}, filenames::Vector{T}, url_zip::AbstractString, filename_zip::AbstractString, headers::Dict)::Vector{Task} where T <: AbstractString

Downloads the 'urls' and saves it to 'filenames' asynchronously. If the file is not available, uses the zipped version. Return the tasks.
"""
function _async_download(
    urls::Vector{T},
    filenames::Vector{T},
    url_zip::AbstractString,
    filename_zip::AbstractString;
    headers::Dict = Dict(),
)::Vector{Task} where {T<:AbstractString}
    tasks = Vector{Task}()
    task1 = _async_download(urls[1], filenames[1], headers)
    if fetch(task1) != ""
        # If the file is already downloaded, we can download everyone else
        push!(tasks, task1)
        for i = 2:length(urls)
            task = @async _download(urls[i], filenames[i], headers)
            push!(tasks, task)
        end
    else
        # If the file is not downloaded, it was archived, we will use the zipped version
        _ = _download(url_zip, filename_zip, headers)
        zip = ZipFile.Reader(filename_zip)
        for file in zip.files
            open(joinpath(dirname(filename_zip), file.name), "w") do temp
                write(temp, read(file))
            end
        end
        close(zip)
        for filename in filenames
            task = @async return filename
            push!(tasks, task)
        end
    end
    return tasks
end

"""
    read_url(url::AbstractString, access_key_dict::Dict)::DataFrame

Read the data from the url.

# Arguments
- url::AbstractString: The url to read the data from.
- access_key_dict::Dict: The access key dictionary.

# Returns
- DataFrame: The data read from the url.
"""
function read_url(url::AbstractString, access_key_dict::Dict)::DataFrame
    # get the data from the url
    response = HTTP.get(url, headers = access_key_dict)
    # read the data into a DataFrame
    CSV.read(IOBuffer(response.body), DataFrame)
end
