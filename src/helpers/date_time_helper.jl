"""
    function _zoned_date_time_to_yyyymmdd(zdt::ZonedDateTime, zone::TimeZone)::Int

Convert `zdt` to yyyymmdd format using the timezone of `zone`.
"""
function _zoned_date_time_to_yyyymmdd(zdt::ZonedDateTime, zone::TimeZone)::Int
    return parse(Int, Dates.format(astimezone(zdt, zone), "yyyymmdd"))
end
