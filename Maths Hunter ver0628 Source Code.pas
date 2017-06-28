PROGRAM sbaGame;

{
   Name: Maths Hunter
   Author: Chu Ching Tin Einstein
   Description: a RPG game for ict SBA 2014-2015
   Last updated 2014-06-28 0200
}


USES crt,dos,sysutils;

TYPE
    dungeonType=array[1..22, 1..47] of char;
    dungeon1Type=array[1..22, 1..33] of char;

VAR
   DataDirCreated,BossWin1,BossWin2:boolean;
   username,userMons:string;
   userID:string[30];
   mosterChoice,UserEXP,UserLV,UserHP,UserATK,GotoDungeon,trigo,cal,DifChoice,Dungeon1Clear:integer;
   //-----------------globle var for snakeGame--------------------
   EXITL:Boolean;
   C1, C2:Char;
   RandCol : integer;
   A : integer;
   Q,W : integer;
   DX,DY : integer;
   X0,Y0 : integer;
   EX,EY : integer;
   HX,HY : integer;
   SC : integer;
   XBorder, YBorder : Integer;
   X, Y:Array [1..400] of integer;
   MoveDelay : integer;
   Lifes : integer;
   Len : Byte;
   Name : String[10];

//----------------Title screen-----------------------
PROCEDURE titleScreen;
          begin
               {"Maths Hunter" logo}
               TextColor(14);
               writeln('        =================================================');
               writeln('        ||                                             ||');
               write('        ||');
               TextColor(11);
               write('                       _____           ___  ');
               TextColor(14);
               writeln(' ||');
               write('        ||');
               TextColor(11);
               write('     |\    /|    /\      |    |    |  /   \');
               TextColor(14);
               writeln('  ||');
               write('        ||');
               TextColor(11);
               write('     | \  / |   /__\     |    |____|  \___');
               TextColor(14);
               writeln('   ||');
               write('        ||');
               TextColor(11);
               write('     |  \/  |  /    \    |    |    |      \');
               TextColor(14);
               writeln('  ||');
               write('        ||');
               TextColor(11);
               write('     |      | /      \   |    |    |  \___/');
               TextColor(14);
               writeln('  ||');
               write('        ||');
               writeln('                                             ||');
               write('        ||');
               TextColor(12);
               write('                         _____   ____   ___');
               TextColor(14);
               writeln('  ||');
               write('        ||');
               TextColor(12);
               write('  |    |  |    |  |\   |   |    |      |   \');
               TextColor(14);
               writeln(' ||');
               write('        ||');
               TextColor(12);
               write('  |____|  |    |  | \  |   |    |___   |___/');
               TextColor(14);
               writeln(' ||');
               write('        ||');
               TextColor(12);
               write('  |    |  |    |  |  \ |   |    |      |  \');
               TextColor(14);
               writeln('  ||');
               write('        ||');
               TextColor(12);
               write('  |    |   \__/|  |   \|   |    |____  |   \');
               TextColor(14);
               writeln(' ||');
               writeln('        ||                                             ||');
               writeln('        ||                                             ||');
               writeln('        =================================================');
               writeln();
               writeln();
               {Press any key to start the game}
               write('                 Press any key to start...');
               readkey;
               clrScr;
          end;

//----------------Easter Egg: Snake Game--------------------
PROCEDURE VarSet;
          begin
               Len := 10;
               X0 := 0;
               Y0 := -1;
               EX := 35;
               EY := 21;
               for A := 1 to Len do
                   begin
                        X[A] := 35;
                        Y[A] := A+14; {changed from 30 to 15}
                   end;
          end;

PROCEDURE CursorOff;
          var
             Reg:Registers;
          begin
               with Reg do
                    begin
                         AH := 1;
                         CH := $20
                    end;
               Intr($10, Reg)
          end;

PROCEDURE Border;
          begin
               textcolor(Yellow);

               { X-Axis Border Top }
               XBorder := 1;
               YBorder := 2;
               repeat
                     gotoxy(XBorder,YBorder);
                     write(char(205));
                     XBorder:=XBorder+1;
               until XBorder = 80;

               { Y-Axis Border Left }
               XBorder := 1;
               YBorder := 2;
               repeat
                     gotoxy(XBorder,YBorder);
                     Write(char(186));
                     YBorder:=YBorder+1;
               until YBorder = 26; {changed from 51 to 26}

               { X-Axis Border Bottom }
               XBorder :=1;
               YBorder :=25;     {changed from 50 to 25}
               repeat
                     gotoxy(XBorder,YBorder);
                     write(char(205));
                     XBorder:=XBorder+1;
               until XBorder = 80;

               { Y-Axis Border Right }
               XBorder := 79;
               YBorder := 2;
               repeat
                     gotoxy(XBorder,YBorder);
                     Write(char(186));
                     YBorder:=YBorder+1;
               until YBorder = 26; {changed from 51 to 25}

               { Corners }
               { Bottom Left }
               gotoxy(1,25);    {changed from 1,50 to 1,25}
               write(char(200));
               { Bottom Right }
               gotoxy(79,25);    {changed from 79,50 to 79,25}
               write(char(188));
               { Top Left }
               gotoxy(1,2);
               write(char(201));
               { Top Right }
               gotoxy(79,2);
               write(char(187));
               textcolor(green);
          end;

PROCEDURE Obj;
          Label
               L;
          begin
               L:Q := Random (20)+4;
               W := Random (75)+3;
               for A := 1 to Len do
               if (X[A] = W) and (Y[A] = Q) then Goto L;
               GotoXY (W, Q);
               RandCol:= random(13);
               RandCol:= RandCol+2;
               textcolor(RandCol);
               Write (char(01));
          end;
PROCEDURE PutSnakeVars;
          begin
               TextColor (Green);
               GotoXY (EX, EY);
               Write (' ');
               for A := Len downto 1 do
                   begin
                        GotoXY (X[A], Y[A]);
                        Write (char(219));
                   end;
               GotoXY (8, 1);
               TextColor(White);
               write ('Current Score: ',SC);
               GotoXY (60,1);
               write ('Remaining Lifes: ',Lifes);
               DX := X0;
               DY := Y0;
          end;

PROCEDURE KeyScan;
          begin
          if KeyPressed
          then begin
                    C1 := ReadKey;
                    if C1 = #0
                    then begin
                              C2 := ReadKey;
                              case c2 of
                                   #75: BEGIN; X0 := -1; Y0 := 0; gotoxy(35,1); write('Direction: ',char(27)); END;      {left}
                                   #77: BEGIN; X0 := 1; Y0 := 0; gotoxy(35,1); write('Direction: ',char(26)) END;       {Right}
                                   #80: BEGIN; X0 := 0; Y0 := 1; gotoxy(35,1); write('Direction: ',char(25)) END;       {DOWN}
                                   #72: BEGIN; X0 := 0; Y0 := -1; gotoxy(35,1); write('Direction: ',char(24)) END       {UP}
                              end
                         end;
                    if C1 = #27
                    then EXITL := True                  {EXITL}
                    else EXITL := false
               end;
          end;

FUNCTION CheckRun:Boolean;
         var
            C:Boolean;
         begin
              CheckRun := false;
              if Y[1] = 2
              then begin
                        CheckRun := true;
                        if Lifes = 0
                        then begin
                                  GotoXY(X[1],Y[1]);
                                  write('*');
                                  sound(1000);
                                  delay(1000);
                                  nosound;
                                  delay(2000);
                                  gotoxy(35,12); {changed from 35,25 to 35,12}
                                  Textcolor(lightRed);
                                  write('G A M E O V E R');
                                  gotoxy(35,13); {changed from 35,26 to 35,13}
                                  textcolor(lightblue);
                                  write('Score:',SC);
                                  delay(2000);
                                  halt;
                             end;
                        Lifes:=Lifes-1;
                        GotoXY (60,1);
                        write ('Remaining Lifes: ',Lifes);
                        GotoXY(X[1],Y[1]);
                        write('*');
                        {   delay(2000);}
                        textcolor(green);
                        sound(1000);
                        delay(1000);
                        nosound;
                   end;
         if X[1] = 1
         then begin
                    CheckRun := true;
                    if Lifes = 0
                    then begin
                              GotoXY(X[1],Y[1]);
                              write('*');
                              sound(1000);
                              delay(1000);
                              nosound;
                              delay(2000);
                              gotoxy(35,12); {changed from 35,25 to 35,12}
                              Textcolor(lightRed);
                              write('G A M E O V E R');
                              gotoxy(35,13); {changed from 35,26 to 35,13}
                              textcolor(lightblue);
                              write('Score:',SC);
                              delay(2000);
                              halt;
                         end;
                    Lifes:=Lifes-1;
                    GotoXY (60,1);
                    Write ('Remaining Lifes: ',Lifes);
                    GotoXY(X[1],Y[1]);
                    write('*');
                    delay(2000);
                    textcolor(green);
                    sound(1000);
                    delay(1000);
                    nosound;
              end;
              if Y[1] = 25
              then begin                {changed from 50 to 25}
                        CheckRun := true;
                        if Lifes = 0
                        then begin
                                  GotoXY(X[1],Y[1]);
                                  write('*');
                                  sound(1000);
                                  delay(1000);
                                  nosound;
                                  delay(2000);
                                  gotoxy(35,12); {changed from 35,25 to 35,12}
                                  Textcolor(lightRed);
                                  write('G A M E O V E R');
                                  gotoxy(36,13); {changed from 35,26 to 35,13}
                                  textcolor(lightblue);
                                  write('Score:',SC);
                                  delay(2000);
                                  halt;
                             end;
                        Lifes:=Lifes-1;
                        GotoXY (60,1);
                        Write ('Remaining Lifes: ',Lifes);
                        GotoXY(X[1],Y[1]);
                        write('*');
                        {   delay(2000);  }
                        textcolor(green);
                        sound(1000);
                        delay(1000);
                        nosound;
                   end;
              if X[1] = 79
              then begin
                   CheckRun := true;
                   if Lifes = 0
                   then begin
                             GotoXY(X[1],Y[1]);
                             write('*');
                             sound(1000);
                             delay(1000);
                             nosound;
                             delay(2000);
                             gotoxy(35,12); {changed from 35,25 to 35,12}
                             Textcolor(lightRed);
                             write('G A M E O V E R');
                             gotoxy(36,13); {changed from 35,26 to 35,13}
                             textcolor(lightblue);
                             write('Score:',SC);
                             delay(2000);
                             halt;
                        end;
                   Lifes:=Lifes-1;
                   GotoXY (60,1);
                   Write ('Remaining Lifes: ',Lifes);
                   GotoXY(X[1],Y[1]);
                   write('*');
                   {  delay(2000);      }
                   textcolor(green);
                   sound(1000);
                   delay(1000);
                   nosound;
              end;
         end;

FUNCTION CheckEat:Boolean;
         begin
              CheckEat := false;
              for A := 2 to Len do
                  if (X[1] = X[A]) and (Y[1] = Y[A])
                  then begin
                            CheckEat := true;
                            if Lifes = 0
                            then begin
                                      GotoXY(X[1],Y[1]);
                                      write('*');
                                      sound(1000);
                                      delay(1000);
                                      nosound;
                                      {  delay(2000);  }
                                      gotoxy(35,12); {changed from 35,25 to 35,12}
                                      Textcolor(lightRed);
                                      write('G A M E O V E R');
                                      gotoxy(36,13); {changed from 35,26 to 35,13}
                                      textcolor(lightblue);
                                      write('Score:',SC);
                                      delay(2000);
                                      halt;
                                 end;
                            textcolor(white);
                            Lifes:=Lifes-1;
                            GotoXY (60,1);
                            Write ('Remaining Lifes: ',Lifes);
                            GotoXY(X[1],Y[1]);
                            write('*');
                            sound(1000);
                            delay(1000);
                            nosound;
                            delay(2000);
                            textcolor(green);
                       end;
         end;

FUNCTION CheckObj:Boolean;
         begin
              if (W = HX) and (Q = HY)
              then CheckObj := true
              else CheckObj := false
         end;

PROCEDURE Move;
          begin
               EX := X[Len];
               EY := Y[Len];
               for A := Len downto 2 do
                   begin
                        X[A] := X[A-1];
                        Y[A] := Y[A-1]
                   end;
               X[1] := HX;
               Y[1] := HY
          end;

Procedure Fat;
          begin
               Inc (Len);
               for A := Len downto 2 do
                   begin
                        X[A] := X[A-1];
                        Y[A] := Y[A-1]
                   end;
          end;

PROCEDURE snakeGame();
          Label
               L2;
          begin
               clrscr;
               cursoroff;
               clrscr;
               textcolor(yellow);
               writeln('Instructions');
               textcolor(white);
               writeln('Up: ',char(24));
               writeln('Down: ',char(25));
               writeln('Right: ',char(26));
               writeln('Left: ',char(27));
               writeln('Escape: Esc');
               textcolor(LightRed);
               writeln('Press Enter to Continue');
               readln;
               clrscr;
               Lifes:=3;
               MoveDelay:=125;
               PutSnakeVars;
               Randomize;
               Repeat
                     KeyScan;
                     begin
                          clrscr;
                          border;
                          VarSet;
                          textcolor(white);
                          gotoxy(35,1);
                          write('Direction: ',char(24));
                          Obj;
                          while true do
                                begin
                                     PutSnakeVars;
                                     KeyScan;
                                     if DX = -X0 then X0 := DX;
                                     if DY = -Y0 then Y0 := DY;
                                     HX := X[1] + X0;
                                     HY := Y[1] + Y0;
                                     if CheckObj
                                     then begin
                                               Inc (SC);
                                               if SC >= 5  then MoveDelay:=100;
                                               if SC >= 10 then MoveDelay:=75;
                                               if SC >= 15 then MoveDelay:=50;
                                               if SC >= 20 then MoveDelay:=25;
                                               Fat;
                                               Obj;
                                          end;
                                     if CheckRun then Goto L2;
                                     Move;
                                     if CheckEat then Goto L2;
                                     if EXITL then Goto L2;
                                     Delay (MoveDelay);
                                end;
                          L2:END
               until EXITL;
          end;
//----------------End of Easter Egg: Snake Game-------------------

//----------------Make GameData Directory and files available-----------------------
PROCEDURE checkDataDirCreation(
          var CDataDirCreated:boolean
          );

          var
             DataDirCreationText:text;
             CreateData:string;
             NewDir:PathStr;
             t16,t17,t18,t19,t20:text;

          begin
               //-------------------Initializing data text files---------------------
               NewDir := FSearch('C:\GameData', GetEnv('')); {look for GameData folder}
               if NewDir = ''                                 {create C:\GameData if not exist}
               then begin
                         CreateDir('C:\GameData');
                         //-------------------make map text files----------------------
                         assign(t16,'C:\GameData\Dungeon1finish.txt');
                         rewrite(t16);
                         writeln(t16,'FFFFFFFFFFFFFFFFFFFFFFFFFTTTFFF');
                         writeln(t16,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t16,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t16,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t16,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t16,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t16,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t16,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t16,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t16,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t16,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t16,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t16,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t16,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t16,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t16,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t16,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t16,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t16,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t16,'FFFFFFFFFFFFFFFFFFFFFTTTTTTTFFF');
                         writeln(t16,'FFFFFFFFFFFFFFFFFFFFFTTTTTTTFFF');
                         write(t16,'TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT');
                         close(t16);
                         assign(t17,'C:\GameData\Dungeon2finish.txt');
                         rewrite(t17);
                         writeln(t17,'TFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t17,'TFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t17,'TFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t17,'TFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t17,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t17,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t17,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t17,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t17,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t17,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t17,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t17,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t17,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t17,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t17,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t17,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t17,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t17,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t17,'FFFFFFFFTTTTTTTFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t17,'FFFFFFFFTTTTTTTFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         writeln(t17,'FFFFFFFFTTTTTTTFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF');
                         write(t17,'TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT');
                         close(t17);
                         assign(t18,'C:\GameData\Dungeon1map.txt');
                         rewrite(t18);
                         writeln(t18,'|||||||||||||||||||||||||   |||');
                         writeln(t18,'|     |           | |   ||||| |');
                         writeln(t18,'| |=| | |=======| | | | |===| |');
                         writeln(t18,'|  B| |     | |   | | |       |');
                         writeln(t18,'| |=| |===| | | |=| | | |=|   |');
                         writeln(t18,'| |M| |     |   |B    | |B|   |');
                         writeln(t18,'| | | | |=|=|=| |=====| | |=| |');
                         writeln(t18,'|   | |  B|   |   |     | | | |');
                         writeln(t18,'|===| |===| | |=| |   |=| | | |');
                         writeln(t18,'|   |     | |  B| |   |   | | |');
                         writeln(t18,'| | |===| | |===| | |=| |=| | |');
                         writeln(t18,'| |  B|   | |     | |   |     |');
                         writeln(t18,'| |===| |=| | |===| | |=|   |=|');
                         writeln(t18,'|   |   |B| |     |   |     |||');
                         writeln(t18,'|   | |=| | |===| |=| | |=| |||');
                         writeln(t18,'| |   ||| |     |     |  B| |||');
                         writeln(t18,'| |===|=| |===| | |=======| |=|');
                         writeln(t18,'|       |   |   |  B| |       |');
                         writeln(t18,'|=====| | | | | |===| | |===| |');
                         writeln(t18,'|     |   | | |       | |   | |');
                         writeln(t18,'|B|=|   | |   | |===|   | |   |');
                         write(t18,'|||||||||||||||||||||||||S|||||');
                         close(t18);
                         assign(t19,'C:\GameData\Dungeon2map.txt');
                         rewrite(t19);
                         writeln(t19,' ||||||||||||||||||||||||||||||||||||||||||||');
                         writeln(t19,' ||B|     |       |       |||B  |   |       |');
                         writeln(t19,' || | | | | |=|== | ==| | |=|=| | | | |== | |');
                         writeln(t19,' ||   | |   |||   |   | |   |   |B|   |   | |');
                         writeln(t19,'|=|===| |=|=|=|   |=| | |=| | | |=|===| |=| |');
                         writeln(t19,'|B|   |  B| |         | |   | |   |     |   |');
                         writeln(t19,'| |=| |===| | |=====| | | |=| | | | |=|=| | |');
                         writeln(t19,'| |B|       | |     | | |B|   | | | |=|B  | |');
                         writeln(t19,'| | | |===| | | |=| | | |=| |=| |   |M|===| |');
                         writeln(t19,'| | | |   | | | ||| | |   |   | |===| |     |');
                         writeln(t19,'|   | | | |   | |=| | |   |   | |     | |===|');
                         writeln(t19,'| |=| | | |===|   | | |   |=| | |   |=|     |');
                         writeln(t19,'| |   |B|         | |B|     | | |   |   |=| |');
                         writeln(t19,'| | |=|=|===|=====| |=|===| | | |=| | |=| | |');
                         writeln(t19,'| |  B| |||||B      |B|  B| | |  B| | |   | |');
                         writeln(t19,'| | |=| |===|=|   |=| | |=| | |===| | | | | |');
                         writeln(t19,'| | |         |   |   | |   |       | | |   |');
                         writeln(t19,'| | | |=| | | | |=| | | |=| |=======| | |===|');
                         writeln(t19,'| | |   | | | | ||| | |   |       |B  |     |');
                         writeln(t19,'| | |===| | | | |=| | |=| |=====| |===|===| |');
                         writeln(t19,'|         | |       | |||                   |');
                         write(t19,'|||||||||||S|||||||||||||||||||||||||||||||||');
                         close(t19);
                         //------------------make user list--------------------
                         assign(t20,'C:\GameData\userIDs.txt');                              {new t20}
                         rewrite(t20);
                         write(t20,'ccm2IsHandsome');
                         close(t20);
                    end;
               assign(DataDirCreationText,'C:\GameData\DataCreateion.txt');
               rewrite(DataDirCreationText);
               writeln(DataDirCreationText,'1');
               close(DataDirCreationText);
          end;

//--------------------create new user account (ID and PW)------------------------
PROCEDURE createUserAccount();

          var
             ci,cc:integer;
             passuser:array[1..30] of string[30];
             cPassword:string;
             cUser:string[30];
             uservalid:boolean;
             usertext,passtext,t0,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,t13,t14,t15:text;
          begin
               clrscr;
               Textcolor(white);
               repeat
                     ci:=1;
                     uservalid:=TRUE;
                     clrscr;
                     write('Please input a username (within 30 characters): ');
                     readln(cUser);
                     assign(usertext,'C:\GameData\userIDs.txt');
                     reset(usertext);
                     while not eof(usertext) do {check if username exist}
                           begin
                                readln(usertext,passuser[ci]);
                                if cUser=passuser[ci]
                                then uservalid:=FALSE
                                else if cUser<>passuser[ci]
                                then uservalid:=uservalid;
                                ci:=ci+1;
                           end;
                     close(usertext);
                     if uservalid
                     then begin
                               passuser[ci+1]:=cUser;
                               assign(usertext,'C:\GameData\userIDs.txt');
                               rewrite(usertext);
                               for cc:=1 to ci+1 do      {save new username to username list}
                               writeln(usertext,passuser[cc]);
                               close(usertext);
                               //-------------------make user data files------------------------
                               //-------------------make text files filled with 0----------------------
                               assign(t1,'C:\GameData\'+cUser+'_cal.txt');
                               assign(t2,'C:\GameData\'+cUser+'_NoOfBattles.txt');
                               assign(t3,'C:\GameData\'+cUser+'_NoOfRightAns.txt');
                               assign(t4,'C:\GameData\'+cUser+'_NoOfWrongAns.txt');
                               assign(t5,'C:\GameData\'+cUser+'_trigo.txt');
                               assign(t6,'C:\GameData\'+cUser+'_UserATK.txt');
                               assign(t7,'C:\GameData\'+cUser+'_UserCreation.txt');
                               assign(t8,'C:\GameData\'+cUser+'_UserEXP.txt');
                               assign(t9,'C:\GameData\'+cUser+'_UserHP.txt');
                               assign(t10,'C:\GameData\'+cUser+'_ClearDungeon1.txt');
                               assign(t11,'C:\GameData\'+cUser+'_ClearDungeon2.txt');
                               rewrite(t1);
                               rewrite(t2);
                               rewrite(t3);
                               rewrite(t4);
                               rewrite(t5);
                               rewrite(t6);
                               rewrite(t7);
                               rewrite(t8);
                               rewrite(t9);
                               rewrite(t10);
                               rewrite(t11);
                               write(t1,0);
                               write(t2,0);
                               write(t3,0);
                               write(t4,0);
                               write(t5,0);
                               write(t6,0);
                               write(t7,0);
                               write(t8,0);
                               write(t9,0);
                               write(t10,0);
                               write(t11,0);
                               close(t1);
                               close(t2);
                               close(t3);
                               close(t4);
                               close(t5);
                               close(t6);
                               close(t7);
                               close(t8);
                               close(t9);
                               close(t10);
                               close(t11);
                               //-------------------make text files filled with 1----------------------
                               assign(t12,'C:\GameData\'+cUser+'_UserDif.txt');
                               assign(t13,'C:\GameData\'+cUser+'_UserLV.txt');
                               assign(t14,'C:\GameData\'+cUser+'_UserMonster.txt');
                               rewrite(t12);
                               rewrite(t13);
                               rewrite(t14);
                               write(t12,1);
                               write(t13,1);
                               write(t14,1);
                               close(t12);
                               close(t13);
                               close(t14);
                               //-------------------make empty text file----------------------
                               assign(t15,'C:\GameData\'+cUser+'_UserName.txt');
                               rewrite(t15);
                               write(t15,'');
                               close(t15);
                          end
                     else if not(uservalid)
                          then begin
                                    write('Invalid Username! It may be used. Please use another username.');
                                    for ci:=1 to 15 do
                                        begin
                                             write('.');
                                             delay(200);
                                        end;
                                    clrscr;
                               end;
               until uservalid;
               write('Please input a password: ');
               readln(cPassword);
               assign(passtext,'C:\GameData\'+cUser+'_UserPassword.txt');  {save user password to file}
               rewrite(passtext);
               write(passtext,cPassword);
               close(passtext);
               assign(t0,'C:\GameData\'+cUser+'_UserInfoCreation.txt');
               rewrite(t0);
               write(t0,'0');
               close(t0);
               write('User successfully created!');
               for ci:=1 to 15 do
                   begin
                        write('.');
                        delay(200);
                   end;
               clrscr;
          end;

//--------------------User login---------------------
PROCEDURE login(
          var stayProg:integer;
          var LoUserid:string[30]
          );
          var
             loi,count,attempts:integer;
             leaveLogin,LoUserEx,gotoLogin:boolean;
             YN:char;
             LoUsertext,LoPasstext:text;
             LoUsername,LoPassUser:string[30];
             LoPassword,LoInputPassword:string;
          begin
               count:=1;
               leaveLogin:=FALSE;
               repeat
                     gotoLogin:=FALSE;
                     TextColor(LightRed);
                     writeln('Maths Hunter!':48);
                     GotoXY(1,12);
                     TextColor(white);
                     write('Welcome! Are you a new challenger? (Y/N): ':61);
                     readln(YN);
                     if (YN='N') or (YN='n')
                     then gotoLogin:=TRUE
                     else if (YN='Y') or (YN='y')
                          then createUserAccount()
                          else begin
                                    write('Invaild input! Please input Y or N!':57);
                                    for loi:=1 to 10 do
                                        begin
                                             write('.');
                                             delay(200);
                                        end;
                                    clrscr;
                               end;
                until gotoLogin=TRUE;
                clrscr;
                LoUserEx:=FALSE;
                repeat
                     if LoUserEx=FALSE
                     then begin
                     GotoXY(30,1);
                     TextColor(LightRed);
                     writeln('Maths Hunter: Login');
                     GotoXY(24,12);
                     TextColor(white);
                     write('username: ');
                     readln(LoUsername);
                     if LoUsername='ccm2IsHandsome'   {eater egg: snake game}
                     then snakeGame();
                     assign(LoUsertext,'C:\GameData\userIDs.txt');
                     reset(LoUsertext);
                     while not eof(LoUsertext) do     {check if user exist}
                           begin
                                readln(LoUsertext,LoPassUser);
                                if LoUsername = LoPassUser
                                then LoUserEx:=TRUE;
                           end;
                     close(LoUsertext);
                     end;
                     if LoUserEx=FALSE
                     then begin
                               writeln();
                               attempts:=4-count;
                               GotoXY(24,13);
                               write('User not exist!');
                               GotoXY(24,14);
                               write('You have ',attempts,' more attempts.');
                               for loi:=1 to 10 do
                                   begin
                                        write('.');
                                        delay(200);
                                   end;
                               clrscr;
                               count:=count+1;
                          end;
                     if LoUserEx=TRUE
                     then begin
                               clrscr;
                               GotoXY(30,1);
                               TextColor(LightRed);
                               writeln('Maths Hunter: Login');
                               GotoXY(24,12);
                               TextColor(white);
                               write('username: ');
                               write(LoUsername);
                               GotoXY(24,13);
                               write('Password: ');
                               readln(LoInputPassword);
                               assign(LoPasstext,'C:\GameData\'+LoUsername+'_UserPassword.txt');
                               reset(LoPasstext);
                               readln(LoPasstext,LoPassword);
                               close(LoPasstext);
                               if LoInputPassword=LoPassword
                               then begin
                                         GotoXY(24,14);
                                         writeln();
                                         GotoXY(24,15);
                                         write('Login successful!');
                                         LoUserid:=LoUsername;
                                         for loi:=1 to 10 do
                                             begin
                                                  write('.');
                                                  delay(200);
                                             end;
                                         clrscr;
                                         leaveLogin:=TRUE;
                                     end
                               else begin
                                         GotoXY(24,14);
                                         writeln('Incorrect Password!');
                                         GotoXY(24,15);
                                         write('You have ',4-count,' more attempts.');
                                         for loi:=1 to 10 do
                                         begin
                                              write('.');
                                              delay(200);
                                         end;
                                         clrscr;
                                         count:=count+1;
                                    end;
                          end;
                       if count=5
                       then begin
                                 clrscr;
                                 writeln('You have already done 4 wrong attempts.');
                                 writeln('The game is going to terminate itself.');
                                 for loi:=1 to 10 do
                                     begin
                                          write('.');
                                          delay(200);
                                     end;
                                 stayProg:=0;
                             end;
               until (count=5) or (leaveLogin=TRUE);
end;

//----------------check if user informaion exist-----------------------
FUNCTION userInfoCreated(
         var UICid:string[30]
         ):boolean;

         var
            UICtext:text;
            UIC:integer;
         begin
              assign(UICtext,'C:\GameData\'+UICid+'_UserInfoCreation.txt');
              reset(UICtext);
              readln(UICtext,UIC);
              close(UICtext);
              if UIC=1
              then userInfoCreated:=TRUE
              else userInfoCreated:=FALSE;
         end;

//----------------Create New user information-----------------------
PROCEDURE MakeUser (
          var MuserID:string[30];
          var NewUsername: string;
          var MUserCreated: boolean;
          var MMonsterChoice, MUserEXP, MUserLV, MUserHP, MUserATK, MDifChoice: integer
          );

          var
             MUserMonsterText,MUserNameText,MUserCreationText,UserDifText:text;
             MMonCV,MDifCV,MnameV:boolean;

          begin
               delay(1000);
               writeln('Welcome to MATHS HUNTER!');
               delay(1000);
               MMonCV:=FALSE;
               MDifCV:=FALSE;
               MnameV:=FALSE;
               repeat
                     writeln('Please enter your name ,within 30 characters: (Press enter when done) '); {Get User name}
                     readln(NewUsername);
                     if length(NewUsername)>30
                     then writeln('Please enter a valid name!');
                     if length(NewUsername)<31
                     then MnameV:=TRUE;
               until length(NewUsername)<31;
               clrscr;
               writeln('Welcome, ',NewUsername,'.');
               delay(1000);
               writeln('Before you start your maths journey,');
               delay(1000);
               writeln('Please choose one moster as your partner!'); {Choosse partner}
               delay(1000);
               //------------------Monster arts-----------------
               TextColor(10);
               writeln('                               __');
               TextColor(10);
               write('                             /  `)');
               TextColor(14);
               writeln('                      __,,,,_');
               TextColor(10);
               write('                            / /');
               TextColor(14);
               writeln('          _ __..-;||`--/|/ /.|,-`-. ');
               TextColor(10);
               write('                           / /');
               TextColor(14);
               writeln('        (`/| ` |  \ \ \\ / / / / .-|/`,_');
               TextColor(10);
               write('          .-~~-.          / /');
               TextColor(14);
               writeln('        /|`\ \   |  \ | \| // // / -.,/_,|-,');
               TextColor(10);
               write('        /         `      / /');
               TextColor(14);
               writeln('        /<7| ;  \ \  | ; ||/ /| | \/    |`-/,,_,/)');
               TextColor(10);
               write('      /            \  _," /');
               TextColor(14);
               writeln('        /  _.-, `,-\,__|  _-| / \ \/|_/  |    .;./');
               TextColor(10);
               write('     /               "   /');
               TextColor(14);
               writeln('        `-`   / ;      / __/ \__ `/ |__/ |');
               TextColor(10);
               write('    /      ,_____,   ,-~?');
               TextColor(14);
               writeln('               `-       |  -| =|\_  \  |-| |');
               TextColor(10);
               write('   / /~|  |     |  |');
               TextColor(14);
               writeln('                          __/   /_..-| `  ),|  //');
               TextColor(10);
               write('   /   |__|     |__|');
               TextColor(14);
               writeln('                        ((__.- ((___..-/  \__.|');
               writeln();
               TextColor(10);
               //------------------Monster details-----------------
               write('          1.Diana Lv.1');
               TextColor(14);
               writeln('                              2.Taiga Lv.1');
               TextColor(10);
               write('          HP: 60');
               TextColor(14);
               writeln('                                    HP: 30');
               TextColor(10);
               write('          ATK: 10');
               TextColor(14);
               writeln('                                   ATK: 20');
               writeln();
               //------------------Input Monster choice-----------------
               TextColor(7);
               MUserLV:=1;{initialize LV =1}
               MUserEXP:=0;{initialize EXP =0}
               repeat {repeat until choice =1 or 2}
                     TextColor(white);
                     write('Which one would you choose? (type in 1 or 2) ');
                     readln(MMonsterChoice);
                     if (MMonsterChoice<1) or (MMonsterChoice>2)
                     then
                         begin
                              writeln('Invalid input! Please choose 1 or 2!');
                              writeln();
                         end;
                     if (MMonsterChoice=1) or (MMonsterChoice=2)
                     then MMonCV:=TRUE;
               until (MMonsterChoice=1) or (MMonsterChoice=2);
               {Repeat user's choice}
               if (MMonsterChoice=1)
               then begin
                         writeln('Okay! Your parnter will be Diana!');
                         MUserHP:=60;
                         MUserATK:=10;
                    end
               else if (MMonsterChoice=2)
                    then begin
                              writeln('Okay! Your parnter will be Taiga!');
                              MUserHP:=30;
                              MUserATK:=20;
                         end;
               //------------------Select Difficulties-----------------
               repeat {repeat until choice = 1, 2 or 3}
                     TextColor(white);
                     writeln('Please choose a difficulty, ');
                     write('type in 1 for easy, 2 for difficult or 3 for master: ');
                     readln(MDifChoice);
                     if (MDifChoice=1) or (MDifChoice=2) or (MDifChoice=3)
                     then MDifCV:=TRUE
                     else
                         begin
                              writeln('Invalid input! Please choose 1, 2 or 3!');
                              writeln();
                         end;
               until (MDifChoice=1) or (MDifChoice=2) or (MDifChoice=3);
               {User is created}
               MUserCreated:=TRUE;
               write('Please press Enter to continue: ');
               readln();
               //------------------Mark User information created in UserInfoCreation-----------------
               if MMonCV and MDifCV and MnameV
               then begin
                    assign(MUserCreationText,'C:\GameData\'+MuserID+'_UserInfoCreation.txt');
                    rewrite(MUserCreationText);
                    write(MUserCreationText,'1');
                    close(MUserCreationText);
                    end;
               //------------------Save User name to file-----------------
               assign(MUserNameText,'C:\GameData\'+MuserID+'_UserName.txt');
               rewrite(MUserNameText);
               write(MUserNameText, NewUsername);
               close(MUserNameText);
               //------------------Save User monster to file-----------------
               assign(MUserMonsterText,'C:\GameData\'+MuserID+'_UserMonster.txt');
               rewrite(MUserMonsterText);
               write(MUserMonsterText, MMonsterChoice);
               close(MUserMonsterText);
               //------------------Save Difficulty to file-----------------
               assign(UserDifText,'C:\GameData\'+MuserID+'_UserDif.txt');
               rewrite(UserDifText);	
               write(UserDifText, MDifChoice);
               close(UserDifText);
          end;

//-----------------Introducing story background of this RPG--------------------
PROCEDURE Introduction(
          var INusername:string
          );

          begin
               clrscr;
               TextColor(LightCyan);
               writeln('Welcome to the world of Maths Hunter, ', INusername,'!');
               delay(1500);
               writeln('This is a world called Mathematica.');
               delay(1500);
               writeln('Everything rely on maths and calculator is used in every job.');
               delay(1500);
               writeln('But, one day, the evil monster CCM2 stole all the calculators and people cannot work anymore!');
               delay(1500);
               writeln('As calculators are very important, people in Mathematica decided to sent you,');
               delay(1500);
               writeln(INusername, ', the most brave hero to defeat CCM2');
               delay(1500);
               writeln('So they can get back their calculators and recover the world of Mathematica!');
               delay(1500);
               writeln('However, CCM2 and his monster army live in dangerous dungeons.');
               delay(1500);
               writeln('So you have to go to the dungeons, defeat the monster and find CCM2!!');
               TextColor(White);
               write('Please press Enter to continue: ');
               readln();
          end;

//-----------------change difficulties in MyRoom--------------------
PROCEDURE changeDif(
          var CDFuserID:string[30]
          );

          var
             CDFtext:text;
             CDFdif:integer;

          begin
               repeat
                     clrscr;
                     TextColor(white);
                     writeln('Please choose a difficulty, ');
                     write('Type in 1 for easy, 2 for difficult or 3 for master: ');
                     readln(CDFdif);
                     if (CDFdif=1) or (CDFdif=2) or (CDFdif=3)
                     then CDFdif:=CDFdif
                     else
                         begin
                              writeln('Invalid input! Please choose 1, 2 or 3!');
                              writeln();
                              clrscr;
                         end;
               until (CDFdif=1) or (CDFdif=2) or (CDFdif=3);
               assign(CDFtext,'C:\GameData\'+CDFuserID+'_UserDif.txt');
               rewrite(CDFtext);
               write(CDFtext,CDFdif);
               close(CDFtext);
          end;

//-----------------showing player status, read user data from files, recover user HP--------------------
PROCEDURE MyRoom(
          var MRuserID:string[30];
          var MRmonster,MRusername:string;
          var MRUserLV,MRUserHP,MRUserATK,MRGotoDungeon,MRDifChoice,MRdun1:integer
          );

          var
             MRtext:text;
             MRmonsterNo:char;
             MRRight, MRBattles, MRWrong, MRi, MRtrigo, MRcal, MRdun2:integer;
             MRUDif:string;

          begin
               clrscr;
               TextColor(Yellow);
               //-----------------read and write username, user difficuty---------------------
               assign(MRtext,'C:\GameData\'+MRuserID+'_UserName.txt');
               reset(MRtext);
               read(MRtext,MRusername);
               close(MRtext);
               assign(MRtext,'C:\GameData\'+MRuserID+'_UserDif.txt');
               reset(MRtext);
               read(MRtext,MRDifChoice);
               close(MRtext);
               case DifChoice of
               1: MRUDif:='Easy';
               2: MRUDif:='Difficult';
               3: MRUDif:='Master';
               end;
               writeln(MRusername,chr(39),'s Room                    Difficulty: ',MRUDif);
               writeln('================================================================================');
               //----------------read and write user Monster, LV-----------------------
               TextColor(LightGreen);
               writeln('Current Status');
               assign(MRtext,'C:\GameData\'+MRuserID+'_UserMonster.txt');
               reset(MRtext);
               read(MRtext,MRmonsterNo);
               close(MRtext);
               if MRmonsterNo='1'
               then MRmonster:='Diana'
               else MRmonster:='Taiga';
               assign(MRtext,'C:\GameData\'+MRuserID+'_UserLV.txt');
               reset(MRtext);
               read(MRtext,MRUserLV);
               close(MRtext);
               write('Your Monster is ',MRmonster,' Lv ',MRUserLV,'.  ');
               if MRUserLV=20
               then write('Max Lv');
               writeln();
               //----------------calculate and write user's HP, ATK, save user's HP, ATK to file-----------------------
               if MRmonster='Diana'
               then begin
                         MRUserHP:=60;
                         MRUserATK:=10;
                         for MRi:=1 to MRUserLV-1 do
                             begin
                                  MRUserHP:=trunc(MRUserHP*1.1);
                                  MRUserATK:=trunc(MRUserATK*1.1);
                             end;
                    end
               else begin
                         MRUserHP:=30;
                         MRUserATK:=20;
                         for MRi:=1 to MRUserLV-1 do
                             begin
                                  MRUserHP:=trunc(MRUserHP*1.1);
                                  MRUserATK:=trunc(MRUserATK*1.1);
                             end;
                    end;
               writeln('HP: ':17,MRUserHP:3,'ATK: ':17,MRUserATK:3);
               assign(MRtext,'C:\GameData\'+MRuserID+'_UserHP.txt');
               rewrite(MRtext);
               write(MRtext,MRUserHP);
               close(MRtext);
               assign(MRtext,'C:\GameData\'+MRuserID+'_UserATK.txt');
               rewrite(MRtext);
               write(MRtext,MRUserATK);
               close(MRtext);
               writeln('--------------------------------------------------------------------------------');
               //----------------read user's items from file and write it-----------------------
               TextColor(LightRed);
               assign(MRtext,'C:\GameData\'+MRuserID+'_trigo.txt');
               reset(MRtext);
               readln(MRtext,MRtrigo);
               close(MRtext);
               assign(MRtext,'C:\GameData\'+MRuserID+'_cal.txt');
               reset(MRtext);
               readln(MRtext,MRcal);
               close(MRtext);
               writeln('My backpacks (Items you currently have):');
               writeln('Calculus Textbook:':27,MRcal:3,'Trigonometry Textbook:':27,MRtrigo:3);
               writeln('--------------------------------------------------------------------------------');
               //----------------read user's play data from files and write-----------------------
               TextColor(LightCyan);
               writeln('Your Records');
               assign(MRtext,'C:\GameData\'+MRuserID+'_NoOfBattles.txt');
               reset(MRtext);
               read(MRtext,MRBattles);
               close(MRtext);
               assign(MRtext,'C:\GameData\'+MRuserID+'_NoOfRightAns.txt');
               reset(MRtext);
               read(MRtext,MRRight);
               close(MRtext);
               assign(MRtext,'C:\GameData\'+MRuserID+'_NoOfWrongAns.txt');
               reset(MRtext);
               read(MRtext,MRWrong);
               close(MRtext);
               assign(MRtext,'C:\GameData\'+MRuserID+'_ClearDungeon1.txt');
               reset(MRtext);
               read(MRtext,MRdun1);
               close(MRtext);
               assign(MRtext,'C:\GameData\'+MRuserID+'_ClearDungeon2.txt');
               reset(MRtext);
               read(MRtext,MRdun2);
               close(MRtext);
               write('Battles: ':17,MRBattles:3,'      Total answered: ':17,MRRight+MRWrong:3,'      Clear Dungeon 1: ');
               if MRdun1=1
               then writeln('Yes')
               else writeln('No');
               write('Right Answers: ':17,MRRight:3,'       Wrong Answers: ':17,MRWrong:3,'      Clear Dungeon 2: ');
               if MRdun2=1
               then writeln('Yes')
               else writeln('No');
               writeln('--------------------------------------------------------------------------------');
               //----------------user choose to go to dungeons or leave game-----------------------
               TextColor(white);
               writeln('Where would you like to go?');
               writeln('0. Exit Game.                        8. Change Difficulties');
               writeln('1. Dungeon of Additions and Subtractions');
               if MRdun1=1
               then writeln('2. Dungeon of Multiplications and Divisions');
               writeln('9. Online Maths Hunter Ranking');
               writeln();
               write('Input which dungeon (a number) you want to go and press enter: ');
               readln(MRGotoDungeon);
          end;

//----------------procedure run when user open a treasure box in dungeons, read and save items amount to file-----------------------
PROCEDURE getItems(
          var GETuserID:string[30]
          );

          var
             GETtext:text;
             GETtrigo,GETcal:integer;

          begin
               clrscr;
               randomize;
               if random()>0.8
               then begin
                         assign(GETtext,'C:\GameData\'+GETuserID+'_cal.txt');
                         reset(GETtext);
                         readln(GETtext,GETcal);
                         GETcal:=GETcal+1;
                         rewrite(GETtext);
                         write(GETtext,GETcal);
                         close(GETtext);
                         writeln('Congratulations! You found a Calculus textbook!');
                         delay(1500);
                         writeln('It can recover 30% of your HP in battles!');
                         delay(2200);
                    end
               else begin
                         assign(GETtext,'C:\GameData\'+GETuserID+'_trigo.txt');
                         reset(GETtext);
                         readln(GETtext,GETtrigo);
                         GETtrigo:=GETtrigo+1;
                         rewrite(GETtext);
                         write(GETtext,GETtrigo);
                         close(GETtext);
                         writeln('Congratulations! You found a Trigonometry textbook!');
                         delay(1500);
                         writeln('It can recover 10% of your HP in battles!');
                         delay(2200);
                    end;
           end;

//----------------Procedure for additions and subtractions in battles-----------------------
PROCEDURE AddSub(
          var ASDif:integer;
          var AScor:boolean);

          var
             operatorCode,no1,no2,sum,ans:integer;
             operator01,reminder:string;

          begin
               randomize;
               reminder:=' ';
               writeln('================================================================================');
               case ASDif of
               1:begin
                      no1:=random(9)+1;
                      no2:=random(9)+1;
                 end;
               2:begin
                      no1:=random(99)+1;
                      no2:=random(99)+1;
                 end;
               3:begin
                      no1:=random(999)+1;
                      no2:=random(999)+1;
                 end;
               end;
               operatorCode:=random(2)+1;
               case operatorCode of
               1:begin
                      operator01:=' + ';
                      sum:=no1+no2;
                 end;
               2:begin
                      operator01:=' - ';
                      sum:=no1-no2;
                 end;
               3:begin
                      operator01:=' * ';
                      sum:=no1*no2;
                 end;
               4:begin
                      operator01:=' / ';
                      reminder:=' (Correct to the nearest integer)';
                      sum:=round(no1/no2);
                 end;
               end;
               writeln(no1,operator01,no2,' = ?',reminder);
               write('Answer: ');
               readln(ans);
               if (ans=sum)
               then AScor:=TRUE
               else AScor:=FALSE;
          end;

//----------------Procedure for multipications and divisions in battles-----------------------
PROCEDURE MulDiv(
          var MDDif:integer;
          var MDcor:boolean);

          var
             operatorCode,no1,no2,sum,ans:integer;
             operator01,reminder:string;

          begin
               randomize;
               reminder:=' ';
               writeln('================================================================================');
               case MDDif of
               1:begin
                      no1:=random(9)+1;
                      no2:=random(9)+1;
                 end;
               2:begin
                      no1:=random(99)+1;
                      no2:=random(99)+1;
                 end;
               3:begin
                      no1:=random(999)+1;
                      no2:=random(999)+1;
                 end;
               end;
               operatorCode:=random(2)+1;
               case operatorCode of
               1:begin
                      operator01:=' * ';
                      sum:=no1*no2;
                 end;
               2:begin
                      operator01:=' / ';
                      reminder:=' (Correct to the nearest integer)';
                      sum:=round(no1/no2);
                 end;
               end;
               writeln(no1,operator01,no2,' = ?',reminder);
               write('Answer: ');
               readln(ans);
               if (ans=sum)
               then MDcor:=TRUE
               else MDcor:=FALSE;
          end;

//-----------------Using backpack items in battles-----------------
PROCEDURE UseItems(
          var UIuserID:string[30];
          var UIHP,initUIHP:integer
          );

          var
             UItext1,UItext2:text;
             UItrigo,UIcal,UIinput:integer;

          begin
               assign(UItext1,'C:\GameData\'+UIuserID+'_trigo.txt');
               assign(UItext2,'C:\GameData\'+UIuserID+'_cal.txt');
               reset(UItext1);
               reset(UItext2);
               readln(UItext1,UItrigo);
               readln(UItext2,UIcal);
               clrscr;
               repeat
                     TextColor(Yellow);
                     writeln('Backpack');
                     writeln('--------------------------------------------------------------------------------');
                     TextColor(LightCyan);
                     writeln('You currently have:');
                     writeln(UItrigo:5,' Trigonometry Textbook(s), which can recover 10% HP,');
                     writeln(UIcal:5,' Calculus Textbook(s), which can recover 30% HP.');
                     writeln('--------------------------------------------------------------------------------');
                     TextColor(LightGreen);
                     writeln('Your current HP is: ',UIHP:3,'/',initUIHP:3);
                     writeln();
                     TextColor(white);
                     writeln('Type in 1 to use Trigonometry Textbook,');
                     writeln('2 for Calculus Textbook');
                     writeln('And 0 for back to battle.');
                     write('Your choice is: ');
                     readln(UIinput);
                     case UIinput of
                     1:begin
                            if UItrigo<=0
                            then writeln('You have no Trigonometry Textbook left!');
                            if UIHP>=initUIHP
                            then writeln('Your HP is already full!');
                            if (UItrigo>0) and (UIHP<initUIHP)
                            then begin
                                      UIHP:=UIHP+trunc(initUIHP*0.1); {HP 10% UP}
                                      writeln('10% HP recoverd! Feel better now?');
                                      if UIHP>initUIHP {limit HP not to be > initial HP}
                                      then UIHP:=initUIHP;
                                      UItrigo:=UItrigo-1; {trigo -1}
                                      rewrite(UItext1);
                                      write(UItext1,UItrigo);
                                 end;
                       end;
                     2:begin
                            if UIcal<=0
                            then writeln('You have no Calculus Textbook left!');
                            if UIHP>=initUIHP
                            then writeln('Your HP is already full!');
                            if (UIcal>0) and (UIHP<initUIHP)
                            then begin
                                      UIHP:=UIHP+trunc(initUIHP*0.3); {HP 30% UP}
                                      writeln('30% HP recoverd! Feel better now?');
                                      if UIHP>initUIHP {limit HP not to be > initial HP}
                                      then UIHP:=initUIHP;
                                      UIcal:=UIcal-1; {cal -1}
                                      rewrite(UItext2);
                                      write(UItext2,UIcal);
                                 end;
                       end
                     else begin
                               writeln();
                               writeln('Wrong input! Please input again!');
                          end;
                     end;
                     delay(1300);
                     clrscr;
               until (UIinput=0);
               close(UItext1);
               close(UItext2);
          end;

//-----------------random battles in dungeons--------------------
PROCEDURE SmallBattle(
          var SBuserID:string[30];
          var SBHP,SBATK,SBDif,SBdungeon:integer
          );

          var
             monsHP,monsATK,initmonsHP,userMonsChoice,initSBHP,totalSBHP,SBLV,SBright,SBwrong,SBbattles,SBexpUp,SBEXP,SBi:integer;
             chosMon:real;
             SBcor,UseItemSkip,itemDone:boolean;
             SBmonster:string;
             SBtext,SBtext2,SBtext3,SBtext4:text;
             SBkey:char;

          begin
               randomize;
               chosMon:=random; {Random a monster to battle with}
               //---------------initial user HP------------------
               assign(SBtext,'C:\GameData\'+SBuserID+'_UserHP.txt');
               reset(SBtext);
               read(SBtext,initSBHP);
               close(SBtext);
               //---------------read user total HP------------------
               assign(SBtext,'C:\GameData\'+SBuserID+'_UserMonster.txt');
               reset(SBtext);
               readln(SBtext,userMonsChoice);
               close(SBtext);
               assign(SBtext,'C:\GameData\'+SBuserID+'_UserLV.txt');
               reset(SBtext);
               readln(SBtext,SBLV);
               close(SBtext);
               if userMonsChoice=1
               then totalSBHP:=60
               else if userMonsChoice=2
                    then totalSBHP:=30;
               for SBi:=1 to SBLV-1 do
                   totalSBHP:=trunc(totalSBHP*1.1);
               //---------------set monster HP and ATK----------------------
               if chosMon>0.8
               then begin
                         SBmonster:='Naughty Dog';
                         monsHP:=SBATK*5;
                         monsATK:=trunc(totalSBHP/3);
                         SBexpUp:=15;
                    end;
               if chosMon<0.8
               then begin
                         SBMonster:='CCM Mouse';
                         monsHP:=SBATK*3;
                         monsATK:=trunc(totalSBHP/4);
                         SBexpUp:=10;
                    end;
               initmonsHP:=monsHP; {initial monster HP}
               clrscr;
               writeln('A ',SBmonster,' appeared!');
               delay(1500);
               write('Ready');
               write('.');
               delay(200);
               write('.');
               delay(200);
               write('.');
               delay(200);
               write('.');
               delay(200);
               write('.');
               delay(200);
               write('.');
               delay(200);
               writeln(' Battle Start!');
               delay(1500);
               clrscr;
               repeat
                     clrscr;
                     //----------------Headings------------------
                     TextColor(Yellow);
                     writeln('Battle Time!');
                     {writeln(chosMon:3:3);} {development use}
                     writeln('--------------------------------------------------------------------------------');
                     //----------------Monster art------------------
                     TextColor(LightRed);
                     if SBmonster='Naughty Dog'
                     then begin
                               writeln('                               ,-~~-.___.');
                               writeln('                             / |  X     \');
                               writeln('                            (  )         0');
                               writeln('                             \_/-, ,----"');
                               writeln('                                 ====');
                               writeln('                                /  \-"~;');
                               writeln('                               /  __/~|');
                               writeln('                             =(  _____|');
                          end
                     else if SBmonster='CCM Mouse'
                          then begin
                                    writeln();
                                    writeln();
                                    writeln();
                                    writeln();
                                    writeln('                                   _____');
                                    writeln('                               _@ /     \');
                                    writeln('                             / o         \');
                                    writeln('                            <___m____m____>====--');
                               end;
                     TextColor(white);
                     writeln('--------------------------------------------------------------------------------');
                     //----------------Monster and User Status------------------
                     TextColor(LightCyan);
                     write(SBmonster,':     HP:',monsHP:3,'/',initmonsHP:3,'   ATK:',monsATK:3);
                     TextColor(white);
                     write('    vs    ');
                     TextColor(LightGreen);
                     writeln('You:     HP:',SBHP:3,'/',totalSBHP:3,'   ATK:',SBATK:3);
                     TextColor(white);

                     //----------------use items---------------
                     itemDone:=FALSE;
                     writeln('If you wish to use your items in your backpack (if any), please press delete.');
                     writeln('If not, press any key to continue.');
                     UseItemSkip:=FALSE;
                     SBkey:=readkey;
                     case SBkey of
                          #0:begin
                                  SBkey:=readkey;
                                  case SBkey of
                                       #83:begin
                                                UseItems(SBuserID,SBHP,totalSBHP);
                                                UseItemSkip:=TRUE;
                                           end;
                                  end;
                             end
                     else itemDone:=TRUE;
                     end;                    
                     //----------------Maths exercise part------------------
                     if (UseItemSkip=FALSE) and (itemDone=TRUE)
                     then begin
                               case SBdungeon of
                               1:AddSub(SBDif,SBcor);
                               2:MulDiv(SBDif,SBcor);
                               end;
                          end;
                     //----------------write answer right or wrong, and record the number of rights and wrongs------------------
                     if (UseItemSkip=FALSE) and (itemDone=TRUE)
                     then begin
                     Assign(SBtext,'C:\GameData\'+SBuserID+'_NoOfRightAns.txt');
                     Assign(SBtext2,'C:\GameData\'+SBuserID+'_NoOfWrongAns.txt');
                     reset(SBtext);
                     reset(SBtext2);
                     readln(SBtext,SBright);
                     readln(SBtext2,SBwrong);
                     if SBcor=TRUE
                     then begin
                               monsHP:=monsHP-SBATK;
                               writeln('You are right! ',SBmonster,' recieved an effective attack!');
                               rewrite(SBtext);
                               SBright:=SBright+1;
                               write(SBtext,SBright);
                          end
                     else if SBcor=FALSE
                          then begin
                                    SBHP:=SBHP-monsATK;
                                    writeln('You are wrong! :( ',SBmonster,' attacked you!');
                                    rewrite(SBtext2);
                                    SBwrong:=SBwrong+1;
                                    write(SBtext2,SBwrong);
                               end;
                     close(SBtext);
                     close(SBtext2);
                     delay(2000);
                     clrscr;
                     end;
               until (SBHP<=0) or (monsHP<=0);
               //------------------when user win------------------
               if monsHP<=0
               then begin
                         //---------------add EXP-------------------
                         assign(SBtext4,'C:\GameData\'+SBuserID+'_UserEXP.txt');
                         reset(SBtext4);
                         read(SBtext4,SBEXP);
                         SBEXP:=SBEXP+SBexpUp;
                         rewrite(SBtext4);
                         write(SBtext4,SBEXP);
                         close(SBtext4);
                         //---------------Level up if EXP enough----------------
                         assign(SBtext4,'C:\GameData\'+SBuserID+'_UserLV.txt');
                         reset(SBtext4);
                         read(SBtext4,SBLV);
                         repeat
                              if (SBEXP>=(SBLV*100)) and (SBLV<21) {limit max LV = 20}
                              then SBLV:=SBLV+1;
                         until SBEXP<(SBLV*100);
                         rewrite(SBtext4);
                         write(SBtext4,SBLV);
                         close(SBtext4);
                         for SBi:=1 to SBLV-1 do
                             begin
                                  totalSBHP:=trunc(totalSBHP*1.1);
                                  SBATK:=trunc(SBATK*1.1);
                             end;
                         assign(SBtext4,'C:\GameData\'+SBuserID+'_UserHP.txt');
                         rewrite(SBtext4);
                         write(SBtext4,totalSBHP);
                         close(SBtext4);
                         assign(SBtext4,'C:\GameData\'+SBuserID+'_UserATK.txt');
                         rewrite(SBtext4);
                         write(SBtext4,SBATK);
                         close(SBtext4);
                         TextColor(white);
                         writeln('Level Up! Congratulations! Your level is now lv.',SBLV,'!');
                         //---------------write user win-------------
                         TextColor(white);
                         writeln('Congratulations! You won this battle!');
                         write('EXP gained = ',SBexpUP);
                         delay(1000);
                         write('.');
                         delay(1000);
                         write('.');
                         delay(1000);
                         writeln('.');
                         clrscr;

                    end;
               //------------------when user lose, write user lose------------------
               if SBHP<=0
               then begin
                         TextColor(white);
                         writeln('Oh no! You lose! Your Monster',chr(39),'s HP become 0!');
                         writeln('Let',chr(39),'s go back to your room and recover your monster T^T');
                         delay(3000);
                         clrscr;
                    end;
               //------------------count of battles +1------------------
               assign(SBtext3,'C:\GameData\'+SBuserID+'_NoOfBattles.txt');
               reset(SBtext3);
               readln(SBtext3,SBbattles);
               SBbattles:=SBbattles+1;
               rewrite(SBtext3);
               write(SBtext3,SBbattles);
               close(SBtext3);
          end;

//--------------------Boss Battle for dungeon 1------------------
PROCEDURE BossBattle1(
          var BBuserID:string[30];
          var BBHP,SBATK,BBDif:integer;
          var BB1win:boolean
          );

          var
             monsHP,monsATK,initmonsHP,initBBHP,BBLV,BBright,BBwrong,BBbattles,BBexpUp,BBEXP,BBi,userMonsChoice,totalBBHP:integer;
             BBcor,UseItemSkip,itemDone:boolean;
             BBmonster:string;
             BBtext,BBtext2,BBtext3,BBtext4:text;
             BBkey:char;

          begin
               BB1win:=FALSE;
               //---------------initial user HP------------------
               assign(BBtext,'C:\GameData\'+BBuserID+'_UserHP.txt');
               reset(BBtext);
               read(BBtext,initBBHP);
               close(BBtext);
               //---------------read user total HP------------------
               assign(BBtext,'C:\GameData\'+BBuserID+'_UserMonster.txt');
               reset(BBtext);
               readln(BBtext,userMonsChoice);
               close(BBtext);
               assign(BBtext,'C:\GameData\'+BBuserID+'_UserLV.txt');
               reset(BBtext);
               readln(BBtext,BBLV);
               close(BBtext);
               if userMonsChoice=1
               then totalBBHP:=60
               else if userMonsChoice=2
                    then totalBBHP:=30;
               for BBi:=1 to BBLV-1 do
                   totalBBHP:=trunc(totalBBHP*1.1);
               //---------------set monster HP and ATK----------------------
               BBmonster:='Evil SAKANA';
               monsHP:=180;
               monsATK:=80;
               BBexpUp:=80;
               initmonsHP:=180; {initial monster HP}
               clrscr;
               repeat
                     //----------------Headings------------------
                     TextColor(Yellow);
                     writeln('Boss Battle 1!');
                     writeln('--------------------------------------------------------------------------------');
                     //----------------Monster art------------------
                     TextColor(LightRed);
                               writeln();
                               writeln();
                               writeln();
                               writeln('                              ,,///;,   ,;/');
                               writeln('                             X:::::::;;///');
                               writeln('                            >::::::::;;\\\');
                               writeln('                              \\\\\\\"" ;\');
                               writeln('                                 ;\');
                     TextColor(white);
                     writeln('--------------------------------------------------------------------------------');
                     //----------------Monster and User Status------------------
                     TextColor(LightCyan);
                     write(BBmonster,':     HP:',monsHP:3,'/',initmonsHP:3,'   ATK:',monsATK:3);
                     TextColor(white);
                     write('    vs    ');
                     TextColor(LightGreen);
                     writeln('You:     HP:',BBHP:3,'/',totalBBHP:3,'   ATK:',SBATK:3);
                     TextColor(white);

                     //----------------use items---------------
                     itemDone:=FALSE;
                     writeln('If you wish to use your items in your backpack (if any), please press delete.');
                     writeln('If not, press any key to continue.');
                     UseItemSkip:=FALSE;
                     BBkey:=readkey;
                     case BBkey of
                          #0:begin
                                  BBkey:=readkey;
                                  case BBkey of
                                       #83:begin
                                                UseItems(BBuserID,BBHP,totalBBHP);
                                                UseItemSkip:=TRUE;
                                           end;
                                  end;
                             end
                     else itemDone:=TRUE;
                     end;                    
                     //----------------addition and subtraction part------------------
                     if (UseItemSkip=FALSE) and (itemDone=TRUE)
                     then AddSub(BBDif,BBcor);
                     //----------------write answer right or wrong, and record the number of rights and wrongs------------------
                     if (UseItemSkip=FALSE) and (itemDone=TRUE)
                     then begin
                     Assign(BBtext,'C:\GameData\'+BBuserID+'_NoOfRightAns.txt');
                     Assign(BBtext2,'C:\GameData\'+BBuserID+'_NoOfWrongAns.txt');
                     reset(BBtext);
                     reset(BBtext2);
                     readln(BBtext,BBright);
                     readln(BBtext2,BBwrong);
                     if BBcor=TRUE
                     then begin
                               monsHP:=monsHP-SBATK;
                               writeln('You are right! ',BBmonster,' recieved an effective attack!');
                               rewrite(BBtext);
                               BBright:=BBright+1;
                               write(BBtext,BBright);
                          end
                     else if BBcor=FALSE
                          then begin
                                    BBHP:=BBHP-monsATK;
                                    writeln('You are wrong! :( ',BBmonster,' attacked you!');
                                    rewrite(BBtext2);
                                    BBwrong:=BBwrong+1;
                                    write(BBtext2,BBwrong);
                               end;
                     close(BBtext);
                     close(BBtext2);
                     delay(2000);
                     clrscr;
                     end;
               until (BBHP<=0) or (monsHP<=0);
               //------------------when user win------------------
               if monsHP<=0
               then begin
                         BB1win:=TRUE;
                         //---------------marked dungeon 1 cleared to file-------------------
                         assign(BBtext4,'C:\GameData\'+BBuserID+'_ClearDungeon1.txt');
                         rewrite(BBtext4);
                         write(BBtext4,1);
                         close(BBtext4);
                         //---------------add EXP-------------------
                         assign(BBtext4,'C:\GameData\'+BBuserID+'_UserEXP.txt');
                         reset(BBtext4);
                         read(BBtext4,BBEXP);
                         BBEXP:=BBEXP+BBexpUp;
                         rewrite(BBtext4);
                         write(BBtext4,BBEXP);
                         close(BBtext4);
                         //---------------Level up if EXP enough----------------
                         assign(BBtext4,'C:\GameData\'+BBuserID+'_UserLV.txt');
                         reset(BBtext4);
                         read(BBtext4,BBLV);
                         repeat
                               if (BBEXP>=(BBLV*100)) and (BBLV<21)  {limit max LV = 20 }
                               then BBLV:=BBLV+1;
                         until BBEXP<(BBLV*100);
                         rewrite(BBtext4);
                         write(BBtext4,BBLV);
                         close(BBtext4);
                         for BBi:=1 to BBLV-1 do
                             begin
                                  BBHP:=trunc(totalBBHP*1.1);
                                  SBATK:=trunc(SBATK*1.1);
                             end;
                         assign(BBtext4,'C:\GameData\'+BBuserID+'_UserHP.txt');
                         rewrite(BBtext4);
                         write(BBtext4,totalBBHP);
                         close(BBtext4);
                         assign(BBtext4,'C:\GameData\'+BBuserID+'_UserATK.txt');
                         rewrite(BBtext4);
                         write(BBtext4,SBATK);
                         close(BBtext4);
                         clrscr;
                    end;
               //------------------when user lose, write user lose------------------
               if BBHP<=0
               then BB1win:=FALSE;
               //------------------count of battles +1------------------
               assign(BBtext3,'C:\GameData\'+BBuserID+'_NoOfBattles.txt');
               reset(BBtext3);
               readln(BBtext3,BBbattles);
               BBbattles:=BBbattles+1;
               rewrite(BBtext3);
               write(BBtext3,BBbattles);
               close(BBtext3);
          end;

//--------------------Boss Battle for dungeon 2------------------
PROCEDURE BossBattle2(
          var BBuserID:string[30];
          var BBHP,SBATK,BBDif:integer;
          var BB2win:boolean
          );

          var
             monsHP,monsATK,initmonsHP,initBBHP,BBLV,BBright,BBwrong,BBbattles,BBexpUp,BBEXP,BBi,userMonsChoice,totalBBHP:integer;
             BBcor,UseItemSkip,itemDone:boolean;
             BBmonster:string;
             BBtext,BBtext2,BBtext3,BBtext4:text;
             BBkey:char;

          begin
               BB2win:=FALSE;
               //---------------initial user HP------------------
               assign(BBtext,'C:\GameData\'+BBuserID+'_UserHP.txt');
               reset(BBtext);
               read(BBtext,initBBHP);
               close(BBtext);
               //---------------read user total HP------------------
               assign(BBtext,'C:\GameData\'+BBuserID+'_UserMonster.txt');
               reset(BBtext);
               readln(BBtext,userMonsChoice);
               close(BBtext);
               assign(BBtext,'C:\GameData\'+BBuserID+'_UserLV.txt');
               reset(BBtext);
               readln(BBtext,BBLV);
               close(BBtext);
               if userMonsChoice=1
               then totalBBHP:=60
               else if userMonsChoice=2
                    then totalBBHP:=30;
               for BBi:=1 to BBLV-1 do
                   totalBBHP:=trunc(totalBBHP*1.1);
               //---------------set monster HP and ATK----------------------
               BBmonster:='Evil CCM2';
               monsHP:=360;
               monsATK:=160;
               BBexpUp:=160;
               initmonsHP:=360; {initial monster HP}
               clrscr;
               repeat
                     //----------------Headings------------------
                     TextColor(Yellow);
                     writeln('Boss Battle 2!');
                     writeln('--------------------------------------------------------------------------------');
                     //----------------Monster art------------------
                     TextColor(LightRed);
                               writeln();
                               writeln();
                               writeln();
                               writeln('                            ("\""/").___..--"""`-._  ');
                               writeln('                            `9_ 9  )   `-.  (     ).`-.__.`)');
                               writeln('                            (_Y_.)"  ._   )  `._ `. ``-..-"');
                               writeln('                          _..`--"_..-_/  /--"_." ."');
                               writeln('                         (il).-""  ((i)."  ((!.-"');
                     TextColor(white);
                     writeln('--------------------------------------------------------------------------------');
                     //----------------Monster and User Status------------------
                     TextColor(LightCyan);
                     write(BBmonster,':     HP:',monsHP:3,'/',initmonsHP:3,'   ATK:',monsATK:3);
                     TextColor(white);
                     write('    vs    ');
                     TextColor(LightGreen);
                     writeln('You:     HP:',BBHP:3,'/',totalBBHP:3,'   ATK:',SBATK:3);
                     TextColor(white);

                     //----------------use items---------------
                     itemDone:=FALSE;
                     writeln('If you wish to use your items in your backpack (if any), please press delete.');
                     writeln('If not, press any key to continue.');
                     UseItemSkip:=FALSE;
                     BBkey:=readkey;
                     case BBkey of
                          #0:begin
                                  BBkey:=readkey;
                                  case BBkey of
                                       #83:begin
                                                UseItems(BBuserID,BBHP,totalBBHP);
                                                UseItemSkip:=TRUE;
                                           end;
                                  end;
                             end
                     else itemDone:=TRUE;
                     end;                    
                     //----------------Multiplications and Divisions part------------------
                     if (UseItemSkip=FALSE) and (itemDone=TRUE)
                     then MulDiv(BBDif,BBcor);
                     //----------------write answer right or wrong, and record the number of rights and wrongs------------------
                     if (UseItemSkip=FALSE) and (itemDone=TRUE)
                     then begin
                     Assign(BBtext,'C:\GameData\'+BBuserID+'_NoOfRightAns.txt');
                     Assign(BBtext2,'C:\GameData\'+BBuserID+'_NoOfWrongAns.txt');
                     reset(BBtext);
                     reset(BBtext2);
                     readln(BBtext,BBright);
                     readln(BBtext2,BBwrong);
                     if BBcor=TRUE
                     then begin
                               monsHP:=monsHP-SBATK;
                               writeln('You are right! ',BBmonster,' recieved an effective attack!');
                               rewrite(BBtext);
                               BBright:=BBright+1;
                               write(BBtext,BBright);
                          end
                     else if BBcor=FALSE
                          then begin
                                    BBHP:=BBHP-monsATK;
                                    writeln('You are wrong! :( ',BBmonster,' attacked you!');
                                    rewrite(BBtext2);
                                    BBwrong:=BBwrong+1;
                                    write(BBtext2,BBwrong);
                               end;
                     close(BBtext);
                     close(BBtext2);
                     delay(2000);
                     clrscr;
                     end;
               until (BBHP<=0) or (monsHP<=0);
               //------------------when user win------------------
               if monsHP<=0
               then begin
                         BB2win:=TRUE;
                         //---------------marked dungeon 1 cleared to file-------------------
                         assign(BBtext4,'C:\GameData\'+BBuserID+'_ClearDungeon2.txt');
                         rewrite(BBtext4);
                         write(BBtext4,1);
                         close(BBtext4);
                         //---------------add EXP-------------------
                         assign(BBtext4,'C:\GameData\'+BBuserID+'_UserEXP.txt');
                         reset(BBtext4);
                         read(BBtext4,BBEXP);
                         BBEXP:=BBEXP+BBexpUp;
                         rewrite(BBtext4);
                         write(BBtext4,BBEXP);
                         close(BBtext4);
                         //---------------Level up if EXP enough----------------
                         assign(BBtext4,'C:\GameData\'+BBuserID+'_UserLV.txt');
                         reset(BBtext4);
                         read(BBtext4,BBLV);
                         repeat
                               if (BBEXP>=(BBLV*100)) and (BBLV<21)  {limit max LV = 20}
                               then BBLV:=BBLV+1;
                         until BBEXP<(BBLV*100);
                         rewrite(BBtext4);
                         write(BBtext4,BBLV);
                         close(BBtext4);
                         for BBi:=1 to BBLV-1 do
                             begin
                                  BBHP:=trunc(totalBBHP*1.1);
                                  SBATK:=trunc(SBATK*1.1);
                             end;
                         assign(BBtext4,'C:\GameData\'+BBuserID+'_UserHP.txt');
                         rewrite(BBtext4);
                         write(BBtext4,totalBBHP);
                         close(BBtext4);
                         assign(BBtext4,'C:\GameData\'+BBuserID+'_UserATK.txt');
                         rewrite(BBtext4);
                         write(BBtext4,SBATK);
                         close(BBtext4);
                         clrscr;
                    end;
               //------------------when user lose, write user lose------------------
               if BBHP<=0
               then BB2win:=FALSE;
               //------------------count of battles +1------------------
               assign(BBtext3,'C:\GameData\'+BBuserID+'_NoOfBattles.txt');
               reset(BBtext3);
               readln(BBtext3,BBbattles);
               BBbattles:=BBbattles+1;
               rewrite(BBtext3);
               write(BBtext3,BBbattles);
               close(BBtext3);
          end;

PROCEDURE Boss1Intro(
          var B1IuserID:string[30]
          );
          var
             B1Icontent:array[1..6] of string[80];
             B1I:integer;
             B1Itext:text;
             B1Iusername:string;

          begin
               assign(B1Itext,'C:\GameData\'+B1IuserID+'_UserName.txt');
               reset(B1Itext);
               readln(B1Itext,B1Iusername);
               close(B1Itext);
               B1Icontent[1]:='Welcome to my dungeon, '+B1Iusername;
               B1Icontent[2]:='My dungeon is very famous in the world of Mathmatica';
               B1Icontent[3]:='Because NO ONE can leave this dungeon after going in!';
               B1Icontent[4]:='Prepare to die! I will finish you right now!';
               B1Icontent[5]:='HAHAHAHAHAHAHAHA!';
               B1Icontent[6]:='Lets start our battle!';
               for B1I:=1 to 6 do
               begin
                    clrscr;
                    TextColor(LightRed);
                    writeln();
                    writeln();
                    writeln();
                    writeln('                                 ,,///;,   ,;/');
                    writeln('                                X:::::::;;///');
                    writeln('                               >::::::::;;\\\');
                    writeln('                                \\\\\\\"" ;\');
                    writeln('                                    ;\');
                    TextColor(Yellow);
                    writeln('===============||');
                    writeln('  Evil SAKANA  ||');
                    writeln('================================================================================');
                    writeln();
                    writeln(B1Icontent[B1I]);
                    writeln();
                    writeln('================================================================================');
                    delay(3400);
               end;
               clrscr;
          end;

PROCEDURE Boss1After(
          var B1AuserID:string[30];
          var B1ABossWin2:Boolean
          );

          var
             B1Acontent:array[1..3] of string[80];
             B1A:integer;
             B1Atext:text;
             B1Ausername:string;

          begin
               assign(B1Atext,'C:\GameData\'+B1AuserID+'_UserName.txt');
               reset(B1Atext);
               readln(B1Atext,B1Ausername);
               close(B1Atext);
               if B1ABossWin2=TRUE
               then begin
                         B1Acontent[1]:='Oh no...You win..., '+B1Ausername;
                         B1Acontent[2]:='Never mind, our boss CCM2 in the second dungeon is very strong!';
                         B1Acontent[3]:='He will take my revange!!';
                    end
               else begin
                         B1Acontent[1]:='HAHAHA! '+B1Ausername+', you lose!';
                         B1Acontent[2]:='You are so weak!';
                         B1Acontent[3]:='Bye bye!';
                    end;
               for B1A:=1 to 3 do
               begin
                    clrscr;
                    TextColor(LightRed);
                    writeln();
                    writeln();
                    writeln();
                    writeln('                                 ,,///;,   ,;/');
                    writeln('                                X:::::::;;///');
                    writeln('                               >::::::::;;\\\');
                    writeln('                                \\\\\\\"" ;\');
                    writeln('                                    ;\');
                    TextColor(Yellow);
                    writeln('===============||');
                    writeln('  Evil SAKANA  ||');
                    writeln('================================================================================');
                    writeln();
                    writeln(B1Acontent[B1A]);
                    writeln();
                    writeln('================================================================================');
                    delay(3000);
               end;
               clrscr;

          end;


PROCEDURE Boss2Intro(
          var B2IuserID:string[30]
          );
          var
             B2Icontent:array[1..6] of string[80];
             B2I:integer;
             B2Itext:text;
             B2Iusername:string;

          begin
               assign(B2Itext,'C:\GameData\'+B2IuserID+'_UserName.txt');
               reset(B2Itext);
               readln(B2Itext,B2Iusername);
               close(B2Itext);
               B2Icontent[1]:='Finally you are here, '+B2Iusername;
               B2Icontent[2]:='And you will die here very soon! Haha';
               B2Icontent[3]:='Everyone in the world should study ICT, but not maths!';
               B2Icontent[4]:='So I will kill you and no one can get back the calculators!';
               B2Icontent[5]:='HAHAHAHAHAHAHAHA!';
               B2Icontent[6]:='Lets start our battle!';
               for B2I:=1 to 6 do
               begin
                    clrscr;
                    TextColor(LightRed);
                    writeln();
                    writeln();
                    writeln();
                    writeln('                            ("\""/").___..--"""`-._  ');
                    writeln('                            `9_ 9  )   `-.  (     ).`-.__.`)');
                    writeln('                            (_Y_.)"  ._   )  `._ `. ``-..-"');
                    writeln('                          _..`--"_..-_/  /--"_." ."');
                    writeln('                         (il).-""  ((i)."  ((!.-"');
                    TextColor(Yellow);
                    writeln('=============||');
                    writeln('  Evil CCM2  ||');
                    writeln('================================================================================');
                    writeln();
                    writeln(B2Icontent[B2I]);
                    writeln();
                    writeln('================================================================================');
                    delay(3400);
               end;
               clrscr;
          end;

PROCEDURE Boss2After(
         var B2AuserID:string[30];
          var B2ABossWin2:Boolean
          );

          var
             B2Acontent:array[1..2] of string[80];
             B2A:integer;
             B2Atext:text;
             B2Ausername:string;

          begin
               assign(B2Atext,'C:\GameData\'+B2AuserID+'_UserName.txt');
               reset(B2Atext);
               readln(B2Atext,B2Ausername);
               close(B2Atext);
               if B2ABossWin2=TRUE
               then begin
                         B2Acontent[1]:='You win..., '+B2Ausername;
                         B2Acontent[2]:='I will give those calculators back to you...';
                    end
               else begin
                         B2Acontent[1]:='HAHAHA! '+B2Ausername+', you lose!';
                         B2Acontent[2]:='You should go home and study ICT.';
                    end;
               for B2A:=1 to 2 do
               begin
                    clrscr;
                    TextColor(LightRed);
                    writeln();
                    writeln();
                    writeln();
                    writeln('                            ("\""/").___..--"""`-._  ');
                    writeln('                            `9_ 9  )   `-.  (     ).`-.__.`)');
                    writeln('                            (_Y_.)"  ._   )  `._ `. ``-..-"');
                    writeln('                          _..`--"_..-_/  /--"_." ."');
                    writeln('                         (il).-""  ((i)."  ((!.-"');
                    TextColor(Yellow);
                    writeln('=============||');
                    writeln('  Evil CCM2  ||');
                    writeln('================================================================================');
                    writeln();
                    writeln(B2Acontent[B2A]);
                    writeln();
                    writeln('================================================================================');
                    delay(3000);
               end;
               clrscr;
               if B2ABossWin2=TRUE
               then begin
                         writeln('Congratulations! You have just saved the world of Mathmatica!');
                         writeln('You have successfully finish all 2 boss battle!');
                    end;
               delay(3000);
          end;

//-----------------procedure for moving with arrow keys, entering battles, opening treasure boxes in dungeon 2-----------------
PROCEDURE keyControl(
          var KCuserID:string[30];
          var KCdungeon1map,KCdungeon1Finish:dungeonType;
          var KCHP,KCATK,KCDifChoice,KCux,KCuy:integer;
          var KCleaveDungeon,KCBossWin2:Boolean
          );

          var
             key:char;
             fy, fx, dungeon:integer;
          begin
               randomize;
               key:=readkey;
               dungeon:=2;
               case key of
               #0 : begin
                         key:= readkey();
                         case key of
                         #72:begin {up key}
                                   if KCdungeon1map[KCuy-1,KCux]=chr(32)
                                   then begin
                                             KCdungeon1map[KCuy-1,KCux]:='#';
                                             KCdungeon1map[KCuy,KCux]:=chr(32);
                                             KCuy:=KCuy-1;
                                             if random(100)+1>96
                                             then SmallBattle(KCuserID,KCHP,KCATK,KCDifChoice,dungeon);
                                             for fy:=-2 to 2 do
                                                 begin
                                                      for fx:=-2 to 2 do
                                                          begin
                                                               if (KCuy+fy>0) and (KCuy+fy<23) and (KCux+fx>0) and (KCux+fx<48)
                                                               then KCdungeon1Finish[KCuy+fy,KCux+fx]:='T';
                                                          end;
                                                 end;
                                        end
                                   else if KCdungeon1map[KCuy-1,KCux]='B'
                                        then begin
                                                  getItems(KCuserID);
                                                  KCdungeon1map[KCuy-1,KCux]:='E';
                                             end
                                        else if KCdungeon1map[KCuy-1,KCux]='M'
                                             then begin
                                                       Boss2Intro(KCuserID);
                                                       BossBattle2(KCuserID,KCHP,KCATK,KCDifChoice,KCBossWin2);
                                                       Boss2After(KCuserID,KCBossWin2);
                                                  end
                                             else begin
                                                       clrscr;
                                                       TextColor(LightRed);
                                                       writeln('You cannot walk across things!');
                                                       delay(500);
                                                       clrscr;
                                                  end;
                             end;
                         #80:begin {down key}
                                   if KCdungeon1map[KCuy+1,KCux]=chr(32)
                                   then begin
                                             KCdungeon1map[KCuy+1,KCux]:='#';
                                             KCdungeon1map[KCuy,KCux]:=chr(32);
                                             KCuy:=KCuy+1;
                                             if random(100)+1>96
                                             then SmallBattle(KCuserID,KCHP,KCATK,KCDifChoice,dungeon);
                                             for fy:=-2 to 2 do
                                                 begin
                                                      for fx:=-2 to 2 do
                                                          begin
                                                               if (KCuy+fy>0) and (KCuy+fy<23) and (KCux+fx>0) and (KCux+fx<48)
                                                               then KCdungeon1Finish[KCuy+fy,KCux+fx]:='T';
                                                          end;
                                                 end;
                                        end
                                   else if KCdungeon1map[KCuy+1,KCux]='B'
                                        then begin
                                                  getItems(KCuserID);
                                                  KCdungeon1map[KCuy+1,KCux]:='E';
                                             end
                                        else if KCdungeon1map[KCuy+1,KCux]='S'
                                             then KCleaveDungeon:=TRUE
                                             else begin
                                                       clrscr;
                                                       TextColor(LightRed);
                                                       writeln('You cannot walk across things!');
                                                       delay(500);
                                                       clrscr;
                                                  end;
                             end;
                         #75:begin {left key}
                                   if KCdungeon1map[KCuy,KCux-1]=chr(32)
                                   then begin
                                             KCdungeon1map[KCuy,KCux-1]:='#';
                                             KCdungeon1map[KCuy,KCux]:=chr(32);
                                             KCux:=KCux-1;
                                             if random(100)+1>96
                                             then SmallBattle(KCuserID,KCHP,KCATK,KCDifChoice,dungeon);
                                             for fy:=-2 to 2 do
                                                 begin
                                                      for fx:=-2 to 2 do
                                                          begin
                                                               if (KCuy+fy>0) and (KCuy+fy<23) and (KCux+fx>0) and (KCux+fx<48)
                                                               then KCdungeon1Finish[KCuy+fy,KCux+fx]:='T';
                                                          end;
                                                 end;
                                        end
                                   else if KCdungeon1map[KCuy,KCux-1]='B'
                                        then begin
                                                  getItems(KCuserID);
                                                  KCdungeon1map[KCuy,KCux-1]:='E';
                                             end
                                        else begin
                                                  clrscr;
                                                  TextColor(LightRed);
                                                  writeln('You cannot walk across things!');
                                                  delay(500);
                                                  clrscr;
                                             end;
                             end;
                         #77:begin {right key}
                                   if KCdungeon1map[KCuy,KCux+1]=chr(32)
                                   then begin
                                             KCdungeon1map[KCuy,KCux+1]:='#';
                                             KCdungeon1map[KCuy,KCux]:=chr(32);
                                             KCux:=KCux+1;
                                             if random(100)+1>96
                                             then SmallBattle(KCuserID,KCHP,KCATK,KCDifChoice,dungeon);
                                             for fy:=-2 to 2 do
                                                 begin
                                                      for fx:=-2 to 2 do
                                                          begin
                                                               if (KCuy+fy>0) and (KCuy+fy<23) and (KCux+fx>0) and (KCux+fx<48)
                                                               then KCdungeon1Finish[KCuy+fy,KCux+fx]:='T';
                                                          end;
                                                 end;
                                        end
                                   else if KCdungeon1map[KCuy,KCux+1]='B'
                                        then begin
                                                  getItems(KCuserID);
                                                  KCdungeon1map[KCuy,KCux+1]:='E';
                                             end
                                        else begin
                                                  clrscr;
                                                  TextColor(LightRed);
                                                  writeln('You cannot walk across things!');
                                                  delay(500);
                                                  clrscr;
                                             end;
                             end;
                         end;
                         clrscr;
                    end;
               end;
          end;

//-----------------procedure for moving with arrow keys, entering battles, opening treasure boxes in dungeon 1-----------------
PROCEDURE keyControl1(
          var KCuserID:string[30];
          var KCdungeon1map,KCdungeon1Finish:dungeon1Type;
          var KCHP,KCATK,KCDifChoice,KCux,KCuy:integer;
          var KCleaveDungeon,KCBossWin1:Boolean
          );

          var
             key:char;
             fy, fx, dungeon:integer;
          begin
               randomize;
               key:=readkey;
               dungeon:=1;
               case key of
               #0 : begin
                         key:= readkey();
                         case key of
                         #72:begin {up key}
                                   if KCdungeon1map[KCuy-1,KCux]=chr(32)
                                   then begin
                                             KCdungeon1map[KCuy-1,KCux]:='#';
                                             KCdungeon1map[KCuy,KCux]:=chr(32);
                                             KCuy:=KCuy-1;
                                             if random(100)+1>96
                                             then SmallBattle(KCuserID,KCHP,KCATK,KCDifChoice,dungeon);
                                             for fy:=-2 to 2 do
                                                 begin
                                                      for fx:=-2 to 2 do
                                                          begin
                                                               if (KCuy+fy>0) and (KCuy+fy<23) and (KCux+fx>0) and (KCux+fx<48)
                                                               then KCdungeon1Finish[KCuy+fy,KCux+fx]:='T';
                                                          end;
                                                 end;
                                        end
                                   else if KCdungeon1map[KCuy-1,KCux]='B'
                                        then begin
                                                  getItems(KCuserID);
                                                  KCdungeon1map[KCuy-1,KCux]:='E';
                                             end
                                        else if KCdungeon1map[KCuy-1,KCux]='M'
                                             then begin
                                                       Boss1Intro(KCuserID);
                                                       BossBattle1(KCuserID,KCHP,KCATK,KCDifChoice,KCBossWin1);
                                                       Boss1After(KCuserID,KCBossWin1);
                                                  end
                                             else begin
                                                       clrscr;
                                                       TextColor(LightRed);
                                                       writeln('You cannot walk across things!');
                                                       delay(500);
                                                       clrscr;
                                                  end;
                             end;
                         #80:begin {down key}
                                   if KCdungeon1map[KCuy+1,KCux]=chr(32)
                                   then begin
                                             KCdungeon1map[KCuy+1,KCux]:='#';
                                             KCdungeon1map[KCuy,KCux]:=chr(32);
                                             KCuy:=KCuy+1;
                                             if random(100)+1>96
                                             then SmallBattle(KCuserID,KCHP,KCATK,KCDifChoice,dungeon);
                                             for fy:=-2 to 2 do
                                                 begin
                                                      for fx:=-2 to 2 do
                                                          begin
                                                               if (KCuy+fy>0) and (KCuy+fy<23) and (KCux+fx>0) and (KCux+fx<48)
                                                               then KCdungeon1Finish[KCuy+fy,KCux+fx]:='T';
                                                          end;
                                                 end;
                                        end
                                   else if KCdungeon1map[KCuy+1,KCux]='B'
                                        then begin
                                                  getItems(KCuserID);
                                                  KCdungeon1map[KCuy+1,KCux]:='E';
                                             end
                                        else if KCdungeon1map[KCuy+1,KCux]='S'
                                             then KCleaveDungeon:=TRUE
                                             else begin
                                                       clrscr;
                                                       TextColor(LightRed);
                                                       writeln('You cannot walk across things!');
                                                       delay(500);
                                                       clrscr;
                                                  end;
                             end;
                         #75:begin {left key}
                                   if KCdungeon1map[KCuy,KCux-1]=chr(32)
                                   then begin
                                             KCdungeon1map[KCuy,KCux-1]:='#';
                                             KCdungeon1map[KCuy,KCux]:=chr(32);
                                             KCux:=KCux-1;
                                             if random(100)+1>96
                                             then SmallBattle(KCuserID,KCHP,KCATK,KCDifChoice,dungeon);
                                             for fy:=-2 to 2 do
                                                 begin
                                                      for fx:=-2 to 2 do
                                                          begin
                                                               if (KCuy+fy>0) and (KCuy+fy<23) and (KCux+fx>0) and (KCux+fx<48)
                                                               then KCdungeon1Finish[KCuy+fy,KCux+fx]:='T';
                                                          end;
                                                 end;
                                        end
                                   else if KCdungeon1map[KCuy,KCux-1]='B'
                                        then begin
                                                  getItems(KCuserID);
                                                  KCdungeon1map[KCuy,KCux-1]:='E';
                                             end
                                        else begin
                                                  clrscr;
                                                  TextColor(LightRed);
                                                  writeln('You cannot walk across things!');
                                                  delay(500);
                                                  clrscr;
                                             end;
                             end;
                         #77:begin {right key}
                                   if KCdungeon1map[KCuy,KCux+1]=chr(32)
                                   then begin
                                             KCdungeon1map[KCuy,KCux+1]:='#';
                                             KCdungeon1map[KCuy,KCux]:=chr(32);
                                             KCux:=KCux+1;
                                             if random(100)+1>96
                                             then SmallBattle(KCuserID,KCHP,KCATK,KCDifChoice,dungeon);
                                             for fy:=-2 to 2 do
                                                 begin
                                                      for fx:=-2 to 2 do
                                                          begin
                                                               if (KCuy+fy>0) and (KCuy+fy<23) and (KCux+fx>0) and (KCux+fx<48)
                                                               then KCdungeon1Finish[KCuy+fy,KCux+fx]:='T';
                                                          end;
                                                 end;
                                        end
                                   else if KCdungeon1map[KCuy,KCux+1]='B'
                                        then begin
                                                  getItems(KCuserID);
                                                  KCdungeon1map[KCuy,KCux+1]:='E';
                                             end
                                        else begin
                                                  clrscr;
                                                  TextColor(LightRed);
                                                  writeln('You cannot walk across things!');
                                                  delay(500);
                                                  clrscr;
                                             end;
                             end;
                         end;
                         clrscr;
                    end;
               end;
          end;

//-----------------Dungeon 1--------------------
PROCEDURE dungeon1(
          var DUNuserID:string[30];
          var DUNtrigo,DUNcal,DUNHP,DUNATK,DUNDifChoice:integer;
          var DUNBossWin1:boolean
          );

          var
             dungeon1map, dungeon1Finish:dungeon1Type;
             x, y ,ux, uy, countT:integer;
             dungeon1Text,dungeon1FinishText:text;
             leaveDungeon:boolean;

          begin
               clrscr;
               leaveDungeon:=FALSE;
               TextColor(white);
               //----------------read dungeon map to dungeon1map[y,x]----------------
               assign(dungeon1Text,'C:\GameData\Dungeon1map.txt');
               reset(dungeon1Text);
               for y:=1 to 22 do
                   begin
                        for x:=1 to 33 do
                            begin
                                 read(dungeon1Text,dungeon1map[y,x]);
                                 if dungeon1map[y,x]=' '
                                 then dungeon1map[y,x]:=chr(32);
                            end;
                   end;
               close(dungeon1Text);
               //----------------initialize user position-----------------
               uy:=21;
               ux:=26;
               dungeon1map[uy,ux]:='#';
               //----------------repeat for dungeon----------------
               repeat
               //----------------read map finish part----------------
               assign(dungeon1FinishText,'C:\GameData\Dungeon1finish.txt');
               reset(dungeon1FinishText);
               for y:=1 to 22 do
                   begin
                        for x:=1 to 33 do
                            read(dungeon1FinishText,dungeon1Finish[y,x]);
                   end;
               close(dungeon1FinishText);
               //----------------write map and user positon etc----------------
               countT:=0; {reset completed map counter}
               for y:=1 to 22 do
                   begin
                        for x:=1 to 31 do
                            begin
                                 if dungeon1Finish[y,x]='T'
                                 then begin
                                           countT:=countT+1; {count completed map}
                                           if (dungeon1map[y,x]='|') or (dungeon1map[y,x]='=')
                                           then begin
                                                TextColor(white);
                                                write(dungeon1map[y,x]);
                                                end
                                           else if (dungeon1map[y,x]='#')
                                                then begin
                                                          TextColor(Yellow);
                                                          write(dungeon1map[y,x]);
                                                     end
                                                else if (dungeon1map[y,x]='M')
                                                     then begin
                                                               TextColor(LightRed);
                                                               write(dungeon1map[y,x]);
                                                          end
                                                     else if (dungeon1map[y,x]='E')
                                                          then begin
                                                                    TextColor(LightMagenta);
                                                                    write(dungeon1map[y,x]);
                                                               end
                                                          else begin
                                                                    TextColor(LightCyan);
                                                                    write(dungeon1map[y,x]);
                                                               end;
                                      end
                                 else begin
                                           TextColor(White);
                                           write(chr(32));
                                      end;
                        end;
                        writeln(y);
                   end;
               //--------------------words at the bottom--------------------------------
               writeln('Map complete rate: ',(countT/6.82):3:1,'%');
               writeln('Instructions:        Use arrow keys to move');
               TextColor(Yellow);
               write('#');
               TextColor(White);
               write('=current position ');
               TextColor(LightCyan);
               write('B');
               TextColor(White);
               write('=Treasure Boxes ');
               TextColor(LightMagenta);
               write('E');
               TextColor(White);
               write('=empty Boxes ');
               TextColor(LightRed);
               write('M');
               TextColor(White);
               write('=boss of this dungeon.');
               //--------------key control-------------------
               keyControl1(DUNuserID,dungeon1map,dungeon1Finish,DUNHP,DUNATK,DUNDifChoice,ux,uy,leaveDungeon,DUNBossWin1);
               //----------------write map finish part----------------
               assign(dungeon1FinishText,'C:\GameData\Dungeon1finish.txt');
               rewrite(dungeon1FinishText);
               for y:=1 to 22 do
                   begin
                        for x:=1 to 33 do
                            write(dungeon1FinishText,dungeon1Finish[y,x]);
                   end;
               close(dungeon1FinishText);
               //-----------------send user back to room after die------------------
               if DUNHP<=0
               then leaveDungeon:=TRUE;
               until leaveDungeon=TRUE;
end;

//-----------------Dungeon 2--------------------
PROCEDURE dungeon2(
          var DUNuserID:string[30];
          var DUNtrigo,DUNcal,DUNHP,DUNATK,DUNDifChoice:integer;
          var DUNBossWin2:boolean
          );

          var
             dungeon2map, dungeon2Finish:dungeonType;
             x, y ,ux, uy, countT:integer;
             dungeon2Text,dungeon2FinishText:text;
             leaveDungeon:boolean;

          begin
               clrscr;
               leaveDungeon:=FALSE;
               TextColor(white);
               //----------------read dungeon map to dungeon2map[y,x]----------------
               assign(dungeon2Text,'C:\GameData\Dungeon2map.txt');
               reset(dungeon2Text);
               for y:=1 to 22 do
                   begin
                        for x:=1 to 47 do
                            begin
                                 read(dungeon2Text,dungeon2map[y,x]);
                                 if dungeon2map[y,x]=' '
                                 then dungeon2map[y,x]:=chr(32);
                            end;
                   end;
               close(dungeon2Text);
               //----------------initialize user position-----------------
               uy:=21;
               ux:=12;
               dungeon2map[uy,ux]:='#';
               //----------------repeat for dungeon----------------
               repeat
               //----------------read map finish part----------------
               assign(dungeon2FinishText,'C:\GameData\Dungeon2finish.txt');
               reset(dungeon2FinishText);
               for y:=1 to 22 do
                   begin
                        for x:=1 to 47 do
                            read(dungeon2FinishText,dungeon2Finish[y,x]);
                   end;
               close(dungeon2FinishText);
               //----------------write map and user positon etc----------------
               countT:=0; {reset completed map counter}
               for y:=1 to 22 do
                   begin
                        for x:=1 to 45 do
                            begin
                                 if dungeon2Finish[y,x]='T'
                                 then begin
                                           countT:=countT+1; {count completed map}
                                           if (dungeon2map[y,x]='|') or (dungeon2map[y,x]='=')
                                           then begin
                                                TextColor(white);
                                                write(dungeon2map[y,x]);
                                                end
                                           else if (dungeon2map[y,x]='#')
                                                then begin
                                                          TextColor(Yellow);
                                                          write(dungeon2map[y,x]);
                                                     end
                                                else if (dungeon2map[y,x]='M')
                                                     then begin
                                                               TextColor(LightRed);
                                                               write(dungeon2map[y,x]);
                                                          end
                                                     else if (dungeon2map[y,x]='E')
                                                          then begin
                                                                    TextColor(LightMagenta);
                                                                    write(dungeon2map[y,x]);
                                                               end
                                                          else begin
                                                                    TextColor(LightCyan);
                                                                    write(dungeon2map[y,x]);
                                                               end;
                                      end
                                 else begin
                                           TextColor(White);
                                           write(chr(32));
                                      end;
                        end;
                        writeln(y);
                   end;
               //--------------------words at the bottom--------------------------------
               writeln('Map complete rate: ',(countT/9.9):3:1,'%');
               writeln('Instructions:        Use arrow keys to move');
               TextColor(Yellow);
               write('#');
               TextColor(White);
               write('=current position ');
               TextColor(LightCyan);
               write('B');
               TextColor(White);
               write('=Treasure Boxes ');
               TextColor(LightMagenta);
               write('E');
               TextColor(White);
               write('=empty Boxes ');
               TextColor(LightRed);
               write('M');
               TextColor(White);
               write('=boss of this dungeon.');
               //--------------key control-------------------
               keyControl(DUNuserID,dungeon2map,dungeon2Finish,DUNHP,DUNATK,DUNDifChoice,ux,uy,leaveDungeon,DUNBossWin2);
               //----------------read map finish part----------------
               assign(dungeon2FinishText,'C:\GameData\Dungeon2finish.txt');
               rewrite(dungeon2FinishText);
               for y:=1 to 22 do
                   begin
                        for x:=1 to 47 do
                            write(dungeon2FinishText,dungeon2Finish[y,x]);
                   end;
               close(dungeon2FinishText);
               //-----------------send user back to room after die------------------
               if DUNHP<=0
               then leaveDungeon:=TRUE;
               until leaveDungeon=TRUE;
end;

//-------------------------View Online Ranking------------------------
PROCEDURE ViewRank();

          var
             PW,ID:integer;

          begin
               clrscr;
               TextColor(white);
               writeln('Welcome to online Maths Hunters',chr(39),' Assoication!');
               clrscr;
               TextColor(yellow);
               writeln('Top Maths Hunters',chr(39),' ranking:');
               writeln('--------------------------------------------------------------------------------');
               Textcolor(LightCyan);
               writeln();
               writeln('1.','You':30,' ......... correct answer rate: 99%');
               writeln('2.','LALALA':30,' ......... correct answer rate: 0%');
               writeln('3.','CCM20':30,' ......... correct answer rate: 0%');
               writeln('4.','ga':30,' ......... correct answer rate: 0%');
               writeln('5.','689':30,' ......... correct answer rate: 0%');
               writeln('6.','hateSBA':30,' ......... correct answer rate: 0%');
               writeln('--------------------------------------------------------------------------------');
               writeln();
               TextColor(LightGreen);
               writeln('Your current position: 1');
               writeln();
               TextColor(white);
               writeln('This page is for displaying the effect of the online ranking system only,');
               writeln('information shown is not accurate and not updated.');
               write('Press Enter key to leave:');
               readln();
          end;


//-------------------------Main program---------------------------
BEGIN
     titleScreen();
     if not FileExists('C:\GameData\DataCreateion.txt')
     then checkDataDirCreation(DataDirCreated);
     login(GotoDungeon,userID);
     if not userInfoCreated(userID)
     then begin
               MakeUser(userID,username,DataDirCreated,mosterChoice,UserEXP,UserLV,UserHP,UserATK,DifChoice);
               Introduction(username);
          end;
     repeat
           MyRoom(UserID,Username,UserMons,UserLV,UserHP,UserATK,GotoDungeon,DifChoice,Dungeon1Clear);
           if GotoDungeon=1
           then dungeon1(userID,trigo,cal,UserHP,UserATK,DifChoice,BossWin1);
           if (GotoDungeon=2) and (Dungeon1Clear=1)
           then dungeon2(userID,trigo,cal,UserHP,UserATK,DifChoice,BossWin2);
           if (GotoDungeon=9)
           then ViewRank();
           if (GotoDungeon=8)
           then changeDif(userID);
     until GotoDungeon=0;
END.