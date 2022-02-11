PROGRAM Echecs;

USES Crt,Graph;

TYPE Grille = Array[0..7,0..7] of byte;

(*
⁄ƒƒƒ¬ƒƒƒ¬ƒƒƒ¬ƒƒƒ¬ƒƒƒ¬ƒƒƒ¬ƒƒƒ¬ƒƒƒ¬
≥   ≥   ≥   ≥   ≥   ≥   ≥   ≥   ≥
¿ƒƒƒ+ƒƒƒ+ƒƒƒ+ƒƒƒ+ƒƒƒ+ƒƒƒ+ƒƒƒ+ƒƒƒ+
∫abg∫e.p∫sÇl∫couleur∫ piäce     ∫
*)

CONST piece=7; rien=0;
               pion=1;
               caval=2;
               fou=3;
               tour=4;
               dame=5;
               roi=6;
      couleur=24; blanc=8;
                  noir=16;
      select=32;
      enpassant=64;
      abouge=128;
      MargeX=35; MargeY=35;
      CoteX=54; CoteY=54;

VAR g:grille;
    x,y,aki,xs,ys:shortint;
    quitter,fini,pselect:boolean;
    s:string;

{$I GRAFISME.PAS}

PROCEDURE InitGrille(var g:grille);
 Var x,y:shortint;
   Begin For x:=0 to 7 do
         begin For y:=2 to 5 do
               g[x,y]:=rien;
               g[x,1]:=pion+blanc;
               g[x,6]:=pion+noir;
         end;
         g[0,0]:=tour+blanc;
         g[1,0]:=caval+blanc;
         g[2,0]:=fou+blanc;
         g[3,0]:=dame+blanc;
         g[4,0]:=roi+blanc;
         g[5,0]:=fou+blanc;
         g[6,0]:=caval+blanc;
         g[7,0]:=tour+blanc;
         g[0,7]:=tour+noir;
         g[1,7]:=caval+noir;
         g[2,7]:=fou+noir;
         g[3,7]:=dame+noir;
         g[4,7]:=roi+noir;
         g[5,7]:=fou+noir;
         g[6,7]:=caval+noir;
         g[7,7]:=tour+noir;
   End;

FUNCTION cat(x:integer):string;
 Var s:string;
   Begin Str(x,s);
         cat:=s;
   End;

PROCEDURE Info;
   Begin
   End;

FUNCTION Ennemi(x:shortint):shortint;
   Begin Case x of
          noir:ennemi:=blanc;
          blanc:ennemi:=noir;
         Else ennemi:=rien;
         End;
   End;

PROCEDURE Effectue(x1,y1,x2,y2:shortint;special:char);
 Var y:shortint;
   Begin g[x2,y2]:=g[x1,y1] xor select;
         g[x1,y1]:=rien;
         Case special of
           'c','C' :
             g[x2,y2]:=(g[x2,y2] and $F8) or caval;
           'f','F' :
             g[x2,y2]:=(g[x2,y2] and $F8) or fou;
           't','T' :
             g[x2,y2]:=(g[x2,y2] and $F8) or tour;
           'd','D' :
             g[x2,y2]:=(g[x2,y2] and $F8) or dame;
           'e' :
             begin
               if (y2-y1)=2
               then y:=y1+1
               else y:=y1-1;
               g[x2,y]:=enpassant;
             end;
           'E' :
             begin
               g[x2,y1]:=rien;
               Place(x2,y1,g[x2,y1]);
             end;
         End;
         Place(x2,y2,g[x2,y2]);
         Place(x1,y1,g[x1,y1]);
   End;

PROCEDURE EffectueVirtuel(x1,y1,x2,y2:shortint;special:char;var g:grille);
 Var y:shortint;
   Begin g[x2,y2]:=g[x1,y1];
         g[x1,y1]:=rien;
         Case special of
         'c','C': g[x2,y2]:=(g[x2,y2] and $F8) or caval;
         'f','F': g[x2,y2]:=(g[x2,y2] and $F8) or fou;
         't','T': g[x2,y2]:=(g[x2,y2] and $F8) or tour;
         'd','D': g[x2,y2]:=(g[x2,y2] and $F8) or dame;
         'e'    : begin y:=(y1+y2) div 2;
                        g[x2,y]:=enpassant;
                  end;
         'E'    : begin g[x2,y1]:=rien;
                  end;
         End;
   End;

