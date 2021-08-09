#!/usr/bin/env bash

curl 'https://restbus.transit.tips/ttc/train/schedules/show?latitude=43.753837&longitude=-79.478348' \
  -XGET \
  -H 'Accept: */*' \
  -H 'Origin: https://transit.tips' \
  -H 'Pragma: no-cache' \
  -H 'Cache-Control: no-cache' \
  -H 'Accept-Language: en-ca' \
  -H 'Host: restbus.transit.tips' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1.1 Safari/605.1.15' \
  -H 'Referer: https://transit.tips/' \
  -H 'Accept-Encoding: br, gzip, deflate' \
  -H 'Connection: keep-alive'
