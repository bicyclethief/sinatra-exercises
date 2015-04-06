
require 'rubygems'
require 'bundler/setup'
require 'sinatra/activerecord'
require 'sinatra'
require 'alphadecimal'

set :database, {adapter: "sqlite3", database: "development.sqlite3"}

class ShortenedUrl < ActiveRecord::Base
  validates_uniqueness_of :url
  validates_presence_of :url
  validates_format_of :url, :with => /^\b((?:https?:\/\/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))$/, :multiline => true

  def shorten
    self.id.alphadecimal
  end

  def self.find_by_shortened(shortened)
    find(shortened.alphadecimal)
  end
end

get '/' do
  haml :index
end

post '/' do
  @short_url = ShortenedUrl.find_by_url(params[:url]) ||
               ShortenedUrl.create(url: params[:url])
  if @short_url.valid?
    haml :success
  else
    haml :index
  end
end

get '/:shortened' do
  short_url = ShortenedUrl.find_by_shortened(params[:shortened])
  redirect short_url.url
end
