cm = require '../coffee-model'
expect = require 'expect.js'
say = console.log

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



  describe 'type "date"',->
    it "works",->

      class Pet extends cm.Model
        fields:
          name:
            type:'string'
          date_of_birth:
            type:'date'


      try_this=(x, expected_year, expected_month, expected_day)->

        #say "TEST DATE: input = (#{typeof x}) #{x}, expect = #{expected_year}/#{expected_month}/#{expected_day}"

        p = new Pet()
        p.set 'date_of_birth', x
        dt = p.get 'date_of_birth'

        if dt instanceof Date
          expect(dt.getFullYear()).to.be(expected_year)
          expect(dt.getMonth()+1).to.be(expected_month)
          expect(dt.getDate()).to.be(expected_day)

          expect(dt.getHours()).to.be(0)
          expect(dt.getMinutes()).to.be(0)
          expect(dt.getSeconds()).to.be(0)



        else
          throw new Error "expected get to return a Date after setting date with (#{typeof x}) #{x}"

      #try_this (new Date()), 2012, 06, 02
      #try_this 'fail me'
      try_this "28-JAN-1986", 1986,1,28
      try_this "2007/12/25", 2007,12,25
      try_this "Sat, 02 Jun 2012 15:39:27 GMT", 2012,6,2
      try_this "09-JUN-2012", 2012,6,9
      try_this "2012-JUN-07", 2012,6,7

      try_this [2001,9,11], 2001,9,11
































