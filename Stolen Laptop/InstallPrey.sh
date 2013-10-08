#!/bin/bash

cd /tmp/ && sudo curl -O https://preyproject.com/releases/0.6.0/prey-0.6.0-mac-batch.mpkg.zip && sudo unzip -XKo /tmp/prey-0.6.0-mac-batch.mpkg.zip && sudo chmod 777 prey-0.6.0-mac-batch.mpkg && API_KEY="YOURKEYHERE!!!" sudo -E installer -pkg /tmp/prey-0.6.0-mac-batch.mpkg -target /