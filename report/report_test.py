"""
Author: toshi
Description: Report Generation code Tester
NOTE: should write a unit test for this.
this may become the stub for unit test
"""

from report_gen import ReportGen

RG = ReportGen()

RG.add_content_json("whois", """<table class="table table-bordered table-striped">
                                    <tbody>
                                        <tr>
                                            <td class="col-md-6">registrantName</td>
                                            <td class="col-md-6">Contact Privacy Inc. Customer 124329082</td>
                                        </tr>
                                        <tr>
                                            <td class="col-md-6">registrantEmail</td>
                                            <td class="col-md-6"></td>
                                        </tr>
                                        <tr>
                                            <td class="col-md-6">registrantAddress</td>
                                            <td class="col-md-6">96 Mowat Ave Toronto ON M4K 3K1</td>
                                        </tr>
                                        <tr>
                                            <td class="col-md-6">techName</td>
                                            <td class="col-md-6">Contact Privacy Inc. Customer 124329082</td>
                                        </tr>
                                        <tr>
                                            <td class="col-md-6">techEmail</td>
                                            <td class="col-md-6">aes8ev4r02ci@contactprivacy.email</td>
                                        </tr>
                                        <tr>
                                            <td class="col-md-6">techAddress</td>
                                            <td class="col-md-6">"96 Mowat Ave Toronto ON M4K 3K1</td>
                                        </tr>
                                        <tr>
                                            <td class="col-md-6">registrar</td>
                                            <td class="col-md-6">Google Inc.</td>
                                        </tr>
                                        <tr>
                                            <td class="col-md-6">domainExirationDate</td>
                                            <td class="col-md-6">2017-05-28T00:00:00Z</td>
                                        </tr>
                                    </tbody>
                                </table>""")

RG.report_generation("testReport.html")
