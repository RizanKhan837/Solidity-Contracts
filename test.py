def decode_string_from_image(image):
    with open(image, 'rb') as f:
        pixels = f.read()
    result = ""
    i = 60
    j = 0
    while j < 56:
        pixel_value = pixels[i]
        if (pixel_value & 1) == 0:
            result += '0'
        else:
            result += '1'
        i += 4
        j += 4
    while j < 64:
        pixel_value = pixels[i]
        if (pixel_value & 1) == 0:
            result += '0'
        else:
            result += '1'
        i += 4
        j += 4
    if result[-8:] == "00000000":
        result = result[:-8]
    else:
        character = chr(int(result[-8:], 2))
        result = result[:-8] + character
    return result

print(decode_string_from_image("C:/Users/HP/OneDrive/Steganography_Project/ImageSource/decodesss.bmp"))