"""
    _download(url::String, filename::String)::Nothing

Downloads the return of `url` if the file `filename` does not exist, and saves it in `filename`.
"""
function _download(url::String, filename::String)::Nothing
    if !isfile(file_path)
        response = HTTP.get(url)
        open(filename, "w") do file
            write(file, response.body)
        end
    end
end

"""
    _download_async(urls::Vector{String}, filenames::Vector{String})::Vector{Task}

Downloads the 'urls' return set and saves it to 'filenames' asynchronously. Return the tasks.
"""
function _download_async(urls::Vector{String}, filenames::Vector{String})::Vector{Task}
    @assert length(urls) == length(filenames)
    tasks = Vector{Task}()
    for (url, filename) in zip(urls, filenames)
        task = @async _download(url, filename)
        push!(tasks, task)
    end
    return tasks
end