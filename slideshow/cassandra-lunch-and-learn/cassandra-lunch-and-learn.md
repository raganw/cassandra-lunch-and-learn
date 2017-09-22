# Cassandra Lunch and Learn
## September 22, 2017

---

# History
- Developed at Facebook to power Inbox Search
- One of the authors of Amazon's DynamoDB

---

# History - Releases
- 2008 - Released as Open Source
- 2009 - Apache Incubator
- 2010 - Graduated to top-tier Apache project
- 2010 - Cassandra 0.6 (Probably the first version used at Socrata for first version of Balboa)
- 2015 - Cassandra 2.2 (2.2.10, released 6/2017, is the version we are currently running)
- 2015 - Cassandra 3.0 (3.11, released 6/2017, is the latest stable version)
- ???? - Cassandra 4.0 (Will put 2.2.x out of support, and 3.x into 6 months of support)
  - 92% of the project's JIRA tickets tagged for v4.0 are complete

---

# Why Cassandra?
## CAP Theorem

---

# CAP Theorem

> Parenting CAP Theorem:  
>   
> Consistent sleep  
> Available time  
> Peace and quiet  
>   
> Choose none.
> 
> — Dan Woods (@danveloper) [February 21, 2017](https://twitter.com/danveloper/status/833861643536834560)

---

# CAP Theorem

> The CAP theorem says that a paper on distributed systems cannot be simultaneously Applicable, Comprehensible and free from Paywall.
> 
> — Chris Ford (@ctford) [July 3, 2017](https://twitter.com/ctford/status/881990271881314304)

---

# CAP Theorem

It is impossible for a distributed computer system to simultaneously provide more than two of the following three guarantees:
- Consistency - Every read receives the most recent write or an error
- Availability - Every request receives a (non-error) response – without guarantee that it contains the most recent write
- Partition-tolerant - The system continues to operate despite an arbitrary number of messages being dropped (or delayed) by the network between nodes

---

# Cassandra and CAP

Considered an AP system, where it prioritizes Availability and Partition-tolerance.  However, it is tunable via replication factor and consistency level to provide high consistency

---

# Biggest Selling Point

High performance for writes, scalable horizontally due to its peer-based clustering, with a number of fault tolerance mechanisms

---

# How Cassandra Works

---

# Clustering

- No "master" node, all nodes are peers
- Performance generally scales linearly with number of nodes (e.g. 2 nodes serving 100,000 transactions per second should scale to 4 nodes service 200,000 tx/s)

---

# Replication

- The number of replicas in the cluster, i.e. copies of a particular piece of data across all nodes, is configurable on a per-keyspace (table) basis
- If any node in a cluster goes down, one or more copies of that node’s data is available on other machines in the cluster
- Can be configured to work across one datacenter, many datacenters, and multiple cloud availability zones

---

# Consistency

- Consistency refers to how up-to-date and synchronized a row of data is on all of its replicas
- Extends the concept of eventual consistency by offering tunable consistency for any given read or write operation, the client application decides how consistent the requested data should be

---

# Consistency (cont.)
## Read Consistency Options (a subset)

| Level | Description |
| --- | --- |
| ALL | Returns the record with the most recent timestamp after all replicas have responded. The read operation will fail if a replica does not respond. |
| EACH_QUORUM | Returns the record with the most recent timestamp once a quorum of replicas in each data center of the cluster has responded. |
| LOCAL_QUORUM | Returns the record with the most recent timestamp once a quorum of replicas in the current data center as the coordinator node has reported. |

---

# Consistency (cont.)
## Read Consistency Options (a subset)

| Level | Description |
| --- | --- |
| LOCAL_ONE | Returns a response from the closest replica, as determined by the snitch, but only if the replica is in the local data center. |
| ONE | Returns a response from the closest replica, as determined by the snitch. By default, a read repair runs in the background to make the other replicas consistent. |
| QUORUM | Returns the record with the most recent timestamp after a quorum of replicas has responded regardless of data center. |

---

# Consistency (cont.)
## Write Consistency Options (a subset)

| Level | Description |
| --- | --- |
| ANY | A write must be written to at least one node. If all replica nodes for the given row key are down, the write can still succeed after a _hinted handoff_ has been written. If all replica nodes are down at write time, an ANY write is not readable until the replica nodes for that row have recovered. |
| ALL | A write must be written to the commit log and memory table on all replica nodes in the cluster for that row. |

---
# Consistency (cont.)
## Write Consistency Options (a subset)

| Level | Description |
| --- | --- |
| LOCAL_QUORUM | A write must be written to the commit log and memory table on a quorum of replica nodes in the same data center as the coordinator node. Avoids latency of inter-data center communication. |
| ONE | A write must be written to the commit log and memory table of at least one replica node. |

---

# How is Data Stored?

---

## The Write Path

![IMAGE](http://docs.datastax.com/en/archived/cassandra/2.0/cassandra/images/dml_write-process_12.png)

---

# The Write Path

- Mem table - Fast immediate access
- Commit Log - Immediate durability
- SSTable - Long-term durability and consistency

---

# The Read Path

![IMAGE](http://docs.datastax.com/en/archived/cassandra/2.0/cassandra/images/dml_caching-reads_12.png)

---

# The Read Path

Cassandra must combine results from the active memtable and potentially multiple SSTables to satisfy a read.

- Bloom filter - probability that a particular sstable has data before actually going to disk
- Partition key cache - What sstable has the data?
  - Partition Summary - Where on disk could the data be?
  - Partition Index - Where exactly on disk is the data?
- Compression Offsets - Where in the sstable is the data?
- Data - There it is!

---

# Repairs

---

# Repairs
## Getting consistent

Repairs (or anti-entropy operations) are Cassandra's mechanism for maintaining consistency across the cluster in the event of network issues
and node outages.

---

# Repairs
## Getting consistent

Repairs are performed on read of data when it is determined that a node that should have the data does not have it.  Additionally,
we have repairs scheduled to run across our cluster every few days.  This is done by calculate the hash of parts of the data and comparing that hash
with where it should exists.  In the event that data is missing, the data is streamed from a node that has it to the node that does not.

---

# API

---

# API

Cassandra historically has provided two APIs/network transports for working with it.  "Thrift" was the initial transport supported, but was
superseded by the native "CQL" transport in later versions of Cassandra.  In version 3.0 of Cassandra, thrift is no longer active by default
and is basically deprecated.

The argument for using CQL over thrift primarily comes down to if you want to use more modern capabilities of Cassandra, but CQL is the preferred
mechanism for working with Cassandra now and going forward.

---

# Datastax

---

# Datastax

Commercial entity that provides their own flavor of Cassandra in the form of Datastax Enterprise.  Also fosters the development of libraries
to use with Cassandra, and provides some online training courses that are helpful for getting a deeper understanding of Cassandra
operations and development.

---

# Datastax Driver

Datastax Driver is the library that we would ideally be using everywhere for interacting with Cassandra.  This provides support for the native
transport when communicating with Cassandra, connection pooling, and resiliency.

Delta Importer 2 seems to be the only Socrata project that still uses the
now-deprecated and no longer supported Astyanax driver.

---

# Tools

---

# Tools
## nodetool

`nodetool` - The most important tool for working with Cassandra nodes.

Provides the ability to check the state of the cluster and individual nodes, manipulate
the cluster, snapshot nodes, run consistency repairs, and shutdown nodes cleanly.

---

# Tools
## `nodetool status`
## See the status of the cluster, what nodes are part of it, their load of the data, and their status

```
Datacenter: us-west-2
=====================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address        Load       Tokens       Owns    Host ID                               Rack
UN  10.110.33.188  5.18 GB    256          ?       c196cd0d-812a-4795-a423-a7d8799eee00  2a
UN  10.110.42.252  5.33 GB    256          ?       bd9918c2-635f-455d-90d5-3c59daa365f4  2c
UN  10.110.37.55   4.9 GB     256          ?       885593d3-8fde-4962-a902-41beec305ba7  2b
```

---

# Tools
## `nodetool describecluster`
## More detail about the cluster

```
Cluster Information:
	Name: Socrata Metrics Cluster
	Snitch: org.apache.cassandra.locator.DynamicEndpointSnitch
	Partitioner: org.apache.cassandra.dht.RandomPartitioner
	Schema versions:
		0c0e24fd-ac04-3887-8cc0-eb53235fd4eb: [10.110.42.252, 10.110.33.188, 10.110.37.55]
```

---

# Tools
## `nodetool info`
## Information about the node it is run on, e.g. heap usage, uptime, cache stats

```
ID                     : c196cd0d-812a-4795-a423-a7d8799eee00
Gossip active          : true
Thrift active          : true
Native Transport active: true
Load                   : 5.18 GB
Generation No          : 1505150833
Uptime (seconds)       : 883752
Heap Memory (MB)       : 574.09 / 1976.00
Off Heap Memory (MB)   : 143.16
Data Center            : us-west-2
Rack                   : 2a
Exceptions             : 0
Key Cache              : entries 1038840, size 87.55 MB, capacity 98 MB, 6292004 hits, 9409776 requests, 0.669 recent hit rate, 14400 save period in seconds
Row Cache              : entries 0, size 0 bytes, capacity 0 bytes, 0 hits, 0 requests, NaN recent hit rate, 0 save period in seconds
Counter Cache          : entries 207445, size 26.63 MB, capacity 49 MB, 948966 hits, 1331745 requests, 0.713 recent hit rate, 7200 save period in seconds
```

---

# Tools
## `nodetool tpstats`
## Thread pool stats - what threads are active on this node, e.g. compaction, anti-entropy (repair), blocked threads

```
Pool Name                    Active   Pending      Completed   Blocked  All time blocked
MutationStage                     0         0        2086964         0                 0
ReadStage                         0         0       64182133         0                 0
RequestResponseStage              0         0       26635830         0                 0
ReadRepairStage                   0         0        6029181         0                 0
CounterMutationStage              0         0         587910         0                 0
HintedHandoff                     0         0             20         0                 0
MiscStage                         0         0              0         0                 0
CompactionExecutor                0         0         887421         0                 0
MemtableReclaimMemory             0         0           4231         0                 0
PendingRangeCalculator            0         0              8         0                 0
GossipStage                       0         0        2651509         0                 0
MigrationStage                    0         0              5         0                 0
MemtablePostFlush                 0         0         125356         0                 0
ValidationExecutor                0         0          90872         0                 0
Sampler                           0         0              0         0                 0
MemtableFlushWriter               0         0           3859         0                 0
InternalResponseStage             0         0            137         0                 0
AntiEntropyStage                  0         0         346369         0                 0
CacheCleanupExecutor              0         0              0         0                 0
Native-Transport-Requests         0         0      102993281         0                 0

Message type           Dropped
READ                         0
RANGE_SLICE                  0
_TRACE                       0
MUTATION                     0
COUNTER_MUTATION             0
REQUEST_RESPONSE             0
PAGED_RANGE                  0
READ_REPAIR                  0
```

---

# Tools
## `nodetool netstats`
## Network stats - mostly if data is streaming between nodes

```
Mode: NORMAL
Not sending any streams.
Read Repair Statistics:
Attempted: 5517249
Mismatch (Blocking): 0
Mismatch (Background): 17
Pool Name                    Active   Pending      Completed   Dropped
Large messages                  n/a         0           1731         0
Small messages                  n/a         0       50627207         0
Gossip messages                 n/a         0        2651909         0
```

---

# Tools
## cqlsh

`cqlsh` - CQL shell

Is the equivalent of `psql` for Cassandra.  Allows executing queries against a Cassandra node/cluster. 

```
Connected to Socrata Metrics Cluster at 10.110.33.188:9042.
[cqlsh 5.0.1 | Cassandra 2.2.10 | CQL spec 3.3.1 | Native protocol v4]
Use HELP for help.
cqlsh> describe keyspaces;

govstat        system_auth  "OpsCenter"    books               "GovStat"
system_traces  system       "Metrics2012"  system_distributed  delta_importer_2

cqlsh>
```

---

# Tools
## jmxterm

`jmxterm` - Command-line interface for working with JMX

This has been useful for pulling data out of Cassandra and, specifically, stopping consistency repairs that are in progress.
See the Cassandra Playbook for how to stop a repair.

---

# Cassandra at Socrata
## Clusters

- Apps Cluster
  - Delta Importer 2
  - Phiddipides (metadata)
- Metrics Cluster
  - Balboa (tenant metrics)
  - Procrustes
- Apps-Metrics Cluster (RC and EU)
  - Everything on one cluster
  - Why aren't all the clusters like this?
    - Differing partitioners between clusters

---

# Cassandra at Socrata
## Services

- Delta Importer 2
  - "Partition table" for a filesystem distributed over S3
  - "Greyboard" logs
- Phidippides
  - Key/Value metadata for datasets
- Balboa
  - Time-series data of collected metrics
  - Aggregating counters and absolute count values
- Procrustes
  - Goal data and ???

---

# Cassandra and On-Call

The OpsDocs for Cassandra have been updated to reflect the current state of Cassandra operations
at Socrata.  Additionally, the Cassandra playbook has been updated with ways to attack some
scenarios that we have encountered recently with Cassandra.

When on-call, and something looks like a Cassandra issue:

**Refer to the OpsDoc, then the Playbook. Otherwise, flag down someone who knows Cassandra (presently Ragan, someday more 🤞)**

---

# Hands-on Time

**Slack Channel: #cassandra-cluster-fun**

Let's break into groups of three people or so, clone the repository https://github.com/raganw/cassandra-lunch-and-learn,
and take a look at the `cluster-exercise` directory.

---