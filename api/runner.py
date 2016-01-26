from flask_restful import Resource
from flask import request
import subprocess
import logging
import json


class Runner(Resource):

    IDS = 'ids'

    def get(self):
        message = {
            "message": "GO enrichment analysis endpoint.  Use POST to perform the analysis."
        }

        return message, 405


    def post(self):

        logging.info("Calling external R process...")

        data = request.read()
        query = json.loads(data)
        if self.IDS in query:
            ids = query[self.IDS]
        else:
            # Invalid query
            invalid_input = {
                "message": "List of Entrez Gene ID is required for this service."
            }
            return invalid_input, 400

        # Write IDs to temp file

        # Call R script as subprocess
        subprocess.call(['R', 'CMD', 'BATCH', './R/run.R'])

        logging.warn("Done! ================")

        result_msg = {"message": 'Done analysis'}
        return result_msg
