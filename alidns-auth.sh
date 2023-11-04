#!/bin/bash

if ! command -v aliyun > /dev/null; then
    echo "Error: Alibaba Cloud CLI not found. Please visit https://github.com/aliyun/aliyun-cli for more information."
    exit 1
fi

DOMAIN=$(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)')
SUB_DOMAIN=$(expr match "$CERTBOT_DOMAIN" '\(.*\)\..*\..*')

if [ -z $DOMAIN ]; then
    DOMAIN=$CERTBOT_DOMAIN
fi

if [ ! -z $SUB_DOMAIN ]; then
    SUB_DOMAIN=".$SUB_DOMAIN"
fi

DOMAIN_RECORD="_acme-challenge$SUB_DOMAIN"

echo "Adding TXT record:"
echo "  Domain: $DOMAIN_RECORD.$DOMAIN"
echo "  Value: $CERTBOT_VALIDATION"

aliyun alidns AddDomainRecord \
    --DomainName $DOMAIN \
    --RR $DOMAIN_RECORD \
    --Type "TXT" \
    --Value $CERTBOT_VALIDATION \
    > /dev/null
    
/bin/sleep 20