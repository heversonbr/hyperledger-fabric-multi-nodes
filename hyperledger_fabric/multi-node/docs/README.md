# How to use the scripts.

## Configuration overview

The vagrant file is set up to use vagrant openstack plugin.
The goal of the vagrant file is automatically configure hyperledger hosts with a given configuration 
> **TODO:**
> add a picture explaining to be clear about the config. 

In order to add a new host to the vagrant configuration use the data structure called "cluster" in the Vagrantfile and add a new structure such as:

```bash 
{
    :name => "hl-admin",
    :username => "ubuntu",
    :type => "msp",
    :box => "hbr_ubuntu1604_img",
    :flavor => "j1.medium",
    :netid => "d085327f-2cea-4e14-8784-764ee72b92f4",
    :netadd => "192.168.1.10",
    :privkeyfile => "~/.ssh/openstack_cloudlab_bcom.key"  
}
```

## Main files and directories

- **Vagrantfile**: 

- **install**: contains the scripts that are automatically run during the *vagrant up* execution and create the base configuration for hosts. 

- **setup_scripts**: contains the scripts used to set up the hyperledger environment, after the base configuration at the hosts. 

- **config_files**: contains the configuration templates used to create our hyperledger infra-structure.

## Using the scripts

### Putting all the nodes up 

The very first action is to put all the nodes up with the base configuration by running the *vagrant up* command.

```bash
$ vagrant up
...

$ vagrant status
Current machine states:

hl-admin                  active (openstack)
org1-msp-1                active (openstack)
org2-msp-2                active (openstack)

```

Vagrant creates all the hosts defined at the Vagrantfile. Besides the creation of virtual machines vagrant executes a series of scripts stored in the directory *install*. At the end of the process, Vagrant will create a directory called ~/hyperledger_ws at each host which is the *HYPERLEDGER_HOME* directory. This directory has the following structure:

```bash 
$ bin/
$ config/
$ config_files/
$ config_template
$ fabric-samples/
$ go/
$ install/
$ setup_scripts/
```

### Run the complementary configuration

In our environment we want to emulate a realistic scenario. Therefore, different hosts were created and each host has a distinguish role. 

#### Setting Certification authority

The first step is to set up the certification authority infrastructure. 

Nodes of type *msp* are the hosts in charge of the cerfification authority (CA). Among them, there is a host named *hl-admin* which is the CA administrator. The others are named according to the organization they belong to. For instance, the host *org1-msp-1* is the host *msp-1* from organization *org1*. 

##### CA-root adminstration host

Follow the steps: 

1. log (ssh) into CA administrator host called **hl-admin**

```bash
$ vagrant ssh hl-admin

~/hyperledger_ws/cd setup_scripts/
```


2. start the CA server.

run **$HYPERLEDGER_HOME/setup_scripts/start_ca_server.sh** to start the CA server. 


