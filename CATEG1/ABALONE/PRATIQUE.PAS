PROCEDURE Attendre;
   Begin While not keypressed do;
   End;

PROCEDURE VideClavier;
 Var t:char;
   Begin While keypressed do t:=readkey;
   End;

FUNCTION Cat(n:integer):string;
 Var s:string;
   Begin Str(n,s);
         cat:=s;
   End;

FUNCTION CoordPossible(x,y:shortint):boolean;
 Var q:boolean;
   Begin q:=     (x>=-4) and (x<=4)
             and (y>=-4) and (y<=4)
             and (y>=x-4) and (y<=x+4);
         CoordPossible:=q;
   End;  (* CoordPossible *)

PROCEDURE InitGrille(var g:T_Grille);
 Var i,j:shortint;
   Begin For i:=-4 to 4 do
         For j:=-4 to 4 do
         begin g[i,j]:=0;
               If not CoordPossible(i,j) then inc(g[i,j],HorsGrille);
         end;
         For i:=-4 to 0 do
         begin inc(g[i,-4],Oqp+BouleNoire);
               inc(g[-i,4],Oqp+BouleBlanche);
         end;
         For i:=-4 to 1 do
         begin inc(g[i,-3],Oqp+BouleNoire);
               inc(g[-i,3],Oqp+BouleBlanche);
         end;
         For i:=-2 to 0 do
         begin inc(g[i,-2],Oqp+BouleNoire);
               inc(g[-i,2],Oqp+BouleBlanche);
         end;
   End;  (* InitGrille *)

PROCEDURE ConvertirCoord1(var x,y:integer); (* StrucData->Graphic *)
   Begin x:=320+round(50*(x-y/2));
         y:=240-50*y;
   End;

PROCEDURE ConvertirCoord2(var x,y:integer); (* Graphic->StrucData *)
   Begin y:=round((240-y)/50);
         x:=round((x-320)/50+y/2);
   End;

PROCEDURE Saisir(var s:string);
 Var valider:boolean;
     t:char;
   Begin SetFillStyle(SolidFill,Green);
         SetColor(White);
         Valider:=false;
         s:='';
         While not valider do
         begin Bar(0,465,500,479);
               OutTextXY(10,470,s);
               Attendre;
               t:=readkey;
               If t<>#0
               then begin t:=upcase(t);
                          Case t of
                          #27:s:='';
                          #13:valider:=true;
                          'A'..'Z','.','0'..'9':s:=s+t;
                          #8:delete(s,length(s),1);
                          End;
                    end
               else begin t:=readkey;
                    end;
         end;
         SetFillStyle(SolidFill,Black);
         Bar(0,465,500,479);
   End;