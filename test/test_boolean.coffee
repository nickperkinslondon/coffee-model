cm = require '../coffee-model'
expect = require 'expect.js'

describe 'Boolean',->

  class Pet extends cm.Model
    fields:
      species:
        type:'string'
      name:
        type:'string'
      alive:
        type:'boolean'


  describe 'field type',->
    it 'is valid',->
      p = new Pet()

    it 'works',->
      p = new Pet()
      p.set 'alive', true
      expect(p.get 'alive').to.be(true)
      p.set 'alive', false
      expect(p.get 'alive').to.be(false)


    truthiness =
      "{}":
        value:{}
        truthiness:true # !
      "[]":
        value:[]
        truthiness:true # !
      "0":
        value:0
        truthiness:false
      "1":
        value:1
        truthiness:true
      "-1":
        value:-1
        truthiness:true
      "null":
        value:null
        truthiness:false
      "undefined":
        value:undefined
        truthiness:false
      "[1,2,3]":
        value:[1,2,3]
        truthiness:true
      "{name:'Nick'}":
        value:{name:'Nick'}
        truthiness:true


    for display,obj of truthiness
      do (display,obj)->
        it "silently converts truthiness of #{display} to "+obj.truthiness,->
          p = new Pet()
          p.set 'alive', obj.value
          expect(p.get 'alive').to.be(obj.truthiness)


