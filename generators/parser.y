class TP::Parser
token SECTION_PROG SECTION_ATTR SECTION_APPL SECTION_MN
token SECTION_POS SECTION_END

token IDENT STRING INT REAL

token ATTR_ABORT_REQUEST ATTR_ASCBIN ATTR_BUSY_LAMP_OFF ATTR_COMMENT
token ATTR_CONTROL_CODE ATTR_CREATE ATTR_DATE ATTR_DEFAULT_GROUP
token ATTR_FILE_NAME ATTR_LINE_COUNT ATTR_MEMORY_SIZE ATTR_MODIFIED
token ATTR_OWNER ATTR_PAUSE_REQUEST ATTR_PROG_SIZE ATTR_PROTECT
token ATTR_READ_WRITE ATTR_STACK_SIZE ATTR_TASK_PRIORITY ATTR_TCD
token ATTR_TIME ATTR_TIME_SLICE ATTR_VERSION

token ARG AI AO DI DO FLAG GI GO LBL POSITION POSREG NUMREG RI RO
token RSR SREG TIMER TIMER_OVERFLOW UALM VR UFRAME UTOOL

token ABORT ACC AND AP_LD C CALL CONDITION CNT DA DB DISABLE DIV
token DOWNTO ELSE ENABLE END ENDFOR ERROR_PROG FINDSTR FINE FOR IF
token INC J JPOS JMP L LOCK LPOS MAX_SPEED MOD MONITOR OFF OFFSET
token Offset ON OR OVERRIDE PAUSE PAYLOAD POINT_LOGIC PREG PTH
token PULSE RESUME_PROG RT_LD RUN SELECT SKIP Skip STOP_TRACKING
token STRLEN SUBSTR TA TB TIMEOUT TO TOOL_OFFSET Tool_Offset
token UFRAME_NUM UNLOCK UTOOL_NUM VOFFSET VREG WAIT

token COMMENT SYSVAR REMARK

token CM_MIN DEG_SEC MM MM_SEC MSEC SEC

token GP CONFIG UF UT X Y Z W P R MM DEG

token EQL NEQL NOT LT LTE GT GTE SUB ADD MUL DIV QUO

token LBRACK RBRACK LBRACE RBRACE LPAREN RPAREN
token COLON COMMA ILLEGAL SEMICOLON PERCENT

prechigh
  right NOT
  left MUL QUO DIV MOD
  left ADD SUB
  left GT GTE LT LTE
  left EQL NEQL
  left AND
  left OR
preclow


