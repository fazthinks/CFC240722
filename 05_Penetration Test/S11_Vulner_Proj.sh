#!/bin/bash

# Name of Student (Code): Muhd Fazil Istamar (S11)
# Class Code: CFC240722
# Name of Trainer: James Lim
# Filename: S11_Vulner_Proj.sh

#Project Title
figlet "Vulner!"

#Date Format: DDMMYY
df=$(date +"%d%m%y")

# Make use of nested function to house commands for sub-menu actions: App Installation, Network Scan, Enumeration, Vulnerability Scan, Brute Force attack and Viewing of Results.
function menu()
{	
# Main Menu Page
echo '============================================================'
echo '                      MAIN MENU                             '
echo '============================================================'
echo -e "\nWhat would you like to do, $USER?\n"
echo '[1] A.I - Apps Installation'
echo '[2] S.E.E - Scan Enumerate Explore'
echo '[3] B.F.A - Brute Force Attack'
echo '[4] Results'
echo -e "\n[E] Exit"
echo -e "\nPlease input desired option to proceed with next action."
read menu_choice
echo
	# Option [1] A.I sub-menu
	function AI()
	{
		#~ sudo apt-get update
		#~ sudo apt-get upgrade -y
		sleep 2
		 
		echo -e '\n1. Nmap & Netdiscover'
		sleep 2
		# Install Nmap to be used for network discovery and security auditing.
		# Install Netdiscover; a simple ARP scanner to scan for Live Host(s) in a network.
		#~ sudo apt-get -yV install nmap netdiscover
		sleep 2

		echo -e '\n2. Ghostscript, enscript, evince & PDFtk'
		sleep 2
		# Install the following packages used in generating PDF file.
		#~ sudo apt-get install ghostscript enscript evince pdftk-java -y
		sleep 2
		
		echo -e '\n3. WebMap'
		sleep 2
		# Install WebMap that offers dashboard for Nmap XML output file.
		#~ sudo apt install docker.io
		
		# Create a new folder for WebMap process Nmap XML output files
		mkdir /tmp/mp
		
		# Configuration and additional files download
		sudo docker run -d \
					--name webmap\
					-h webmap \
					-p 8000:8000 \
					-v /tmp/webmap:/opt/xml \
					reborntc/webmap
		sleep 2
				
		# Variables for retrieving apps/tools newly-installed.		
		header=$(dpkg --list | head -n 5)
		AI_1=$(dpkg --list | grep nmap)
		AI_2=$(dpkg --list | grep netdiscover)
		AI_3=$(dpkg --list | grep ghostscript)
		AI_4=$(dpkg --list | grep enscript)
		AI_5=$(dpkg --list | grep evince)
		AI_6=$(dpkg --list | grep pdftk-java)
		AI_7=$(dpkg --list | grep docker)
		# Print out the basic details of application/tool installed.
		echo -e "$header \n$AI_1 \n$AI_2 \n$AI_3 \n$AI_4 \n$AI_5 \n$AI_6 \n$AI_7"
		sleep 5
		echo -e '\nReturn to Main Menu for more options.'
		# Return to Main Menu for more choices of activity.
		menu
	}

	function NWS()
	{ 
		#Peform a network scan every time user execute this bash script file.
		# cidr - IP Address in CIDR format
		cidr=$(ip a s | grep noprefixroute | grep eth0 | awk '{print $2}')
		
		# nwr - NetWork Range
		nwr=$(netmask -r $cidr)
		
		# snm - SubNet Mask IP Address2
		snm=$(ifconfig | grep broadcast | tail -n 1 | awk '{print $4}')
		
		# Print out the details
		echo "IP Address (CIDR Format): $cidr"
		echo "Network Range:$nwr"
		echo -e "Subnet mask: $snm\n"	
	}
	
	# Option [2] S.E.E sub-menu
	function SEE()
	{
		echo '============================================================'
		echo '       Main Menu > [2] S.E.E - Scan◦Enumerate◦Explore       '
		echo '============================================================'
		echo -e "\nWhat would you like to do, $USER?\n"
		echo '[1] Scan Network'
		echo '[2] Enumerate live host(s)'
		echo '[3] Explore potential vulnerabilities'
		echo -e '\n[R] Return to Main Menu\n'
		read -p "Option  " SEE_choice
			
		case $SEE_choice in
			(1)
				# To re-iterate the user's option for clarity
				echo -e "\nYou have chosen Option $SEE_choice - Scan Network\n"
				sleep 2
				
				# This file will store Live Host(s) info detected in current LAN network.
				nwscan=nws_$df.txt
				
				# Create a new file (*.txt).
				touch $nwscan
				printf "\n$(date)  $(whoami)  Scan LAN Network\n" > $nwscan
				
				# Call out 'NWS' function to determine LAN network range
				NWS
				
				# lh = Live Host
				# Created a variable for scanning of current LAN network.
				lh=$(sudo netdiscover -r $cidr -P)
				
				# Scan current LAN based on IP address (CIDR format).
				echo "$lh"
				
				# Print all the identified Live Host(s) details into newly created file (*.txt).
				printf "$lh" >> $nwscan
				echo -e "\nThe above listing is saved in the current working directory as $nwscan.\n"
				
				# This file will contain a listing of Live Host(s) IP address only.
				# ipl = IP Address Listing
				ipl=ip_$df.lst
				
				# Create the file (*.lst).
				touch $ipl
				
				# Filter scan result of current LAN for IP address of Live Host(s) in ascending order.
				lhip=$(cat $nwscan | grep 'VMware' | awk '{print $1}' | sort -t . -k 3,3n -k4,4n)
				
				# Print all the Live Host(s) IP address into newly created file (*.lst).
				printf "$lhip" > $ipl
				
				# Allow command stoppage time of 5 seconds for user to view detected Live Host(s) IP Address
				sleep 5
				
				# Create Folder Directory for each Live Host detected (forloop) for storage of enumaeration and vulnerability scan results.
				# This will allow easy retrieval of results based on identified IP Address.
				for indv_lhip in $lhip
				do
					mkdir $indv_lhip
				done
				
				# Return to Option [2] S.E.E sub-menu.
				SEE
			;;
		
			(2)
				# To re-iterate the user's option for clarity.
				echo -e "\nYou have chosen Option $SEE_choice - Enumerate live host(s)"
				sleep 2
				
				# Display the detected Live Host(s) IP Address for user's reference.
				echo -e "\nBelow is the list of live host(s) that will be enumerated:\n"
				cat $ipl
				sleep 2
				
				# Used a forloop so that all the Live Host(s) will be enumerated and scan output files will be saved in respective folders.
				for indv_lhip_nmpe in $lhip
				do
					# Navigate to folder of interest based on Live Host IP Address. 
					cd $indv_lhip_nmpe
					
					# Need to insert command for user to see the directory where the scan will be saved.
					F1=$(pwd)
					echo -e "\nEnumeration scan of $indv_lhip_nmpe will be saved in this directory: $F1.\n"
					
					# Variables for the different enumeration Nmap scan files.
					ipopx=ip_open_port_$df.xml
					ipoph=ip_open_port_$df.html
					ipopg=ip_open_port_$df.txt
					ipop=ip_open_ports_filtered_$df.lst
					
					# Print header that serves as metadata for the information captured.
					printf "\nPORT    STATE  SERVICE        REASON          VERSION\n" > $ipop
					
					# Triggered enumeration process with decoy IP addresses.
					sudo nmap $indv_lhip_nmpe -sV -O -v --reason -oX $ipopx -oG $ipopg -D 192.167.55.1,192.166.50.2,192.165.45.3
					
					# Convert XML to HTML.
					xsltproc $ipopx -o $ipoph
					
					# Performed a 2nd Nmap scan with grep command for 'open' ports and save these filtered info directly to a txt file.
					sudo nmap $indv_lhip_nmpe -sV -O -v --reason | grep 'open' | grep -v 'Discovered' | cat >> $ipop
					
					# Navigate back to original directory where the bash script file was executed.
					cd ..
				done 
				
				# User is made aware of the output Nmap scan files generated from the enumeration process.
				echo -e "NMap scan (Open Port) is saved in the current working directory as $ipopx and $ipoph.\n"
				
				# Return to Option [2] S.E.E sub-menu.
				SEE
			;;
			
			(3)
				# To re-iterate the user's option for clarity
				echo -e "\nYou have chosen Option $SEE_choice - Explore potential vulnerabilities\n"
				
				A=$(ip a s | grep noprefixroute |grep eth0 | awk '{print $2}')
				B=$(sudo netdiscover -r $A -P | grep 'VMware' | awk '{print $1}' | sort -t . -k 3,3n -k4,4n)
				
				# Used a forloop so that all the Live Host(s) will be explored for potential vulnerabilities and scan output files will be saved in respective folders.						
				for indv_lhip_nmpv in $B
				do
					# Navigate to folder of interest based on Live Host IP Address.
					cd $indv_lhip_nmpv
					
					# For user's reference on the file storage pathway
					F2=$(pwd)
					echo -e "\nVulnerability scan of $indv_lhip_nmpv will be saved in this directory - $F2.\n"
					
					# Variables for the different vulnerability Nmap scan files.
					nmpvx=ip_op_vuln.xml
					nmpvh=ip_op_vuln.html
					nmpvg=ip_op_vuln.txt
					
					# Triggered vulnerability scan using one of NSE script with decoy IP addresses.
					sudo nmap $indv_lhip_nmpv -sS -A -O --script=vuln -oX $nmpvx -oG $nmpvg -D 192.167.55.1,192.166.50.2,192.165.45.3
					
					# Convert XML to HTML.
					xsltproc $nmpvx -o $nmpvh
					sleep 5
					
					# Navigate back to original directory where the bash script file was executed.
					cd ..
				done
				
				# User is made aware of the output Nmap scan files generated from the vulnerability scan.
				echo -e "\nNmap scan output is saved in the current working directory as $nmpvx and $nmpvh.\n"
				
				# Return to Option [2] S.E.E sub-menu.
				SEE
			;;				
							
			(R)
				# To re-iterate the user's option for clarity.
				echo -e "\nYou have chosen Option $netscan_choice - Return to Main Menu.\n"
				sleep 2
				# Return to Main Menu.
				menu
			;;
			
			(*)
				# To inform user of an invalid input.
				echo -e '\nPlease input the desired option: [1] or [2] or [R - Return to Main Menu].\n'
				sleep 2
				# Return to Option [2] S.E.E sub-menu.
				SEE
			;;
		esac
	}
	
	# Option [3] B.F.A sub-menu
	function BFA()
	{
		echo '============================================================'
		echo '        Main Menu > [3] B.F.A - Brute Force Attack          '
		echo '============================================================'
		echo -e "\nWhat would you like to do, $USER?\n"
		echo '[1] Brute Force Attack (Hydra) - User & Password List' 
		echo '[2] Brute Force Attack (Hydra) - User List'
		echo -e '\n[R] Return to Main Menu\n'
		sleep 1
		read -p "Option  " BFA_choice
		
		case $BFA_choice in
			(1)
				# Use of function to execute Hydra attack using specified User and Password lists.
				function BFA_upl()
				{
					# To re-iterate the user's option for clarity
					echo -e "\nYou have chosen Option $BFA_choice - Brute Force Attack (Hydra) - User & Password List"
					
					# To state the working directory that the command is currently in. This will allow user to assess whether to define the file or the full file pathway directory.
					F3=$(pwd)
					echo -e "\nYour current working directory is: $F3"
					
					# List down the files for user's reference so it will be easy to name the User and Password list.
					echo -e "\nFiles in the current workng directory:\n"
					ls -all
					echo
					
					# Prompt user to define User List file.
					echo -e "\nPlease define your User List file. (Note:Include the full file pathway if the user list is not saved in current directory.)"
					read BFA_uid1
					
					# Prompt user to define Password List file.
					echo -e "\nPlease define your Password List file. (Note:Include the full file pathway if the password list is not saved in current directory.)"
					read BFA_pwd1
					
					# List down the detected Live Host(s). This will be helpful especially when user has a long list of IP address.
					A=$(ip a s | grep noprefixroute |grep eth0 | awk '{print $2}')
					B=$(sudo netdiscover -r $A -P | grep 'VMware' | awk '{print $1}' | sort -t . -k 3,3n -k4,4n)
					echo -e "\nBelow is the list of detected live host(s):\n$B"
					
					# Prompt user to define target Live Host.
					echo -e "\nPlease state your target IP Address based on the listing above."
					read BFA_target1
					
					for indv_lhip_bfa1 in $B
					do
						# Navigate to folder of interest based on Live Host IP Address.
						cd $indv_lhip_bfa1
						# Text manipulation of current working directory to get folder name for comparison
						F4=$(pwd | awk -F/ '{print $6}')
							
							# If the user's input of target IP address matches 1st IP address in the list of detected Live Host(s), the script will proceed to list down the 'open' ports.
							# If otherwise, the script will check for folders name with the same IP address as user's input. Similarly, the script will list down the 'open' ports which are stored in txt file.
							if [ $BFA_target1 == $F4 ]
							then
								
								# List down the 'open' ports for that specific Live Host.
								cat ip_open_ports_filtered_*.lst
								count_port=$(cat ip_open_ports_filtered_*.lst | grep open | wc -l)
								echo -e "\nNumber of services: $count_port"
								
								# Prompt user to choose service that will be subjected to Brute Force Attack. 
								echo -e "\nType of service? (E.g ssh, apache2, ftp and etc.)"
								read BFA_svc1
							else
								# Will need to move back to original working directory before the script can check for relevant and correct folders.
								cd ..
								
								# Navigate to folder of interest based on Live Host IP Address.
								cd $BFA_target1
								
								# List down the 'open' ports for that specific Live Host.
								cat ip_open_ports_filtered_*.lst
								count_port=$(cat ip_open_ports_filtered_*.lst | grep open | wc -l)
								echo -e "\nNumber of services: $count_port"
								
								# Prompt user to choose service that will be subjected to Brute Force Attack.
								echo -e "\nType of service? (E.g ssh, apache2, ftp and etc.)"
								read BFA_svc1
							fi	
						
						# Navigate back to original directory where the bash script file was executed.
						cd ..
						
						# Execute Hydra attack to target Live Host using specific user and password lists and chosen service.
						sudo hydra -L $BFA_uid1 -P $BFA_pwd1 $BFA_target1 $BFA_svc1 -vV -o BFA_UPWD_$df.txt
						
						# Move the hydra attack txt file to target IP Address Live Host folder.
						mv BFA_UPWD_$df.txt $BFA_target1/BFA_UPWD_$df.txt
						sleep 5
						
						# Return to Option [3] B.F.A sub-menu.
						BFA
					done
				}
				BFA_upl
			;;
		
			(2)
				# Use of function to execute Hydra attack using specified User list and create new Password list.
				function BFA_ul()
				{
					# To re-iterate the user's option for clarity
					echo -e "\nYou have chosen Option $BFA_choice - Brute Force Attack (Hydra) - User List"
					
					# Text manipulation of current working directory to get folder name for comparison
					F5=$(pwd)
					
					# To state the working directory that the command is currently in. This will allow user to assess whether to define the file or the full file pathway directory.
					echo -e "\nYour current working directory is: $F5"
					echo -e "\nFiles in the current workng directory:\n"
					ls -all
					echo
					
					# Prompt user to define User List file.
					echo -e "\nPlease define your User List file. (Note:Include the full file pathway if the user list is not saved in current directory.)"
					read BFA_uid2
					
					# Guide user to create a Password List file.
					echo -e "\nLet's create a Password list by entering five(5) unique passwords to be used in Brute Force Attack."
					
					# Create a forloop to create a Password List file by getting user to input passwords.
					BFA_pwd2=pwd_$df.lst
					for i in {1..5}; 
					do 
						read -p "Enter a unique password:  " pwd
						printf "$pwd" >> $BFA_pwd2
					done
					
					# Inform user about the name of the newly generated Password List file.
					echo -e "\nA new Password List has been created and saved as (pwd_$df.lst) in the current directory - $F5."
					
					# List down the detected Live Host(s). This will be helpful especially when user has a long list of IP address.
					C=$(ip a s | grep noprefixroute |grep eth0 | awk '{print $2}')
					D=$(sudo netdiscover -r $C -P | grep 'VMware' | awk '{print $1}' | sort -t . -k 3,3n -k4,4n)
					echo -e "\nBelow is the list of detected live host(s):\n$D"
					
					# Prompt user to define target Live Host.
					echo -e "\nPlease state your target IP Address based on the listing above."
					read BFA_target2
					
					
					for indv_lhip_bfa2 in $D
					do
						# Navigate to folder of interest based on Live Host IP Address.
						cd $indv_lhip_bfa2
						
						# Text manipulation of current working directory to get folder name for comparison
						F6=$(pwd | awk -F/ '{print $6}')
							
							# If the user's input of target IP address matches 1st IP address in the list of detected Live Host(s), the script will proceed to list down the 'open' ports.
							# If otherwise, the script will check for folders name with the same IP address as user's input. Similarly, the script will list down the 'open' ports which are stored in txt file.
							if [ $BFA_target2 == $F6 ]
							then
								# List down the 'open' ports for that specific Live Host.
								cat ip_open_ports_filtered_*.lst
								count_port2=$(cat ip_open_ports_filtered_*.lst | grep open | wc -l)
								echo -e "\nNumber of services: $count_port2"
								
								# Prompt user to choose service that will be subjected to Brute Force Attack.
								echo -e "\nType of service? (E.g ssh, apache2, ftp and etc.)"
								read BFA_svc2
							else
								# Will need to move back to original working directory before the script can check for relevant and correct folders.
								cd ..
								
								# Navigate to folder of interest based on Live Host IP Address.
								cd $BFA_target2
								
								# List down the 'open' ports for that specific Live Host.
								cat ip_open_ports_filtered_*.lst
								count_port2=$(cat ip_open_ports_filtered_*.lst | grep open | wc -l)
								echo -e "\nNumber of services: $count_port2"
								
								# Prompt user to choose service that will be subjected to Brute Force Attack.
								echo -e "\nType of service? (E.g ssh, apache2, ftp and etc.)"
								read BFA_svc2
							fi	
						
						# Navigate back to original directory where the bash script file was executed.
						cd ..
						
						# Execute Hydra attack to target Live Host using specific user list, newly created password list and chosen service.
						sudo hydra -L $BFA_uid2 -P $BFA_pwd2 $BFA_target2 $BFA_svc2 -vV -o BFA_U_$df.txt
						
						# Move the hydra attack txt file to target IP Address Live Host folder.
						mv BFA_U_$df.txt $BFA_target2/BFA_U_$df.txt
						sleep 5
						
						# Return to Option [3] B.F.A sub-menu.
						BFA
					done
				}
				BFA_ul
			;;
			
			(R)
				# To re-iterate the user's option for clarity
				echo -e "\nYou have chosen Option $cyberat_choice - Return to Main Menu.\n"
				# Return to Main Menu.
				menu
			;;
			
			(*)
				# To inform user of an invalid input
				echo -e "\nPlease input the desired option: [1] to [3] or [R - Return to Main Menu].\n"
				sleep 2
				
				# Return to Option [3] B.F.A sub-menu.
				BFA
			;;
		esac
	}
	
	#Option [4] Results sub-menu
	function RES()
	{
		echo '============================================================'
		echo '         Main Menu > [4] Results            '
		echo '============================================================'
		echo -e '\nWhich logs would you like to view?'
		echo '[1] S.E.E Result (WebMap)'
		echo '[2] B.F.A Result (PDF)'
		echo -e '\n[R] Return to Main Menu\n'
		sleep 1
		read -p "Option  " RES_choice
		case $RES_choice in
			(1)
				# To re-iterate the user's option for clarity
				echo -e "\nYou have chosen Option $RES_choice - S.E.E Result (WebMap)."
				
				# Prompt user to input Live Host of interest.
				echo -e "\nPlease state your Live Host IP Address that you wish to view the results."
				read RES_SEE	
				
				# Navigate to folder of interest based on Live Host IP Address.
				cd $RES_SEE
				
				# Copy Nmap XML files to WebMap folder where it will be processed into dashboard display 
				sudo cp ip_open_port_*.xml /tmp/webmap/ip_open_port_$df.xml
				sudo cp ip_op_vuln.xml /tmp/webmap/ip_op_vuln_$df.xml
				
				# In order to access to the WebMap dashboard, a token is needed and can be created using the command below.
				sudo docker exec -ti webmap /root/token
				
				# User will need to copy a unique token.
				echo 'For first time setting, copy (Ctrl+Shift+C) the token and paste it to prompt message in Firefox for access to WebMap.'
				sleep 2
				
				# Launch WebMap in FireFox.
				firefox http://localhost:8000
				
				# Delete the XML files so that there will be no conflict of Nmap XML files for other Live Hosts(s).
				sudo rm /tmp/webmap/*.xml
				
				# Navigate back to original directory where the bash script file was executed.
				cd ..
				
				# Return to Option [4] Result sub-menu.				
				RES
			;;
		
			(2)
				# To re-iterate the user's option for clarity
				echo -e "\nYou have chosen Option $RES_choice - B.F.A Result (PDF)."
				echo -e "\nPlease state your Live Host IP Address that you wish to view the results."
				read RES_BFA	
				
				# Navigate to folder of interest based on Live Host IP Address.
				cd $RES_BFA
				echo -e "\nWill generate Brute Force Attack PDF file!"
				
				# Convert a text file to Postscript format.
				enscript -p BFA_UPWD_$df.ps BFA_UPWD_$df.txt
				enscript -p BFA_U_$df.ps BFA_U_$df.txt
				
				# Variable for different Brute Force Attack results PDF files
				PDF_1=BFA_UPWD_$df.pdf
				PDF_2=BFA_U_$df.pdf
				
				# Convert newly generated postscript file to PDF file.
				ps2pdf BFA_UPWD_$df.ps BFA_UPWD_$df.pdf
				ps2pdf BFA_U_$df.ps BFA_U_$df.pdf
				
				# Launch PDF viewer application.
				evince BFA_UPWD_$df.pdf
				evince BFA_U_$df.pdf
				
				# Remove unnecessary postscript file
				sudo rm *.ps
				
				F7=$(pwd)
				# Inform user of the PDF file(s) generated and where it is stored.
				echo -e "\n	PDF file(s) generated: $PDF_1 $PDF_2"
				echo -e "\n The file(s) is saved in $F7."		
				
				# Navigate back to original directory where the bash script file was executed.
				cd ..				
				
				# Return to Option [4] Result sub-menu.
				RES
			;;
					
			(R)
				# To re-iterate the user's option for clarity
				echo -e "\nYou have chosen Option $viewlog_choice - Return to Main Menu.\n"
				menu
			;;
			
			(*)
				# To inform user of an invalid input
				echo -e '\nPlease input the desired option: [1] to [6] or [R - Return to Main Menu].\n'
				sleep 2
				
				# Return to Option [4] Result sub-menu.
				RES
			;;
		esac		
	}
case $menu_choice in
		(1)
			# To re-iterate the user's option for clarity
			echo -e "\nYou have chosen Option $menu_choice - A.I.\n"
			sleep 2
			# Go to Function 'AI'. It is at this point, the function get called out and the commands get executed. This applies to other options.
			AI	
		;;
	
		(2)
			# To re-iterate the user's option for clarity
			echo -e "\nYou have chosen Option $menu_choice - S.E.E.\n"
			sleep 2
			# Go to Function 'SEE'.
			SEE
		;;
		
		(3)
			# To re-iterate the user's option for clarity
			echo -e "\nYou have chosen Option $menu_choice - B.F.A.\n"
			sleep 2
			# Go to Function 'BFA'.
			BFA	
		;;
			
		(4)
			# To re-iterate the user's option for clarity
			echo -e "\nYou have chosen Option $menu_choice - Results.\n"
			sleep 2
			# Go to Function 'RES'
			RES
		;;
		
		(E)
			# This option caters to user who wish to exit early.
			echo -e "\nYou have chosen Option $menu_choice - Exit. Bye Bye and have a nice day!\n"
			sleep 2
			exit
		;;
		
		(*)
			# This option caters to user who input incorrect option not defined in 'case statement'.
			echo -e '\nPlease input the desired option: [1] to [4] or [E - Exit].\n'
			sleep 2
			# Go to Function 'menu'
			menu
		;;
	esac		
}
menu
