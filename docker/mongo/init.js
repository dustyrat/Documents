db.createUser(
  {
    user: "sa",
    pwd: "sa",
    roles: [
      "dbOwner"
    ]
  }
);

load("./docker-entrypoint-initdb.d/collection/Test.js");
load("./docker-entrypoint-initdb.d/data/Test.js");
