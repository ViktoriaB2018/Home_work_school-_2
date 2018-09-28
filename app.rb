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

	#if user_details.valid?
	Client.create [ :name => @username,
					:phone => @phone,
					:datestamp => @date_timee,
					:barber => @select_barber,
					:color => @color ]

	erb "<h4>Thank you for check in!</h4>"
end

