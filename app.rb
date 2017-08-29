#encoding: utf-8
require 'sqlite3'
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

def get_db
	return SQLite3::Database.new 'barbershop.db'
end 

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS
		"Users"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"Name" TEXT,
			"Phone" TEXT,
			"DateStamp" TEXT,
			"Barber" TEXT,
			"Color" TEXT
		)'
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
			Name,
			Phone,
			DateStamp,
			Barber,
			Color
		)
		values (?, ?, ?, ?, ?)', [@user_name, @user_phone, @user_time, @barber, @color]

	erb "Данные: Имя - #{@user_name}, Телефон: #{@user_phone}, Время записи: #{@user_time}, Парикмахер: #{@barber}"

end

get '/showusers' do
  "Hello World"
end

get '/contacts' do
	erb :contacts
end