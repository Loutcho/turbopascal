PROCEDURE DessineGrille(cols,ligs:byte);
 Var i:byte;
   Begin TextAttr:=DarkGray;
         VaEnXY(0,0); Ecryre('˛');
         VaEnXY(0,ligs+1); Ecryre('˛');
         VaEnXY(cols+1,ligs+1); Ecryre('˛');
         VaEnXY(cols+1,0); Ecryre('˛');
         VaEnXY(1,0);
         Ecrire(ChaineDe('‹',cols));
         VaEnXY(1,ligs+1);
         Ecrire(ChaineDe('ﬂ',cols));
         For i:=1 to ligs do
         begin VaEnXY(0,i); Ecryre('ﬁ');
               VaEnXY(cols+1,i); Ecryre('›');
         end;
   End;

PROCEDURE InitGrille(var t:tableau;cols,ligs:byte;handicap:boolean);
 Var i,j:byte;
   Begin For i:=1 to Cols do
         For j:=1 to Ligs do
         if not handicap
            then t[i,j]:=0
            else if j>(ligs div 2)+1
                    then t[i,j]:=random(2)*(random(7)+1)
                    else t[i,j]:=0;
   End;

PROCEDURE InitPrevus(var prevus:T_Prevus);
 Var i:byte;
   Begin For i:=1 to NbPrevus do prevus[i]:=random(7)+1;
   End;

PROCEDURE M_a_j_Prevus(var prevus:T_Prevus);
 Var i:byte;
   Begin For i:=1 to NbPrevus-1 do
         prevus[i]:=prevus[i+1];
         prevus[NbPrevus]:=random(7)+1;
   End;

PROCEDURE ObtBloc(numero:byte;var bloc:T_Bloc);
   Begin Case numero of
              {‹‹‹‹} 1:  begin bloc[1].x:=0; bloc[1].y:=1;
                               bloc[2].x:=1; bloc[2].y:=1;
                               bloc[3].x:=2; bloc[3].y:=1;
                               bloc[4].x:=3; bloc[4].y:=1;
                         end;

              {‹‹}   2: begin bloc[1].x:=0;   bloc[1].y:=0;
              {ﬂﬂ}            bloc[2].x:=0;   bloc[2].y:=1;
                              bloc[3].x:=1;   bloc[3].y:=1;
                              bloc[4].x:=1;   bloc[4].y:=0;
                        end;
              { ‹ }  3: begin bloc[1].x:=0;   bloc[1].y:=1;
              {ﬂﬂﬂ}           bloc[2].x:=1;   bloc[2].y:=1;
                              bloc[3].x:=1;   bloc[3].y:=0;
                              bloc[4].x:=2;   bloc[4].y:=1;
                        end;
              { ‹‹}  4: begin bloc[1].x:=0;   bloc[1].y:=1;
              {ﬂﬂ }           bloc[2].x:=1;   bloc[2].y:=1;
                              bloc[3].x:=1;   bloc[3].y:=0;
                              bloc[4].x:=2;   bloc[4].y:=0;
                        end;
              {‹‹ }  5: begin bloc[1].x:=0;   bloc[1].y:=0;
              { ﬂﬂ}           bloc[2].x:=1;   bloc[2].y:=0;
                              bloc[3].x:=1;   bloc[3].y:=1;
                              bloc[4].x:=2;   bloc[4].y:=1;
                        end;
              {‹  }  6: begin bloc[1].x:=0;   bloc[1].y:=0;
              {ﬂﬂﬂ}           bloc[2].x:=0;   bloc[2].y:=1;
                              bloc[3].x:=1;   bloc[3].y:=1;
                              bloc[4].x:=2;   bloc[4].y:=1;
                        end;
              {  ‹}  7: begin bloc[1].x:=0;   bloc[1].y:=1;
              {ﬂﬂﬂ}           bloc[2].x:=1;   bloc[2].y:=1;
                              bloc[3].x:=2;   bloc[3].y:=1;
                              bloc[4].x:=2;   bloc[4].y:=0;
                        end;
         End;   {du case}
   End; (* ObtBloc *)

