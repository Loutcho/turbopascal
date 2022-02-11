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

PROCEDURE Ellipse(x,y,rx,ry:real;couleur:byte);
 Var alpha,incr,rsina,rcosa:real;
   Begin If (rx<>0) and (ry<>0)
         Then begin incr:=2.7/(pi*(rx+ry)/2);
                    alpha:=0;
              end
         Else alpha:=pi;
         While alpha<=pi/2 do
               begin rcosa:=rx*cos(alpha);
                     rsina:=ry*sin(alpha);
                     PlacePixel(round(x+rcosa),round(y+rsina),couleur);
                     PlacePixel(round(x+rcosa),round(y-rsina),couleur);
                     PlacePixel(round(x-rcosa),round(y+rsina),couleur);
                     PlacePixel(round(x-rcosa),round(y-rsina),couleur);
                     alpha:=alpha+incr;
               end;
   End;

PROCEDURE Lissajous(xo,yo:real;
                    coefx,coefy:real;
                    OmX,OmY:real;
                    Incr:real;
                    Coul:byte);
 Var t:real;
   Begin t:=0;
         incr:=abs(incr);
         if incr=0 then incr:=pi/1024;
         While t<=2*PI do
         begin PlacePixel(round(xo+CoefX*cos(OmX*t)),
                          round(yo+CoefY*sin(OmY*t)),
                          Coul);
               t:=t+incr;
         end;
   End;

FUNCTION Mini(a,b:real):real;
   Begin If a<=b then Mini:=a
                 else Mini:=b;
   End;

FUNCTION Maxi(a,b:real):real;
   Begin If a>=b then Maxi:=a
                 else Maxi:=b;
   End;

PROCEDURE Ligne(xA,yA,xB,yB:real;couleur:byte);
 Var Dx,Dy,a,b:real;
     i:integer;
   Begin Dx:=xA-xB; Dy:=yA-yB;
         If Abs(Dx)>Abs(Dy)
         Then begin a:=(Dy/Dx); b:=yA-a*xA;
                    For i:=round(mini(xA,xB)) to round(maxi(xA,xB)) do
                    PlacePixel(i,round(a*i+b),couleur);
              end
         Else begin a:=(Dx/Dy); b:=xA-a*yA;
                    For i:=round(mini(yA,yB)) to round(maxi(yA,yB)) do
                    PlacePixel(round(a*i+b),i,couleur);
              end;
   End;