```bash
~/hyperledger_ws/setup_scripts$ ./start_ca_server.sh

checking /home/ubuntu/hyperledger_ws/ca-server/fabric-ca-server-config.yaml
Server YAML not found in /home/ubuntu/hyperledger_ws/ca-server/
Copying /home/ubuntu/hyperledger_ws/config_files/fabric-ca-server-config.yaml to /home/ubuntu/hyperledger_ws/ca-server 
Starting server with: /home/ubuntu/hyperledger_ws/ca-server/fabric-ca-server-config.yaml
Server Started ... Logs available at /home/ubuntu/hyperledger_ws/ca-server/ca-server.log
---------------------------- /home/ubuntu/hyperledger_ws/ca-server/ca-server.log -----------------------------------
2019/08/26 14:46:22 [INFO] Configuration file location: /home/ubuntu/hyperledger_ws/ca-server/fabric-ca-server-config.yaml
2019/08/26 14:46:22 [INFO] Starting server in home directory: /home/ubuntu/hyperledger_ws/ca-server
2019/08/26 14:46:22 [WARNING] Unknown provider type: ; metrics disabled
2019/08/26 14:46:22 [INFO] Server Version: 1.4.3
2019/08/26 14:46:22 [INFO] Server Levels: &{Identity:2 Affiliation:1 Certificate:1 Credential:1 RAInfo:1 Nonce:1}
2019/08/26 14:46:22 [WARNING] &{69 The specified CA certificate file /home/ubuntu/hyperledger_ws/ca-server/ca-cert.pem does not exist}
2019/08/26 14:46:22 [INFO] generating key: &{A:ecdsa S:256}
2019/08/26 14:46:22 [INFO] encoded CSR
2019/08/26 14:46:22 [INFO] signed certificate with serial number 218894824680373116736324349693129485989627306464
2019/08/26 14:46:22 [INFO] The CA key and certificate were generated for CA acme-ca
2019/08/26 14:46:22 [INFO] The key was stored by BCCSP provider 'SW'
2019/08/26 14:46:22 [INFO] The certificate is at: /home/ubuntu/hyperledger_ws/ca-server/ca-cert.pem
2019/08/26 14:46:22 [INFO] Initialized sqlite3 database at /home/ubuntu/hyperledger_ws/ca-server/fabric-ca-server.db
2019/08/26 14:46:22 [INFO] The issuer key was successfully stored. The public key is at: /home/ubuntu/hyperledger_ws/ca-server/IssuerPublicKey, secret key is at: /home/ubuntu/hyperledger_ws/ca-server/msp/keystore/IssuerSecretKey
2019/08/26 14:46:22 [INFO] Idemix issuer revocation public and secret keys were generated for CA 'acme-ca'
2019/08/26 14:46:22 [INFO] The revocation key was successfully stored. The public key is at: /home/ubuntu/hyperledger_ws/ca-server/IssuerRevocationPublicKey, private key is at: /home/ubuntu/hyperledger_ws/ca-server/msp/keystore/IssuerRevocationPrivateKey
2019/08/26 14:46:22 [INFO] Home directory for default CA: /home/ubuntu/hyperledger_ws/ca-server
2019/08/26 14:46:22 [INFO] Operation Server Listening on [::]:45991
2019/08/26 14:46:22 [INFO] Listening on http://192.168.1.10:7054

```


3. enroll the bootstrap identity to out CA server (the admin client)

```bash
~/hyperledger_ws/setup_scripts$ ./enroll_bootstrap_identity.sh 

my FABRIC_CA_CLIENT_HOME=/home/ubuntu/hyperledger_ws/ca-client/caserver/admin
Client YAML not found in /home/ubuntu/hyperledger_ws/ca-client/caserver/admin/
Copying the /home/ubuntu/hyperledger_ws/config_files/fabric-ca-client-config.yaml to /home/ubuntu/hyperledger_ws/ca-client/caserver/admin
Enrolling ca-client with: /home/ubuntu/hyperledger_ws/ca-client/caserver/admin/fabric-ca-client-config.yaml
2019/08/26 14:48:01 [INFO] generating key: &{A:ecdsa S:256}
2019/08/26 14:48:01 [INFO] encoded CSR
2019/08/26 14:48:01 [INFO] Stored client certificate at /home/ubuntu/hyperledger_ws/ca-client/caserver/admin/msp/signcerts/cert.pem
2019/08/26 14:48:01 [INFO] Stored root CA certificate at /home/ubuntu/hyperledger_ws/ca-client/caserver/admin/msp/cacerts/192-168-1-10-7054.pem
2019/08/26 14:48:01 [INFO] Stored Issuer public key at /home/ubuntu/hyperledger_ws/ca-client/caserver/admin/msp/IssuerPublicKey
2019/08/26 14:48:01 [INFO] Stored Issuer revocation public key at /home/ubuntu/hyperledger_ws/ca-client/caserver/admin/msp/IssuerRevocationPublicKey
Name: admin, Type: client, Affiliation: , Max Enrollments: -1, Attributes: [{Name:hf.Registrar.DelegateRoles Value:* ECert:false} {Name:hf.Revoker Value:1 ECert:false} {Name:hf.IntermediateCA Value:1 ECert:false} {Name:hf.GenCRL Value:1 ECert:false} {Name:hf.Registrar.Attributes Value:* ECert:false} {Name:hf.AffiliationMgr Value:1 ECert:false} {Name:hf.Registrar.Roles Value:* ECert:false}]

```

