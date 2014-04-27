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
	attr_reader :url, :feed, :template, :prefix, :suffix
	
	
		def initialize(url, format)
			@url = url
			@feed  = RSS::Parser.parse(url, false)
			@template = Liquid::Template.parse(unescape(format))
			@killlist = []
			@guidkilllist = []
		end

		def prefix=(prefixstring)
			@prefix = Liquid::Template.parse(unescape(prefixstring))
		end

		def suffix= (suffixstring)
			@suffix = Liquid::Template.parse(unescape(suffixstring))
		end
	
		def formatted
		vars = {}

		vars['channel_title'] 		= @feed.channel.title 		if @feed.channel.title
		vars['channel_description'] 	= @feed.channel.description 	if @feed.channel.description
		vars['channel_link'] 		= @feed.channel.link 		if @feed.channel.link
		vars['channel_langauge']	= @feed.channel.langauge 	if @feed.channel.langauge

		string = ""
		string += @prefix.render(vars) 
			@feed.items.each do |i|
				unless ( @killlist.include? i.enclosure.url ) or ( @guidkilllist.include? i.guid.to_s )
					if i.pubDate
						vars['utime'] = i.pubDate.strftime('%s') 
					else
						vars['utime'] = nil
					end

					if i.title
						vars['title'] = i.title.chomp
					else
						vars['title'] = nil
					end
					
					if i.enclosure && i.enclosure.url
						vars['enclosure_url'] = i.enclosure.url
					else
						vars['enclosure_url'] = nil
					end
					
					if i.itunes_author
						vars['itunes_author'] = i.itunes_author if i.itunes_author
					else
						vars['itunes_author'] = nil
					end

					if i.author
						vars['author'] = i.author
					else
						vars['guid'] = nil
					end
				
					string += @template.render(vars)
				end
			end
			string += @suffix.render(vars)
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
