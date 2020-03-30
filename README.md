# next-passenger
next passenger demo/example/experiment

## Setup

```bash
docker build -t test .
docker run -d -p 8080:80 --name test test
```

For logs look at:

```bash
docker logs -f test
```

## Changes

For changes to nginx conf edit `default.conf` and rebuild the container.
