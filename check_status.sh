#!/bin/bash
green="\033[32m"
red="\033[31m"
over="\033[0m"

udev="/etc/udev/rules.d/70-persistent-net.rules"
ifcfg="/etc/sysconfig/network-scripts/ifcfg-eth0"

UDev_Mac=`cat ${udev}  |tail -1|awk -F'"' '{print $8}'`
UDev_Name=`cat ${udev} |tail -1|awk -F'"' '{print $14}'`
Conf_Name=`grep eth0 ${ifcfg} |awk -F'=' '{print $2}'`
Conf_Onboot=`grep  "ONBOOT" ${ifcfg} |awk -F'=' '{print $2}'`
Local_IP=`ip a s eth0 | grep 'inet ' |awk '{ split($2,a,"/"); print a[1]}'`
Local_GW=`ip r|tail -1 |awk {'print $3'}`
Power=`head -1 /etc/sysconfig/network |awk -F'=' '{print $2}'`

network() {
    echo "====== Network ======"
    [ ${Power} == "yes" ]                        && echo -e "Power    ${green}OK${over}"    || echo -e "Power    ${red}No${over}"
    chkconfig |grep NetworkManager|grep on       && echo -e "NM OFF   ${red}No${over}"      || echo -e "NM OFF   ${green}OK${over}"
    ip a |grep -o ${UDev_Mac} &>/dev/null        && echo -e "Mac      ${green}OK${over}"    || echo -e "Mac      ${red}No${over}"
    [ ${UDev_Name} == ${Conf_Name} ] &>/dev/null && echo -e "Name     ${green}OK${over}"    || echo -e "Name     ${red}No${over}"
    [ ${Conf_Onboot} == "yes" ]                  && echo -e "Onboot   ${green}OK${over}"    || echo -e "Onboot   ${red}No${over}"
    grep "none" ${ifcfg} &>/dev/null             && echo -e "Protocal ${green}OK${over}"    || echo -e "Protocal ${red}No${over}"
    grep "${Local_IP}" ${ifcfg} &>/dev/null      && echo -e "IP Config   ${green}OK${over}" || echo -e "IP Config   ${red}No${over}" 
    grep "${Local_GW}" ${ifcfg} &>/dev/null      && echo -e "GW Config   ${green}OK${over}" || echo -e "GW Config   ${red}No${over}"
}
network
