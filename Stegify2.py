import struct

def decode_string_from_image(image):
    # Open the image file and read the pixel data
    with open(image, 'rb') as f:
        pixels = f.read()

    # Initialize variables for decoding
    array_bit = 0
    array_bit_index = 0
    end_string = 0
    end_string_index = 0
    i = 0
    result = ""
    
    # Decode the string from the pixel data
    while array_bit_index < 56:
        pixel_value = pixels[i]
        array_bit = array_bit[array_bit_index]
        pixel_value += 0
        if array_bit == 0:
            i += 4
            array_bit_index += 4
            i += 1
        else:
            pixel_value += 1
            pixels[i] = pixel_value
            i += 4
            array_bit_index += 4
            i += 1
    while end_string_index < 8:
        pixel_value = pixels[i]
        end_string = end_string[end_string_index]
        pixel_value += 0
        if end_string == 0:
            i += 4
            end_string_index += 4
            i += 1
        else:
            pixel_value += 1
            pixels[i] = pixel_value
            i += 4
            end_string_index += 4
            i += 1

    # Convert the decoded pixel data back into a string
    for j in range(i):
        result += chr(pixels[j])

    return result

# Test the function
print(decode_string_from_image("C:/Users/HP/OneDrive/Steganography_Project/ImageSource/sample.bmp"))
