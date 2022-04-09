.data
userInput:  .space 1001 # allow user to input string of 1000 characters

.text

main: 

      #-----------------------
      li $v0, 8  # gets user input from keyboard
      la $a0, userInput # stores user in put in $a0
      li $a1, 1001 # max lengeth of user input string
      syscall

      # first step count how many chars are in userinput while ignoring blank and space tabs
      li $t0, 0 # t0 = length of user input string
      li $t1, 0 # iterator variable
      la $t9, userInput
# where we will count length of userinput
while:  
      lb $s1, 0($t9)
      beq $t1, 1000, exit



exit:

      li $v0, 10
      sycall