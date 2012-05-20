cm = require '../coffee-model'
expect = require 'expect.js'


describe "Validation",->


  describe "Field Validation", ->
    it "should work", ->

      class Pet extends cm.Model
        fields:
          name:
            type:'string'
          species:
            type:'string'
            validate:(val,err)->
              if val not in ['dog','cat']
                err 'not a real pet'


      p = new Pet()
      p.set 'name', 'Hilda'
      p.set 'species','hippo'

      r = p.validate()
      expect(r.PASS).to.be(false)
      expect(r.errors).to.have.length(1)
      expect(p.isValid()).to.be(false)


      # oops, i meant cat:
      p.set 'species','cat'
      r = p.validate()
      expect(r.PASS).to.be(true)
      expect(r.errors).to.have.length(0)
      expect(p.isValid()).to.be(true)



  describe 'Model Validations', ->
    it "should work",->


      class Pet extends cm.Model
        fields:
          name:
            type:'string'
          species:
            type:'string'

        validations:
          reasonable_name:(err)->
            name = @get 'name'
            if not @is 'species','cat'
              if name.indexOf('Mr.')==0
                err "Only cat names can start with 'Mr.'"
          name_not_too_long:(err)->
            name = @get 'name'
            if name.length > 17
              err "name '#{name}' must be 12 chars or less"


      pet = new Pet()
      pet.set 'species','dog'


      # not a dog's name
      pet.set 'name', 'Mr.Bigglesworth'
      r = pet.validate()
      expect(r.PASS).to.be(false)
      expect(r.errors).to.have.length(1)
      expect(pet.isValid()).to.be(false)


      # oops, i meant cat:
      pet.set 'species','cat'
      r = pet.validate()
      expect(r.PASS).to.be(true)
      expect(r.errors).to.have.length(0)
      expect(pet.isValid()).to.be(true)


      # name too long
      pet.set 'name','Mr.Bigglesworthington-Jones'
      r = pet.validate()
      expect(r.PASS).to.be(false)
      expect(r.errors).to.have.length(1)
      expect(pet.isValid()).to.be(false)



  describe "an Exception in a validation function", ->
    it "should be caught and should become a validation error",->

      class Pet extends cm.Model
        fields:
          species:
            type:'string'
          name:
            type:'string'
            validate:(val,err)->
              fdsjkjfkdsjklfdsjkfdls # exception! not defined!
              # could be an accidental error,
              #  or user could purosely "throw" or "assert" or "expect"


      p = new Pet()
      p.set 'species','dog'
      p.set 'name','Rover'

      r = p.validate() # will divide by zero!

      expect(p.isValid()).to.be(false)
      expect(r.PASS).to.be(false)
      expect(r.errors).to.have.length(1)
