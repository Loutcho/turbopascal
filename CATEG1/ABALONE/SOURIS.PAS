PROCEDURE InitSouris;
 Var reg:registers;
   Begin reg.ax:=0;
         Intr(51,reg);
   End;

PROCEDURE Souris(b:boolean);
 Var reg:registers;
   Begin Case b of
          true:reg.ax:=1;
          false:reg.ax:=2;
         End;
         Intr(51,reg);
   End;

FUNCTION XSouris:integer;
 Var reg:registers;
   Begin reg.ax:=$3;
         Intr($33,reg);
         XSouris:=reg.cx
   End;

FUNCTION YSouris:integer;
 Var reg:registers;
   Begin reg.ax:=$3;
         Intr($33,reg);
         YSouris:=reg.dx
   End;

FUNCTION BoutonPresse(n:byte):boolean;
 Var reg:registers;
   Begin reg.ax:=5;
         reg.bx:=0;
         intr(51,reg);
         BoutonPresse:=(reg.ax and n)<>0;
   End;

PROCEDURE MinMaxX(x,y:integer);
 Var reg:registers;
   Begin reg.ax:=7;
         reg.cx:=x;
         reg.dx:=y;
         Intr(51,reg);
   End;

PROCEDURE MinMaxY(x,y:integer);
 Var reg:registers;
   Begin reg.ax:=8;
         reg.cx:=x;
         reg.dx:=y;
         Intr(51,reg);
   End;