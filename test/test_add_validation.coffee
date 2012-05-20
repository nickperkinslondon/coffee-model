cm = require '../coffee-model'
expect = require 'expect.js'

describe 'Add Validation',->
  describe 'added validation',->
    it 'works',->

      class Pet extends cm.Model
        fields:
          species:
            type:'string'
          name:
            type:'string'

      p = new Pet()
      p.addValidation (err)->
        s = p.get 'species'
        if s isnt 'cat'
          err "Cats Only!"

      p.set 'species','dog'
      r = p.validate()
      expect(r.PASS).to.be(false)
