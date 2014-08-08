require './spec_helper'

#module ShakespeareAnalyzer
describe Analyzer do 
   before :each do
     @analyzer = Analyzer.new
   end	
 
   describe "#new" do
   	it "returns a new analyzer object" do
   	  @analyzer.should be_an_instance_of Analyzer
   	end
   	it "analyzer has an instance of Play" do
   	  @analyzer.play.should be_an_instance_of Play
   	end   	
   end

   describe "#readPlay" do
   	it "returns the number of chars read from the Macbeth play url" do
      @analyzer.play.readPlay('http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml').should > 1000
   	end
   	it "returns the number of lines read from the webpage, broken up by closing tag" do
   	  @analyzer.play.readPlay('http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml')
      @analyzer.play.makeLines.should > 0
   	end   	
   	it "returns the number of characters in the play" do
   	  @analyzer.play.readPlay('http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml')
      @analyzer.play.makeLines
      @analyzer.play.makeChars.should > 0
   	end      	
   	it "returns the number of total spoken lines processed when calculating lines for each character" do
   	  @analyzer.play.readPlay('http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml')
      @analyzer.play.makeLines
      @analyzer.play.makeChars
      @analyzer.play.calculateLines > 0
   	end    	 
   	it "shows the number of lines spoken for all characters in the play" do
   	  @analyzer.play.readPlay('http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml')
      @analyzer.play.makeLines
      numChars = @analyzer.play.makeChars
      @analyzer.play.calculateLines
      @analyzer.play.outputChars.should == numChars 
   	end     	  	
   end
end