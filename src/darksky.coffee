# Description
#   Grabs the current forecast from Dark Sky
#
# Dependencies
#   None
#
# Configuration
#   HUBOT_DARK_SKY_API_KEY
#   HUBOT_DARK_SKY_DEFAULT_LOCATION
#   HUBOT_DARK_SKY_GOOGLE_MAPS_GEOCODING_API_KEY
#   HUBOT_DARK_SKY_SEPARATOR (optional - defaults to "\n")
#
# Commands:
#   hubot weather - Get the weather for HUBOT_DARK_SKY_DEFAULT_LOCATION
#   hubot weather <location> - Get the weather for <location>
#
# Notes:
#   If HUBOT_DARK_SKY_DEFAULT_LOCATION is blank, weather commands without a location will be ignored
#
# Author:
#   kyleslattery
#   awaxa
module.exports = (robot) ->
  robot.respond /weather ?(.+)?/i, (msg) ->
    location = msg.match[1] || process.env.HUBOT_DARK_SKY_DEFAULT_LOCATION
    return if not location

    options =
      separator: process.env.HUBOT_DARK_SKY_SEPARATOR
    unless options.separator
      options.separator = "\n"

    google_api_key = process.env.HUBOT_DARK_SKY_GOOGLE_MAPS_GEOCODING_API_KEY || ''
    google_url = "https://maps.googleapis.com/maps/api/geocode/json"
    q = sensor: false, address: location, key: google_api_key
    msg.http(google_url)
      .query(q)
      .get() (err, res, body) ->
        result = JSON.parse(body)

        if result.results.length > 0
          lat = result.results[0].geometry.location.lat
          lng = result.results[0].geometry.location.lng
          lookupWeatherAndRespond msg, lat, lng, options.separator, result.results[0].formatted_address
        else
          msg.send "Couldn't find #{location}"
          console.log("hubot-darksky google geocoding result: " + JSON.stringify(result))

lookupWeatherAndRespond = (msg, lat, lng, separator, geocoded_address) ->
  url = "https://api.darksky.net/forecast/#{process.env.HUBOT_DARK_SKY_API_KEY}/#{lat},#{lng}/?units=si"
  msg.http(url)
    .get() (err, res, body) ->
      result = JSON.parse(body)

      if result.error
        msg.send "#{result.error}"
        return

      response = "Weather for #{geocoded_address} (Powered by DarkSky https://darksky.net/poweredby/)"
      response += "#{separator}Currently: #{result.currently.summary} #{result.currently.temperature}°C"
      response += "#{separator}Today: #{result.hourly.summary}"
      response += "#{separator}Coming week: #{result.daily.summary}"
      response = response.replace /-?(\d+\.?\d*)°C/g, (match) ->
          centigrade = match.replace /°C/, ''
          match = Math.round(centigrade*10)/10 + '°C/' + Math.round(centigrade * (9/5) + parseInt(32, 10)) + '°F'

      msg.send response
