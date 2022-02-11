PROGRAM FonctionsDePlusieursVariables;

        USES Crt;

        CONST n=4; p=2;

        TYPE VecteurN = Array[1..n] of real;
             VecteurP = Array[1..p] of real;

        VAR x:vecteurn;
            fx:vecteurp;

PROCEDURE SaisirN(var v:vecteurn);
 Var i:integer;
   Begin For i:=1 to n do
         begin Write('[',i,']='); Readln(v[i]);
         end;
   End;

PROCEDURE SaisirP(var v:vecteurp);
 Var i:integer;
   Begin For i:=1 to p do
         begin Write('[',i,']='); Readln(v[i]);
         end;
   End;

PROCEDURE Fonction(x:vecteurn;var fx:vecteurp);
   Begin fx[1]:=sin(x[1]-x[2]);
         fx[2]:=-sin(x[1]-x[2]);
   End;

PROCEDURE AfficherN(v:vecteurn);
 Var i:integer;
   Begin For i:=1 to n do Writeln('[',i,']: ',v[i]:0:5,'               ');
   End;

PROCEDURE AfficherP(v:vecteurp);
 Var i:integer;
   Begin For i:=1 to p do Writeln('[',i,']: ',v[i]:0:5,'               ');
   End;

PROCEDURE Deriver(x:vecteurn;i:integer);
 Var h:real;
     xx:vecteurn;
     fx,fxx,f_x:vecteurp;
     j:integer;
   Begin h:=1; Fonction(x,fx); GotoXY(1,1); AfficherN(x);
         While (h>=1e-6) do
         begin xx:=x; xx[i]:=xx[i]+h;
               GotoXY(1,n+1);
               Fonction(xx,fxx);
               For j:=1 to p do f_x[j]:=(fxx[j]-fx[j])/h;
               Gotoxy(1,n+p+2); Writeln(h:0:6,'     ');
               AfficherP(f_x);
               h:=h*0.99;
         end;
   End;

BEGIN ClrScr;
      Saisirn(x);
      Deriver(x,1);
END.