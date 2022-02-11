PROGRAM Trinome;

        USES Crt,Dos,Graph;

        CONST Longueur = 65;

        TYPE T_Grille= Array [1..11,1..11] of byte;
             T_Chaine=string[longueur];
             T_Enreg = Record identification:T_Chaine;
                              aquidejouer:byte;
                              position:T_Grille
                       End;
             F_Enreg = File Of T_Enreg;
             T_Joueurs = Array[0..1] of char;

        CONST Etat=1; Vide=0; OQP=1;
              CoulPiece=2; Rouge=0; Verte=2; Vert=2;
              Forme=12; Triangle=4; Carre=8; Rond=12;
              Piece=15; TV=7; CV=11; RV=15; TR=5; CR=9; RR=13;
              Hachures=16;
              Camp=32; CampR=0; CampV=32;
              Coulcase=64; CaseN=0; CaseB=64;
              Acces=128; Accessible=128; Inaccessible=0;
              MargeX:integer=10; MargeY:integer=10;
              CoteX:integer=40; CoteY:integer=40;
              NbEnreg=20;

        VAR statut,nbb:integer;
            jr:T_Joueurs;
            pa:char;
            aqui:byte;
            g:T_Grille;
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

PROCEDURE Affjr(jr:char);
   Begin If jr='H' then TextAttr:=Yellow+16*LightGray+Blink
                   else TextAttr:=Yellow+16*LightGray;
         GotoXY(30,10); Write('Humain');
         If jr='O' then TextAttr:=Yellow+16*LightGray+Blink
                   else TextAttr:=Yellow+16*LightGray;
         GotoXY(50,10); Write('Ordinateur');
   End;

PROCEDURE Affjv(jv:char);
   Begin If jv='H' then TextAttr:=Yellow+16*LightGray+Blink
                   else TextAttr:=Yellow+16*LightGray;
         GotoXY(30,12); Write('Humain');
         If jv='O' then TextAttr:=Yellow+16*LightGray+Blink
                   else TextAttr:=Yellow+16*LightGray;
         GotoXY(50,12); Write('Ordinateur');
   End;

PROCEDURE Affpa(pa:char);
   Begin TextAttr:=Yellow+16*Blue; GotoXY(30,14);
         Case pa of
              'I':Write('initiale       ');
              'S':Write('sauvegard‚e    ');
              'N':Write('non sauvegard‚e');
         End; {Case}
         If pa='N'
         Then begin GotoXY(3,16);
                    TextAttr:=Yellow+16*LightGray;
                    Write('Sauvegarder la position actuelle');
              end;
   End;

PROCEDURE AfficheMenu(jr:T_Joueurs;pa:char);
 Var i:byte;
   Begin TextAttr:=Yellow+16*Blue; ClrScr;
         GotoXY(1,2);
         Writeln('                  ÜÜÜÜÜÜÜ ÜÜÜ  ÜÜÜ Ü    Ü  ÜßÜ  Ü     Ü ÜÜÜÜ');
         Writeln('                     Û    Û  Û  Û  ÛÜ   Û ß   ß ÛÜ   ÜÛ Û   ');
         Writeln('                     Û    ÛÜÜß  Û  Û ßÜ Û ÜßßßÜ Û ßÜß Û ÛÜÜ ');
         Writeln('                     Û    ÛßÜ   Û  Û   ßÛ Û   Û Û     Û Û   ');
         Writeln('                     Û    Û ßÜ ÜÛÜ Û    Û ßÜÜÜß Û     Û ÛÜÜÜ');
         GotoXY(1,1); Write('É'); GotoXY(80,1); Write('»');
         GotoXY(1,24); Write('È'); GotoXY(80,24); Write('¼');
         GotoXY(2,1);  For i:=2 to 79 do Write('Í');
         GotoXY(2,24); For i:=2 to 79 do Write('Í');
         For i:=2 to 23 do
         begin GotoXY(1,i); Write('º');
               GotoXY(80,i); Write('º');
         end;
         GotoXY(3,10); Write('Joueur rouge:'); Affjr(jr[Rouge shr 1]);
         TextAttr:=Yellow+16*Blue;
         GotoXY(3,12); Write('Joueur vert:');  Affjv(jr[Vert shr 1]);

         TextAttr:=Yellow+16*Blue;
         GotoXY(3,14); Write('Position actuelle:');
         Affpa(pa);

         TextAttr:=Yellow+16*LightGray;
         GotoXY(3,18); Write('Charger une position initiale');
         GotoXY(3,20); Write('Charger une position sauvegard‚e');
         GotoXY(3,22); Write('Jouer la position actuelle');
         GotoXY(3,24); Write('Quitter');
   End;

