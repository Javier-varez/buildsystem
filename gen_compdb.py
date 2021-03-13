#!/usr/bin/env python3

""" Creates a compilation database entry for the given command """

import json
import argparse
import os

def generate_db_json(source_file, command):
    """ Generates a single compilation database string from
        all provided files """
    compdb = [
        {
            "arguments": command.split(),
            "directory": os.getcwd(),
            "file": source_file
        }
    ]
    return json.dumps(compdb, indent=4)

def main():
    """ Entrypoint for the program """
    parser = argparse.ArgumentParser()
    parser.add_argument("--file",
                        help='File to build',
                        required=True)
    parser.add_argument("--command",
                        help='command to build',
                        required=True)
    parser.add_argument('--output', nargs='?',
                        help='Output file. Defaults to file.json',
                        default='file.json')
    args = parser.parse_args()

    comp_db = generate_db_json(args.file, args.command)
    with open(args.output, 'w') as output_file:
        output_file.write(comp_db)

if __name__ == '__main__':
    main()
