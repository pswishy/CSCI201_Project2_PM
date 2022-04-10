.data
userInput:  .space 1001 # allow user to input string of 1000 characters
string: .asciiz "Invalid"
testing: .asciiz "testing"
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
      li $t5, 0 # leading white space counter
      la $t9, userInput


# where we will count length of userinput
while:  
      lb $s1, 0($t9)
      beq $t1, 1000, exit # finished processing all 1000 chars and if after 4 chars all are whitespace we can do check
      bgt $t0, 4, trailingWhiteSpaceCheck # after we get first four chars the only other other valid char is a white space char
      beq $s1, 9, tabOrSpaceCharFound # if the char is a tab we have to give special consideration
      beq $s1, 32, tabOrSpaceCharFound # 32 = space char, 9 = tab char


      # if we get here we are at a char and no more leading whitespace
      # ------------------------

      addi $t0,$t0, 1 # increment length of user string by 1
      addi $t1, $t1, 1 # increment loop
      addi $t9, $t9, 1 # increment loop address for loop
      move $a2, $t9 # will hold memory address of 4th char 
      j while

      # we need to pass memory address of string to function
      # memory address stored in $t9
      # --------------------

      # move $a2, $t9
      # jal calculate
      
LeadingWhiteSpaceCounter:
      addi $t5, $t5, 1 # add 1 to leading whitespace counter
tabOrSpaceCharFound:
      # if it is a tab or space char and len $t0 is 0 then we want to ignore because it is a leading whitespace 
      beq $t0, 0 LeadingWhiteSpaceCounter
      beq $t0, 0, skip # if t0 equals 0 leading whitespace dont update length of userinput string
      
      # if $t0 is not 0 or 4 and then no other char should be checked print error and end
      # j errorMessage
      
trailingWhiteSpaceCheck:
      beq $s1, 9, skip # if the char is a tab we have to give special consideration
      beq $s1, 32, skip # 32 = space char, 9 = tab char
      beq $s1, 0, skip # 0 = null char

      # if after first 4 chars there is any of char go to error and end
      j errorMessage


calculate:

      lb $s2, 0($t9)
      
      # first check all invalid chars
      blt $s2, 48, errorMessage # 48 = '0' in ascii. if char < 48 print error message and exit

      ble $s2, 57, calculateNum # 57 = '9' in ascii. if char <= 57 calculate it

calculateNum:
      # exponent * 


skip:
      addi $t9, $t9, 1 # increment loop address for loop
      addi $t1, $t1, 1 # increment loop break condition
      j while

exit:
      lb $s2, ($t9)

      li $v0, 10
      syscall


errorMessage:
      # print error message
      li $v0, 4
      la $a0, string
      syscall

      j exit

     

