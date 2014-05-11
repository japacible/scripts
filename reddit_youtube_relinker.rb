# by n0xin
# try to link a given reddit comment to a YouTube video
# only looks at top-level comments
# will pull a direct YouTube link out if exists
# otherwise, will count on the majik of Google's "I'm Feeling Lucky" + Video search

require 'json'
require 'open-uri'

# read the comments LIKE A BAWS
contents = open("http://www.reddit.com/r/running/comments/21c8u5/when_this_song_hits_your_ipod_you_explode_with.json?limit=500").read

# or could save contents to a local file and read it thataway
# if that's what you're in to...
#contents = File.read('songs.json')

# parse out that JSON
raw_songs = JSON.parse(contents, :max_nesting => 100).last["data"]["children"]

# gonna remember list of songs we pull out of the raw comments
parsed_songs = []

# go through each top-level comment
raw_songs.each do |song|
  # reddit sez ...
  body = song["data"]["body"]

  # o btw skip if nae grood
  next if body.nil?

  # take first line of comment
  # ignore other lines, assuming they are pontificating
  body = body.include?("\n") ? body.split("\n")[0] : body

  # check for existing URL in the contents
  url = body.scan(/(https?:\/\/[^\s\)]+)/).first

  unless url.nil?
    # found a URL in the body
    
    # scan is weird ... so need to dig deeper otherwise response is an array
    url = url.first unless url.nil?

    # ok, now we need to get rid of the evidence . . .
    # remove the []s around the reddit link text as well as the URL in the ()s
    body.gsub!(/\[([^\]]+)\]\s*\([^\)]+\)/, '\1')
  else
    # if the comment did not already have a url in it, we'll do a majik Google Video search

    # but first -- strip all non-alphanumericz
    # why ? because they can affect the Google search
    # example was "Pearl Jam -Green Disease" talking about chrons...
    # go ahead, try it: https://encrypted.google.com/search?q=Pearl%20Jam%20-Green%20Disease&btnI&tbm=vid
    clean_body = body.gsub(/[^a-zA-Z1-9\s]/, ' ').gsub(/\s\s+/, ' ')

    # encode comment content for URL and stick into a majik Google search
    # btnI -- "I'm Feeling Lucky" search = auto-forward to top result
    # tbm=vid -- video search (not web results)
    url = "https://encrypted.google.com/search?q=#{URI::encode(clean_body)}&btnI&tbm=vid"
  end

  # save results so can then output them laterz
  parsed_songs << { text: body, url: url, length: (body.length + url.length) }
end

# save to an HTML file locally so can sanity-check during debugging
File.open("running-songs.html", 'w') do |f|
  parsed_songs.each do |song|
    f.write('<li><a href="' + song[:url] + '">' + song[:text] + '</li>')
  end
  f.write("</ul>")
end

# reddit has a 10,000 character limit, so we'll just be safe and call that 40 songs per post
# create separate flatfiles formatted and ready to post as a reddit comment
parsed_songs.each_slice(40).to_a.each_with_index do |slice, index|
  File.open("running-songs-#{index}.reddit", 'w') do |f|
    slice.each do |song|
      f.puts ' * [' + song[:text] + '](' + song[:url] + ')'
    end
  end
end


