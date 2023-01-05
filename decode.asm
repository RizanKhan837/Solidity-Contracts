.data

# Declare a buffer to hold the decoded string
string_buf: .space 100

# Declare the file name of the image
image_name: .asciiz "C:/Users/HP/OneDrive/Steganography_Project/ImageSource/sample3.bmp"

# Declare the file descriptor for the image file
image_fd: .word 0

# Declare a buffer to hold the pixel values
pixel_buf: .space 4000

.text

# Open the image file
li $v0, 13 # system call for open()
la $a0, image_name # address of file name
li $a1, 0 # read-only mode
li $a2, 0 # no special options
syscall # open the file and store the file descriptor in $v0
sw $v0, image_fd # store the file descriptor in image_fd

# Read the pixel values from the image file into memory
li $v0, 14 # system call for read()
lw $a0, image_fd # file descriptor of image file
la $a1, pixel_buf # address of buffer to store pixel values
li $a2, 4000 # number of bytes to read (assuming image is 10x10 pixels)
syscall # read the pixel values from the image file

# Decode the text from the pixel values
la $a0, pixel_buf # address of pixel values
la $a1, string_buf # address of string buffer
jal decode # call the decode function

# Close the image file
li $v0, 16 # system call for close()
lw $a0, image_fd # file descriptor of image file
syscall # close the file

# print the decoded string
li $v0, 4
la $a0, string_buf
syscall

# Exit the program
li $v0, 10
syscall

# Decode function
decode:
    # Loop through each pixel of the image
    loop:
        # Load the value of the current pixel into $t0
        lw $t0, 0($a0)
        # Check if the current pixel value is zero (indicating the end of the encoded string)
        beq $t0, $zero, end_loop
        # Shift the pixel value right by one bit to get the next character in the encoded string
        srl $t0, $t0, 1
        # Store the decoded character in the string buffer
        sb $t0, 0($a1)
        # Increment the buffer pointer to store the next character
        addi $a1, $a1, 1
        # Increment the pixel pointer to process the next pixel
        addi $a0, $a0, 4
        # Jump back to the beginning of the loop to process the next pixel
        j loop
    # End of loop
    end_loop:
        # null-terminate the string
        sb $zero, 0($a1)
        # Return from the decode function
        jr $ra
