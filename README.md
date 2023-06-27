# bitbucket_avoid_vpn

### What is this?
Currently, in cloud hosted bitbucket pipelines there is no out-of-the box solution to connect to private services,
that are behind firewall or vpn. ( https://jira.atlassian.com/browse/BCLOUD-12753 )

The only workaround so far is to connect to this services via "proxy", where all needed connections will go through ssh-tunnel.

### Prerequsties
First, you need to ask your devops folks (or IT) to setup special host in your private network such that it can accept ssh-connections from outside. ( AKA bastion host ).
Connection to this host will be made via private key only.

For additional security IT can also make whitelisting this connection for specific hosts that bitbucket uses for their runners ( https://support.atlassian.com/bitbucket-cloud/docs/what-are-the-bitbucket-cloud-ip-addresses-i-should-use-to-configure-my-corporate-firewall/ )


### How to use
Use simple script provided in this repo
```
source ci_utils.sh
make_available -host somehost.private.com -ports 80,443
```


### Example for bitbucket pipeline
Put ci_utils.sh in your repo and later use it in your steps. That's it. :))
```
- step: &end_to_end_tests
    name: Run End to End Tests
    image: cypress/included:9.7.0
    script:
      - source ci_utils
      - make_available -host our.dev.env.in.aws.am -ports 80,443
      - some-work-here-that-need-access-to-dev-env
      - some-other-work-here-that-need-access-to-dev-env
      - ....
````

