(function() {
  var cm, expect,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  cm = require('../coffee-model');

  expect = require('expect.js');

  describe("Set/Get", function() {
    return describe("converts string to number", function() {
      return it("works", function() {
        var Pet, p;
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
        p = new Pet();
        p.set('name', 'Snowball');
        p.set('species', 'dog');
        p.set('year_of_birth', 2008);
        expect(p.get('name')).to.be('Snowball');
        expect(p.get('species')).to.be('dog');
        expect(p.get('year_of_birth')).to.be.a('number');
        p.set('year_of_birth', '2009');
        expect(p.get('year_of_birth')).to.be.a('number');
        return expect(p.get('year_of_birth')).to.be(2009);
      });
    });
  });

}).call(this);