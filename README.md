# Hubot Dark Sky

A script to grab the forecast information from Dark Sky for Hubot

[![Build Status](https://travis-ci.org/hubot-scripts/hubot-darksky.png)](https://travis-ci.org/hubot-scripts/hubot-darksky)

## Installation

Run `npm install --save hubot-darksky`

Add **hubot-darksky** to your `external-scripts.json`:

```json
["hubot-darksky"]
```

## Sample Interaction
```
Hubot> hubot: weather portland
Hubot> Weather for Portland, OR, USA
Currently: Mostly Cloudy 19.9°C/68°F
Today: Partly cloudy until this evening.
Coming week: Drizzle on Sunday, with temperatures bottoming out at 21°C/70°F on Tuesday.
```

## Sources
[darksky.coffee from hubot-scripts](https://github.com/github/hubot-scripts/blob/master/src/scripts/darksky.coffee) by [kyleslattery](https://github.com/kyleslattery)
