PROGRAM Othello;

USES Crt,Graph;

TYPE Grille = Array[0..7,0..7] of byte;

CONST rien=0; blanc=1; noir=2; gris=7; rouge=12;
      MargeX=25; MargeY=4;
      CoteX=59; CoteY=59;

VAR g:grille;
    x,y,aki:shortint;
    quitter,fini:boolean;
    tb,tn:integer;
    s:string;

PROCEDURE ModeGraphique;
 Var Gd,Gm:integer;
   Begin Gd:=VGA; Gm:=VGAHI;
         InitGraph(Gd,Gm,'');
   End;

PROCEDURE InitGrille(var g:grille);
 Var x,y:shortint;
   Begin For x:=0 to 7 do
         For y:=0 to 7 do
         g[x,y]:=rien;
         g[3,3]:=noir;
         g[4,4]:=noir;
         g[3,4]:=blanc;
         g[4,3]:=blanc;
   End;

FUNCTION couleur(c:shortint):byte;
 Var cc:byte;
   Begin Case c of
         noir: cc:=8;
         blanc: cc:=15;
         gris: cc:=7;
         rouge: cc:=12;
         End;
         couleur:=cc;
   End;

FUNCTION XX(x:shortint):integer;
   Begin xx:=MargeX+CoteX*x;
   End;

FUNCTION YY(y:shortint):integer;
   Begin yy:=479-MargeY-CoteY*y;
   End;

PROCEDURE Place(x,y,c:shortint);
 Var cc:byte;
     x1,y1,x2,y2:integer;
 Const m=8; n=15;
   Begin (* Autour *)
         cc:=couleur(c);
         SetFillStyle(SolidFill,cc);
         x1:=xx(x);   y1:=yy(y);
         x2:=xx(x+1); y2:=yy(y+1);
         Bar(x1+m,y1-m,x2-m,y2+m);

         (* Arˆtes *)
         Case c of
              blanc: cc:=8;
              noir:  cc:=15;
              gris:  cc:=7;
         End;
         SetColor(cc);
         Rectangle(x1+m,y1-m,x2-m,y2+m);
         Rectangle(x1+n,y1-n,x2-n,y2+n);
         Line(x1+m,y1-m,x1+n,y1-n);
         Line(x1+m,y2+m,x1+n,y2+n);
         Line(x2-m,y2+m,x2-n,y2+n);
         Line(x2-m,y1-m,x2-n,y1-n);
   End;

PROCEDURE Curseur(x,y,c:shortint);
 Var x1,x2,y1,y2:integer;
 Const e=1; f=3;
   Begin x1:=xx(x);   y1:=yy(y);
         x2:=xx(x+1); y2:=yy(y+1);
         SetFillStyle(SolidFill,c);
         Bar(x1+e,y1-e,x2-e,y1-f);
         Bar(x1+e,y2+e,x2-e,y2+f);
         Bar(x1+e,y1-e,x1+f,y2+e);
         Bar(x2-e,y1-e,x2-f,y2+e);
   End;

PROCEDURE TraceGrille;
 Var i,j:shortint;
     z:integer;
   Begin SetColor(15);
         Rectangle(0,0,639,479);
         SetFillStyle(SolidFill,7);
         Bar(xx(0),yy(0),xx(8),yy(8));
         SetColor(0);
         For i:=0 to 8 do
         begin z:=xx(i);
               Line(z,yy(0),z,yy(8));
               z:=yy(i);
               Line(xx(0),z,xx(8),z);
         end;
         SetColor(White);
         SetTextJustify(CenterText,CenterText);
         SetTextStyle(TriplexFont,VertDir,9);
         OutTextXY(550,220,'OTHELLO');
         SetTextStyle(DefaultFont,VertDir,1);
         OutTextXY(630,220,'programmation par Luc ROUSSEAU (24 ao–t 1996)');
         SetTextStyle(TriplexFont,HorizDir,4);
         For i:=3 to 4 do
         For j:=3 to 4 do
         Place(i,j,g[i,j]);
   End;

FUNCTION cat(x:integer):string;
 Var s:string;
   Begin Str(x,s);
         cat:=s;
   End;

PROCEDURE Info;
 Var x,y:shortint;
   Begin tb:=0; tn:=0;
         For x:=0 to 7 do
         For y:=0 to 7 do
         Case g[x,y] of
              blanc:inc(tb);
              noir:inc(tn);
         End;
         SetFillStyle(SolidFill,7);
         Bar(520,450,639,479);
         SetColor(15);
         OutTextXY(555,460,cat(tb));
         SetColor(0);
         OutTextXY(605,460,cat(tn));
   End;

