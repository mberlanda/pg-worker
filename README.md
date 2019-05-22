# Pg Worker

The purpose of this repo is to familiarize with the `database/sql` go library.

### Setup

Assuming that go and postgresql are setup, the db can be prepared with a simple [cli](db.sh):

```sh
$ ./db.sh --create
$ ./db.sh --migrate
$ ./db.sh --seeds
```
