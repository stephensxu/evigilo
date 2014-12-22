# Evigilo

[![Build Status](https://travis-ci.org/gogobot/evigilo.svg)](https://travis-ci.org/gogobot/evigilo)

![Evigilo Logo](http://aviioblog.s3.amazonaws.com/screenshot-kensodevVC75M0a.jpg-2014-12-22-np7n4.png)

Evigilo is a minimalist API to store/track your database changes.

## Why?

### Why not use papertrail or any other db-centric solution?

We already have a pretty extensive messaging infrastructure at Gogobot and we try to refactor all the non-user-centric-logic out to micro-services.

	
### Plugins support (Planned)

We plan on adding plugin support (similar to what I did for [cashier](https://github.com/ahawkins/cashier)), this means, you will be able to add `evigilo-aws` and store the change data on `AWS::S3` as JSON files.

Once it’s on AWS as JSON you can use it with all other AWS services like lambda for example.

 
## Installation and running

### Running the API service

* Clone the repository.
* Run `bundle install`.
* Run `bundle exec rake db:create` in order to create the development and test databases.
* Run `rackup -p 4567` in order to run the web service.

### Running tests

* Running `bundle exec rake` will run the full test suite.

## API

Basic API Endpoints are:

* `/store/:table_name/:id/:action` Stores a change log for that object, returns a version id that you can store wherever you want (or don’t)
* `/versions/:table_name/:id` Get all version of a specific object. Returns a list of versions from the server, no change data.
* `/versions/:version` Get changelog data for a specific version

### Api Terms

To keep consistency, the terms (params) of the API are kept across all the endpoints

* `table_name` Just as it’s name suggest, the table (or collection) name
* `id` Again, pretty self explanatory, pass the id of that row/object, this can be either string/integer, your choice
* `version` The version id you want to query
* `action` DB action relevant, this is a string so you can store anything you want eg: (create, update, delete, upsert)

There are **no manipulations** on the data you pass in, if you send `Users` as the table name, it will be stored as is, same for ids and the data/snapshot JSON.

### Store action

The `store` endpoint requires you to send a `data` field with a JSON format for the changelog of the object.

This is the standard:

```javascript
{
  fieldname: [ was, now ]
}
```

For example:

```javascript
{
    "name": [
        "Avi Tzurel",
        "Avi"
    ],
    "perishable_token": [
        "XXXXX",
        "YYYY"
    ],
    "updated_at": [
        "2014-12-21T19:07:25Z",
        "2014-12-22T07:49:49Z"
    ]
}
```

`snapshot


### Store Change

#### POST `/store/:table_name/:id/:action`

SAMPLE POST:

```shell
curl \
  -X POST \
  "http://localhost:4567/store/users/1/create"  \
  -F "data={\"name\":[\"Avi Tzurel\",\"Avi\"],\"perishable_token\":[\"XXXXX\",\"YYYYY\"],\"updated_at\":[\"2014-12-21T19:07:25Z\",\"2014-12-22T07:49:49Z\"]}"
```

SAMPLE RESPONSE:

```javascript
{
    "result": true,
    "version": "3d4415f0-baff-4ba9-bc70-11a95493dfb2"
}
```

`result` field will be true of the version was indeed saved correctly to the database and false if it wasn’t

#### GET `/versions/:table_name/:id`

Will return all versions (or empty array)

SAMPLE GET:

```shell
curl -X GET 'http://localhost:4567/versions/users/1'
```

SAMPLE RESPONSE:

```javascript
{
    "result": "ok",
    "versions": [
        "d0568dc7-4b89-4542-ad16-7b1b9d252e2b",
        "06bdfc59-e261-4c43-b25e-8df69a17423c",
        "00e4759d-5099-4635-81e6-103f1ba43492",
        "444e5058-f7ad-433f-9199-7a0492cc0be9",
        "4e515bdc-735d-4ef4-a3c3-ec6947a2f479",
        "7a1eeb73-5a12-48e3-9a82-90b16cd56a03",
        "e052f9ce-dd79-4204-977f-ab1d63d14524",
        "87fdcd17-602c-4f18-9dbf-f4565a3da4b4",
        "ff35450b-572f-4b59-8cfe-b7235492fefa",
        "8a2a0d15-698b-4b1c-b78c-4f6898b55a47",
        "3c9323f3-4be9-4c6a-8e43-56ac89b83b56",
        "3d4415f0-baff-4ba9-bc70-11a95493dfb2"
    ]
}
```

#### GET `/versions/:version`

SAMPLE REQUEST: 

```shell
curl -X GET 'http://localhost:4567/versions/8a2a0d15-698b-4b1c-b78c-4f6898b55a47'
```

SAMPLE RESPONSE: 

```javascript
{"result":"ok","object_name":"users","object_id":"1","data":{"name":["Avi","NewAvi"]},"snapshot":null}
```


## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b feature/my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin feature/my-new-feature`
5. Submit a pull request :D]

Please make sure you have tests that cover the core functionality of what you are adding.

Feel free to open an issue first in order to discuss the bug/feature you are addressing.

## Credits

Avi Tzurel: [@KensoDev](http://twitter.com/KensoDev)

## License

Read more on the license file, but as usual, it’s MIT

