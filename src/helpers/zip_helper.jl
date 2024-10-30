"""
    _unzip(filename::AbstractString, func::Function = x -> x)::AbstractString

Unzip all files of 'filename' adding to 'text'.
"""
function _unzip(filename::AbstractString, func::Function = x -> x)::Vector{AbstractString}
    zip = ZipFile.Reader(filename)
    dest_paths = Vector{AbstractString}()
    for file in zip.files
        dest_path = joinpath(dirname(filename), func(file.name))
        push!(dest_paths, dest_path)
        if !isfile(dest_path)
            write(dest_path, read(file))
        end
    end
    close(zip)
    return dest_paths
end
