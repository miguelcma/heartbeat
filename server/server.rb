require 'sinatra'
require 'time'
require 'json'
require 'dotenv/load'

post '/heartbeat' do
  halt(404) if params[:key] != ENV['API_KEY']

  time = Time.now.utc.iso8601
  File.write(ENV['HEARTBEAT_FILE_PATH'], time, mode: 'w')

  { status: 'ok', timestamp: time }.to_json
end

get '/heartbeat' do
  halt(404) if params[:key] != ENV['API_KEY']

  time = Time.parse File.open(ENV['HEARTBEAT_FILE_PATH']).read

  { timestamp: time }.to_json
rescue Errno::ENOENT
  { error: 'no heartbeat yet' }.to_json
end
