.data
    #creating output in the case the input is wrong
    Input_isLong: .asciiz "Input is too long."
    emptyInput: .asciiz "Input is empty."
    Input_isInvalid: .asciiz "Invalid base-35 number."
    # creating space for user to input
    Input_askUser: .space 2000
    # storing the first four non-space characters. If the input has less than 4 characters, then the null value will be stored
    users_inputstorage: .space 4
.text

main:

    #aprompting the user to input the string
    li $v0, 8
    la $a0, Input_askUser
    li $a1, 2000
    syscall

    la $a1, Input_askUser
    li $t0, 0                #t0 remains 0 until a valid character is entered. Then, it changes to 1 this distinction is necessary to find out if the input is valid or not

    
loop_findvalue:
    beq $t2, 4, check_if_loop_continues        #this checks if we have gone through all the values. It ends the loop
    addi $t2, $t2, 1                    # incresing value of the loop count as we loop through the string from behind

    addi $t9, $t9, -1                   #increasing the value of the address by 1.In the next loop we look at the 2nd last, then 2nd and 1st chracter
    lb $t3, ($t9)                # loading the value of the byte to $t3

    beq $t3, 10, loop_findvalue      # check if the character is a new line. We will ignore it if it is

    beq $t3, 32, check_forspace        # check if the character is a space. We will ignore it if it is

    beq $t3, 0, loop_findvalue        # check if the character is a null. We will ignore it if it is

    li $a3, 1                # initializing the value as we reach the last valid character

    #characater could be numbers or letters

    #For numbers
    slti $t4, $t3, 58                     #anything below 58 is either a number or invalid
    li $t5, 47

    slt $t5, $t5, $t3
    and $t5, $t5, $t4
    addi $t0, $t3, -48            # t0 stores the actual value of the number
    beq $t5, 1, findvalue

    #For Capital letters
    slti $t4, $t3, 95             #anything below 95 are capital letters or invalid
    li $t5, 64
    slt $t5, $t5, $t3
    and $t5, $t5, $t4
    addi $t0, $t3, -55

    beq $t5, 1, findvalue

    #For small letters
    slti $t4, $t3, 122         #anything below 95 are capital letters or invalid
    li $t5, 96
    slt $t5, $t5, $t3
    and $t5, $t5, $t4

    addi $t0, $t3, -87
    bne $t5, 1, Input_isInvalidlabel
    j findvalue


    #when we find a character that is not space, null or newline after the first we store the first four characters we need to analyse, this label is executed. It prints "Input is too long." and ends the program
    Input_isLonglabel:
    li $v0, 4
    la $a0, Input_isLong
    syscall
    j exit
    #If the string has no characters or if the string has only space in it, then this label executes. It prints "Input is empty." and ends the program
    emptyInputlabel:
    li $v0, 4
    la $a0, emptyInput
    syscall
    j exit
    #When we check if the character is a number or a letter, this label will execute if we find an invalid character.It prints ""Invalid base-35 number." and ends the program
    Input_isInvalidlabel:
    li $v0, 4
    la $a0, Input_isInvalid
    syscall
    j exit

    # checking if there is a space in between two valid characters. Like "abc" is valid but "ab c" is invalid
    check_forspace:
    beq $a3, 1, Input_isInvalidlabel
    j loop_findvalue            #

    #findvalue will mutliply the value of the string with the exponent and add it to the sum
findvalue:
    mul $t6, $t1, $t0
    add $t8, $t8, $t6
    mul $t1, $t1, 35
    j loop_findvalue

    #The program exits after printing the result
exit:
    li $v0, 10
    syscall
