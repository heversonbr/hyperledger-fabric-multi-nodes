# Hyperledger Fabric notes
---

## MSP (Membership Service Provider)

 The Membership Service Provider (MSP) identifies which Root CAs and Intermediate CAs are trusted to define the members of a trust domain. For instance, an organization, either by listing the identities of their members, or by identifying which CAs are authorized to issue valid identities for their members, or through a combination of both.

The power of an MSP goes beyond simply listing who is a network participant or member of a channel. 
An MSP can identify specific roles an actor might play either within the scope of the organization the MSP represents 
(e.g., admins, or as members of a sub-organization group), 
and sets the basis for defining access privileges in the context of a network and channel (e.g., channel admins, readers, writers).

### Mapping MSPs to Organizations
An organization is a managed group of members. 
This can be something as big as a multinational corporation or a small as a flower shop. 
What’s most important about organizations (or orgs) is that they manage their members under a single MSP. 
Note that this is different from the organization concept defined in an X.509 certificate.

The exclusive relationship between an organization and its MSP makes it sensible to name the MSP after the organization, a convention you’ll find adopted in most policy configurations. For example, organization ORG1 would likely have an MSP called something like ORG1-MSP. In some cases an organization may require multiple membership groups — for example, where channels are used to perform very different business functions between organizations. In these cases it makes sense to have multiple MSPs and name them accordingly, e.g., ORG2-MSP-NATIONAL and ORG2-MSP-GOVERNMENT, reflecting the different membership roots of trust within ORG2 in the NATIONAL sales channel compared to the GOVERNMENT regulatory channel.

### Organizational Units and MSPs
An organization is often divided up into multiple organizational units (OUs), each of which has a certain set of responsibilities. For example, the ORG1 organization might have both ORG1-MANUFACTURING and ORG1-DISTRIBUTION OUs to reflect these separate lines of business. When a CA issues X.509 certificates, the OU field in the certificate specifies the line of business to which the identity belongs.

OUs can be helpful to control the parts of an organization who are considered to be the members of a blockchain network. For example, only identities from the ORG1-MANUFACTURING OU might be able to access a channel, whereas ORG1-DISTRIBUTION cannot.



### Fabric members and their MSP roles  

- **Admin** is one level above a member. An admin can add and remove members from the network and modify member settings. An admin is a user role with administrative privileges for the organization from which the certificate was generated. This role has the ability to add/remove peers, deploy chaincode, create and join channels, etc. on behalf of that organization

- A **peer** can be an endorsing peer or a regular peer which does not endorse but commits transactions.

- A **client** is usually an organization that invokes the smart contracts on the Blockchain network. 


### Idemix CRI (Certificate Revocation Information)
An Idemix CRI (Credential Revocation Information) is similar in purpose to an X509 CRL (Certificate Revocation List): to revoke what was previously issued. However, there are some differences.

In X509, the issuer revokes an end user’s certificate and its ID is included in the CRL. The verifier checks to see if the user’s certificate is in the CRL and if so, returns an authorization failure. The end user is not involved in this revocation process, other than receiving an authorization error from a verifier.

In Idemix, the end user is involved. The issuer revokes an end user’s credential similar to X509 and evidence of this revocation is recorded in the CRI. The CRI is given to the end user (aka “prover”). The end user then generates a proof that their credential has not been revoked according to the CRI. The end user gives this proof to the verifier who verifies the proof according to the CRI. For verification to succeed, the version of the CRI (known as the “epoch”) used by the end user and verifier must be same. The latest CRI can be requested by sending a request to /api/v1/idemix/cri API endpoint.


#### Revoking a certificate or identity
An identity or a certificate can be revoked. Revoking an identity will revoke all the certificates owned by the identity and will also prevent the identity from getting any new certificates. Revoking a certificate will invalidate a single certificate.

In order to revoke a certificate or an identity, the calling identity must have the hf.Revoker and hf.Registrar.Roles attribute. The revoking identity can only revoke a certificate or an identity that has an affiliation that is equal to or prefixed by the revoking identity’s affiliation. 

