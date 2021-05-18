import os
import pandas as pd

T4_THRESHOLD = 10
SOURCE_FILE = 'patronnamemod.csv'

DIR = os.path.dirname(__file__)
SCRIPT_HEAD = "local NameTable = {\nExperimental = {\n"
SCRIPT_TAIL = "}}\nfunction GetTable()\nreturn NameTable;\nend"


def write_t4_names(data, out):
    for name in data[data['Pledge Amount'] > T4_THRESHOLD].Name:
        out.write(f'"{name}",\n')


def write_default_names(data, out):
    for name in data.Name:
        out.write(f'"{name}",\n')


def main():
    data = pd.read_csv(os.path.join(DIR, SOURCE_FILE), sep=';')  # Read CSV
    data = data[['Name', 'Pledge Amount']]  # Filter relevant data

    # Write new tables.lua file
    with open(os.path.join(DIR, 'tables.lua'), 'w') as out:
        out.write(SCRIPT_HEAD)
        write_t4_names(data, out)
        out.write('}, Default = {')
        write_default_names(data, out)
        out.write(SCRIPT_TAIL)


if __name__ == '__main__':
    main()
