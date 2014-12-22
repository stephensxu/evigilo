# Evigilo

![Evigilo Logo](http://aviioblog.s3.amazonaws.com/screenshot-kensodevVC75M0a.jpg-2014-12-22-np7n4.png)

Evigilo is a minimalist API to store/track your database changes.

## API

### Store Change

#### POST `/store/:table_name/:id/:action`

* `table_name` The table name you are storing the change for eg: `users`
* `id` row ID
* `action` `create`, `update` or `destroy`, this is just a string, you can pass in anything you can identify in your own application (eg: `upsert`).

You also need to pass `data` as a JSON field, the convention for storing the changes is:

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

SAMPLE POST:

```shell
curl \
  -X POST \
  "http://localhost:4567/track/users/1/create"  \
  -F "data={\"name\":[\"Avi Tzurel\",\"Avi\"],\"perishable_token\":[\"XXXXX\",\"YYYYY\"],\"updated_at\":[\"2014-12-21T19:07:25Z\",\"2014-12-22T07:49:49Z\"]}"
```