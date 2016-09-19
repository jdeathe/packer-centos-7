#!/bin/bash -e

/bin/echo '--> Purging documentaion.'
/bin/find /usr/share/{man,doc,info} -type f -delete
