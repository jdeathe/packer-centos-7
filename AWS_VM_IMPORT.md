# Importing an OVA VM Image to an AWS EC2 AMI

## Prerequisites
- [Install](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and [configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) the AWS CLI.
- Follow the guidance in [VM Import/Export Prerequisites](https://docs.aws.amazon.com/vm-import/latest/userguide/vmimport-image-import.html#import-image-prereqs).
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

### Upload an Image

Upload the `vmdk`,`ova` or `raw` format image to the S3 bucket `{{bucket_name}}`.

```
$ aws s3 cp \
  builds/CentOS-7.9.2009-x86_64-Minimal-AMI-en_US.vmdk \
  s3://{{bucket_name}}/CentOS-7.9.2009-x86_64-Minimal-AMI-en_US.vmdk
```

<!-- ### Copy an Image Between Reigional Buckets

```
$ aws s3 cp \
  s3://{{source_bucket_name}}/CentOS-7.9.2009-x86_64-Minimal-AMI-en_US.vmdk \
  s3://{{target_bucket_name}}/CentOS-7.9.2009-x86_64-Minimal-AMI-en_US.vmdk
``` -->

### Import

Import the image from the S3 bucket `{{bucket_name}}`.


This will return some output that includes an ImportTaskId. e.g. `import-ami-08e9c882d14e44b83`.

<!-- ```
$ aws ec2 import-image \
  --region eu-west-1 \
  --cli-input-json '{ "LicenseType": "BYOL", "Description": "jdeathe/CentOS-7.9.2009-x86_64-Minimal-AMI-en_US", "DiskContainers": [ { "Description": "jdeathe/CentOS-7.9.2009-x86_64-Minimal-AMI-en_US", "Format": "vmdk", "UserBucket": { "S3Bucket": "{{bucket_name}}", "S3Key" : "CentOS-7.9.2009-x86_64-Minimal-AMI-en_US.vmdk" } } ]}'
``` -->

```
$ aws ec2 import-image \
  --architecture x86_64 \
  --boot-mode legacy-bios \
  --description "jdeathe/CentOS-7.9.2009-x86_64-Minimal-AMI-en_US" \
  --disk-containers '[ { "Description": "jdeathe/CentOS-7.9.2009-x86_64-Minimal-AMI-en_US", "Format": "vmdk", "UserBucket": { "S3Bucket": "{{bucket_name}}", "S3Key" : "CentOS-7.9.2009-x86_64-Minimal-AMI-en_US.vmdk" } } ]' \
  --license-type BYOL \
  --platform Linux \
  --region eu-west-1
```

Check progress

```
$ aws ec2 describe-import-image-tasks \
  --region eu-west-1 \
  --import-task-ids {{ImportTaskId}}
```

If you need to cancel the import:

```
$ aws ec2 cancel-import-task \
  --import-task-id {{ImportTaskId}}
```

Once complete, identify the `ImageId`.

```
$ aws --output json ec2 describe-images \
  --owners self \
  --region eu-west-1 \
  --filters '[ { "Name": "description", "Values": ["AWS-VMImport service*"] } ]' \
  | grep '"ImageId"' \
  | sed -r -e 's~^(.*"ImageId": ")(ami-[0-9a-zA-Z]+)(",)$~\2~'
```

Create copy of the intermediate image with required name and description values to the target region(s).

```
$ aws ec2 copy-image \
  --source-region eu-west-1 \
  --region eu-west-1 \
  --name "jdeathe/centos-7-x86_64-minimal-en_us-v7.9.0" \
  --description "CentOS-7.9.2009 x86_64 Minimal Base Image - en_US locale" \
  --source-image-id {{ImageId}}
```

### Clean up

Deregister the intermediate image that was created by the import process.

```
$ aws ec2 deregister-image \
  --region eu-west-1 \
  --image-id {{ImageId}}
```

Identify SpanshotId. i.e. With a Description starting "Created by AWS-VMImport service".

```
$ aws --output json ec2 describe-snapshots \
  --region eu-west-1 \
  --owner-ids self \
  --filters '[ { "Name": "description", "Values": ["Created by AWS-VMImport service*"] } ]' \
  | grep '"SnapshotId"' \
  | sed -r -e 's~^(.*"SnapshotId": ")(snap-[0-9a-zA-Z]+)(",)$~\2~'
```

Remove snapshot created by the import process.

```
$ aws ec2 delete-snapshot \
  --region eu-west-1 \
  --snapshot-id {{SnapshotId}}
```

Remove the source image from the S3 bucket.

```
$ aws s3 rm \
  s3://{{bucket_name}}/CentOS-7.9.2009-x86_64-Minimal-AMI-en_US.vmdk
```
