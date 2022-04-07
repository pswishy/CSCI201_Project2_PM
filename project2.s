.data
userInput:  .space 1001 # allow user to input string of 1000 characters

.text

main: 

      #-----------------------
      li $v0, 8  # gets user input from keyboard
      la $a0, userInput # stores user in put in $a0
      li $a1, 1001 # max lengeth of user input string
      syscall