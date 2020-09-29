# /bin/bash

#Initialize variables
centLtsUrl="https://downloads.morpheusdata.com/files/morpheus-appliance-4.2.3-1.el7.x86_64.rpm"
centLtsFile="morpheus-appliance-4.2.3-1.el7.x86_64.rpm"
centBetaUrl="https://downloads.morpheusdata.com/files/morpheus-appliance-5.0.0-1.el7.x86_64.rpm"
centBetaFile="morpheus-appliance-5.0.0-1.el7.x86_64.rpm"
ubLtsUrl="https://downloads.morpheusdata.com/files/morpheus-appliance_4.2.3-1_amd64.deb"
ubLtsFile="morpheus-appliance_4.2.3-1_amd64.deb"
ubBetaUrl="https://downloads.morpheusdata.com/files/morpheus-appliance_5.0.0-1_amd64.deb"
ubBetaFile="morpheus-appliance_5.0.0-1_amd64.deb"
installing="Installing Morpheus..."
reconfiguring="Reconfiguring Morpheus..."

#Instructions
echo "Install Morpheus version 4.2.3 (LTS) or 5.0.0 (Beta) for CentOS 7 or Ubuntu 16.04/18.04"
echo "Press any key to begin"

#Stores IP address to variable

#Gets Linux distribution
until [[ $distro == "c" ]] || [[ $distro == "u" ]]
do
	echo "Indicate your Linux distribution, 'c' for CentOS 7 or 'u' for Ubuntu 16.04 or 18.04"
	read distro
done

#Gets desired Morpheus install package
echo "Choose the Morpheus version you wish to install:"

select ver in 4.2.3 5.0.0
do
	case $ver in
	4.2.3)
		if [[ $distro == "c" ]]
		then
			curl ${centLtsUrl} > ${centLtsFile}
		else
			curl ${ubLtsUrl} > ${ubLtsFile}
		fi;;
	5.0.0)
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