The following command disables an identity and revokes all of the certificates associated with the identity.

```console
fabric-ca-client revoke -e <enrollment_id> -r <reason>
```
The following are the supported reasons that can be specified using -r flag:

- unspecified
- keycompromise
- cacompromise
- affiliationchange
- superseded
- cessationofoperation
- certificatehold
- removefromcrl
- privilegewithdrawn
- aacompromise



 ---

## Notes on commands

### Enroll bootstrap identity:
The enroll command stores an enrollment certificate (ECert), corresponding private key and CA certificate chain PEM files in the subdirectories of the Fabric CA client’s msp directory. You will see messages indicating where the PEM files are stored.

### Registering new identity:
- The identity performing the register request must be currently enrolled.
- The identity performing the register request must have the proper authority to register the type of the identity that is being registered.
- The registrar (i.e. the invoker) must have the “hf.Registrar.Roles” attribute with a comma-separated list of values where one of the values equals the type of identity being registered. 
For example, if the registrar has the “hf.Registrar.Roles” attribute with a value of “peer”, the registrar can register identities of type peer, but not client!
- The affiliation of the registrar must be equal to or a prefix of the affiliation of the identity being registered. 
For example, an registrar with an affiliation of “a.b” may register an identity with an affiliation of “a.b.c” but may not register an identity with an affiliation of “a.c”. If root affiliation is required for an identity, then the affiliation request should be a dot (”.”) and the registrar must also have root affiliation. If no affiliation is specified in the registration request, the identity being registered will be given the affiliation of the registrar.

When registering an identity, you specify an array of attribute names and values. If the array specifies multiple array elements with the same name, only the last element is currently used. In other words, multi-valued attributes are not currently supported.

### Enrolling an identity:
After successfully registering an identity, one may enroll the peer given the enrollment ID and secret (i.e. the password from the previous section). This is similar to enrolling the bootstrap identity except that we also demonstrate how to use the “-M” option to populate the Hyperledger Fabric MSP (Membership Service Provider) directory structure.

- Example: 
```bash
export FABRIC_CA_CLIENT_HOME=$HOME/fabric-ca/clients/peer1
fabric-ca-client enroll -u http://peer1:peer1pw@localhost:7054 -M $FABRIC_CA_CLIENT_HOME/msp
```

--- 

## Setup files

### ca-server: 
- $HYPERLEDGER_HOME/ca-server/msp/keystore : stores the private key of the ca-server user
- $HYPERLEDGER_HOME/ca-server/ca-cert.pem : ca-certificate (created when the ca server starts)
- $HYPERLEDGER_HOME/ca-server/IssuerPublicKey :  Issuer public key  (created when the ca server starts)
- $HYPERLEDGER_HOME/ca-server/msp/keystore/IssuerSecretKey : Issuer secret key  (created when the ca server starts)
- $HYPERLEDGER_HOME/ca-server/IssuerRevocationPublicKey : Issuer revocation public key  (created when the ca server starts)
- $HYPERLEDGER_HOME/ca-server/msp/keystore/IssuerRevocationPrivateKey : Issuer revocation private key  (created when the ca server starts)
 

### ca-client: 
- $HYPERLEDGER_HOME/ca-client/msp/keystore : stores the private key of the admin user
- $HYPERLEDGER_HOME/ca-client/caserver/admin/msp/signcerts/cert.pem : ca client certificate  (created when we enroll the client)
- $HYPERLEDGER_HOME/ca-client/caserver/admin/msp/cacerts/hostname-port.pem : root CA certificate  (created when we enroll the client)
- $HYPERLEDGER_HOME/ca-client/msp/tlscacerts/tls-hostname-port.pem  : tls root certificate  (created when we enroll the client)
- $HYPERLEDGER_HOME/ca-client/caserver/admin/msp/IssuerPublicKey : Issuer public key (created when we enroll the client)
- $HYPERLEDGER_HOME/ca-client/caserver/admin/msp/IssuerRevocationPublicKey : Issuer revocation public key (created when we enroll the client)

---

## Outputs 

