PROGRAM Maths;

        USES Crt;

        CONST    DimMax     =   10;
                 NbDeci     =   5;
                 Epsilon    =   1e-6;

        TYPE     Complexe   =   Array [0..1] of real;
                 Matrice2   =   Array [1..dimmax,1..dimmax] of Complexe;
                 Matrice    =   Record nbl,nbc:byte;
                                       Mat:matrice2;
                                end;
                 Matrices   =   Array ['A'..'Z'] of Matrice;
                 Complexes  =   Array ['a'..'z'] of Complexe;

        CONST    _0:complexe=(0,0);
                 _1:complexe=(1,0);
                 _i:complexe=(0,1);
                 _j:complexe=(-0.5,0.866025403785);
                 minuscules:set of char=['a'..'z'];
                 majuscules:set of char=['A'..'Z'];

        VAR      Mat:Matrices;
                 Com:Complexes;
                 Quitter:boolean;

PROCEDURE Attendre;
   Begin While not keypressed do;
   End;

PROCEDURE VideClavier;
 Var t:char;
   Begin While keypressed do t:=readkey;
   End;

FUNCTION Nul(x:real):boolean;
   Begin Nul:=abs(x)<epsilon;
   End;

FUNCTION Entier(x:real):boolean;
   Begin Entier:=Nul(Frac(x));
   End;

FUNCTION Sgn(x:real):char;
   Begin If nul(x)
         then Sgn:='0'
         else If x>0 then Sgn:='+' else Sgn:='-';
   End;

FUNCTION Module(z:complexe):real;
   Begin Module:=sqrt(sqr(z[0])+sqr(z[1]));
   End;