4. register the organization administrators into the CA server 

In the following we are registering 3 admins:  acme, budget and orderer. 

```bash
~/hyperledger_ws/setup_scripts$  ./register_admin.sh client acme-admin    pw  acme    acme
my FABRIC_CA_CLIENT_HOME=/home/ubuntu/hyperledger_ws/ca-client/caserver/admin
total 16
drwxrwxr-x 3 ubuntu ubuntu 4096 Aug 26 14:48 .
drwxrwxr-x 3 ubuntu ubuntu 4096 Aug 26 14:48 ..
-rw-r--r-- 1 ubuntu ubuntu 3281 Aug 26 14:48 fabric-ca-client-config.yaml
drwx------ 6 ubuntu ubuntu 4096 Aug 26 14:48 msp
Registering: acme-admin
2019/08/26 14:51:01 [INFO] Configuration file location: /home/ubuntu/hyperledger_ws/ca-client/caserver/admin/fabric-ca-client-config.yaml
Password: pw
NOTE:  inform the user <acme-admin> and password <pw> to the admin of the organization <acme> (this information is also required to enroll organization's clients)

```

```bash
~/hyperledger_ws/setup_scripts$ ./register_admin.sh client budget-admin  pw  budget  budget 

my FABRIC_CA_CLIENT_HOME=/home/ubuntu/hyperledger_ws/ca-client/caserver/admin
total 16
drwxrwxr-x 3 ubuntu ubuntu 4096 Aug 26 14:48 .
drwxrwxr-x 3 ubuntu ubuntu 4096 Aug 26 14:48 ..
-rw-r--r-- 1 ubuntu ubuntu 3281 Aug 26 14:48 fabric-ca-client-config.yaml
drwx------ 6 ubuntu ubuntu 4096 Aug 26 14:48 msp
Registering: budget-admin
2019/08/26 14:51:43 [INFO] Configuration file location: /home/ubuntu/hyperledger_ws/ca-client/caserver/admin/fabric-ca-client-config.yaml
Password: pw
NOTE:  inform the user <budget-admin> and password <pw> to the admin of the organization <budget> (this information is also required to enroll organization's clients)

```

