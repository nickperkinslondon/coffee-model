cm = require '../coffee-model'
expect = require 'expect.js'



validation_event:
  when_validation_is_called:
    the_event_is_triggered:->


      class Pet extends cm.Model
        fields:
          species:
            type:'string'
          name:
            type:'string'
            validate:'fdsfds'




