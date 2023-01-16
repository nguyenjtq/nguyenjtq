#!/usr/bin/env zsh

# function to write $PWD into file and then echo it.
function marco () {
	pwd > marco.txt
	echo "$PWD"
}

# Store the output of marco into a global variable
pwd=$(marco)

# Function to change back to the directory of the marco.txt file
function polo () {
	if [[ $(ls $pwd | grep "marco.txt") = "marco.txt" ]]
	then
		cd $pwd
	else
		echo "\"marco.txt\" DNE"
	fi
}
