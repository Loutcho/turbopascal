PROGRAM Machin;

        USES Crt;

        CONST TailleMax=250;

        TYPE Pile=Array[1..TailleMax] of real;

        VAR p:pile;
            quitter:boolean;
            taille:integer;

PROCEDURE Empile(var p:pile;x:real);
   Begin inc(taille);
         p[taille]:=x;
   End;

FUNCTION Depile(var p:pile):real;
   Begin If taille=0
         Then Depile:=0
         Else begin Depile:=p[taille];
                    dec(taille);
              end;
   End;

PROCEDURE GC(var quitter:boolean;var p:pile);
 Var t:char;
     s:string;
     code:integer;
     x,y,z:real;
   Begin Window(2,22,79,24); ClrScr;
         t:=readkey;
         If (t=#0)
         Then begin t:=readkey;
              end
         Else
         Case upcase(t) of
              #13:Empile(p,p[taille]);
              #27:quitter:=true;
              #8:x:=Depile(p);
              '+','-','*','/':
                begin y:=Depile(p);
                      x:=Depile(p);
                      Case t of
                      '+':z:=x+y;
                      '-':z:=x-y;
                      '*':z:=x*y;
                      '/':z:=x/y;
                      End;
                      Empile(p,z);
                end;
              'C': begin Write('Commande> '); Readln(s);
                         If s='raz'
                         Then taille:=0;
                         If s='ech'
                         Then begin x:=Depile(p); y:=Depile(p);
                                    Empile(p,x); Empile(p,y);
                              end;
                   end;
              'F': begin Write('Fonction> '); Readln(s);
                         x:=Depile(p); z:=x;
                         If s='cos' Then z:=cos(x);
                         If s='sin' Then z:=sin(x);
                         If s='exp' Then z:=exp(x);
                         If s='ln'  Then z:=ln(x);
                         If s='sqrt' Then z:=sqrt(x);
                         If s='-'   Then z:=-x;
                         If s='abs' Then z:=abs(x);
                         If s='arctan' Then z:=arctan(x);
                         Empile(p,z);
                   end;
         Else begin Write(t);
                    Readln(s);
                    s:=t+s;
                    inc(taille);
                    val(s,p[taille],code);
                    GotoXY(1,22);
                    ClrEol;
              end;
         End; {Case}
   End;

PROCEDURE AffichePile(VAR p:pile);
 Var i:integer;
   Begin Window(2,2,79,20);
         TextAttr:=Yellow+16*Blue;
         ClrScr;
         If taille=0 Then Write('í');
         For i:=1 to taille do
         Writeln(i:2,': ',p[i]:0:5);
         Window(1,1,80,25);
         TextAttr:=LightGray;
   End;

BEGIN TextAttr:=LightGray;
      ClrScr;
      quitter:=false; taille:=0;
      While not quitter do
      begin AffichePile(p);
            GC(quitter,p);
      end;
END.