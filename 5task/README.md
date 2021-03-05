# Task 5

AWS tasks.

## Task 5.1

Create EC2 in public VPC subnet and access it.

1. Create EC2 with AWS console. 
2. Add rule in security group to access though ssh port 22 from MyIP.
3. From local terminal access to the instance:
```
chmod 400 path/to/key/my_key.perm
ssh -i path/to/key/my_key.pem ubuntu@<Public IPv4 DNS>
```

## Task 5.2

Create EC2 in private VPC subnet, same VPC net as task 5.1, and access it.

1. Create EC2 with AWS console. Use same keys.
2. Add rule in security group to access though ssh port 22 from the security group of the previous EC2.
3. From local terminal access to the instance:
```
ssh-add path/to/key/my_key.pem
ssh -A ubuntu@<Public IPv4 DNS public subnet instance>
```
From inside first instance:
```
ssh ubuntu@<Private IPv4 addresses second instance>
```

## Task 5.3

Create docker postgres database container and connec though postgres docker client.

1. Create docker postgres database:
```
docker run --name my-postgres -p 5432:5432 -e POSTGRES_PASSWORD=mysecretpassword -d postgres
```
! Publish 5432 port

2. Check docker container gateway IP:
```
docker inspect < container ID >
```
Response example:
```
  "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "fe16b2c75ef231dc6e195570605d16c5ac524803eeff573655a49904e3be5ea4",
                    "EndpointID": "aa2547b56f45cee1b068fe514cd6e17cd57df1d850ea1be1c9dcb77e2f0d6266",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.3",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:11:00:03",
                    "DriverOpts": null
                }
            }
```

3. Access though posgres docker client:
```
docker run -it --rm postgres psql -h 172.17.0.1 -U postgres
```

## Task 5.4

Access RDS using docker postgreSQL image.

docker run -it --rm postgres psql -h < RDS database Endpoint >
