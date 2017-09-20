# Cassandra Lunch and Learn
## September 22, 2017

---

# History
- Developed at Facebook to power Inbox Search
- One of the authors of Amazon's DynanamoDB

---

# History
## Releases
- 2008 - Released as Open Source
- 2009 - Apache Incubator
- 2010 - Graduated to top-tier Apache project

---

# History
## Releases

- 2010 - Cassandra 0.6 (Probably the first version used at Socrata for first version of Balboa)
- 2015 - Cassandra 2.2 (2.2.10, released 6/2017, is the version we are currently running)
- 2015 - Cassandra 3.0 (3.11, released 6/2017, is the latest stable version)

---

# History
## Releases

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

It is impossible for a distributed computer system to simultaneously provide more than two of three of the following guarantees:
- Consistency - Every read receives the most recent write or an error
- Availability - Every request receives a (non-error) response – without guarantee that it contains the most recent write
- Partition-tolerant - The system continues to operate despite an arbitrary number of messages being dropped (or delayed) by the network between nodes

---

# Cassandra and CAP

Considered an AP system, where it prioritizes Availability and Partition-tolerance.  However, as we will see, it is tunable via replication factor and consistency level to provide high consistency

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
- can be configured to work across one data center, many data centers, and multiple cloud availability zones

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
| LOCAL_QUORUM | A write must be written to the commit log and memory table on a quorum of replica nodes in the same data center as the coordinator node. Avoids latency of inter-data center communication. |
| ONE | A write must be written to the commit log and memory table of at least one replica node. |

---

# How is Data Stored?

---

# How is Data Stored?
## The Write Path

![IMAGE](http://docs.datastax.com/en/archived/cassandra/2.0/cassandra/images/dml_write-process_12.png)

- Memtable
- Commit Log
- SStable

---

# API

---

# Datastax

---

# Available Tools

---

# Cassandra at Socrata

---

# Cassandra and On-Call

---

# Hands-on Time

---