dockercloud-agent
===========

- unoffical fork of dockercloud-agent
- support running with unmodified docker-engine 1.11.2
- works with coreos (untested) and rancheros
- to run:
```
docker run -d -p 2375:2375 --privileged -v /var/run/docker.sock:/var/run/docker.sock --restart=always -e TOKEN=$TOKEN dictcp/dockercloud-agent
```

