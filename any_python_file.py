import argparse

parser = argparse.ArgumentParser(
                    prog='ProgramName',
                    description='What the program does',
                    epilog='Text at the bottom of help')

parser.add_argument('filename')

args = parser.parse_args()

with open(args.filename,'r') as f:
    content = f.read()

print(len(content))
