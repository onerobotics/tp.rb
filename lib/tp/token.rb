module TP
  class Token
    ATTR_TOKENS = {
      "ABORT_REQUEST" => :ATTR_ABORT_REQUEST,
      "ASCBIN"        => :ATTR_ASCBIN,
      "BUSY_LAMP_OFF" => :ATTR_BUSY_LAMP_OFF,
      "COMMENT"       => :ATTR_COMMENT,
      "CONTROL_CODE"  => :ATTR_CONTROL_CODE,
      "CREATE"        => :ATTR_CREATE,
      "DATE"          => :ATTR_DATE,
      "DEFAULT_GROUP" => :ATTR_DEFAULT_GROUP,
      "FILE_NAME"     => :ATTR_FILE_NAME,
      "LINE_COUNT"    => :ATTR_LINE_COUNT,
      "MEMORY_SIZE"   => :ATTR_MEMORY_SIZE,
      "MODIFIED"      => :ATTR_MODIFIED,
      "OWNER"         => :ATTR_OWNER,
      "PAUSE_REQUEST" => :ATTR_PAUSE_REQUEST,
      "PROG_SIZE"     => :ATTR_PROG_SIZE,
      "PROTECT"       => :ATTR_PROTECT,
      "READ_WRITE"    => :ATTR_READ_WRITE,
      "STACK_SIZE"    => :ATTR_STACK_SIZE,
      "TASK_PRIORITY" => :ATTR_TASK_PRIORITY,
      "TCD"           => :ATTR_TCD,
      "TIME"          => :ATTR_TIME,
      "TIME_SLICE"    => :ATTR_TIME_SLICE,
      "VERSION"       => :ATTR_VERSION,
    }

    SECTION_TOKENS = {
      "/PROG" => :SECTION_PROG,
      "/ATTR" => :SECTION_ATTR,
      "/MN"   => :SECTION_MN,
      "/POS"  => :SECTION_POS,
      "/END"  => :SECTION_END
    }

    DATA = {
      "AR"             => :ARG,
      "AI"             => :AI,
      "AO"             => :AO,
      "DI"             => :DI,
      "DO"             => :DO,
      "F"              => :FLAG,
      "GI"             => :GI,
      "GO"             => :GO,
      "LBL"            => :LBL,
      "P"              => :POSITION,
      "PR"             => :POSREG,
      "R"              => :NUMREG,
      "RI"             => :RI,
      "RO"             => :RO,
      "RSR"            => :RSR,
      "SR"             => :SREG,
      "TIMER"          => :TIMER,
      "TIMER_OVERFLOW" => :TIMER_OVERFLOW,
      "UALM"           => :UALM,
    }

    TOKENS = {
      "ABORT"         => :ABORT,
      "ACC"           => :ACC,
      "AND"           => :AND,
      "AP_LD"         => :AP_LD,
      "C"             => :C,
      "CALL"          => :CALL,
      "CONDITION"     => :CONDITION,
      "CNT"           => :CNT,
      "DA"            => :DA,
      "DB"            => :DB,
      "DISABLE"       => :DISABLE,
      "DIV"           => :DIV,
      "DOWNTO"        => :DOWNTO,
      "ELSE"          => :ELSE,
      "ENABLE"        => :ENABLE,
      "END"           => :END,
      "ENDFOR"        => :ENDFOR,
      "ERROR_PROG"    => :ERROR_PROG,
      "FINDSTR"       => :FINDSTR,
      "FINE"          => :FINE,
      "FOR"           => :FOR,
      "IF"            => :IF,
      "INC"           => :INC,
      "J"             => :J,
      "JPOS"          => :JPOS,
      "JMP"           => :JMP,
      "L"             => :L,
      "LOCK"          => :LOCK,
      "LPOS"          => :POS,
      "max_speed"     => :MAX_SPEED,
      "MOD"           => :MOD,
      "MONITOR"       => :MONITOR,
      "OFF"           => :OFF,
      "OFFSET"        => :OFFSET,
      "Offset"        => :Offset,
      "ON"            => :ON,
      "OR"            => :OR,
      "OVERRIDE"      => :OVERRIDE,
      "PAUSE"         => :PAUSE,
      "PAYLOAD"       => :PAYLOAD,
      "POINT_LOGIC"   => :POINT_LOGIC,
      "PREG"          => :PREG,
      "PTH"           => :PTH,
      "PULSE"         => :PULSE,
      "RESUME_PROG"   => :RESUME_PROG,
      "RT_LD"         => :RT_LD,
      "RUN"           => :RUN,
      "SELECT"        => :SELECT,
      "SKIP"          => :SKIP,
      "Skip"          => :Skip,
      "STOP_TRACKING" => :STOP_TRACKING,
      "STRLEN"        => :STRLEN,
      "SUBSTR"        => :SUBSTR,
      "TA"            => :TA,
      "TB"            => :TB,
      "TIMEOUT"       => :TIMEOUT,
      "TO"            => :TO,
      "TOOL_OFFSET"   => :TOOL_OFFSET,
      "Tool_Offset"   => :Tool_Offset,
      "UFRAME_NUM"    => :UFRAME_NUM,
      "UNLOCK"        => :UNLOCK,
      "UTOOL_NUM"     => :UTOOL_NUM,
      "VOFFSET"       => :VOFFSET,
      "VREG"          => :VREG,
      "WAIT"          => :WAIT,

      "cm/sec"        => :CM_SEC,
      "deg/sec"       => :DEG_SEC,
      "mm"            => :MM,
      "mm/sec"        => :MM_SEC,
      "msec"          => :MSEC,
      "sec"           => :SEC,
    }

    POS_TOKENS = {
      "GP"     => :GP,
      "CONFIG" => :CONFIG,
      "UF"     => :UF,
      "UT"     => :UT,
      "X"      => :X,
      "Y"      => :Y,
      "Z"      => :Z,
      "W"      => :W,
      "P"      => :P,
      "R"      => :R,
      "mm"     => :MM,
      "deg"    => :DEG
    }

    OPERATORS = {
      "="  => :EQL,
      "<>" => :NEQL,
      "!"  => :NOT,
      "<"  => :LT,
      "<=" => :LTE,
      ">"  => :GT,
      ">=" => :GTE
    }

    class << self
      def lookup(string, hash)
        hash[string] || :IDENT
      end

      def lookup_attr(string)
        lookup(string, ATTR_TOKENS)
      end

      def lookup_section(string)
        lookup(string, SECTION_TOKENS)
      end

      def lookup_token(string)
        lookup(string, TOKENS)
      end

      def lookup_data(string)
        lookup(string, DATA)
      end

      def lookup_pos(string)
        lookup(string, POS_TOKENS)
      end
    end
  end
end
