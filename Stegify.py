import struct

def decode_string_from_bitmap(bitmap_file, length_array_bits, array_bits, end_string):
  # Open the bitmap file in binary mode
  with open(bitmap_file, 'rb') as file:
    # Seek to the first pixel address (56 bits after the start of the file)
    file.seek(56)

    # Initialize variables
    i = 0
    j = 0
    t3 = 1
    decoded_string = ''

    # Iterate through the array of bits
    while i != length_array_bits:
      # Read the value of the first pixel
      t4 = file.read(1)
      # Read the value of the current array bit
      t6 = array_bits[j]
      t4 += bytes([0])

      # If the current array bit is 1, add 1 to the value of the pixel
      if t6 == 1:
        t4 += t3

      # Write the new pixel value back to the file
      file.seek(-1, 1)
      file.write(t4)

      # Move to the next pixel and array bit
      file.seek(4, 1)
      j += 4
      i += 1

    # Initialize variables for adding the end string
    i = 0
    j = 0
    t3 = 1
    t7 = 8

    # Iterate through the end string
    while i != t7:
      # Read the value of the first pixel
      t4 = file.read(1)
      # Read the value of the current end string element
      t6 = end_string[j]
      t4 += 0

      # If the current end string element is 1, add 1 to the value of the pixel
      if t6 == 1:
        t4 += t3

      # Write the new pixel value back to the file
      file.seek(-1, 1)
      file.write(t4)

      # Move to the next pixel and end string element
      file.seek(4, 1)
      j += 4
      i += 1
      
  # Open the bitmap file again, this time in read-only mode
  with open(bitmap_file, 'wb') as file:
    # Seek to the first pixel address (56 bits after the start of the file)
    file.seek(56)

    # Read and decode the string from the pixel values
    while True:
      # Read the next pixel value
      pixel = file.read(1)
      # If the end of the file has been reached, break out of the loop
      if not pixel:
        break
      # Decode the character from the pixel value using struct.unpack
      character = struct.unpack('>B', pixel)[0]
      # If the character is a null byte (ASCII value 0), break out of the loop
      if character == 0:
        break
      # Otherwise, add the character to the decoded string
      decoded_string += chr(character)

  return decoded_string

# Calculate the length of the array of bits, the array of bits, and the end string from the given bitmap image
# with open('C:/Users/HP/OneDrive/Steganography_Project/ImageTextCacher/decoded.bmp', 'rb') as file:
#   # Read the length of the array of bits from the first 4 bytes of the file
#   length_array_bits = struct.unpack('>I', file.read(4))[0]
#   # Initialize the array of bits
#   array_bits = []
#   # Read the array of bits from the next length_array_bits bytes of the file
#   for i in range(length_array_bits):
#     array_bits.append(struct.unpack('>B', file.read(1))[0])
#   # Initialize the end string
#   end_string = []
#   # Read the end string from the next 8 bytes of the file
#   for i in range(8):
#     end_string.append(struct.unpack('>B', file.read(1))[0])

# # Call the decode_string_from_bitmap function with the calculated arguments
# decoded_string = decode_string_from_bitmap('C:/Users/HP/OneDrive/Steganography_Project/ImageTextCacher/decoded.bmp', length_array_bits, array_bits, end_string)

# # Print the decoded string
# print(decoded_string)

# Calculate the length of the array of bits, the array of bits, and the end string from the given bitmap image
with open('C:/Users/HP/OneDrive/Steganography_Project/decoded.bmp', 'rb') as file:
  # Read the length of the array of bits from the first 4 bytes of the file
  length_array_bits = struct.unpack('>I', file.read(4))[0]
  # Initialize the array of bits
  array_bits = []
  
  for i in range(length_array_bits):
    array_bits.append(struct.unpack('>B', file.read(1))[0])
  
  # Initialize the end string
  end_string = []
  # Read the end string from the next 8 bytes of the file
  for i in range(8):
    # Read the next byte from the file
    data = file.read(1)
    # If the end of the file has been reached, break out of the loop
    if not data:
      break
    # Unpack the byte and append it to the end string
    end_string.append(struct.unpack('>B', data)[0])

  
# Call the decode_string_from_bitmap function with the calculated arguments
decoded_string = decode_string_from_bitmap('C:/Users/HP/OneDrive/Steganography_Project/ImageSource/sample.bmp', length_array_bits, array_bits, end_string)

# Print the decoded string
print(decoded_string)


