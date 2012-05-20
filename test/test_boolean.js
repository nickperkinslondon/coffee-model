(function() {
  var cm, expect,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  cm = require('../coffee-model');

  expect = require('expect.js');

  describe('Boolean', function() {
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
        alive: {
          type: 'boolean'
        }
      };

      return Pet;

    })(cm.Model);
    return describe('field type', function() {
      var display, obj, truthiness, _results;
      it('is valid', function() {
        var p;
        return p = new Pet();
      });
      it('works', function() {
        var p;
        p = new Pet();
        p.set('alive', true);
        expect(p.get('alive')).to.be(true);
        p.set('alive', false);
        return expect(p.get('alive')).to.be(false);
      });
      truthiness = {
        "{}": {
          value: {},
          truthiness: true
        },
        "[]": {
          value: [],
          truthiness: true
        },
        "0": {
          value: 0,
          truthiness: false
        },
        "1": {
          value: 1,
          truthiness: true
        },
        "-1": {
          value: -1,
          truthiness: true
        },
        "null": {
          value: null,
          truthiness: false
        },
        "undefined": {
          value: void 0,
          truthiness: false
        },
        "[1,2,3]": {
          value: [1, 2, 3],
          truthiness: true
        },
        "{name:'Nick'}": {
          value: {
            name: 'Nick'
          },
          truthiness: true
        }
      };
      _results = [];
      for (display in truthiness) {
        obj = truthiness[display];
        _results.push((function(display, obj) {
          return it(("silently converts truthiness of " + display + " to ") + obj.truthiness, function() {
            var p;
            p = new Pet();
            p.set('alive', obj.value);
            return expect(p.get('alive')).to.be(obj.truthiness);
          });
        })(display, obj));
      }
      return _results;
    });
  });

}).call(this);