PROCEDURE InitGrille(var g:T_Grille);
 Var i,j:byte;
   Begin (* cases vid‚es et color‚es *)
         For i:=1 to 11 do For j:=1 to 11 do
         g[i,j]:=((i+j) mod 2)*CoulCase;
         (* cases hachur‚es, camps, et ronds *)
         For i:=5 to 7 do
         begin g[i,1]:=g[i,1] or (hachures+CampR+RR);
               g[i,11]:=g[i,11] or (hachures+campV+RV);
         end;
         (* carr‚s *)
         For i:=1 to 3 do
         begin g[i,4-i]:=g[i,4-i] or CR;
               g[i,8+i]:=g[i,8+i] or CV;
               g[i+8,i]:=g[i+8,i] or CR;
               g[i+8,12-i]:=g[i+8,12-i] or CV;
         end;
         (* triangles *)
         For i:=1 to 2 do For j:=1 to 2 do
         begin if i+j<4 then
               begin g[i,j]:=g[i,j] or TR;
                     g[i,12-j]:=g[i,12-j] or TV;
                     g[12-i,j]:=g[12-i,j] or TR;
                     g[12-i,12-j]:=g[12-i,12-j] or TV;
               end;
         end;
   End;

PROCEDURE Echange(var a,b:byte);
 Var c:byte;
   Begin c:=a; a:=b; b:=c;
   End;

PROCEDURE Place(x,y,b:byte);
 Var xx,yy:integer;
   Begin xx:=MargeX+CoteX*(x-1);
         yy:=MargeY+CoteY*(y-1);
         Case b and (CoulCase+hachures) of
         CaseN: begin SetFillStyle(SolidFill,Black);
                      Bar(xx,yy,xx+CoteX-1,yy+CoteY-1);
                end;
         CaseB: begin SetFillStyle(SolidFill,LightBlue);
                      Bar(xx,yy,xx+CoteX-1,yy+CoteY-1);
                end;
         CaseN+Hachures: begin SetFillStyle(LtSlashFill,LightBlue);
                               Bar(xx,yy,xx+CoteX-1,yy+CoteY-1);
                         end;
         CaseB+Hachures: begin SetFillStyle(SlashFill,LightBlue);
                               Bar(xx,yy,xx+CoteX-1,yy+CoteY-1);
                         end;
         End; {Case}
         Case b and CoulPiece of
              Rouge: SetColor(LightRed);
              Verte: SetColor(LightGreen)
         End; {Case}
         SetLineStyle(SolidLn,0,ThickWidth);
         Case b and Forme of
              Triangle: begin Line(xx+5,yy+CoteY-5,xx+CoteX-5,yy+CoteY-5);
                              Line(xx+CoteX-5,yy+CoteY-5,xx+CoteX div 2,yy+5);
                              Line(xx+CoteX div 2,yy+5,xx+5,yy+CoteY-5)
                        end;
              Rond: Circle(xx+CoteX div 2,yy+CoteY div 2,CoteX div 2-4);
              Carre: Rectangle(xx+5,yy+5,xx+CoteX-5,yy+CoteY-5);
         End; {Case}
         If b and Acces = Accessible
         Then begin SetLineStyle(SolidLn,1,ThickWidth);
                    SetColor(Yellow);
                    Line(xx+3,yy+3,xx+CoteX-3,yy+CoteY-3);
                    Line(xx+3,yy+CoteY-3,xx+CoteX-3,yy+3);
              end;
   End;

PROCEDURE AfficheGrille(VAR g:T_Grille);
 Var i,j:byte;
   Begin For i:=1 to 11 do
         For j:=1 to 11 do
         Place(i,j,g[i,j]);
         SetLineStyle(SolidLn,0,NormWidth);
         SetColor(LightBlue);
         Rectangle(MargeX-2,MargeY-2,MargeX+11*CoteX+1,MargeY+11*CoteY+1);
   End;

