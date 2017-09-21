# Cluster Exercise

### Setup
To install and setup an isolated instance of cassandra bound to the LAN IP of
your laptop, run:
```
$ ./setup
```
To setup with a seed node other than your local node, run:
```
$ ./setup -s <other IP address>
```
### Exercises
With nodes connected to form a cluster, run:
```
$ ./nodetool status
$ ./nodetool info
$ ./nodetool describecluster
```
Take note of the information that is provided by each.
