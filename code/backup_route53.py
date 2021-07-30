import os
import json
import time
from datetime import datetime
import boto3
from botocore.exceptions import ClientError
import route53_utils
import logging

bucket_name = os.environ.get("S3_BUCKET_NAME", None)
aws_region = os.environ.get("REGION", "eu-west-2")
s3 = boto3.client('s3')
route53 = boto3.client('route53')

def get_route53_hosted_zones(next_dns_name=None, next_hosted_zone_id=None):
    if next_dns_name and next_hosted_zone_id:
        response = route53.list_hosted_zones_by_name(DNSName=next_dns_name, HostedZoneId=next_hosted_zone_id)
    else:
        response = route53.list_hosted_zones_by_name()
    zones = response['HostedZones']
    if response['IsTruncated']:
        zones += get_route53_hosted_zones(response['NextDNSName'], response['NextHostedZoneId'])

    private_hosted_zones = list(filter(lambda x: x['Config']['PrivateZone'], zones))
    for zone in private_hosted_zones:
        zone['VPCs'] = route53.get_hosted_zone(Id=zone['Id'])['VPCs']
    return zones


def handle(event, context):
    if bucket_name is None:
        logging.error("S3_BUCKET_NAME env var must be set")
        raise EnvironmentError("S3_BUCKET_NAME env var must be set")
    
    timestamp = time.strftime("%Y-%m-%dT%H:%M:%SZ", datetime.utcnow().utctimetuple())

    hosted_zones = get_route53_hosted_zones()
    s3.put_object(Body=json.dumps(hosted_zones).encode(), Bucket=bucket_name, Key='{}/zones.json'.format(timestamp))

    for zone in hosted_zones:
        zone_records = route53_utils.get_route53_zone_records(zone['Id'])
        s3.put_object(Body=json.dumps(zone_records).encode(), Bucket=bucket_name, Key="{}/{}.json".format(timestamp, zone['Name']))

    health_checks = route53_utils.get_route53_health_checks()
    for health_check in health_checks:
        tags = route53.list_tags_for_resource(ResourceType='healthcheck', ResourceId=health_check['Id'])['ResourceTagSet']['Tags']
        health_check['Tags'] = tags

    s3.put_object(Body=json.dumps(health_checks).encode(), Bucket=bucket_name, Key="{}/Health checks.json".format(timestamp))

    s3.put_object(Body=timestamp.encode(), Bucket=bucket_name, Key="latest_backup_timestamp")

    return "Success: {} zones backed up and {} health checks backed up at {}".format(len(hosted_zones), len(health_checks), timestamp)
