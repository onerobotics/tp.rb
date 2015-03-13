/PROG TEST
/ATTR
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
/MN
 : ! lbls and jumps ;
 : LBL[1] ;
 : LBL[2:two] ;
 : JMP LBL[1] ;
 : JMP LBL[2:two] ;
 : JMP LBL[R[1]] ;
 : JMP LBL[AR[1]] ;
 :  ;
 : ! program calls, runs and args ;
 : CALL FOO ;
 : CALL FOO(1) ;
 : CALL FOO(1,2) ;
 : CALL FOO(1,'bar') ;
 : CALL FOO(R[1]) ;
 : CALL FOO(R[R[1]]) ;
 : CALL SR[1] ;
 : CALL SR[R[1]] ;
 : RUN FOO ;
 : RUN FOO(1) ;
 : RUN FOO(1,2) ;
 : RUN FOO(1,'bar') ;
 : RUN FOO(R[1]) ;
 : RUN FOO(R[R[1]]) ;
 : RUN SR[1] ;
 : RUN SR[R[1]] ;
 :  ;
 : ! assignment ;
 : R[1]=1 ;
 : R[1]=3.14 ;
 : R[1]=(-1) ;
 : R[1]=(-3.14) ;
 : R[1:foo]=1 ;
 : R[R[1]]=1 ;
 : R[1]=R[2] ;
 : R[1]=R[R[1]] ;
 : R[1]=R[AR[1]] ;
 : R[1]=DO[1] ;
 : R[1]=DO[1:foo] ;
 : R[1]=DI[1] ;
 : R[1]=RO[1] ;
 : R[1]=RI[1] ;
 : R[1]=GO[1] ;
 : R[1]=GI[1] ;
 : R[1]=SO[1] ;
 : R[1]=SI[1] ;
 : R[1]=TIMER[1] ;
 : R[1]=TIMER_OVERFLOW[1] ;
 : R[1]=AR[1] ;
 : R[1]=AO[1] ;
 : R[1]=AI[1] ;
 : R[1]=PR[1,1] ;
 : R[1]=PR[1,1:foo] ;
 : R[1]=PR[R[1],1] ;
 : R[1]=PR[1,R[1]] ;
 : R[1]=PR[R[1],R[1]] ;
 : R[1]=SR[1] ;
 :  ;
 : ! vision ;
 : !VISION RUN_FIND 'test' ;
 : !VISION GET_OFFSET 'test' VR[1] JMP LBL[1] ;
 : !VISION GET_PASSFAIL 'test' R[1] ;
 : !VISION GET_NFOUND 'test' R[1] ;
 : !VISION GET_NFOUND 'test' R[1] CAMERA_VIEW[1] ;
 : !VISION SET_REFERENCE 'test' ;
 : !VISION OVERRIDE 'test' 0.0 ;
 : !VISION CAMERA_CALIB 'test' Request=1 ;
 : !R[1]=VR[1].MODELID ;
 : !R[1]=VR[1].MES[1] ;
 : !PR[1]=VR[1].FOUND_POS[1] ;
 : !PR[1]=VR[1].OFFSET ;
 : !R[1]=VR[1].ENC ;
 : !VISION GET_READING 'test' SR[1] R[1] JMP LBL[1] ;
 :  ;
 : ! simple exps ;
 : R[1]=1+1 ;
 : R[1]=1-1 ;
 : R[1]=1*1 ;
 : R[1]=1/1 ;
 : R[1]=1 DIV 1 ;
 : R[1]=1 MOD 1 ;
 : PR[1,1]=5 ;
 : PR[1,1:foo]=5 ;
 :  ;
 : ! mixed logic ;
 : R[1]=(1) ;
 : R[1]=(1+1) ;
 : R[1]=(F[1]) ;
 : R[1]=(1+1+1) ;
 : R[1]=(1+(1+1)) ;
 :  ;
 : ! io ;
 : DO[1:foo]=ON ;
 : DO[1]=OFF ;
 : DO[1]=PULSE ;
 : DO[1]=PULSE,0.1sec ;
 : DO[1]=PULSE,25.5sec ;
 : DO[1]=(ON) ;
 : F[1]=(ON) ;
 : F[1]=((F[2] AND F[3]) OR (F[4] AND F[5])) ;
 :  ;
 : ! if-statements ;
 : IF R[1]=1,JMP LBL[1] ;
 : IF R[1]>1,JMP LBL[1] ;
 : IF R[1]<1,JMP LBL[1] ;
 : IF R[1]<(-1),JMP LBL[1] ;
 : IF R[1]>=1,JMP LBL[1] ;
 : IF R[1]<=1,JMP LBL[1] ;
 : IF R[1]<>1,JMP LBL[1] ;
 : IF R[1]>R[2],JMP LBL[1] ;
 : IF R[1]>AR[1],JMP LBL[1] ;
 : IF R[1]=SR[1],JMP LBL[1] ;
 : IF GI[1]=1,JMP LBL[1] ;
 : IF DO[1]=R[1],JMP LBL[1] ;
 : IF DO[1]=ON,JMP LBL[1] ;
 : IF DO[1]=OFF,JMP LBL[1] ;
 : IF DO[1]=DO[2],JMP LBL[1] ;
 : IF DO[1]=DI[1],JMP LBL[1] ;
 : IF DI[1]=R[1],JMP LBL[1] ;
 : IF SR[1]=R[1],JMP LBL[1] ;
 : IF SR[1]=5,JMP LBL[1] ;
 : IF SR[1]=AR[1],JMP LBL[1] ;
 : IF SR[1]=SR[2],JMP LBL[1] ;
 : IF R[1]=1,CALL FOO ;
 : IF R[1]=1,CALL FOO(1) ;
 : IF R[1]=1 AND R[2]=1,JMP LBL[1] ;
 : IF R[1]=1 OR R[2]=1,JMP LBL[1] ;
 :  ;
 : ! mixed logic IF ;
 : IF (F[1]),JMP LBL[1] ;
 : IF (!F[1]),JMP LBL[1] ;
 : IF (F[1] AND F[2]),JMP LBL[1] ;
 : IF (F[1] OR F[2]),JMP LBL[1] ;
 : IF (F[1] AND (F[2] OR F[3])),JMP LBL[1] ;
 : IF (ON),JMP LBL[1] ;
 : IF (ON),CALL FOO ;
 : IF (ON),CALL FOO(1) ;
 : IF (ON),DO[1]=(ON) ;
 : IF (ON),DO[1]=PULSE ;
 : IF (ON),DO[1]=PULSE,0.1sec ;
 : IF (ON),R[1]=(1) ;
 : IF (ON),$foo=(5) ;
 : IF (ON),PR[1,1]=(5) ;
 : IF (R[1]>1),JMP LBL[1] ;
 : IF (R[1]<1),JMP LBL[1] ;
 : IF (R[1]>=1),JMP LBL[1] ;
 : IF (R[1]<=1),JMP LBL[1] ;
 : IF (R[1]<>1),JMP LBL[1] ;
 : IF (R[1]>1 AND R[1]<5),JMP LBL[1] ;
 : IF (R[1]=(-1) OR R[1]=2 OR R[1]=3),JMP LBL[1] ;
 :  ;
 : ! select statements ;
 : SELECT R[1]=1,JMP LBL[1] ;
 :        =R[2],CALL FOO ;
 :        =AR[1],CALL FOO(1) ;
 :        =SR[1],JMP LBL[2] ;
 :        =(-1),JMP LBL[1] ;
 :        ELSE,JMP LBL[1] ;
 :  ;
 : SELECT R[1]=1,JMP LBL[1] ;
 :        ELSE,JMP LBL[2] ;
 :  ;
 : SELECT R[1]=1,CALL FOO ;
 :  ;
 : ! wait statements ;
 : WAIT 5.00(sec) ;
 : WAIT  .01(sec) ;
 : WAIT R[1] ;
 : WAIT R[1]=1 ;
 : WAIT R[1]=1 AND R[2]=1 ;
 : WAIT DO[1]=ON ;
 : WAIT DO[1]=ON OR DO[2]=ON ;
 : WAIT (DI[1]) ;
 : WAIT R[1]=1 TIMEOUT,LBL[1] ;
 : WAIT DO[1]=ON TIMEOUT,LBL[R[1]] ;
 : WAIT (DI[1]) TIMEOUT,LBL[1] ;
 :  ;
 : ! rsr ;
 : RSR[1]=ENABLE ;
 : RSR[1]=DISABLE ;
 :  ;
 : ! ualms ;
 : UALM[1] ;
 : UALM[R[1]] ;
 :  ;
 : ! OVERRIDEs ;
 : OVERRIDE=R[1] ;
 : OVERRIDE=5% ;
 : OVERRIDE=AR[1] ;
 : OVERRIDE=R[R[1]] ;
 : OVERRIDE=AR[AR[1]] ;
 :  ;
 : ! sysvars ;
 : $foo=R[1] ;
 : $foo.$bar=R[1] ;
 : $foo[1]=R[1] ;
 : $foo[1].$bar=R[1] ;
 : $foo=1 ;
 : $foo=AR[1] ;
 : $foo=PR[1] ;
 : $foo=AR[R[1]] ;
 : $foo=PR[R[1]] ;
 : R[1]=$foo ;
 : R[R[1]]=$foo ;
 : PR[1]=PR[2] ;
 : PR[1]=P[1] ;
 : PR[1]=LPOS ;
 : PR[1]=JPOS ;
 : PR[R[1]]=PR[R[2]] ;
 : PR[1]=$foo ;
 :  ;
 : ! remarks ;
 : //R[1]=1 <- this is a remark ;
 :  ;
 : ! skip conditions ;
 : SKIP CONDITION R[1]=1 ;
 : SKIP CONDITION DI[1]=ON ;
 :  ;
 : ! PAYLOAD statements ;
 : PAYLOAD[1] ;
 : PAYLOAD[R[1]] ;
 :  ;
 : ! Tracking ;
 : STOP_TRACKING ;
 :  ;
 : ! Offset/frames... ;
 : OFFSET CONDITION PR[1] ;
 : OFFSET CONDITION PR[R[1]] ;
 : TOOL_OFFSET CONDITION PR[1] ;
 : TOOL_OFFSET CONDITION PR[R[1]] ;
 : VOFFSET CONDITION VR[1] ;
 : VOFFSET CONDITION VR[R[1]] ;
 :  ;
 : ! utool/uframe settings ;
 : UFRAME_NUM=1 ;
 : UFRAME_NUM=R[1] ;
 : UFRAME_NUM=AR[1] ;
 : UTOOL_NUM=1 ;
 : UTOOL_NUM=R[1] ;
 : UTOOL_NUM=AR[1] ;
 : UFRAME[1]=PR[1] ;
 : UFRAME[R[1]]=PR[R[1]] ;
 : UTOOL[1]=PR[1] ;
 : UTOOL[R[1]]=PR[R[1]] ;
 :  ;
 : ! program control ;
 : PAUSE ;
 : ABORT ;
 : END ;
 : ERROR_PROG=FOO ;
 : ERROR_PROG=SR[1] ;
 : ERROR_PROG=SR[R[1]] ;
 : RESUME_PROG[1]=FOO ;
 : RESUME_PROG[5]=SR[1] ;
 : RESUME_PROG[2]=SR[R[1]] ;
 :  ;
 : ! for loops ;
 : FOR R[1]=1 TO 10 ;
 : ENDFOR ;
 : FOR R[R[1]]=1 TO 10 ;
 : ENDFOR ;
 : FOR R[1]=R[2] TO R[3] ;
 : ENDFOR ;
 : FOR R[1]=R[R[1]] TO R[R[1]] ;
 : ENDFOR ;
 : FOR R[1]=AR[1] TO AR[2] ;
 : ENDFOR ;
 : FOR R[1]=AR[R[1]] TO AR[R[2]] ;
 : ENDFOR ;
 : FOR R[1]=10 DOWNTO 1 ;
 : ENDFOR ;
 :  ;
 : ! stuff ;
 : LOCK PREG ;
 : UNLOCK PREG ;
 : LOCK VREG ;
 : UNLOCK VREG ;
 : MONITOR FOO ;
 : MONITOR END FOO ;
 :  ;
 : ! strings ;
 : !R[1]=STRLEN SR[1] ;
 : !R[1]=STRLEN SR[R[1]] ;
 : !SR[1]=SUBSTR SR[1],R[1],R[2] ;
 : !SR[R[1]]=SUBSTR SR[R[1]],R[R[1]],R[R[1]] ;
 : !R[1]=FINDSTR SR[1],SR[2] ;
 : !R[R[1]]=FINDSTR SR[R[1]],SR[R[1]] ;
 :  ;
 : ! motion ;
 : J P[1:foo] 100% FINE ;
 : J PR[1:bar] 100% CNT100 ;
 : J P[1] 100% CNT R[1] ;
 : J P[1] R[1]% FINE ;
 : J P[1] R[R[1]]% CNT R[R[1]] ;
 : J PR[1] 100% FINE ;
 : J PR[R[1]] 100% FINE ;
 : J P[1] 60sec FINE ;
 : J P[1] 600msec FINE ;
 : L P[1] 10000mm/sec FINE ;
 : L P[1] 10000cm/min FINE ;
 : L P[1] 100deg/sec FINE ;
 : L P[1] 5sec FINE ;
 : L P[1] 500msec FINE ;
 : L P[1] max_speed FINE ;
 : L P[1] R[1]mm/sec FINE ;
 : L P[1] R[R[1]]mm/sec FINE ;
 : L P[1] 100mm/sec CNT100 ;
 : L P[1] 100mm/sec CNT R[1] ;
 : L P[1] 100mm/sec CNT R[R[1]] ;
 : L PR[1] 100mm/sec FINE ;
 : L PR[R[1]] 100mm/sec FINE ;
 :  ;
 : ! motion modifiers ;
 : L P[1] 100mm/sec FINE ACC100 ;
 : L P[1] 100mm/sec FINE ACC R[1] ;
 : L P[1] 100mm/sec FINE AP_LD50 ;
 : L P[1] 100mm/sec FINE AP_LDR[1] ;
 : L P[1] 100mm/sec FINE RT_LD50 ;
 : L P[1] 100mm/sec FINE RT_LDR[1] ;
 : L P[1] 100mm/sec FINE Skip,LBL[1] ;
 : L P[1] 100mm/sec FINE Skip,LBL[R[1]] ;
 : L P[1] 100mm/sec FINE Skip,LBL[1],PR[1]=LPOS ;
 : L P[1] 100mm/sec FINE Skip,LBL[1],PR[1]=JPOS ;
 : L P[1] 100mm/sec FINE Skip,LBL[1],PR[R[1]]=LPOS ;
 : L P[1] 100mm/sec FINE Offset ;
 : L P[1] 100mm/sec FINE Offset,PR[1] ;
 : L P[1] 100mm/sec FINE Offset,PR[1:foo] ;
 : L P[1] 100mm/sec FINE Offset,PR[R[1]] ;
 : L P[1] 100mm/sec FINE VOFFSET ;
 : L P[1] 100mm/sec FINE VOFFSET,VR[1] ;
 : L P[1] 100mm/sec FINE INC ;
 : L P[1] 100mm/sec FINE PTH ;
 : L P[1] 100mm/sec FINE Tool_Offset ;
 : L P[1] 100mm/sec FINE Tool_Offset,PR[1] ;
 : L P[1] 100mm/sec FINE Tool_Offset,PR[1:foo] ;
 : L P[1] 100mm/sec FINE Tool_Offset,PR[R[1]] ;
 : L P[1] 100mm/sec FINE TB 1.0sec,CALL FOO ;
 : L P[1] 100mm/sec FINE TB 1.0sec,CALL FOO(1) ;
 : L P[1] 100mm/sec FINE TB R[1]sec,CALL FOO ;
 : L P[1] 100mm/sec FINE TB .1sec,CALL SR[1] ;
 : L P[1] 100mm/sec FINE TB 1.0sec,DO[42]=ON ;
 : L P[1] 100mm/sec FINE TB 1.0sec,DO[R[1]]=OFF ;
 : L P[1] 100mm/sec FINE TB 1.0sec,DO[1]=PULSE,1.0sec ;
 : L P[1] 100mm/sec FINE TB 1.0sec,RO[1]=ON ;
 : L P[1] 100mm/sec FINE TB 1.0sec,GO[1]=1 ;
 : L P[1] 100mm/sec FINE TB 1.0sec,AO[1]=5.0 ;
 : L P[1] 100mm/sec FINE TB 1.0sec,POINT_LOGIC ;
 : L P[1] 100mm/sec FINE TA 1.0sec,CALL FOO ;
 : L P[1] 100mm/sec FINE DA 1.0mm,CALL FOO ;
 : L P[1] 100mm/sec FINE DB 1.0mm,CALL FOO ;
/POS
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
};
/END