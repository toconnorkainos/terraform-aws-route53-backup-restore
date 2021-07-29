# docker-tf

**Info**
------
A simple Docker configuration for running Terraform on any machine from within an AmazonLinux powered Docker container.

**Assumptions**
------
The following environment variables are accessible or directly passed to the `docker-compose` command execution:
```bash
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN
AWS_MFA_EXPIRY
```
## Authentication to AWS cli - quickstart.

Content of: **~/.aws/credentials**
```
[kainos-aws]
aws_access_key_id = <aws_access_key_id>
aws_secret_access_key = <aws_secret_access_key>
```

Content of: **~/.aws/config**
```
[profile kainos-aws]
source_profile = kainos-aws
```

Load aws_helper.sh 
```
source bin/aws_helper.sh
```

set AWS_PROFILE environment variable
```
export AWS_PROFILE=kainos-aws
```

_NOTE: tested on **GNU bash, version 3.2.57(1)-release (x86_64-apple-darwin18)**_ 

Authenticate via MFA & get load temporary credentials
```
Dave:bin alijaffer$ sts
MFA Token Code: 018273
aws sts get-session-token --token-code 018273 --serial-number arn:aws:iam::800868885046:mfa/alij --output text
MFA Succeeded. With great power comes great responsibility...
```

**Usage**
------
```bash
$ docker build -t tf-executor-amzlnx2 .

$ TF_WORKING_DIR=../ docker-compose -f docker-compose.yaml run tf-bash
```

**Output**
------
```bash
========================================
AWS ACCOUNT ALIAS: my-account
LOGGED IN AS: admin@my.domain
MFA EXPIRES AT: 2020-09-11T06:39:12Z
========================================
CWD: /opt/tf-code
CWD CONTENT:
total 8
drwxr-xr-x 10 root root  320 Sep 10 21:45 .
drwxr-xr-x  1 root root 4096 Sep 10 21:47 ..
-rw-r--r--  1 root root   68 Sep 10 21:53 .gitignore
-rw-r--r--  1 root root  594 Sep 10 19:50 README.md
drwxr-xr-x  3 root root   96 Aug 31 07:13 bin
drwxr-xr-x 12 root root  384 Sep 10 18:52 bootstrap
drwxr-xr-x  3 root root   96 Sep 10 21:52 components
drwxr-xr-x  6 root root  192 Sep 10 21:48 docker
drwxr-xr-x  8 root root  256 Sep 10 21:52 etc
drwxr-xr-x  5 root root  160 Sep 10 19:00 modules
drwxr-xr-x  3 root root   96 Aug 31 07:20 plugin-cache
bash-4.2#
```
