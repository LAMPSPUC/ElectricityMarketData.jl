"""
    _mkdir(path::AbstractString)::AbstractString

Create directory if it does not exist.
"""
function _mkdir(path::AbstractString)::AbstractString
    if !isdir(path)
        return mkdir(path)
    end
    return path
end
