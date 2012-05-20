cm = require '../coffee-model'
expect = require 'expect.js'

describe 'Model Field',->

  describe 'with invalid type', ->
    it 'errors on instantiation',->

      class Pet extends cm.Model
        fields:
          species:
            type:'char' # should be 'string'
          name:
            type:'char'

      f = ->
        p = new Pet()

      expect(f).to.throwError()



  describe 'with an unknown attribute',->
    it 'errors on instantiation',->

      class Pet extends cm.Model
        fields:
          species:
            type:'string'
          name:
            type:'string'
            fdsa:'' # unknown field attribute

      f = ->
        p = new Pet()

      expect(f).to.throwError()


  describe 'with "validate" that is not a function',->
    it "errors on instantiation",->

      class Pet extends cm.Model
        fields:
          species:
            type:'string'
          name:
            type:'string'
            validate:'not empty' # should be fn

      f = ->
        p = new Pet()

      expect(f).to.throwError()

