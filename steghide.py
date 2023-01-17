def decode_string_from_image(image):
    # Open the image file and read the pixel data
    with open(image, 'rb') as f:
        pixels = f.read()

    result = ""
    i = 0
    while i < len(pixels):
        pixel_value = pixels[i]
        if pixel_value % 2 == 0:
            result += chr(pixel_value)
        i += 1

    return result # result is the decoded string

print(decode_string_from_image("C:/Users/HP/OneDrive/Steganography_Project/ImageSource/decodesss.bmp"))
