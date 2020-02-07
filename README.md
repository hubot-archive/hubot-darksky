# Hubot Dark Sky

A script to grab the forecast information from Dark Sky for Hubot

[![Build Status](https://travis-ci.org/hubot-scripts/hubot-darksky.png)](https://travis-ci.org/hubot-scripts/hubot-darksky)

## Installation

Run `npm install --save hubot-darksky`

Add **hubot-darksky** to your `external-scripts.json`:

```json
["hubot-darksky"]
```

## Configuration
- `HUBOT_DARK_SKY_API_KEY` an api key from [darksky.net](https://darksky.net/dev)
- `HUBOT_DARK_SKY_DEFAULT_LOCATION` if unset, `weather` commands without a location will be ignored
- `HUBOT_DARK_SKY_SEPARATOR` a configurable line separator for responses.  defaults to "\n"
- `HUBOT_MAPQUEST_KEY` an api key from [developer.mapquest.com](https://developer.mapquest.com)

## Sample Interaction
```
user> weather livermore ca
Hubot> ​Weather for Livermore, CA, US
Currently: Clear 9.6°C/49°F
Today: Clear throughout the day.
Coming week: No precipitation throughout the week.
```

## Sources
[darksky.coffee from hubot-scripts](https://github.com/github/hubot-scripts/blob/master/src/scripts/darksky.coffee) by [kyleslattery](https://github.com/kyleslattery)
[comment from hubot-darksky issues](https://github.com/hubot-scripts/hubot-darksky/issues/6#issuecomment-564621223) by [Nmasood](https://github.com/Nmasood)
