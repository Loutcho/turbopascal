PROGRAM Go;

        USES Crt,Dos,Graph;

        TYPE T_Dim=Array[1..3] of byte;

        CONST Longueur = 65;
              Dims:T_Dim=(9,13,19);
              MargeX:T_Dim=(55,40,25);
              MargeY:T_Dim=(55,40,25);
              CoteX:T_Dim=(48,30,21);
              CoteY:T_Dim=(48,30,21);
              Rayon:T_Dim=(16,10,7);

        TYPE T_Grille= Array [1..19,1..19] of byte;
             T_Chaine=string[longueur];
             T_Joueurs = Array[0..1] of char;
             T_Captifs = Array[0..1] of word;
             T_Enreg = Record titre:T_Chaine;
                              aqui:byte;
                              g:T_Grille;
                              pr:T_Captifs;
                              jr:T_Joueurs;
                              idim:byte;
                       End;
             F_Enreg = File Of T_Enreg;

        CONST Etat=1;     Vide=0; OQP=1;
              Couleur=2;  Noir=0; Blanc=1;
              Respirer=4; Peut=1; PeutPas=0;
              Combleur=8; Ya=1;   YaPas=0;

              NbEnreg=20;

        VAR statut,nbb:integer;
            jr:T_Joueurs;
            pr:T_Captifs;
            aqui:byte;
            g:T_Grille;
            idim:byte;
            quitter:boolean;

