require 'sqlite3'

db = SQLite3::Database.new	'barbershop.db'
db.results_as_hash = true

db.execute 'select * from Users' do |row|
	puts "#{row['Name']} \t\t - Имя"
	puts "#{row['DateStamp']} - время записи"
	puts '==================================='
end