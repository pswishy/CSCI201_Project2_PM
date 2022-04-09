.data
userInput:  .space 11 # allow user to input string of 1000 characters
string: .asciiz "Invalid"

.text

main: 
      #-----------------------
      li $v0, 8  # gets user input from keyboard
      la $a0, userInput # stores user in put in $a0
      li $a1, 1000 # max lengeth of user input string
      syscall

      # first step count how many chars are in userinput while ignoring blank and space tabs
      li $t0, 0 # t0 = length of user input string
      li $t1, 0 # iterator variable
      li $t2, 0 # exponent tracker
      li $t3, 33 # base for my program
      li $t4, 0 # sum variable
      la $t9, userInput


# where we will count length of userinput
while:  
      lb $s1, 0($t9)
      beq $t1, 1000, exit
      beq $s1, 9, tabOrSpaceCharFound # if the char is a tab we have to give special consideration
      beq $s1, 32, tabOrSpaceCharFound # 32 = space char, 9 = tab char


      # if we get here we are at a char and no more leading whitespace
      # ------------------------
      # we need to pass memory address of string to function
      # memory address stored in $t9

      # bgt $t0, 4, errorMessage # if length t0 greater than 4 print error message exit
      
      # blt $s1, 48, errorMessage # 48 = '0' in ascii. if char < 48 invalid char. print message and exit

      # start logic for valid char. (may have to update bgt t0 4 line)
      


tabOrSpaceCharFound:
      # if it is a tab or space char and len $t0 is 0 then we want to ignore because it is a leading whitespace 
      beq $t0, 0, skip # if t0 equals 0 leading whitespace dont update length of userinput string
      
      # if $t0 is not equal to 0 then tab or space char is a invalid char because it not in our range. 
      j errorMessage

sumNum:


skip:
      addi $t9, $t9, 1 # increment loop address for loop
      addi $t1, $t1, 1 # increment loop break condition
      j while

exit:

      li $v0, 10
      syscall


errorMessage:
#       # print error message
      li $v0, 4
      la $a0, string
      syscall

      j exit

     

