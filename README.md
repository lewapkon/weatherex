# Weatherex

Command line app that:

1. In one thread downloads temperature from anywhere using any HTTP REST API and
   refreshes every 3 seconds.
2. In another thread downloads temperature from anywhere using the WebSocket
   protocol.
3. Both threads save their readings to a shared state.
4. When the shared state changes the thread with lower temperature reading
   should output to console where the temperature is lower and where is it
   higher.

## Usage

```bash
mix escript.build
./weatherex [city]
```

`city` is a parameter that sets city for the HTTP API. It defaults to Warsaw

Because of the specifics of the api services that are used, temperature readings
usually don't change while the app is working. The WebSocket API is supposed to
send data every minute, however sometimes it just stops after the first message
sent.
