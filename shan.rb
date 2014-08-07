require "net/https"
require "uri"

class Analyzer
  attr_accessor :play

  def initialize
  	@play = Play.new
  	puts "created"
  end
end


class Play
  def intitialize
  	@text = []
  	@characters = {}
  end

  def readPlay (url)
  	# sets the text instance var with an array of strings (one for each line of text read from url) and then returns the number of lines read
  	# http://augustl.com/blog/2010/ruby_net_http_cheat_sheet/
	uri = URI.parse(url)
	http = Net::HTTP.new(uri.host, uri.port)
	request = Net::HTTP::Get.new(uri.request_uri)
	request.initialize_http_header({"User-Agent" => "Shakespeare Analyzer"})

	response = http.request(request)
	@data = response.body
	puts "Response from read Play, num chars:" + @data.length.to_s


  	@data.length
  end

  def makeLines
  	#parse through text array breaking up on all closing tags
  	@text = @data.split('</')
    puts "Number of lines: " + @text.length.to_s
    #puts @text.first 20       #show the first 20 
    @text.length
  end

  def makeChars
  	# Create list of characters in the play
  	@characters = {}
  	@text.each do |line|
  	  pos = line.index('<SPEAKER')
  	  @characters[line[pos+8..-1]] = 0 if pos   # create hash entry with the name being the key and total number of lines set to zero.
  	end
    puts "Total number of characters: " + @characters.length.to_s
    # @characters.each do |char|
    #   puts char
    # end
    
    @characters.length
  end

  def calculateLines
  	speechBlock = false
  	totalLinesProcessed = 0
  	currentSpeaker = ''
 	@text.each do |line|
  	  possp = line.index('<SPEAKER')     # Search for a speaker on this current line
  	  posend = line.index('</SPEECH')     # Search for end
  	  posline = line.index('<LINE')      # Search for a line of text

  	  if possp
  	  	speechBlock = true
  	  	# identify current speaker
  	  	currentSpeaker = line[possp+8..-1]
  	  end
  	  speechBlock = false if posend
  	  if speechBlock && posline && currentSpeaker.length > 0   # If we are in a speech block and we have a line as well as a current speaker
        @characters[currentSpeaker] += 1
        totalLinesProcessed += 1
  	  end
  	end
    puts "Total number of lines processed: " + totalLinesProcessed.to_s      
    return totalLinesProcessed	
  end

  def outputChars
  	count = 0
    @characters.each do |char, lines|
      print char
      print "\t" * (3 - char.length / 8)
      puts "spoke " + lines.to_s + " lines."
      count += 1
    end
    return count 
  end
end

