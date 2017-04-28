import sys
from report_gen import ReportGen
from nmap_data_builder import NMapDataBuilder
from os import walk

report_base_path = sys.argv[1]

RG = ReportGen()

NMAPPER = NMapDataBuilder()

for (dirpath, dirnames, filenames) in walk(report_base_path + '/nmap'):
    for filename in filenames:
        if filename.endswith('.xml'):
            NMAPPER.read_in_file(dirpath + '/' + filename)

for (dirpath, dirnames, filenames) in walk(report_base_path + '/domain'):
    for filename in filenames:
        if filename == 'base-domain-report.txt':
            domain_file = open(dirpath + '/' + filename, 'r')
            domain_data = domain_file.read()
            RG.load_in_json(domain_data, True)

for (dirpath, dirnames, filenames) in walk(report_base_path + '/whois'):
    for filename in filenames:
        if filename.endswith('.json'):
            whois_file = open(dirpath + '/' + filename, 'r')
            whois_data = whois_file.read()
            RG.load_in_json(whois_data, False)

RG.load_in_json(NMAPPER.transform_to_json(), True)

RG.report_generation(report_base_path + '/report/battalionReport.html')
