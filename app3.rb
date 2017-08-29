require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do
	@db = SQLite3::Database.new 'barbershop.db'
	@db.execute 'CREATE TABLE IF NOT EXISTS 
		"Users" 
		(
			"Id" INTEGER PRIMARY KEY AUTOINCREMENT, 
			"Name" TEXT, 
			"Phone" TEXT, 
			"Data_stapm" TEXT, 
			"Barber" TEXT,
			"Color" TEXT
		)'
end

