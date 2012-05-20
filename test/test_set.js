(function() {
  var cm, expect,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  cm = require('../coffee-model');

  expect = require('expect.js');

  describe('Model.Set', function() {
    var Pet;
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
          type: 'string'
        },
        year_of_birth: {
          type: 'number'
        }
      };

      return Pet;

    })(cm.Model);
    describe('valid field name', function() {
      it('works', function() {
        var pet;
        pet = new Pet();
        return pet.set('name', 'Snowball');
      });
      return it('returns "this" for chaining', function() {
        var pet, r;
        pet = new Pet();
        r = pet.set('name', 'Snowball');
        expect(r).to.be(pet);
        pet.set('name', 'Biggles').set('species', 'cat');
        expect(pet.get('name')).to.be('Biggles');
        return expect(pet.get('species')).to.be('cat');
      });
    });
    describe('invalid field name', function() {
      return it('triggers an error event', function() {
        var got_error, pet;
        pet = new Pet();
        got_error = false;
        pet.onError(function(msg) {
          got_error = true;
          return expect(msg).to.be('invalid key: fdsfds');
        });
        pet.set('fdsfds', 'something');
        return expect(got_error).to.be(true);
      });
    });
    describe('invalid number', function() {
      return it('triggers an error', function() {
        var err, pet;
        pet = new Pet();
        err = null;
        pet.onError(function(msg) {
          return err = msg;
        });
        pet.set('year_of_birth', 'not-a-number');
        return expect(err).to.be.ok();
      });
    });
    return describe('string for a number', function() {
      it('converts the string to a number', function() {
        var pet;
        pet = new Pet();
        pet.set('year_of_birth', '2008');
        expect(pet.get('year_of_birth')).to.be.a('number');
        expect(pet.get('year_of_birth')).to.be(2008);
        pet.set('year_of_birth', ' (2008.00) ');
        expect(pet.get('year_of_birth')).to.be.a('number');
        return expect(pet.get('year_of_birth')).to.be(2008);
      });
      return it('throws if the string cannot be converted to a number', function() {
        var f, pet;
        pet = new Pet();
        f = function() {
          return p.set('year_of_birth', 'lastyear');
        };
        return expect(f).to.throwError();
      });
    });
  });

}).call(this);
