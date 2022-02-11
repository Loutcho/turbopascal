(*  PROCEDURES ET FONCTIONS DE L'ECRAN; UTILISENT L'UNITE DOS *)

PROCEDURE Curseur(deb,fin:byte);
 Var reg:registers;
   Begin reg.ah:=$01;
         reg.ch:=deb;
         reg.cl:=fin;
         Intr($10,reg);
   End;

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
   Begin reg.bh:=$0;
         reg.ah:=$3;
         Intr($10,reg);
         OuEnX:=reg.dl;
   End;

FUNCTION OuEnY:byte;              (* Donne l'ordonn‚e du curseur *)
 Var Reg:registers;
   Begin reg.bh:=page;
         reg.ah:=$3;
         Intr($10,reg);
         OuEnY:=reg.dh;
   End;

PROCEDURE VaEnXY(x,y:byte);       (* Positionne le curseur en x,y *)
 Var reg:registers;
   Begin reg.ah:=$2;
         reg.bh:=page;
         reg.dl:=x;
         reg.dh:=y;
         Intr($10,reg);
   End;

PROCEDURE Ecryre(c:char);
 Var reg:registers;
   Begin  reg.al:=ord(c);      (* Code ascii de c *)
          reg.ah:=$9;          (* nø de la fonction *)
          reg.bl:=textattr;    (* attributs de c *)
          reg.bh:=page;
          reg.cx:=$01;         (* taille de la chaŒne *)
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

PROCEDURE AffPage(p:byte);
 Var reg:registers;
   Begin reg.ah:=$05;
         reg.al:=p;
         Intr($10,reg);
   End;

PROCEDURE ActivePolice(VAR police:T_Police);
 Var reg:registers;
   Begin reg.ah:=$11;
         reg.al:=$10;
         reg.bh:=16;
         reg.bl:=0;
         reg.cx:=256;
         reg.dx:=0;
         reg.es:=seg(police);
         reg.bp:=ofs(police);
         Intr($10,reg);
   End;