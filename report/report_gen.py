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
                    <li role="presentation" class="active"><a data-toggle="tab" href="#nav1">Whois</a></li>
                    <li role="presentation"><a data-toggle="tab" href="#nav2">Domain</a></li>
                    <li role="presentation"><a data-toggle="tab" href="#nav3">nmap</a></li>
                    <li role="presentation"><a data-toggle="tab" href="#nav4">WhatWeb</a></li>
                </ul>
            </div>
            <div class="panel-body">
                <div class="tab-content">
                    <div id="nav1" class="tab-pane fade in active">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <b>Whois</b>
                            </div>
                            <div class="panel-body">
                                {whois}
                            </div>
                        </div>
                    </div>
                    <div id="nav2" class="tab-pane fade">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <b>Domain</b>
                            </div>
                            <div class="panel-body">
                                {domainRecords}
                            </div>
                        </div>
                    </div>
                    <div id="nav3" class="tab-pane fade">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <b>nmap</b>
                            </div>
                            <div class="panel-body">
                                {nmap}
                            </div>
                        </div>
                    </div>
                    <div id="nav4" class="tab-pane fade">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <b>WhatWeb</b>
                            </div>
                            <div class="panel-body">
                                Coming Soon!
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