- check directories contents
```bash
ubuntu@hyperledger-admin:~/hyperledger_ws/setup_scripts$ tree ../ca-server/
../ca-server/

ubuntu@hyperledger-admin:~/hyperledger_ws/setup_scripts$ tree ../ca-server/
../ca-server/
```

- ./start_ca_server.sh

```bash
ubuntu@hyperledger-admin:~/hyperledger_ws/setup_scripts$ ./start_ca_server.sh 
checking /home/ubuntu/hyperledger_ws/ca-server/fabric-ca-server-config.yaml
Server YAML not found in /home/ubuntu/hyperledger_ws/ca-server/
Copying /home/ubuntu/hyperledger_ws/config_files/fabric-ca-server-config.yaml to /home/ubuntu/hyperledger_ws/ca-server 
Starting server with: /home/ubuntu/hyperledger_ws/ca-server/fabric-ca-server-config.yaml
Server Started ... Logs available at /home/ubuntu/hyperledger_ws/ca-server/ca-server.log
```

-  cat $FABRIC_CA_SERVER_LOG

```bash
ubuntu@hyperledger-admin:~/hyperledger_ws/setup_scripts$ cat $FABRIC_CA_SERVER_LOG
2019/07/25 15:45:00 [INFO] Configuration file location: /home/ubuntu/hyperledger_ws/ca-server/fabric-ca-server-config.yaml
2019/07/25 15:45:00 [INFO] Starting server in home directory: /home/ubuntu/hyperledger_ws/ca-server
2019/07/25 15:45:00 [WARNING] Unknown provider type: ; metrics disabled
2019/07/25 15:45:00 [INFO] Server Version: 1.4.3
2019/07/25 15:45:00 [INFO] Server Levels: &{Identity:2 Affiliation:1 Certificate:1 Credential:1 RAInfo:1 Nonce:1}
2019/07/25 15:45:00 [WARNING] &{69 The specified CA certificate file /home/ubuntu/hyperledger_ws/ca-server/ca-cert.pem does not exist}
2019/07/25 15:45:00 [INFO] generating key: &{A:ecdsa S:256}
2019/07/25 15:45:00 [INFO] encoded CSR
2019/07/25 15:45:00 [INFO] signed certificate with serial number 356651825161500074746033269569833902994089113482
2019/07/25 15:45:00 [INFO] The CA key and certificate were generated for CA acme-ca
2019/07/25 15:45:00 [INFO] The key was stored by BCCSP provider 'SW'
2019/07/25 15:45:00 [INFO] The certificate is at: /home/ubuntu/hyperledger_ws/ca-server/ca-cert.pem
2019/07/25 15:45:00 [INFO] Initialized sqlite3 database at /home/ubuntu/hyperledger_ws/ca-server/fabric-ca-server.db
2019/07/25 15:45:00 [INFO] The issuer key was successfully stored. The public key is at: /home/ubuntu/hyperledger_ws/ca-server/IssuerPublicKey, secret key is at: /home/ubuntu/hyperledger_ws/ca-server/msp/keystore/IssuerSecretKey
2019/07/25 15:45:00 [INFO] Idemix issuer revocation public and secret keys were generated for CA 'acme-ca'
2019/07/25 15:45:00 [INFO] The revocation key was successfully stored. The public key is at: /home/ubuntu/hyperledger_ws/ca-server/IssuerRevocationPublicKey, private key is at: /home/ubuntu/hyperledger_ws/ca-server/msp/keystore/IssuerRevocationPrivateKey
2019/07/25 15:45:00 [INFO] Home directory for default CA: /home/ubuntu/hyperledger_ws/ca-server
2019/07/25 15:45:00 [INFO] Operation Server Listening on [::]:43271
2019/07/25 15:45:00 [INFO] Listening on http://192.168.1.10:7054
```


