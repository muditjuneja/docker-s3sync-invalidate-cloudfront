#!/bin/ash

set -e

echo "$(date) - Start"

aws s3 sync /data s3://$BUCKET$BUCKET_PATH $PARAMS

if [[ $AWS_CLOUDFRONT_DISTRIBUTION != '' ]]; then
    aws cloudfront create-invalidation \
    --distribution-id $AWS_CLOUDFRONT_DISTRIBUTION \
    --paths $AWS_CLOUDFRONT_PATHS
fi
echo "$(date) End"