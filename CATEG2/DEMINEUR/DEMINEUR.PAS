PROGRAM Demineur;

        USES Crt,Graph,Dos;

        CONST NbCols  = 30;     CoteX   = 20;  MarX = 20;
              NbLigs  = 15;     CoteY   = 20;  MarY = 100;
              NbMines = 100;
              Vide    = $00;    Mine    = $01;
              Vier    = $00;    Expl    = $02;
              Bana    = $00;    Marq    = $04;
              Pers    = $00;    Bonh    = $08;

        TYPE T_Grille = Array[1..NbCols,1..NBLigs] of byte;
             T_Joueur = Record nom:string;
                               score:longint; {vitesse}
                        End;
             T_Liste  = Array[1..10] of T_Joueur;
             F_Liste  = File of T_Liste;

        VAR g           : T_Grille;
            x,y         : Integer;
            gren        : byte;
            quitter     : boolean;
            perdu       : boolean;
            gagne       : boolean;
            joueur      : T_joueur;
            f           : F_Liste;
            h_,m_,s_,c_ : word;
            hh,mm,ss,cc : word;

{$I INTECRAN.PAS}

PROCEDURE Attendre;
   Begin While not keypressed do;
   End;

PROCEDURE VideClavier;
 Var t:char;
   Begin While keypressed do t:=readkey;
   End;

FUNCTION Cat(n:longint):string;
 Var s:string;
   Begin str(n,s);
         cat:=s;
   End;

FUNCTION Min(a,b:integer):integer;
   Begin If a<=b then min:=a
                 else min:=b;
   End;

FUNCTION Max(a,b:integer):integer;
   Begin If a>=b then max:=a
                 else max:=b;
   End;

PROCEDURE ModeGRaphique;
 Var Gd,Gm:integer;
   Begin Gd:=VGA; Gm:=VGAHI;
         InitGraph(Gd,Gm,'');
         If GraphResult<>GrOk
         Then begin Writeln('Erreur d''initialisation du mode graphique '+
                            'VGA.');
                    Halt;
              end;
   End;

PROCEDURE DessVier(x,y:integer);
   Begin SetFillStyle(11,LightGreen);
         Bar(MarX+(x-1)*CoteX,MarY+(y-1)*CoteY,
             MarX+x*CoteX,MarY+y*CoteY);
   End;

PROCEDURE DessExpl(x,y:integer);
   Begin SetFillStyle(10,7);
         Bar(MarX+(x-1)*CoteX,MarY+(y-1)*CoteY,
             MarX+x*CoteX,MarY+y*CoteY);
   End;

PROCEDURE DessMine(x,y:integer);
 Var i:integer;
   Begin {SetFillStyle(1,0);
         Bar(MarX+(x-1)*CoteX,MarY+(y-1)*CoteY,
             MarX+x*CoteX,MarY+y*CoteY);}
         SetColor(12);
         x:=MarX+x*CoteX-CoteX div 2;
         y:=MarY+y*CoteY-CoteY div 2;
         For i:=0 to min(CoteX div 2,CoteY div 2) div 2  do
         Circle(x,y,2*i);
   End;

PROCEDURE DessMarq(x,y:integer);
   Begin SetFillStyle(11,4);
         Bar(MarX+(x-1)*CoteX,MarY+(y-1)*CoteY,
             MarX+x*CoteX,MarY+y*CoteY);
   End;

PROCEDURE DessBonh(x,y:integer);
 Var r:integer;
   Begin SetFillStyle(1,0);
         Bar(MarX+(x-1)*CoteX,MarY+(y-1)*CoteY,
             MarX+x*CoteX,MarY+y*CoteY);
         SetColor(15);
         x:=MarX+x*CoteX-CoteX div 2;
         y:=MarY+y*CoteY-CoteY div 2;
         r:=min(CoteX div 2,CoteY div 2);
         Circle(x,y,r); r:=r div 3;
         PutPixel(x-r,y-r,15);
         PutPixel(x+r,y-r,15);
   End;

PROCEDURE DessMort(x,y:integer);
 Var r:integer;
   Begin SetFillStyle(4,12);
         Bar(MarX+(x-1)*CoteX,MarY+(y-1)*CoteY,
             MarX+x*CoteX,MarY+y*CoteY);
         SetColor(15);
         x:=MarX+x*CoteX-CoteX div 2;
         y:=MarY+y*CoteY-CoteY div 2;
         r:=min(CoteX div 2,CoteY div 2);
         Circle(x,y,r); r:=r div 2;
         PutPixel(x-r,y-r,15);
         PutPixel(x+r,y-r,15);
   End;