```bash
ubuntu@hyperledger-admin:~/hyperledger_ws/setup_scripts$ tree ../ca-server/
../ca-server/
├── ca-cert.pem
├── ca-server.log
├── fabric-ca-server-config.yaml
├── fabric-ca-server.db
├── IssuerPublicKey
├── IssuerRevocationPublicKey
└── msp
    └── keystore
- ├── 96d95313b76c15a95e5a36e34f60b661cd6c93617890a278cb3d0745aa82217a_sk
- ├── IssuerRevocationPrivateKey
- └── IssuerSecretKey

2 directories, 9 files
```

- ./enroll_bootstrap_admin_ca_client.sh

```bash
ubuntu@hyperledger-admin:~/hyperledger_ws/setup_scripts$ ./enroll_bootstrap_admin_ca_client.sh 
my FABRIC_CA_CLIENT_HOME=/home/ubuntu/hyperledger_ws/ca-client/caserver/admin
Client YAML not found in /home/ubuntu/hyperledger_ws/ca-client/caserver/admin/
Copying the /home/ubuntu/hyperledger_ws/config_files/fabric-ca-client-config.yaml to /home/ubuntu/hyperledger_ws/ca-client/caserver/admin
Enrolling ca-client with: /home/ubuntu/hyperledger_ws/ca-client/caserver/admin/fabric-ca-client-config.yaml
2019/07/25 16:05:58 [INFO] generating key: &{A:ecdsa S:256}
2019/07/25 16:05:58 [INFO] encoded CSR
2019/07/25 16:05:58 [INFO] Stored client certificate at /home/ubuntu/hyperledger_ws/ca-client/caserver/admin/msp/signcerts/cert.pem
2019/07/25 16:05:58 [INFO] Stored root CA certificate at /home/ubuntu/hyperledger_ws/ca-client/caserver/admin/msp/cacerts/192-168-1-10-7054.pem
2019/07/25 16:05:58 [INFO] Stored Issuer public key at /home/ubuntu/hyperledger_ws/ca-client/caserver/admin/msp/IssuerPublicKey
2019/07/25 16:05:58 [INFO] Stored Issuer revocation public key at /home/ubuntu/hyperledger_ws/ca-client/caserver/admin/msp/IssuerRevocationPublicKey
```


```bash
ubuntu@hyperledger-admin:~/hyperledger_ws/setup_scripts$ tree ../ca-client/
../ca-client/
└── caserver
    └── admin
- ├── fabric-ca-client-config.yaml
- └── msp
-     ├── cacerts
-     │   └── 192-168-1-10-7054.pem
-     ├── IssuerPublicKey
-     ├── IssuerRevocationPublicKey
-     ├── keystore
-     │   └── 1acc90ebc59ea0c7eab0da01d0aa5e0ae4d6e44546fb458e13a3ad58075bcc45_sk
-     ├── signcerts
-     │   └── cert.pem
-     └── user

7 directories, 6 files
```

- ./register_admins.sh client acme-admin pw acme acme 
```bash
ubuntu@hyperledger-admin:~/hyperledger_ws/setup_scripts$ ./register_admins.sh client acme-admin pw acme acme 
my FABRIC_CA_CLIENT_HOME=/home/ubuntu/hyperledger_ws/ca-client/caserver/admin
total 16
drwxrwxr-x 3 ubuntu ubuntu 4096 Jul 25 16:05 .
drwxrwxr-x 3 ubuntu ubuntu 4096 Jul 25 16:05 ..
-rw-r--r-- 1 ubuntu ubuntu 3281 Jul 25 16:05 fabric-ca-client-config.yaml
drwx------ 6 ubuntu ubuntu 4096 Jul 25 16:05 msp
Registering: acme-admin
2019/07/25 16:07:12 [INFO] Configuration file location: /home/ubuntu/hyperledger_ws/ca-client/caserver/admin/fabric-ca-client-config.yaml
Password: pw
NOTE:  inform the user <acme-admin> and password <pw> to the admin of the organization <acme> (this information is also required to enroll organization's clients)
```

