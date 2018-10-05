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

sets=0
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



_EOF_
}

time_to_exit()
{
  echo -e "\n\nerror: you pressed ctrl+c. exiting now.\n"
  exit 1
}

board()
{
cat <<_EOF_


     [SET-$sets]
====================
    ${b[1]} | ${b[2]} | ${b[3]}
    ---------
    ${b[4]} | ${b[5]} | ${b[6]}
    ---------
    ${b[7]} | ${b[8]} | ${b[9]}

_EOF_
}

get_my_move()
{
# if still not moved, then select random move.
  if [[ $moved -eq 0 ]]; then
    spot=$(shuf -e ${spots} -n 1)
    is_spot_free $spot
  fi
}

is_spot_free()
{
  local s=$1
  if [ "${b[$s]}" = '.' ]; then
    spot=$1
    b[$spot]=$c
    echo -e "info: [c]($c) has chosen it's spot: $spot"
    ((moved+=1))   
  fi
}

# simple AI to guess if either party can win.
can_win()
{
  local w=$1
  local a
  
  winsets=(147 123 159 258 369 789 456 357)
  for a in ${winsets[@]}; do
#    for w in $c $p1; do
      one="${a:0:1}"
      two="${a:1:1}"
      three="${a:2:1}"
      if [[ $moved -eq 0 ]]; then
        if [[ ${b[$one]} = "$w" ]] && [[ ${b[$two]} = "$w" ]]; then
          is_spot_free $three
        elif [[ ${b[$one]} = "$w" ]] && [[ ${b[$three]} = "$w" ]]; then
          is_spot_free $two
        elif [[ ${b[$two]} = "$w" ]] && [[ ${b[$three]} = "$w" ]]; then
          is_spot_free $one
        fi
      fi
#    done
  done
}

# get empty spots on board
get_empty_sets()
{
 spots=""
 for i in {1..9}; do
   if [[ ${b[$i]} = "." ]]; then
     spots="$spots $i"
   fi
     nspots=${spots// /}
 done
     spots=${spots/ /}
}

# simple logic to get winner
get_winner()
{
  local i=$1	# user
  local v=0	# wining occurences    

    if [[ "${b[1]}" = "${!i}" ]] && [[ ${b[2]} = "${!i}" ]] && [[ ${b[3]} = "${!i}" ]]; then
      ((v+=1))  
    elif [[ "${b[1]}" = "${!i}" ]] && [[ ${b[4]} = "${!i}" ]] && [[ ${b[7]} = "${!i}" ]]; then
      ((v+=1))  
    elif [[ "${b[1]}" = "${!i}" ]] && [[ ${b[5]} = "${!i}" ]] && [[ ${b[9]} = "${!i}" ]]; then
      ((v+=1))  
    elif [[ "${b[2]}" = "${!i}" ]] && [[ ${b[5]} = "${!i}" ]] && [[ ${b[8]} = "${!i}" ]]; then
      ((v+=1))  
    elif [[ "${b[3]}" = "${!i}" ]] && [[ ${b[6]} = "${!i}" ]] && [[ ${b[9]} = "${!i}" ]]; then
      ((v+=1))  
    elif [[ "${b[3]}" = "${!i}" ]] && [[ ${b[5]} = "${!i}" ]] && [[ ${b[7]} = "${!i}" ]]; then
      ((v+=1))  
    elif [[ "${b[4]}" = "${!i}" ]] && [[ ${b[5]} = "${!i}" ]] && [[ ${b[6]} = "${!i}" ]]; then
      ((v+=1))  
    elif [[ "${b[7]}" = "${!i}" ]] && [[ ${b[8]} = "${!i}" ]] && [[ ${b[9]} = "${!i}" ]]; then
      ((v+=1))  
    fi

  if [[ "$i" = 'p1' ]]; then
      w1=$((c1 + v))
  else
      w2=$((c2 + v))
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
         users[1]=c
         player=${users[$r]}
         if [ "$player" = 'p1' ]; then
           echo -e "info: p1 will choose first."
           read -p "info: player ID for p1 [${ids[0]}/${ids[1]}]: " p1
         else
           echo -e "info: computer[$player] will choose first: \c"
           c=$(shuf -i 0-1 -n 1); c=${ids[$c]}
           echo -n "$c"
         fi
         break;;
  [Nn] ) r=$(shuf -i 0-1 -n 1)
         player=${users[$r]}
         read -p "info: player ID for ${player} [${ids[0]}/${ids[1]}]: " ${player}
         break;;
   * )   echo -e "warning: invalid choice.";;
  esac
