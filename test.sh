#!/usr/bin/env bash
clear
add_user() {
ls ./userlist >/dev/null 2>&1
sudo rm -f ./new_userlist
sudo rm -f ./sudo_userlist
if [ $? != '0' ];
then
  printf "\033[41;33mFail!!\033[0m ./userlist not found and processed interrupt."
  exit 1
else
  list=$(cat ./userlist | wc -l) >/dev/null 2>&1
  if [ "$list" == '0' ];
  then
    printf "\033[41;33mFail!!\033[0m ./userlist not have any user name and processed interrupt."
    exit 1
  else
    for i in $(cat ./userlist)
    do
      id $i >/dev/null 2>&1
      if [ $? == '0' ];
      then
        printf "\033[30;0mInfo.\033[0m $i have existed.\n"
      else
	echo $i >> ./new_userlist
        sudo useradd $i
        id $i
      fi
    done
  fi
  ls ./new_userlist >/dev/null 2>&1
  if [ $? != '0' ];
  then
    printf "\033[33;40mAttention!!\033[0m all accounts you want to create have existed, nothing to do."
    exit 1
  fi
fi
}
add_pass() {
for j in $(cat ./new_userlist)
do
  echo qW58plmK | sudo passwd $j --stdin
  sudo echo "$j ALL=(ALL:ALL) NOPASSWD:ALL" >> ./sudo_userlist
done
}
add_key() {
for k in $(cat ./new_userlist)
do
  ls ./$k >/dev/null 2>&1
  if [ $? != '0' ];
  then
    printf "\033[41;33mFail!!\033[0mThe new account $k ssh public key file are not found in current path. \
	   \nThe account \033[40;36m$k\033[0m will be remove.\n"
    sudo userdel -r $k
  else
    sudo echo "$k ALL=(ALL:ALL) NOPASSWD:ALL" >> ./sudo_userlist
    sudo mkdir -p /home/$k/.ssh
    sudo mv ./$k /home/$k/.ssh/authorized_keys
    sudo chown -R $k:$k /home/$k
    sudo chmod 600 /home/$k/.ssh/authorized_keys
  fi
done
}
add_sudo() {
while true;
do
  printf "Do you want let all of new accounts can sudo switching to root permission bypass the password (y/n)? " && read yn4
  case $yn4 in
  [Yy]*) sudo sort -n ./sudo_userlist | uniq >> /etc/sudoers.d/sudo
	 break ;;
  [Nn]*) break ;;
  * ) printf "Input error!! please input \033[33;43mY/y\033[0m or \033[33;43mN/n\033[0m.\n"
      continue
  esac
done
printf "\nThank you for your using, bye bye!!\n"
exit 0
}
####
printf "Welcome to use this script for adding new user account.\n"
printf "Input any key to add user account.\n" && read go
add_user
while true;
do
  printf "Do you want to set a defualt password '\033[40;36mqW58plmK\033[0m' for the all new accounts (y/n)? " && read yn1
  case $yn1 in
  [Yy]*) add_pass
	 while true;
         do
	   printf "Do you want to add a \033[40;36mssh public key\033[0m for the all new accounts (y/n)? " && read yn2
	   case $yn2 in
	   [Yy]*) add_key
		  add_sudo
	          break ;;
	   [Nn]*) add_sudo
		  break ;;
	   * ) printf "Input error!! please input \033[33;43mY/y\033[0m or \033[33;43mN/n\033[0m.\n"
	       continue
	   esac
         done
	 break ;;
  [Nn]*) while true;
         do
           printf "Do you want to add a \033[40;36mssh public key\033[0m for the all new accounts (y/n)? " && read yn3
           case $yn3 in
           [Yy]*) add_key
		  add_sudo
  		  break ;;
  	   [Nn]*) printf "Please remember all the new accounts both are not have setting password and not have ssh public key.\n"
		  add_sudo
		  break ;;
  	   * ) printf "Input error!! please input \033[33;43mY/y\033[0m or \033[33;43mN/n\033[0m.\n"
	       continue
	   esac
	 done
      break ;;
  * ) printf "Input error!! please input \033[33;43mY/y\033[0m or \033[33;43mN/n\033[0m.\n"
      continue
  esac
done
