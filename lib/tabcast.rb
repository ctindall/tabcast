	module TextFilter
		def spaces_to_underscores(input)
			input.gsub(/\s/, '_')
		end
	
		def urlencode(input)
			CGI::escape(input)
		end
	
		def md5(input)
			Digest::MD5.hexdigest(input)
		end
	
		def sha1(input)
			Digest::SHA1.hexdigest(input)
		end
	end

module Tabcast
	require 'open-uri'
	Liquid::Template.register_filter(TextFilter)

	class TabCastFeed
	attr_reader :url, :feed, :template
	attr_accessor :prefix, :suffix
	
		def initialize(url, format)
			@url = url
			@items = RSS::Parser.parse(url, false).items
			@template = Liquid::Template.parse(unescape(format))
			@killlist = []
			@guidkilllist = []
		end
	
		def formatted
			string = unescape(@prefix)
			@items.each do |i|
				unless ( @killlist.include? i.enclosure.url ) or ( @guidkilllist.include? i.guid.to_s )
					vars = Hash.new
					vars['utime'] = i.pubDate.strftime('%s') if i.pubDate
					vars['title'] = i.title.chomp if i.title
					vars['enclosure_url'] = i.enclosure.url if i.enclosure && i.enclosure.url
					vars['itunes_author'] = i.itunes_author if i.itunes_author
					vars['author'] = i.author if i.author
					vars['guid'] = i.guid.to_s if i.guid
				
					string += @template.render(vars)
				end
			end
			string += unescape(@suffix)
			string
		end

		def killfile=(filename)
			@killlist = File.read(File.expand_path(filename)).split("\n")
		end

		def guidkillfile=(filename)
			@guidkilllist = File.read(File.expand_path(filename)).split("\n")
		end

		private

		def unescape(string)
			string.gsub!('\t', "\t")
			string.gsub!('\n', "\n")
			string
		end
	end
end
