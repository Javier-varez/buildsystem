#!/usr/bin/env python3

""" Merges multiple partial compilation databases into a single file """

import json
import argparse

def merge_partial_compilation_databases(file_paths):
    """ Generates a single compilation database string from
        all provided files """
    complete_file = []
    for partial_file_path in file_paths:
        with open(partial_file_path, 'r') as partial_file:
            partial_db = json.load(partial_file)
            complete_file.extend(partial_db)

    return json.dumps(complete_file, indent=4)

def main():
    """ Entrypoint for the program """
    parser = argparse.ArgumentParser()
    parser.add_argument("--files", nargs='+',
                        help='Files to merge into a single compilation database',
                        required=True)
    parser.add_argument('--output', nargs='?',
                        help='Output file. Defaults to compile_commands.json',
                        default='compile_commands.json')
    args = parser.parse_args()

    comp_db = merge_partial_compilation_databases(args.files)
    with open(args.output, 'w') as output_file:
        output_file.write(comp_db)

if __name__ == '__main__':
    main()
