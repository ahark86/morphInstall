#!/bin/bash

#Initialize variables
ltsVer="4.2.3"
betaVer="5.0.0"
centLtsUrl="https://downloads.morpheusdata.com/files/morpheus-appliance-${ltsVer}-1.el7.x86_64.rpm"
centLtsFile="morpheus-appliance-${ltsVer}-1.el7.x86_64.rpm"
centBetaUrl="https://downloads.morpheusdata.com/files/morpheus-appliance-${betaVer}-1.el7.x86_64.rpm"
centBetaFile="morpheus-appliance-${betaVer}0-1.el7.x86_64.rpm"
ubLtsUrl="https://downloads.morpheusdata.com/files/morpheus-appliance_${ltsVer}-1_amd64.deb"
ubLtsFile="morpheus-appliance_${ltsVer}-1_amd64.deb"
ubBetaUrl="https://downloads.morpheusdata.com/files/morpheus-appliance_${betaVer}-1_amd64.deb"
ubBetaFile="morpheus-appliance_${betaVer}-1_amd64.deb"
installing="Installing Morpheus..."
reconfiguring="Reconfiguring Morpheus..."
restarting="Restarting Morpheus UI... This may take a couple minutes..."

#Instructions
echo "Install Morpheus version ${ltsVer} (LTS) or ${betaVer} (Beta) for CentOS 7 or Ubuntu 16.04/18.04"
echo "Press any key to begin"

#Gets Linux distribution
until [[ $distro == "c" ]] || [[ $distro == "u" ]]
do
	echo "Indicate your Linux distribution, 'c' for CentOS 7 or 'u' for Ubuntu 16.04 or 18.04"
	read distro
done

#Gets desired Morpheus install package
echo "Choose the Morpheus version you wish to install:"

select ver in $ltsVer $betaVer
do
	case $ver in
	$ltsVer)
		if [[ $distro == "c" ]]
		then
			curl ${centLtsUrl} > ${centLtsFile}
		else
			curl ${ubLtsUrl} > ${ubLtsFile}
		fi;;
	$betaVer)
		if [[ $distro == "c" ]]
		then
			curl ${centBetaUrl} > ${centBetaFile}
		else
			curl ${ubBetaUrl} > ${ubBetaFile}
		fi;;
	*)
		echo "Please select an appropriate version";;
	esac
done

#Installs the package and configures Morpheus services
if [[ $distro == "c" ]]
then
	echo $installing
	sudo rpm -i "morpheus-appliance-${ver}-1.el7.x86_64.rpm"
	
	echo $reconfiguring
	sudo morpheus-ctl reconfigure
else
	echo $installing
	sudo dpkg -i "morpheus-appliance_${ver}-1_amd64.deb"
	
	echo $reconfiguring
	sudo morpheus-ctl reconfigure
fi

#Updates appliance_url in morpheus.rb
echo "Do you wish to update appliance_url?"
echo "This is often required if the appliance machine name is not resolveable from the web browser of the accessing machine (https://appliance_machine_name)"
echo "(y/n)"
read updateUrl

if [[ $updateUrl == "y" ]]
then
	echo "Please provide the IP address for the appliance"
	read ip

	#Updates morpheus.rb

	#Reconfigures and restarts Morpheus UI
	echo $reconfiguring
	sudo morpheus-ctl reconfigure

	echo $restarting
	sudo morpheus-ctl stop morpheus-ui
	sudo morpheus-ctl start morpheus-ui
else
	echo "Moving on..."
fi

#Provides access details
echo "Done!"