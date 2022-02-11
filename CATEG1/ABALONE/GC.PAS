PROCEDURE GC(var quitter:boolean;
             var x,y:integer;
             var data:T_Data;
             VAR f:F_Data);
 Var t:char;
     nb,nba,nbe,i:shortint;
   Begin With Data do
         BEGIN (* With *)
         t:=readkey;
         If t<>#0
         then begin t:=upcase(t);
                    Case t of
                    #27:quitter:=true;
                    'F':data.tour:=data.tour+1;
(* ---------------------------------------------------------------------- *)
'R':begin If CoordPossible(x,y)
          then (* Le curseur souris pointe sur la grille *)
          begin if (data.g[x,y] and oqp <> 0)
                then (* le curseur souris pointe sur 1 boule *)
                begin if (data.g[x,y] and CouleurBoule)=CouleurBoule*(data.tour mod 2)
                      then (* OK: boule du joueur ayant le trait *)
                      begin nb:=0;
                            While CoordPossible(x,y+nb) and (data.g[x,y+nb] and oqp <>0)
                                  do nb:=nb+1;
                            nba:=0;
                            While (nba<nb) and (data.g[x,y+nba] and couleurboule=couleurboule*(data.tour mod 2))
                                  do nba:=nba+1;
                            nbe:=0;
                            While (nba+nbe<nb)and(data.g[x,y+nba+nbe] and couleurboule<>couleurboule*(data.tour mod 2))
                                  do nbe:=nbe+1;
                            If 2*nba<=nb
                            then (* trop faible pour pousser *)
                            begin Message('Vous àtes trop faible pour pousser');
                            end
                            else (* SupÇrioritÇ numÇrique, mais 2 possibilitÇs *)
                            begin if (nba+nbe=nb) and (nba<=3)
                                  then (* on peut pousser: il y a une case vide *)
                                  begin if CoordPossible(x,y+nb)
                                        then
                                        begin Souris(Off);
                                              for i:=nb downto 1 do
                                              begin data.g[x,y+i]:=data.g[x,y+i-1];
                                                    DessineCase(x,y+i);
                                                    PlaceBoule(data.g[x,y+i] and couleurboule,x,y+i);
                                                    SonPoussee;
                                              end;
                                              data.g[x,y]:=0;
                                              DessineCase(x,y);
                                              Souris(On);
                                        end
                                        else
                                        begin If nbe<>0
                                              then
                                              begin Souris(Off);
                                                    SonEject;
                                                    Case CouleurBoule and g[x,y+nb-1] of
                                                         BouleBlanche:BE:=BE+1;
                                                         BouleNoire:NE:=NE+1;
                                                    End;
                                                    for i:=nb-1 downto 1 do
                                                    begin g[x,y+i]:=g[x,y+i-1];
                                                          DessineCase(x,y+i);
                                                          PlaceBoule(g[x,y+i] and couleurboule,x,y+i);
                                                          SonPoussee;
                                                    end;
                                                    g[x,y]:=0;
                                                    DessineCase(x,y);
                                                    Souris(On);
                                              end
                                              else
                                              begin Message('Il est impossible d''Çjecter une boule amie');
                                              end;
                                        end
                                  end
                                  else (* une boule amie gàne derriäre *)
                                  begin Message('Une boule amie gàne.');
                                  end;
                            end;
                      end
                      else (* ERREUR: boule du joueur n'ayant pas le trait *)
                      begin Message('Vous tentez de dÇplacer une boule adverse.');
                      end;
                end
                else (* ERREUR: la souris pointe sur une case vide *)
                begin Message('La fläche pointe sur une case vide.');
                end;
          end
          else (* ERREUR: le curseur pointe hors de la grille *)
          begin Message('La fläche pointe hors de la grille.');
          end;
    end; (* 'R' *)
(* -------------------------------------------------------------------- *)
'V':begin If CoordPossible(x,y)
          then (* Le curseur souris pointe sur la grille *)
          begin if (g[x,y] and oqp <> 0)
                then (* le curseur souris pointe sur 1 boule *)
                begin if (g[x,y] and CouleurBoule)=CouleurBoule*(tour mod 2)
                      then (* OK: boule du joueur ayant le trait *)
                      begin nb:=0;
                            While CoordPossible(x,y-nb) and (g[x,y-nb] and oqp <>0) do nb:=nb+1;
                            nba:=0;
                            While (nba<nb) and (g[x,y-nba] and couleurboule=couleurboule*(tour mod 2)) do nba:=nba+1;
                            nbe:=0;
                            While (nba+nbe<nb) and (g[x,y-nba-nbe] and couleurboule<>couleurboule*(tour mod 2)) do nbe:=nbe+1;
                            If 2*nba<=nb
                            then (* trop faible pour pousser *)
                            begin Message('trop faible');
                            end
                            else (* SupÇrioritÇ numÇrique, mais 2 possibilitÇs *)
                            begin if (nba+nbe=nb) and (nba<=3)
                                  then (* on peut pousser: il y a une case vide *)
                                  begin if CoordPossible(x,y-nb)
                                        then
                                        begin Souris(Off);
                                              for i:=nb downto 1 do
                                              begin g[x,y-i]:=g[x,y-i+1];
                                                    DessineCase(x,y-i);
                                                    PlaceBoule(g[x,y-i] and couleurboule,x,y-i);
                                                    SonPoussee;
                                              end;
                                              g[x,y]:=0;
                                              DessineCase(x,y);
                                              Souris(On);
                                        end
                                        else
                                        begin If nbe<>0
                                              then
                                              begin Souris(Off);
                                                    SonEject;
                                                    Case CouleurBoule and g[x,y-nb+1] of
                                                         BouleBlanche:BE:=BE+1;
                                                         BouleNoire:NE:=NE+1;
                                                    End;
                                                    for i:=nb-1 downto 1 do
                                                    begin g[x,y-i]:=g[x,y-i+1];
                                                          DessineCase(X,Y-I);
                                                          PlaceBoule(g[x,y-i] and couleurboule,x,y-i);
                                                          SonPoussee;
                                                    end;
                                                    g[x,y]:=0;
                                                    DessineCase(x,y);
                                                    Souris(On);
                                              end
                                              else
                                              begin Message('Impossible d''Çjecter une boule amie');
                                              end;
                                        end
                                  end
                                  else (* une boule amie gàne derriäre *)
                                  begin Message('Gàne');
                                  end;
                            end;
                      end
                      else (* ERREUR: boule du joueur n'ayant pas le trait *)
                      begin Message('Boule adverse');
                      end;
                end
                else (* ERREUR: la souris pointe sur une case vide *)
                begin Message('case vide');
                end;
          end
          else (* ERREUR: le curseur pointe hors de la grille *)
          begin Message('hors de la grille');
          end;
    end; (* 'V' *)
(* -------------------------------------------------------------------- *)
'G':begin If CoordPossible(x,y)
          then (* Le curseur souris pointe sur la grille *)
          begin if (g[x,y] and oqp <> 0)
                then (* le curseur souris pointe sur 1 boule *)
                begin if (g[x,y] and CouleurBoule)=CouleurBoule*(tour mod 2)
                      then (* OK: boule du joueur ayant le trait *)
                      begin nb:=0;
                            While CoordPossible(x+nb,y) and (g[x+nb,y] and oqp <>0) do nb:=nb+1;
                            nba:=0;
                            While (nba<nb) and (g[x+nba,y] and couleurboule=couleurboule*(tour mod 2)) do nba:=nba+1;
                            nbe:=0;
                            While (nba+nbe<nb) and (g[x+nba+nbe,y] and couleurboule<>couleurboule*(tour mod 2)) do nbe:=nbe+1;
                            If 2*nba<=nb
                            then (* trop faible pour pousser *)
                            begin Message('trop faible');
                            end
                            else (* SupÇrioritÇ numÇrique, mais 2 possibilitÇs *)
                            begin if (nba+nbe=nb) and (nba<=3)
                                  then (* on peut pousser: il y a une case vide *)
                                  begin if CoordPossible(x+nb,y)
                                        then
                                        begin Souris(Off);
                                              for i:=nb downto 1 do
                                              begin g[x+i,y]:=g[x+i-1,y];
                                                    DessineCase(x+i,y);
                                                    PlaceBoule(g[x+i,y] and couleurboule,x+i,y);
                                                    SonPoussee;
                                              end;
                                              g[x,y]:=0;
                                              DessineCase(x,y);
                                              Souris(On);
                                        end
                                        else
                                        begin If nbe<>0
                                              then
                                              begin Souris(Off);
                                                    SonEject;
                                                    Case CouleurBoule and g[x+nb-1,y] of
                                                         BouleBlanche:BE:=BE+1;
                                                         BouleNoire:NE:=NE+1;
                                                    End;
                                                    for i:=nb-1 downto 1 do
                                                    begin g[x+i,y]:=g[x+i-1,y];
                                                          DessineCase(x+i,y);
                                                          PlaceBoule(g[x+i,y] and couleurboule,x+i,y);
                                                          SonPoussee;
                                                    end;
                                                    g[x,y]:=0;
                                                    DessineCase(x,y);
                                                    Souris(On);
                                              end
                                              else
                                              begin Message('Impossible d''Çjecter une boule amie');
                                              end;
                                        end
                                  end
                                  else (* une boule amie gàne derriäre *)
                                  begin Message('Gàne');
                                  end;
                            end;
                      end
                      else (* ERREUR: boule du joueur n'ayant pas le trait *)
                      begin Message('Boule adverse');
                      end;
                end
                else (* ERREUR: la souris pointe sur une case vide *)
                begin Message('case vide');
                end;
          end
          else (* ERREUR: le curseur pointe hors de la grille *)
          begin OutTextXY(0,400,'hors de la grille');
          end;
    end; (* 'G' *)
(* -------------------------------------------------------------------- *)
'D':begin If CoordPossible(x,y)
          then (* Le curseur souris pointe sur la grille *)
          begin if (g[x,y] and oqp <> 0)
                then (* le curseur souris pointe sur 1 boule *)
                begin if (g[x,y] and CouleurBoule)=CouleurBoule*(tour mod 2)
                      then (* OK: boule du joueur ayant le trait *)
                      begin nb:=0;
                            While CoordPossible(x-nb,y) and (g[x-nb,y] and oqp <>0) do nb:=nb+1;
                            nba:=0;
                            While (nba<nb) and (g[x-nba,y] and couleurboule=couleurboule*(tour mod 2)) do nba:=nba+1;
                            nbe:=0;
                            While (nba+nbe<nb) and (g[x-nba-nbe,y] and couleurboule<>couleurboule*(tour mod 2)) do nbe:=nbe+1;
                            If 2*nba<=nb
                            then (* trop faible pour pousser *)
                            begin Message('trop faible');
                            end
                            else (* SupÇrioritÇ numÇrique, mais 2 possibilitÇs *)
                            begin if (nba+nbe=nb) and (nba<=3)
                                  then (* on peut pousser: il y a une case vide *)
                                  begin if CoordPossible(x-nb,y)
                                        then
                                        begin Souris(Off);
                                              for i:=nb downto 1 do
                                              begin g[x-i,y]:=g[x-i+1,y];
                                                    DessineCase(x-i,y);
                                                    PlaceBoule(g[x-i,y] and couleurboule,x-i,y);
                                                    SonPoussee;
                                              end;
                                              g[x,y]:=0;
                                              DessineCase(x,y);
                                              Souris(On);
                                        end
                                        else
                                        begin If nbe<>0
                                              then
                                              begin Souris(Off);
                                                    SonEject;
                                                    Case CouleurBoule and g[x-nb+1,y] of
                                                         BouleBlanche:BE:=BE+1;
                                                         BouleNoire:NE:=NE+1;
                                                    End;
                                                    for i:=nb-1 downto 1 do
                                                    begin g[x-i,y]:=g[x-i+1,y];
                                                          DessineCase(x-i,y);
                                                          PlaceBoule(g[x-i,y] and couleurboule,x-i,y);
                                                          SonPoussee;
                                                    end;
                                                    g[x,y]:=0;
                                                    DessineCase(x,y);
                                                    Souris(On);
                                              end
                                              else
                                              begin Message('Impossible d''Çjecter une boule amie');
                                              end;
                                        end
                                  end
                                  else (* une boule amie gàne derriäre *)
                                  begin Message('Gàne');
                                  end;
                            end;
                      end
                      else (* ERREUR: boule du joueur n'ayant pas le trait *)
                      begin Message('Boule adverse');
                      end;
                end
                else (* ERREUR: la souris pointe sur une case vide *)
                begin Message('case vide');
                end;
          end
          else (* ERREUR: le curseur pointe hors de la grille *)
          begin Message('hors de la grille');
          end;
    end; (* 'D' *)
(* -------------------------------------------------------------------- *)
'T':begin If CoordPossible(x,y)
          then (* Le curseur souris pointe sur la grille *)
          begin if (g[x,y] and oqp <> 0)
                then (* le curseur souris pointe sur 1 boule *)
                begin if (g[x,y] and CouleurBoule)=CouleurBoule*(tour mod 2)
                      then (* OK: boule du joueur ayant le trait *)
                      begin nb:=0;
                            While CoordPossible(x+nb,y+nb) and (g[x+nb,y+nb] and oqp <>0) do nb:=nb+1;
                            nba:=0;
                            While (nba<nb) and (g[x+nba,y+nba] and couleurboule=couleurboule*(tour mod 2)) do nba:=nba+1;
                            nbe:=0;
                            While (nba+nbe<nb) and (g[x+nba+nbe,y+nba+nbe] and couleurboule<>couleurboule*(tour mod 2))
                                  do nbe:=nbe+1;
                            If 2*nba<=nb
                            then (* trop faible pour pousser *)
                            begin Message('trop faible');
                            end
                            else (* SupÇrioritÇ numÇrique, mais 2 possibilitÇs *)
                            begin if (nba+nbe=nb) and (nba<=3)
                                  then (* on peut pousser: il y a une case vide *)
                                  begin if CoordPossible(x+nb,y+nb)
                                        then
                                        begin Souris(Off);
                                              for i:=nb downto 1 do
                                              begin g[x+i,y+i]:=g[x+i-1,y+i-1];
                                                    DessineCase(x+i,y+i);
                                                    PlaceBoule(g[x+i,y+i] and couleurboule,x+i,y+i);
                                                    SonPoussee;
                                              end;
                                              g[x,y]:=0;
                                              DessineCase(x,y);
                                              Souris(On);
                                        end
                                        else
                                        begin If nbe<>0
                                              then
                                              begin Souris(Off);
                                                    SonEject;
                                                    Case CouleurBoule and g[x+nb-1,y+nb-1] of
                                                         BouleBlanche:BE:=BE+1;
                                                         BouleNoire:NE:=NE+1;
                                                    End;
                                                    for i:=nb-1 downto 1 do
                                                    begin g[x+i,y+i]:=g[x+i-1,y+i-1];
                                                          DessineCase(x+i,y+i);
                                                          PlaceBoule(g[x+i,y+i] and couleurboule,x+i,y+i);
                                                          SonPoussee;
                                                    end;
                                                    g[x,y]:=0;
                                                    DessineCase(x,y);
                                                    Souris(On);
                                              end
                                              else
                                              begin Message('Impossible d''Çjecter une boule amie');
                                              end;
                                        end
                                  end
                                  else (* une boule amie gàne derriäre *)
                                  begin Message('Gàne');
                                  end;
                            end;
                      end
                      else (* ERREUR: boule du joueur n'ayant pas le trait *)
                      begin Message('Boule adverse');
                      end;
                end
                else (* ERREUR: la souris pointe sur une case vide *)
                begin Message('case vide');
                end;
          end
          else (* ERREUR: le curseur pointe hors de la grille *)
          begin Message('hors de la grille');
          end;
    end; (* 'T' *)
(* -------------------------------------------------------------------- *)
'C':begin If CoordPossible(x,y)
          then (* Le curseur souris pointe sur la grille *)
          begin if (g[x,y] and oqp <> 0)
                then (* le curseur souris pointe sur 1 boule *)
                begin if (g[x,y] and CouleurBoule)=CouleurBoule*(tour mod 2)
                      then (* OK: boule du joueur ayant le trait *)
                      begin nb:=0;
                            While CoordPossible(x-nb,y-nb) and (g[x-nb,y-nb] and oqp <>0) do nb:=nb+1;
                            nba:=0;
                            While (nba<nb) and (g[x-nba,y-nba] and couleurboule=couleurboule*(tour mod 2)) do nba:=nba+1;
                            nbe:=0;
                            While (nba+nbe<nb) and (g[x-nba-nbe,y-nba-nbe] and couleurboule<>couleurboule*(tour mod 2))
                                  do nbe:=nbe+1;
                            If 2*nba<=nb
                            then (* trop faible pour pousser *)
                            begin Message('trop faible');
                            end
                            else (* SupÇrioritÇ numÇrique, mais 2 possibilitÇs *)
                            begin if (nba+nbe=nb) and (nba<=3)
                                  then (* on peut pousser: il y a une case vide *)
                                  begin if CoordPossible(x-nb,y-nb)
                                        then
                                        begin Souris(Off);
                                              for i:=nb downto 1 do
                                              begin g[x-i,y-i]:=g[x-i+1,y-i+1];
                                                    DessineCase(x-i,y-i);
                                                    PlaceBoule(g[x-i,y-i] and couleurboule,x-i,y-i);
                                                    SonPoussee;
                                              end;
                                              g[x,y]:=0;
                                              DessineCase(x,y);
                                              Souris(On);
                                        end
                                        else
                                        begin If nbe<>0
                                              then
                                              begin Souris(Off);
                                                    SonEject;
                                                    Case CouleurBoule and g[x-nb+1,y-nb+-1] of
                                                         BouleBlanche:BE:=BE+1;
                                                         BouleNoire:NE:=NE+1;
                                                    End;
                                                    for i:=nb-1 downto 1 do
                                                    begin g[x-i,y-i]:=g[x-i+1,y-i+1];
                                                          DessineCase(x-i,y-i);
                                                          PlaceBoule(g[x-i,y-i] and couleurboule,x-i,y-i);
                                                          SonPoussee;
                                                    end;
                                                    g[x,y]:=0;
                                                    DessineCase(x,y);
                                                    Souris(On);
                                              end
                                              else
                                              begin Message('Impossible d''Çjecter une boule amie');
                                              end;
                                        end
                                  end
                                  else (* une boule amie gàne derriäre *)
                                  begin Message('Gàne');
                                  end;
                            end;
                      end
                      else (* ERREUR: boule du joueur n'ayant pas le trait *)
                      begin Message('Boule adverse');
                      end;
                end
                else (* ERREUR: la souris pointe sur une case vide *)
                begin Message('case vide');
                end;
          end
          else (* ERREUR: le curseur pointe hors de la grille *)
          begin Message('hors de la grille');
          end;
    end; (* 'C' *)
(* -------------------------------------------------------------------- *)
                    End;(* DU CASE *)
              end
         else begin t:=readkey;
                    Case t of
                    #60:(* Sauvegarder la position actuelle *)
                        begin Sauvegarder(data,f);
                        end;
                    #61:(* Charger une position *)
                        begin Charger(data,f);
                              Souris(Off);
                              DessineGrille;
                              PlaceBoules(data.g);
                              Souris(On);
                        end;
                    End;
              end;
         END; (* With *)
   End;  (* GC *)