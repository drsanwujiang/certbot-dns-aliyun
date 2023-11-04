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

echo "Deleting TXT record"

RECORD_ID=$(aliyun alidns DescribeDomainRecords \
    --DomainName $DOMAIN \
    --RRKeyWord $DOMAIN_RECORD \
    --Type "TXT" \
    --ValueKeyWord $CERTBOT_VALIDATION \
    | grep "RecordId" \
    | grep -Eo "[0-9]+")

aliyun alidns DeleteDomainRecord \
    --RecordId $RECORD_ID \
    > /dev/null