PROCEDURE Sauvegarder(VAR g:T_Grille;aqui:byte);
 Var f:F_Enreg;
     enr:T_Enreg;
     ligne,i:byte;
   Begin TextAttr:=Yellow+16*Blue;
         ClrScr; 
         GotoXY(35,1); Writeln('SAUVEGARDER');
         Writeln('Choisissez un emplacement et tapez un texte identificateur');
         Assign(f,'SAUVGARD.3NM');
         Reset(f);
         For i:=1 to NbEnreg do
         begin Read(f,enr);
               GotoXY(1,i+3); Write(i:2);
               GotoXY(5,i+3); Write(enr.identification);
         end;
         Curseur(true);
         While BoutonPresse(1) do;
         Repeat Repeat until BoutonPresse(1);
                While BoutonPresse(1) do; VideClavier;
                ligne:=PosYt;
         Until ligne in [4..23];
         Seek(f,ligne-4); CurseurTexte(6,7); GotoXY(5,ligne);
         Curseur(false);
         ClrEol; Saisir(enr.identification);
         enr.aquidejouer:=aqui; enr.position:=g;
         Write(f,enr);
         Close(f);
         CurseurTexte(7,0);
   End;

PROCEDURE Charger(var g:T_Grille;var aqui:byte);
 Var f:F_Enreg;
     enr:T_Enreg;
     ligne,i:byte;
   Begin TextAttr:=Yellow+16*Blue;
         ClrScr; 
         GotoXY(35,1); Writeln('CHARGER');
         Writeln('Choisissez une sauvegarde');
         Assign(f,'SAUVGARD.3NM');
         Reset(f);
         For i:=1 to NbEnreg do
         begin Read(f,enr);
               GotoXY(1,i+3); Write(i:2);
               GotoXY(5,i+3); Write(enr.identification);
         end;
         Curseur(true);
         While BoutonPresse(1) do; ligne:=1;
         Repeat Repeat until BoutonPresse(1);
                While BoutonPresse(1) do;
                ligne:=PosYt;
         Until ligne in [4..23];
         Seek(f,ligne-4);
         Read(f,enr);
         Close(f);
         g:=enr.position; aqui:=enr.aquidejouer;
         Curseur(false);
   End;


PROCEDURE SelectionPiece(var select,stop:boolean;var xs,ys:byte;
                         VAR g:T_Grille;aqui:byte);
 Var xx,yy:integer;
     xt,yt:shortint;
   Begin Attendre;
         If keypressed
         then begin stop:=readkey=#27; VideClavier;
              end
         else begin While BoutonPresse(1) do;
                    xx:=PosX; yy:=PosY;
                    xt:=(xx-MargeX) div CoteX +1;
                    yt:=(yy-MargeY) div CoteY +1;
                    If (xt in [1..11]) and (yt in [1..11])
                    Then begin xs:=xt; ys:=yt;
                           select:=((g[xs,ys] and (Etat+CoulPiece)=OQP+aqui)) and (g[xs,ys] and
                                    (Hachures+Camp)<>Hachures+(2-aqui) shl 4);
                         end
                    Else select:=false;
              end;
   End;

PROCEDURE SelectionCaseAcc(var select:boolean;var xa,ya:byte;VAR g:T_Grille);
 Var xx,yy:integer;
     xt,yt:shortint;
   Begin Attendre;
         If keypressed
         then VideClavier
         else begin While BoutonPresse(1) do;
                    xx:=PosX; yy:=PosY;
                    xt:=(xx-MargeX) div CoteX +1;
                    yt:=(yy-MargeY) div CoteY +1;
                    If (xt in [1..11]) and (yt in [1..11])
                    Then begin xa:=xt; ya:=yt;
                           select:=(g[xa,ya] and Acces=Accessible);
                         end
                    Else select:=false;
              end;
   End;

PROCEDURE Marque(x,y,aqui:byte;var g:T_Grille;var nb:byte);
   Begin if (g[x,y] and Etat=Vide)
         or ((g[x,y] and Etat=OQP) and (g[x,y] and CoulPiece<>aqui)
              and (g[x,y] and (Hachures+Camp)<>Hachures+(aqui shl 4)))
         then begin g[x,y]:=g[x,y] or Accessible;
                    inc(nb);
              end;
   End;

