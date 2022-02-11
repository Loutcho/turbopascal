PROGRAM MasterMindGraphique;

        USES Crt,Dos,Graph;

        TYPE T_1Coup     = Array[1..4] of byte;
             T_2Coups    = Record essai,correction:T_1Coup;
                           End;
             T_10x2Coups = Array[1..10] of T_2Coups;
             T_Tab       = Record BonneCombi:T_1coup;
                                  Essais:T_10x2Coups;
                           End;

        CONST CoteX=25; CoteY=20;

        VAR Tab:T_Tab;
            NbCoups:shortint;
            statut,Nbboutons:integer;
            Interr,Gagne,Perdu,Rejouer:boolean;
            reponse:char;
            Gd,Gm:integer;
            NbCouleurs:byte;

FUNCTION Cat(n:integer):string;
 Var s:string;
   Begin str(n,s);
         Cat:=s;
   End;

{$I  INTECRAN.PAS}

PROCEDURE Presentation;
 Var t:char;
   Begin SetTextStyle(TriplexFont,HorizDir,9);
         OutTextXY(1,200,'MASTER MIND');
         SetTextStyle(TriplexFont,HorizDir,3);
         OutTextXY(1,450,'programmation de Luc ROUSSEAU (Aout 1992)');
         While not keypressed do;
         While keypressed do t:=readkey;
   End;

PROCEDURE ModeGraphique(var Gd,Gm:integer);
   Begin Gd:=VGA;
         Gm:=VGAHI;
         InitGraph(Gd,Gm,'');
         If GraphResult<>GrOk then Halt(1);
   End;

PROCEDURE TireBonneCombi(var bc:T_1Coup);
 Var i:shortint;
   Begin For i:=1 to 4 do bc[i]:=random(NbCouleurs)+1;
   End;

