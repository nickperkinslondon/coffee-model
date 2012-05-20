cm = require '../coffee-model'
expect = require 'expect.js'

describe "Error Event",->
  describe "trigger",->
    it "works",->

      class Pet extends cm.Model
        fields:
          species:
            type:'string'
          name:
            type:'string'


      p = new Pet()
      p.set 'name','Snowball'
      p.set 'species','dog'

      p.error "chasing own tail"

  describe "listener",->
    it "works",->

      class Pet extends cm.Model
        fields:
          species:
            type:'string'
          name:
            type:'string'


      p = new Pet()
      p.set 'name','Snowball'
      p.set 'species','dog'

      message_recieved = null
      p.onError (msg,rest...)->
        message_recieved = msg

      p.error "chasing own tail"
      expect(message_recieved).to.be.equal("chasing own tail")
