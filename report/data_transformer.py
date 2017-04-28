"""
Author: toshi
Description: Main class for Data Transformer.  Used to transform scan raw data to a standardized json.

The json output should be as follows:

(produces a 2 column table with metadata)
{
    "key_id_for_table" : {
        "data" : "data"
    }
}

or 

(produces a variable column table for mass data)
{
    "key_id_for_table" : [
        { "data" : "data" },
        { "data2" : "data2" }
    ]
}

"""

from json import JSONDecoder

class DataTransformer(object):
    """ This is the main class for data Transformer
    """
    
    @classmethod
    def __init__(cls):
        """Initializer for Datatransformer
           Numbers in Disguise.
        """
        