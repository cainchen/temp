#!/usr/bin/env bash
clear
add_key () {
while true;
do
  printf "Do you need to add a ssh public key for the new account \033[40:36m$name\033[0m (y/n)?" && read yn4
  case $yn4 in
  [Yy]* ) mkdir -p /home/$name/.ssh
	  chown -R $name:$name /home/$name

}
yn3=y
while [ "$yn5" == 'y' ];
do
  while true;
  do
    read -p "Input the full name for create a new account it's shall not same the now esixts(ex. peterwu): " name
    printf "Your input is \033[40;36m$name\033[0m\n"
    printf "Does input is correctly? Push \033[44;37mY/y\033[0m go to next or push any key for re-input: " && read yn1
    case $yn1 in
    [Yy]) id $name
          if [ $? == '0' ];
          then
            printf "\033[41;33mFail!!\033[0m The name now is existed please input another one.\n"
            continue
          else
	    useradd $name
            printf "\033[40;36mAccount have been created:\033[0m\n"
	    id $name
	    printf "Do you need to set a password for the new account \033[40:36m$name\033[0m (y/n)?" && read yn2
            case $yn2 in
            [Yy]) printf "Input password: " $password
		  printf "Your input is \033[40;36m$password\033[0m\n"
		  printf "Does input is correctly? Push \033[44;37mY/y\033[0m go to next or push any key for re-input:" && read yn3
		  [Yy]) echo $password | passwd $name --stdin
		    * ) printf "\033[40;37mRe-input now.\033[0m\n"
		        continue
			;;
                  esac
                        while true;
                        do
                          printf "\n\033[40;37mDo you want to add another account(y/n)?\033[0m " && read yn4
                          case $yn3 in
                          [y]) func1 
                               break ;;
                          [n]) printf "\033[40;33mExit now!!\033[0m\n" 
                               func1
                               exit 0
                          esac
                        done
                        ;;
            *) printf "\033[40;37mRe-input now.\033[0m\n"
               continue
               ;;
               esac
          fi
          ;;
     * ) printf "\033[40;37mRe-input now.\033[0m\n"
         break
         ;;
    esac
  done
done
