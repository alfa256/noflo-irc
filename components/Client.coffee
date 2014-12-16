noflo = require 'noflo'
irc = require 'irc'

exports.getComponent = ->
  c = new noflo.Component

  c.icon = 'cog'
  c.client = null
  c.nick = null
  c.channel = null
  c.server = null
  c.queue = []

  c.description = 'Connects to a channel and listens to messages. Replies with text coming from IN.'

  c.inPorts.add 'channel',
    datatype: 'string'
    process: (event, payload) ->
      if event is 'data' then c.channel = payload
      c.should_connect()

  c.inPorts.add 'nick',
    datatype: 'string'
    process: (event, payload) ->
      if event is 'data' then c.nick = payload
      c.should_connect()

  c.inPorts.add 'server',
    datatype: 'string'
    process: (event, payload) ->
      if event is 'data' then c.server = payload
      c.should_connect()

  c.inPorts.add 'partmsg',
    datatype: 'string'
    process: (event, payload) -> if event is 'data' then c.part = payload

  c.should_connect = ->
    if c.channel? and c.nick? and c.server? and not c.client?
      c.client = new irc.Client( c.server, c.nick, { channels : [ c.channel ] } )
      c.client.addListener('message',(from, to, message) -> c.outPorts.out.send {from:from,to:to,message:message})
      c.client.addListener('pm', (from,message) -> c.outPorts.pm.send {from: from, message: message} )
      c.client.addListener('error', (message) -> c.outPorts.error.send message )
      c.client.addListener('join', (channel, who) -> c.outPorts.join.send {channel: channel, who: who} )
      c.client.addListener('part', (channel, who) -> c.outPorts.part.send {channel: channel, who: who} )
      c.client.addListener('kick', (channel, who, op, reason)-> c.outPorts.part.send {channel: channel, who: who, op: op,reason: reason})
      for m in c.queue
        c.client.say c.channel, m
      c.queue = []

  c.inPorts.add 'shutdown',
    datatype: 'bang'
    process: (event, payload) ->
      if c.client?
        c.client.part(c.part)
        c.client = null

  # Add input ports
  c.inPorts.add 'in',
    datatype: 'string'
    process: (event, payload) ->
      return unless event is 'data'
      if c.client?
        c.client.say c.channel, payload
      else
        c.queue.push payload

  # Add output ports
  c.outPorts.add 'out', datatype: 'object'
  c.outPorts.add 'pm', datatype: 'object'
  c.outPorts.add 'error', datatype: 'object'
  c.outPorts.add 'join', datatype: 'object'
  c.outPorts.add 'part', datatype: 'object'

  c
