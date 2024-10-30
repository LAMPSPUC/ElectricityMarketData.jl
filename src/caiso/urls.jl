"""
    _get_caiso_url(queryname::AbstractString, startdate::AbstractString, stopdate::AbstractString, market_run_id::AbstractString, version::AbstractString = "1", resultformat::AbstractString="6")::AbstractString

Returns the url for the Caiso API.
"""
function _get_caiso_url(
    queryname::AbstractString,
    startdate::AbstractString,
    stopdate::AbstractString,
    market_run_id::AbstractString,
    version::AbstractString = "1",
    resultformat::AbstractString = "6",
)::AbstractString
    return "http://oasis.caiso.com/oasisapi/SingleZip?resultformat=$resultformat&queryname=$queryname&version=$version&startdatetime=$startdate&enddatetime=$stopdate&market_run_id=$market_run_id"
end

"""
    _get_caiso_price_url(startdate::AbstractString, stopdate::AbstractString, market_run_id::AbstractString)::AbstractString

Returns the price url for the Caiso API.
"""
function _get_caiso_price_url(
    startdate::AbstractString,
    stopdate::AbstractString,
    market_run_id::AbstractString,
)::AbstractString
    return _get_caiso_url("PRC_INTVL_LMP", startdate, stopdate, market_run_id)
end