FUNCTION Argument(z:complexe):real;
   Begin Case Sgn(z[0]) of
         '+':Argument:=Arctan(z[1]/z[0]);
         '-':Case Sgn(z[1]) of
             '+':Argument:=Arctan(z[1]/z[0])+pi;
             '-':Argument:=Arctan(z[1]/z[0])-pi;
             '0':Argument:=pi;
             End;
         '0':Case Sgn(z[1]) of
             '+':Argument:=pi/2;
             '-':Argument:=-pi/2;
             '0':begin Write(#7); Argument:=0; end;
             End;
         End;
   End;

PROCEDURE EditerComplexe(var z:Complexe);
   Begin Read(z[0]); Write('+i*'); Read(z[1]);
   End;

PROCEDURE EditerMatrice(var M:Matrice);
 Var i,j:byte;
   Begin Write('nombre de lignes: '); Readln(M.nbl);
         Write('nombre de colonnes: '); Readln(M.nbc);
         For i:=1 to M.nbl do
         For j:=1 to M.nbc do
         begin Writeln('[',i,',',j,'] ');
               EditerComplexe(M.mat[i,j]);
         end;
   End;

PROCEDURE Inv(z:complexe;var zz:complexe);
 Var m:real;
   Begin m:=sqr(module(z));
         If nul(m)
         Then begin zz:=_0;
                    Write(#7);
              end
         Else begin zz[0]:=z[0]/m;
                    zz[1]:=-z[1]/m;
              end;
   End;

PROCEDURE Add(x,y:complexe;var z:complexe);
   Begin z[0]:=x[0]+y[0];
         z[1]:=x[1]+y[1];
   End;

PROCEDURE Sou(x,y:complexe;var z:complexe);
   Begin z[0]:=x[0]-y[0];
         z[1]:=x[1]-y[1];
   End;

PROCEDURE Mul(x,y:complexe;var z:complexe);
   Begin z[0]:=x[0]*y[0]-x[1]*y[1];
         z[1]:=x[0]*y[1]+x[1]*y[0];
   End;

PROCEDURE Divi(x,y:complexe;var z:complexe);
   Begin Inv(y,y);
         Mul(x,y,z);
   End;

PROCEDURE AddMat(A,B:Matrice;var C:Matrice);
 Var i,j:byte;
   Begin If (A.nbl=B.nbl) and (A.nbc=B.nbc)
         Then begin C.nbl:=A.nbl; C.nbc:=A.nbc;
                    For i:=1 to C.nbl do for j:=1 to C.nbc do
                    Add(A.mat[i,j],B.mat[i,j],C.mat[i,j]);
              end
         Else Writeln('Addition impossible: formats diff‚rents');
   End;

PROCEDURE SouMat(A,B:Matrice;var C:Matrice);
 Var i,j:byte;
   Begin If (A.nbl=B.nbl) and (A.nbc=B.nbc)
         Then begin C.nbl:=A.nbl; C.nbc:=A.nbc;
                    For i:=1 to C.nbl do for j:=1 to C.nbc do
                    Sou(A.mat[i,j],B.mat[i,j],C.mat[i,j]);
              end
         Else Writeln('Soustraction impossible: formats diff‚rents');
   End;

PROCEDURE MulMat(A,B:matrice;var C:Matrice);
 Var i,j,k:byte;
     z:complexe;
   Begin If (A.nbc=B.nbl)
         Then begin C.nbl:=A.nbl; C.nbc:=B.nbc;
                    For i:=1 to C.nbl do For j:=1 to C.nbc do
                    begin C.mat[i,j]:=_0;
                          For k:=1 to A.nbc do
                          begin Mul(A.mat[i,k],B.mat[k,j],z);
                                Add(z,C.mat[i,j],C.mat[i,j]);
                          end;
                    end;
              end
         Else Writeln('Produit impossible: formats incompatibles');
   End;

PROCEDURE MulExtMat(l:complexe;M:matrice;var N:matrice);
 Var i,j:byte;
   Begin N.nbl:=M.nbl; N.nbc:=M.nbc;
         For i:=1 to N.nbl do For j:=1 to N.nbc do
         Mul(l,M.mat[i,j],N.mat[i,j]);
   End;

PROCEDURE IDN(n:byte;var M:Matrice);
 Var i,j:byte;
   Begin For i:=1 to n do For j:=1 to n do
         if i=j then M.mat[i,j]:=_1 else M.mat[i,j]:=_0;
         M.nbl:=n; M.nbc:=n;
   End;

PROCEDURE InvMat(A:matrice;var B:matrice);
 Var i,p:byte;
     Ok:boolean;
 Procedure recherchelignepivot(A:matrice;p:byte;var l:byte;var Ok:boolean);
  var i:byte;
      z:complexe;
      m:real;
    begin z:=A.mat[p,p]; l:=p;
          For i:=p+1 to A.nbl do
          If module(A.mat[i,p])>module(z)
          Then begin z:=A.mat[i,p];
                     l:=i;
               end;
          Ok:=not nul(module(z));
    end;
  Procedure echangelignes(var A:matrice;l1,l2:byte);
   var j:byte; z:complexe;
     begin For j:=1 to A.nbc do
           begin z:=A.mat[l1,j];
                 A.mat[l1,j]:=A.mat[l2,j];
                 A.mat[l2,j]:=z;
           end;
     end;
  Procedure normligne(var A:matrice;p:byte;z:complexe);
   var j:byte;
     begin For j:=1 to A.nbc do Divi(A.mat[p,j],z,A.mat[p,j]);
     end;
  Procedure retrancheligne(var A:matrice;l:byte;z:complexe;p:byte);
   Var j:byte;
       zz:complexe;
     begin For j:=1 to A.nbc do
           begin Mul(z,A.mat[p,j],zz);
                 Sou(A.mat[l,j],zz,A.mat[l,j]);
           end;
     end;
   Begin If A.nbl=A.nbc
         Then begin IDN(A.nbc,B); Ok:=true;
                    p:=1;
                    While Ok and (p<=A.nbl) do
                    begin RechercheLignePivot(A,p,i,Ok);
                          If Ok
                          Then begin If i<>p
                                     Then begin EchangeLignes(B,i,p);
                                                EchangeLignes(A,i,p);
                                          end;
                                     normLigne(B,p,A.mat[p,p]);
                                     normLigne(A,p,A.mat[p,p]);
                                     For i:=1 to A.nbl do
                                     If i<>p
                                     Then begin RetrancheLigne(B,i,A.mat[i,p],p);
                                                RetrancheLigne(A,i,A.mat[i,p],p);
                                          end;
                                     inc(p);
                               end
                          Else begin B.nbc:=0;
                                     B.nbl:=0;
                               end;
                    end;
              end
         Else begin Writeln('La matrice n''est mˆme pas carr‚e!');
                    B.nbc:=0;
                    B.nbl:=0;
              end;
   End; (* InvMat *)

PROCEDURE ResoutSysteme(A:matrice;var X:matrice;B:matrice);
   Begin InvMat(A,A);
         MulMat(A,B,X);
   End;

PROCEDURE Transpose(A:matrice;var B:matrice);
 Var i,j:byte;
   Begin B.nbc:=A.nbl; B.nbl:=A.nbc;
         For i:=1 to B.nbl do For j:=1 to B.nbc do
         B.mat[i,j]:=A.mat[j,i];
   End;

PROCEDURE PuissMat(A:matrice;n:integer;var B:matrice);
 Var i:byte;
   Begin If A.nbl=A.nbc
         Then begin IDN(A.nbl,B);
                    If sgn(n)='-'
                    Then begin InvMat(A,A);
                               For i:=1 to n do MulMat(B,A,B);
                         end
                    Else For i:=1 to n do MulMat(B,A,B);
              end
         Else begin Writeln('La matrice n''est mˆme pas carr‚e!');
                    B.nbc:=0; B.nbl:=0;
              end;
   End;

PROCEDURE NulMat(n:byte;var A:matrice);
 Var i,j:byte;
   Begin A.nbl:=n; A.nbc:=n;
         For i:=1 to n do
         For j:=1 to n do
         A.mat[i,j]:=_0;
   End;

PROCEDURE InitVars(var Mat:Matrices;var Com:complexes);
 Var i:char;
     l,k:byte;
   Begin For i:='A' to 'Z' do NulMat(5,Mat[i]);
         For i:='a' to 'z' do Com[i]:=_0;
         IDN(4,Mat['I']);
         Com['p'][0]:=pi;
         Com['e']:=_1;
         Com['i']:=_i;
         Com['j']:=_j;
         For l:=1 to Mat['U'].nbc do
         For k:=1 to Mat['U'].nbc do
         Mat['U'].mat[l,k]:=_1;
         For l:=1 to Mat['N'].nbc-1 do Mat['N'].mat[l,l+1]:=_1;
   End;

PROCEDURE Toilette(var A:matrice);
 Var i,j:byte;
   Begin For i:=1 to A.nbl do For j:=1 to A.nbc do
         begin If Entier(A.mat[i,j][0])
               then A.mat[i,j][0]:=round(A.mat[i,j][0]);
               If Entier(A.mat[i,j][1])
               then A.mat[i,j][1]:=round(A.mat[i,j][1]);
         end;
   End;

FUNCTION Amel(x:real):string;
 Var s:string;
   Begin If Entier(x)
         then Str(round(x),s)
         else begin Str(x:0:NbDeci,s);
                    While s[length(s)]='0' do delete(s,length(s),1);
                    If s[length(s)]='.' then delete(s,length(s),1);
              end;
         Amel:=s;
   End;

PROCEDURE AfficheComplexe(z:complexe);
   Begin If nul(z[1])
         Then Write(Amel(z[0]))
         Else begin If not nul(z[0])
                    then Write(Amel(z[0]));
                    Write(sgn(z[1]));
                    If nul(abs(z[1])-1)
                    Then Write('i')
                    Else Write(Amel(abs(z[1]))+'i');
              end;
   End;

PROCEDURE AfficheMatrice(M:matrice);
 Var i,j:integer;
     x:byte;
   Begin For i:=1 to M.nbl do
         begin x:=WhereX;
               For j:=1 to M.nbc do
               begin GotoXY(x,WhereY);
                     Write('³ ');
                     AfficheComplexe(M.Mat[i,j]);
                     x:=x+15;
               end;
               Writeln;
         end;
   End;

PROCEDURE Exige(var t:char);
   Begin repeat t:=readkey;
         until (upcase(t) in majuscules)
         and not keypressed;
   End;

FUNCTION Ch(x:real):real;
   Begin Ch:=(exp(x)+exp(-x))/2;
   End;

FUNCTION Sh(x:real):real;
   Begin Sh:=(exp(x)-exp(-x))/2;
   End;

PROCEDURE GC1(var Mat:Matrices;var Com:Complexes);
 Var s:string;
     t1,t2:char;
   Begin Write('fonction: '); Readln(s);
         If s='cos'
         Then begin Write(s+'(');
                    Exige(t1); Write(t1+')Ä>');
                    Exige(t2); Writeln(t2);
                    If t1 in minuscules
                    Then begin Com[t2][0]:=cos(Com[t1][0])*ch(Com[t2][1]);
                               Com[t2][1]:=-sin(Com[t1][0])*sh(Com[t2][1]);
                               AfficheComplexe(Com[t2]);
                               Writeln;
                         end;
              end;
         If s='sin'
         Then begin Write(s+'(');
                    Exige(t1); Write(t1+')Ä>');
                    Exige(t2); Writeln(t2);
                    If t1 in minuscules
                    Then begin Com[t2][0]:=sin(Com[t1][0])*ch(Com[t2][1]);
                               Com[t2][1]:=cos(Com[t1][0])*sh(Com[t2][1]);
                               AfficheComplexe(Com[t2]);
                               Writeln;
                         end;
              end;
         If s='exp'
         Then begin
              end;
         If s='det'
         Then begin
              end;
         If s='nul'
         Then begin
              end;
   End;

PROCEDURE GC(var quitter:boolean;var Mat:Matrices;var Com:complexes);
 Var t,t1,t2,t3:char;
   Begin t:=readkey;
         If t<>#0
         Then begin Case t of
                         '?': begin Writeln('?...liste des commandes');
                                    Writeln('+...additionner');
                                    Writeln('-...soustraire');
                                    Writeln('*...multiplier');
                                    Writeln('/...diviser');
                                    Writeln('a...afficher');
                                    Writeln('e...‚diter');
                                    Writeln('f...appel de fonction');
                                    Writeln('i...inverser');
                                    Writeln('q...quitter');
                                    Writeln('t...transposer');
                                    Writeln('o...arrondir');
                              end;
                         '+': begin Write('(additionner) ');
                                    Exige(t1);     Write(t1,'+');
                                    Exige(t2);     Write(t2,'Ä>');
                                    Exige(t3);     Writeln(t3);
                                    If (t1 in minuscules)
                                    and (t2 in minuscules)
                                    then begin Add(Com[t1],Com[t2],Com[t3]);
                                               AfficheComplexe(Com[t3]);
                                               Writeln;
                                         end;
                                    If (t1 in majuscules)
                                    and (t2 in majuscules)
                                    then begin AddMat(Mat[t1],Mat[t2],Mat[t3]);
                                               AfficheMatrice(Mat[t3]);
                                               Writeln;
                                         end;
                              end;
                         '-': begin Write('(soustraire) ');
                                    Exige(t1);     Write(t1,'-');
                                    Exige(t2);     Write(t2,'Ä>');
                                    Exige(t3);     Writeln(t3);
                                    If (t1 in minuscules)
                                    and (t2 in minuscules)
                                    then begin Sou(Com[t1],Com[t2],Com[t3]);
                                               AfficheComplexe(Com[t3]);
                                               Writeln;
                                         end;
                                    If (t1 in majuscules)
                                    and (t2 in majuscules)
                                    then begin SouMat(Mat[t1],Mat[t2],Mat[t3]);
                                               AfficheMatrice(Mat[t3]);
                                               Writeln;
                                         end;
                              end;
                         '*': begin Write('(multiplier) ');
                                    Exige(t1);     Write(t1,'*');
                                    Exige(t2);     Write(t2,'Ä>');
                                    Exige(t3);     Writeln(t3);
                                    If (t1 in minuscules)
                                    and (t2 in minuscules)
                                    then begin Mul(Com[t1],Com[t2],Com[t3]);
                                               AfficheComplexe(Com[t3]);
                                               Writeln;
                                         end;
                                    If (t1 in majuscules)
                                    and (t2 in majuscules)
                                    then begin MulMat(Mat[t1],Mat[t2],Mat[t3]);
                                               AfficheMatrice(Mat[t3]);
                                               Writeln;
                                         end;
                                    If (t1 in minuscules)
                                    and (t2 in majuscules)
                                    then begin MulExtMat(Com[t1],Mat[t2],Mat[t3]);
                                               AfficheMatrice(Mat[t3]);
                                               Writeln;
                                         end;
                              end;
                         '/': begin Write('(diviser) ');
                                    Exige(t1);     Write(t1,'/');
                                    Exige(t2);     Write(t2,'Ä>');
                                    Exige(t3);     Writeln(t3);
                                    If (t1 in minuscules)
                                    and (t2 in minuscules)
                                    then begin Divi(Com[t1],Com[t2],Com[t3]);
                                               AfficheComplexe(Com[t3]);
                                               Writeln;
                                         end;
                                    If (t1 in majuscules)
                                    and (t2 in majuscules)
                                    then begin InvMat(Mat[t2],Mat[t3]);
                                               MulMat(Mat[t1],Mat[t3],Mat[t3]);
                                               AfficheMatrice(Mat[t3]);
                                               Writeln;
                                         end;
                              end;
                         'i': begin Write('(inverser) ');
                                    Exige(t1); Write('inv(',t1,')Ä>');
                                    Exige(t2); Writeln(t2);
                                    If t1 in minuscules
                                    Then begin Inv(Com[t1],Com[t2]);
                                               AfficheComplexe(Com[t2]);
                                               Writeln;
                                         end
                                    Else begin InvMat(Mat[t1],Mat[t2]);
                                               AfficheMatrice(Mat[t2]);
                                         end;
                              end;
                         'a': begin Write('(afficher) ');
                                    Exige(t1); Writeln(t1);
                                    If t1 in minuscules
                                    Then begin AfficheComplexe(Com[t1]);
                                               Writeln;
                                         end
                                    Else AfficheMatrice(Mat[t1]);
                              end;
                         'q': begin Write('(quitter?) ');
                                    Exige(t1); Writeln(t1);
                                    If upcase(t1)='O' then quitter:=true;
                              end;
                         'e': begin Write('(‚diter) ');
                                    Exige(t1); Write(t1);
                                    If t1 in minuscules
                                    Then begin Write('<Ä');
                                               EditerComplexe(Com[t1])
                                         end
                                    Else EditerMatrice(Mat[t1]);
                              end;
                         {'e': begin Write('(exponentielle) exp(');
                                    Exige(t1); Write(t1,')Ä>');
                                    Exige(t2); Write(t2);
                                    If t1 in minuscules
                                    Then begin Com[t2][0]:=exp(Com[t1][0])*cos(Com[t1][0]);
                                               Com[t2][1]:=exp(Com[t1][0])*sin(Com[t1][0]);
                                         end;
                              end;}
                         'f': GC1(Mat,Com);
                         't': begin Write('(transposer) ');
                                    Exige(t1); Write('Ô',t1,'Ä>');
                                    Exige(t2); Writeln(t2);
                                    Transpose(Mat[t1],Mat[t2]);
                                    AfficheMatrice(Mat[t2]);
                              end;
                         'o': begin Write('(arrondir) ');
                                    Exige(t1); Writeln(t1);
                                    Toilette(Mat[t1]);
                                    AfficheMatrice(Mat[t1]);
                              end;
                         '1': begin Write('(norme1) ');
                                    Exige(t1);
                                    If t1 in minuscules
                                    Then Write('º',t1,'ºÄ>');
                                    Exige(t2); Writeln(t2);
                                    If t1 in minuscules
                                    Then begin Com[t2][0]:=abs(Com[t1][0])+abs(Com[t1][1]);
                                               Com[t2][1]:=0;
                                               AfficheComplexe(Com[t2]);
                                               Writeln;
                                         end;
                              end;
                         '2': begin Write('(norme2) ');
                                    Exige(t1);
                                    If t1 in minuscules
                                    Then Write('³',t1,'³Ä>');
                                    Exige(t2); Writeln(t2);
                                    If t1 in minuscules
                                    Then begin Com[t2][0]:=Module(Com[t1]);
                                               Com[t2][1]:=0;
                                               AfficheComplexe(Com[t2]);
                                               Writeln;
                                         end;
                              end;
                    End;
              end
         Else begin t:=readkey;
                    {Case t of
                    End;}
              end;
   End;

BEGIN Randomize;
      Clrscr;
      Quitter:=false;
      InitVars(Mat,Com);
      While not Quitter do
      begin GC(quitter,Mat,Com);
      end;
END.