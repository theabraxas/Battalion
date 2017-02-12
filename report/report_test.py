"""
Author: toshi
Description: Report Generation code Tester
NOTE: should write a unit test for this.
this may become the stub for unit test
"""

from report_gen import ReportGen

TESTJSON = """{"whois" :
    {
        "registrantName":"Contact Privacy Inc. Customer 124329082",
        "registrantEmail":"",
        "registrantAddress":"96 Mowat Ave Toronto ON M4K 3K1",
        "techName":"Contact Privacy Inc. Customer 124329082",
        "techEmail":"aes8ev4r02ci@contactprivacy.email",
        "techAddress":"96 Mowat Ave Toronto ON M4K 3K1",
        "registrar":"Google Inc.",
        "domainExirationDate":"2017-05-28T00:00:00Z"
    }
}"""

RG = ReportGen()

RG.load_in_json(TESTJSON)

RG.report_generation("testReport.html")
