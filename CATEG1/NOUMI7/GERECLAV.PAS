PROCEDURE AfficheMenu(son,handicap:boolean;
                      niveau,cols,ligs:byte;NbBlocs:byte);
 Var i,j:byte;
   Begin ModeVideo($1); ActivePolice(police);
         Curseur(7,0);
         TextAttr:=10;
         VaEnXY(8,2);Ecrire('ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
         VaEnXY(8,3);Ecrire('³      NOUMI  VII      ³');
         VaEnXY(8,4);Ecrire('³   par Luc Rousseau   ³');
         VaEnXY(8,5);Ecrire('ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
         TextAttr:=LightCyan;
         VaEnXY(1,09);Ecrire(     'ÖÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·');
         For i:=10 to 19 do
         begin
          VaEnXY(1,i);Ecrire(     'º                          º');
         end;
         VaEnXY(1,20);Ecrire(     'ÓÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ½');

         TextAttr:=White;
         VaEnXY(3,10); Ecrire('Jouer             Entr‚e');
         VaEnXY(3,11); Ecrire('Son                    S');
         VaEnXY(3,12); Ecrire('Handicap               H');
         VaEnXY(3,14); Ecrire('Niveau initial       + -');
         VaEnXY(3,15); Ecrire('Liste                  L');
         VaEnXY(3,16); Ecrire('Colonnes             '+#27+' '+#26);
         VaEnXY(3,17); Ecrire('Lignes               '+#24+' '+#25);
         VaEnXY(3,18); Ecrire('Pr‚visions             B');
         VaEnXY(3,19); Ecrire('Quitter            Echap');
         TextAttr:=15;
         VaEnXY(30,11);Ecrire(Etat(son));
         VaEnXY(30,12);Ecrire(Etat(handicap));
         VaEnXY(30,14);Ecrire(cat(niveau)+'  ');
         VaEnXY(30,16);Ecrire(cat(cols));
         VaEnXY(30,17);Ecrire(cat(ligs));
         VaEnXY(30,18);Ecrire(cat(NbBlocs));
   End;

PROCEDURE IncCols(var cols:byte);
   Begin If Cols<ColsMax
            then Cols:=Cols+1
            else Cols:=ColsMin;
          VaEnXY(30,16);Ecrire(cat(cols)+'  ');
   End;

PROCEDURE DecCols(var cols:byte);
   Begin If cols>ColsMin
            then cols:=cols-1
            else cols:=ColsMax;
         VaEnXY(30,16);Ecrire(cat(cols)+'  ');
   End;

PROCEDURE IncLigs(var ligs:byte);
   Begin If Ligs<LigsMax
            then Ligs:=Ligs+1
            else Ligs:=LigsMin;
          VaEnXY(30,17);Ecrire(cat(ligs)+'  ');
   End;

PROCEDURE DecLigs(var ligs:byte);
   Begin If ligs>LigsMin
            then ligs:=ligs-1
            else ligs:=ligsMax;
         VaEnXY(30,17);Ecrire(cat(ligs)+'  ');
   End;

PROCEDURE GC(var F:F_Enreg;
             var son,Handicap:boolean;
             var niv,cols,ligs,NbBlocs:byte;
             var q:boolean);
 Var t:char;
   Begin t:=readkey;
         if t<>#0 then Case upcase(t) of
                            '+': begin If niv<NivMax then niv:=niv+1
                                                     else niv:=NivMin;
                                       VaEnXY(30,14);Ecrire(cat(niv)+' ');
                                 end;
                            '-': begin If niv>NivMin then niv:=niv-1
                                                     else niv:=NivMax;
                                       VaEnXY(30,14);Ecrire(cat(niv)+' ');
                                 end;
                            'L': begin AfficheScores(F,-1);
                                       Attendre;VideClavier;
                                       AfficheMenu(son,handicap,niveau,Cols,Ligs,NbBlocs);
                                 end;
                            'S': begin son:=not son;
                                       VaEnXY(30,11);Ecrire(Etat(son));
                                 end;
                            'H': begin handicap:=not handicap;
                                       VaEnXY(30,12);Ecrire(Etat(handicap));
                                       Assign(f,DetermineNomFic(cols,ligs,handicap));
                                 end;
                            #13: begin jouer(F,son,handicap,
                                             niv,cols,ligs,NbBlocs);
                                       AfficheMenu(son,handicap,niv,cols,ligs,nbblocs);
                                 end;
                            'B':begin if NbBlocs<NbPrevus
                                      then NbBlocs:=NbBlocs+1
                                      else NbBlocs:=0;
                                      VaEnXY(30,18);Ecrire(cat(NbBlocs));
                                end;
                            #25: Reecrire(F);
                            #27: q:=true;
                       End {du case}
                  else begin t:=readkey;
                             Case t of
                                  #75: begin DecCols(cols);
                                             Assign(f,DetermineNomFic(cols,ligs,handicap));
                                       end;
                                  #77: begin IncCols(cols);
                                             Assign(f,DetermineNomFic(cols,ligs,handicap));
                                       end;
                                  #72: begin DecLigs(ligs);
                                             Assign(f,DetermineNomFic(cols,ligs,handicap));
                                       end;
                                  #80: begin IncLigs(ligs);
                                             Assign(f,DetermineNomFic(cols,ligs,handicap));
                                       end;
                             End;
                       end;
   End;   (* GC *)