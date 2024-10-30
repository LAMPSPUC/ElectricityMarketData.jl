"""
    _unzip(filename::AbstractString, func::Function = x -> x)::Nothing

Unzip all files of 'filename' adding to 'text'.
"""
function _unzip(filename::AbstractString, func::Function = x -> x)::Nothing
    zip = ZipFile.Reader(filename)
    for file in zip.files
        dest_path = joinpath(dirname(filename), func(file.name))
        if !isfile(dest_path)
            write(dest_path, read(file))
        end
    end
    close(zip)
    return nothing
end
