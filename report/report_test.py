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

TESTJSONARRAY = """{
  "domainRecords": [
    {
      "recordType": "A",
      "domain": "blog.minyc.net",
      "target": "74.207.248.137"
    },
    {
      "recordType": "A",
      "domain": "home.minyc.net",
      "target": "198.105.244.228"
    },
    {
      "recordType": "A",
      "domain": "home.stage.minyc.net",
      "target": "198.105.244.228"
    }
  ]
}"""

RG = ReportGen()

RG.load_in_json(TESTJSON, False)

RG.load_in_json(TESTJSONARRAY, True)

RG.report_generation("testReport.html")
