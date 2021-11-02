#!/bin/bash
# check if on Cigna network, and set proxy accordingly
# NOTE: this may/can be a little different from the system setting
onCignaNetwork=`nslookup CIPAppProxy.sys.cigna.com | grep -v find | grep CIPAppProxy | wc -l | tr -d ' '`
if [ "$onCignaNetwork" -eq "0" ]
then
        unset http_proxy
        unset https_proxy
        unset ftp_proxy
        unset no_proxy
        unset JAVA_OPTS
else
        export http_proxy=http://CIPAppProxy.sys.cigna.com:9090
        export https_proxy=$http_proxy
        export ftp_proxy=$http_proxy
        export no_proxy=' *.local, 169.254/16, localhost, 127.0.0.1, mysite.cigna.com, home.cigna.com, *.corp.cigna.com, ycl.cigna.com, *.internal.cigna.com, *.sys.cinga.com, *.silver.com, *.healthcare.cigna.com, centeralhub.cigna.com, mail.cigna.com, *.cigna.com'        
        export JAVA_OPTS="-Dhttp.proxyHost=CIPAppProxy.sys.cigna.com -Dhttp.proxyPort=9090 -Dhttps.proxyHost=CIPAppProxy.sys.cigna.com -Dhttps.proxyPort=2011"
fi
