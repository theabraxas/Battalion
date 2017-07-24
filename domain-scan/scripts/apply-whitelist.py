import json
import sys

if len(sys.argv) < 5:
    print('[Error] Expected arguments:')
    print('Scan results, IP whitelist, selected output file, rejected output file.')
    sys.exit(0)

scanFile = sys.argv[1]
whitelistFile = sys.argv[2]

with open(scanFile) as data:
    scan = json.load(data)

with open(whitelistFile) as data:
    whitelist = [l.strip() for l in data.readlines()]

# Search through every record. Ensure that only targets that
# match the IP whitelist make it through.
selected = []
rejected = []
for record in scan['domainRecords']:
    if record['target'] in whitelist:
        selected.append(record)
    else:
        rejected.append(record)

selectedOut = { 'domainRecords': selected }
rejectedOut = { 'domainRecords': rejected }

with open(sys.argv[3], 'w') as out:
    json.dump(selectedOut, out)

with open(sys.argv[4], 'w') as out:
    json.dump(rejectedOut, out)