```bash
ubuntu@hyperledger-admin:~/hyperledger_ws/setup_scripts$ tree ../ca-client/
../ca-client/
└── caserver
    └── admin
- ├── fabric-ca-client-config.yaml
- └── msp
-     ├── cacerts
-     │   └── 192-168-1-10-7054.pem
-     ├── IssuerPublicKey
-     ├── IssuerRevocationPublicKey
-     ├── keystore
-     │   └── 1acc90ebc59ea0c7eab0da01d0aa5e0ae4d6e44546fb458e13a3ad58075bcc45_sk
-     ├── signcerts
-     │   └── cert.pem
-     └── user

7 directories, 6 files
```

- ./enroll_admins.sh acme 
```bash
ubuntu@hyperledger-admin:~/hyperledger_ws/setup_scripts$ ./enroll_admins.sh acme 
my FABRIC_CA_CLIENT_HOME=/home/ubuntu/hyperledger_ws/ca-client/acme/admin
/home/ubuntu/hyperledger_ws/ca-client/acme/admin/fabric-ca-client-config.yaml not found in /home/ubuntu/hyperledger_ws/ca-client/acme/admin/
Copy the Client Yaml from /home/ubuntu/hyperledger_ws/config_files/fabric-ca-client-config-acme.yaml 
/home/ubuntu/hyperledger_ws/ca-client/acme/admin/fabric-ca-client-config.yaml
Enrolling: acme-admin
fabric-ca-client enroll -u http://acme-admin:pw@192.168.1.10:7054
2019/07/25 16:08:25 [INFO] generating key: &{A:ecdsa S:256}
2019/07/25 16:08:25 [INFO] encoded CSR
2019/07/25 16:08:25 [INFO] Stored client certificate at /home/ubuntu/hyperledger_ws/ca-client/acme/admin/msp/signcerts/cert.pem
2019/07/25 16:08:25 [INFO] Stored root CA certificate at /home/ubuntu/hyperledger_ws/ca-client/acme/admin/msp/cacerts/192-168-1-10-7054.pem
2019/07/25 16:08:25 [INFO] Stored Issuer public key at /home/ubuntu/hyperledger_ws/ca-client/acme/admin/msp/IssuerPublicKey
2019/07/25 16:08:25 [INFO] Stored Issuer revocation public key at /home/ubuntu/hyperledger_ws/ca-client/acme/admin/msp/IssuerRevocationPublicKey
Creating /home/ubuntu/hyperledger_ws/ca-client/acme/admin/msp/admincerts
====> /home/ubuntu/hyperledger_ws/ca-client/acme/admin/msp/admincerts
copying /home/ubuntu/hyperledger_ws/ca-client/acme/admin/../../caserver/admin/msp/signcerts/*  to /home/ubuntu/hyperledger_ws/ca-client/acme/admin/msp/admincerts
total 12
drwxrwxr-x 2 ubuntu ubuntu 4096 Jul 25 16:08 .
drwx------ 7 ubuntu ubuntu 4096 Jul 25 16:08 ..
-rw-r--r-- 1 ubuntu ubuntu  847 Jul 25 16:08 cert.pem
Created MSP at: /home/ubuntu/hyperledger_ws/ca-client/acme/admin/..
--------------------------------------------------------------
Done MSP setup for org: acme
```

```bash
ubuntu@hyperledger-admin:~/hyperledger_ws/setup_scripts$ tree ../ca-client/
../ca-client/
├── acme
│   ├── admin
│   │   ├── fabric-ca-client-config.yaml
│   │   └── msp
│   │       ├── admincerts
│   │       │   └── cert.pem
│   │       ├── cacerts
│   │       │   └── 192-168-1-10-7054.pem
│   │       ├── IssuerPublicKey
│   │       ├── IssuerRevocationPublicKey
│   │       ├── keystore
│   │       │   └── 1b6be0cb0a170eff73ee12223059f58f99a7004dc13f594eaf5d51a201b2226f_sk
│   │       ├── signcerts
│   │       │   └── cert.pem
│   │       └── user
│   └── msp
│       ├── admincerts
│       │   └── cert.pem
│       ├── cacerts
│       └── keystore
└── caserver
    └── admin
- ├── fabric-ca-client-config.yaml
- └── msp
-     ├── cacerts
-     │   └── 192-168-1-10-7054.pem
-     ├── IssuerPublicKey
-     ├── IssuerRevocationPublicKey
-     ├── keystore
-     │   └── 1acc90ebc59ea0c7eab0da01d0aa5e0ae4d6e44546fb458e13a3ad58075bcc45_sk
-     ├── signcerts
-     │   └── cert.pem
-     └── user

19 directories, 14 files
```

