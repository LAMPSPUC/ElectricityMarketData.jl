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
    _async_download(url::AbstractString, filename::AbstractString)::Task

Downloads the 'url' and saves it to 'filename' asynchronously. Return the tasks.
"""
function _async_download(url::AbstractString, filename::AbstractString)::Task
    return @async _download(url, filename)
end
