.data
userInput:  .space 1001 # allow user to input string of 1000 characters
string: .asciiz "Not recognized"
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
      li $t8, 0 # sum variable
      li $t6, 0
      la $t9, userInput
 # where we will count length of userinput
 while:  
       lb $s1, 0($t9)
       # beq $t1, 6, calculateMemoryAdress # finished processing all 1000 chars and if after 4 chars all are whitespace we can do check
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
      beq $s1, 9, trailingWhiteSpaceCounter # if the char is a tab we have to give special consideration
      beq $s1, 32, trailingWhiteSpaceCounter # 32 = space char, 9 = tab char
      beq $s1, 0, skip # 0 = null char
      # if after first 4 chars there is any other char go to error and end
      j errorMessage

trailingWhiteSpaceCounter:

    add $t6, $t6, 1
    j skip
calculateMemoryAdress:

     # sub $t5, $t5, 1
      # we need to pass memory address of string to function
      # memory address stored in $a2
      # --------------------
      # move
      # sub $a3, $a2, 4 # memory address of 4 char str - 5 is now stored in s3 <- correct memory address if no trailing white space
      bgt $t6, 0, trailingWhiteSpaceMemoryAddress

      sub $a3, $a2, 5
      # a3 holds memory address argument
      j findLength

trailingWhiteSpaceMemoryAddress:
    sub $a2, $a2, $t6 # if there is trailing whitespace ned to find correct memory address
    sub $a3, $a2, 5

    j findLength
findLength:
      lb $s6 0($a3)
      beq $s6, 10, exponent # if char equals line feed we know how long the string is so we know what exponent we need to use
      beq $s6, 32, verify # if char is a space character verify if it is apart of input string or trailing white space
      addi $t4, $t4, 1 # add 1 to t4
      addi $a3, $a3, 1
      j findLength

verify:
    beq $t4, 4, exponent # if space is found and legth is already 4 we know it is a trailing whitespace
    
exponent:
      sub $a3, $a3, $t4 # go back to original memory addres now that we know length of string
      sub $t2, $t4, 1 # the first char exponent is length of char - 1
      # lb $s6 0($a3) # load  char into $s6
      jal charcheck
      j print
charcheck:
      lb $s6, 0($a3)
       blt $s6, 48, errorMessage # 48 = '0' in ascii. if char < 48 print error 
       ble $s6, 57, numCalc # 57 = '9' in ascii. if char <= 57 add it to sum

       blt $s6, 65, errorMessage # 65 = 'A' in ascii. if char < 65 print error
       ble $s6, 88, capitalCalc # 88 = 'X' in ascii. if char <= 88 do math

 numCalc:
       sub $s6, $s6, 48 # if number found update val of char to be - 48
       j multiplicationloop

 capitalCalc:

 multiplicationloop:

    beq $t2, 3, exponent3 
      beq $t2, 2, exponent2
      beq $t2, 1, exponent1
      beq $t2, 0, exponent0
     
# s6 is sum variable
# t3 holds base
exponent3:
      # mul $s7, 33, 33
      # mul $s7, 33, $s7
      # mul $s7, $s7, $a3 # multiply a3 char value by 33 * 33 * 33
      mult $t3, $t3
      mflo $s7
      mult $t3, $s7
      mflo $s7
      mult $s6, $s7 # multipy char val * 33^3
      mflo $s7
      add $t8, $t8, $s7
      li $s7, 0
      sub $t2, $t2, 1 # decrement exponent value by 1
      j increment
exponent2:
      mult $t3, $t3 # t3 is register with base value
      mflo $s7 # 33^2
      mult $s7, $s6 # have to multiply char value 
      mflo $s7
      add $t8, $t8, $s7 # add into sum var t8
      li $s7, 0 # set s7 back to zero
      sub $t2, $t2, 1 # decrement exponent value by 1
      j increment
exponent1:
      mult $t3, $s6
      # mul $s7, 33, $a3 # if exponent 1 all i have to do is multiply char value by 33
      mflo $s7
      add $t8, $t8, $s7
      li $s7, 0
      sub $t2, $t2, 1 # decrement exponent value by 1
      j increment
exponent0:
      add $v1, $t8, $s6 # exponent 0 just add char value to sum
      # li $s7, 0
      jr $ra
increment:
      addi $a3, $a3, 1 # increment byte address
      j charcheck
skip:
      addi $t9, $t9, 1 # increment loop address for loop
      addi $t1, $t1, 1 # increment loop break condition
      j while
exit:
      li $v0, 10
      syscall
print:
 
      li $v0, 1
      addi $a0, $v1, 0
      syscall
      j exit
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


 trailingZeroGuardCase:

       add $v1, $v1, $s6
       j print