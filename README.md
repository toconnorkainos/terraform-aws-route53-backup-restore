# Setup Route53 Backup 
Amazon Route53 is a managed DNS web service. Route53 is often a mission critical asset in the organization. 
 
The following tool enables:
 1. Backup of Route53 DNS Records
 2. Backup of Route53 Health checks
 3. Restore capability to both of the above

## Architecture
### Backup data flow
![backup](https://raw.githubusercontent.com/bridgecrewio/terraform-aws-route53-backup-restore/master/images/backup.png)
### Restore data flow
![restore](https://raw.githubusercontent.com/bridgecrewio/terraform-aws-route53-backup-restore/master/images/restore.png)
## Prerequisites:
* Valid access keys at `~/.aws/credentials` with a default profile configured or matching [AWS Environment Variables](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)  
* `Python` ,`Pipenv` & `npm` installed on the host running the tool

## Integrate backup & restore module using terraform
This module can be integrated into an existing terraform framework. To add it, simply add the following module to your 
terraform code:
```
module "route53-backup-restore" {
  source            = "github.com/toconnorkainos/terraform-aws-route53-backup-restore"
  interval          = "120"
  s3_bucket_name = "NameOfAnExistingS3Bucket"
  tags              = {}
}
``` 
Please note that all the above values are the default values, and therefore these specific values can be omitted.

### Deployment parameters:

| Key             | Description                                             | Default value |
|-----------------|---------------------------------------------------------|---------------|
| profile         | AWS profile, from the AWS credentials file, to be used  | default       |
| region          | Region of resources to be deployed                      | us-east-1     |
| interval        | Interval, in minutes, of scheduled backup               | 120 minutes   |
| tags            | Map of tags to be merged into resources                 | {}            |



## Manually triggering route53 backup 
using aws CLI - trigger `backup-route53` lambda.
```bash
aws lambda invoke --function-name backup-route53 --profile ${profile} --region ${region} --output text /dev/stdout
```
## Restoring data from bucket
using aws CLI - trigger `restore-route53` lambda.
```bash
aws lambda invoke --function-name restore-route53 --profile ${profile} --region ${region} --output text /dev/stdout
```