PROCEDURE MarquerCasesAcc(xs,ys,aqui:byte;var g:T_Grille;var select:boolean);
 Var nb:byte;
     correct:boolean;
   Begin nb:=0;
         correct:=((g[xs,ys] and (Etat+CoulPiece)=OQP+aqui)) and (g[xs,ys] and
         (Hachures+Camp)<>Hachures+(2-aqui) shl 4);
         Case g[xs,ys] and Forme of
         Triangle: begin If xs>1
                         then begin if ys>1
                                    then Marque(xs-1,ys-1,aqui,g,nb);
                                    if ys<11
                                    then Marque(xs-1,ys+1,aqui,g,nb);
                              end;
                         If xs<11
                         then begin if ys>1
                                    then Marque(xs+1,ys-1,aqui,g,nb);
                                    if ys<11
                                    then Marque(xs+1,ys+1,aqui,g,nb);
                              end;
                   end;
         Carre:    begin If xs>1
                         then Marque(xs-1,ys,aqui,g,nb);
                         If xs<11
                         then Marque(xs+1,ys,aqui,g,nb);
                         If ys>1
                         then Marque(xs,ys-1,aqui,g,nb);
                         If ys<11
                         then Marque(xs,ys+1,aqui,g,nb);
                   end;
         Rond:     begin If xs>2
                         Then begin If g[xs-1,ys] and Etat = Vide
                                    Then Marque(xs-2,ys,aqui,g,nb);
                                    If ys>2
                                    Then If g[xs-1,ys-1] and Etat = Vide
                                         Then Marque(xs-2,ys-2,aqui,g,nb);
                                    If ys<10
                                    Then If g[xs-1,ys+1] and Etat = Vide
                                         Then Marque(xs-2,ys+2,aqui,g,nb);
                              end;
                         If xs<10
                         Then begin If g[xs+1,ys] and Etat = Vide
                                    Then Marque(xs+2,ys,aqui,g,nb);
                                    If ys>2
                                    Then If g[xs+1,ys-1] and Etat = Vide
                                         Then Marque(xs+2,ys-2,aqui,g,nb);
                                    If ys<10
                                    Then If g[xs+1,ys+1] and Etat = Vide
                                         Then Marque(xs+2,ys+2,aqui,g,nb);
                              end;
                         If ys>2
                         Then If g[xs,ys-1] and Etat = Vide
                              Then Marque(xs,ys-2,aqui,g,nb);
                         If ys<10
                         Then If g[xs,ys+1] and Etat = Vide
                              Then Marque(xs,ys+2,aqui,g,nb);
                   end;
         End; {Case}
         select:=(nb<>0) and correct;
   End;

PROCEDURE MontrerCasesAcc(VAR g:T_Grille);
 Var i,j:byte;
   Begin For i:=1 to 11 do For j:=1 to 11 do
         if g[i,j] and Acces = Accessible
         then Place(i,j,g[i,j]);
   End;

PROCEDURE CacherCasesAcc(var g:T_Grille);
 Var i,j:byte;
   Begin For i:=1 to 11 do For j:=1 to 11 do
         If g[i,j] and Acces = Accessible
         Then begin g[i,j]:=g[i,j] xor accessible;
                    Place(i,j,g[i,j]); 
              end;
   End;

PROCEDURE DemarquerCasesAcc(var g:T_Grille);
 Var i,j:byte;
   Begin For i:=1 to 11 do For j:=1 to 11 do
         If g[i,j] and Acces = Accessible
         Then g[i,j]:=g[i,j] xor accessible;
   End;

PROCEDURE EffectuerDepl(xs,ys,xa,ya:byte;var g:T_Grille);
   Begin g[xa,ya]:=(g[xa,ya] xor (g[xa,ya] and Piece)) or (g[xs,ys] and Piece);
         g[xs,ys]:=(g[xs,ys] xor (g[xs,ys] and Piece));
         Place(xs,ys,g[xs,ys]); Place(xa,ya,g[xa,ya]);
   End;

PROCEDURE TestGainPieceEnnemie(xd,yd,xa,ya:byte;VAR g:T_Grille;
          qui:byte;var note:integer);
   Begin  If g[xa,ya] and (Etat+CoulPiece)= OQP+2-qui
          then note:=note+50;
   End;

PROCEDURE TestApproche(xd,yd,xa,ya:byte;VAR g:T_Grille;
          qui:byte;var note:integer);
 Var x,y:byte;
   Begin x:=1; y:=1;
         While (g[x,y] and (Hachures+Camp)) <> (Hachures+Camp-(qui shl 4)) do
         begin inc(x);
               if x=12 then begin x:=1; inc(y); end;
         end;
         if x in [5,7] then x:=6;
         if y in [5,7] then y:=6;
         note:=note+16-round(sqrt(sqr(x-xa)+sqr(y-ya)));
         if ((y=1) and (ya=1)) or ((y=11) and (ya=11))
         or ((x=1) and (xa=1)) or ((x=11) and (xa=11))
         then note:=note+1;
   End;

