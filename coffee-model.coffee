
###
 coffee-model
 by Nick perkins
 2012-05-17
###

expect = require ('expect.js')
say = console.log



is_an_array = (x)->
  Array.isArray(x)

is_valid_date = (d)->
  #http://stackoverflow.com/questions/1353684/detecting-an-invalid-date-date-instance-in-javascript
  if Object.prototype.toString.call(d) != "[object Date]"
    return false
  if isNaN(d.getTime())
    return false
  try
    y = d.getFullyear()
    if y < 1900
      return false
    if y > 3000
      return false
  return true


truncate_date = (dt)->
  year = dt.getFullYear()
  month = dt.getMonth()
  day = dt.getDate()
  d = new Date( year, month, day)
  return d

exports.truncate_date = truncate_date


exports.Model = class Model

  # class-level stuff:
  check_fields = (fields)->
    for name,field of fields
      expect(name).to.be.a('string')
      expect(field).to.be.an('object')
      for atr,val of field
        expect(['type','validate']).to.contain(atr)
      expect(field).to.have.property('type')

      if typeof field.type is 'string'
        expect(field.type).to.match(/string|number|boolean|date/)
      else
        if field.type instanceof Model
          say('MODEL TYPE:OK')

      if field.validate
        expect(field.validate).to.be.a('function')

  # ===================================
  # PUBLIC:
  constructor:( initial_data = {} )->

    expect(@fields).to.be.an('object')
    check_fields(@fields)
    fields = @fields


    # private instance data and functions:
    data      = initial_data
    error_log = []
    listeners = {}
    #validations = {}
    unnamed_validations = []
    valid = false

    private_set = (key,val)->
      # actually set the value ( internal )
      old_val = data[key]
      data[key] = val
      emit 'change',key,val,old_val

    emit = @emit = (event_name,args...)->
      list = listeners[event_name]
      if list
        for cb in list
          cb.apply(this,args)

    get_field = (key)->
      f = fields[key]
      expect(f).to.be.an('object')
      expect(f).to.have.property('type')
      return f


    # PUBLIC Functions are added here
    # so that they are in the scope of the private data and fns
    # ( standard coffee-script classes don't provice any privacy )

    @on = (name,cb)->
      list = listeners[name]
      if not list
        list = listeners[name] = []
      list.push cb

    @onError=(cb)->
      @on 'error', (args...)->
        expect(args[0]).to.be.a('string') # the rest can be anything
        cb.apply @, args

    @error=(args...)->
      error_log.push args
      emit 'error', args...

    @set=(key,val)->
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
            private_set key, b

          when 'string'
            s = String(val)
            private_set key, s

          when 'number'
            switch typeof val
              when 'number'
                private_set key, val
              when 'string'
                n = parseInt(val,10)
                if isNaN n
                  @error "not a number:set ('#{key}','#{val}')"
                else
                  private_set key, n
              else
                false # value was NOT set

          when 'date'
            if val instanceof Date
              truncated_date = truncate_date( val )
              private_set key, truncated_date
            else
              t = typeof val
              switch t
                when 'string'
                  dt = new Date val
                  dt = truncate_date(dt)
                  if not is_valid_date(dt)
                    @error "set '#{key}' expects a Date or valid date string, but got '#{val}'"
                    return false
                  else
                    private_set key, dt
                when 'object'
                  # ok....is it an array like this? [2012,06,02]?
                  if val.length = 3
                    dt = new Date( val[0], val[1]-1, val[2])
                    if is_valid_date(dt)
                      private_set key, dt
                      return true
                  throw new Error "expected Date, got "+JSON.stringify(val)

                else
                  e = "set '#{key}' expects Date or similar, but got (#{t}) #{val}"
                  @error e
                  throw new Error e
                  return false
          else
            # must be a Model class:
            if new field.type not instanceof Model
              throw new Error 'unknown field type:'+field.type
            if val not instanceof field.type
              throw new Error 'expected '+field.type+', got '+(typeof val)
            private_set key,val

      return @



    @get = (key)->
      expect(key).to.be.a('string')
      #if not key in @fields then throw new Error 'invalid key: '+key
      field = get_field(key)
      v = data[key]
      if v == undefined
        if is_an_array field.type
          empty_list = []
          private_set key, empty_list
          return empty_list
      return v


    @is = (key,testval)->
      val = @get key
      return ( val == testval )


    @hasKey = (key)->
      return key in Object.keys(data)


    @has = (key)->
      if not @hasKey(key) then return false
      val = @get key
      if val is undefined then return false
      if val is null then return false
      return true



    @validate = ()->
      valid = false
      result = { errors:[], PASS:true }

      # run any field validations:
      for key,field of @fields
        if field.validate
          val = @get key
          err = (msg)->
            result.PASS = false
            result.errors.push
              fieldname : key
              value     : val
              message   : msg
          try
            field.validate.call @, val, (msg)->
              err(msg)
          catch error
              err("error executing field validation for #{key}: " + String(error))


      # run any model validations:
      for vname, vfn of @validations
        vfn.call @, (msg)->
          result.PASS = false
          result.errors.push
            name:vname
            message:msg


      # run "unnamed validations"
      for fn in unnamed_validations
        fn.call @, (msg)->
          result.PASS = false
          result.errors.push
            message:msg

      # did we pass all tests?
      if result.PASS and result.errors.length==0
        valid = true


      emit 'validation', result
      # "validation" listeners get the result before
      #                 it's returned to the caller?
      # doesn't seem fair! maybe we should "setTimeout"?

      return result

    @isValid=()->
      return valid


    @addValidation=(fn)->
      unnamed_validations.push fn

    @toJSON=->
      return JSON.stringify(data)


    @is_a_list = (fieldname)->
      field = @fields[fieldname]
      if is_an_array( field.type )
        return true
      return false

    @add = (fieldname,val)->


      field = @fields[fieldname]
      if not field
        throw new Error "unexpected fieldname: "+fieldname

      if is_an_array field.type

        if field.type.length != 1
          throw new Error 'field type is array but not length 1'

        t = field.type[0]

        if val instanceof t
          # type OK
          list = @get fieldname
          expect(list).to.be.an('array')
          list.push val

        else
          # type wrong
          throw new Error "wrong type for 'add': exptected #{t}, got #{typeof val}"



