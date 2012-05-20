(function() {
  var cm, expect,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
    __slice = Array.prototype.slice;

  cm = require('../coffee-model');

  expect = require('expect.js');

  describe("Error Event", function() {
    describe("trigger", function() {
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
            }
          };

          return Pet;

        })(cm.Model);
        p = new Pet();
        p.set('name', 'Snowball');
        p.set('species', 'dog');
        return p.error("chasing own tail");
      });
    });
    return describe("listener", function() {
      return it("works", function() {
        var Pet, message_recieved, p;
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
            }
          };

          return Pet;

        })(cm.Model);
        p = new Pet();
        p.set('name', 'Snowball');
        p.set('species', 'dog');
        message_recieved = null;
        p.onError(function() {
          var msg, rest;
          msg = arguments[0], rest = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
          return message_recieved = msg;
        });
        p.error("chasing own tail");
        return expect(message_recieved).to.be.equal("chasing own tail");
      });
    });
  });

}).call(this);