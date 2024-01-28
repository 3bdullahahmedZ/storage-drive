# Simple Storage 

### Environment Variables 
```
AWS_ACCESS_KEY=aws_access_key
AWS_SECRET_ACCESS_KEY=aws_secret_access_key
AWS_URL=aws_url   #default: https://s3.amazonaws.com
AWS_BUCKET=aws_bucket     #default: storage-drive-project 
AWS_REGION=aws_region     #default: us-east-1

STORAGE_DRIVER=storage_driver     #default: local
LOCAL_STORAGE_DRIVER_PATH=local_storage_driver_path     #default: storage/files
```

## Configirations
### Storage Drivers

storage_drivers.yml:
```
production:
  driver: <%= ENV.fetch("STORAGE_DRIVER") { 'local' } %>
  local_storage_path: <%= ENV.fetch("LOCAL_STORAGE_DRIVER_PATH") { 'storage/files' } %>

development:
  driver: <%= ENV.fetch("STORAGE_DRIVER") { 'local' } %>
  local_storage_path: <%= ENV.fetch("LOCAL_STORAGE_DRIVER_PATH") { 'storage/files' } %>
```

STORAGE_DRIVER enum:
```
class StorageDrivers
  LOCAL = 'local'
  AWS = 'aws'
  DATABASE = 'database'
end
```

## AWS
aws.yml
```
production:
  url:  <%= ENV.fetch("AWS_URL") { 'https://s3.amazonaws.com' } %>
  bucket: <%= ENV.fetch("AWS_BUCKET") { 'storage-drive-project' } %>
  access_key: <%= ENV.fetch("AWS_ACCESS_KEY") %>
  secret_access_key: <%= ENV.fetch("AWS_SECRET_ACCESS_KEY") %>
  region: <%= ENV.fetch("AWS_REGION") { 'us-east-1' } %>

development:
  url:  <%= ENV.fetch("AWS_URL") { 'https://s3.amazonaws.com' } %>
  bucket: <%= ENV.fetch("AWS_BUCKET") { 'storage-drive-project' } %>
  access_key: <%= ENV.fetch("AWS_ACCESS_KEY") %>
  secret_access_key: <%= ENV.fetch("AWS_SECRET_ACCESS_KEY") %>
  region: <%= ENV.fetch("AWS_REGION") { 'us-east-1' } %>
``` 

## Authentication
### Generate Token Command
```
rails make:token
```

