require 'twilio-ruby'
require 'sinatra'
require 'json'
require 'net/http'

account_sid = 'AC4c942e8e65199b762846fa63c15ef7be'
auth_token = '0f6e736a0cd9f3ea6b992714efc169cd'
client = Twilio::REST::Client.new account_sid, auth_token 

def what_played
	uri = URI('http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=bbcradio1&api_key=dc9fd34e42449b66f86e39aa8b77f230&format=json')
	response = Net::HTTP.get(uri)
	
	ruby_hash = JSON.parse(response)
	
	{ artist: ruby_hash['recenttracks']['track'][0]['artist']['#text'],
	  track: ruby_hash['recenttracks']['track'][0]['name'] }
end
 

get '/player' do 
	client.account.messages.create(to: "+447988799279", from: "+441274271478", body: "the contents of your message")
end 

get '/player_say' do 
	client.account.calls.create(to: "+447988799279", from: "+441274271478", url: "https://74095107.ngrok.com/player_say")
end

post '/player' do 
	recent_tune = what_played
	content_type 'text/xml'
	"<Response>
		<Message>You listened to #{recent_tune[:track]} by #{recent_tune[:artist]} </Message>
	 </Response>"
end 

post '/player_say' do 
	recent_tune = what_played
	content_type 'text/xml'
	"<Response>
		<Say>You listened to #{recent_tune[:track]} by #{recent_tune[:artist]} </Say>
	 </Response>"
end 


