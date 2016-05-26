#creating a simple recall app using sinatra



require 'sinatra'
require 'data_mapper'
require 'mysql2'

#map the database to the program
DataMapper.setup(:default,"mysql://root:qwertyuio@localhost/mydb")

#Note will be the databse
class Note
  include DataMapper::Resource
  property :id, Serial
  property :content, Text, :required => true
  property :complete, Boolean, :required => true, :default => false
  property :created_at, DateTime
  property :updated_at, DateTime
end

DataMapper.finalize.auto_upgrade!

#Add the notes
get '/' do
  @notes = Note.all :order => :id.desc
  @title = "All notes"
  erb :home
end


#Add and save the notes
post '/' do
  n = Note.new
  n.content = params[:content]
  n.created_at = Time.now
  n.updated_at = Time.now
  n.save
  redirect '/'
end


get '/rss.xml' do
  @notes = Note.all :order => id.desc
  builder :rss
end


#get the notes
get '/:id' do
  @note = Note.get params[:id]
  @title = "Edit note ##{params[:id]}"
  erb :edit
end


#use put to changes/ modifying
put '/:id' do
  n = Note.get params[:id]
  n.content = params[:content]
  n.complete = params[:complete] ? 1 : 0
  n.updated_at = Time.now
  n.save
  # redirected to the home page
  redirect '/'
end


#delete the file
get '/:id/delete' do
  @note = Note.get params[:id]
  @title = "Delete note #{params[:id]}"
  erb :delete
end


delete '/:id' do
  n = Note.get params[:id]
  n.destroy
  redirect '/'
end


get '/:id/complete' do
  n = Note.get params[:id]
  n.complete = params[:complete] ? 1 : 0
  n.updated_at = Time.now
  n.save
  #redirected to the home page
  redirect '/'
end

#avoiding html tags as input
helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end