5. Enroll organization's adminstrators ca-clients into the server

  
```bash 
~/hyperledger_ws/setup_scripts$./enroll_admin.sh acme 

my FABRIC_CA_CLIENT_HOME=/home/ubuntu/hyperledger_ws/ca-client/acme/admin
/home/ubuntu/hyperledger_ws/ca-client/acme/admin/fabric-ca-client-config.yaml not found in /home/ubuntu/hyperledger_ws/ca-client/acme/admin/
Copy the Client Yaml from /home/ubuntu/hyperledger_ws/config_files/fabric-ca-client-config-acme.yaml 
/home/ubuntu/hyperledger_ws/ca-client/acme/admin/fabric-ca-client-config.yaml
Enrolling: acme-admin
fabric-ca-client enroll -u http://acme-admin:pw@192.168.1.10:7054
2019/08/26 14:58:33 [INFO] generating key: &{A:ecdsa S:256}
2019/08/26 14:58:33 [INFO] encoded CSR
2019/08/26 14:58:33 [INFO] Stored client certificate at /home/ubuntu/hyperledger_ws/ca-client/acme/admin/msp/signcerts/cert.pem
2019/08/26 14:58:33 [INFO] Stored root CA certificate at /home/ubuntu/hyperledger_ws/ca-client/acme/admin/msp/cacerts/192-168-1-10-7054.pem
2019/08/26 14:58:33 [INFO] Stored Issuer public key at /home/ubuntu/hyperledger_ws/ca-client/acme/admin/msp/IssuerPublicKey
2019/08/26 14:58:33 [INFO] Stored Issuer revocation public key at /home/ubuntu/hyperledger_ws/ca-client/acme/admin/msp/IssuerRevocationPublicKey
Creating /home/ubuntu/hyperledger_ws/ca-client/acme/admin/msp/admincerts
====> /home/ubuntu/hyperledger_ws/ca-client/acme/admin/msp/admincerts
copying /home/ubuntu/hyperledger_ws/ca-client/acme/admin/../../caserver/admin/msp/signcerts/*  to /home/ubuntu/hyperledger_ws/ca-client/acme/admin/msp/admincerts
total 12
drwxrwxr-x 2 ubuntu ubuntu 4096 Aug 26 14:58 .
drwx------ 7 ubuntu ubuntu 4096 Aug 26 14:58 ..
-rw-r--r-- 1 ubuntu ubuntu  847 Aug 26 14:58 cert.pem
Created MSP at: /home/ubuntu/hyperledger_ws/ca-client/acme/admin/..
--------------------------------------------------------------
Name: acme-admin, Type: client, Affiliation: acme, Max Enrollments: 2, Attributes: [{Name:hf.Registrar.Roles Value:peer,user,client ECert:false} {Name:hf.AffiliationMgr Value:true ECert:false} {Name:hf.Revoker Value:true ECert:false} {Name:hf.EnrollmentID Value:acme-admin ECert:true} {Name:hf.Type Value:client ECert:true} {Name:hf.Affiliation Value:acme ECert:true}]
Done MSP setup for org: acme

```

```bash 
~/hyperledger_ws/setup_scripts$ ./enroll_admin.sh budget 
my FABRIC_CA_CLIENT_HOME=/home/ubuntu/hyperledger_ws/ca-client/budget/admin
/home/ubuntu/hyperledger_ws/ca-client/budget/admin/fabric-ca-client-config.yaml not found in /home/ubuntu/hyperledger_ws/ca-client/budget/admin/
Copy the Client Yaml from /home/ubuntu/hyperledger_ws/config_files/fabric-ca-client-config-budget.yaml 
/home/ubuntu/hyperledger_ws/ca-client/budget/admin/fabric-ca-client-config.yaml
Enrolling: budget-admin
fabric-ca-client enroll -u http://budget-admin:pw@192.168.1.10:7054
2019/08/26 14:58:41 [INFO] generating key: &{A:ecdsa S:256}
2019/08/26 14:58:41 [INFO] encoded CSR
2019/08/26 14:58:41 [INFO] Stored client certificate at /home/ubuntu/hyperledger_ws/ca-client/budget/admin/msp/signcerts/cert.pem
2019/08/26 14:58:41 [INFO] Stored root CA certificate at /home/ubuntu/hyperledger_ws/ca-client/budget/admin/msp/cacerts/192-168-1-10-7054.pem
2019/08/26 14:58:41 [INFO] Stored Issuer public key at /home/ubuntu/hyperledger_ws/ca-client/budget/admin/msp/IssuerPublicKey
2019/08/26 14:58:41 [INFO] Stored Issuer revocation public key at /home/ubuntu/hyperledger_ws/ca-client/budget/admin/msp/IssuerRevocationPublicKey
Creating /home/ubuntu/hyperledger_ws/ca-client/budget/admin/msp/admincerts
====> /home/ubuntu/hyperledger_ws/ca-client/budget/admin/msp/admincerts
copying /home/ubuntu/hyperledger_ws/ca-client/budget/admin/../../caserver/admin/msp/signcerts/*  to /home/ubuntu/hyperledger_ws/ca-client/budget/admin/msp/admincerts
total 12
drwxrwxr-x 2 ubuntu ubuntu 4096 Aug 26 14:58 .
drwx------ 7 ubuntu ubuntu 4096 Aug 26 14:58 ..
-rw-r--r-- 1 ubuntu ubuntu  847 Aug 26 14:58 cert.pem
Created MSP at: /home/ubuntu/hyperledger_ws/ca-client/budget/admin/..
--------------------------------------------------------------
Name: budget-admin, Type: client, Affiliation: budget, Max Enrollments: 2, Attributes: [{Name:hf.Revoker Value:true ECert:false} {Name:hf.Registrar.Roles Value:peer,user,client ECert:false} {Name:hf.AffiliationMgr Value:true ECert:false} {Name:hf.EnrollmentID Value:budget-admin ECert:true} {Name:hf.Type Value:client ECert:true} {Name:hf.Affiliation Value:budget ECert:true}]
Done MSP setup for org: budget

```


