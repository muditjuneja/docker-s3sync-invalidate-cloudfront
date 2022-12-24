# muditjuneja/docker-s3sync-invalidate-cloudfront

Docker container that periodically syncs a folder to Amazon S3 using the [AWS Command Line Interface tool](https://aws.amazon.com/cli/) and cron and also allows the user to request invalidation in a given cloudfront distribution

## Usage

    docker run -d [OPTIONS] futurevision/aws-s3-sync


### Required Parameters:

* `-e KEY=<KEY>`: User Access Key
* `-e SECRET=<SECRET>`: User Access Secret
* `-e REGION=<REGION>`: Region of your bucket
* `-e BUCKET=<BUCKET>`: The name of your bucket
* `-e $AWS_CLOUDFRONT_DISTRIBUTION=<AWS_CLOUDFRONT_DISTRIBUTION>` : AWS CloudFront Distribution Id (Optional)
* `-e $AWS_CLOUDFRONT_PATHS=<AWS_CLOUDFRONT_PATHS>` : CloudFront paths to invalidate and can be passed as string like "index.html, blog/test-blog.html" (Optional)
* `-v /path/to/backup:/data:ro`: mount target local folder to container's data folder. Content of this folder will be synced with S3 bucket.

### Optional parameters:

* `-e PARAMS=`: parameters to pass to the sync command ([full list here](http://docs.aws.amazon.com/cli/latest/reference/s3/sync.html)).
* `-e BUCKET_PATH=<BUCKET_PATH>`: The path of your s3 bucket where the files should be synced to (must start with a slash), defaults to "/" to sync to bucket root
* `-e CRON_SCHEDULE="0 1 * * *"`: specifies when cron job starts ([details](http://en.wikipedia.org/wiki/Cron)), defaults to `0 1 * * *` (runs every night at 1:00).
* `now`: run container once and exit (no cron scheduling).

## Examples:

Sync every hour with cron schedule (container keeps running):

    docker run -d \
        -e KEY=mykey \
        -e SECRET=mysecret \
		-e REGION=region \
        -e BUCKET=mybucket \
        -e CRON_SCHEDULE="0 * * * *" \
		-e BUCKET_PATH=/path \
        -v /home/user/data:/data:ro \
        futurevision/aws-s3-sync

Sync just once (container is deleted afterwards):

    docker run --rm \
        -e KEY=mykey \
        -e SECRET=mysecret \
		-e REGION=region \
        -e BUCKET=mybucket \
        -v /home/user/data:/data:ro \
        futurevision/aws-s3-sync now

Sync every hour with cron schedule (container keeps running) and also request invaldation in a given cloudfron distribution:

    docker run -d \
        -e KEY=mykey \
        -e SECRET=mysecret \
		-e REGION=region \
        -e BUCKET=mybucket \
        -e CRON_SCHEDULE="0 * * * *" \
		-e BUCKET_PATH=/path \
        -e AWS_CLOUDFRONT_DISTRIBUTION=E1UI1MJJJN78IC \
        -e AWS_CLOUDFRONT_PATHS="/index.html" \
        -v /home/user/data:/data:ro \
        futurevision/aws-s3-sync

## Credits

This container is heavily inspired by [futurevision/docker-aws-s3-sync](https://github.com/futurevision/docker-aws-s3-sync) which was heavily inspired by [istepanov/backup-to-s3](https://github.com/istepanov/docker-backup-to-s3/blob/master/README.md).

The main difference is that this container allows a user to request invaldation requests in a given cloudfront distribution id which could come up really handy and also updates Alpine Linux version.
