FROM alpine:3.14


RUN apk add --no-cache --update python3 python3-dev
RUN python3 -m ensurepip
RUN pip3 install --upgrade pip

RUN pip3 install awscli

ENV KEY=,SECRET=,REGION=,BUCKET=,BUCKET_PATH=/,CRON_SCHEDULE="0 1 * * *",PARAMS=

VOLUME ["/data"]

ADD *.sh /
RUN chmod +x /*.sh

ENTRYPOINT ["/start.sh"]
CMD [""]
