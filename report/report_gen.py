"""
Author: toshi
Description: Main class for Report Generation.abs
"""

from json import JSONDecoder

class ReportGen(object):
    """This is the main class for ReportGen
    """

    @classmethod
    def __init__(cls):
        """Initializer for ReportGen
        """
        cls.filename = ""
        cls.open_file = None
        cls.report_content_json = {}

    @classmethod
    def initialize_file(cls, filename):
        """Opens the file for ReportGeneration

        @filename: name of the output file
        """
        cls.open_file = open(filename, "w")

    @classmethod
    def close_file(cls):
        """Closes the file post ReportGeneration
        """
        cls.open_file.close()

    @classmethod
    def load_in_json(cls, raw_json, is_array):
        """This is a helper method used to deserialize
        JSON objects and transform and load them into
        report_content_json

        @raw_json: string representation of JSON
        """
        decoder = JSONDecoder()
        decoded = decoder.decode(raw_json)

        for key, value in decoded.items():
            table_key = key #the key is the name to pass in
            if is_array:
                tr_table = cls.jsonarray_to_html_table(value)  # this needs to be parsed and transformed into a HTML table
            else:
                tr_table = cls.json_to_html_table(value)
            cls.add_content_json(table_key, tr_table)

    @classmethod
    def jsonarray_to_html_table(cls, json_array):
        """transforms the json array into html table

        @json_dict: dict version of deocded json
        @return: string of the html table
        """

        html_table = '<table class="table table-bordered table-striped"><thead>'
        array_data = ''
        array_header = '<tr>'
        table_keys = set()
        
        for json_item in json_array:
            array_data += '<tr>'
            for key, value in json_item.items():
                if key not in table_keys:
                    table_keys.add(key)
                    array_header += '<th>' + key + '</th>'
                array_data += '<td>' + value + '</td>'
            array_data += '</tr>'

        array_header += '</tr>'
        html_table += array_header + '</thead><tbody>' + array_data + '</tbody></table>'

        return html_table

    @classmethod
    def json_to_html_table(cls, json_dict):
        """transforms the dictionary into html table

        @json_dict: dict version of deocded json
        @return: string of the html table
        """
        html_table = '<table class="table table-bordered table-striped"><tbody>'
        
        for key, value in json_dict.items():
            html_table += '<tr>'
            html_table += '<td class="col-md-6">' + key + '</td>'
            html_table += '<td class="col-md-6">' + value + '</td>'
            html_table += '</tr>'

        html_table += '</tbody></table>'

        return html_table


    @classmethod
    def add_content_json(cls, name, content):
        """This method will add the corresponding
        object into the dictionary which will be used to
        generate the report.  Only names preset are valid.

        @name: naem of key or preset
        @content: raw html content
        """
        cls.report_content_json[name] = content



    @classmethod
    def report_generation(cls, filename):
        """This method will do the heavy lifting of generating reports
        until as such time this is broken down.

        @filename: name of the output file.
        """

        open_file = open(filename, 'w')

        report_content = """<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="bs/css/bootstrap.min.css">
    </head>
    <body>
        <div class="panel panel-default">
            <div class="panel-heading">
                <div class="container">
                    <h1>Battalion Battle Report</h1>
                    <p><i>Key to cyber warfare is information</i></p>
                </div>
                <ul class="nav nav-tabs">
                    <li role="presentation" class="active"><a data-toggle="tab" href="#nav1">Summary</a></li>
                    <li role="presentation"><a data-toggle="tab" href="#nav2">User</a></li>
                    <li role="presentation"><a data-toggle="tab" href="#nav3">Domain</a></li>
                </ul>
            </div>
            <div class="panel-body">
                <div class="tab-content">
                    <div id="nav1" class="tab-pane fade in active">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <b>Summary</b>
                            </div>
                            <div class="panel-body">
                                <ul class="list-group">
                                    <li class="list-group-item"><span class="badge">65</span><a href="#user-scan-result">Total Users Scanned</a></li>
                                    <li class="list-group-item"><span class="badge">14</span><a href="#user-scan-result">Compromised Users</a></li>
                                    <li class="list-group-item"><span class="badge">12</span><a href="#domain-scan-result">Total Domains Scanned</a></li>
                                    <li class="list-group-item"><span class="badge">31</span><a href="#domain-scan-result">DNS Records Found</a></li>
                                    <li class="list-group-item"><span class="badge">32</span><a href="#domain-scan-result">Subdomains Found</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div id="nav2" class="tab-pane fade">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <b>User Scan Results</b>
                            </div>
                            <div class="panel-body">
                                <ul class="list-group">
                                    <li class="list-group-item"><span class="badge">65</span><a href="#user-scan-result">Total Users</a></li>
                                    <li class="list-group-item"><span class="badge">14</span><a href="#user-scan-result">Compromised Users</a></li>
                                    <li class="list-group-item"><span class="badge">45</span><a href="#user-scan-result">LinkedIn Profiles Found</a></li>
                                    <li class="list-group-item"><span class="badge">20</span><a href="#user-scan-result">Facebook Profiles Found</a></li>
                                </ul>
                            </div>
                        </div>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <b>Compromised Emails</b>
                            </div>
                            <div class="panel-body">

                            </div>
                        </div>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <b>LinkedIn</b>
                            </div>
                            <div class="panel-body">

                            </div>
                        </div>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <b>Facebook</b>
                            </div>
                            <div class="panel-body">

                            </div>
                        </div>
                    </div>
                    <div id="nav3" class="tab-pane fade">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <b>Domain Scan Results</b>
                            </div>
                            <div class="panel-body">
                                <ul class="list-group">
                                    <li class="list-group-item"><span class="badge">4</span><a href="#domain-scan-result">Total Domains</a></li>
                                    <li class="list-group-item"><span class="badge">4</span><a href="#domain-scan-result">DNS Records</a></li>
                                    <li class="list-group-item"><span class="badge">4</span><a href="#domain-scan-result">Subdomains</a></li>
                                    <li class="list-group-item"><span class="badge">2</span><a href="#domain-scan-result">External IPs Found</a></li>
                                </ul>
                            </div>
                        </div>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <b>Domain</b>
                            </div>
                            <div class="panel-body">
                                {domainRecords}
                            </div>
                        </div>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <b>WhatWeb</b>
                            </div>
                            <div class="panel-body">

                            </div>
                        </div>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <b>Whois</b>
                            </div>
                            <div class="panel-body">
                                {whois}
                            </div>
                        </div>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <b>NMap</b>
                            </div>
                            <div class="panel-body">
                                {nmap}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script type="text/javascript" src="bs/js/jquery-3.1.1.min.js"></script>
        <script type="text/javascript" src="bs/js/bootstrap.min.js"></script>
    </body>
</html>"""

        open_file.write(report_content.format(**cls.report_content_json))
        open_file.close()
