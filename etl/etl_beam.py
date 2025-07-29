import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions
import mysql.connector
import csv
import json
import os
import argparse

def load_config(config_path):
    with open(config_path, 'r') as f:
        config = json.load(f)
    return config['db_config'], config['query']

class ExtractFromMySQL(beam.DoFn):
    def __init__(self, db_config, query):
        self.db_config = db_config
        self.query = query
    def process(self, unused_element):
        conn = mysql.connector.connect(**self.db_config)
        cursor = conn.cursor(dictionary=True)
        cursor.execute(self.query)
        for row in cursor.fetchall():
            yield row
        cursor.close()
        conn.close()

class TransformRow(beam.DoFn):
    def process(self, row):
        for k, v in row.items():
            if v is None:
                row[k] = ''
        yield row

class ToCSV(beam.DoFn):
    def __init__(self, output_path):
        self.output_path = output_path
        self.header_written = False
    def start_bundle(self):
        self.file = open(self.output_path, 'w', newline='')
        self.writer = None
    def process(self, element):
        if self.writer is None:
            self.writer = csv.DictWriter(self.file, fieldnames=element.keys())
            self.writer.writeheader()
        self.writer.writerow(element)
        yield element 
    def finish_bundle(self):
        self.file.close()

def run(config_path, output_path, runner='DirectRunner', project_id=None):
    if not os.path.exists(config_path):
        raise FileNotFoundError(f"Config file not found: {config_path}")

    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    db_config, query = load_config(config_path)

    options_dict = {
        'runner': runner,
        'temp_location': os.path.join(os.path.dirname(output_path), 'temp')
    }

    if project_id and runner == 'DataflowRunner':
        options_dict.update({
            'project': project_id,
            'region': 'us-central1',
            'job_name': 'etl-pipeline-job' 
        })

    options = PipelineOptions(flags=[], **options_dict)

    with beam.Pipeline(options=options) as p:
        (
            p
            | 'Start' >> beam.Create([None])
            | 'Extract' >> beam.ParDo(ExtractFromMySQL(db_config, query))
            | 'Transform' >> beam.ParDo(TransformRow())
            | 'ToCSV' >> beam.ParDo(ToCSV(output_path))
        )

def parse_arguments():
    parser = argparse.ArgumentParser(description='ETL Pipeline com Apache Beam')
    parser.add_argument('--runner', default='DirectRunner', help='Runner a ser usado (DirectRunner ou DataflowRunner)')
    parser.add_argument('--config', required=True, help='Caminho para o arquivo de configuração JSON')
    parser.add_argument('--result', required=True, help='Caminho para o arquivo CSV de saída')
    parser.add_argument('--project', help='ID do projeto GCP (necessário para DataflowRunner)')
    return parser.parse_args()

if __name__ == '__main__':
    args = parse_arguments()

    config_path = args.config
    output_path = args.result
    runner = args.runner
    project_id = args.project

    run(config_path, output_path, runner, project_id)
