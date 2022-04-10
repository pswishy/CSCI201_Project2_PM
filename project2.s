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
      li $t3, 30 # base for my program
      li $t4, 0 # length counter
      li $t5, 0 # leading white space counter
      li $s6, 0 # sum variable
      li $t6, 1
      la $t9, userInput


# where we will count length of userinput
while:  
      lb $s1, 0($t9)
      beq $t1, 1000, calculateMemoryAdress # finished processing all 1000 chars and if after 4 chars all are whitespace we can do check
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




      
LeadingWhiteSpaceCounter:
     addi $t5, $t5, 1 # add 1 to leading whitespace counter
     j skip

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

      # if after first 4 chars there is any other char go to error and end
      j errorMessage


calculateMemoryAdress:

      # we need to pass memory address of string to function
      # memory address stored in $a2
      # --------------------
      sub $a3, $a2, 5 # memory address of 4 char str - 5 is now stored in s3
      # a3 holds memory address argument


      j findLength

findLength:
      lb $s6 0($a3)
      beq $s6, 10, codetesting # if char equals line feed we know how long the string is so we know what exponent we need to use
      addi $t4, $t4, 1 # add 1 to t4
      addi $a3, $a3, 1
      j findLength
      

exponent:
      sub $a3, $a3, $t4 # go back to original memory addres now that we know length of string
      sub $t2, $t4, 1 # the first char exponent is length of char - 1
      # lb $s6 0($a3) # load  char into $s6
      jal charcheck


charcheck:
      lb $s6, 0($a3)

      blt $s6, 48, errorMessage # 48 = '0' in ascii. if char < 48 print error 
      ble $s6, 57, multiplicationloop # 57 = '9' in ascii. if char <= 57 add it to sum


multiplicationloop:

      beq $t2, 3, exponent3 
      beq $t2, 2, exponent2
      beq $t2, 1, exponent1
      beq $t2, 0, exponent0
     
# s6 is sum variable
exponent3:

exponent2:
      mul 

exponent1:

exponent0:

increment:
      addi $a3, $a3, 1 # increment byte address
      j multiplicationloop
skip:
      addi $t9, $t9, 1 # increment loop address for loop
      addi $t1, $t1, 1 # increment loop break condition
      j while

exit:

      li $v0, 10
      syscall

codetesting:
      li $v0, 4
      la $a0, testing
      syscall
      j exit

errorMessage:
      # print error message
      li $v0, 4
      la $a0, string
      syscall

      j exit

     

