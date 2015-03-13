module TP
  class Scanner
    class Error < Struct.new(:line, :column, :msg) ; end

    attr_reader :errors
    def initialize(src="")
      self.scan_setup(src)
    end

    # scan_setup is used by Parser.
    def scan_setup(src)
      @src = src
      self.reset!
      self.next
    end

    def reset!
      @ch = ' '

      @current_line   = 1
      @current_column = 0
      @token_line     = @current_line
      @token_column   = @current_column

      @offset         = 0
      @read_offset    = 0

      @brack = 0
      @paren = 0

      @state  = []
      @errors = []
    end

    def error(msg)
      @errors.push(Error.new(@token_line, @token_column, msg))
    end

    def next
      if @read_offset < @src.length
        @offset = @read_offset
        @ch = @src[@read_offset]
        if @ch == "\n"
          @current_line  += 1
          @current_column = 0
        end
        @read_offset += 1
        @current_column += 1
      else
        @offset = @src.length
        @ch = -1
      end
    end

    def is_digit?(ch)
      return false if ch == -1

      case ch
      when '0','1','2','3','4','5','6','7','8','9'
        return true
      else
        return false
      end
    end

    def is_letter?(ch)
      return false if ch == -1

      case ch
      when 'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
           'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
           '_'
        return true
      else
        return false
      end
    end

    def push_state(state)
      @state.push(state)
    end

    def current_state
      return nil if @state.length == 0

      @state[@state.length-1]
    end

    def skip_whitespace
      while @ch == ' ' || @ch == "\t" || @ch == "\r" || @ch == "\n"
        self.next
      end
    end

    def skip_newlines
      while @ch == '\n'
        self.next
      end
    end

    def scan_attr
      offs = @offset

      while self.is_letter?(@ch) || @ch == "_"
        self.next
      end

      s = @src[offs, (@offset-offs)]
      tok = TP::Token.lookup_attr(s)

      return [tok, s]
    end

    def scan_section
      offs = @offset

      self.next
      while self.is_letter?(@ch)
        self.next
      end

      s = @src[offs, (@offset-offs)]
      tok = TP::Token.lookup_section(s)

      if tok != :IDENT
        self.push_state(tok)
      end

      return [tok, s]
    end

    def scan_identifier
      offs = @offset

      while self.is_letter?(@ch)
        self.next
      end

      return @src[offs, (@offset-offs)]
    end

    def scan_int
      offs = @offset

      while self.is_digit?(@ch)
        self.next
      end

      return @src[offs, (@offset-offs)]
    end

    def pop_state
      raise new ScanError("Cannot pop state") if @state.length == 0

      @state.pop
    end

    def scan_token
      offs = @offset

      while self.is_letter?(@ch) || (@brack > 0 && (@ch == " " || self.is_digit?(@ch)))
        self.next
      end

      if @ch == "/"
        # this could be units like mm/sec
        self.next
        while self.is_letter?(@ch)
          self.next
        end
      end

      s = @src[offs, (@offset-offs)]

      case s
      when "AP_LDR", "RT_LDR"
        # backup
        @offset -= 1
        @read_offset -= 1
        s = @src[offs, (@offset-offs)]
        @ch = @src[@offset]
      end

      if @ch == '['
        tok = Token.lookup_data(s)
      else
        tok = Token.lookup_token(s)
      end

      return [tok, s]
    end

    def scan_string(terminator)
      offs = @offset

      while @ch != terminator && @ch != -1
        if @ch == "\n"
          self.error("string not terminated")
        end

        self.next
      end

      # consume closing terminator
      if @ch == terminator
        self.next
      end

      return @src[offs, (@offset-offs-1)]
    end

    def scan_number
      offs = @offset
      tok = nil
      s = ""

      if @ch == "."
        self.next
        while self.is_digit?(@ch)
          self.next
        end
        tok = :REAL
      else
        while self.is_digit?(@ch)
          self.next
        end

        if @ch == "."
          self.next
          while self.is_digit?(@ch)
            self.next
          end
          tok = :REAL
        else
          tok = :INT
        end
      end

      s = @src[offs, (@offset-offs)]

      return [tok, s]
    end

    def scan_pos_ident
      offs = @offset

      while self.is_letter?(@ch)
        self.next
      end

      s = @src[offs, @offset-offs]
      tok = nil
      if s == "P" && @ch == "["
        tok = :POSITION
      else
        tok = TP::Token.lookup_pos(s)
      end

      return [tok, s]
    end

    # return token
    def next_token
      self.skip_whitespace

      tok = nil
      lit = ""

      @token_line = @current_line
      @token_column = @current_column

      ch = @ch
      return nil if ch == -1

      case self.current_state
      when nil
        case ch
        when "/"
          tok, lit = self.scan_section
        else
          self.next # always make progress
          tok = :ILLEGAL
          lit = ch
        end
      when :SECTION_PROG
        if is_letter?(ch)
          tok = :IDENT
          lit = self.scan_identifier
          self.pop_state
        else
          self.next # always make progress
          tok = :ILLEGAL
          lit = ch
        end
      when :SECTION_ATTR
        if ch == "\n"
          self.skip_newlines
          self.next
          ch = @ch
        end

        if ch == " "
          self.skip_whitespace
          ch = @ch
        end

        if self.is_letter?(ch)
          tok, lit = self.scan_attr
        elsif self.is_digit?(ch)
          tok = :INT
          lit = self.scan_int
        elsif ch == "/"
          self.pop_state
          tok, lit = self.scan_section
        else
          self.next # always make progress
          case ch
          when "="
            tok = :EQL
          when ";"
            tok = :SEMICOLON
          when "\""
            tok = :STRING
            lit = self.scan_string(ch)
          when "-"
            tok = :MINUS
          when ":"
            tok = :COLON
          when ","
            tok = :COMMA
          when "*"
            tok = :MUL
          else
            tok = :ILLEGAL
            lit = ch
          end
        end
      when :SECTION_MN
        if is_letter?(ch)
          tok, lit = self.scan_token
        elsif is_digit?(ch)
          tok, lit = self.scan_number
        elsif ch == "/"
          self.pop_state
          tok, lit = self.scan_section
        else
          self.next
          case ch
          when "["
            tok = :LBRACK
            @brack += 1
          when "]"
            tok = :RBRACK
            if @brack > 0
              @brack -= 1
            else
              self.error("unmatched ]")
            end
          when "("
            tok = :LPAREN
            @paren += 1
          when ")"
            tok = :RPAREN
            if @paren > 0
              @paren -= 1
            else
              self.error("unmatched )")
            end
          when ":"
            tok = :COLON
          when ";"
            tok = :SEMICOLON
          when ","
            tok = :COMMA
          else
            tok = :ILLEGAL
            lit = ch
          end
        end
      when:SECTION_POS
        if ch == "/"
          self.pop_state
          tok, lit = self.scan_section
        elsif self.is_letter?(ch)
          tok, lit = self.scan_pos_ident
        elsif self.is_digit?(ch)
          tok, lit = self.scan_number
        else
          self.next
          case ch
          when "["
            tok = :LBRACK
          when "]"
            tok = :RBRACK
          when ":"
            tok = :COLON
          when '"',"'"
            tok = :STRING
            lit = self.scan_string(ch)
          when "{"
            tok = :LBRACE
          when "}"
            tok = :RBRACE
          when ","
            tok = :COMMA
          when "="
            tok = :EQL
          when "-"
            tok = :MINUS
          when ";"
            tok = :SEMICOLON
          else
            tok = :ILLEGAL
            lit = ch
          end
        end
      else
        self.next # always make progress
        case ch
        when "foo"
          # do something
        else
          tok = :ILLEGAL
          lit = ch
        end
      end

      return [tok, lit]
    end
  end
end
