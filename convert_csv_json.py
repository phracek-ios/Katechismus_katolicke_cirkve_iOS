#!/usr/bin/python

import sys, getopt
import csv
import json


#Get Command Line Arguments
def main():
    read_csv("part.csv", "part.json", True)
    read_csv("database.csv", "database.json", False)


def parse_part(row):
    fields = row.split("::")
    return {'id': int(fields[0]), 'parent': int(fields[1]), 'name': fields[2]}


def parse_database(row):
    fields = row.split("::")
    return {'id': int(fields[0]),
            'caption': fields[1],
            'caption_no_html': fields[2],
            'chapter': int(fields[3]),
            'refs': fields[4],
            'text': fields[5],
            'text_no_html': fields[6],
            }


#Read CSV File
def read_csv(input_file, output_file, fnc):
    csv_dict = {}
    if fnc:
        csv_dict['chapters'] = []
    else:
        csv_dict['paragraph'] = []
    with open(input_file) as csvfile:
        for row in csvfile.readlines():
            if fnc:
                csv_dict['chapters'].append(parse_part(row))
            else:
                csv_dict['paragraph'].append(parse_database(row))
        write_json(csv_dict, output_file)


#Convert csv data into json and write it
def write_json(data, json_file):
    with open(json_file, "w") as f:
        f.write(json.dumps(data, sort_keys=False, indent=4, encoding="utf-8",ensure_ascii=False))


if __name__ == "__main__":
   main()
