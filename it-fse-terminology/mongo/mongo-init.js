db = db.getSiblingDB("admin");
db.createUser({
    user: "mongoadmin",
    pwd: "secret",
    roles: ["userAdminAnyDatabase", "dbAdminAnyDatabase", "readWriteAnyDatabase"]
})

db = db.getSiblingDB("fse");
db.createUser({
    user: "mongoadmin",
    pwd: "secret",
    roles: [
        { 
            role: "readWrite", 
            db: "fse" 
        }, 
        { 
            role: "read", 
            db: "fse" 
        }
    ], 
    mechanisms: [ "SCRAM-SHA-1","SCRAM-SHA-256" ] 
})