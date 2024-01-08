import sys

def read_binary_file(filename):
    try:
        with open(filename, 'rb') as binary_file:
            binary_data = binary_file.read()
            return binary_data
    except FileNotFoundError:
        print(f"Error: File '{filename}' not found.")
        return None
    except Exception as e:
        print(f"Error reading file '{filename}': {e}")
        return None

def write_to_text_file(formatted_data, output_filename):
    try:
        with open(output_filename, 'w') as output_file:
            output_file.write(formatted_data)
            print(f"Formatted data written to '{output_filename}'")
    except Exception as e:
        print(f"Error writing to file '{output_filename}': {e}")

def main():
    if len(sys.argv) != 3:
        print("Usage: python script_name.py <input_binary_file> <output_text_file>")
        return

    input_binary_filename = sys.argv[1]
    output_text_filename = sys.argv[2]

    # Read data from binary file
    binary_data = read_binary_file(input_binary_filename)
    if binary_data is not None:
        # Convert binary data to little-endian hexadecimal format with comma-separated x"<hexdata>" every 4 bytes
        formatted_data = ""
        for i in range(0, len(binary_data), 4):
            hex_str = binary_data[i:i+4][::-1].hex()
            formatted_data += f'x"{hex_str}",\n'

        write_to_text_file(formatted_data, output_text_filename)

if __name__ == "__main__":
    main()
