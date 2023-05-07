#!/usr/bin/env zsh

scriptPath="/Users/james.nguyen/nguyenjtq/Development/Lecture 2 Exercises/randomGenerator.sh"

i=0

## Script below works, but want to make it simpler ##
# while :
# do
#     val=$(bash $scriptPath)
#     if [[ $val = "Everything went according to plan" ]]; then
#         (( i++ ))

#     else
#         break
#     fi
# done

while [[ $(bash $scriptPath) = "Everything went according to plan" ]]
do
    (( i++ ))
    >&1 yoooo.txt
done

echo $i