PROCEDURE NoterCoup(xd,yd,xa,ya:byte;VAR g:T_Grille;
                    qui:byte;var note:integer);
   Begin note:=0;
         TestGainPieceEnnemie(xd,yd,xa,ya,g,qui,note);
         TestApproche(xd,yd,xa,ya,g,qui,note);
   End;

PROCEDURE OrdinateurJoue(var g:T_Grille;qui:byte);
 Var NoteMem:integer;         (* note maximale m‚moris‚e *)
     xdm,ydm,xam,yam:byte;    (* coordonn‚es du coup m‚moris‚ *)
     Note:integer;
     xd,yd,xa,ya:byte;
     ok:boolean;
   Begin NoteMem:=-32768; xdm:=0; ydm:=0; xam:=0; yam:=0; ok:=true;
         For xd:=1 to 11 do
         For yd:=1 to 11 do
         If (g[xd,yd] and (CoulPiece+Etat) = OQP+qui)
         Then begin MarquerCasesAcc(xd,yd,qui,g,ok);
                    If ok
                    Then For xa:=1 to 11 do
                         For ya:=1 to 11 do
                         If g[xa,ya] and Acces = Accessible
                         Then begin NoterCoup(xd,yd,xa,ya,g,qui,note);
                                    If Note>NoteMem
                                    Then begin NoteMem:=Note;
                                               xdm:=xd; ydm:=yd;
                                               xam:=xa; yam:=ya;
                                         end;
                              end;
                    DemarquerCasesAcc(g);
              end;
         If xdm<>0
         Then begin MarquerCasesAcc(xdm,ydm,qui,g,ok);
                    MontrerCasesAcc(g);
                    Delay(500);
                    CacherCasesAcc(g);
                    EffectuerDepl(xdm,ydm,xam,yam,g);
              end;
   End;

PROCEDURE Jouer(var g:T_Grille;jr:T_Joueurs;var pa:char;var aqui:byte);
 Var stop,select:boolean;
     xs,ys,xa,ya:byte;
   Begin ModeGraphique;
         SetRGBPalette(EGALightBlue,30,30,50);
         AfficheGrille(g);
         SetColor(Yellow); OutTextXY(0,470,'Echap pour retourner au menu');
         Curseur(true);
         stop:=not(aqui in [Rouge,Vert]);
         While not stop do
         begin If aqui=Rouge then SetRGBPalette(EGAWhite,63,0,0)
                             else SetRGBPalette(EGAWhite,0,63,0);
               If jr[aqui shr 1]='H'
               Then begin select:=false;
                          Repeat SelectionPiece(select,stop,xs,ys,g,aqui);
                                 If select
                                 then MarquerCasesAcc(xs,ys,aqui,g,select);
                                 {syntaxe voulue: pas de ...else...}
                                 If not select
                                 Then DemarquerCasesAcc(g);
                          Until select or stop;
                          If Select
                          Then begin Curseur(false);
                                     MontrerCasesAcc(g);
                                     Curseur(true);
                                     select:=false;
                                     Repeat SelectionCaseAcc(select,xa,ya,g);
                                     Until select;
                                     Curseur(false);
                                     CacherCasesAcc(g);
                                     EffectuerDepl(xs,ys,xa,ya,g);
                                     Curseur(true);
                                     Aqui:=2-aqui; pa:='N';
                               end;
                    end
               Else begin Curseur(false);
                          OrdinateurJoue(g,aqui);
                          aqui:=2-aqui; pa:='N';
                          If jr<>'OO' then Curseur(true);
                          If keypressed
                          Then begin If readkey=#27 then stop:=true;
                                     VideClavier;
                               end;
                    end;
         end;
         curseur(false);
         RestoreCrtMode;
         VideClavier;
         Repeat until not BoutonPresse(1);
         CurseurTexte(7,0);
   End;

