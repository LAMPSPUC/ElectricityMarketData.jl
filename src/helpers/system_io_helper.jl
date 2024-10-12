"""
    _mkdir(path::AbstractString)::Nothing

Create directory if it does not exist.
"""
function _mkdir(path::AbstractString)::Nothing
    if !isdir(path)
        mkdir(path)
    end
    return nothing
end
