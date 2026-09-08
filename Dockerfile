FROM alpine:latest

RUN apk add --no-cache bash

WORKDIR /app

COPY loganalyze.sh .

RUN chmod +x loganalyze.sh

CMD ["./loganalyze.sh"]
