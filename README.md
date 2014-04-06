#tabcast

a tool to turn, ugly messy podcast XML into lines of tab-seperated values that are easy to work with on the command line.

##Installation:

1. `gem install liquid`
2. copy the "tabcast" file from this repo into your $PATH

##Usage:

`tabcast <feed url>`

###Advanced Usage:

The default output format is probably fine for most purposes, but you can specify your own output format with the -f flag. This uses [Liquid](http://liquidmarkup.org/)
templating and renders the specified markup for each item in the feed. For example, to get a list of the titles and Unix timestamps of a feed's items, seperated by a pipe character:

`tabcast -f "{{title}}|{{time}}\n" <feed url>`

Note that the default output is equivalent to using:

 `-f "{{utime}}\t{{title | spaces_to_underscores}}\t{{enclosure_url}}\n"`
