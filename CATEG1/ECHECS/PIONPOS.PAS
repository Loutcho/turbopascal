FUNCTION PionPossible(x1,y1,x2,y2,aki:shortint;var special:char):boolean;
 Var iy:shortint;
     f:boolean;
   Begin f:=false;
         If g[x1,y1] and couleur = blanc
         Then iy:=1 Else iy:=-1;
         If (g[x2,y2] and couleur = ennemi(aki))
            or (g[x2,y2] and enpassant <> 0)
         Then
              begin
                f:=(abs(x2-x1)=1) and (y2-y1=iy);
                if g[x2,y2] and enpassant <> 0
                then
                  special:='E';
              end
         Else
              begin f:=(x2-x1)=0;
                    If f
                    Then Case iy*(y2-y1) of
                           1:
                             f:=true;
                           2:
                             begin
                               f:=(g[x1,y1+iy]=rien) and
                                  ( ((y1=1) and (aki=blanc))
                                    or ((y1=6) and (aki=noir)));
                               if f then special:='e';
                             end;
                           Else f:=false;
                         End;
              end;
         If f
         Then if (((aki=blanc) and (y2=7)) or ((aki=noir) and (y2=0)))
              then repeat special:=readkey;
                   until upcase(special) in ['C','F','T','D'];
         PionPossible:=f;
   End;