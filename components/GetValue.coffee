noflo = require 'noflo'

exports.getComponent = ->
  c = new noflo.Component
  c.icon = 'cog'
  
  c.key = 'message'
  c.missing = ''

  c.description = 'Gets the value of a property from incoming objects. Missing values will return MISSING value. Defaults key to message for convenient irc usage. Use NOTMISSING if you only want data from objects that have the KEY. HADKEY forwards objects that had the key.'

  c.inPorts.add 'key',
    datatype: 'string'
    process: (event, payload) ->
      return unless event is 'data'
      c.key = payload
 
  c.inPorts.add 'missing',
    datatype: 'string'
    process: (event, payload) ->
      return unless event is 'data'
      c.missing = payload

  c.inPorts.add 'in',
    datatype: 'object'
    process: (event, payload) ->
      return unless event is 'data'
      console.log payload[c.key]
      if typeof payload is 'object' and payload[c.key]?
        c.outPorts.out.send payload[c.key]
        c.outPorts.notmissing.send payload[c.key]
        c.outPorts.hadkey.send payload
      else
        c.outPorts.out.send c.missing
        c.outPorts.nothadkey.send payload
        
  c.outPorts.add 'out', datatype: 'object'
  c.outPorts.add 'notmissing', datatype: 'object'
  c.outPorts.add 'hadkey', datatype: 'object'
  c.outPorts.add 'nothadkey', datatype: 'object'

  c
