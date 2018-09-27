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

set=1
w1=0
w2=0
metrics="1 2 3 4 5 6 7 8 9 "
spots=$metrics
declare -a b=(' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ')
declare -a p1
declare -a p2
declare -a ids=(o x)
declare -a winsets=(123
456
789
147
258
369
396
963
936
639
693
852
582
528
285
825
741
714
417
471
174
159
195
519
591
951
915
753
735
537
573
357
375
321
312
213
231
132
465
546
564
645
654
798
879
897
987
978)

usage()
{
cat<<_EOF_

	This game is designed for fun and to show, what shell, itself, is capable of.
	The game has simple rules, Do not cheat. You can choose your own mark apart-
	the one provided as defaults. The board design with spots is below:

	# board design
	#  1 | 2 | 3
	#  --------
	#  4 | 5 | 6
	#  --------
	#  7 | 8 | 9

	Score: 6 points will be awarded each time a player wins.

	NOTE: playing with computer is still to write


_EOF_
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

is_winner()
{
    local c="$1"
    local u=$2

    len=${#c}
    if [ $len -eq 5 ]; then
      n=3
    else
      n=2
    fi
    for combination in $(eval echo {$c}{$c}{$c}); do
      if [ ${#combination} -eq 3 ]; then
        for match in ${winsets[@]}; do
          if [ $match -eq $combination ]; then
             if [ "$u" = "p1" ]; then
               ((w1+=1))
             else
               ((w2+=1))
             fi
	     break
          fi
        done
      else
        break
      fi
    done

cat<<_EOF_

      -SCORES-
     ---------
     | P1| P2|
     ---------
     |  $w1|  $w2|
     ---------

_EOF_
}

register_player()
{
  read -p "info: number of players? [2 max]: " n
  if [ $n -eq 2 ]; then
    for user in p1 p2; do
      read -p "info: enter player ID for $user [${ids[0]}/${ids[1]}]: " $user
      if [[ x${!user} = x ]] || [[ "$p1" = "$p2" ]]; then
	echo -e "error: player ID cannot be empty or identical!!"
	exit 1
      else
        ids=(${ids[@]/${!user}/})
      fi
    done
  elif [ $n -gt 2 ]; then
    echo -e "error: number of players cannot exceed 2!!"
    exit 1
  else
    read -p "info: enter player ID for p1: " p1
    p2=computer
  fi

# declare users array
  users=($p1 $p2)
  if [ ${#users[@]} -eq 2 ]; then
    printf '%s, ' "users ${users[@]}"
    printf ': %s\n' "have joined the game"
  fi
}

play()
{
count=0
  for i in $(seq 1 5); do
    for player in ${users[@]}; do
      ((count+=1))
      if [[ "$player" != "computer" ]] && [[ x${metrics} != x ]]; then
        while true; do
	read -p "[${player}] choose your spot [${metrics}]: " spot
        if [ x${b[$spot]} = x ]; then
  	  if [ "$player" = "$p1" ]; then
            b[$spot]=${p1}
	    if [[ x"$c1" = x ]]; then
	      c1="$spot"
	    else
	      c1="${c1} $spot"
	    fi
            w1=0
            is_winner "${c1// /,}" p1
	  else
            b[$spot]=$p2
	    if [[ x"$c2" = x ]]; then
  	      c2="$spot"
	    else
	      c2="${c2} $spot"
	    fi
            w2=0
            is_winner "${c2// /,}" p2
	  fi
          break
        else
          echo -e "warning: that spot is already taken!!"
        fi
        done
        metrics="${metrics/$spot /}"
        board
      elif [[ "$p2" = "computer" ]]; then
 				#TODO: AI algorithm for computer to choose.
        echo -e "info: this part is TODO, you can still enjoy the game with your friend!!"
				exit 1
      fi
    done
  done
}
### main ###

usage
register_player
play
