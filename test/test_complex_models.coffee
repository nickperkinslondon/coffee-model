cm = require '../coffee-model'
expect = require 'expect.js'
say = console.log


show = (x)->
  say typeof x
  say x


describe 'Complex Models',->
  describe 'Single Value', ->
    it 'works',(done)->

      class Person extends cm.Model
        fields:
          name:
            type:'string'
          address:
            type:'string'

      class Pet extends cm.Model
        fields:
          name:
            type:'string'
          species:
            type:'string'
          owner:
            type:Person

      nick = new Person
        name:'Nick'
        address:'Canada'

      snowball = new Pet
        name:'Snowball'
        species:'dog'
        owner:nick

      snowball.set 'owner', nick

      got_owner = snowball.get 'owner'

      #show got_owner.toJSON()
      #show nick.toJSON()

      #expect(got_owner).to.be(nick)
      done()

    it 'errors if type is wrong',(done)->

      class Person extends cm.Model
        fields:
          name:
            type:'string'

      class Pet extends cm.Model
        fields:
          owner:
            type:Person
          name:
            type:'string'

      class Thing extends cm.Model
        fields:
          size:
            type:'number'

      nick = new Person
      snowball = new Pet
      chain = new Thing

      nick.set 'name', 'Nick'
      snowball.set 'owner', nick

      set_wrong_type = ->
        snowball.set 'owner', chain

      expect(set_wrong_type).to.throwError()
      done()



    it 'works with lists',(done)->

      class Pet extends cm.Model
        fields:
          name:
            type:'string'

      class Person extends cm.Model
        fields:
          name:
            type:'string'
          pets:
            type:[Pet]


      nick = new Person
        name:'Nick'

      snowball = new Pet
        name:'Snowball'

      littlenicky = new Pet
        name:'Little Nicky'

      nick.add 'pets', snowball
      nick.add 'pets', littlenicky

      pets = nick.get 'pets'
      expect(pets).to.be.an('array')

      expect(pets[0]).to.be.a(Pet)
      expect(pets[1]).to.be.a(Pet)
      done()

