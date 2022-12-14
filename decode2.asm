.data
    buffer: .space 1000
    arrayBit: .space 4000 # increased the size of the array to hold all pixel values
    imageOne: .asciiz "C:/Users/HP/OneDrive/Steganography_Project/decoded.bmp"
    newLine: .asciiz "\n"
    errorReadFile: .asciiz "Error for reading the file\n"
    errorMsgFile: .asciiz "Error for loading the file descriptor\n"
    endString: .word 0, 0, 1, 0, 1, 1, 1, 1

.text
.globl main
main:
    # s0 = Array of the image bmp
    # s1 = Decoded string
    # s2 = Iteration of the loop
    # s3 = Iteration of the arrayBit[]
    # s4 = Current pixel value
    # s5 = End of loop
    # s6 = Length of the arrayBit[]

    jal makingFileArray # go to the function for making the file array image (header + pixel)
    move $s0, $v0 # saving the total size of the file into $s4
    move $s5, $v1 # saving the file into $s5 (header + pixel)

    # Load the address of the image array into s0
    la $s0, ($s5)

    # Initialize the iteration variables
    li $s2, 0
    li $s3, 0
    li $s5, 4000 # set the end of loop to the size of the arrayBit[]

    jal LOOP_PIXELS
    j exit

    # Start reading the pixel values
    LOOP_PIXELS:
        beq $s2, $s5, END_LOOP # If end of loop, jump to END_LOOP
        lb $s4, 0($s0) # Read current pixel value
        andi $s4, $s4, 1 # Extract least significant bit
        sw $s4, arrayBit($s3) # Save LSB in arrayBit[]
        add $s0, $s0, 4 # Move to next pixel
        add $s2, $s2, 1 # Increment loop iteration
        add $s3, $s3, 4 # Increment arrayBit[] iteration
        j LOOP_PIXELS # Jump back to LOOP_PIXELS

    END_LOOP:
        # Read the length of the arrayBit[]
        la $s1, arrayBit
        lw $s6, 0($s1)

        # Initialize the iteration variables
        li $s2, 0
        li $s3, 0

        # Start decoding the data
        LOOP_DECODE:
            beq $s2, $s6, END_DECODE # If end of arrayBit[], jump to END_DECODE
            lw $t0, arrayBit($s3) # Read current arrayBit[] value
            beq $t0, $0, SKIP_CHAR # If 0, skip current character
            lb $t0, buffer($s2) # Read current buffer value
            addi $t0, $t0, 1 # Increment current buffer value
            sb $t0, buffer($s2) # Save updated buffer value
            SKIP_CHAR:
            add $s2, $s2, 1 # Increment loop iteration
            add $s3, $s3, 4 # Increment arrayBit[] iteration
            j LOOP_DECODE # Jump back to LOOP_DECODE

        END_DECODE:
            # Print the decoded string
            li $v0, 4
            la $a0, buffer
            syscall
            jr $ra # Return to caller

makingFileArray: #######Function for making the array of the file image
	#s4 = File descriptor of the image
	#s5 = Address of the array header 
	#s6 = Total size of the image
	#s7 = Address of the pixel array

	addi $sp, $sp, -4 #load the stack with one spotr
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

	jal openFile #go to function for opening a file
	move $s4, $v0 #move the file discriptor and save it into $s4
		
	la $a0, 14 #size to alloc in $a0
	jal mallocBit #go to the function for malloc
	move $s5, $v0 #Address of header array of the file

	move $a0, $s4 #move fd to $a0
	move $a1, $s5 #move new array alloc to $a1
	li $a2, 14 #load 14 bits into $a2

	jal readFileDescriptor #go to function for read the file descriptor for the header

	#get the total length of the file
    	lwl $s6, 5($s5) #load the word left into $s6
    	lwr $s6, 2($s5) #load the word right into $6

     	move $a0, $s6 #move the size of file to $a0
	jal mallocBit #go to the function for malloc bit
    	move $s7, $v0 #save the value of the array of pixel to $s7
    	

   	move $a0, $s4  #move the file descriptor to $a0
   	jal closeFileDescriptor #go to the function for closing the file descriptor

	jal openFile #go to function for opening a file
	move $s4, $v0 #move the file discriptor and save it into $s4

	move $a0, $s4 #move fd to $a0
	move $a1, $s7 #move new array of the file alloc to $a1
	move $a2, $s6 #load the total size of the file into $a2

	jal readFileDescriptor #go to function for read the file descriptor

   	move $a0, $s4  #move the file descriptor to $a0
   	jal closeFileDescriptor #go to the function for closing the file descriptor

	move $v0, $s6 #move the total size to the return value $v0
	move $v1, $s7 #move the array of the file to the return value $v1

	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the 
	jr $ra #jump back to $ra (main)	
	

mallocBit: ######Function to malloc bit
	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

	li $v0, 9 #system all for alloc
	syscall #exec the cmd
	
	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the 
	jr $ra #jump back to $ra (main)

#################################################################################
##### FUNCTION FOR READING / OPENING / CLOSE FILE
	
closeFileDescriptor: ####### Function to close the file descriptor
	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

	li $v0, 16 #signal to close the file descriptor
	syscall #exec the cmd

	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the 
	jr $ra #jump back to $ra (main)
	
printStringWithNewline: ###### FUNCTION FOR PRINT STRING WITH \n
	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0
	li $v0, 4 #load the signal to print a string
	syscall #exec the instruction

	li $v0, 4 #load the signal to print a string
	la $a0, newLine
	syscall #exec the instruction

	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the 
	jr $ra #jump back to the pc - 1

readFileDescriptor: ####### Function to read the file discriptor
	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

   	li $v0, 14 #signal to read
    	syscall #exec the cmd

    	bltz $v0, errorRead #if $v0 < 0 goto errorRead
        	j readFile #jump to readFile
    	errorRead:
        	la $a0, errorReadFile #load the error string to $a0
        	jal exit #jump to exit the program
   	readFile:
	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the 
	jr $ra #jump back to $ra (main)

openFile: ####### Function to open file
	addi $sp, $sp, -4 #load the stack with one spot
	sw $ra, 0($sp) #allocate the register $ra to the stack $sp at 0

	#li $t0, 1 #init $t0 = 1 (choice 1)
	#li $t1, 2 #init $t1 = 2 (choice 2)

	li $v0, 13 #signal for opening a file
	la $a0, imageOne #load path imageOne into $a0
	j endOpen #jump to endOpen
	
	endOpen:
	li $a1, 0 #flag for only reading (1 is for writing)
	li $a2, 0 #mode
	syscall #exec of the cmd
	
	bltz $v0, errorFileDescriptor # go to function error if fd < 0

	lw $ra, 0($sp) #restore the value of the stack with the register
	addi $sp, $sp, 4 #Desalocate the 
	jr $ra #jump back to $ra (main)	

errorFileDescriptor: ####### FUNCTION FOR ERROR FD
	la $a0, errorMsgFile #load the string into $a0
	jal printStringWithNewline #go to the function for print a string with a new line
	jal exit #go to the function for exit the program

exit: ###### Exit the program
    	li $v0, 10 #Signal for existing the program 
    	syscall #exec cmd
