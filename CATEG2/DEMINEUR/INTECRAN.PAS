PROCEDURE ModeVideo(mode:integer);
 Var reg:registers;
   Begin reg.ax:=mode;
         reg.ah:=0;
         Intr($10,reg);
   End;

PROCEDURE VaEnXY(x,y:byte);
 Var reg:registers;
   Begin reg.al:=$0;
         reg.ah:=$2;
         reg.bx:=0;
         reg.cx:=0;
         reg.dl:=x;
         reg.dh:=y;
         Intr($10,reg);
   End;

FUNCTION OuEnX:byte;
 Var Reg:registers;
   Begin reg.bh:=$0;
         reg.ah:=$3;
         Intr($10,reg);
         OuEnX:=reg.dl;
   End;

FUNCTION OuEnY:byte;
 Var Reg:registers;
   Begin reg.bh:=$0;
         reg.ah:=$3;
         Intr($10,reg);
         OuEnY:=reg.dh;
   End;

PROCEDURE Ecrire(s:string);
 Var reg:registers;
     tam:array[1..255]of char;
     i:byte;
   Begin For i:=1 to length(s) do tam[i]:=s[i];
         reg.ah:=$13;
         reg.al:=$1;
         reg.bl:=TextAttr;
         reg.cx:=length(s);
         reg.dh:=OuEnY;
         reg.dl:=OuEnX;
         reg.bh:=$0;
         reg.es:=seg(tam);
         reg.bp:=ofs(tam);
         Intr($10,reg);
   End;