PROCEDURE ModeGraphique;
 Var Gd,Gm:integer;
   Begin Gd:=VGA; gm:=VGAHI;
         InitGraph(gd,gm,'');
         If GraphResult<>GrOk
         Then begin Writeln(#7'ProblŠme d''initialisation du mode VGA,');
                    Writeln('Programme interrompu.');
                    Halt;
              end;
   End;

PROCEDURE CurseurTexte(d,f:byte);
 Var r:registers;
   Begin r.ah:=1;
         r.ch:=d; r.cl:=f;
         Intr($10,r);
   End;

{$I SOURIS.PAS}

PROCEDURE Attendre;
   Begin While not keypressed and not BoutonPresse(1) do;
   End;

PROCEDURE VideClavier;
 Var t:char;
   Begin While keypressed do t:=readkey;
   End;

FUNCTION Cat(n:longint):string;
 Var s:string;
   Begin Str(n,s);
         Cat:=s;
   End;

PROCEDURE Saisir(var ch:T_Chaine);
 Var t:char;
     Ok:boolean;
     x:byte;
     wx,wy:byte;
   Begin wx:=WhereX; wy:=WhereY;
         Write(#254); GotoXY(wx,wy);
         ch:=''; Ok:=false; x:=1;
         Repeat t:=readkey;
                If t<>#0
                Then Case t of
                          #8:if x>1 then begin dec(x);
                                               delete(ch,x,1);
                                         end;
                          #13:Ok:=true;
                          #32..#175:if (x<=longueur) and (length(ch)<longueur)
                                    then begin Insert(t,ch,x); inc(x); end;
                     End
                Else begin t:=readkey;
                           Case t of
                                #75:if x>1
                                    then dec(x);
                                #77:if (x<=length(ch)) and (x<longueur)
                                    then inc(x);
                                #83:delete(ch,x,1);
                                #71:x:=1;
                                #79:x:=length(ch)+1;
                           End;
                     end;
                GotoXY(wx,wy); Write(ch);
                If length(ch)<longueur then Write(#254) else Write(#219);
                ClrEol; GotoXY(x+wx-1,wy);
         Until Ok;
   End;

PROCEDURE Affjn(jn:char);
   Begin If jn='H' then TextAttr:=Yellow+16*LightGray+Blink
                   else TextAttr:=Yellow+16*LightGray;
         GotoXY(20,08); Write('Humain');
         If jn='O' then TextAttr:=Yellow+16*LightGray+Blink
                   else TextAttr:=Yellow+16*LightGray;
         GotoXY(28,08); Write('Ordinateur');
   End;

PROCEDURE Affjb(jb:char);
   Begin If jb='H' then TextAttr:=Yellow+16*LightGray+Blink
                   else TextAttr:=Yellow+16*LightGray;
         GotoXY(20,10); Write('Humain');
         If jb='O' then TextAttr:=Yellow+16*LightGray+Blink
                   else TextAttr:=Yellow+16*LightGray;
         GotoXY(28,10); Write('Ordinateur');
   End;

PROCEDURE AfficheMenu(jr:T_Joueurs);
 Var i:byte;
   Begin TextAttr:=Yellow+16*Blue; ClrScr;
         CurseurTexte(7,0);
         GotoXY(1,2);
         Writeln('             ÜßßßÜ  ÜßßßÜ');
         Writeln('            Û      Û     Û');
         Writeln('            Û   ÜÜ Û     Û');
         Writeln('            Û    Û Û     Û');
         Writeln('             ßÜÜÜß  ßÜÜÜß');
         GotoXY(1,1); Write('É'); GotoXY(40,1); Write('»');
         GotoXY(1,24); Write('È'); GotoXY(40,24); Write('¼');
         GotoXY(2,1);  For i:=2 to 39 do Write('Í');
         GotoXY(2,24); For i:=2 to 39 do Write('Í');
         For i:=2 to 23 do
         begin GotoXY(1,i); Write('º');
               GotoXY(40,i); Write('º');
         end;
         GotoXY(3,08); Write('Joueur noir:'); Affjn(jr[noir]);
         TextAttr:=Yellow+16*Blue;
         GotoXY(3,10); Write('Joueur blanc:');  Affjb(jr[blanc]);

         TextAttr:=Yellow+16*LightGray;
         GotoXY(3,12); Write('   R‚initialiser la position    ');
         GotoXY(3,14); Write(' Jouer sur la position en cours ');
         GotoXY(3,16); Write('Sauvegarder la position en cours');
         GotoXY(3,18); Write('Charger une position sauvegard‚e');
         GotoXY(3,20); Write(' Modifier la position en cours  ');
         GotoXY(3,22); Write('Quitter');
   End;

PROCEDURE InitGrille;
 Var i,j:byte;
   Begin For i:=1 to dims[idim] do For j:=1 to dims[idim] do g[i,j]:=0;
   End;

PROCEDURE PlacePierre(x,y:shortint;b:byte);
 Var xx,yy:integer;
     i:byte;
   Begin xx:=MargeX[idim]+CoteX[idim]*(x-1);
         yy:=MargeY[idim]+CoteY[idim]*(y-1);
         SetColor(b);
         For i:=1 to Rayon[idim] do Circle(xx,yy,i);
         {If g[x,y] and Respirer=Peut*Respirer
         Then begin SetColor(Green);
                    Circle(xx,yy,Rayon[idim]);
                    Circle(xx,yy,Rayon[idim]+1);
              end;}
   End;

PROCEDURE PlaceVide(x,y:byte);
 Var xx,yy:integer;
     cx,cy:integer;
   Begin xx:=MargeX[idim]+CoteX[idim]*(x-1);
         yy:=MargeY[idim]+CoteY[idim]*(y-1);
         cx:=CoteX[idim] div 2;
         cy:=CoteY[idim] div 2;
         SetFillStyle(SolidFill,LightGray);
         Bar(xx-cx,yy-cy,xx+cx,yy+cy);
         {SetLineStyle(SolidLn,0,ThickWidth);}
         SetColor(DarkGray);
         Line(xx-cx,yy,xx+cx,yy);
         Line(xx,yy-cy,xx,yy+cy);
   End;

PROCEDURE AfficheInfo(aqui:byte;pr:T_Captifs);
   Begin SetFillStyle(SolidFill,15*aqui);
         Bar(560,400,639,419);
         SetFillStyle(SolidFill,LightGray);
         Bar(550,200,600,218);
         SetFillStyle(SolidFill,LightGray);
         SetColor(DarkGray);
         Bar3D(560,350,639,389,1,false);
         SetColor(Black);
         OutTextXY(580,370,cat(pr[Noir]));
         SetColor(White);
         OutTextXY(620,370,cat(pr[Blanc]));
   End;

PROCEDURE AfficheGrille;
 Var i,j:byte;
     xx,yy:integer;
     cx,cy:integer;
     v:byte;
   Begin SetFillStyle(SolidFill,LightGray);
         Bar(0,0,639,479);
         SetColor(DarkGray);
         cx:= CoteX[idim] div 2; cy:=CoteY[idim] div 2;
         v:=dims[idim]-1;
         For i:=0 to v do
         begin xx:=MargeX[idim]+i*CoteX[idim];
               yy:=MargeY[idim]+i*CoteY[idim];
               Line(xx,MargeY[idim]-cy,xx,MargeY[idim]+v*CoteY[idim]+cy);
               Line(MargeX[idim]-cx,yy,MargeX[idim]+v*CoteX[idim]+cx,yy);
         end;
         SetFillStyle(SolidFill,DarkGray);
         Bar(560,460,639,479); { retourner au menu }
         Bar(560,430,639,449); { passer son tour }
         Bar(560,330,639,349); { prison titre }
         SetTextJustify(CenterText,CenterText);
         SetColor(LightRed);
         OutTextXY(600,465,'retourner');
         OutTextXY(600,475,'au menu');
         OutTextXY(600,435,'passer');
         OutTextXY(600,445,'son tour');
         SetColor(LightGreen);
         OutTextXY(600,340,'prison');
         For i:=1 to dims[idim] do For j:=1 to dims[idim] do
         If g[i,j] and Etat = OQP
         Then PlacePierre(i,j,15*((g[i,j] and couleur) shr 1));
   End;

{$I  SAVELOAD.PAS}

FUNCTION Copine(x,y,dx,dy:shortint):boolean;
 Var r:boolean;
     xx,yy:shortint;
   Begin xx:=x+dx; yy:=y+dy;
         r:=true;
         r:=r and (xx>=1);
         r:=r and (xx<=dims[idim]);
         r:=r and (yy>=1);
         r:=r and (yy<=dims[idim]);
         if r then r:=r and ((g[xx,yy] and Respirer) = PeutPas*Respirer);
         if r then r:=r and ((g[x,y] and etat = vide)
                             or (g[x,y] and Couleur = g[xx,yy] and couleur));
         Copine:=r;
   End;

PROCEDURE FluxAir(x,y:shortint); { r‚cursive ! }
 { la case x,y peut respirer }
 { et envoie de l'air … ses copines}
   Begin g[x,y]:=g[x,y] or Peut*Respirer;
         If Copine( x , y , -1 ,  0) Then FluxAir( x-1 , y   );
         If Copine( x , y ,  1 ,  0) Then FluxAir( x+1 , y   );
         If Copine( x , y ,  0 , -1) Then FluxAir(   x , y-1 );
         If Copine( x , y ,  0 ,  1) Then FluxAir(   x , y+1 );
   End;

PROCEDURE Respiration;
 { Qui peut respirer dans g ? La proc‚dure Respiration r‚pond … cette
   question en mettant … 1 le bit "Respirer" des cases qui le peuvent. }
 Var i,j:shortint;
   Begin For i:=1 to dims[idim] do For j:=1 to dims[idim] do
         g[i,j] := g[i,j] and not (Peut*Respirer);
         For i:=1 to dims[idim] do For j:=1 to dims[idim] do
         If g[i,j] and etat=vide Then FluxAir(i,j);
   End;

PROCEDURE Capture(aqui:byte);
 Var i,j:byte;
   Begin Respiration;
         For i:=1 to dims[idim] do For j:=1 to dims[idim] do
         If g[i,j] and (etat+couleur+respirer)
            =etat*OQP+(1-aqui)*couleur+peutpas*respirer
         Then begin g[i,j]:=0;
                    PlaceVide(i,j);
                    inc(pr[1-aqui]);
              end;
   End;

PROCEDURE EnvisageCoup(x,y,aqui:byte;var ok:boolean);
 Var gsav:T_Grille;
     ami,ennemi:integer; { nombre de pierres captur‚es }
     i,j:byte;
   Begin gsav:=g;
         g[x,y]:=g[x,y] or (etat*OQP+couleur*aqui);
         Respiration;
         ami:=0; ennemi:=0;
         For i:=1 to dims[idim] do For j:=1 to dims[idim] do
         begin if g[i,j] and (etat+respirer) = (etat*OQP+peutpas*respirer)
               then begin if g[i,j] and couleur = couleur*aqui
                          then inc(ami)
                          else inc(ennemi);
                    end;
         end;
         If ami=0
         Then ok:=true
         Else ok:=ennemi>0; { autocapture interdite sauf rŠgle priorit‚ }
         g:=gsav;
   End;

PROCEDURE OrdinateurJoue(aqui:byte;var ok:boolean;var x,y:shortint);
 Var stop,clic:boolean;
     t:char;
   Begin Repeat
         Repeat x:=random(dims[idim])+1;
                y:=random(dims[idim])+1;
                clic:=BoutonPresse(1);
                ok:=g[x,y] and etat = etat*vide
         Until ok or keypressed or clic;
               If ok
               then begin
                    EnvisageCoup(x,y,aqui,ok);
                    stop:=ok;
                    end;
               if keypressed
               then begin
                    t:=upcase(readkey);
                    VideClavier;
                    stop:=t=#27;
                    ok:=false;
                    end;
               if clic
               then begin
                    While BoutonPresse(1) do;
                    stop:=true;
                    ok:=false;
                    end;
         Until ok or stop;
   End;

PROCEDURE HumainJoue(aqui:byte;var ok:boolean;var x,y:shortint);
 Var xx,yy:integer;
     stop,dansg,passe:boolean;
     t:char;
   Begin Curseur(true);
         Repeat Attendre;
                If keypressed
                Then begin { þþþ gestion clavier þþþ }
                     t:=upcase(readkey);
                     VideClavier;
                     stop:=t=#27;
                     passe:=t=' ';
                     ok:=false;
                     end   { þþþ gestion clavier þþþ }
                Else begin { þþþ gestion souris þþþ }
                     While BoutonPresse(1) do;
                     xx:=PosX;
                     yy:=PosY;
                     x:=round((xx-MargeX[idim])/CoteX[idim]+1);
                     y:=round((yy-MargeY[idim])/CoteY[idim]+1);
                     passe:=(xx>=560) and (yy>=430) and (yy<450);
                     stop:=(xx>=560) and (yy>=460);
                     dansg:=(x>=1) and (x<=dims[idim]) and (y>=1) and (y<=dims[idim]);
                     If stop Then ok:=false;
                     If dansg
                     Then begin { þþ clic dans grille þþ }
                          If g[x,y] and etat = vide
                          Then begin { þ case cliqu‚e vide þ }
                               EnvisageCoup(x,y,aqui,ok);
                               stop:=ok;
                               end   { þ case cliqu‚e vide þ }
                          Else begin { þ case cliqu‚e OQP þ }
                               ok:=false;
                               stop:=false;
                               end   { þ case cliqu‚e OQP þ }
                          end;  { þþ clic dans grille þþ }
                     If passe
                     Then begin { þþ passe son tour þþ }
                          ok:=true; x:=0; y:=0; stop:=true;
                          end;  { þþ passe son tour þþ }
                     end;  { þþþ gestion souris þþþ }
         Until stop;
         Curseur(false);
   End;

PROCEDURE HumainArrange(aqui:byte;var ok:boolean;var x,y:shortint);
 Var xx,yy:integer;
     stop,dansg,passe:boolean;
     t:char;
   Begin Curseur(true);
         Repeat Attendre;
                If keypressed
                Then begin { þþþ gestion clavier þþþ }
                     t:=upcase(readkey);
                     VideClavier;
                     stop:=t=#27;
                     passe:=t=' ';
                     ok:=false;
                     end   { þþþ gestion clavier þþþ }
                Else begin { þþþ gestion souris þþþ }
                     While BoutonPresse(1) do;
                     xx:=PosX;
                     yy:=PosY;
                     x:=round((xx-MargeX[idim])/CoteX[idim]+1);
                     y:=round((yy-MargeY[idim])/CoteY[idim]+1);
                     passe:=(xx>=560) and (yy>=430) and (yy<450);
                     stop:=(xx>=560) and (yy>=460);
                     dansg:=(x>=1) and (x<=dims[idim]) and (y>=1) and (y<=dims[idim]);
                     If stop Then ok:=false;
                     If dansg
                     Then begin { þþ clic dans grille þþ }
                          If g[x,y] and etat = vide
                          Then begin { þ case cliqu‚e vide þ }
                               g[x,y]:=etat*OQP+Ya*Combleur;
                               Curseur(false);
                               PlacePierre(x,y,LightRed);
                               Curseur(true);
                               stop:=false;
                               end   { þ case cliqu‚e vide þ }
                          Else begin { þ case cliqu‚e OQP þ }
                               If g[x,y] and combleur=YaPas*Combleur
                               then inc(pr[(g[x,y] and couleur) div couleur]);
                               g[x,y]:=etat*vide;
                               Curseur(false);
                               AfficheInfo(aqui,pr);
                               PlaceVide(x,y);
                               Curseur(true);
                               stop:=false;
                               end   { þ case cliqu‚e OQP þ }
                          end;  { þþ clic dans grille þþ }
                     If passe
                     Then begin { þþ passe son tour þþ }
                          ok:=true; x:=0; y:=0; stop:=true;
                          end;  { þþ passe son tour þþ }
                     end;  { þþþ gestion souris þþþ }
         Until stop;
         Curseur(false);
   End;

PROCEDURE Jouer;
 Var ok:boolean;
     x,y:shortint;
   Begin ModeGraphique;
         AfficheGrille;
         Repeat AfficheInfo(aqui,pr);
                If jr[aqui]='H'
                Then HumainJoue(aqui,ok,x,y)
                Else OrdinateurJoue(aqui,ok,x,y);
                If ok
                Then If x<>0
                     Then begin { coup normal }
                          g[x,y]:=g[x,y] or (etat*OQP+couleur*aqui);
                          PlacePierre(x,y,15*aqui);
                          Capture(aqui);
                          aqui:=1-aqui;
                          end
                     Else { le joueur passe son tour }
                          aqui:=1-aqui;
         Until not ok;
         RestoreCrtMode;
   End;

PROCEDURE ModifieGrille;
 Var ok:boolean;
     x,y:shortint;
   Begin ModeGraphique;
         AfficheGrille;
         ok:=true;
         Repeat AfficheInfo(aqui,pr);
                HumainArrange(aqui,ok,x,y);
                If ok
                Then If x=0
                     Then aqui:=1-aqui;
         Until not ok;
         RestoreCrtMode;
   End;

PROCEDURE GCGS(var quitter:boolean;var jr:T_Joueurs;
               var aqui:byte);
 Var t:char;
     xx,yy:integer;
   Begin If keypressed
         Then (* d‚but gestion clavier *)
              begin t:=readkey;
                    If t<>#0
                    Then begin t:=upcase(t);
                               Case t of
                               #27,'Q': quitter:=true;
                               #13,'J': {if aqui in [Blanc,Noir]
                                        then} begin Curseur(false);
                                                   Jouer;
                                                   AfficheMenu(jr);
                                                   Curseur(true);
                                             end;
                               End;
                         end
                    Else begin t:=readkey;
                               Case t of
                               #59: begin InitGrille;
                                          pr[Noir]:=0;
                                          pr[Blanc]:=0;
                                          aqui:=Noir;
                                    end;
                               #60: begin Curseur(false);
                                          Sauvegarder;
                                          AfficheMenu(jr);
                                          Curseur(true);
                                    end;
                               #61: begin Curseur(false);
                                          Charger;
                                          AfficheMenu(jr);
                                          Curseur(true);
                                    end;
                               End;
                         end;
              end
              (* fin gestion clavier *)
         else (* d‚but gestion souris *)
              begin Repeat until not BoutonPresse(1);
                    xx:=PosXt; yy:=PosYt;
                    If (yy=08) and (xx in [20..25]) and (jr[0]='O')
                    Then begin jr[0]:='H'; Curseur(false);
                               Affjn(jr[0]); Curseur(true);
                         end;
                    If (yy=08) and (xx in [28..37]) and (jr[0]='H')
                    Then begin jr[0]:='O'; Curseur(false);
                               Affjn(jr[0]); Curseur(true);
                         end;
                    If (yy=10) and (xx in [20..25]) and (jr[1]='O')
                    Then begin jr[1]:='H'; Curseur(false);
                               Affjb(jr[1]); Curseur(true);
                         end;
                    If (yy=10) and (xx in [28..37]) and (jr[1]='H')
                    Then begin jr[1]:='O'; Curseur(false);
                               Affjb(jr[1]); Curseur(true);
                         end;
                    If (yy=12) and (xx in [3..34])
                    Then begin InitGrille;
                               pr[Noir]:=0;
                               pr[Blanc]:=0;
                               aqui:=Noir;
                         end;
                    If (yy=14) and (xx in [3..34]) and (aqui in [Noir,Blanc])
                    Then begin Curseur(false);
                               Jouer;
                               AfficheMenu(jr);
                               Curseur(true);
                         end;
                    If (yy=16) and (xx in [3..34])
                    Then begin Curseur(false);
                               Sauvegarder;
                               AfficheMenu(jr);
                               Curseur(true);
                         end;
                    If (yy=18) and (xx in [3..34])
                    Then begin Curseur(false);
                               Charger;
                               AfficheMenu(jr);
                               Curseur(true);
                         end;
                    If (yy=20) and (xx in [3..34])
                    Then begin Curseur(false);
                               ModifieGrille;
                               AfficheMenu(jr);
                               Curseur(true);
                         end;
                    If (yy=22) and (xx in [3..9])
                    Then Quitter:=true
              end;
              (* fin gestion souris *)
   End;

PROCEDURE Presentation;
 Var i:byte;
   Begin SetColor(LightGreen);
         OutTextXY(0,470,'Programmation par Luc ROUSSEAU (30 octobre 1995)');
         SetTextStyle(DefaultFont,HorizDir,5);
         SetFillStyle(CloseDotFill,LightGray);
         Bar(200,190,440,290);
         SetTextJustify(CenterText,CenterText);
         OutTextXY(320,240,'GO');
   End;

BEGIN InitSouris(statut,nbb);
      If statut<>-1
      then Writeln('Souris non install‚e')
      else begin ModeGraphique;
                 Presentation;
                 Attendre;
                 VideClavier; While BoutonPresse(1) do;
                 RestoreCrtMode;
                 Quitter:=false;
                 Randomize;
                 idim:=1;
                 InitGrille;
                 jr:='OO';
                 pr[Noir]:=0; pr[Blanc]:=0;
                 aqui:=Noir;
                 AfficheMenu(jr);
                 Curseur(true);
                 While not Quitter do
                 begin Attendre;
                       GCGS(quitter,jr,aqui);
                 end;
                 Curseur(false);
                 TextAttr:=LightGray; ClrScr;
                 CurseurTexte(6,7);
           end;
END.