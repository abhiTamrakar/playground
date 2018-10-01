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
# tic-tac-toe game for shell users

# board design
#  1 | 2 | 3
#  --------
#  4 | 5 | 6
#  --------
#  7 | 8 | 9

set=0
metrics="1 2 3 4 5 6 7 8 9"
declare -a spots
declare -a users=(p1 p2)
declare -a b=(. . . . . . . . . .)
declare -a ids=(o x)

usage()
{
cat<<_EOF_

	This game is designed for fun and to show, what shell, itself, is capable of.
	The game has simple rules:
        * Do not cheat. 
        * You cannot choose your own mark apart from the one provided as defaults.
        The board design with spots is below:

	# board design
	#  1 | 2 | 3
	#  --------
	#  4 | 5 | 6
	#  --------
	#  7 | 8 | 9

	Score: 1 points will be awarded each time a player wins.

	NOTE: playing with computer is still to write


_EOF_
}
time_to_exit()
{
  echo -e "\n\nerror: it seems you have pressed ctrl+c. exiting now.\n"
  exit 1
}

board()
{
cat <<_EOF_


   --BOARD-[SET-$set]
====================
    ${b[1]} | ${b[2]} | ${b[3]}
    ---------
    ${b[4]} | ${b[5]} | ${b[6]}
    ---------
    ${b[7]} | ${b[8]} | ${b[9]}

_EOF_
}

get_empty_sets()
{
 spots=""
 for i in {1..9}; do
   if [[ ${b[$i]} = "." ]]; then
     spots="$spots $i"
   fi
   spots=${spots/ /}
 done
}

get_winner()
{
  local i=$1	# user
  local c=0	# wining occurences    

    if [[ "${b[1]}" = "${!i}" ]] && [[ ${b[2]} = "${!i}" ]] && [[ ${b[3]} = "${!i}" ]]; then
      ((c+=1))  
    elif [[ "${b[1]}" = "${!i}" ]] && [[ ${b[4]} = "${!i}" ]] && [[ ${b[7]} = "${!i}" ]]; then
      ((c+=1))  
    elif [[ "${b[1]}" = "${!i}" ]] && [[ ${b[5]} = "${!i}" ]] && [[ ${b[9]} = "${!i}" ]]; then
      ((c+=1))  
    elif [[ "${b[2]}" = "${!i}" ]] && [[ ${b[5]} = "${!i}" ]] && [[ ${b[8]} = "${!i}" ]]; then
      ((c+=1))  
    elif [[ "${b[3]}" = "${!i}" ]] && [[ ${b[6]} = "${!i}" ]] && [[ ${b[9]} = "${!i}" ]]; then
      ((c+=1))  
    elif [[ "${b[3]}" = "${!i}" ]] && [[ ${b[5]} = "${!i}" ]] && [[ ${b[7]} = "${!i}" ]]; then
      ((c+=1))  
    elif [[ "${b[4]}" = "${!i}" ]] && [[ ${b[5]} = "${!i}" ]] && [[ ${b[6]} = "${!i}" ]]; then
      ((c+=1))  
    elif [[ "${b[7]}" = "${!i}" ]] && [[ ${b[8]} = "${!i}" ]] && [[ ${b[9]} = "${!i}" ]]; then
      ((c+=1))  
    fi

  if [[ "$i" = 'p1' ]]; then
      w1=$((c1 + c))
  else
      w2=$((c2 + c))
  fi

cat<<_EOF_

      -SCORES-
     ---------
     | P1| P2|
     ---------
     |  ${w1:-0}|  ${w2:-0}|
     ---------

_EOF_
}

register_player()
{
local yn
while true; do
  read -p "info: want to play with computer? yn: " yn
  case $yn in
  [Yy] ) r=$(shuf -i 0-1 -n 1)
         player=${users[$r]}
         if [ "$player" = 'p1' ]; then
           echo -e "info: p1 will choose first."
           read -p "info: enter player ID for p1 [${ids[0]}/${ids[1]}]: " p1
         else
           echo -e "info: computer[p2] will choose first: \c"
           c=$(shuf -i 0-1 -n 1); p2=${ids[$c]}
           echo -n "$p2"
         fi
         computer=1
         break;;
  [Nn] ) player=p1
         read -p "info: enter player ID for p1 [${ids[0]}/${ids[1]}]: " p1
         break;;
   * )   echo -e "warning: invalid choice.";;
  esac
done

    if [[ "$player" == "p1" ]]; then
      if [[ -z "$p1" ]] || [[ "$p1" != "x" ]] && [[ "$p1" != "o" ]]; then
        echo -e "error: player ID cannot be empty or other than o/x!!"
        exit 1
      elif [[ "$p1" = 'o' ]]; then
        p2=x
      elif [[ "$p1" = 'x' ]]; then
        p2=o
      fi
    else
      if [[ -z $p2 ]] || [[ "$p2" != "x" ]] && [[ "$p2" != "o" ]]; then
        echo -e "error: player ID cannot be empty or other than o/x!!"
        exit 1
      elif [[ "$p2" = 'o' ]]; then
        p1=x
      elif [[ "$p2" = 'x' ]]; then
        p1=o
      fi
    fi

    printf '\n%s\n%s\n' "info: p1 has chosen $p1" "info: p2 has chosen $p2"
}

play()
{
  ((set+=1))
 get_empty_sets
  while [ ${#spots} -gt 1 ]; do
    for player in ${users[@]}; do
      if [[ $computer -ne 1 ]] && [[ ${#spots} -gt 1 ]]; then
        get_empty_sets
        while true; do
	read -p "[${player}](${!player}) choose your spot [${spots}]: " spot
        if [ "${b[$spot]}" = '.' ]; then
  	  if [ "$player" = "p1" ]; then
            b[$spot]=${p1}
            get_winner p1
	  else
            b[$spot]=$p2
            get_winner p2
	  fi
          break
        else
          echo -e "warning: that spot is already taken!!"
        fi
        done
        board
      elif [[ ${computer:-0} -eq 1 ]]; then
	#TODO: AI algorithm for computer to choose.
        echo -e "SORRY: this part is TODO, you can still enjoy the game with your friend!!"
	exit 1
      fi
    done
  done

if [[ ${w1:-0} -eq ${w2:-0} ]]; then
  echo -e "\ninfo: ****The game is a tie.****\n"
elif [[ ${w1} -gt ${w2} ]]; then
  echo -e "\ninfo: ****player p1 has beaten p2 by [${w1:-0}-${w2:-0}] in total $set sets.****\n"
else
  echo -e "\ninfo: ****player p2 has beaten p1 by [${w1:-0}-${w2:-0}] in total $set sets..****\n"
fi
}

### main ###
trap time_to_exit INT

usage
register_player
play

while true; do
  read -p 'info: do you want to play again? [y/n] ' yn
  case $yn in
    [Yy]) b=(. . . . . . . . . .)
          c1=${w1:-0}
          c2=${w2:-0}
          play;;
    [Nn]) echo -e "info: exiting the game."
          exit 0;;
  esac 
done
