cm = require '../coffee-model'
expect = require 'expect.js'

describe 'Model.Set',->

  class Pet extends cm.Model
    fields:
      species:
        type:'string'
      name:
        type:'string'
      year_of_birth:
        type:'number'


  describe 'valid field name',->
    it 'works', ->
      pet = new Pet()
      pet.set 'name','Snowball'

    it 'returns "this" for chaining',->
      pet = new Pet()
      r = pet.set 'name','Snowball'
      expect(r).to.be(pet)

      pet.set('name','Biggles').set('species','cat')
      expect(pet.get 'name').to.be('Biggles')
      expect(pet.get 'species').to.be('cat')


  describe 'invalid field name', ->
    it 'triggers an error event',->
      pet = new Pet()
      got_error = false
      pet.onError (msg)->
        got_error = true
        expect(msg).to.be('invalid key: fdsfds')
      pet.set 'fdsfds','something'
      expect(got_error).to.be(true)

  describe 'invalid number',->
    it 'triggers an error',->
      pet = new Pet()
      err = null
      pet.onError (msg)->
        err = msg
      pet.set 'year_of_birth','not-a-number'
      expect(err).to.be.ok()


  describe 'string for a number',->
    it 'converts the string to a number',->
      pet = new Pet()

      pet.set 'year_of_birth','2008'
      expect(pet.get 'year_of_birth').to.be.a('number')
      expect(pet.get 'year_of_birth').to.be(2008)

      pet.set 'year_of_birth',' (2008.00) '
      expect(pet.get 'year_of_birth').to.be.a('number')
      expect(pet.get 'year_of_birth').to.be(2008)

    it 'throws if the string cannot be converted to a number',->
      pet = new Pet()
      f = ->
        p.set 'year_of_birth','lastyear' # expects number
      expect(f).to.throwError()


