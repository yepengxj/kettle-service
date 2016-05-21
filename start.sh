#!/bin/bash
mkdir -p /root/.kettle/
env > /root/.kettle/kettle.properties

./carte.sh 0.0.0.0 8181
