PROCEDURE InitSouris(var Statut,Boutons:integer);
 Var reg:registers;
   Begin reg.ax:=0;
         Intr(51,reg);
         Statut:=reg.ax;
         Boutons:=reg.bx;
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

FUNCTION PosXt:integer;
 Var reg:registers;
   Begin reg.ax:=$3;
         Intr(51,reg);
         PosXt:=reg.cx div 8 +1;
   End;

FUNCTION PosYt:integer;
 Var reg:registers;
   Begin reg.ax:=$3;
         Intr(51,reg);
         PosYt:=reg.dx div 8 +1;
   End;

PROCEDURE Curseur(b:boolean);
 Var reg:registers;
   Begin If b then reg.ax:=1
              else reg.ax:=2;
         Intr(51,reg);
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
