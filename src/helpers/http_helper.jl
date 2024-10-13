"""
    _download(url::AbstractString, filename::AbstractString)::AbstractString

Downloads the return of `url` if the file `filename` does not exist, and saves it in `filename`.
"""
function _download(url::AbstractString, filename::AbstractString)::AbstractString
    if !isfile(filename)
        response = HTTP.get(url; status_exception = false)
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
    _async_download(url::AbstractString, filename::AbstractString)::Task

Downloads the 'url' and saves it to 'filename' asynchronously. Return the tasks.
"""
function _async_download(url::AbstractString, filename::AbstractString)::Task
    return @async _download(url, filename)
end

"""
    function _async_download(urls::Vector{T}, filenames::Vector{T}, url_zip::AbstractString, filename_zip::AbstractString)::Vector{Task} where T <: AbstractString

Downloads the 'urls' and saves it to 'filenames' asynchronously. If the file is not available, uses the zipped version. Return the tasks.
"""
function _async_download(
    urls::Vector{T},
    filenames::Vector{T},
    url_zip::AbstractString,
    filename_zip::AbstractString,
)::Vector{Task} where {T<:AbstractString}
    tasks = Vector{Task}()
    task1 = _async_download(urls[1], filenames[1])
    if fetch(task1) != ""
        # If the file is already downloaded, we can download everyone else
        push!(tasks, task1)
        for i = 2:length(urls)
            task = @async _download(urls[i], filenames[i])
            push!(tasks, task)
        end
    else
        # If the file is not downloaded, it was archived, we will use the zipped version
        _ = _download(url_zip, filename_zip)
        zip = ZipFile.Reader(filename_zip)
        for filename in filenames
            base_file = basename(filename)
            for file in zip.files
                if file.name == base_file
                    task = @async begin
                        open(filename, "w") do temp
                            write(temp, read(file))
                        end
                        return filename
                    end
                    push!(tasks, task)
                    break
                end
            end
        end
    end
    return tasks
end
