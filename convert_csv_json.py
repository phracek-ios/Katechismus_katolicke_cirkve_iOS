#!/usr/bin/python

import sys, getopt
import csv
import json
import io


class Convert2Json(object):
    recap = False
    chapter = 0

    #Get Command Line Arguments
    def run(self):
        self.read_csv("part.csv", "part.json", True)
        self.read_csv("database.csv", "database.json", False)

    def parse_part(self, row):
        fields = row.split("::")
        return {'id': int(fields[0]), 'parent': int(fields[1]), 'name': fields[2]}

    def parse_refs(self, refs):
        if '-' in refs:
            list_refs = []
            for r in refs.split(','):
                if '-' in r:
                    begin, end = r.split('-')
                    list_refs.extend(map(str, range(int(begin), int(end)+1)))
                else:
                    list_refs.append(r)
            return ','.join(list_refs)
        else:
            return refs

    def parse_database(self, row):
        fields = row.split("::")
        if "souhrn" in fields[2].lower():
            self.recap = True
            self.chapter = int(fields[3])
        else:
            if self.chapter != int(fields[3]) or fields[2] != "":
                self.recap = False
        refs = self.parse_refs(fields[4])
        return {'id': int(fields[0]),
                'caption': fields[1],
                'caption_no_html': fields[2],
                'chapter': int(fields[3]),
                'refs': refs,
                'text': fields[5],
                'text_no_html': fields[6],
                'recap': int(self.recap),
                }

    #Read CSV File
    def read_csv(self, input_file, output_file, fnc):
        csv_dict = {}
        if fnc:
            csv_dict['chapters'] = []
        else:
            csv_dict['paragraph'] = []
        with open(input_file, 'r') as csvfile:
            for row in csvfile.readlines():
                if fnc:
                    csv_dict['chapters'].append(self.parse_part(row))
                else:
                    csv_dict['paragraph'].append(self.parse_database(row))
            self.write_json(csv_dict, output_file)


    #Convert csv data into json and write it
    def write_json(self, data, json_file):
        with open(json_file, "w") as f:
            f.write(json.dumps(data, sort_keys=False,
                               indent=4, encoding="utf-8",
                               ensure_ascii=False))


if __name__ == "__main__":
    cj = Convert2Json()
    cj.run()