PROCEDURE ConvertitCouleur(var c:byte);
   Begin Case c of
          1: c:=Black;
          2: c:=White;
          3: c:=Red;
          4: c:=Green;
          5: c:=Blue;
          6: c:=Yellow;
          7: c:=LightGray;
          {‚viter d'aller au del…  de 7 (trop difficile)}
          8: c:=Cyan;
          9: c:=Magenta;
          10:c:=Brown;
          11:c:=DarkGray;
          12:c:=LightBlue;
          13:c:=LightGreen;
          14:c:=LightCyan;
          15:c:=LightRed;
          16:c:=LightMagenta;
         End;
   End;

PROCEDURE ConvertitCoup(var c:T_1Coup);
 Var i:shortint;
   Begin For i:=1 to 4 do ConvertitCouleur(c[i]);
   End;

PROCEDURE Initialise(var essais:T_10x2Coups);
 Var i:shortint;
   Begin For i:=1 to 4 do
               begin essais[1].essai[i]:=LightGray;
                     essais[1].Correction[i]:=LightGray;
               end;
               ConvertitCoup(essais[1].essai);
         For i:=2 to 10 do
         begin essais[i]:=essais[1];
         end;
   End;

PROCEDURE AfficheCouleur(x,y,c:byte);
   Begin SetFillStyle(SolidFill,LightGray);
         SetColor(c);
         Bar(CoteX*(X-1),CoteY*(Y-1),CoteX*x,CoteY*y);
         Circle((x-1)*CoteX+CoteX div 2,(y-1)*CoteY+CoteY div 2,CoteX div 3);
         SetFillStyle(SolidFill,c);
         FloodFill((x-1)*CoteX+CoteX div 2,(y-1)*CoteY+CoteY div 2,c);
   End;

PROCEDURE AfficheBonneCombi(bc:T_1Coup);
 Var i:shortint;
   Begin For i:=1 to 4 do
         AfficheCouleur(10+i,1,bc[i]);
   End;

PROCEDURE CacheBonneCombi;
 Var i:shortint;
   Begin For i:=1 to 4 do
         AfficheCouleur(10+i,1,LightGray)
   End;

PROCEDURE AfficheEssai(y:byte;es:T_1Coup);
 Var i:byte;
   Begin For i:=1 to 4 do AfficheCouleur(2+i,y,es[i]);
   End;

PROCEDURE AfficheCorrection(y:byte;co:T_1Coup);
 Var i:byte;
   Begin For i:=1 to 4 do AfficheCouleur(i+10,y,co[i]);
   End;

PROCEDURE Affiche2Coups(num:byte;coup:T_2Coups);
   Begin AfficheEssai(num,coup.essai);
         AfficheCorrection(num,coup.correction);
   End;

PROCEDURE AfficheCommandes(NbCouleurs:byte);
 Var i:shortint;
     c:byte;
   Begin SetLineStyle(SolidLn,0,NormWidth);
         SetColor(LightGray);
         Rectangle(0,0,639,479);
         Line(0,25,639,25);
         Line(200,25,200,300);
         Line(0,300,400,300);
         Line(400,25,400,420);
         Line(0,420,639,420);
         SetFillStyle(SolidFill,DarkGray);
         FloodFill(1,1,LightGray);
         TextAttr:=LightGray+128;
         VaEnXY(3,1);  Ecrire('Combinaison recherch‚e:');
         VaEnXY(8,3);  Ecrire('Tentative');
         VaEnXY(33,3); Ecrire('Correction');
         SetTextStyle(DefaultFont,HorizDir,1);
         SetColor(LightGray);
         For i:=1 to 10 do
         OutTextXY(2,CoteY*(2+i)+4,cat(i));
         SetFillStyle(SolidFill,DarkGray);
         FloodFill(500,200,LightGray);
         FloodFill(1,419,LightGray);
         For i:=1 to NbCouleurs do
         begin c:=i;
               ConvertitCouleur(c);
               AfficheCouleur(20,5+i,c);
               OutTextXY(530,CoteY*(4+i)+4,'F'+cat(i));
         end;
         AfficheCouleur(20,12,LightGray);
         OutTextXY(530,CoteY*(11)+4,'Suppr');
         TextAttr:=LightGray+128;
         VaEnXY(60,3); Ecrire('Commandes');
         VaEnXY(52,17); Ecrire('Valider la tentative  Entr‚e');
         VaEnXY(52,18); Ecrire('Avorter la partie     Echap');
         SetColor(LightGray);
         Rectangle(580,255,635,270);
         Rectangle(580,272,635,287);
         SetLineStyle(DottedLn,0,NormWidth);
         SetColor(LightGray);
         Line(0,50,400,50);
         SetColor(White);
         Line(400,50,639,50);
         {axes du graphique}
         SetColor(White);
         SetLineStyle(SolidLn,0,NormWidth);
         Line(50,410,350,410);
         Line(50,310,50,410);
         SetLineStyle(DashedLn,0,NormWidth);
         For i:=1 to 10 do
         begin Line(50+i*30,415,50+i*30,305);
               Line(45,410-i*10,355,410-i*10);
         end;
   End;

PROCEDURE Corrige(es,bc:T_1Coup;var co:T_1Coup);
 Var i,j:shortint;
   Begin For i:=1 to 4 do co[i]:=0;
         For i:=1 to 4 do
         If es[i]=bc[i]
            then co[i]:=co[i] or (128+2+1);
         For i:=1 to 4 do
         If co[i] and 1 = 0
            then For j:=1 to 4 do
                 If (co[j] and 2 = 0) and (co[i] and 1 = 0)
                    then if es[i]=bc[j]
                            then begin co[i]:=co[i] or (64+1) ;
                                       co[j]:=co[j] or 2;
                                 end;
         For i:=1 to 4 do
         Case co[i] and (128+64) of
              128:co[i]:=Black;
              64:co[i]:=White;
              0:co[i]:=LightGray;
         Else Halt(1);
         End;
   End;

PROCEDURE Classe(var co:T_1Coup);
 Var i,x:shortint;
     am:T_1Coup;
   Begin x:=1;
         For i:=1 to 4 do
         If co[i] = Black then
         begin am[x]:=Black;
               x:=x+1;
         end;
         For i:=1 to 4 do
         If co[i] = White then
         begin am[x]:=White;
               x:=x+1;
         end;
         For i:=x to 4 do am[i]:=LightGray;
         co:=am;
   End;

PROCEDURE Symbole(x,y:shortint);
   Begin SetColor(Blue);
         Circle((x+1)*CoteX+CoteX div 2,(y+2)*CoteY+CoteY div 2,CoteX div 3);
         SetColor(LightBlue);
         Circle((x+1)*CoteX+CoteX div 2,(y+2)*CoteY+CoteY div 2,CoteX div 3+1);
         SetColor(LightCyan);
         Circle((x+1)*CoteX+CoteX div 2,(y+2)*CoteY+CoteY div 2,CoteX div 3+2);
   End;

PROCEDURE SaisitCoup(num:shortint;var tab:T_Tab;var Interr:boolean);
 Var Valide:boolean;
     t:char;
     x:shortint;
   Begin valide:=false;
         x:=1;
         AfficheEssai(num+3,tab.essais[num].essai);
         Repeat
         SetColor(10);
         Symbole(x,num);
         t:=readkey;
         If t<>#0 then begin t:=upcase(t);
                             Case t of
                             #27:Interr:=true;
                             #13:Valide:=true;
                             End;
                       end
                  else begin t:=readkey;
                             Case t of
                             #59:tab.essais[num].essai[x]:=Black;
                             #60:tab.essais[num].essai[x]:=White;
                             #61:tab.essais[num].essai[x]:=Red;
                             #62:tab.essais[num].essai[x]:=Green;
                             #63:tab.essais[num].essai[x]:=Blue;
                             #64:tab.essais[num].essai[x]:=Yellow;
                             #77:if x<4 then x:=x+1
                                        else x:=1;
                             #75:if x>1 then x:=x-1
                                        else x:=4;
                             #83:tab.essais[num].essai[x]:=LightGray;
                             #72:if num>1 then
                                 tab.essais[num].essai:=
                                 tab.essais[num-1].essai;
                             End;
                       end;
         AfficheEssai(num+3,tab.essais[num].essai);
         Until Interr or Valide;
   End;

PROCEDURE Graphique(x:byte;VAR co:T_1Coup);
 Var i,pct:shortint;
   Begin pct:=0;
         For i:=1 to 4 do
         Case co[i] of
              Black:pct:=pct+25;
              White:pct:=pct+10;
         End;
         SetLineStyle(SolidLn,0,NormWidth);
         SetFillStyle(SolidFill,LightGreen);
         SetColor(White);
         Bar(30*(x-1)+50,410-pct,30*x+50,410);
   End;

BEGIN NbCouleurs:=6;

      Randomize;

      ModeGraphique(gd,gm);

      Presentation;

    Repeat

      ClearDevice; AfficheCommandes(NbCouleurs);

      Initialise(Tab.essais);
      Interr:=false; Gagne:=false; Perdu:=false;
      NbCoups:=1;

      TireBonneCombi(Tab.BonneCombi);
      ConvertitCoup(Tab.BonneCombi);
      CacheBonneCombi;

      While not Interr and not Gagne and not Perdu do
      begin
            SaisitCoup(NbCoups,Tab,Interr);
            If not Interr then
            begin Corrige(Tab.essais[NbCoups].essai,Tab.BonneCombi,
                          Tab.essais[NbCoups].correction);
                  Classe(Tab.essais[NbCoups].correction);
                  AfficheCorrection(3+NbCoups,Tab.essais[NbCoups].correction);
                  Gagne:=    (Tab.essais[NbCoups].essai[1]=Tab.BonneCombi[1])
                         and (Tab.essais[NbCoups].essai[2]=Tab.BonneCombi[2])
                         and (Tab.essais[NbCoups].essai[3]=Tab.BonneCombi[3])
                         and (Tab.essais[NbCoups].essai[4]=Tab.BonneCombi[4]);
                  Graphique(NbCoups,Tab.essais[NbCoups].correction);
                  NbCoups := NbCoups+1;
                  If not Gagne then Perdu:=NbCoups >= 11;
            end; (* IF *)
      end; (* WHILE *)
      SetFillStyle(SolidFill,DarkGray);
      Bar(401,26,638,419);
      AfficheBonneCombi(Tab.BonneCombi);
      If Perdu then SetFillStyle(SolidFill,LightRed);
      If Gagne then SetFillStyle(SolidFill,LightBlue);
      If Interr then SetFillStyle(SolidFill,DarkGray);
      FloodFill(1,478,LightGray);
      TextAttr:=Cyan+128;
      VaEnXY(3,28);
      If Gagne then
         if NbCoups=2 then Ecrire('La bonne combinaison a ‚t‚ trouv‚e du premier coup!')
                      else Ecrire('La bonne combinaison a ‚t‚ trouv‚e en '+cat(NbCoups-1)+' coups.');
      If Perdu then Ecrire('La bonne combinaison n''a pas ‚t‚ trouv‚e.');
      If Interr then Ecrire('La partie a ‚t‚ avort‚e.');
      VaEnXY(3,29);Ecrire('D‚sirez-vous rejouer (O/N) ? ');
      reponse:=readkey;
      rejouer:=upcase(reponse)<>'N'
    Until not rejouer;
    RestoreCRTMode;
    CloseGraph;
END.