
cm = require '../coffee-model'
expect = require 'expect.js'


describe "Set/Get",->
  describe "converts string to number",->
    it "works",->

      class Pet extends cm.Model
        fields:
          species:
            type:'string'
          name:
            type:'string'
          year_of_birth:
            type:'number'

      p = new Pet()
      p.set 'name','Snowball'
      p.set 'species','dog'
      p.set 'year_of_birth', 2008

      expect(p.get 'name').to.be('Snowball')
      expect(p.get 'species').to.be('dog')
      expect(p.get 'year_of_birth').to.be.a('number')

      p.set 'year_of_birth', '2009'
      # should convert from string to number
      expect(p.get 'year_of_birth').to.be.a('number')
      expect(p.get 'year_of_birth').to.be(2009)

