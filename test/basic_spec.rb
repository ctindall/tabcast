require 'fakeweb' #so I can run tests without the feeds changing out from under me all the time
require 'rspec'

require_relative '../lib/tabcast'

@kolurl FakeWeb.register_uri(:get, "http://kol.xml", :response => File.read( File.expand_path( File.dirname( __FILE__ ) + "/docroot/kol.xml")))


describe Tabcast::TabCastFeed do
	describe "#formatted" do
		it "prints item titles" do
			@feed = Tabcast::TabCastFeed.new(@kolurl, '{{utime}}\t{{title | spaces_to_underscores}}\t{{enclosure_url}}\n')
			#TODO actually test something
		end
	end
end
