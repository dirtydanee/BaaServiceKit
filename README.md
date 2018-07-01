# BaaServiceKit
[![Build Status](https://travis-ci.com/dirtydanee/BaaServiceKit.svg?branch=develop)](https://travis-ci.com/dirtydanee/BaaServiceKit)  

Fast and easy submission of data to the Bitcoin blockchain!  
## Usage

## Submission flow
```
+--------+                         +-------+
|        |                         |       |
| Client |                         |  SBS  |
|        |                         |       |
+---+----+                         +---+---+
    |                                  |
    |                                  |
    +---------------------------------->
    |  Send data for hashing           +-----------+
    |                                  |  Generates|
    |                                  |  SHA+256  |
    |                                  |  hash     |
    |                                  <-----------+
    <----------------------------------+
    |  Sends hashed data               |
    +---------------------------------->
    |  Submits hash                    +------------+
    |                                  |  Submits   |
    |                                  |  to        |
    |                                  |  Blockchain|
    |                                  <------------+
    <----------------------------------+
    |  Sends hash identifier from      |
    |  response                        |
    +---------------------------------->
    |  Optional: save hash id          +--------+
    |  to database                     |  Saves |
    |                                  |  to    |
    |                                  |  SQLite|
    |                                  <--------+
    +---------------------------------->
    |  Get proof of hash id            +------------+
    |                                  |  Get       |
    |                                  |  proof     |
    |                                  |  from      |
    |                                  |  Blockchain|
    |                                  <------------+
    <----------------------------------+
    |  Returns proof                   |
    |                                  |
    +---------------------------------->
    |  Verify proof                    +------------+
    |                                  |  Verify    |
    |                                  |  proof     |
    |                                  |  from      |
    |                                  |  Blockchain|
    |                                  <------------+
    <----------------------------------+
    |  Returns verification            |
    +----------------------------------+
    |  Optional: get all hash id       +--------+
    |  Optional: clear all hash id     |  DB    |
    |  Optional: clear a hash id       |  action|
    |                                  <--------+
    <----------------------------------+
    |  Returns action                  |
    |                                  |
    +                                  +
```
