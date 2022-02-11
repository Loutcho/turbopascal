(* ------------------------------------------------------------------- *)
(* Les proc‚dures suivantes modifient si c'est possible la position du *)
(* bloc, sans sortie … l'‚cran: utiliser DessinerBloc avant et aprŠs.  *)
(* ------------------------------------------------------------------- *)

PROCEDURE Gauche(var x:shortint;y:shortint;VAR t:tableau;VAR bloc:T_bloc);
 Var i,xo,yo:byte;
     res,q:boolean;
   Begin Res:=true; i:=1;
         While res and (i<=4) do
             begin xo:=bloc[i].x;
                   q:=(x+xo)>1;
                   res:=res and q;
                   If q then begin yo:=bloc[i].y;
                                   q:=t[x+xo-1,y+yo]=0;
                                   res:=res and q;
                             end;
                   i:=i+1;
             end;
         If res then x:=x-1;
   End; (* Gauche *)

PROCEDURE Droite(var x:shortint;y:shortint;VAR t:tableau;
                 VAR bloc:T_bloc;cols:byte);
 Var i,xo,yo:byte;
     res,q:boolean;
   Begin Res:=true; i:=1;
         While res and (i<=4) do
             begin xo:=bloc[i].x;
                   q:=(x+xo)<Cols;
                   res:=res and q;
                   If q then begin yo:=bloc[i].y;
                                   q:=t[x+xo+1,y+yo]=0;
                                   res:=res and q;
                             end;
                   i:=i+1;
             end;
         If res then x:=x+1;
   End; (* Droite *)

PROCEDURE FaireDescendreBloc(VAR t:tableau;x:shortint;var y:shortint;
                             VAR bloc:T_bloc;var di:boolean;
                             niv,ligs:byte);
 Var i,xo,yo:shortint;
     res,q:boolean;
   Begin
         Res:=true; i:=1;
         While res and (i<=4) do
             begin yo:=bloc[i].y;
                   q:=(y+yo)<Ligs;
                   res:=res and q;
                   If q then begin
                                   xo:=bloc[i].x;
                                   q:=t[x+xo,y+yo+1]=0;
                                   res:=res and q;
                             end;
                   i:=i+1;
             end;
         di:=not res;
         If not di
         then y:=y+1;
   End; (* FaireDescendreBloc *)

PROCEDURE EnvoiAuFond(VAR t:tableau;x:shortint;var y:shortint;VAR bloc:T_bloc;
                      niv,ligs:byte;var score:longint);
 Var di:boolean;
   Begin Repeat
         FaireDescendreBloc(t,x,y,bloc,di,(niv*2)+1,ligs);
         Until di;  (* di signifie "Descente Impossible" *)
   End; (* EnvoiAuFond *)

PROCEDURE Transforme(VAR bloc:T_bloc;n:byte);
 Var i,tmp:byte;
   Begin If n=3 then
         For i:=1 to 4 do
             begin tmp:=bloc[i].x;
                   bloc[i].x:=bloc[i].y;
                   bloc[i].y:=2-tmp;
             end;
         If n=4 then
         For i:=1 to 4 do
             begin tmp:=bloc[i].x;
                   bloc[i].x:=bloc[i].y;
                   bloc[i].y:=4-tmp;
             end;
   End; (* Transforme *)

(* Les deux fonctions suivantes renvoient un bool‚en contr“lant la *)
(* possibilit‚ d'une rotation: existence et vacuit‚ des cases images *)

FUNCTION ImageDefinie(x,y,n:byte;VAR p:T_point;cols,ligs:byte):boolean;
 Var b:boolean;
   Begin b:=true;
         If n=3 then
            if (x+p.y<1) or (x+p.y>Cols)
            or (y+2-p.x<1) or (y+2-p.x>Ligs)
            then b:=false;
         If n=4 then
            if (x+p.y<1) or (x+p.y>Cols)
            or (y+4-p.x<1) or (y+4-p.x>Ligs)
            then b:=false;
         ImageDefinie:=b;
   End; (* ImageDefinie *)

FUNCTION ImageLibre(VAR t:tableau;x,y,n:byte;p:T_point):boolean;
 Var b:boolean;
     tmp:byte;
   Begin b:=true;
         If n=3 then
            begin tmp:=p.x;
                  p.x:=p.y;
                  p.y:=2-tmp;
                  If t[x+p.x,y+p.y]<>0 then b:=false;
            end;
         If n=4 then
            begin tmp:=p.x;
                  p.x:=p.y;
                  p.y:=4-tmp;
                  If t[x+p.x,y+p.y]<>0 then b:=false;
            end;
         ImageLibre:=b;
   End; (* ImageLibre *)

PROCEDURE Rotation(VAR t:Tableau;x,y,num:byte;var bloc:T_bloc;
                   cols,ligs:byte);
 Var i,cotes:byte;
     RotaPos:boolean;
   Begin Case num of
              3..7:begin Cotes:=3;RotaPos:=true end;
              2:begin Cotes:=0;RotaPos:=false end;
         Else begin Cotes:=4;RotaPos:=true end;
         End;
         If RotaPos then For i:=1 to 4 do
            RotaPos:=RotaPos and ImageDefinie(x,y,cotes,bloc[i],cols,ligs);
         If RotaPos then For i:=1 to 4 do
            RotaPos:=RotaPos and ImageLibre(t,x,y,cotes,bloc[i]);
         If RotaPos then Transforme(bloc,Cotes);
   End;  (* Rotation *)

PROCEDURE FaireUnePause;
   Begin VideClavier;
         TextAttr:=LightGray; VaEnXY(1,1); Ecrire('PAUSE');
         Attendre;
         VideClavier;
   End; (* FaireUnePause *)

FUNCTION FonctionDe(nivo:byte):word;
   Begin FonctionDe:=sqr((NivMax-Nivo)*10);
   End; (* FonctionDe *)

PROCEDURE Sedimenter(var t:tableau;x,y,c:shortint;VAR bloc:T_bloc);
 Var i:byte;
   Begin For i:=1 to 4 do t[x+bloc[i].x,y+bloc[i].y]:=c;
   End; (* Sedimenter *)

PROCEDURE GereClavier(VAR tab:tableau;var x,y,numero:shortint;
                      VAR bloc:T_bloc;
                      var son:boolean;
                      var niv:byte;
                      var score:longint;
                      var interr,DescImp:boolean;
                      var compteurMax,compteur:word;
                      cols,ligs:byte;
                      nblignes:integer;
                      var prevus:T_Prevus;var NbBlocs:byte;
                      var perdu:boolean;
                      handicap:boolean);
 Var t:char;
     bo:boolean;
   Begin t:=readkey;
         If t<>#0 then Case upcase(t) of
                            'S':begin son:=not son;
                                      AfficheRenseig(
                                         niv,son,NbLignes,score,
                                         Prevus,NbBlocs);
                                end;
                            'P':begin CacheContenu(cols,ligs,1);
                                      FaireUnePause;
                                      VoirContenu(tab,cols,ligs);
                                      DessinerBloc(x,y,numero,bloc);
                                end;
                            'B':begin if NbBlocs<NbPrevus
                                      then NbBlocs:=NbBlocs+1
                                      else NbBlocs:=0;
                                      AfficheRenseig(
                                         niv,son,NbLignes,score,
                                         Prevus,NbBlocs);
                                end;
                            '+':If niv<nivmax then
                                         begin if son then SignalNiv;
                                               niv:=niv+1;
                                               CompteurMax:=FonctionDe(Niv);
                                               AfficheRenseig(
                                                niv,son,NbLignes,score,
                                                Prevus,NbBlocs);
                                         end;
                            'W':begin Sedimenter(tab,x,y,numero,bloc);
                                      DetruireLignes(tab,NbLignes,Score,Niv,
                                       cols,ligs,son,numero);
                               If (NbLignes>=(Niv+1)*10) and (niv<NivMax)
                                  then begin niv:=niv+1;
                                             Score:=Score+100;
                                             If son then SignalNiv;
                                       end;
                               Score:=Score-(NivMax-Niv)*NbBlocs;
                               ChoisirBloc(tab,prevus,bloc,x,y,numero,cols,Perdu);
                               M_A_J_Prevus(prevus);
                                end;
                            '4':begin Dessinerbloc(x,y,0,bloc);
                                      gauche(x,y,tab,bloc);
                                      DessinerBloc(x,y,numero,bloc);
                                end;
                            '5':begin DessinerBloc(x,y,0,bloc);
                                      Rotation(tab,x,y,numero,bloc,
                                               cols,ligs);
                                      DessinerBloc(x,y,numero,bloc);
                                end;
                            '6':begin Dessinerbloc(x,y,0,bloc);
                                      droite(x,y,tab,bloc,cols);
                                      DessinerBloc(x,y,numero,bloc);
                                end;
                            ' ','2':begin DessinerBloc(x,y,0,bloc);
                                          EnvoiAuFond(tab,x,y,bloc,
                                                      niv,ligs,score);
                                          Compteur:=compteurMax;
                                          DessinerBloc(x,y,numero,bloc);
                                    end;
                            '8':Compteur:=compteurMax;
                            #27:Interr:=true;
                       End
                  else begin t:=readkey;
                             Case t of
                                  #75:begin DessinerBloc(x,y,0,bloc);
                                            gauche(x,y,tab,bloc);
                                            DessinerBloc(x,y,numero,bloc);
                                      end;
                                  #77:begin DessinerBloc(x,y,0,bloc);
                                            droite(x,y,tab,bloc,cols);
                                            DessinerBloc(x,y,numero,bloc);
                                      end;
                                  #80:begin DessinerBloc(x,y,0,bloc);
                                            EnvoiAuFond(tab,x,y,bloc,
                                                        niv,ligs,score);
                                            Compteur:=CompteurMax;
                                            DessinerBloc(x,y,numero,bloc);
                                      end;
                                  #72:begin DessinerBloc(x,y,0,bloc);
                                            Rotation(tab,x,y,numero,bloc,
                                                     cols,ligs);
                                            DessinerBloc(x,y,numero,bloc);
                                      end;
                             End; {du case}
                       end;
   End; (* GereClavier *)

PROCEDURE Jouer(VAR F:F_Enreg;son,handicap:boolean;niv,cols,ligs,NbPrevus:byte);
 Var Perdu,Interr:boolean;
     Compteur,CompteurMax:word;
     DescImp,Pause:boolean;
     x,y,numero:shortint;
     tab:tableau;
     NbLignes:integer;
     bloc:T_bloc;
     Score:Longint;
     Prevus:T_Prevus;
   Begin  ModeVideo($1); ActivePolice(police); Curseur(7,0);
          DessineGrille(cols,ligs);
          InitGrille(tab,cols,ligs,handicap); NbLignes:=0; Score:=0;
          VoirContenu(tab,cols,ligs);
          Interr:=false; Pause:=false;
          InitPrevus(Prevus);
          ChoisirBloc(tab,prevus,bloc,x,y,numero,cols,perdu);
          M_A_J_PRevus(prevus);
          While not Perdu and not Interr do
                begin AfficheRenseig(niv,son,NbLignes,score,Prevus,NbBlocs);
                      DessinerBloc(x,y,numero,bloc);
                      DescImp:=false;
                      Repeat compteur:=0;
                             repeat compteur:=compteur+1;
                                    compteurMax:=FonctionDe(Niv);
                                    if keypressed then
                                    repeat GereClavier(tab,X,Y,numero,bloc,
                                                son,niv,score,Interr,
                                                DescImp,
                                                compteurMax,compteur,
                                                cols,ligs,nblignes,
                                                prevus,NbBlocs,
                                                perdu,handicap);
                                    until not keypressed ;
                             until (compteur>=CompteurMax) or Interr;
                             DessinerBloc(x,y,0,bloc);
                             FaireDescendreBloc(tab,X,Y,bloc,
                                                DescImp,niv,ligs);
                             DessinerBloc(x,y,numero,bloc);
                             AfficheRenseig(niv,son,NbLignes,score,Prevus,NbBlocs);
                      Until DescImp or Interr;
                      If not Interr then
                         begin Sedimenter(tab,x,y,numero,bloc);
                               DetruireLignes(tab,NbLignes,Score,Niv,
                                       cols,ligs,son,numero);
                               If (NbLignes>=(Niv+1)*10) and (niv<NivMax)
                                  then begin niv:=niv+1;
                                             Score:=Score+100;
                                             If son then SignalNiv;
                                       end;
                               Score:=Score-NbBlocs+3;
                               ChoisirBloc(tab,prevus,bloc,x,y,numero,cols,Perdu);
                               M_A_J_Prevus(prevus);
                         end; (* Du If not Interr *)
                end;  (* Du While not Perdu and nor Interr *)
          AfficheRenseig(niv,son,NbLignes,score,Prevus,NbBlocs);
          If Perdu
          Then begin DessinerBloc(x,y,numero,bloc);
                     If son then SignalFin
                            else Delay(1000);
                     TestScores(F,score,nblignes);
               end;
   End;   (* Jouer *)