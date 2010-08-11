require 'sqlite3'

db = SQLite3::Database.new("db/pie-man.db")
# boot some initial values in the table

=begin
db.execute <<SQL

  CREATE TABLE karma (
   name TEXT,
   karma INTEGER,
   host TEXT PRIMARY KEY
  );
  
SQL

db.execute <<SQL
  INSERT INTO karma VALUES (
  	'bheek', 
  	7,
  	'kitallis@122.161.212.59'
  );
SQL
=end

