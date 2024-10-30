"""
    _get_zdt_formated(zdt::ZonedDateTime)::AbstractString

Get the zdt formated string in the format "yyyymmddTHH:MMzzzz".
"""
function _get_zdt_formated(zdt::ZonedDateTime)::AbstractString
    return string(
        Dates.format(zdt, "yyyymmddTHH:MM"),
        replace(Dates.format(zdt, "zzzz"), ":" => ""),
    )
end
