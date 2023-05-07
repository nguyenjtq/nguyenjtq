 #!/usr/bin/env zsh

# Generates random number, then gives remainder of it divided by 100.
 n=$(( RANDOM % 100 ))

 if [[ $n -eq 42 ]]; then
   echo "Something went wrong"
   >&2 echo "The error was using magic numbers"
   exit 1
 fi

 echo "Everything went according to plan"