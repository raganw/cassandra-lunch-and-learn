# Cassandra Lunch and Learn

---

# History
- Developed at Facebook to power Inbox Search
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
## CAP Theorem

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
## CAP Theorem

> The CAP theorem says that a paper on distributed systems cannot be simulteneously Applicable, Comprehensible and free from Paywall.
> 
> — Chris Ford (@ctford) [July 3, 2017](https://twitter.com/ctford/status/881990271881314304)

---
## CAP Theorem

It is impossible for a distributed computer system to simultaneously provide more than two of three of the following guarantees:
- Consistency - Every read receives the most recent write or an error
- Availability - Every request receives a (non-error) response – without guarantee that it contains the most recent write
- Partition-tolerant - The system continues to operate despite an arbitrary number of messages being dropped (or delayed) by the network between nodes

---
### Cassandra and CAP
Considered an AP system, where it prioritizes Availability and Partition-tolerance.  However, as we will see, it is tunable to trade off 
---
# How Cassandra Works
---
## Replication
---
## Consistency
---
## API
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