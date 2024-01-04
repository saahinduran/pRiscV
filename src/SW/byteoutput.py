import sys

def format_byte(byte):
    return f'x"{byte:02x}",'

def read_binary_file(input_file, output_file):
    with open(input_file, 'rb') as file:
        binary_data = file.read()

    formatted_bytes = [format_byte(byte) for byte in binary_data]

    with open(output_file, 'w') as output:
        for i in range(0, len(formatted_bytes), 10):
            chunk = formatted_bytes[i:i+10]
            line = ' '.join(chunk)
            output.write(line + '\n')

    print(f"Formatted data has been written to {output_file}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script_name.py input_file output_file")
        sys.exit(1)

    input_filename = sys.argv[1]
    output_filename = sys.argv[2]

    read_binary_file(input_filename, output_filename)
