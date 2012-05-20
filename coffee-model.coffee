
###
 coffee-model
 by Nick perkins
 2012-05-17
###

expect = require ('expect.js')

exports.Model = class Model

  constructor:(@data={})->

    ###
    for each event name, keep a list of listeners:
    ###
    @listeners = {}
    @_unnamed_validations = []

    ###
    check the "fields" defined by the sub-class
    ###
    for name,field of @fields
      expect(name).to.be.a('string')
      expect(field).to.be.an('object')

      for atr,val of field
        expect(['type','validate']).to.contain(atr)

      expect(field).to.have.property('type')
      expect(field.type).to.be.a('string')
      expect(field.type).to.match(/string|number|boolean/)

      if field.validate
        expect(field.validate).to.be.a('function')



  on:(name,cb)->
    list = @listeners[name]
    if not list
      list = @listeners[name] = []
    list.push cb

  onError:(cb)->
    @on 'error', (args...)->
      expect(args[0]).to.be.a('string') # the rest can be anything
      cb.apply @, args

  emit:(name,args...)->
    ###
    trigger an event
    ###
    list = @listeners[name]
    if list
      for cb in list
        cb.apply(this,args)

  _error_log:[]
  error:(args...)->
    @_error_log.push args
    @emit 'error', args...

  set:(key,val)->
    ###
    request to set a value ( subject to validation, etc,etc )
    returns "this" if it works, or "false" if not
    ###
    field = @fields[key]
    if not field
      @error "invalid key: #{key}"
      false
    else
      switch field.type
        when 'boolean'
          b = not not val
          @_set key, b
        when 'string'
          s = String(val)
          @_set key, s
        when 'number'
          switch typeof val
            when 'number'
              @_set key, val
            when 'string'
              n = parseInt(val,10)
              if isNaN n
                @error "not a number:set '#{key}', #{val}"
              else
                @_set key, n
            else
              false # value was NOT set
        else
          false

  _set:(key,val)->
    # actually set the value ( internal )
    old_val = @data[key]
    @data[key] = val
    @emit 'change',key,val,old_val
    @ # return "this" for chaining

  get:(key)->
    t = typeof key
    if t != 'string'
      throw new Error "model.get(key):key is not a string, it's a "+t
    else
      # check key in fields:
      for name of @fields
        if name == key
          v = @data[key]
          return v

      # still here? then your key is not valid
      throw new Error "invalid key: #{key}"



  is:(key,testval)->
    val = @get key
    return ( val == testval )

  _valid:false

  validate:()->
    @_valid = false
    result = { errors:[], PASS:true }

    # run any field validations:
    for name,field of @fields
      if field.validate
        val = @get name
        err = (msg)->
          result.PASS = false
          result.errors.push
            fieldname : name
            value     : val
            message   : msg
        try
          field.validate.call @, val, (msg)->
            err(msg)
        catch error
            err("error executing field validation for #{name}: " + String(error))


    # run any model validations:
    for vname, vfn of @validations
      vfn.call @, (msg)->
        result.PASS = false
        result.errors.push
          name:vname
          message:msg


    # run "unnamed validations"
    for fn in @_unnamed_validations
      fn.call @, (msg)->
        result.PASS = false
        result.errors.push
          message:msg

    # did we pass all tests?
    if result.PASS and result.errors.length==0
      @_valid = true


    @emit 'validation', result
    # "validation" listeners get the result before
    #                 it's returned to the caller?
    # doesn't seem fair! maybe we should "setTimeout"?

    return result

  isValid:()->
    return @_valid



  addValidation:(fn)->
    @_unnamed_validations.push fn




