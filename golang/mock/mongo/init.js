db.createUser(
  {
    user: "mock",
    pwd: "password",
    roles: [
      { role: "readWrite", db: "Example" }
    ]
  }
);

load("./docker-entrypoint-initdb.d/collection/Example.js");
load("./docker-entrypoint-initdb.d/data/Example.js");
