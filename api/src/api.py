from flask import Flask
from flask_swagger_ui import get_swaggerui_blueprint
from flask import request, jsonify
from flask_cors import CORS
from pprint import pprint
from urllib.parse import parse_qs
from os import environ
import ssl
import json
import subprocess

'''
description:
'''


def create_api(tf_cwd):
    api = Flask(__name__)
    CORS(api)

    ### swagger specific ###
    SWAGGER_URL = '/swagger'
    API_URL = '/static/swagger.json'
    SWAGGERUI_BLUEPRINT = get_swaggerui_blueprint(
        SWAGGER_URL,
        API_URL,
        config={
            'app_name': "tf-compute-crud-example"
        }
    )
    api.register_blueprint(SWAGGERUI_BLUEPRINT, url_prefix=SWAGGER_URL)
    ### end swagger specific ###

    @api.route('/', methods=['GET'])
    def home():
        return "<h1>Nothing to see here</h1><p>Nothing to see here</p>"

    @api.route('/api/ec2instance', methods=['POST'])
    def create_ec2instance():
        try:
            print(id)
            cmd = './create_resource.sh'

            process = subprocess.Popen(
                cmd, shell=True, executable='/bin/bash', cwd=tf_cwd, stdout=subprocess.PIPE)
            piped_output = ''
            resource_id_line = ''
            while True:
                line = process.stdout.readline()
                if not line:
                    break
                line_stripped = line.decode('utf8', errors='strict').strip()
                print(line_stripped)
                piped_output += line_stripped + "\n"
                if line_stripped is not None and 'resource_id' in line_stripped:
                    resource_id_line = line_stripped

            process.wait()
            if process.returncode == 0:
                message = {
                    'message': "Resource" + " created succesfully \n",
                    'resource_id': resource_id_line
                }
                return message, 201
            else:
                message = {
                    'message': "Resource" + " created unsuccesfully \n",
                }
                return message, 500

        except Exception:
            return {'message': "Unable to execute Terraform"}, 500

    @api.route('/api/ec2instance/<id>', methods=['DELETE'])
    def delete_ec2instance_by_id(id):
        try:
            print(id)
            cmd = './delete_resource.sh' + ' ' + id

            process = subprocess.Popen(
                cmd, shell=True, executable='/bin/bash', cwd=tf_cwd, stdout=subprocess.PIPE)
            piped_output = ''
            while True:
                line = process.stdout.readline()
                if not line:
                    break
                line_stripped = line.decode('utf8', errors='strict').strip()
                print(line_stripped)
                piped_output += line_stripped + "\n"

            process.wait()
            if process.returncode == 0:
                message = {
                    'message': "Resource" + " deleted succesfully \n",
                }
                return message, 200
            else:
                message = {
                    'message': "Resource" + " deleted unsuccesfully \n",
                }
                return message, 500

        except Exception:
            return {'message': "Unable to execute Terraform"}, 500

    return api


def main():
    tf_cwd = environ['TF_CWD']
    #tf_cwd = '../../tf/'

    api = create_api(tf_cwd)

    # Run the service on the local server it has been deployed to,
    # listening on port 8080.
    api.run(host="0.0.0.0", port=8080)


if __name__ == '__main__':
    main()