PROCEDURE ChoisirBloc(VAR t:tableau;VAR prevus:T_PRevus;
                      var bloc:T_bloc;
                      var x,y,numero:shortint;
                      cols:byte;var p:boolean);
 Var i:byte;
   Begin numero:=prevus[1];
         ObtBloc(numero,bloc);
         x:=Cols Div 2;  y:=1; p:=false;
         For i:=1 to 4 do p:=p or (t[x+bloc[i].x,y+bloc[i].y]<>0);
   End; (* ChoisirBloc *)

PROCEDURE Place(x,y,c:byte);
   Begin VaEnXY(x,y);
         TextAttr:=c;
         Ecryre('€');
   End; (* Place *)

PROCEDURE DessinerBloc(x,y,c:byte;VAR bloc:T_bloc);
 Var i:byte;
   Begin For i:=1 to 4 do Place(x+bloc[i].x,y+bloc[i].y,c);
   End; (* DessinerBloc *)

PROCEDURE VoirContenu(VAR t:tableau;cols,ligs:byte);
 Var i,j:byte;
   Begin For i:=1 to Cols do For j:=1 to Ligs do Place(i,j,t[i,j]);
   End;

PROCEDURE CacheContenu(cols,ligs:byte;Num:byte);
 Var i,j:byte;
   Begin For i:=1 to Cols do For j:=1 to Ligs do Place(i,j,0);
   End;

FUNCTION Somme(VAR t:tableau;y:byte):byte;
 Var i,accu:byte;
   Begin accu:=0;
         For i:=1 to Cols do if t[i,y]<>0 then accu:=accu+1;
         Somme:=accu;
   End;

PROCEDURE Rabaisser(var t:tableau;Cols,Lig:byte;son:boolean); (* sans S Ö lig *)
 Var i,j:byte;
   Begin If son
         Then SignalLig;
         For i:=1 to Cols do For j:=Lig downto 2 do
             begin t[i,j]:=t[i,j-1];
                   Place(i,j,t[i,j]);
             end;
         For i:=1 to Cols do
             begin t[i,1]:=0;
                   Place(i,1,0);
             end;
   End;

PROCEDURE DetruireLignes(var t:tableau;var nbl:integer;var score:longint;
                         niv,cols,ligs:byte;son:boolean;NumCarre:byte);
 Var Lig:byte;
   Begin
         Lig:=Ligs;
         While Lig>1 do
               If Somme(t,Lig)=Cols then begin Rabaisser(t,Cols,Lig,son);
                                               Score:=Score+niv+1;
                                               Inc(Nbl,1);
                                         end
                                    else Lig:=Lig-1;
         If Somme(t,ligs)=0
         Then begin If son then SignalVide;
                    score:=score*2;
              end;
   End;

PROCEDURE AfficheRenseig(niv:byte;son:boolean;nbl:integer;
                         score:longint;Prevus:T_Prevus;NbBlocs:byte);
 Var bloc:T_Bloc;
     i:byte;
   Begin TextAttr:=LightGray;
         VaEnXY(20,1); Ecrire('Lignes : ');  Ecrire(cat(nbl));
         VaEnXY(20,2); Ecrire('Son    : ');  Ecrire(etat(son));
         VaEnXY(20,3); Ecrire('Niveau : ');  Ecrire(cat(niv));
         TextAttr:=White;
         VaEnXY(20,4); Ecrire('Score  : ');  Ecrire(cat(score));
         For i:=1 to 3 do
         If i<=NbBlocs
         Then begin ObtBloc(prevus[i],Bloc);
                    DessinerBloc(20+5*(i-1),20,prevus[i],Bloc);
              end
         Else; {on verra plus tard}
   End;