{$I PIONPOS.PAS}

FUNCTION CavalPossible(x1,y1,x2,y2:shortint):boolean;
 Var f:boolean;
     dx,dy:shortint;
   Begin dx:=abs(x2-x1);
         dy:=abs(y2-y1);
         f:=((dx=1) and (dy=2)) or ((dx=2) and (dy=1));
         CavalPossible:=f;
   End;

FUNCTION FouPossible(x1,y1,x2,y2:shortint):boolean;
 Var f,ff:boolean;
     dx,dy:shortint;
     x,y:shortint;
   Begin dx:=x2-x1; dy:=y2-y1;
         f:=abs(dx)=abs(dy);
         If f
         Then
           begin
             if dx>0 then dx:=1 else dx:=-1;
             if dy>0 then dy:=1 else dy:=-1;
             x:=x1; y:=y1;
             Repeat x:=x+dx; y:=y+dy;
                    f:=g[x,y] and piece = rien;
                    ff:=(x=x2) and (y=y2);
             Until (not f) or ff;
             If ff then f:=true;
           end;
         FouPossible:=f;
   End;

FUNCTION TourPossible(x1,y1,x2,y2:shortint):boolean;
 Var f,ff:boolean;
     dx,dy:shortint;
     x,y:shortint;
   Begin dx:=x2-x1; dy:=y2-y1;
         f:=((dx=0) and (dy<>0)) or ((dx<>0) and (dy=0));
         If f
         Then
           begin
             if dx>0
             then dx:=1
             else if dx<0
                  then dx:=-1
                  else dx:=0;
             if dy>0
             then dy:=1
             else if dy<0
                  then dy:=-1
                  else dy:=0;
             x:=x1; y:=y1;
             Repeat x:=x+dx; y:=y+dy;
                    f:=g[x,y] and piece = rien;
                    ff:=(x=x2) and (y=y2);
             Until (not f) or ff;
             If ff then f:=true;
           end;
         TourPossible:=f;
   End;

FUNCTION DamePossible(x1,y1,x2,y2:shortint):boolean;
 Var f,ff:boolean;
     dx,dy:shortint;
     x,y:shortint;
   Begin dx:=x2-x1; dy:=y2-y1;
         f:= ((dx=0) and (dy<>0)) or ((dx<>0) and (dy=0))
             or (abs(dx)=abs(dy));
         If f
         Then
           begin
             if dx>0
             then dx:=1
             else if dx<0
                  then dx:=-1
                  else dx:=0;
             if dy>0
             then dy:=1
             else if dy<0
                  then dy:=-1
                  else dy:=0;
             x:=x1; y:=y1;
             Repeat x:=x+dx; y:=y+dy;
                    f:=g[x,y] and piece = rien;
                    ff:=(x=x2) and (y=y2);
             Until (not f) or ff;
             If ff then f:=true;
           end;
         DamePossible:=f;
   End;

