(function() {
  var cm, expect,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  cm = require('../coffee-model');

  expect = require('expect.js');

  describe('Model Field', function() {
    describe('with invalid type', function() {
      return it('errors on instantiation', function() {
        var Pet, f;
        Pet = (function(_super) {

          __extends(Pet, _super);

          function Pet() {
            Pet.__super__.constructor.apply(this, arguments);
          }

          Pet.prototype.fields = {
            species: {
              type: 'char'
            },
            name: {
              type: 'char'
            }
          };

          return Pet;

        })(cm.Model);
        f = function() {
          var p;
          return p = new Pet();
        };
        return expect(f).to.throwError();
      });
    });
    describe('with an unknown attribute', function() {
      return it('errors on instantiation', function() {
        var Pet, f;
        Pet = (function(_super) {

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
              fdsa: ''
            }
          };

          return Pet;

        })(cm.Model);
        f = function() {
          var p;
          return p = new Pet();
        };
        return expect(f).to.throwError();
      });
    });
    return describe('with "validate" that is not a function', function() {
      return it("errors on instantiation", function() {
        var Pet, f;
        Pet = (function(_super) {

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
              validate: 'not empty'
            }
          };

          return Pet;

        })(cm.Model);
        f = function() {
          var p;
          return p = new Pet();
        };
        return expect(f).to.throwError();
      });
    });
  });

}).call(this);
