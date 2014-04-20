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
	Liquid::Template.register_filter(TextFilter)

	class TabCastFeed
	attr_reader :url, :feed, :template
	attr_accessor :prefix, :suffix
	
		def initialize(url, format)
			@url = url
			@items = RSS::Parser.parse(url, false).items
			@template = Liquid::Template.parse(unescape(format))
		end
	
		def formatted
			string = unescape(@prefix)
			@items.each do |i|
				vars = Hash.new
				vars['utime'] = i.pubDate.strftime('%s') if i.pubDate
				vars['title'] = i.title.chomp if i.title
				vars['enclosure_url'] = i.enclosure.url if i.enclosure && i.enclosure.url
				vars['itunes_author'] = i.itunes_author if i.itunes_author
				vars['author'] = i.author if i.author
				vars['guid'] = i.guid if i.guid

				string += @template.render(vars)
			end
			string + unescape(@suffix)
		end

		private

		def unescape(string)
			string.gsub!('\t', "\t")
			string.gsub!('\n', "\n")
			string
		end
	end
end
