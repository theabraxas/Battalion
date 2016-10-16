#!/usr/bin/env python
import sys

domain = sys.argv[1]
filename = sys.argv[2]

def parse_file(filename):
    "Load the file as a record."
    with open(filename) as f:
        return [parse_line(line.strip('\n')) for line in f.readlines()]

def parse_line(line):
    "Parse a line by breaking it apart by spaces."
    parts = line.split()
    if len(parts) != 3:
        return []
    else:
        return parts

def make_a_record_map(records, domain):
    "Given a list of records and a domain, produce a mapping of A records to IP Address."
    result = {}

    for record in records:
        if len(record) == 3 and record[0] == "A" and domain in record[1]:
            result[record[1]] = record[2]
    
    return result

def make_cname_record_map(records, domain):
    "Given a list of records and a domain, produce a mapping of subdomains to domains."
    result = {}

    for record in records:
        if len(record) == 3 and record[0] == "CNAME" and record[2].endswith(domain):
            result[record[1]] = record[2]

    return result

records = parse_file(filename)
a_records = make_a_record_map(records, domain)
cname_records = make_cname_record_map(records, domain)

for subdomain, domain in cname_records.items():
    if domain in a_records:
        print("{} {} {}".format(subdomain, domain, a_records[domain]))

