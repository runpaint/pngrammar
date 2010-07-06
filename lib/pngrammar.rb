require 'tempfile'
require 'mechanize'

class PNGrammar
  attr_reader :ebnf, :ua
  URL = "http://www-cgi.uni-regensburg.de/~brf09510/syntax.html"
  def initialize(file)
    @ebnf = File.read(file).gsub(/\n/,' ')
    @ua = Mechanize.new
  end

  def image
    resize_image ua.get_file(results.at('img')['src'])
  end

  def results
    @results ||= ua.get(URL).forms.first.tap do |f| 
      f['ssyntax'] = ebnf
      f['width'] = 1000
    end.submit.parser
  end

  def resize_image(png)
    Tempfile.open('pngrammar') do |tempfile|
      tempfile.print png
      tempfile.close
      return begin
        `convert png:#{tempfile.path} -strip -trim -bordercolor White -border 10x10 -`
      rescue Errno::ENOENT
        tempfile.read
      end.force_encoding('binary')
    end
  end
end
