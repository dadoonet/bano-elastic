# Demo scripts used for Bano Talk

> Come and learn how you can enrich your existing data with normalized postal addresses with geo location points thanks to open data and [BANO project](http://bano.openstreetmap.fr/data/).

Most of the time postal addresses from our customers or users are not very well formatted or defined in our information systems. And it can become a nightmare if you are a call center employee for example and want to find a customer by its address.
Imagine as well how a sales service could easily put on a map where are located the customers and where they can open a new shop...

Let's take a simple example:

```json
{
  "name": "Joe Smith",
  "address": {
    "number": "23",
    "street_name": "r verdiere",
    "city": "rochelle",
    "country": "France"
  }
}
```

Or the opposite. I do have the coordinates but I can't tell what is the postal address corresponding to it:

```json
{
  "name": "Joe Smith",
  "location": {
    "lat": 46.15735,
    "lon": -1.1551
  }
}
```

In this live coding session, I will show you how to solve all those questions using the Elastic stack.

## Setup

### Run on cloud (recommended)

This specific configuration is used to ingest the whole bano dataset on a [cloud instance](https://cloud.elastic.co).
You need to create a `.cloud` local file which contains:

```properties
CLOUD_ID=the_cloud_id_you_can_read_from_cloud_console
CLOUD_PASSWORD=the_generated_elastic_password
```

Run:

```sh
./setup.sh
```

### Run Locally

Run Elastic Stack:

```sh
echo docker-compose down -v
echo docker-compose up
```

And run:

```sh
./setup.sh
```

## Inject the whole dataset

Run:

```sh
./inject-all.sh
```

Open Kibana.

Go to the dev tools application and check that data is coming with:

```json
GET bano-*/_count
```

Go to the map application and check that data is coming.

## Side notes

The csv fields we want to extract are:

* _id
* address.number
* address.street_name
* address.zipcode
* address.city
* source
* location.lat
* location.lon

The fields we can remove are:

* @timestamp
* input
* ecs
* host
* agent
* message