rule

  program
    : SECTION_PROG IDENT
      attr_section
      appl_section
      mn_section
      pos_section
      SECTION_END       {
                          result = Program.new(val[1], val[2], val[3], val[4], val[5])
                        }
    ;

  attr_section
    : SECTION_ATTR
      attributes        { result = val[1] }
    | SECTION_ATTR      { result = {} }
    |                   { result = {} }
    ;

  attributes
    : attribute SEMICOLON
                        { result = val[0] }
    | attributes attribute SEMICOLON
                        { result = val[0].merge(val[1]) }
    ;

  attribute
    : ATTR_OWNER EQL ATTR_ASCBIN
                        { result = { val[0] => val[2] } }
    | ATTR_COMMENT EQL STRING
                        { result = { val[0] => val[2] } }
    | ATTR_PROG_SIZE EQL INT
                        { result = { val[0] => val[2] } }
    | ATTR_CREATE EQL date_time
                        { result = { val[0] => val[2] } }
    | ATTR_MODIFIED EQL date_time
                        { result = { val[0] => val[2] } }
    | ATTR_FILE_NAME EQL IDENT
                        { result = { val[0] => val[2] } }
    | ATTR_VERSION EQL INT
                        { result = { val[0] => val[2] } }
    | ATTR_LINE_COUNT EQL INT
                        { result = { val[0] => val[2] } }
    | ATTR_MEMORY_SIZE EQL INT
                        { result = { val[0] => val[2] } }
    | ATTR_PROTECT EQL ATTR_READ_WRITE
                        { result = { val[0] => val[2] } }
    | ATTR_TCD COLON ATTR_STACK_SIZE EQL INT COMMA
        ATTR_TASK_PRIORITY EQL INT COMMA
        ATTR_TIME_SLICE EQL INT COMMA
        ATTR_BUSY_LAMP_OFF EQL INT COMMA
        ATTR_ABORT_REQUEST EQL INT COMMA
        ATTR_PAUSE_REQUEST EQL INT
                        { result = {
                                     val[0] => {
                                       val[2] => val[4],
                                       val[6] => val[8],
                                       val[10] => val[12],
                                       val[14] => val[16],
                                       val[18] => val[20],
                                       val[22] => val[24]
                                     }
                                   }
                        }
    | ATTR_DEFAULT_GROUP EQL group_mask
                        { result = { val[0] => val[2] } }
    | ATTR_CONTROL_CODE EQL INT INT
                        { result = { val[0] => [val[2], val[3]] } }
    ;

  group_mask
    : int_or_mul COMMA int_or_mul COMMA
      int_or_mul COMMA int_or_mul COMMA
      int_or_mul
                        { result = [val[0],val[2],val[4],val[6]] }
    ;

  int_or_mul
    : INT
    | MUL
    ;

  date_time
    : ATTR_DATE INT SUB INT SUB INT
      ATTR_TIME INT COLON INT COLON INT
    ;

  appl_section
    : SECTION_APPL # TODO: implement
    | # this section is optional
    ;

  mn_section
    : SECTION_MN
      lines             { result = val[1] }
    ;

  lines
    : line              { result = [val[0]] }
    | lines line        { result = val[0].push(val[1]) }
    ;

  line
    : COLON statement SEMICOLON
                        { result = Statement.new(val[1]) }
    ;

  statement
    : # could be empty
    | COMMENT           { result = Comment.new(val[0]) }
    | label_stmt
    | jump_stmt
    | call_stmt
    | run_stmt
    | numreg_assignment
    | posreg_assignment
    | component_assignment
    | boolean_output_assignment
    | if_stmt
    | select_stmt
    | wait_stmt
    | rsr_stmt
    | ualm_stmt
    | override_stmt
    | sysvar_assignment
    | REMARK            { result = Remark.new(val[0]) }
    | skip_stmt
    | payload_stmt
    | STOP_TRACKING     { result = StopTrackingStmt.new }
    | offset_condition_stmt
    | uframe_num_stmt
    | utool_num_stmt
    | uframe_assignment
    | utool_assignment
    | PAUSE
    | ABORT
    | END
    | error_prog_stmt
    | resume_prog_stmt
    | for_stmt
    | ENDFOR
    | lock_stmt
    | monitor_stmt
    | motion_stmt
    | gout_assignment
    ;

  gout_assignment
    : gout EQL numeric
    ;

  motion_stmt
    : joint_motion_stmt
    | linear_motion_stmt
    ;

  linear_motion_stmt
    : L destination int_or_numreg linear_units termination motion_modifiers
    | L destination MAX_SPEED termination motion_modifiers
    ;

  joint_motion_stmt
    : J destination int_or_numreg joint_units termination motion_modifiers
    ;

  motion_modifiers
    : # optional
    | actual_modifiers
    ;

  actual_modifiers
    : motion_modifier
    | actual_modifiers motion_modifier
    ;

  motion_modifier
    : acc_modifier
    | ld_modifier
    | skip_modifier
    | offset_modifier
    | voffset_modifier
    | INC
    | PTH
    | toffset_modifier
    | time_modifier
    | distance_modifier
    ;

  time_modifier
    : times real_or_numreg SEC COMMA time_action
    ;

  distance_modifier
    : distances real_or_numreg MM COMMA time_action
    ;

  distances
    : DA
    | DB
    ;

  times
    : TA
    | TB
    ;

  real_or_numreg
    : real
    | numreg
    ;

  time_action
    : call_stmt
    | boolean_output_assignment
    | gout EQL numeric
    | aout EQL real
    | POINT_LOGIC
    ;

  toffset_modifier
    : Tool_Offset
    | Tool_Offset COMMA posreg
    ;

  offset_modifier
    : Offset
    | Offset COMMA posreg
    ;

  voffset_modifier
    : VOFFSET
    | VOFFSET COMMA vr
    ;

  skip_modifier
    : Skip COMMA label
    | Skip COMMA label COMMA posreg EQL lpos_or_jpos
    ;

  lpos_or_jpos
    : lpos
    | jpos
    ;

  lpos
    : LPOS
    ;

  jpos
    : JPOS
    ;

  ld_modifier
    : AP_LD int_or_numreg
    | RT_LD int_or_numreg
    ;

  acc_modifier
    : ACC int_or_numreg
    ;

  linear_units
    : MM_SEC
    | CM_MIN
    | SEC
    | MSEC
    ;

  joint_units
    : PERCENT
    | SEC
    | MSEC
    | DEG_SEC
    ;

  int_or_numreg
    : int
    | numreg
    ;

  termination
    : FINE
    | CNT int_or_numreg
    ;

  destination
    : position
    | posreg
    ;

  monitor_stmt
    : MONITOR IDENT
    | MONITOR END IDENT
    ;

  lock_stmt
    : lock_verb lock_target
    ;

  lock_verb
    : LOCK
    | UNLOCK
    ;

  lock_target
    : PREG
    | VREG
    ;

  for_stmt
    : FOR numreg EQL int_like TO int_like
    | FOR numreg EQL int_like DOWNTO int_like
    ;

  error_prog_stmt
    : ERROR_PROG EQL ident_or_sreg
    ;

  resume_prog_stmt
    : RESUME_PROG index EQL ident_or_sreg
    ;

  ident_or_sreg
    : ident
    | sreg
    ;

  ident
    : IDENT
    ;

  utool_assignment
    : utool EQL posreg
    ;

  utool
    : UTOOL index
    ;

  uframe_assignment
    : uframe EQL posreg
    ;

  uframe
    : UFRAME index
    ;

  uframe_num_stmt
    : UFRAME_NUM EQL int
    | UFRAME_NUM EQL numreg
    | UFRAME_NUM EQL arg
    ;

  utool_num_stmt
    : UTOOL_NUM EQL int
    | UTOOL_NUM EQL numreg
    | UTOOL_NUM EQL arg
    ;

  offset_condition_stmt
    : OFFSET CONDITION posreg
                        { result = OffsetConditionStmt.new(val[0], val[2]) }
    | TOOL_OFFSET CONDITION posreg
                        { result = OffsetConditionStmt.new(val[0], val[2]) }
    | VOFFSET CONDITION vr
                        { result = OffsetConditionStmt.new(val[0], val[2]) }
    ;

  vr
    : VR index
    ;

  payload_stmt
    : PAYLOAD index     { result = PayloadStmt.new(val[1][:id]) }
    ;

  skip_stmt
    : SKIP CONDITION comparison # this may not be valid TP
                        { result = SkipStmt.new(val[2]) }
    ;

  posreg_assignment
    : posreg EQL posreg_assignable
                        { result = Assignment.new(val[0], val[2]) }
    ;

  posreg_assignable
   : posreg
   | position
   | lpos
   | jpos
   | sysvar
   ;

  position
    : POSITION index
    ;

  sysvar_assignment
    : sysvar EQL numeric
                        { result = Assignment.new(val[0], val[2]) }
    | sysvar EQL posreg
                        { result = Assignment.new(val[0], val[2]) }
    ;

  override_stmt
    : OVERRIDE EQL numreg
                        { result = OverrideStmt.new(val[2]) }
    | OVERRIDE EQL int PERCENT
                        { result = OverrideStmt.new(val[2]) }
    | OVERRIDE EQL arg  { result = OverrideStmt.new(val[2]) }
    ;

  ualm_stmt
    : UALM index        { result = UalmStmt.new(val[1][:id]) }
    ;

  rsr_stmt
    : rsr EQL enable_or_disable
                        { result = RsrStmt.new(val[0], val[2]) }
    ;

  enable_or_disable
    : ENABLE
    | DISABLE
    ;

  wait_stmt
    : WAIT real LPAREN SEC RPAREN
                        { result = DelayStmt.new(val[1]) }
    | WAIT numreg
                        { result = DelayStmt.new(val[1]) }
    | WAIT comparison timeout_lbl
                        { result = WaitStmt.new(val[1], val[2]) }
    | WAIT paren_bool_exp timeout_lbl
                        { result = WaitStmt.new(val[1], val[2]) }
    ;

  timeout_lbl
    : # optional
    | TIMEOUT COMMA label
                        { result = val[2] }
    ;

  select_stmt
    : SELECT numreg EQL numeric COMMA call_or_jmp
                        { result = SelectStmt.new(val[1], val[3], val[5]) }
    | EQL numeric COMMA call_or_jmp
                        { result = SelectCase.new(val[1], val[3]) }
    | ELSE COMMA call_or_jmp
                        { result = SelectElse.new(val[2]) }
    ;

  if_stmt
    : IF comparison COMMA call_or_jmp
                        { result = If.new(val[1], val[3]) }
    | IF paren_bool_exp COMMA call_or_jmp
                        { result = If.new(val[1], val[3]) }
    | IF paren_bool_exp COMMA inline_assignment
                        { result = If.new(val[1], val[3]) }
    | IF paren_comparison COMMA call_or_jmp
                        { result = If.new(val[1], val[3]) }
    | IF paren_comparison COMMA inline_assignment
                        { result = If.new(val[1], val[3]) }
    ;

  paren_comparison
    : LPAREN comparison RPAREN
    ;

  inline_assignment
    : numreg EQL LPAREN numeric_assignable RPAREN
    | sysvar EQL LPAREN numeric_assignable RPAREN
    | posreg_component EQL LPAREN numeric_assignable RPAREN
    | inline_boolean_output_assignment
    ;

  sysvar
    : SYSVAR
    ;

  call_or_jmp
    : call_stmt
    | jump_stmt
    ;

  comparison
    : numeric EQL numeric
    | numeric GT  numeric
    | numeric GTE numeric
    | numeric LT  numeric
    | numeric LTE numeric
    | numeric NEQL numeric
    | bool_io EQL bool_io_comparable
    | sreg EQL sreg_comparable
    | comparison AND comparison
    | comparison OR comparison
    ;

  sreg_comparable
    : sreg
    | arg
    ;

  bool_io_comparable
    : bool_io
    | bool
    ;

  label_stmt
    : LBL direct_index  { result = Label.new(val[1]) }
    ;

  jump_stmt
    : JMP label         { result = Jump.new(val[1]) }
    ;

  call_stmt
    : CALL IDENT        { result = Call.new(val[1]) }
    | CALL IDENT LPAREN params RPAREN
                        { result = Call.new(val[1], val[3]) }
    | CALL sreg         { result = Call.new(val[1]) }
    ;

  run_stmt
    : RUN IDENT         { result = Run.new(val[1]) }
    | RUN IDENT LPAREN params RPAREN
                        { result = Run.new(val[1], val[3]) }
    | RUN sreg          { result = Run.new(val[1]) }
    ;

  numreg_assignment
    : numreg EQL numeric_assignable
                        { result = Assignment.new(val[0], val[2]) }
    ;

  boolean_output_assignment
    : boolean_output EQL bool
                        { result = Assignment.new(val[0], val[2]) }
    | boolean_output EQL pulse
                        { result = Assignment.new(val[0], val[2]) }
    | boolean_output EQL paren_bool_exp
                        { result = Assignment.new(val[0], val[2]) }
    ;

  pulse
    : PULSE
    | PULSE COMMA REAL SEC
    ;

  # for IF (),DO[x]=(ON) ;
  inline_boolean_output_assignment
    : boolean_output EQL paren_bool_exp
                        { result = Assignment.new(val[0], val[2]) }
    | boolean_output EQL pulse
                        { result = Assignment.new(val[0], val[2]) }
    ;

  paren_bool_exp
    : LPAREN bool_exp RPAREN
    ;

  bool_exp
    : bool
    | bool_io
    | paren_bool_exp
    | bool_exp AND bool_exp
    | bool_exp OR bool_exp
    | NOT bool_exp
    ;

  bool_io
    : dout
    | din
    | flag
    ;

  din
    : DI index
    ;

  boolean_output
    : dout
    | flag
    | rout
    ;

  rout
    : RO index
    ;

  dout
    : DO index
    ;

  flag
    : FLAG index
    ;

  bool
    : ON
    | OFF
    ;

  component_assignment
    : posreg_component EQL numeric_assignable
                        { result = Assignment.new(val[0], val[2]) }
    ;

  numeric_assignable
    : int
    | LPAREN int RPAREN
    | real
    | LPAREN real RPAREN
    | negative_int
    | negative_real
    | numreg
    | gout
    | gin
    | timer
    | timer_overflow
    | arg
    | aout
    | ain
    | posreg
    | posreg_component
    | numeric_exp
    | paren_numeric_exp
    | sysvar
    ;

  numeric_exp
    : add_exp
    | sub_exp
    | mul_exp
    | quo_exp
    | div_exp
    | mod_exp
    ;

  paren_numeric_exp
    : LPAREN numeric_exp RPAREN
    ;

  add_exp
    : numeric ADD numeric
    ;

  sub_exp
    : numeric SUB numeric
    ;

  mul_exp
    : numeric MUL numeric
    ;

  quo_exp
    : numeric QUO numeric
    ;

  div_exp
    : numeric DIV numeric
    ;

  mod_exp
    : numeric MOD numeric
    ;

  int_like
    : int
    | numreg
    | arg
    ;

  numeric
    : int
    | negative_int
    | real
    | negative_real
    | numreg
    | arg
    | gin
    | gout
    | ain
    | aout
    | numeric_exp
    | paren_numeric_exp
    ;

  sreg
    : SREG index
    ;

  params
    : param             { result = [val[0]] }
    | params COMMA param
                        { result = val[0].push(val[2]) }
    ;

  param
    : int
    | string
    | numreg
    ;

  string
    : STRING
    ;

  label
    : LBL index         { result = Label.new(val[1]) }
    ;

  # the inner part of DATA[] that doesn't allow indirection
  direct_index
    : LBRACK int RBRACK { result = { id: val[1] } }
    | LBRACK int COLON IDENT RBRACK
                        { result = { id: val[1], comment: val[3] } }
    ;

  # the inner part of DATA[] that can be indirected
  index
    : direct_index
    | indirect_index
    ;

  indirect_index
    : LBRACK numreg RBRACK
                        { result = { id: val[1] } }
    | LBRACK arg RBRACK { result = { id: val[1] } }
    ;

  numreg
    : NUMREG index
    ;

  posreg
    : POSREG index
    ;

  posreg_component
    : POSREG LBRACK int_numreg_or_arg COMMA int_numreg_or_arg RBRACK
    | POSREG LBRACK int_numreg_or_arg COMMA int_numreg_or_arg
        COLON IDENT RBRACK
    ;

  int_numreg_or_arg
    : int
    | numreg
    | arg
    ;

  rsr
    : RSR index         { result = val[1][:id] }
    ;

  gout
    : GO index
    ;

  gin
    : GI index
    ;

  aout
    : AO index
    ;

  ain
    : AI index
    ;

  timer
    : TIMER index
    ;

  timer_overflow
    : TIMER_OVERFLOW index
    ;

  int
    : INT
    ;

  negative_int
    : LPAREN SUB INT RPAREN
    ;

  real
    : REAL
    ;

  negative_real
    : LPAREN SUB REAL RPAREN
    ;

  signed_real
    : real
    | SUB real
    ;

  arg
    : ARG index
    ;


  pos_section
    : # this section is optional
    | SECTION_POS
    | SECTION_POS position_list
    ;

  position_list
    : position_spec
    | position_list position_spec
    ;

  position_spec
    : POSITION LBRACK id RBRACK LBRACE
        GP int COLON
        UF COLON int COMMA UT COLON INT COMMA CONFIG COLON STRING COMMA
        X EQL signed_real MM COMMA Y EQL signed_real MM COMMA Z EQL signed_real MM COMMA
        W EQL signed_real DEG COMMA P EQL signed_real DEG COMMA R EQL signed_real DEG
      RBRACE SEMICOLON
    ;

  id
    : int
    | int COLON STRING
    ;


end

---- inner

  include TP::AST

  def initialize(scanner)
    @scanner = scanner
    super()
  end

  def next_token
    t = @scanner.next_token
    #puts t.inspect
    t
  end

  def parse
    do_parse
  end

  def on_error(t, val, vstack)
    raise ParseError, sprintf("Parse error on line #{@scanner.token_line} column #{@scanner.token_column}: %s (%s)",
                                val.inspect, token_to_str(t) || '?')
  end

  class ParseError < StandardError ; end
