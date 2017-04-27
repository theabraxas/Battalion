"""
Author: toshi
Description: Main class for nmap data builder

NMap Data Builder - it'll take your shitty xml output and transform it to a shitty json blob using a shitty piece of shit code.

Used to process nmap scan data and output a json blob for reporting purpose.

will be of the following form:

{
    "nmap": {[
        {
            "hostname":"dude.com",
            "port":"25",
            "protocol":"tcp",
            "state":"open", 
            "service":"smtp",
            "product":"Postfix"
        }
        ]
    }
}

"""
import xml.etree.ElementTree as ETree
import json

class NMapDataBuilder(object):
    """ This is the main class for NMapDataBuilder
    """

    @classmethod
    def __init__(cls):
        """Initializer for NMapDataBuilder
           gotta have them variables init fam
        """

        cls.current_file = None
        cls.nmap_dict = {}
        
    def read_in_file(cls, filename):
        """reads in file and parse the shit out of it
        """
        cls.current_file = open(filename, 'r')
        current_buffer = cls.current_file.read()
        try:
            current_xml = ETree.fromstring(current_buffer.rstrip())
        except ETree.ParseError:
            return
        cur_host = current_xml.find("host")
        if cur_host is not None:
            hostnames = cur_host.find("hostnames")
            ports = list(cur_host.find("ports").iter("port"))
            for hostname in hostnames:
                name = hostname.get("name")
                host_dict = None
                if name not in cls.nmap_dict:
                    host_dict = {}
                else:
                    host_dict = cls.nmap_dict[name]
                host_dict["address"] = cur_host.find("address").get("addr")
                port_dict = None
                if "ports" not in host_dict:
                    port_dict = {}
                else:
                    port_dict = host_dict["ports"]
                for port in ports:
                    cur_port_id = port.get("portid")
                    cur_port =  None
                    if cur_port_id not in port_dict:
                        cur_port = {}
                        cur_port["protocol"] = port.get("protocol")
                        cur_port["state"] = port.find("state").get("state")
                        if cur_port["state"] == "closed":
                            continue
                        cur_port["service_name"] = port.find("service").get("name")
                        cur_port["service_product"] = port.find("service").get("product")
                        port_dict[cur_port_id] = cur_port
                    else:
                        """in this case we don't need it again"""
                        pass

                host_dict["ports"] = port_dict
                cls.nmap_dict[name] = host_dict
            cls.current_file.close()

    def print_to_json(cls):
        print(cls.transform_to_json())
    
    def transform_to_json(cls):
        """ this should now take the de-duplicated stuff and json it
        """
        data_list = []
        for host in cls.nmap_dict:
            cur_addr = cls.nmap_dict[host]['address']
            for port, values in cls.nmap_dict[host]['ports'].items():
                data_item = {}
                data_item["host"] = host
                data_item["port"] = port
                data_item["address"] = cur_addr
                for name, value in values.items():
                    data_item[name] = value
                data_list.append(data_item)
        return json.dumps({"nmap":data_list})

    def clear_data(cls):
        cls.current_file = None
        cls.nmap_dict = None
