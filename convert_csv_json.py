#!/usr/bin/python

import sys, getopt
import csv
import json

#Get Command Line Arguments
def main():
    read_csv("part.csv", "part.json", True)
    read_csv("database.csv", "database.json", False)

def parse_part(row):
    d = {}
    fields = row.split("::")
    d[fields[0]] = {'parent': fields[1], 'name': fields[2]}
    return d

def parse_database(row):
    d = {}
    fields = row.split("::")
    d[fields[0]] = {'caption': fields[1],
                    'chapter': fields[2],
                    'refs': fields[3],
                    'text': fields[4]}
    return d


#Read CSV File
def read_csv(input_file, output_file, fnc):
    csv_dict = {}
    with open(input_file) as csvfile:
        for row in csvfile.readlines():
            if fnc:
                csv_dict.update(parse_part(row))
            else:
                csv_dict.update(parse_database(row))
        write_json(csv_dict, output_file)

#Convert csv data into json and write it
def write_json(data, json_file):
    with open(json_file, "w") as f:
        f.write(json.dumps(data, sort_keys=False, indent=4, encoding="utf-8",ensure_ascii=False))

if __name__ == "__main__":
   main()
