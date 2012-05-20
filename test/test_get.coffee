
cm = require '../coffee-model'
expect = require 'expect.js'


describe "Model.Get",->

  class Pet extends cm.Model
    fields:
      species:
        type:'string'


  describe "a perfectly valid key", ->
    it "works",->
      p = new Pet()
      p.set 'species','dog'
      expect(p.get 'species').to.be('dog')


  describe "an invalid key",->
    it "should throw exception",->
      p = new Pet()
      f = ->
        p.get 'fdsa',true
      expect(f).to.throwError()


