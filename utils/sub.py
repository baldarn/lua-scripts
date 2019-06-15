import paho.mqtt.publish as publish
import time
import random
import sys

#publish.single("/radiolog/show", 8142241818244281, hostname="mqtt.asterix.cloud")
#publish.single("/radiolog/show/Node_5580c2", 8142241818244281, hostname="mqtt.asterix.cloud")
#time.sleep(1)
publish.single("/radiolog/cmd/Node_54d1da", "demo", hostname="mqtt.asterix.cloud")
sys.exit(0)

for i in range(10):
    s = ''
    for x in range(6):
        s += chr(random.randint(ord('a'), ord('z')))

    delay = random.randrange(1,5)
    publish.single("/radiolog/Node-%s/status" % s, delay, hostname="mqtt.asterix.cloud")
    print "Wait.. %s" % delay
    time.sleep(delay)

for i in range(3):
    s = ''
    delay = random.randrange(1,5)
    publish.single("/radiolog/Node-123456/status", delay, hostname="mqtt.asterix.cloud")
    print "Wait.. %s" % delay
    time.sleep(delay)
