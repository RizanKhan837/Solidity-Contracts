def decode_string_from_image(image):
    with open(image, 'rb') as f:
        pixels = f.read()
    
    result = ""
    i = 0
    j = 0
    while j < len(pixels):
        pixel_value = pixels[j]
        if i < 8: 
            if (pixel_value & 1) == 0:
                result += '0'
            else:
                result += '1'
            i += 1
        else:
            if result[-8:] == "00000000":
                break
            else:
                character = chr(int(result[-8:], 2))
                result = result[:-8]
                result += character
                i = 0
        j += 1
    return result

print(decode_string_from_image("C:/Users/HP/OneDrive/Steganography_Project/ImageSource/decodesss.bmp"))
