# Cakefile for
# coffee-model

fs          = require 'fs'
util        = require 'util'
child_process = require 'child_process'

say = console.log

check = (err,desc)->
  if err
    s = desc + ' : ' + JSON.stringify(err)
    throw new Error s

build = (callback)->
  child_process.exec 'coffee -c *.coffee', (err,stdout,stderr)->
    if err
      say err
      say stdout
      say stderr
      return false

    child_process.exec 'coffee -c test/*.coffee', (err,stdout,stderr)->
      if err
        say err
        say stdout
        say stderr
        return false

      say 'build done'
      if callback
        if typeof callback is 'function'
          callback()

task 'build', 'Compile CoffeeScript source files', build

test = (callback)->
  # run all tests, and only call the callback if they all pass
  #mocha_proc = child_process.spawn 'mocha' ,['--compilers','coffee:coffee-script','--colors','-R','list']
  #mocha_proc = child_process.spawn 'mocha' ,['--colors','-R','list','-u','exports']

  # this one uses the old (describe/describe/it) tests:
  mocha_proc = child_process.spawn 'mocha' ,['--colors','-R','list']


  mocha_proc.stdout.pipe(process.stdout, end:false )
  mocha_proc.stderr.pipe(process.stderr, end:false )
  mocha_proc.on 'exit',(code)->
    if code == 0
      say 'test done'
      if callback
        callback()
    else
      say 'TEST FAIL'

task 'test', 'Run all mocha tests', ->
  build ->
    test()



