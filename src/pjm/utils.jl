"""
    get_acess_key_headers()::Dict

Get the access key headers from the PJM API.
"""
function get_acess_key_headers()::Dict
    # get public subscription key
    r = HTTP.request("GET", "http://dataminer2.pjm.com/config/settings.json")
    #convert response to dict
    response = JSON.Parser.parse(String(r.body))
    return Dict("Ocp-Apim-Subscription-Key" => response["subscriptionKey"])
end
