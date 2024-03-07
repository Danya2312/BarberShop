require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'pony'
require 'pg'

def get_db
  return PG::Connection.new( dbname: 'BarberShop', port: 5432, password: 'postgres', user: 'postgres', host: 'localhost' )
end

configure do 
	db = get_db
	db.exec 'CREATE TABLE IF NOT EXISTS 
	Users 
	(
	id Serial PRIMARY KEY,
	username Varchar,
	phone Varchar,
	datestamp Varchar,
	barber Varchar,
	color Varchar
)'

end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

	hh = { :username => 'Введите имя',
		   :phone => 'Введите телефон',
		   :datetime => 'Введите дату и время' }

	hh.each do |key, value|
		# если параметр пуст
		if params[key] == ''
			# переменной error присвоить value из хеша hh
			# (а value из хеша hh это сообщение об ошибке)
			# т.е переменной error присвоить сообщение об ошибке
			@error = hh[key]

			# вернуть представление visit
			return erb :visit
		end
	end

	db = get_db
	db.exec 'insert into 
		Users
		(
			username,
			phone,
			datestamp,
			barber,
			color
			)
			values ( $1, $2, $3, $4, $5 )', [@username, @phone, @datetime, @barber, @color]

	erb "OK, username is #{@username}, #{@phone}, #{@datetime}, #{@barber}, #{@color}"
end

get '/showusers' do 
	db = get_db
	@results = db.exec 'Select * from Users order by id desc'
#	erb "<%= @s.each {|row| row } %>"
	erb :showusers

end


get '/contacts' do
	erb :contacts
end

post '/contacts' do
	@email = params[:email]
	@textarea = params[:textarea]

	 Pony.mail(:to => "#{@email}", :subject => "#{@textarea}")

	 erb "Ваше сообщение успешно доставлено"
	
end