- ./register_admins.sh client budget-admin budget budget 

```bash
ubuntu@hyperledger-admin:~/hyperledger_ws/setup_scripts$ ./register_admins.sh client budget-admin budget budget 
------------------------------------------------------------------------
USAGE: ./register_admin.sh <type> <name> <pass> <affiliation> <organization>
   EX: ./register_admin.sh client acme-admin    pw  acme  acme 
   EX: ./register_admin.sh client acme-admin    pw  acme  acme 
   EX: ./register_admin.sh client orderer-admin pw  orderer  orderer 
------------------------------------------------------------------------
ubuntu@hyperledger-admin:~/hyperledger_ws/setup_scripts$ ./register_admins.sh client budget-admin pw budget budget 
my FABRIC_CA_CLIENT_HOME=/home/ubuntu/hyperledger_ws/ca-client/caserver/admin
total 16
drwxrwxr-x 3 ubuntu ubuntu 4096 Jul 25 16:05 .
drwxrwxr-x 3 ubuntu ubuntu 4096 Jul 25 16:05 ..
-rw-r--r-- 1 ubuntu ubuntu 3281 Jul 25 16:05 fabric-ca-client-config.yaml
drwx------ 6 ubuntu ubuntu 4096 Jul 25 16:05 msp
Registering: budget-admin
2019/07/25 16:10:24 [INFO] Configuration file location: /home/ubuntu/hyperledger_ws/ca-client/caserver/admin/fabric-ca-client-config.yaml
Password: pw
NOTE:  inform the user <budget-admin> and password <pw> to the admin of the organization <budget> (this information is also required to enroll organization`s clients)
```


```bash
ubuntu@hyperledger-admin:~/hyperledger_ws/setup_scripts$ tree ../ca-client/
../ca-client/
├── acme
│   ├── admin
│   │   ├── fabric-ca-client-config.yaml
│   │   └── msp
│   │       ├── admincerts
│   │       │   └── cert.pem
│   │       ├── cacerts
│   │       │   └── 192-168-1-10-7054.pem
│   │       ├── IssuerPublicKey
│   │       ├── IssuerRevocationPublicKey
│   │       ├── keystore
│   │       │   └── 1b6be0cb0a170eff73ee12223059f58f99a7004dc13f594eaf5d51a201b2226f_sk
│   │       ├── signcerts
│   │       │   └── cert.pem
│   │       └── user
│   └── msp
│       ├── admincerts
│       │   └── cert.pem
│       ├── cacerts
│       └── keystore
└── caserver
    └── admin
- ├── fabric-ca-client-config.yaml
- └── msp
-     ├── cacerts
-     │   └── 192-168-1-10-7054.pem
-     ├── IssuerPublicKey
-     ├── IssuerRevocationPublicKey
-     ├── keystore
-     │   └── 1acc90ebc59ea0c7eab0da01d0aa5e0ae4d6e44546fb458e13a3ad58075bcc45_sk
-     ├── signcerts
-     │   └── cert.pem
-     └── user

