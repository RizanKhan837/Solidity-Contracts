.data

# Declare the input string
input_string: .asciiz "Hello, world!"

# Declare the file name of the output image
output_name: .asciiz "C:/Users/HP/OneDrive/Steganography_Project/ImageSource/sample.bmp"

# Declare the file descriptor for the output file
output_fd: .word 0

# Declare a buffer to hold the pixel values of the output image
pixel_buf: .space 4000

.text

# Open the output file
li $v0, 13 # system call for open()
la $a0, output_name # address of file name
li $a1, 1 # write-only mode
li $a2, 0 # no special options
syscall # open the file and store the file descriptor in $v0
sw $v0, output_fd # store the file descriptor in output_fd

# Initialize the pixel buffer
la $a0, pixel_buf # address of pixel buffer
li $t0, 0 # initialize to zero
li $t1, 4000 # number of pixels in the image (assuming 10x10 pixels)
init_loop:
    sw $t0, 0($a0) # store zero in the current pixel
    addi $a0, $a0, 4 # increment the pixel pointer
    addi $t1, $t1, -1 # decrement the loop counter
    bne $t1, $zero, init_loop # loop until all pixels are initialized

# Encode the input string into the pixel values
la $a0, input_string # address of input string
la $a1, pixel_buf # address of pixel buffer
jal encode # call the encode function

# Write the pixel values to the output file
li $v0, 15 # system call for write()
lw $a0, output_fd # file descriptor of output file
la $a1, pixel_buf # address of pixel values
li $a2, 4000 # number of bytes to write (assuming image is 10x10 pixels)
syscall # write the pixel values to the output file

# Close the output file
li $v0, 16 # system call for close()
lw $a0, output_fd # file descriptor of output file
syscall # close the file

# Exit the program
li $v0, 10
syscall

# Encode function
encode:
    # Initialize the pixel pointer and loop counter
    la $a2, pixel_buf # address of pixel buffer
    li $t0, 0 # loop counter
    # Loop through each character in the input string
    loop:
        # Load the current character into $t1
        lbu $t1, 0($a0)
        # Check if the current character is a null terminator (indicating the end of the string)
        beq $t1, $zero, end_loop
        # Load the current pixel value into $t2
        lw $t2, 0($a2)
        # Shift the pixel value left by one bit and OR it with the current character
        sll $t2, $t2, 1
        or $t2, $t2, $t1
        # Store the modified pixel value back in the buffer
        sw $t2, 0($a2)
        # Increment the pixel pointer and loop counter
        addi $a2, $a2, 4
        addi $t0, $t0, 1
        # Check if the loop counter has reached the maximum number of pixels in the image
        blt $t0, 4000, loop
        # Set the next pixel to zero to indicate the end of the encoded string
        sw $zero, 0($a2)
    # End of loop
    end_loop:
        # Return from the encode function
        jr $ra
