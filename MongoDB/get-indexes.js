// iterate through every collection in MongoDB database
db.getCollectionNames().forEach(function (collection) {
	try {
		var indexes = db.getCollection(collection).getIndexes();
		// now iterate through every index in the collection
		indexes.forEach(function (index) {
			// we don't need these as it will be auto created
			delete index.v; delete index.ns;
			var key = index.key;
			delete index.key
			var options = {};
			// let us also copy all options associated with the index
			// index property unique is an example
			for (var option in index) {
				options[option] = index[option]
			}

			// Create script output
			print(`db.getCollection("${collection}").createIndex(${JSON.stringify(key)}, ${JSON.stringify(options)})`)
		});
	} catch (e) { }
});
