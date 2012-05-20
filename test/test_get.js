(function() {
  var cm, expect,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  cm = require('../coffee-model');

  expect = require('expect.js');

  describe("Model.Get", function() {
    var Pet;
    Pet = (function(_super) {

      __extends(Pet, _super);

      function Pet() {
        Pet.__super__.constructor.apply(this, arguments);
      }

      Pet.prototype.fields = {
        species: {
          type: 'string'
        }
      };

      return Pet;

    })(cm.Model);
    describe("a perfectly valid key", function() {
      return it("works", function() {
        var p;
        p = new Pet();
        p.set('species', 'dog');
        return expect(p.get('species')).to.be('dog');
      });
    });
    return describe("an invalid key", function() {
      return it("should throw exception", function() {
        var f, p;
        p = new Pet();
        f = function() {
          return p.get('fdsa', true);
        };
        return expect(f).to.throwError();
      });
    });
  });

}).call(this);
