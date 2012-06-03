
cm = require '../coffee-model'
expect = require 'expect.js'


class Pet extends cm.Model
  fields:
    name:
      type:'string'


describe 'Model Private Functions',->
  describe 'cannot_be_called',->

    it 'emit',->
      p = new Pet()
      f = ->
        p.emit 'some-event'
      expect(f).to.throwError()


    it '_save',->
      p = new Pet()
      f = ->
        p._set 'name','Snowball'
      expect(f).to.throwError()


    it '_error_log',->
      p = new Pet()
      expect(p._error_log).to.be(undefined)

    it '_set',->
      p = new Pet()
      expect(p.private_set).to.be(undefined)

    it '_valid',->
      p = new Pet()
      expect(p.valid).to.be(undefined)
