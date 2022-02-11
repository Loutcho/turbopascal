PROCEDURE ModeGraphique;
 Var Gd,Gm:integer;
   Begin Gd:=VGA; Gm:=VGAHI;
         InitGraph(Gd,Gm,'');
   End;

FUNCTION CouleurCase(x,y:shortint):byte;
   Begin Case (x+y) mod 2 of
         0: couleurCase:=noir;
         1: couleurCase:=blanc;
         End;
   End;

FUNCTION XX(x:shortint):integer;
   Begin xx:=MargeX+CoteX*x;
   End;

FUNCTION YY(y:shortint):integer;
   Begin yy:=479-MargeY-CoteY*y;
   End;

PROCEDURE DessinePion(x,y:integer);
   Begin SetLineStyle(SolidLn,0,ThickWidth);
         Circle(x,y-13,5);
         Line(x-10,y-4,x+10,y-4);
         Rectangle(x-6,y,x+6,y+12);
         Line(x-10,y+16,x+10,y+16);
         Line(x-10,y+20,x+10,y+20);
   End;

PROCEDURE DessineCaval(x,y:integer);
   Begin SetLineStyle(SolidLn,0,ThickWidth);
         Arc(x-7,y-6,90,270,6);
         Line(x-7,y-12,x,y-12);
         Line(x-7,y,x,y);
         Arc(x,y,270,90,12);
         Line(x,y,x-6,y+12);
         Line(x-6,y+12,x,y+12);
         Line(x-10,y+16,x+10,y+16);
         Line(x-10,y+20,x+10,y+20);
         Line(x+3,y-12,x+6,y-15);
         Line(x+7,y-10,x+10,y-14);
         Line(x+10,y-14,x+10,y-6);
   End;

PROCEDURE DessineFou(x,y:integer);
   Begin SetLineStyle(SolidLn,0,ThickWidth);
         Circle(x,y-15,2);
         Arc(x+6,y,110,240,13);
         Arc(x-5,y,300,70,13);
         Line(x-4,y,x+4,y);
         Line(x,y-4,x,y+4);
         Line(x-6,y+14,x+6,y+14);
         Line(x-6,y+20,x-2,y+16);
         Line(x+6,y+20,x+2,y+16);
         Line(x-6,y+20,x-16,y+20);
         Line(x+6,y+20,x+16,y+20);
   End;

PROCEDURE DessineTour(x,y:integer);
   Begin SetLineStyle(SolidLn,0,ThickWidth);
         Rectangle(x-8,y-8,x+8,y+12);
         Line(x-12,y+16,x+12,y+16);
         Line(x-12,y+20,x+12,y+20);
         Line(x-12,y-12,x+12,y-12);
         SetLineStyle(DashedLn,0,ThickWidth);
         Line(x-13,y-16,x+13,y-16);
   End;

PROCEDURE DessineDame(x,y:integer);
   Begin SetLineStyle(SolidLn,0,ThickWidth);
         Arc(x-9,y+3,30,330,11);
         Arc(x+9,y+3,210,150,11);
         Line(x-12,y+16,x+12,y+16);
         Line(x-12,y+20,x+12,y+20);
         Circle(x,y-12,6);
   End;

PROCEDURE DessineRoi(x,y:integer);
   Begin SetLineStyle(SolidLn,0,ThickWidth);
         Arc(x-9,y+3,30,330,11);
         Arc(x+9,y+3,210,150,11);
         Line(x-12,y+16,x+12,y+16);
         Line(x-12,y+20,x+12,y+20);
         Line(x,y,x,y-20);
         Line(x-5,y-15,x+5,y-15);
   End;

PROCEDURE Place(x,y,c:shortint);
 Var cc:byte;
     x1,x2,y1,y2,x0,y0:integer;
   Begin Case couleurCase(x,y) of
          noir:  cc:=DarkGray;
          blanc: cc:=LightGray;
         End;
         SetFillStyle(SolidFill,cc);
         x1:=xx(x);   y1:=yy(y);
         x2:=xx(x+1); y2:=yy(y+1);
         x0:=(x1+x2) div 2;
         y0:=(y1+y2) div 2;
         Bar(x1,y1,x2-1,y2+1);
         Case c and couleur of
          blanc: cc:=Yellow;
          noir:  cc:=Brown;
         End;
         SetColor(cc);
         SetFillStyle(SolidFill,cc);
         Case c and piece of
          pion: DessinePion(x0,y0);
          caval:DessineCaval(x0,y0);
          fou:  DessineFou(x0,y0);
          tour: DessineTour(x0,y0);
          dame: DessineDame(x0,y0);
          roi:  DessineRoi(x0,y0);
         End;
   End;

PROCEDURE Curseur(x,y,c:shortint);
 Var x1,x2,y1,y2:integer;
     cc:byte;
 Const e=1; f=3;
   Begin x1:=xx(x);   y1:=yy(y);
         x2:=xx(x+1)-1; y2:=yy(y+1)+1;
         Case c and couleur of
         rien: if couleurcase(x,y)=blanc
               then cc:=LightGray
               else cc:=DarkGray;
         blanc: cc:=White;
         noir: cc:=Black;
         End;
         SetFillStyle(SolidFill,cc);
         If c and 32 =0
         then begin Bar(x1+e,y1-e,x2-e,y1-f);
                    Bar(x1+e,y2+e,x2-e,y2+f);
                    Bar(x1+e,y1-e,x1+f,y2+e);
                    Bar(x2-e,y1-e,x2-f,y2+e);
              end
         else begin Bar(x1+e,y1-e,x2-e,y1-f-1);
                    Bar(x1+e,y2+e,x2-e,y2+f+1);
                    Bar(x1+e,y1-e,x1+f+1,y2+e);
                    Bar(x2-e,y1-e,x2-f-1,y2+e);
              end;
   End;

PROCEDURE TraceGrille;
 Var i,j:shortint;
     z:integer;
   Begin SetColor(15);
         Rectangle(0,0,639,479);
         SetColor(White);
         SetTextJustify(CenterText,CenterText);
         SetTextStyle(TriplexFont,VertDir,9);
         OutTextXY(550,220,'ECHECS');
         SetTextStyle(DefaultFont,VertDir,1);
         OutTextXY(630,220,'programmation par Luc ROUSSEAU (27 ao–t 1996)');
         SetTextStyle(GothicFont,HorizDir,4);
         For i:=0 to 7 do
         For j:=0 to 7 do
         Place(i,j,g[i,j]);
         SetColor(White);
         SetTextStyle(TriplexFont,HorizDir,4);
         For i:=0 to 7 do
         begin MoveTo(20,yy(i)-30);
               OutText(chr(i+ord('1')));
         end;
         For i:=0 to 7 do
         begin MoveTo(xx(i)+30,457);
               OutText(chr(i+ord('A')));
         end;
   End;