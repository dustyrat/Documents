db = db.getSiblingDB('Example');
db.createCollection("Example",{});
collection = db.getCollection("Example");

collection.createIndex({ "field1": 1 }, { "background": true, "sparse": true, "unique": true });
collection.createIndex({ "field2": 1 }, { "background": true, "sparse": false, "unique": true });
collection.createIndex({ "field3": 1 }, { "background": true, "sparse": false, "unique": false });

