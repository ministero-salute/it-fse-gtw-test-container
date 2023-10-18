db = db.getSiblingDB("admin");
db.createUser({
    user: "mongoadmin",
    pwd: "secret",
    roles: ["userAdminAnyDatabase", "dbAdminAnyDatabase", "readWriteAnyDatabase"],
    mechanisms: [ "SCRAM-SHA-1","SCRAM-SHA-256" ]
})