# Importing an OVA VM Image to an AWS EC2 AMI

## Prerequisites
- [Install](http://docs.aws.amazon.com/cli/latest/userguide/installing.html) and [configure](http://docs.aws.amazon.com/cli/latest/userguide/cli-config-files.html) the AWS CLI.
  ```
  # On OSX
  $ easy_install awscli 
  ```
- Follow the guidance in [VMImportPrerequisites](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/VMImportPrerequisites.html).
- For non-root IAM users you may need to attach the following inline policy to the `vmimport` service role.
  ```
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid": "380",
              "Effect": "Allow",
              "Action": [
                  "iam:CreateRole",
                  "iam:PutRolePolicy"
              ],
              "Resource": [
                  "arn:aws:iam::{{user_account_id}}:role/vmimport"
              ]
          }
      ]
  }
  ```

### Create an Import Bucket

Create S3 bucket named `{{bucket_name}}` in a nearby region for use by the import process. 

*Note:* Buckets are region specific so it's recommended to include a region identifier in the name.

```
$ aws s3 mb \
  s3://{{bucket_name}} \
  --region eu-west-1
```

Upload the ova image to the S3 bucket `{{bucket_name}}`.

```
$ aws s3 cp \
  builds/CentOS-7.4.1708-x86_64-Minimal-AMI-en_US.ova \
  s3://{{bucket_name}}/CentOS-7.4.1708-x86_64-Minimal-AMI-en_US.ova
```

### Import

Import the image from the S3 bucket `{{bucket_name}}`.

```
$ aws ec2 import-image \
  --cli-input-json '{ "LicenseType": "BYOL", "Description": "jdeathe/CentOS-7.4.1708-x86_64-Minimal-AMI-en_US", "DiskContainers": [ { "Description": "jdeathe/CentOS-7.4.1708-x86_64-Minimal-AMI-en_US", "Format": "ova", "UserBucket": { "S3Bucket": "{{bucket_name}}", "S3Key" : "CentOS-7.4.1708-x86_64-Minimal-AMI-en_US.ova" } } ]}'
```

Check progress

```
$ aws ec2 describe-import-image-tasks
```

If you need to cancel the import:

```
$ aws ec2 cancel-import-task \
  --import-task-id {{ImportTaskId}}
```

Once complete, identify the `ImageId`.

```
$ aws ec2 describe-images \
  --owners self \
  --region eu-west-1
```

Create copy of the intermediate image with required name and description values.

```
$ aws ec2 copy-image \
  --source-region eu-west-1 \
  --region eu-west-1 \
  --name "jdeathe/centos-7-x86_64-minimal-cloud-init-en_us-v7.4.0" \
  --description "CentOS-7.4.1708 x86_64 Minimal Cloud-Init Base Image - en_US locale" \
  --source-image-id {{ImageId}}
```

### Clean up

Deregister the intermediate image that was created by the import process.

```
$ aws ec2 deregister-image \
  --image-id {{ImageId}}
```

Identify SpanshotId. i.e. With a Description starting "Created by AWS-VMImport service".

```
$ aws ec2 describe-snapshots \
  --owner-ids self
```

Remove snapshot created by the import process.

```
$ aws ec2 delete-snapshot \
  --snapshot-id {{SnapshotId}}
```

Remove the source OVA image from the S3 bucket.

```
$ aws s3 rm \
  s3://{{bucket_name}}/CentOS-7.4.1708-x86_64-Minimal-AMI-en_US.ova
```
