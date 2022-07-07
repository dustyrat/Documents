// Upsert
db.getCollection("test").update(
    { "key": "value" }, // filter
    {
        $setOnInsert: {
            "created": new Date() // set created timestamp
        },
        $currentDate: { // set modified timestamp
            lastModified: true, // default
            // and/or
            "updated": { $type: "date" } // custom field
        },
        $inc: { "version": NumberInt(1) }, // auto increment field
        $set: { /* <document body> */ } // update
    },
    // options
    // {
    //     upsert: <boolean>, // update/insert
    //     multi: <boolean>, // update multiple
    //     writeConcern: <document>,
    //     collation: <document>,
    //     arrayFilters: [ <filterdocument1>, ... ],
    //     hint:  <document|string>        // Available starting in MongoDB 4.2
    // }
)
