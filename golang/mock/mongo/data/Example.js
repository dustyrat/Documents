db = db.getSiblingDB('Example')
var collection = db.getCollection("Example");

/*
*   _id's starting with 0 - get
*   _id's starting with 1 - update
*   _id's starting with 2 - find
*/

collection.insert({
    "_id": ObjectId("000000000000000000000001"),
})

collection.insert({
    "_id": ObjectId("100000000000000000000001"),
})

collection.insert({
    "_id": ObjectId("200000000000000000000001"),
})
