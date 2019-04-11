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

In this live coding session, I will show you how to solve all those questions using the Elastic stack with a lot of focus on Logstash and Elasticsearch.