FUNCTION RoiPossible(x1,y1,x2,y2,aki:shortint;var special:char):boolean;
 Var dx,dy:shortint;
     f:boolean;
   Begin dx:=abs(x2-x1); dy:=abs(y2-y1);
         If (dx<=1) and (dy<=1)
         Then f:=true
         Else If (dy<>0) or (dx<>2)
              Then f:=false
              Else (* Il s'agit du roque *)
                begin f:=true {pour l'instant}
                end;
         RoiPossible:=f;
   End;

FUNCTION CoupPossible(x1,y1,x2,y2,aki:shortint;
                      var special:char;g:grille):boolean;
 Var f:boolean;
 Const EchecSurFuturePosition=false;
   Begin
     f:=false;
     If g[x2,y2] and couleur = aki
     Then
       f:=false
     Else
       begin
         Case g[x1,y1] and piece of
           pion :
             f:=PionPossible(x1,y1,x2,y2,aki,special);
           caval :
             f:=CavalPossible(x1,y1,x2,y2);
           fou :
             f:=FouPossible(x1,y1,x2,y2);
           tour :
             f:=TourPossible(x1,y1,x2,y2);
           dame :
             f:=DamePossible(x1,y1,x2,y2);
           roi :
             f:=RoiPossible(x1,y1,x2,y2,aki,special);
         End;
         If f
         Then
           begin
             EffectueVirtuel(x1,y1,x2,y2,special,g)
             {f:=not EchecSurFuturePosition;}
           end;
       end;
     CoupPossible:=f;
   End;

FUNCTION PeutJouer(aki:shortint):boolean;
   Begin
   End;

PROCEDURE RetireEP(aki:shortint);
 Var x,y:shortint;
   Begin if aki=blanc
         then y:=2
         else y:=5;
         For x:=0 to 7 do
           g[x,y]:=g[x,y] and ($FF xor enpassant);
   End;

PROCEDURE GC(var quitter:boolean;var g:grille;var x,y,aki:shortint;
             var fini,pselect:boolean;var xs,ys:shortint);
 Var t,special:char;
   Begin t:=readkey;
     If t<>#0
     Then
       begin
         t:=upcase(t);
         Case t of
           #27:
             quitter:=true;
           #13:
             If not pselect
             then (* pas de piäce en main *)
               begin
                 if (g[x,y]<>rien)
                   and (g[x,y] and couleur=aki)
                 then (* sÇlection piäce amie *)
                   begin
                     pselect:=true;
                     xs:=x; ys:=y;
                     g[x,y]:=g[x,y] xor select;
                     Curseur(x,y,g[x,y]);
                   end;
               end
             else (* dÇjÖ une piäce en main *)
               begin
                 if (x=xs) and (y=ys)
                 then (* dÇsÇlection piäce *)
                   begin
                     g[x,y]:=g[x,y] xor select;
                     Place(x,y,g[x,y]);
                     Curseur(x,y,g[x,y]);
                     pselect:=false;
                   end
                 else (* Çtude du coup *)
                   begin
                     special:=' ';
                     If CoupPossible(xs,ys,x,y,aki,special,g)
                     then
                       begin
                         Effectue(xs,ys,x,y,special);
                         pselect:=false;
                         aki:=ennemi(aki);
                         RetireEP(aki);
                         Curseur(x,y,aki);
                       end;
                   end;
               end;
         End; (* Case *)
       end (* if *)
   Else
     begin
       t:=readkey;
       Case t of
         #75:
           begin
             Curseur(x,y,rien);
             if x>0
             then x:=x-1
             else x:=7;
             Curseur(x,y,aki);
           end; (* #75 *)
         #77:
           begin
             Curseur(x,y,rien);
             if x<7
             then x:=x+1
             else x:=0;
             Curseur(x,y,aki);
           end; (* #77 *)
         #72:
           begin
             Curseur(x,y,rien);
             if y<7
             then y:=y+1
             else y:=0;
             Curseur(x,y,aki);
           end; (* #72 *)
         #80:
           begin
             Curseur(x,y,rien);
             if y>0
             then y:=y-1
             else y:=7;
             Curseur(x,y,aki);
           end; (* #80 *)
       End; (* Case *)
     end; (* Else *)
   End;

BEGIN InitGrille(g);
      x:=4; y:=1; aki:=blanc;
      quitter:=false; fini:=false; pselect:=false;
      ModeGraphique;
      SetRGBPalette(EGADarkGray,40,34,34);
      SetRGBPalette(EGALightGray,44,40,40);
      SetRGBPalette(EGABrown,25,20,15);
      SetRGBPalette(EGAYellow,63,63,40);
      TraceGrille;
      Curseur(x,y,aki);
      Info;
      While not Quitter and not Fini do
      begin GC(quitter,g,x,y,aki,fini,pselect,xs,ys);
      end;
      If Fini Then Readln;
      RestoreCRTMode;
      CloseGraph;
END.