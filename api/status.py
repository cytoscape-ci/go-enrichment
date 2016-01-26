from flask_restful import Resource


class Status(Resource):

    def get(self):

        status = {
            'serviceName': 'GO Analysis Service',
            'description': 'Perform GO enrichment analysis with Bioconductor',
            'apiVersion': 'v1',
            'buildVersion': '0.1.0'
        }

        return status
