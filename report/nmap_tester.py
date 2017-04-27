"""
Author: toshi
Description: NMap Data Builder code Tester
NOTE: should write a unit test for this.
this may become the stub for unit test
"""

from nmap_data_builder import NMapDataBuilder
from os import walk

NMAPPER = NMapDataBuilder()
hard_path = '/home/toshi/Git/Battalion/scans/scanz'

for (dirpath, dirnames, filenames) in walk(hard_path + '/nmap'):
    for filename in filenames:
        if filename.endswith('.xml'):
            NMAPPER.read_in_file(dirpath + '/' + filename)

INPUT_FILE = '/home/toshi/Git/Battalion/scans/scanz/nmap/john.minyc.net.xml'
NMAPPER.print_to_json()