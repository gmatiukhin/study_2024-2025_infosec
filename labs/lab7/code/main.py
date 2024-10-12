import argparse

parser = argparse.ArgumentParser(prog="Cipher")
parser.add_argument("--bytefile_a", "-a", required=True)
parser.add_argument("--bytefile_b", "-b", required=True)
parser.add_argument("--out", "-O", required=True)


args = parser.parse_args()


def read_file_bytes(fname):
    with open(fname, "rb") as f:
        return f.read()


a = read_file_bytes(args.bytefile_a)
b = read_file_bytes(args.bytefile_b)

if len(a) != len(b):
    print(f"Lengths of A ({len(a)}) and B ({len(b)}) are not the same.")
    exit(1)

print("A: ", a)
print("B: ", b)

a_int = int.from_bytes(a)
b_int = int.from_bytes(b)

o_int = a_int ^ b_int

o = o_int.to_bytes(len(a))

print("O: ", o)

with open(args.out, "wb") as f:
    f.write(o)