done

    if [[ "$player" = "p1" ]] && [[ "${users[1]}" = "p2" ]]; then
      if [[ -z "$p1" ]] || [[ "$p1" != "x" ]] && [[ "$p1" != "o" ]]; then
        echo -e "error: player ID should either be o/x!!"
        exit 1
      elif [[ "$p1" = 'o' ]]; then
        p2=x
      elif [[ "$p1" = 'x' ]]; then
        p2=o
      fi
    elif [[ "$player" = 'c' ]]; then
      if [[ "$c" = 'o' ]]; then
        p1=x
      else
        p1=o
      fi
    elif [[ "${player}" = "p2" ]]; then
      if [[ -z "$p2" ]] || [[ "$p2" != "x" ]] && [[ "$p2" != "o" ]]; then
        echo -e "error: player ID should either be o/x!!"
        exit 1
      elif [[ "$p2" = 'o' ]]; then
        p1=x
      else
        p1=o
      fi
    else
      if [[ "$p1" = 'o' ]]; then
        c=x
      else
        c=o
      fi
    fi

    printf '\n%s\n%s\n' "info: ${users[0]} has chosen $p1" "info: ${users[1]} has chosen ${p2:-$c}"
}

play()
{
  local u=$r
  ((sets+=1))
  get_empty_sets
  while [ ${#nspots} -ge 1 ]; do
    moved=0
    case $u in
      0 ) player=${users[0]}
          get_empty_sets
          if [ ${#nspots} -lt 1 ]; then
            break
          fi
          while true; do
            read -p "[${player}](${!player}) choose your spot [${nspots}]: " spot
            if [[ "${b[$spot]}" = '.' ]] && [[ ! -z $spot ]] && [[ ! $spot -gt 9 ]] && [[ ! "$spot" =~ [a-z] ]]; then
              if [ "$player" = "p1" ]; then
                b[$spot]=${p1}
                get_winner p1
              fi
              break
            else
              echo -e "warning: that spot is not allowed!!"
            fi
          done
          board
          u=1;;
      1 ) player=${users[1]}
          get_empty_sets
          if [ ${#nspots} -lt 1 ]; then
            break
          fi
          if [ "${users[1]}" = "p2" ]; then
            while true; do
              read -p "[${player}](${!player}) choose your spot [${nspots}]: " spot
              if [[ "${b[$spot]}" = '.' ]] && [[ ! -z $spot ]] && [[ ! $spot -gt 9 ]] && [[ ! "$spot" =~ [a-z] ]]; then
                b[$spot]=$p2
                get_winner p2
              break
              else
                echo -e "warning: that spot is not allowed!!"
              fi
            done
            board
          else
            # logic for computer move
            can_win $c
            can_win $p1
            # is still not moved
            get_my_move
            get_winner c
            board	# print board only once in a 1 player game.
          fi
          u=0;;
    esac
  done

if [[ ${w1:-0} -eq ${w2:-0} ]]; then
  echo -e "\ninfo: ****The game is a tie.****\n"
elif [[ ${w1} -gt ${w2} ]]; then
  echo -e "\ninfo: ****player 1 won by [${w1:-0}-${w2:-0}] in $sets sets.****\n"
else
  echo -e "\ninfo: ****player 2 won by [${w1:-0}-${w2:-0}] in $sets sets..****\n"
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
