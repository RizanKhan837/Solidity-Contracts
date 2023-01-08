def encodeImage(image, string_to_encode):
    # Convert the image to a list of characters
    image = list(image)

    # Initialize the encoded string and the current index
    encoded_str = ""
    idx = 0

    # Iterate through the string and encode it in the pixel data
    for char in string_to_encode:
        # Convert the character to its ASCII value
        char_val = ord(char)

        # Modify the value of the current pixel to store the encoded character
        pixel_val = ord(image[idx])
        if char_val % 2 == 1:
            pixel_val += 1
        image[idx] = chr(pixel_val)

        # Move to the next pixel
        idx += 1

    # Convert the list back to a string
    image = "".join(image)

    return image

def decodeImage(image):
    # Convert the image to a string
    image = str(image)

    # Initialize the decoded string and the current index
    decoded_str = ""
    idx = 0

    # Iterate through the pixel data and decode the string
    while True:
        # Check the value of the current pixel
        pixel_val = ord(image[idx])
        if pixel_val % 2 == 1:
            decoded_str += "1"
        else:
            decoded_str += "0"

        # Check if we have reached the end of the encoded string
        if len(decoded_str) % 8 == 0:
            break

        # Move to the next pixel
        idx += 1

    # Convert the decoded string to its ASCII equivalent
    decoded_str = chr(int(decoded_str, 2))

    return decoded_str

# Open the image file and read its contents into memory
with open("C:/Users/HP/OneDrive/Steganography_Project/ImageTextCacher/decoded.bmp", "rb") as f:
    image = f.read()

while True:
    # Print the menu options
    print("1. Encode a string in the image")
    print("2. Decode a string from the image")
    print("3. Quit")

    # Get the user's choice
    choice = input("Enter your choice: ")

    if choice == "1":
        # Get the string to encode from the user
        string_to_encode = input("Enter the string to encode: ")

        # Encode the string in the image
        image = encodeImage(image, string_to_encode)
        print("String encoded successfully")
    elif choice == "2":
        # Decode the string from the image
        decoded_str = decodeImage(image)
        print("Decoded string: " + decoded_str)
    elif choice == "3":
        # Quit the program
        break
    else:
        print("Invalid choice")
