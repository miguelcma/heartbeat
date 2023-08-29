# Usage

##### Start server

```
$ ruby server.rb -o 0.0.0.0
```

##### Create a Hearbeat

```
$ curl -X POST http://localhost:4567/heartbeat

{"status":"ok","timestamp":"2023-08-29T09:24:29Z"}
```

##### Read a Hearbeat

```
$ curl -X GET http://localhost:4567/heartbeat 

{"timestamp":"2023-08-29 09:24:29 UTC"}
```

##### Configure server crontab

```
$ crontab -e

* * * * * ENVS=... /usr/bin/ruby /home/miguelcma/heartbeat/server/check.rb
* * * * * ENVS=... /usr/bin/ruby /home/miguelcma/heartbeat/server/server.rb -o 0.0.0.0 &
```
