#!/bin/bash
##############
# Opens the web page for temp admin access
# andrina.kelly@bellmedia.ca etc 4995
# June 27, 2013
##############

su - `ls -l /dev/console | awk '{print $3}'` -c "open http://webserver.yourcompany.com/admin.html"