(function() {
  var cm, expect,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  cm = require('../coffee-model');

  expect = require('expect.js');

  ({
    validation_event: {
      when_validation_is_called: {
        the_event_is_triggered: function() {
          var Pet;
          return Pet = (function(_super) {

            __extends(Pet, _super);

            function Pet() {
              Pet.__super__.constructor.apply(this, arguments);
            }

            Pet.prototype.fields = {
              species: {
                type: 'string'
              },
              name: {
                type: 'string',
                validate: 'fdsfds'
              }
            };

            return Pet;

          })(cm.Model);
        }
      }
    }
  });

}).call(this);
