require_relative '../test_helper'

class TestScanner < Test::Unit::TestCase
  def setup
    @scanner = TP::Scanner.new
  end

  def assert_token(token)
    assert_equal token, @scanner.next_token[0]
  end

  def assert_pair(token, string)
    pair = @scanner.next_token
    assert_equal token, pair[0]
    assert_equal string, pair[1]
  end

  def assert_state(state)
    assert_equal state, @scanner.current_state
  end

  def test_blank_returns_nil
    @scanner.scan_setup ""
    assert_nil @scanner.next_token
  end

  def test_whitespace_returns_nil
    @scanner.scan_setup " \t\r  "
    assert_nil @scanner.next_token
    assert_equal(-1, @scanner.next)
  end

  def test_initial_state_is_nil
    assert_state nil
  end

  def test_scan_prog
    @scanner.scan_setup "/PROG"
    assert_token :SECTION_PROG
    assert_state :SECTION_PROG
  end

  def test_scan_prog_name
    @scanner.scan_setup "/PROG FOO\n"
    assert_token :SECTION_PROG
    assert_state :SECTION_PROG
    assert_pair :IDENT, "FOO"
    assert_state nil
  end

  def test_scan_attr
    @scanner.scan_setup "/ATTR"
    assert_token :SECTION_ATTR
  end

  def test_scan_attr_section
    @scanner.scan_setup %q(/ATTR
OWNER		= ASCBIN;
COMMENT		= "test";
PROG_SIZE	= 480;
CREATE		= DATE 14-01-02  TIME 23:01:46;
MODIFIED	= DATE 14-01-02  TIME 23:03:58;
FILE_NAME	= ASDF;
VERSION		= 0;
LINE_COUNT	= 1;
MEMORY_SIZE	= 848;
PROTECT		= READ_WRITE;
TCD:  STACK_SIZE	= 0,
      TASK_PRIORITY	= 50,
      TIME_SLICE	= 0,
      BUSY_LAMP_OFF	= 0,
      ABORT_REQUEST	= 0,
      PAUSE_REQUEST	= 0;
DEFAULT_GROUP	= 1,*,*,*,*;
CONTROL_CODE	= 00000000 00000000;
/MN)
    assert_token :SECTION_ATTR
    assert_state :SECTION_ATTR

    assert_token :ATTR_OWNER
    assert_token :EQL
    assert_token :ATTR_ASCBIN
    assert_token :SEMICOLON

    assert_token :ATTR_COMMENT
    assert_token :EQL
    assert_pair :STRING, "test"
    assert_token :SEMICOLON

    assert_token :ATTR_PROG_SIZE
    assert_token :EQL
    assert_pair :INT, "480"
    assert_token :SEMICOLON

    assert_token :ATTR_CREATE
    assert_token :EQL
    assert_token :ATTR_DATE
    assert_pair :INT, "14"
    assert_token :SUB
    assert_pair :INT, "01"
    assert_token :SUB
    assert_pair :INT, "02"
    assert_token :ATTR_TIME
    assert_pair :INT, "23"
    assert_token :COLON
    assert_pair :INT, "01"
    assert_token :COLON
    assert_pair :INT, "46"
    assert_token :SEMICOLON

    assert_token :ATTR_MODIFIED
    assert_token :EQL
    assert_token :ATTR_DATE
    assert_pair :INT, "14"
    assert_token :SUB
    assert_pair :INT, "01"
    assert_token :SUB
    assert_pair :INT, "02"
    assert_token :ATTR_TIME
    assert_pair :INT, "23"
    assert_token :COLON
    assert_pair :INT, "03"
    assert_token :COLON
    assert_pair :INT, "58"
    assert_token :SEMICOLON

    assert_token :ATTR_FILE_NAME
    assert_token :EQL
    assert_pair :IDENT, "ASDF"
    assert_token :SEMICOLON

    assert_token :ATTR_VERSION
    assert_token :EQL
    assert_pair :INT, "0"
    assert_token :SEMICOLON

    assert_token :ATTR_LINE_COUNT
    assert_token :EQL
    assert_pair :INT, "1"
    assert_token :SEMICOLON

    assert_token :ATTR_MEMORY_SIZE
    assert_token :EQL
    assert_pair :INT, "848"
    assert_token :SEMICOLON

    assert_token :ATTR_PROTECT
    assert_token :EQL
    assert_token :ATTR_READ_WRITE
    assert_token :SEMICOLON

    assert_token :ATTR_TCD
    assert_token :COLON
    assert_token :ATTR_STACK_SIZE
    assert_token :EQL
    assert_pair :INT, "0"
    assert_token :COMMA
    assert_token :ATTR_TASK_PRIORITY
    assert_token :EQL
    assert_pair :INT, "50"
    assert_token :COMMA
    assert_token :ATTR_TIME_SLICE
    assert_token :EQL
    assert_pair :INT, "0"
    assert_token :COMMA
    assert_token :ATTR_BUSY_LAMP_OFF
    assert_token :EQL
    assert_pair :INT, "0"
    assert_token :COMMA
    assert_token :ATTR_ABORT_REQUEST
    assert_token :EQL
    assert_pair :INT, "0"
    assert_token :COMMA
    assert_token :ATTR_PAUSE_REQUEST
    assert_token :EQL
    assert_pair :INT, "0"
    assert_token :SEMICOLON

    assert_token :ATTR_DEFAULT_GROUP
    assert_token :EQL
    assert_pair :INT, "1"
    assert_token :COMMA
    assert_token :MUL
    assert_token :COMMA
    assert_token :MUL
    assert_token :COMMA
    assert_token :MUL
    assert_token :COMMA
    assert_token :MUL
    assert_token :SEMICOLON

    assert_token :ATTR_CONTROL_CODE
    assert_token :EQL
    assert_pair :INT, "00000000"
    assert_pair :INT, "00000000"
    assert_token :SEMICOLON

    assert_token :SECTION_MN
    assert_state :SECTION_MN
  end

  def test_data
    TP::Token::DATA.each_key do |string|
      @scanner.scan_setup "/MN\n#{string}\["
      assert_token :SECTION_MN
      assert_token TP::Token::DATA[string]
      assert_token :LBRACK
    end
  end

  def test_tokens
    s = "/MN\n:;"
    TP::Token::TOKENS.each_key do |string|
      s += string + " ;\t\r\n"
    end
    s += "/POS"
    @scanner.scan_setup s
    assert_token :SECTION_MN
    assert_token :COLON
    assert_token :SEMICOLON
    TP::Token::TOKENS.each_value do |tok|
      assert_token tok
      assert_token :SEMICOLON
    end
    assert_token :SECTION_POS
    assert_state :SECTION_POS
  end

  def test_pos_section_with_no_positions
    @scanner.scan_setup "/POS
