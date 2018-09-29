#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:barbershop.db"

class Client < ActiveRecord::Base
	validates :name, presence: true, length: { minimum: 3 }
	validates :phone, presence: true
	validates :datestamp, presence: true
	validates :color, presence: true
end

class Barber < ActiveRecord::Base
end

class Contact < ActiveRecord::Base
end

before do
	@barbers = Barber.order "created_at DESC"
end

get '/' do
	erb :index			
end

get '/visit' do
	@c = Client.new
	erb :visit
end

post '/visit' do
	
	@c = Client.new params[:client]
	if @c.save
		erb "<h4>Thank you for check in!</h4>"
	else
		@error = @c.errors.full_messages.first
		erb :visit
	end

end

get '/contacts' do
	erb :contacts
end

post '/contacts' do
	@name = params[:name]
	@email = params[:email]
	@textarea = params[:textarea]

	e = Contact.new
	e.name = @name
	e.email = @email
	e.textarea = @textarea
	e.save

		require 'pony'
		Pony.mail(
		  :to => 'vikavebmaster@gmail.com',
		  :subject => params[:name] + " email: " + params[:email] + " wants to contact you",
		  :body => params[:textarea],
		  :via => :smtp,
		  :via_options => { 
		    :address              => 'smtp.gmail.com', 
		    :port                 => '587', 
		    :enable_starttls_auto => true, 
		    :user_name            => 'vikavebmaster', 
		    :password             => '123456789qaRf', 
		    :authentication       => :plain, 
		    :domain               => 'localhost.localdomain'
		  })

		erb "<h4>Thank you for contacting us! We will reply to you as soon as possible.</h4>"

end

get '/barber/:id' do
	@barber = Barber.find(params[:id])
	erb :barber
end

get '/bookings' do
	@clients = Client.order('created_at DESC')
	erb :bookings
end