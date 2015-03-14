require_relative '../test_helper'

class TestParser < Test::Unit::TestCase
  def setup
    @scanner = TP::Scanner.new
    @parser  = TP::Parser.new(@scanner)
  end

  def parse(src)
    @scanner.scan_setup(src)
    @parser.parse
  end

  def test_parse_minimum_program
    program = parse("/PROG FOO
/ATTR
/MN
 : ;
/END")
    assert_equal "FOO", program.name
  end

  def test_parse_test_file
    file = File.open(File.join(File.dirname(__FILE__), "..", "fixtures", "test.ls"))

    src = file.read
    file.close

    parse(src)
  end
end
