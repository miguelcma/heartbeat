#!/bin/bash

function ping {
	curl -X POST "$HEARTBEAT_SERVER_URL/heartbeat?key=$API_KEY"
	echo "Heartbeat sent!"
	echo 'waiting 20 more seconds to send another heartbeat...'
	sleep 20
}

ping
ping
ping
