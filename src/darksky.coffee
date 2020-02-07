# Description
#   Grabs the current forecast from Dark Sky
#
# Dependencies
#   None
#
# Configuration
#   HUBOT_DARK_SKY_API_KEY
#   HUBOT_DARK_SKY_DEFAULT_LOCATION (optional)
#   HUBOT_DARK_SKY_SEPARATOR (optional - defaults to "\n")
#   HUBOT_MAPQUEST_KEY
#   HUBOT_MAPQUEST_SECRET
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
#   enfuego311
module.exports = (robot) ->
  robot.hear /weather ?(.+)?/i, (msg) ->
    location = msg.match[1] || process.env.HUBOT_DARK_SKY_DEFAULT_LOCATION
    return if not location

    options =
      separator: process.env.HUBOT_DARK_SKY_SEPARATOR
    unless options.separator
      options.separator = "\n"

    mapquest_key = process.env.HUBOT_MAPQUEST_KEY
    mapquest_secret = process.env.HUBOT_MAPQUEST_SECRET
    mapquest_url = "http://open.mapquestapi.com/geocoding/v1/address"
    q = location: location, key: mapquest_key
    msg.http(mapquest_url)
      .query(q)
      .get() (err, res, body) ->
        result = JSON.parse(body)

        if result.results.length > 0
          lat = result.results[0].locations[0].latLng.lat
          lng = result.results[0].locations[0].latLng.lng
          if result.results[0].locations[0].adminArea5 == ""
            retcity = ""
          else
            retcity = "#{result.results[0].locations[0].adminArea5}, "
          if result.results[0].locations[0].adminArea3 == ""
            retstate = ""
          else
            retstate = "#{result.results[0].locations[0].adminArea3}, "
          if result.results[0].locations[0].postalCode == ""
            retzip = ""
          else
            retzip = "#{result.results[0].locations[0].postalCode}, "
          if result.results[0].locations[0].adminArea1 == ""
            retcountry = ""
          else
            retcountry = result.results[0].locations[0].adminArea1
          darkSkyMe msg, lat,lng , options.separator, (darkSkyText) ->
            response = "Weather for #{retcity}#{retstate}#{retzip}#{retcountry}#{options.separator}#{darkSkyText}"
              .replace /-?(\d+\.?\d*)°C/g, (match) ->
                centigrade = match.replace /°C/, ''
                match = Math.round(centigrade*10)/10 + '°C/' + Math.round(centigrade * (9/5) + parseInt(32, 10)) + '°F'
            response += "#{options.separator}"
            msg.send response
        else
          msg.send "Couldn't find #{location}"

darkSkyMe = (msg, lat, lng, separator, cb) ->
  url = "https://api.darksky.net/forecast/#{process.env.HUBOT_DARK_SKY_API_KEY}/#{lat},#{lng}/?units=si"
  msg.http(url)
    .get() (err, res, body) ->
      result = JSON.parse(body)

      if result.error
        cb "#{result.error}"
        return

      response = "Currently: #{result.currently.summary} #{result.currently.temperature}°C"
      response += "#{separator}Today: #{result.hourly.summary}"
      response += "#{separator}Coming week: #{result.daily.summary}"
      cb response
