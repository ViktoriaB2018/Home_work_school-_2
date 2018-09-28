#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:barbershop.db"

class Client < ActiveRecord::Base
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
	erb :visit
end

get '/contacts' do
	erb :contacts
end

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@date_time = params[:date_time]
	@select_barber = params[:select_barber]
	@color = params[:color]

	#if @username.valid? & 
	c = Client.new
	c.name = @username
	c.phone = @phone
	c.datestamp = @date_time
	c.barber = @select_barber
	c.color = @color
	c.save

	erb "<h4>Thank you for check in!</h4>"
	#else
	#erb :visit, locals: {
      #  @error = "Your details could not be saved, please try again."
    #  }
   # end
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
