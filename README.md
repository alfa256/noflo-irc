# noflo-irc

IRC client components for noflo. Wraps the node-irc library by martynsmith.

By Alfredo Consebola.

## irc/Client :

Connects once server, nick and channel are received.

### Sends data as objects through :

*PM* : private messages the client gets.

    {from: 'user', to: 'channel', message: 'text'}

*KICK* : kick messages in the channel.

    {channel: 'channel', who: 'kicked user', op: 'op', reason: 'kick reason'}

*PART* : part messages in the channel.

    {channel: 'channel', who: 'parting user'}

*JOIN* : join messages in the channel.

    {channel: 'channel', who: 'joining user'}

*OUT* : normal messages in the channel.

    {from: 'user', to: 'channel', message: 'text'}

*ERROR* : sends client errors.

    {message: [ error lines ]} 

### Inports :

*SHUTDOWN* : shuts down the client.

*PARTMSG* : sets part message for the client.

*SERVER* : sets server.

*NICK* : sets nick.

*CHANNEL* : sets channel to join.

*IN* : write messages to the joined channel.


## irc/GetValue

For ease of use I bundle this useful component that extracts a property value from incoming objects.

### Outports :

*OUT* : property value of incoming object, sends the MISSING value if not present.

*NOTMISSING* : only sends values if present, does not send the MISSING value.

*HADKEY* : forwards objects that had the property.

*NOTHADKEY* : forwards objects that didn't have the property.

### Inports :

*KEY* : sets the key used to extract property values. Defaults to 'message' for convenience.

*IN* : incoming objects.

*MISSING* : value to be used for missing properties through the OUT port.