PROCEDURE DessCase(x,y:integer;c:byte);
   Begin Case c of
              {0,1}
              vide+vier+bana+pers,
              mine+vier+bana+pers: begin DessVier(x,y);
                                   end;
              {2}
              vide+expl+bana+pers,
              vide+expl+marq+pers: begin DessExpl(x,y);
                                   end;
              {3}
              mine+expl+bana+pers,
              mine+expl+marq+pers: begin DessMine(x,y);
                                   end;
              {4,5}
              vide+vier+marq+pers,
              mine+vier+marq+pers: begin DessMarq(x,y);
                                   end;
              {8} {impossible}
              {9} {impossible}
              {A,E}
              vide+expl+bana+bonh,
              vide+expl+marq+bonh: begin DessBonh(x,y);
                                   end;
              {B}
              mine+expl+bana+bonh,
              mine+expl+marq+bonh: begin DessMort(x,y);
                                   end;
              {C} {impossible}
              {D} {impossible}
         End;
   End;

PROCEDURE DessGrille(var g:T_Grille);
 Var i,j:integer;
   Begin For i:=1 to NbCols do
         For j:=1 to NbLigs do
         DessCase(i,j,g[i,j]);
   End;

PROCEDURE InitGrille(var g:T_Grille);
 Var i,j,n:integer;
   Begin For i:=1 to NbCols do
         For j:=1 to NbLigs do
         g[i,j]:=vide+vier;
         For n:=1 to NbMines do
         begin repeat i:=random(NbCols)+1; j:=random(NbLigs)+1;
               until ((i<>1) or (j<>1)) and ((i<>NbCols) or (j<>NbLigs))
                     and (g[i,j] and mine = 0);
               g[i,j]:=g[i,j] or mine;
         end;
         g[1,1]:=g[1,1] or expl;
         g[NbCols,NbLigs]:=expl;
         DessGrille(g);
   End;

FUNCTION MinProx(VAR g:T_Grille;x,y:integer):byte;
 Var i,j:integer;
     n:byte;
   Begin n:=0;
         For i:=max(1,x-1) to min(NbCols,x+1) do
         For j:=max(1,y-1) to min(NbLigs,y+1) do
         If g[i,j] and mine <> 0 then inc(n);
         MinProx:=n;
   End;

PROCEDURE Explore(var a:byte);
   Begin a:=a or expl;
   End;

PROCEDURE Demine(var a:byte);
   Begin a:=a xor (a and mine);
   End;