/END"
    assert_token :SECTION_POS
    assert_token :SECTION_END
  end

  def test_pos_section_with_positions
    @scanner.scan_setup %q(/POS
P[1:"load"]{
  GP1:
 UF : 4, UT : 1,  CONFIG : 'N U T, 0, 0, 0',
 X = 78.446 mm, Y = 377.859 mm, Z = 147.347 mm,
 W = -68.197 deg, P = 88.704 deg, R = -3.196 deg
};
P[2:"via"]{
  GP1:
 UF : 0, UT : 1,  CONFIG : 'N U T, 0, 0, 0',
 X = 1546.0 mm, Y = 979.0 mm, Z = 534.0 mm,
 W = -94.26 deg, P = 87.976 deg, R = 0.0 deg
};)
    assert_token :SECTION_POS
    assert_token :POSITION
    assert_token :LBRACK
    assert_pair :INT, "1"
    assert_token :COLON
    assert_pair :STRING, "load"
    assert_token :RBRACK
    assert_token :LBRACE

    assert_token :GP
    assert_pair :INT, "1"
    assert_token :COLON
    assert_token :UF
    assert_token :COLON
    assert_pair :INT, "4"
    assert_token :COMMA

    assert_token :UT
    assert_token :COLON
    assert_pair :INT, "1"
    assert_token :COMMA

    assert_token :CONFIG
    assert_token :COLON
    assert_pair :STRING, 'N U T, 0, 0, 0'
    assert_token :COMMA

    assert_token :X
    assert_token :EQL
    assert_pair :REAL, "78.446"
    assert_token :MM
    assert_token :COMMA

    assert_token :Y
    assert_token :EQL
    assert_pair :REAL, "377.859"
    assert_token :MM
    assert_token :COMMA

    assert_token :Z
    assert_token :EQL
    assert_pair :REAL, "147.347"
    assert_token :MM
    assert_token :COMMA

    assert_token :W
    assert_token :EQL
    assert_token :SUB
    assert_pair :REAL, "68.197"
    assert_token :DEG
    assert_token :COMMA

    assert_token :P
    assert_token :EQL
    assert_pair :REAL, "88.704"
    assert_token :DEG
    assert_token :COMMA

    assert_token :R
    assert_token :EQL
    assert_token :SUB
    assert_pair :REAL, "3.196"
    assert_token :DEG

    assert_token :RBRACE
    assert_token :SEMICOLON

    assert_token :POSITION
  end

  def test_silly_tokens
    # i wish FANUC separated their tokens!
    @scanner.scan_setup %q(/MN ACC100 AP_LD50 AP_LDR[1] RT_LD50 RT_LDR[1])
    assert_token :SECTION_MN
    assert_token :ACC
    assert_pair :INT, "100"
    assert_token :AP_LD
    assert_pair :INT, "50"
    assert_token :AP_LD
    assert_token :NUMREG
    assert_token :LBRACK
    assert_pair :INT, "1"
    assert_token :RBRACK
    assert_token :RT_LD
    assert_pair :INT, "50"
    assert_token :RT_LD
    assert_token :NUMREG
    assert_token :LBRACK
    assert_pair :INT, "1"
    assert_token :RBRACK
  end

  def test_scan_data_with_comment
    @scanner.scan_setup %q(/MN R[:foo bar12])
    assert_token :SECTION_MN
    assert_token :NUMREG
    assert_token :LBRACK
    assert_token :COLON
    assert_pair :IDENT, "foo bar12"
    assert_token :RBRACK
  end

  def test_nested_data
    @scanner.scan_setup %q(/MN R[R[R[1]]])
    assert_token :SECTION_MN
    assert_token :NUMREG
    assert_token :LBRACK
    assert_token :NUMREG
    assert_token :LBRACK
    assert_token :NUMREG
    assert_token :LBRACK
    assert_pair :INT, "1"
    assert_token :RBRACK
    assert_token :RBRACK
    assert_token :RBRACK
  end

  def test_punctuation
    @scanner.scan_setup "/MN () \n [],;: = <> < > <= >= ! - + / * %"
    assert_token :SECTION_MN
    assert_token :LPAREN
    assert_token :RPAREN
    assert_token :LBRACK
    assert_token :RBRACK
    assert_token :COMMA
    assert_token :SEMICOLON
    assert_token :COLON
    assert_token :EQL
    assert_token :NEQL
    assert_token :LT
    assert_token :GT
    assert_token :LTE
    assert_token :GTE
    assert_token :NOT
    assert_token :SUB
    assert_token :ADD
    assert_token :QUO
    assert_token :MUL
    assert_token :PERCENT
    assert_nil @scanner.next_token
  end

  def test_unmatched_paren_error
    @scanner.scan_setup "/MN ())"
    while @scanner.next_token != nil ; end
    assert_equal "unmatched )", @scanner.errors.first.msg
  end

  def test_unmatched_brack_error
    @scanner.scan_setup "/MN []]"
    while @scanner.next_token != nil ; end
    assert_equal "unmatched ]", @scanner.errors.first.msg
  end

  def test_scan_comment
    @scanner.scan_setup "/MN : ! foo;"
    assert_token :SECTION_MN
    assert_token :COLON
    assert_pair :COMMENT, " foo"
  end

   def test_scan remark
     @scanner.scan_setup "/MN : // foo;"
     assert_token :SECTION_MN
     assert_token :COLON
     assert_pair :REMARK, " foo"
   end

  def test_scan_string
    @scanner.scan_setup "/MN 'foo bar'"
    assert_token :SECTION_MN
    assert_pair :STRING, "foo bar"
  end

  def test_scan_sysvars
    @scanner.scan_setup "/MN $foo $foo.$bar $foo[1] $foo[1].$bar[3]"
    assert_token :SECTION_MN
    assert_pair :SYSVAR, "$foo"
    assert_pair :SYSVAR, "$foo.$bar"
    assert_pair :SYSVAR, "$foo[1]"
    assert_pair :SYSVAR, "$foo[1].$bar[3]"
  end

  def test_scan_real_with_no_leading_zero
    @scanner.scan_setup "/MN .05"
    assert_token :SECTION_MN
    assert_pair :REAL, ".05"
  end

end
