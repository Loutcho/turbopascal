PROCEDURE ModeGraphique(var Gd,Gm:integer);
   Begin Gd:=VGA;
         Gm:=VGAHI;
         InitGraph(Gd,Gm,'');
         If GraphResult<>GrOk then Halt;
   End;   (* ModeGraphique *)

PROCEDURE Ligne(x1,y1,x2,y2:integer);
   Begin ConvertirCoord1(x1,y1);
         ConvertirCoord1(x2,y2);
         Line(x1,y1,x2,y2);
   End;

PROCEDURE DessineCase(x,y:integer);
   Begin SetColor(Brown);
         SetFillStyle(SolidFill,Black);
         ConvertirCoord1(x,y);
         Circle(x,y,20);
         FloodFill(x,y,Brown);
   End;   (* DessineCase *)

PROCEDURE DessineGrille;
 Var i,j:shortint;
   Begin SetColor(Yellow);
         SetLineStyle(SolidLn,0,ThickWidth);
         For i:=0 to 4 do
         begin Ligne(-4+i,i,4,i);
               Ligne(4-i,-i,-4,-i);
               Ligne(i,4,i,-4+i);
               Ligne(-i,-4,-i,4-i);
               Ligne(i-4,-4,4,4-i);
               Ligne(-i+4,4,-4,-4+i);
         end;
         SetLineStyle(SolidLn,0,NormWidth);
         For i:=-4 to 4 do
         For j:=-4 to 4 do
         If CoordPossible(i,j) then DessineCase(i,j);
   End;  (* DessineGrille *)

PROCEDURE AfficheCadre;
   Begin SetLineStyle(SolidLn,0,NormWidth);
         SetColor(White);
         Rectangle(80,0,559,461);
         OutTextXY(0,160,'de jouer.');
   End;

PROCEDURE PlaceBoule(Coul:Byte;x,y:integer);
   Begin ConvertirCoord1(x,y);
         Case Coul of
              BouleNoire  :begin SetColor(LightRed);
                                 SetFillStyle(SolidFill,LightGray);
                                 Circle(x,y,20);
                                 FloodFill(x,y,LightRed);
                           end;
              BouleBlanche:begin SetColor(LightGray);
                                 SetFillStyle(SolidFill,White);
                                 Circle(x,y,20);
                                 FloodFill(x,y,LightGray);
                           end;
         End;
   End;   (* PlaceBoule *)

PROCEDURE PlaceBouleS(VAR g:T_Grille);
 Var i,j:shortint;
   Begin For i:=-4 to 4 do
         For j:=-4 to 4 do
         if (g[i,j] and HorsGrille=0)
         then if (g[i,j] and Oqp<>0)
              then PlaceBoule(g[i,j] and CouleurBoule,i,j);
   End;

PROCEDURE InitCouleurs;
   Begin SetRGBPalette(EGABlack,36,12,36);
         SetRGBPalette(EGALightGray,0,0,0);
         SetRGBPalette(EGAWhite,63,63,63);
         SetRGBPalette(EGABrown,38,14,38);
         SetRGBPalette(EGALightRed,63,0,0);
   End;

PROCEDURE AfficheRenseig(VAR Data:T_Data);
 Var i:shortint;
   Begin SetColor(LightRed);
         SetTextStyle(DefaultFont,VertDir,3);
         OutTextXY(600,130,'BOULES ');
         OutTextXY(630,130,'EJECTEES');
         SetTextStyle(DefaultFont,HorizDir,3);
         SetFillStyle(1,0);
         Bar(560,0,639,50);
         Bar(560,430,639,479);
         SetColor(White); OutTextXY(600,10,cat(data.be));
         SetColor(LightGray); OutTextXY(600,450,cat(data.ne));
         SetTextStyle(DefaultFont,HorizDir,1);
         SetColor(White);
         Bar(0,100,79,150);
         Case data.tour mod 2 of
         0:OutTextXY(0,125,'Aux Noirs');
         1:OutTextXY(0,125,'Aux Blancs');
         End;
   End;  (* AfficheRenseig *)

PROCEDURE Message(s:string);
   Begin Souris(Off);
         SetTextStyle(DefaultFont,HorizDir,1);
         SetColor(White);
         SetFillStyle(SolidFill,Red);
         Bar(80,465,560,479);
         OutTextXY(80,470,s);
         Attendre;
         VideClavier;
         SetFillStyle(SolidFill,Black);
         Bar(80,465,560,479);
         Souris(On);
   End;