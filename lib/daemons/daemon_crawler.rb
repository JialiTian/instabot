#!/usr/bin/env ruby

require 'date'
#You might want to change this
ENV["RAILS_ENV"] ||= "development"

Dir.chdir(File.dirname(__FILE__) + "/../../")
require File.dirname(__FILE__) + "/../../config/environment"

$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do
	arr = Keyword.pluck(:text)
	cooldown = Sleep.first.period
	mediaData = Instagram.user_recent_media("2444722678")
	mediaData.each do |media|
	  commentData = Instagram.media_comments(media.id)
	  commentData.each do |comment|
	    arr.each do |word|
	    	if comment.text.downcase.include?(word)
		      Instagram.delete_media_comment(media.id, comment.id) 
		      createAt =DateTime.strptime(comment.created_time,'%s')
		      Record.create(sender:comment.from.username, time:createAt, keyword:word, text:comment.text, commentid:comment.id, mediaid:media.id)
	    	end
	    end
	  end
	end
	sleep(cooldown)
end