.data
    # strings for printing messages
    startProgram:   .asciiz     "The program to decode a hidding sentence into a BMP image has began... "
    menuFilename:   .asciiz     "Enter a number for choosing the image BMP to decode: 1 => img1.bmp, 2 => img2.bmp: "
    imageOne:       .asciiz     "img1.bmp"
    imageTwo:       .asciiz     "img2.bmp"
    endProgram:     .asciiz     "The decode of the image has finished and the result is: "
    errorFileDescriptor: .asciiz "There was an error opening the file. Exiting program."
    errorMessage:   .asciiz     "There was an error decoding the string. Exiting program."

    # buffer for storing the contents of the file
    buffer:         .space      500

    # array for storing the decoded string
    decodedStr:     .space      500

.text
.globl main
main:
    # INPUT FROM THE USER
    # ask the user for the image file to decode
    li $v0, 4 # system call for printing a string
    la $a0, startProgram  # load the string into the argument to enable printing
    syscall # exec system call

    li $v0, 4 # system call for printing a string
    la $a0, menuFilename  # load the string into the argument to enable printing
    syscall # exec system call

    li $v0, 5 # system call for reading an integer
    syscall # exec system call
    move $s0, $v0 # move the integer input into $s0

    # OPEN THE FILE
    jal openFile # jump to the openFile function

    # DECODE THE STRING FROM THE FILE
    li $v0, 14 # system call for decoding
    move $a0, $v0 # file descriptor for the opened file
    la $a1, buffer # address of the buffer to store the file contents
    li $a2, 500 # size of the buffer
    syscall # exec system call

    # CHECK FOR ERRORS
    bltz $v0, error # if the return value is less than zero, go to error

    # DISPLAY THE DECODED STRING ON THE CONSOLE
    li $v0, 4 # system call for printing a string
    la $a0, endProgram  # load the string into the argument to enable printing
    syscall # exec system call

    li $v0, 4 # system call for printing a string
    la $a0, decodedStr # load the decoded string into the argument to enable printing
    syscall # exec system call

    li $v0, 10 # end the program
    syscall # exec system call

openFile:
    # function to open the file
    addi $sp, $sp, -4 # load the stack with one spot
    sw $ra, 0($sp) # allocate the register $ra to the stack $sp at 0

    li $t0, 1 # choice 1
    li $t1, 2 # choice 2

    li $v0, 13 # system call for opening a file
beq $s0, $t1, openImg2 # if $s0 = $t1 go to openImg2
la $a0, imageOne # load path imageOne into $a0
j endOpen # jump to endOpen
openImg2:
la $a0, imageTwo # load path to the file to open
endOpen:
li $a1, 0 # flag for only reading (1 is for writing)
li $a2, 0 # mode
syscall # execute the system call
bltz $v0, errorFileDescriptor # go to function error if fd < 0

lw $ra, 0($sp) # restore the value of the stack with the register
addi $sp, $sp, 4 # deallocate the stack at the position
jr $ra # jump back to $ra (main)
errorFileDescriptor:
# function for error if file descriptor is invalid
la $a0, errorMsgFile # load the error message string into $a0
jal printStringWithNewline # go to the function for printing a string with a new line
jal exit # go to the function for exiting the program

readFile:
# function for reading the file
addi $sp, $sp, -4 # load the stack with one spot
sw $ra, 0($sp) # allocate the register $ra to the stack $sp at 0
li $v0, 14 # system call for reading from file
move $a0, $s0 # file descriptor
la $a1, buffer # address of buffer to store read data
li $a2, 500 # number of bytes to read
syscall # execute the system call

lw $ra, 0($sp) # restore the value of the stack with the register
addi $sp, $sp, 4 # deallocate the stack at the position
jr $ra # jump back to $ra (main)
closeFile:
# function for closing the file
addi $sp, $sp, -4 # load the stack with one spot
sw $ra, 0($sp) # allocate the register $ra to the stack $sp at 0
li $v0, 16 # system call for closing a file
move $a0, $s0 # file descriptor
syscall # execute the system call

lw $ra, 0($sp) # restore the value of the stack with the register
addi $sp, $sp, 4 # deallocate the stack at the position
jr $ra # jump back to $ra (main)
decodeString:# function for decoding the string
addi $sp, $sp, -4 # load the stack with one spot
sw $ra, 0($sp) # allocate the register $ra to the stack $sp at 0
li $t0, 0 #initialize $t0 to 0
li $t1, 0 # initialize $t1 to 0
li $t2, 0 # initialize $t2 to 0
li $t3, 1 # initialize $t3 to 1

DECODE_LOOP:
lb $t2, buffer($t0) # load byte from buffer at position $t0
beq $t2, 0, END_LOOP # if byte is zero, end loop
sb $t2, decodedStr($t1) # store byte in decodedStr at position $t1
addi $t0, $t0, 1 # increment $t0 by 1
addi $t1, $t1, 1 # increment $t1 by 1
j DECODE_LOOP # jump to DECODE_LOOP
END_LOOP:
lw $ra, 0($sp) # restore the value of the stack with the register
addi $sp, $sp, 4 # deallocate the stack at the position
jr $ra # jump back to the return address

#print the decoded string
li $v0, 4 # system call for printing a string
la $a0, decodedStr # load the decoded string into $a0
syscall # execute the system call

#exit the program
li $v0, 10 # system call for exiting the program
syscall # execute the system call