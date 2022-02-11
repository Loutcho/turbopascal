(*  PROCEDURES ET FONCTIONS DE L'ECRAN; UTILISENT L'UNITE DOS *)

PROCEDURE ModeVideo(mode:integer); (* Met l'‚cran au mode vid‚o "mode" *)
 Var reg:registers;
   Begin reg.ax:=mode;
         reg.ah:=0;
         Intr($10,reg);
   End;

FUNCTION QuelModeVideo:integer;
 Var reg:registers;
   Begin reg.ah:=$0F;
         Intr($10,reg);
         QuelModeVideo:=reg.ax mod $100;
   End;

FUNCTION OuEnX:byte;              (* Donne l'abscisse du curseur *)
 Var Reg:registers;
   Begin reg.bh:=$0;  (* n‚cessaire et je ne sais pas pourquoi *)
         reg.ah:=$3;
         Intr($10,reg);
         OuEnX:=reg.dl+1;
   End;

FUNCTION OuEnY:byte;              (* Donne l'ordonn‚e du curseur *)
 Var Reg:registers;
   Begin reg.bh:=$0; (* n‚cessaire et je ne sais pas pourquoi *)
         reg.ah:=$3;
         Intr($10,reg);
         OuEnY:=reg.dh+1;
   End;

PROCEDURE VaEnXY(x,y:byte);       (* Positionne le curseur en x,y *)
 Var reg:registers;
   Begin reg.al:=$0;
         reg.ah:=$2;    (* nø de la fonction *)
         reg.bx:=0;
         reg.cx:=0;
         reg.dl:=x-1;
         reg.dh:=y-1;
         Intr($10,reg);
   End;

PROCEDURE Ecryre(c:char);
 Var reg:registers;
   Begin
               reg.al:=ord(c);      (* Code ascii de c *)
               reg.ah:=$9;          (* nø de la fonction *)
               reg.bl:=textattr;    (* attributs de c *)
               reg.bh:=$0;
               reg.cl:=$01;         (* taille de la chaŒne *)
               reg.ch:=$0;
               reg.dl:=$0;
               reg.dh:=$0;
               Intr($10,reg);
   End;

PROCEDURE AvanceCurseur;            (* Avance le curseur vers la droite *)
   Begin VaEnXY(OuEnX+1,OuenY);
   End;

PROCEDURE Ecrire(s:string);         (* Ecrit une chaine de caractŠres *)
 Var i:integer;
   Begin For i:=1 to length(s) do
             begin Ecryre(s[i]);
                   AvanceCurseur;
             end;
   End;

PROCEDURE PlacePixel(x,y:integer;coul:byte);
 Var reg:registers;
   Begin With reg do
         begin ah:=$0C;
               al:=coul;
               bl:=0;
               bh:=0;
               cx:=x;
               dx:=y;
         end;
         Intr($10,reg);
   End;

FUNCTION LitPixel(x,y:integer):byte;
 Var reg:registers;
   Begin With reg do
         begin ah:=$0D;
               bl:=0;
               bh:=0;
               cx:=x;
               dx:=y;
         end;
         Intr($10,reg);
         LitPixel:=reg.Al;
   End;

PROCEDURE SwapInteger(a,b:integer);
 Var ab:integer;
   Begin ab:=a;
         a:=b;
         b:=ab;
   End;

PROCEDURE Ligne(x1,y1,x2,y2:integer;couleur:byte);
 Var D,Dx,Dy,aincr,bincr,xincr,yincr,x,y:integer;
   Begin If (abs(x2-x1)<abs(y2-y1)) then
         begin If (y1>y2) then
               begin SwapInteger(x1,x2);
                     SwapInteger(y1,y2);
               end;
               if (x2>x1) then xincr:=1
                          else xincr:=-1;
               dy:=y2-y1;
               dx:=abs(x2-x1);
               d:=2*dx-dy;
               aincr:=2*(dx-dy);
               bincr:=2*dx;
               x:=x1;
               y:=y1;
               PlacePixel(x,y,couleur);
               For y:=y1+1 to y2 do
               begin if d>=0 then
                     begin inc(x,xincr);
                           inc(d,aincr);
                     end
                     Else inc(d,bincr);
                     PlacePixel(x,y,couleur);
               end;
         end
         Else
         begin If (x1>x2) then
               begin SwapInteger(x1,x2);
                     SwapInteger(y1,y2);
               end;
               if (y2>y1) then yincr:=1
                          else yincr:=-1;
               dx:=x2-x1;
               dy:=abs(y2-y1);
               d:=2*dy-dx;
               aincr:=2*(dy-dx);
               bincr:=2*dy;
               x:=x1;
               y:=y1;
               PlacePixel(x,y,couleur);
               For x:=x1+1 to x2 do
               begin if d>=0 then
                     begin inc(y,yincr);
                           inc(d,aincr);
                     end
                     Else inc(d,bincr);
                     PlacePixel(x,y,couleur);
               end;
         end;
   End;

{PROCEDURE Ligne(x1,y1,x2,y2:integer;c:byte);
 Var Dx,Dy,i:integer;
     Incr:integer;
   Begin Dx := x2 - x1;
         Dy := y2 - y1;
         If Abs(Dx)>Abs(Dy)
         Then begin If x1>x2 then begin SwapInteger(x1,x2);
                                        SwapInteger(y1,y2);
                                  end;
                    Dx:=Abs(Dx);
                    Dy:=y2-y1;
                    If Dx<>0 then Incr:=Dy div Dx
                             else Incr:=0;
                    For i:=0 to Dx do
                    PlacePixel(x1+i,y1+Abs(Incr*i),c);
              end
         Else begin If y1>y2 then begin SwapInteger(y1,y2);
                                        SwapInteger(x1,x2);
                                  end;
                    Dy:=Abs(Dy);
                    Dx:=x2-x1;
                    If Dy<>0 then Incr:=Dx div Dy
                             else Incr:=0;
                    For i:=0 to Dy do
                    PlacePixel(x1+Abs(Incr*i),y1+i,c);
              end
   End;}

{PROCEDURE RectanglePlein(x1,y1,x2,y2:integer;coul:byte);
 Var i:integer;
   Begin For i:=x1 to x2 do
         Ligne(i,y1,i,y2,coul);
   End;

PROCEDURE RectangleVide(x1,y1,x2,y2:integer;coul:byte);
   Begin Ligne(x1,y1,x2,y1,coul);
         Ligne(x2,y1,x2,y2,coul);
         Ligne(x2,y2,x1,y2,coul);
         Ligne(x1,y2,x1,y1,coul);
   End;}

PROCEDURE RectanglePlein(x1,y1,x2,y2:integer;coul:byte);
 Var i,j:integer;
   Begin If x1>x2 then begin i:=x1; x1:=x2; x2:=i end;
         If y1>y2 then begin j:=y1; y1:=y2; y2:=j end;
         For i:=x1 to x2 do For j:=y1 to y2 do PlacePixel(i,j,coul);
   End;

PROCEDURE RectangleVide(x1,y1,x2,y2:integer;coul:byte);
 Var i:integer;
   Begin If x1>x2 then begin i:=x1; x1:=x2; x2:=i end;
         If y1>y2 then begin i:=y1; y1:=y2; y2:=i end;
         For i:=x1 to x2 do
         begin PlacePixel(i,y1,coul);
               PlacePixel(i,y2,coul);
         end;
         For i:=y1 to y2 do
         begin PlacePixel(x1,i,coul);
               PlacePixel(x2,i,coul);
         end;
   End;