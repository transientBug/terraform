# transientBug Terraform

Make a file `backend-config`
```
# backend-config
access_token = ""
secret_token = ""
```
then
```
terraform init --backend-config-backend-config
```

You should also `set -x TF_VAR_do_token $DO_TOKEN` to set the DO token.

Finally, do something like

```
terraform plan
```

User data script logging:
```
grep user-data: /var/log/syslog
```
