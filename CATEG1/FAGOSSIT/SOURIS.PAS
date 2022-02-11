PROCEDURE Init_s(var Statut,Boutons:integer);
 Var reg:registers;
   Begin reg.ax:=0;
         Intr(51,reg);
         Statut:=reg.ax;
         Boutons:=reg.bx;
   End;

PROCEDURE Curseur_s(b:boolean);
 Var reg:registers;
   Begin If b then reg.ax:=1
              else reg.ax:=2;
         Intr(51,reg);
   End;

FUNCTION PosX_s:integer;
 Var reg:registers;
   Begin reg.ax:=$3;
         Intr(51,reg);
         PosX_s:=reg.cx;
   End;

FUNCTION PosY_s:integer;
 Var reg:registers;
   Begin reg.ax:=$3;
         Intr(51,reg);
         PosY_s:=reg.dx;
   End;

PROCEDURE PlaceCurseur_s(x,y:Integer);
 Var reg:registers;
   Begin reg.ax:=4;
         reg.cx:=x;
         reg.dx:=y;
         Intr(51,reg);
   End;

FUNCTION BoutonPresse_s(n:byte):boolean;
 Var reg:registers;
   Begin reg.ax:=5;
         reg.bx:=0;
         intr(51,reg);
         BoutonPresse_s:=(reg.ax and n)<>0;
   End;

PROCEDURE DefZone_s(x1,y1,x2,y2:integer);
 Var reg:registers;
   Begin reg.ax:=7;
         reg.cx:=x1;
         reg.dx:=x2;
         Intr(51,reg);
         reg.ax:=8;
         reg.cx:=y1;
         reg.dx:=y2;
         Intr(51,reg);
   End;

{ T_Curseur_s = Array [1..32] of word }

PROCEDURE DefCurseurGraphique_s(var c:T_Curseur_s;x,y:integer);
 Var reg : registers;
   Begin reg.bx := x;
         reg.cx := y;
         reg.es := seg(c);
         reg.dx := ofs(c);
         reg.ax := 9;
         Intr(51,reg);
   End;

PROCEDURE DefCurseurTexte_s(car1:char;attr1:byte;car2:char;attr2:byte);
 Var reg:registers;
   Begin reg.ax:=10;
         reg.bx:=0;
         reg.cx:=ord(car1)+256*attr1;
         reg.dx:=ord(car2)+256*attr2;
         Intr(51,reg);
   End;