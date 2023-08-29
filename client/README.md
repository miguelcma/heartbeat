# Usage

##### Configure client crontab (router)
```
$ crontab -e

* * * * * HEARTBEAT_SERVER_URL=http://localhost:4567 /home/pi/heartbeat/client/ping.sh
```
