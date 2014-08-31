chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'darksky', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/darksky')(@robot)

  it 'registers a respond listener for "weather"', ->
    expect(@robot.respond).to.have.been.calledWith(/weather ?(.+)?/i)