PROCEDURE GC(var quitter:boolean;
             var g:T_Grille;
             var x,y:integer;
             var gren:byte;
             var joueur:T_Joueur);
 Var t:char;
   Begin t:=readkey;
         If t<>#0
         Then begin t:=upcase(t);
                    Case t of
                         #27: quitter:=true;
                         '8': begin If y>1
                                    Then begin DessCase(x,y,g[x,y]);
                                               dec(y);
                                               if g[x,y] and expl = vier
                                               then inc(joueur.score);
                                               Explore(g[x,y]);
                                               DessCase(x,y,g[x,y]+bonh);
                                         end;
                              end;
                         '7': begin If (x>1) and (y>1)
                                    Then begin DessCase(x,y,g[x,y]);
                                               dec(x); dec(y);
                                               if g[x,y] and expl = vier
                                               then inc(joueur.score);
                                               Explore(g[x,y]);
                                               DessCase(x,y,g[x,y]+bonh);
                                         end;
                              end;
                         '4': begin If x>1
                                    Then begin DessCase(x,y,g[x,y]);
                                               dec(x);
                                               if g[x,y] and expl = vier
                                               then inc(joueur.score);
                                               Explore(g[x,y]);
                                               DessCase(x,y,g[x,y]+bonh);
                                         end;
                              end;
                         '1': begin If (x>1) and (y<NbLigs)
                                    Then begin DessCase(x,y,g[x,y]);
                                               dec(x); inc(y);
                                               if g[x,y] and expl = vier
                                               then inc(joueur.score);
                                               Explore(g[x,y]);
                                               DessCase(x,y,g[x,y]+bonh);
                                         end;
                              end;
                         '2': begin If y<NbLigs
                                    Then begin DessCase(x,y,g[x,y]);
                                               inc(y);
                                               if g[x,y] and expl = vier
                                               then inc(joueur.score);
                                               Explore(g[x,y]);
                                               DessCase(x,y,g[x,y]+bonh);
                                         end;
                              end;
                         '3': begin If (x<NbCols) and (y<NbLigs)
                                    Then begin DessCase(x,y,g[x,y]);
                                               inc(x); inc(y);
                                               if g[x,y] and expl = vier
                                               then inc(joueur.score);
                                               Explore(g[x,y]);
                                               DessCase(x,y,g[x,y]+bonh);
                                         end;
                              end;
                         '6': begin If x<NbCols
                                    Then begin DessCase(x,y,g[x,y]);
                                               inc(x);
                                               if g[x,y] and expl = vier
                                               then inc(joueur.score);
                                               Explore(g[x,y]);
                                               DessCase(x,y,g[x,y]+bonh);
                                         end;
                              end;
                         '9': begin If (x<NbCols) and (y>1)
                                    Then begin DessCase(x,y,g[x,y]);
                                               inc(x); dec(y);
                                               if g[x,y] and expl = vier
                                               then inc(joueur.score);
                                               Explore(g[x,y]);
                                               DessCase(x,y,g[x,y]+bonh);
                                         end;
                              end;
                    End;
              end
         Else begin t:=readkey;
                    Case t of
                         #71: begin If (x>1) and (y>1) and (gren>0)
                                    Then begin Explore(g[x-1,y-1]);
                                               Demine(g[x-1,y-1]);
                                               DessCase(x-1,y-1,g[x-1,y-1]);
                                               dec(gren);
                                         end;
                              end;
                         #72: begin If (y>1) and (gren>0)
                                    Then begin Explore(g[x,y-1]);
                                               Demine(g[x,y-1]);
                                               DessCase(x,y-1,g[x,y-1]);
                                               dec(gren);
                                         end;
                              end;
                         #73: begin If (x<NbCols) and (y>1) and (gren>0)
                                    Then begin Explore(g[x+1,y-1]);
                                               Demine(g[x+1,y-1]);
                                               DessCase(x+1,y-1,g[x+1,y-1]);
                                               dec(gren);
                                         end;
                              end;
                         #75: begin If (x>1) and (gren>0)
                                    Then begin Explore(g[x-1,y]);
                                               Demine(g[x-1,y]);
                                               DessCase(x-1,y,g[x-1,y]);
                                               dec(gren);
                                         end;
                              end;
                         #77: begin If (x<NbCols) and (gren>0)
                                    Then begin Explore(g[x+1,y]);
                                               Demine(g[x+1,y]);
                                               DessCase(x+1,y,g[x+1,y]);
                                               dec(gren);
                                         end;
                              end;
                         #79: begin If (x>1) and (y<NbLigs) and (gren>0)
                                    Then begin Explore(g[x-1,y+1]);
                                               Demine(g[x-1,y+1]);
                                               DessCase(x-1,y+1,g[x-1,y+1]);
                                               dec(gren);
                                         end;
                              end;
                         #80: begin If (y<NbLigs) and (gren>0)
                                    Then begin Explore(g[x,y+1]);
                                               Demine(g[x,y+1]);
                                               DessCase(x,y+1,g[x,y+1]);
                                               dec(gren);
                                         end;
                              end;
                         #81: begin If (x<NbCols) and (y<NbLigs) and (gren>0)
                                    Then begin Explore(g[x+1,y+1]);
                                               Demine(g[x+1,y+1]);
                                               DessCase(x+1,y+1,g[x+1,y+1]);
                                               dec(gren);
                                         end;
                              end;
                    End;
              end;
   End;

PROCEDURE VerifieFichier(var f:F_Liste);
 Var t:T_Liste;
     i:byte;
   Begin {$I-}
         Reset(f);
         Close(f);
         {$I+}
         If IoResult<>0
         then begin For i:=1 to 10 do
                    begin t[i].nom:='Noumi 7';
                          t[i].score:=11-i;
                    end;
                    {$I-}
                    Rewrite(f);
                    Write(f,t);
                    Close(f);
                    {$I+}
              end;
   End;

