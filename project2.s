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
      beq $s1, 9, tabOrSpaceCharFound # if the char is a tab we have to give special consideration

tabOrSpaceCharFound:
      # if it is a tab or space char and len $t0 is 0 then we want to ignore because it is a leading whitespace 



exit:

      li $v0, 10
      sycall