6. Setup admin certificates




7. Check/verify/list CA-server identity list

```bash
~/hyperledger_ws/setup_scripts$ ./list_identity_list.sh 

-----------------------------
FABRIC_CA_CLIENT_CONFIG=fabric-ca-client-config.yaml
FABRIC_VERSION=1.4.0
FABRIC_CONFIG_FILES=/home/ubuntu/hyperledger_ws/config_files
FABRIC_LOGGING_SPEC=INFO
FABRIC_USER=ubuntu
FABRIC_CA_SERVER_HOME=/home/ubuntu/hyperledger_ws/ca-server
FABRIC_CA_SERVER_CONFIG=fabric-ca-server-config.yaml
FABRIC_CFG_PATH=/home/ubuntu/hyperledger_ws/orderer
FABRIC_CA_SERVER_LOG=/home/ubuntu/hyperledger_ws/ca-server/ca-server.log
FABRIC_CA_CLIENT_HOME=/home/ubuntu/hyperledger_ws/ca-client
-----------------------------
./list_identity_list.sh caserver admin
current FABRIC_CA_CLIENT_HOME = /home/ubuntu/hyperledger_ws/ca-client
received : [caserver] and [admin]
now FABRIC_CA_CLIENT_HOME = /home/ubuntu/hyperledger_ws/ca-client/caserver/admin
-----------------------------
Name: admin, Type: client, Affiliation: , Max Enrollments: -1, Attributes: [{Name:hf.Registrar.DelegateRoles Value:* ECert:false} {Name:hf.Revoker Value:1 ECert:false} {Name:hf.IntermediateCA Value:1 ECert:false} {Name:hf.GenCRL Value:1 ECert:false} {Name:hf.Registrar.Attributes Value:* ECert:false} {Name:hf.AffiliationMgr Value:1 ECert:false} {Name:hf.Registrar.Roles Value:* ECert:false}]

Name: acme-admin, Type: client, Affiliation: acme, Max Enrollments: 2, Attributes: [{Name:hf.Registrar.Roles Value:peer,user,client ECert:false} {Name:hf.AffiliationMgr Value:true ECert:false} {Name:hf.Revoker Value:true ECert:false} {Name:hf.EnrollmentID Value:acme-admin ECert:true} {Name:hf.Type Value:client ECert:true} {Name:hf.Affiliation Value:acme ECert:true}]

Name: budget-admin, Type: client, Affiliation: budget, Max Enrollments: 2, Attributes: [{Name:hf.Revoker Value:true ECert:false} {Name:hf.Registrar.Roles Value:peer,user,client ECert:false} {Name:hf.AffiliationMgr Value:true ECert:false} {Name:hf.EnrollmentID Value:budget-admin ECert:true} {Name:hf.Type Value:client ECert:true} {Name:hf.Affiliation Value:budget ECert:true}]
-----------------------------
```

##### CA-organization admin host


1. log (ssh) into CA's administration host called **org1-msp-1**

```bash
$ vagrant ssh org1-msp-1 

~/hyperledger_ws/cd setup_scripts/
```

2. 

```bash

```