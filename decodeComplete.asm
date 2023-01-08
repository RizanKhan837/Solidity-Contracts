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

makingFileArray: # Function for making the array of the file image
    # s4 = File descriptor of the image
    # s5 = Address of the array header 
    # s6 = Total size of the image
    # s7 = Address of the pixel array

    addi $sp, $sp, -4 # load the stack with one spot
    sw $ra, 0($sp) # allocate the register $ra

    # Open the image file
    li $v0, 13 # system call for open()
    la $a0, imageOne # address of file name
    li $a1, 0 # read-only mode
    li $a2, 0 # no special options
    syscall # open the file and store the file descriptor in $v0
    move $s4, $v0 # store the file descriptor in $s4

    # Check if the file was successfully opened
    beq $s4, $zero, ERROR_OPEN # if open() returned an error, jump to ERROR_OPEN

    # Read the file header into the array
    li $v0, 14 # system call for read()
    move $a0, $s4 # file descriptor of image file
    la $a1, ($s5) # address of array
    li $a2, 104 # number of bytes to read (size of BMP file header)
    syscall # read the file header into the array

    # Check if the file header was successfully read
    beq $v0, $zero, ERROR_READ # if read() returned an error, jump to ERROR_READ

    # Read the pixel data into the array
    li $v0, 14 # system call for read()
    move $a0, $s4 # file descriptor of image file
    la $a1, arrayBit # address of array
    move $a2, $s6 # number of bytes to read (size of BMP file pixel data)
    syscall # read the pixel data into the array

    # Check if the pixel data was successfully read
    beq $v0, $zero, ERROR_READ # if read() returned an error, jump to ERROR_READ

    # Close the image file
    li $v0, 16 # system call for close()
    move $a0, $s4 # file descriptor of image file
    syscall # close the file

    # Return the size of the image
    move $v0, $s6 # return the total size of the image
    move $v1, $s5 # return the address of the array
    lw $ra, 0($sp) #restore the value of $ra
    addi $sp, $sp, 4 #increment the stack
    jr $ra # Return to caller

exit:
    li $v0, 10
    syscall

ERROR_OPEN:
    li $v0, 4
    la $a0, errorMsgFile
    syscall
    j exit

ERROR_READ:
    li $v0, 4
    la $a0, errorReadFile
    syscall
    j exit