FUNCTION Ennemi(x:shortint):shortint;
   Begin Case x of
          noir:ennemi:=blanc;
          blanc:ennemi:=noir;
          Else ennemi:=gris;
         End;
   End;

FUNCTION LignePossible(x,y,ix,iy,aki:shortint):boolean;
 Var tote:byte;
   Begin tote:=0;
         x:=x+ix; y:=y+iy;
         While     (0<=x) and (x<=7) and (0<=y) and (y<=7)
               and (g[x,y]=ennemi(aki)) do
         begin tote:=tote+1;
               x:=x+ix; y:=y+iy;
         end;
         LignePossible:=     (tote>0)
                         and (0<=x) and (x<=7) and (0<=y) and (y<=7)
                         and (g[x,y]=aki);
   End;

FUNCTION CoupPossible(x,y,aki:shortint):boolean;
 Var f:boolean;
     ix,iy:shortint;
   Begin f:=false;
         If g[x,y]=rien
         Then begin ix:=-1; iy:=-1;
                    While (not f) and (ix<2) do
                    begin While (not f) and (iy<2) do
                          begin if not ((ix=0) and (iy=0))
                                then f:=f or LignePossible(x,y,ix,iy,aki);
                                inc(iy);
                          end;
                          iy:=-1;
                          inc(ix);
                    end;
              end;
         CoupPossible:=f;
   End;

PROCEDURE RetourneLigne(x,y,ix,iy,aki:shortint);
   Begin x:=x+ix; y:=y+iy;
         While g[x,y]=ennemi(aki) do
         begin g[x,y]:=aki;
               Place(x,y,aki);
               x:=x+ix; y:=y+iy;
         end;
   End;

PROCEDURE Retourne(x,y,aki:shortint);
 Var ix,iy:shortint;
   Begin ix:=-1; iy:=-1;
         While ix<2 do
         begin While iy<2 do
               begin if not ((ix=0) and (iy=0))
                     then if LignePossible(x,y,ix,iy,aki)
                          then RetourneLigne(x,y,ix,iy,aki);
                     inc(iy);
               end;
               iy:=-1;
               inc(ix);
         end;
   End;

FUNCTION PeutJouer(aki:shortint):boolean;
 Var x,y:shortint;
     f:boolean;
   Begin x:=0; y:=0; f:=false;
         While (not f) and (x<8) do
         begin While (not f) and (y<8) do
               begin f:=f or CoupPossible(x,y,aki);
                     inc(y);
               end;
               y:=0;
               inc(x);
         end;
         PeutJouer:=f;
   End;

PROCEDURE GC(var quitter:boolean;var g:grille;var x,y,aki:shortint;
             var fini:boolean);
 Var t:char;
   Begin t:=readkey;
         If t<>#0
         Then begin t:=upcase(t);
                    Case t of
                    #27:quitter:=true;
                    #13: If CoupPossible(x,y,aki)
                         Then begin Retourne(x,y,aki);
                                    g[x,y]:=aki;
                                    Place(x,y,aki);
                                    aki:=ennemi(aki);
                                    If not PeutJouer(aki)
                                    Then begin aki:=ennemi(aki);
                                               If not PeutJouer(aki)
                                               Then begin aki:=gris;
                                                          fini:=true;
                                                    end;
                                         end;
                                    Curseur(x,y,couleur(aki));
                                    Info;
                              end;
                    End;
              end
         Else begin t:=readkey;
                    Case t of
                    #75: begin Curseur(x,y,gris);
                               if x>0
                               then x:=x-1
                               else x:=7;
                               Curseur(x,y,couleur(aki));
                         end;
                    #77: begin Curseur(x,y,gris);
                               if x<7
                               then x:=x+1
                               else x:=0;
                               Curseur(x,y,couleur(aki));
                         end;
                    #72: begin Curseur(x,y,gris);
                               if y<7
                               then y:=y+1
                               else y:=0;
                               Curseur(x,y,couleur(aki));
                         end;
                    #80: begin Curseur(x,y,gris);
                               if y>0
                               then y:=y-1
                               else y:=7;
                               Curseur(x,y,couleur(aki));
                         end;
                    End;
              end;
   End;

BEGIN InitGrille(g); x:=3; y:=3; aki:=blanc; quitter:=false; fini:=false;
      ModeGraphique;
      TraceGrille;
      Curseur(x,y,couleur(aki));
      Info;
      While not Quitter and not Fini do
      begin GC(quitter,g,x,y,aki,fini);
      end;
      If Fini Then Readln;
      RestoreCRTMode;
      CloseGraph;
END.