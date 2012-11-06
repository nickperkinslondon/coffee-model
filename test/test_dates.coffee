
cm = require '../coffee-model'
expect = require 'expect.js'
say = console.log

describe 'Date Field',->
  describe 'Set with Time', ->
    it 'removes the Time component, truncating the date',(done)->

      class Pet extends cm.Model
        fields:
          date_of_birth:
            type:'date'


      d1 = new Date() # will have time component

      p = new Pet()
      p.set 'date_of_birth', d1
      d2 = p.get 'date_of_birth'

      expect( d2.getHours()  ).to.be(0)
      expect( d2.getMinutes()).to.be(0)
      expect( d2.getSeconds()).to.be(0)
      expect( d2.getYear()   ).to.be(d1.getYear())
      expect( d2.getMonth()  ).to.be(d1.getMonth())
      expect( d2.getDate()   ).to.be(d1.getDate())
      done()


describe 'Coffee-Model',->
  describe 'exports',->
    it 'truncate_date',->
      expect(cm.truncate_date).to.be.a('function')












