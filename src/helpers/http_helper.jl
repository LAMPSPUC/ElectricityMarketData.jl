"""
    _download(url::AbstractString, filename::AbstractString)::AbstractString

Downloads the return of `url` if the file `filename` does not exist, and saves it in `filename`.
"""
function _download(url::AbstractString, filename::AbstractString)::AbstractString
    if !isfile(filename)
        response = HTTP.get(url)
        open(filename, "w") do file
            write(file, response.body)
        end
    end
    return filename
end

"""
    _download_async(urls::Vector{T}, filenames::Vector{T})::Vector{Task} where T<:AbstractString

Downloads the 'urls' return set and saves it to 'filenames' asynchronously. Return the tasks.
"""
function _download_async(urls::Vector{T}, filenames::Vector{T})::Vector{Task} where T <: AbstractString
    @assert length(urls) == length(filenames)
    tasks = Vector{Task}()
    for (url, filename) in zip(urls, filenames)
        task = @async _download(url, filename)
        push!(tasks, task)
    end
    return tasks
end
