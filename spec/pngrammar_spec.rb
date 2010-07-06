require_relative 'spec_helper'
require 'tempfile'

# ImageMagick adds metadata to images when resizing them, which foils our
# test. Therefore, to normalise the file, we strip the two date fields.
def strip_dates png
  Tempfile.open('pngrammar') do |tempfile|
    tempfile.print png
    tempfile.close
    return `convert +set date:create +set date:modify png:#{tempfile.path} -`.
        force_encoding('binary')
  end
end

describe PNGrammar do
  it "renders EBNF to PNG" do
    pg = PNGrammar.new('fixtures/hex-literal.ebnf')
    strip_dates(pg.image).should == File.binread('fixtures/hex-literal.png')
  end
end
