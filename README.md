# Router Heartbeat

This is a simple security system for your home, to monitor when your router is offline, sending a notifications to you if the cable is cut.

Four levels of severity are supported:

1. A few 2 minutes without Internet connection: just a normal push notification is sent.
2. After 5 minutes without Internet an SMS is sent.
3. If 10 minutes pass offline, you'll receive a phone call.
4. Critical: after 30 minutes and the router is still down, then you'll get a critical push notification on your phone, which bypasses the iOS silent mode on all your devices (iPhone, Mac, iPad and Apple Watch).