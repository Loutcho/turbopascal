PROCEDURE InitSouris(var Statut,Boutons:integer);
 Var reg:registers;
   Begin reg.ax:=0;
         Intr(51,reg);
         Statut:=reg.ax;
         Boutons:=reg.bx;
   End;

PROCEDURE Curseur(b:boolean);
 Var reg:registers;
   Begin If b then reg.ax:=1
              else reg.ax:=2;
         Intr(51,reg);
   End;

FUNCTION PosX:integer;
 Var reg:registers;
   Begin reg.ax:=$3;
         Intr(51,reg);
         PosX:=reg.cx;
   End;

FUNCTION PosY:integer;
 Var reg:registers;
   Begin reg.ax:=$3;
         Intr(51,reg);
         PosY:=reg.dx;
   End;

PROCEDURE PlaceCurseur(x,y:Integer);
 Var reg:registers;
   Begin reg.ax:=4;
         reg.cx:=x;
         reg.dx:=y;
         Intr(51,reg);
   End;

FUNCTION BoutonPresse(n:byte):boolean;
 Var reg:registers;
   Begin reg.ax:=5;
         reg.bx:=0;
         intr(51,reg);
         BoutonPresse:=(reg.ax and n)<>0;
   End;

PROCEDURE DefZone(x1,y1,x2,y2:integer);
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

{ T_Curseur = Array [1..32] of word }

PROCEDURE DefCurseurGraphique(var c:T_Curseur_s;x,y:integer);
 Var reg : registers;
   Begin reg.bx := Col;
         reg.cx := Lig;
         reg.es := seg(Forme);
         reg.dx := ofs(Forme);
         reg.ax := 9;
         Intr(51,reg);
   End;

PROCEDURE DefCurseurTexte(car1:char;attr1:byte;car2:char;attr2:byte);
 Var reg:registers;
   Begin reg.ax:=10;
         reg.bx:=0;
         reg.cx:=ord(car1)+256*attr1;
         reg.dx:=ord(car2)+256*attr2;
         Intr(51,reg);
   End;