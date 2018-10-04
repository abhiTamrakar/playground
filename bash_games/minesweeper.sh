#!/bin/bash
# AUTHOR: Abhishek Tamrakar
# EMAIL: abhishek.tamrakar08@gmail.com
# LICENSE: Copyright (C) 2018 Abhishek Tamrakar
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
##
# minesweeper in shell

#---------------
# * | * | * | *
# * | * | * | *
# * | * | * | *
# * | * | * | *
# * | * | * | *
# * | * | * | *
# * | * | * | *
#---------------

usage()
{
cat <<_EOF_


  This game is made for fun, it has simple rules.
  * Do not cheat.
  * You can re-select an element if only it's -
    empty.
  * if even, double digits are given, only the
    first will be considered.
  * When the game is over, it is over.

  Shown down here is a metrics 10x10 in size and
  to play you have to enter the coordinates.

  NOTE: To choose col- g, row- 5, give input - g5


_EOF_
}

time_to_quit()
{
  printf '\n\n%s\n\n' "info: Sadly! You opted to quit!!"
  exit 1
}

plough()
{
  r=0
  printf '\n\n'
  printf '%s' "     a   b   c   d   e   f   g   h   i   j"
  printf '\n   %s\n' "-----------------------------------------"
  for row in $(seq 0 9); do
    printf '%d  ' "$row" 
    for col in $(seq 0 9); do
       ((r+=1))
       is_null_field $r
       printf '%s %s ' "|" "${room[$r]}"
    done
    printf '%s\n' "|" 
    printf '   %s\n' "-----------------------------------------"
  done
  printf '\n\n'
}

is_free_field()
{
  local f=$1
  not_allowed=0
  if [[ "${room[$f]}" = "." ]]; then
    room[$f]=$field
  else
    not_allowed=1
  fi
}

is_null_field()
{
  local e=$1  
    if [[ -z "${room[$e]}" ]];then
      room[$r]="."
    fi
}

get_mines()
{
  n=$(shuf -e 1 2 3 4 5 6 7 8 X -n 1)
  if [[ "$n" != "X" ]]; then
  for s in $(seq 1 $n); do
    for limit in 0 -1 -10 1 10; do
      field=$(shuf -i 0-3 -n 1)
      index=$((i+limit))
      is_free_field $index
    done
  done
  elif [[ "$n" = "X" ]]; then
    g=0
    room[$i]=X
    for j in {42..49}; do
      out="gameover"
      k=${out:$g:1}
      room[$j]=${k^^}
      ((g+=1)) 
    done
  fi
}

get_coordinates()
{
  colm=${opt:0:1}
  ro=${opt:1:1}
  case $colm in
    a ) o=1;;
    b ) o=2;;
    c ) o=3;;
    d ) o=4;;
    e ) o=5;;
    f ) o=6;;
    g ) o=7;;
    h ) o=8;;
    i ) o=9;;
    j ) o=10;;
  esac

  i=$(((ro*10)+o))
  is_free_field $i
  if [[ $not_allowed -eq 1 ]] || [[ ! "$colm" =~ [a-j] ]]; then
    printf '\n%s: %s\n' "warning" "not allowed, the field is already used or invalid column!!!!"
  else
    get_mines
    plough
    if [[ "$n" = "X" ]]; then
      exit 0
    fi
  fi
}

#

trap time_to_quit INT

usage
plough

while true; do
  read -p "info: enter the coordinates: " opt
  get_coordinates
done