19 directories, 14 files
```


- ./enroll_admins.sh budget 
```bash
ubuntu@hyperledger-admin:~/hyperledger_ws/setup_scripts$ ./enroll_admins.sh budget 
my FABRIC_CA_CLIENT_HOME=/home/ubuntu/hyperledger_ws/ca-client/budget/admin
/home/ubuntu/hyperledger_ws/ca-client/budget/admin/fabric-ca-client-config.yaml not found in /home/ubuntu/hyperledger_ws/ca-client/budget/admin/
Copy the Client Yaml from /home/ubuntu/hyperledger_ws/config_files/fabric-ca-client-config-budget.yaml 
/home/ubuntu/hyperledger_ws/ca-client/budget/admin/fabric-ca-client-config.yaml
Enrolling: budget-admin
fabric-ca-client enroll -u http://budget-admin:pw@192.168.1.10:7054
2019/07/25 16:10:44 [INFO] generating key: &{A:ecdsa S:256}
2019/07/25 16:10:44 [INFO] encoded CSR
2019/07/25 16:10:44 [INFO] Stored client certificate at /home/ubuntu/hyperledger_ws/ca-client/budget/admin/msp/signcerts/cert.pem
2019/07/25 16:10:44 [INFO] Stored root CA certificate at /home/ubuntu/hyperledger_ws/ca-client/budget/admin/msp/cacerts/192-168-1-10-7054.pem
2019/07/25 16:10:44 [INFO] Stored Issuer public key at /home/ubuntu/hyperledger_ws/ca-client/budget/admin/msp/IssuerPublicKey
2019/07/25 16:10:44 [INFO] Stored Issuer revocation public key at /home/ubuntu/hyperledger_ws/ca-client/budget/admin/msp/IssuerRevocationPublicKey
Creating /home/ubuntu/hyperledger_ws/ca-client/budget/admin/msp/admincerts
====> /home/ubuntu/hyperledger_ws/ca-client/budget/admin/msp/admincerts
copying /home/ubuntu/hyperledger_ws/ca-client/budget/admin/../../caserver/admin/msp/signcerts/*  to /home/ubuntu/hyperledger_ws/ca-client/budget/admin/msp/admincerts
total 12
drwxrwxr-x 2 ubuntu ubuntu 4096 Jul 25 16:10 .
drwx------ 7 ubuntu ubuntu 4096 Jul 25 16:10 ..
-rw-r--r-- 1 ubuntu ubuntu  847 Jul 25 16:10 cert.pem
Created MSP at: /home/ubuntu/hyperledger_ws/ca-client/budget/admin/..
--------------------------------------------------------------
Done MSP setup for org: budget
```


```
ubuntu@hyperledger-admin:~/hyperledger_ws/setup_scripts$ tree ../ca-client/
../ca-client/
├── acme
│   ├── admin
│   │   ├── fabric-ca-client-config.yaml
│   │   └── msp
│   │       ├── admincerts
│   │       │   └── cert.pem
│   │       ├── cacerts
│   │       │   └── 192-168-1-10-7054.pem
│   │       ├── IssuerPublicKey
│   │       ├── IssuerRevocationPublicKey
│   │       ├── keystore
│   │       │   └── 1b6be0cb0a170eff73ee12223059f58f99a7004dc13f594eaf5d51a201b2226f_sk
│   │       ├── signcerts
│   │       │   └── cert.pem
│   │       └── user
│   └── msp
│       ├── admincerts
│       │   └── cert.pem
│       ├── cacerts
│       └── keystore
├── budget
│   ├── admin
│   │   ├── fabric-ca-client-config.yaml
│   │   └── msp
│   │       ├── admincerts
│   │       │   └── cert.pem
│   │       ├── cacerts
│   │       │   └── 192-168-1-10-7054.pem
│   │       ├── IssuerPublicKey
│   │       ├── IssuerRevocationPublicKey
│   │       ├── keystore
│   │       │   └── 4f04e06233fc99bbebd9224066a23f76c315a2fd084d9d03f66763202cfad2f9_sk
│   │       ├── signcerts
│   │       │   └── cert.pem
│   │       └── user
│   └── msp
│       ├── admincerts
│       │   └── cert.pem
│       ├── cacerts
│       └── keystore
└── caserver
    └── admin
- ├── fabric-ca-client-config.yaml
- └── msp
-     ├── cacerts
-     │   └── 192-168-1-10-7054.pem
-     ├── IssuerPublicKey
-     ├── IssuerRevocationPublicKey
-     ├── keystore
-     │   └── 1acc90ebc59ea0c7eab0da01d0aa5e0ae4d6e44546fb458e13a3ad58075bcc45_sk
-     ├── signcerts
-     │   └── cert.pem
-     └── user

31 directories, 22 files
```
