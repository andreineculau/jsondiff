jsonLint = require 'jsonlint'
jsonPointer = require 'jsonpointer'
JSON = require 'json3'
extend = require 'node.extend'

type = (obj) ->
  if obj is null or obj is undefined
    return String(obj)
  Object.prototype.toString.call(obj).slice(8, -1).toLowerCase() || 'object'


exports.parse = (instance1, instance2) ->
  throw 'Not yet implemented'


exports.apply = (instance, diff) ->
  silentGet = (pointer) ->
    jsonPointer.silentGet instance, pointer
  get = (pointer) ->
    jsonPointer.get instance, pointer
  set = (pointer, value) ->
    jsonPointer.set instance, pointer, value
  remove = (pointer) ->
    jsonPointer.remove instance, pointer


  if type(instance) is 'array'
    instance = extend true, [], instance
  else
    instance = extend true, {}, instance

  diff ?= []
  for instruction, value of diff
    mode = ''
    path = instruction
    switch path[0]
      when '~'
        mode = 'merge'
        path = path.substr 1
      when '-'
        mode = 'remove'
        path = path.substr 1
    [path, arrayInfo] = path.split '['
    if arrayInfo
      arrayAdd = false
      arrayInfo = arrayInfo.substr 0, arrayInfo.length-1
      if arrayInfo[0] is '+' # array insert
        arrayInfo = arrayInfo.substr 1
        arrayAdd = true

    try
      currentValue = get path
    catch e
      set path, value  if mode isnt 'remove'
      continue

    if arrayInfo
      if type(currentValue) isnt 'array'
        throw 'looks like different types ?! expecting array at ' + path
      currentArray = currentValue
      path = "#{path}/#{arrayInfo}"
      currentValue = currentValue[arrayInfo]

    switch mode
      when 'remove'
        remove path
      when 'merge'
        if arrayInfo and arrayAdd # array insert
          currentArray.splice arrayInfo, 0, value
          continue
        if type(currentValue) is 'object' and type(value) is 'object'
          extend currentValue, value # object merge, or array object-item merge
        else
          set path, value # replace instead of merge for primite data types or array items
      else
        set path, value

  instance
