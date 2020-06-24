import datetime
import boto3
from smart_open import open
import json
import sqlite3

bucket = 'party-jams-dot-biz-covid-data'
rawS3folder = 'nytimes-us-county'


def lambda_handler(event, context):
	return {status: 200}
