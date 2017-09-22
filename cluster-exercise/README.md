# Cluster Exercise
NOTE: Don't be connected to the VPN when doing this, please.

This is a collection of scripts for running an isolated instance of cassandra
and allow for easier clustering between laptops connected to our LAN.

## Setup
To install and setup an isolated instance of cassandra bound to the LAN IP of
your laptop, run:
```
$ ./setup
```
To setup with a seed node other than your local node, run:
```
$ ./setup -s <other IP address>
```

## Start Cassandra
Use the provided `service` script to start and stop cassandra:
```
$ ./service start
$ ./service stop
```

### Logs
This instance of cassandra will put its logs under `./cassandra/logs`.  It will
be helpful and insightful to have a terminal open tailing this log:
```
$ tail -F cassandra/logs/system.log
```

## Exercises

### Form a cluster
As a group, decide on one person's node to be the seed, then have the others
in the group setup their node with the designated seed node's IP (see
[setup](#setup)).  Begin starting nodes and watch the log output as the
dance of the node coordination is performed.

### Using nodetool

With nodes connected to form a cluster, run:
```
$ ./nodetool help
$ ./nodetool version # should be 2.2.10
$ ./nodetool status
$ ./nodetool info
$ ./nodetool describecluster
```
Take note of the information that is provided by each.

### Down and restore a node

Have one person in your group stop their instance of cassandra.  Options for
this operation are:
```
$ ./nodetool stopdaemon
# or
$ ./service stop
```

With a node down, run `./nodeool status` on each node and see what it says. To
interpret the output, look [here](http://docs.datastax.com/en/archived/cassandra/2.2/cassandra/tools/toolsStatus.html).
Also check `./nodetool describecluster` to see that the cluster has an
unreachable node.

Bring the node back up (`./service start`) and verify that it is a part of
the cluster again.

### Decommission a node
As we can see, simple downing a node does not remove it from the cluster. It
is still considered responsible for storing data, and will receive the data
that it missed while down when it comes up (via hinted handoff) and when the
next repair operation occurs.

To actually remove a node from the cluster, we need to signal our intent to
the cluster and stream the data this node was responsible for back into the
remaining nodes.  To do this, on the node you would like to remove, run:
```
$ ./nodetool decommission
```

A `./nodetool status` will now show either the node leaving the cluster (status
of UL -- UP and Leaving), or that it is no longer a part of the cluster.

Since the cluster information is retained in the the system keyspace of the
removed node, starting the node back up will find it rejoining the cluster
again.

### Create a keyspace and insert data
Currently, our cluster has no data, other than system-level data.  We can
confirm this via `cqlsh` and the filesystem:
```
$ ./cqlsh -e 'describe keyspaces'
$ ls cassandra/data/data
```

Let's create a keyspace that will replicate across all nodes in our cluster:
```
$ ./cqlsh -e "CREATE KEYSPACE replicated_data WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 3 }"
```

We can confirm the creation of the keyspace now:
```
$ ./cqlsh -e 'DESCRIBE KEYSPACES'
$ ./cqlsh -e 'DESCRIBE KEYSPACE Replicated_data'
```

But there's no tables (see `ls cassandra/data/data`).

To create tables, execute CQL statements from a file:
```
$ ./cqlsh -f create_tables.cql
```

And to insert data, run:
```
$ ./cqlsh -f insert_people.cql
```

Now we can retrieve data out in a way similar to SQL:
```
$ ./cqlsh -e "SELECT * FROM replicated_data.people"
$ ./cqlsh -e "SELECT name, location FROM replicated_data.people"
```

However, we can not filter to arbitrary columns like in SQL:
```
$ ./cqlsh -e "SELECT * FROM replicated_data.people WHERE age = 25"
```

Additionally, we've created the primary partition as a combination of the id
and name, so selecting on either one of those separately will fail:
```
$ ./cqlsh -e "SELECT * FROM replicated_data.people WHERE id = 5"
$ ./cqlsh -e "SELECT * FROM replicated_data.people WHERE name = 'Glenn'"
$ ./cqlsh -e "SELECT * FROM replciated_data.people WHERE id = 5 AND name = 'Glenn'"
```

We can add an index on age to allow for selecting on that column:
```
$ ./cqlsh -e "CREATE INDEX ON replicated_data.people (age)"
$ ./cqlsh -e "SELECT * FROM replicated_data.people WHERE age = 25"
```

### Insert with consistency confirmation
Let's take down one of the nodes in the cluster and see what happens.

```
$ ./cqlsh
# Now we're in the cqlsh repl
cqlsh> CONSISTENCY ALL;
cqlsh> INSERT INTO replicated_data.people (id, name, age, height, location, phones) VALUES (6, 'John', 26, 5.9, {state: 'WA', city: 'Seattle', zip_code: 98119, street: '4th Street'}, {'2065551212'});
# Fails since it cannot get acknowledgment from all nodes that would own this data (replication factor 3)
cqlsh> CONSISTENCY QUORUM;
cqlsh> INSERT INTO replicated_data.people (id, name, age, height, location, phones) VALUES (6, 'John', 26, 5.9, {state: 'WA', city: 'Seattle', zip_code: 98119, street: '4th Street'}, {'2065551212'});
# Succeed because it can get acknowledgment from quorum = floor((replication_factor / 2) + 1)
```