PROCEDURE GCGS(var quitter:boolean;var g:T_Grille;var jr:T_Joueurs;
               var pa:char;var aqui:byte);
 Var t:char;
     xx,yy:integer;
   Begin If keypressed
         Then (* d‚but gestion clavier *)
              begin t:=readkey;
                    If t<>#0
                    Then begin t:=upcase(t);
                               Case t of
                               #27,'Q': quitter:=true;
                               #13,'J': if aqui in [Rouge,Vert]
                                        then begin Curseur(false);
                                                   Jouer(g,jr,pa,aqui);
                                                   AfficheMenu(jr,pa);
                                                   Curseur(true);
                                             end;
                               End;
                         end
                    Else begin t:=readkey;
                               Case t of
                               #60: if pa='N' then
                                    begin Curseur(false);
                                          Sauvegarder(g,aqui);
                                          pa:='S';
                                          AfficheMenu(jr,pa);
                                          Curseur(true);
                                    end;
                               #61: begin Curseur(false);
                                          Charger(g,aqui);
                                          pa:='S';
                                          AfficheMenu(jr,pa);
                                          Curseur(true);
                                    end;
                               End;
                         end;
              end
              (* fin gestion clavier *)
         else (* d‚but gestion souris *)
              begin Repeat until not BoutonPresse(1);
                    xx:=PosXt; yy:=PosYt;
                    If (yy=10) and (xx in [30..35]) and (jr[0]='O')
                    Then begin jr[0]:='H'; Curseur(false);
                               Affjr(jr[0]); Curseur(true);
                         end;
                    If (yy=10) and (xx in [50..59]) and (jr[0]='H')
                    Then begin jr[0]:='O'; Curseur(false);
                               Affjr(jr[0]); Curseur(true);
                         end;
                    If (yy=12) and (xx in [30..35]) and (jr[1]='O')
                    Then begin jr[1]:='H'; Curseur(false);
                               Affjv(jr[1]); Curseur(true);
                         end;
                    If (yy=12) and (xx in [50..59]) and (jr[1]='H')
                    Then begin jr[1]:='O'; Curseur(false);
                               Affjv(jr[1]); Curseur(true);
                         end;
                    If (yy=16) and (xx in [3..34]) and (pa='N')
                    Then begin Curseur(false);
                               Sauvegarder(g,aqui);
                               pa:='S';
                               AfficheMenu(jr,pa);
                               Curseur(true);
                         end;
                    If (yy=18) and (xx in [3..31]) and (pa<>'I')
                    Then begin pa:='I'; aqui:=Rouge;
                               InitGrille(g);
                               Curseur(false);
                               AfficheMenu(jr,pa);
                               Curseur(true);
                         end;
                    If (yy=20) and (xx in [3..34])
                    Then begin Curseur(false);
                               Charger(g,aqui);
                               pa:='S';
                               AfficheMenu(jr,pa);
                               Curseur(true);
                         end;
                    If (yy=22) and (xx in [3..28]) and (aqui in [Rouge,Vert])
                    Then begin Curseur(false);
                               Jouer(g,jr,pa,aqui);
                               AfficheMenu(jr,pa);
                               Curseur(true);
                         end;
                    If (yy=24) and (xx in [3..9])
                    Then Quitter:=true
              end;
              (* fin gestion souris *)
   End;

PROCEDURE Presentation(VAR g:T_Grille);
 Var i:byte;
   Begin SetRGBPalette(EGALightBlue,30,30,50);
         AfficheGrille(g);
         SetColor(Yellow);
         OutTextXY(0,470,'Programmation par Luc ROUSSEAU (03 septembre 1994)');
         SetTextStyle(DefaultFont,HorizDir,5);
         SetFillStyle(XHatchFill,LightGray);
         Bar(140,190,500,290);
         SetTextJustify(CenterText,CenterText);
         OutTextXY(320,240,'TRINOME');
   End;

BEGIN InitSouris(statut,nbb);
      If statut<>-1
      then Writeln('Souris non install‚e')
      else begin ModeGraphique;
                 InitGrille(g);
                 Presentation(g);
                 Attendre;
                 VideClavier; While BoutonPresse(1) do;
                 RestoreCrtMode;
                 Quitter:=false;
                 jr:='HH'; pa:='I';
                 aqui:=Rouge;
                 CurseurTexte(7,0);
                 AfficheMenu(jr,pa);
                 Curseur(true);
                 While not Quitter do
                 begin Attendre;
                       GCGS(quitter,g,jr,pa,aqui);
                 end;
                 Curseur(false);
                 TextAttr:=LightGray; ClrScr;
                 CurseurTexte(6,7);
           end;
END.