PROCEDURE Insere(var joueur:T_Joueur;var f:F_Liste;hh,mm,ss,cc:word);
 Var liste:T_Liste;
     i,j:integer;
   Begin joueur.score:=round(10000*joueur.score/(3600*hh+60*mm+ss+0.01*cc));
         Reset(f);
         Read(f,liste);
         i:=11;
         While (i>0) and (joueur.score>liste[i-1].score) do dec(i);
         If i<=10
         Then begin For j:=9 downto i do
                    liste[j+1]:=liste[j];
                    TextAttr:=LightCyan;
                    Ecrire('Quel est votre nom? ');
                    Readln(joueur.nom);
                    liste[i].nom:=joueur.nom;
                    liste[i].score:=joueur.score;
                    seek(f,0);
                    Write(f,liste);
              end;
         Close(f);
   End;

PROCEDURE AfficheListe(var f:F_Liste);
 Var t:T_Liste;
     i:integer;
   Begin Reset(f);
         Read(f,t);
         For i:= 1 to 10 do
         Ecrire(cat(i)+'...'+t[i].nom+'    ('+cat(t[i].score)+')'+#10#13);
         Close(f);
   End;

PROCEDURE DevoileMines(var g:T_Grille);
 Var i,j:integer;
   Begin For i:=1 to NbCols do
         For j:=1 to NbLigs do
         if g[i,j] and mine = mine
         then g[i,j]:=g[i,j] or expl;
   End;

PROCEDURE ModifieHeure(var h_,m_,s_,c_:word);
   Begin GetTime(h_,m_,s_,c_);
         SetTime(0,0,0,0);
   End;

PROCEDURE AfficheVitesse(joueur:T_Joueur;hh,mm,ss,cc:word);
 Var t:real;
   Begin t:=3600*hh+60*mm+ss+0.01*cc;
         If t<>0 then Ecrire(cat(round(10000*joueur.score/t))+' x 10^-4 points/seconde   ')
                 else Ecrire('ÄÄ');
   End;

BEGIN Randomize;
      ModeGraphique;
      Assign(f,'PODIUM.DAT');
      InitGrille(g);
      x:=1; y:=1; gren:=5; joueur.score:=0;
      Quitter:=false; Perdu:=false; Gagne:=false;
      DessCase(x,y,g[x,y]+bonh);
      ModifieHeure(h_,m_,s_,c_);
      While not Quitter and not Perdu and not Gagne do
      begin TextAttr:=7;
            VaEnXY(1,1); Ecrire('Mines proches: '+cat(MinProx(g,x,y)));
            VaEnXY(31,1); Ecrire('Grenades en r‚serve: '+cat(gren));
            VaEnXY(1,3); Ecrire('score: '+cat(joueur.score));
            If g[x,y] and mine <> 0 then perdu:=true;
            Repeat
            GetTime(hh,mm,ss,cc);
            VaEnXY(21,3); Ecrire('temps: ');
                          Ecrire(cat(hh)+':'+cat(mm)+':'+cat(ss)+'  ');
            VaEnXY(41,3); Ecrire('vitesse: ');
                          AfficheVitesse(joueur,hh,mm,ss,cc);
            until keypressed or perdu;
            If not Perdu
            Then GC(quitter,g,x,y,gren,joueur);
            Gagne:=(x+y=NbCols+NbLigs)
      end;
      GetTime(hh,mm,ss,cc);
      VaEnXY(21,3); Ecrire('temps: ');
      Ecrire(cat(hh)+':'+cat(mm)+':'+cat(ss)+'  ');
      VaEnXY(41,3); Ecrire('vitesse: ');
      AfficheVitesse(joueur,hh,mm,ss,cc);
      VaEnXY(1,28);
      TextAttr:=12;
      If Quitter then ecrire('La partie a ‚t‚ interrompue.'+#10#13);
      If Gagne then ecrire('F‚licitation, vous avez r‚ussi!'+#10#13);
      If Perdu then ecrire('Vous avez saut‚ sur une mine!'+#10#13);
      If not Quitter
      then begin DevoileMines(g);
                 DessGrille(g);
           end;
      VideClavier;
      TextAttr:=15; VaEnXY(0,10);
      VerifieFichier(f);
      If gagne
      then begin Insere(joueur,f,hh,mm,ss,cc);
                 AfficheListe(f);
           end;
      Attendre; VideClavier;
      RestoreCrtMode;
      CloseGraph;
END.