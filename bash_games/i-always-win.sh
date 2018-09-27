#!/bin/bash
# AUTHOR: Abhishek Tamrakar
# EMAIL: abhishek.tamrakar08@gmail.com
#	LICENSE: Copyright (C) 2018 Abhishek Tamrakar
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
##
# game where computer always wins

total=20
remaining=$total
max_selection=5
min_selection=1
p1=''
p2=computer
violations=0

declare -a players=(p1 p2)
declare -a users

check_player()
{
  for user in ${players[@]}; do
    if [ x${!user} = x ]; then
      echo -e "error: ${user} has no name !!"
      exit 1
    else
      users=(${users[@]} ${!user})
      echo -e "info: ${user} -> ${!user} has joined the game." 
    fi
  done

#  echo -e "${#users[@]} registered. ${users[@]}"
}


echo -e "\e[033m"
cat<<_EOF_

[PLEASE READ]

This is a basic game, where each player has to select a random
number between 1-5, not more than 5, in a single chance. Going 
by every chance, the total ($total) will get deducted by the number
a player will choose.The last person to pick the number will be
the one to loose the game.

_EOF_

echo -e "\e[0m"

read -p "your name: " p1

while true; do
  read -p "info: start the game? y/n, ans: " yn
  case $yn in
    [Yy] ) echo -e "info: starting the game..\n"; break;;
    [Nn] ) echo -e "info: one of the player has opted to quit!!"; exit 1;;
    * )    echo -e "error: wrong choice, try again!!\n";;
  esac
done

check_player

i=1;

while [ $remaining -gt 0 ]; do

  echo -e "\n==============================="
  echo -e "ROUND $i: $remaining/$total available"
  echo -e "===============================\n"

  for user in ${users[@]}; do
    if [ "${user}" != "computer" ]; then
      read -p "[${user}] select a number[1-5]: " choice
      echo
    else
       choice=$((RANDOM%5+1))

       case $remaining in
    	12 ) 	choice=5;;
	11 ) 	choice=4;;
	10 ) 	choice=3;;
	9 )  	choice=2;;
	8 )  	choice=1;;
	[2-6] ) choice=$(expr $remaining - 1) 
       esac

       sleep 1s
    fi

    if [[ $choice -le 5 ]] && [[ $choice -ne 0 ]]; then
       echo -e "\e[033m[${user}]\e[0m selected $choice"
       dif=$choice
       ((remaining-=dif))
    else
       echo -e "\e[031m[${user}]\e[0m selected $choice, has cheated by violating the game rules.\n"
       echo -e "\n\n******\$\$\$\$\$\e[032m[${users[@]/${user}/}]\e[0m wins the game\$\$\$\$\$******\n\n"
       exit 1
    fi

    if [ $remaining -le 0 ]; then
       echo -e "\n\n******\$\$\$\$\$\e[032m[${users[@]/${user}/} ]\e[0m wins the game\$\$\$\$\$******\n\n"
       exit 0
    fi
  done

((i+=1))
done
