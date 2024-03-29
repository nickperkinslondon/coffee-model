// Generated by CoffeeScript 1.4.0
(function() {
  var cm, expect,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  cm = require('../coffee-model');

  expect = require('expect.js');

  describe("Validation", function() {
    describe("Field Validation", function() {
      return it("should work", function() {
        var Pet, p, r;
        Pet = (function(_super) {

          __extends(Pet, _super);

          function Pet() {
            return Pet.__super__.constructor.apply(this, arguments);
          }

          Pet.prototype.fields = {
            name: {
              type: 'string'
            },
            species: {
              type: 'string',
              validate: function(val, err) {
                if (val !== 'dog' && val !== 'cat') {
                  return err('not a real pet');
                }
              }
            }
          };

          return Pet;

        })(cm.Model);
        p = new Pet();
        p.set('name', 'Hilda');
        p.set('species', 'hippo');
        r = p.validate();
        expect(r.PASS).to.be(false);
        expect(r.errors).to.have.length(1);
        expect(p.isValid()).to.be(false);
        p.set('species', 'cat');
        r = p.validate();
        expect(r.PASS).to.be(true);
        expect(r.errors).to.have.length(0);
        return expect(p.isValid()).to.be(true);
      });
    });
    describe('Model Validations', function() {
      return it("should work", function() {
        var Pet, pet, r;
        Pet = (function(_super) {

          __extends(Pet, _super);

          function Pet() {
            return Pet.__super__.constructor.apply(this, arguments);
          }

          Pet.prototype.fields = {
            name: {
              type: 'string'
            },
            species: {
              type: 'string'
            }
          };

          Pet.prototype.validations = {
            reasonable_name: function(err) {
              var name;
              name = this.get('name');
              if (!this.is('species', 'cat')) {
                if (name.indexOf('Mr.') === 0) {
                  return err("Only cat names can start with 'Mr.'");
                }
              }
            },
            name_not_too_long: function(err) {
              var name;
              name = this.get('name');
              if (name.length > 17) {
                return err("name '" + name + "' must be 12 chars or less");
              }
            }
          };

          return Pet;

        })(cm.Model);
        pet = new Pet();
        pet.set('species', 'dog');
        pet.set('name', 'Mr.Bigglesworth');
        r = pet.validate();
        expect(r.PASS).to.be(false);
        expect(r.errors).to.have.length(1);
        expect(pet.isValid()).to.be(false);
        pet.set('species', 'cat');
        r = pet.validate();
        expect(r.PASS).to.be(true);
        expect(r.errors).to.have.length(0);
        expect(pet.isValid()).to.be(true);
        pet.set('name', 'Mr.Bigglesworthington-Jones');
        r = pet.validate();
        expect(r.PASS).to.be(false);
        expect(r.errors).to.have.length(1);
        return expect(pet.isValid()).to.be(false);
      });
    });
    return describe("an Exception in a validation function", function() {
      return it("should be caught and should become a validation error", function() {
        var Pet, p, r;
        Pet = (function(_super) {

          __extends(Pet, _super);

          function Pet() {
            return Pet.__super__.constructor.apply(this, arguments);
          }

          Pet.prototype.fields = {
            species: {
              type: 'string'
            },
            name: {
              type: 'string',
              validate: function(val, err) {
                return fdsjkjfkdsjklfdsjkfdls;
              }
            }
          };

          return Pet;

        })(cm.Model);
        p = new Pet();
        p.set('species', 'dog');
        p.set('name', 'Rover');
        r = p.validate();
        expect(p.isValid()).to.be(false);
        expect(r.PASS).to.be(false);
        return expect(r.errors).to.have.length(1);
      });
    });
  });

}).call(this);
