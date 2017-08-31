#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db, name
	db.execute('select * from Barbers where name=?', [name]).length > 0
end

def seed_db db, barbers
	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute 'insert into Barbers (name) values (?)', [barber]
		end
	end
end

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true

	return db
end

before do
	db = get_db
	@barbers = db.execute 'select * from Barbers'
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS
		"Users"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"ClientName" TEXT,
			"Phone" TEXT,
			"DateStamp" TEXT,
			"Barber" TEXT,
			"Color" TEXT
		)'

	db.execute 'CREATE TABLE IF NOT EXISTS
	"Barbers"
	(
		"id" INTEGER PRIMARY KEY AUTOINCREMENT,
		"name" TEXT
	)'

	seed_db db, ['Александр Евгеньевич', 'Лев Александрович', 'Дарья Олеговна', 'Олег Евгеньевич', 'Елена Георгиевна']
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	@error = 'Something wrong!'
	erb :about
end

get '/visit' do
	erb :visit
end

post '/visit' do
	@user_name = params[:user_name]
	@user_phone = params[:user_phone]
	@user_time = params[:user_time]
	@barber = params[:barber]
	@color = params[:color]

	hh = {
		:user_name => "Введите имя",
	    :user_phone => "Введите телефон",
	    :user_time => "Введите дату и время"}

	@error = hh.select{|key,values| params[key] ==""}.values.join(", ")

	if @error != ''
		return erb :visit
	end

	db = get_db
	db.execute 'insert into
		Users
		(
			ClientName,
			Phone,
			DateStamp,
			Barber,
			Color
		)
		values (?, ?, ?, ?, ?)', [@user_name, @user_phone, @user_time, @barber, @color]

	erb "<h2>Спасибо! Вы записались.</h2>"
end

get '/showusers' do
	db = get_db
	db.results_as_hash = true
	@results = db.execute 'select * from Users order by id desc'

	erb :showusers
end

get '/contacts' do
	erb :contacts
end