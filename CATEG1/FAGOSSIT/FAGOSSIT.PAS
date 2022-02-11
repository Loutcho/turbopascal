PROGRAM Microscope;

        USES Crt,Dos,Graph;

        TYPE T_Grille=Array[1..7,1..7] of char;
             T_Curseur_s = Array [1..32] of word;

        CONST CoteX=50; CoteY=50; CoinHGX=250; CoinHGY=50;

        Pion:T_Curseur_s=($F81F,$E007,$C003,$8001,$8001,$0000,$0000,$0000,
                          $0000,$0000,$0000,$8001,$8001,$C003,$E007,$F81F,
                          $0000,$0000,$0000,$0000,$0000,$0E70,$0A50,$0E70,
                          $0000,$2004,$37FC,$1818,$07E0,$0000,$0000,$0000);

        Rien:T_Curseur_s=($1FF8,$0FF0,$07E0,$83C1,$C183,$E007,$F00F,$F81F,
                          $F81F,$F00F,$E007,$C183,$83C1,$07E0,$0FF0,$1FF8,
                          $C003,$E007,$700E,$381C,$1C38,$0E70,$07E0,$03C0,
                          $03C0,$07E0,$0E70,$1C38,$381C,$700E,$E007,$C003);


        VAR g:T_Grille;
            Fini:boolean;
            J:char;
            cold,ligd,cola,liga:shortint;

{$I  SOURIS.PAS}

FUNCTION Min(a,b:shortint):shortint;
   Begin If a<=b then Min:=a else Min:=b;
   End;

FUNCTION Max(a,b:shortint):shortint;
   Begin If a>=b then Max:=a else Max:=b;
   End;

FUNCTION Cat(n:shortint):string;
 Var s:string;
   Begin Str(n,s);
         Cat:=s;
   End;

PROCEDURE Attendre;
   Begin While not keypressed do;
   End;

PROCEDURE VideClavier;
 Var t:char;
   Begin While keypressed do t:=readkey;
   End;

PROCEDURE ModeGraphique;
 Var Gd,Gm:integer;
   Begin Gd:=VGA; Gm:=VGAHI;
         InitGraph(Gd,Gm,'');
         If GraphResult<>GrOk
         Then begin Writeln('Erreur: initialisation du mode graphique VGA');
                    Halt;
              end;
   End;

PROCEDURE InitSouris;
 Var statut,Nbb:integer;
   Begin Init_s(statut,Nbb);
         If statut=0
         Then begin Writeln('Erreur: souris non activ‚e');
                    Halt;
              end;
   End;

PROCEDURE DessineGrille;
 Var i:byte;
     a:integer;
   Begin SetLineStyle(SolidLn,0,ThickWidth);
         Rectangle(0,0,639,479);
         SetColor(White);
         For i:=0 to 7 do
         begin a:=CoinHGX+i*CoteX;
               Line(a,CoinHGY,a,CoinHGY+7*CoteY);
               a:=CoinHGY+i*CoteY;
               Line(CoinHGX,a,CoinHGX+7*CoteX,a);
         end;
   End;

PROCEDURE Place(x,y:shortint;c:char);
 Var a:byte;
   Begin Curseur_s(false);
         Case c of
              'A':a:=Red;
              'B':a:=Green;
              ' ':a:=Black;
         End;
         SetFillStyle(SolidFill,a);
         FloodFill(CoinHGX+x*CoteX-CoteX div 2,
                   CoinHGY+y*CoteY-CoteY div 2,White);
         Curseur_s(true);
   End;

PROCEDURE InitGrille(var g:T_Grille);
 Var x,y:byte;
   Begin For x:=1 to 7 do For y:=1 to 7 do g[x,y]:=' ';
         g[1,1]:='A'; g[7,7]:='A';
         g[1,7]:='B'; g[7,1]:='B';
         Place(1,1,'A'); Place(7,1,'B');
         Place(7,7,'A'); Place(1,7,'B');
   End;

PROCEDURE ConvCoord(x,y:integer;var col,lig:shortint;var ok:boolean);
 var xx,yy:real;
   Begin x:=x-CoinHGX; y:=y-CoinHGY;
         xx:=x/CoteX;  yy:=y/CoteY;
         ok:=((xx>0) and (xx<7) and (yy>0) and (yy<7));
         If ok
         Then begin col:=trunc(xx)+1;
                    lig:=trunc(yy)+1;
              end;
   End;

FUNCTION ExisteCaseLibre2(g:T_Grille;col,lig:shortint):boolean;
 Var p:boolean;
     i,j:byte;
   Begin p:=false;
         For i:=max(1,col-2) to min(7,col+2) do
         For j:=max(1,lig-2) to min(7,lig+2) do
         p:=p or (g[i,j]=' ');
         ExisteCaseLibre2:=p;
   End;

FUNCTION PeutJouer(g:T_Grille;j:char):boolean;
 Var col,lig:byte;
     q:boolean;
   Begin q:=false;
         For col:=1 to 7 do
         For lig:=1 to 7 do
         If g[col,lig]=j Then q:=q or ExisteCaseLibre2(g,col,lig);
         PeutJouer:=q;
   End;

PROCEDURE ChgJoueur(var j:char);
   Begin If j='A'
         then j:='B'
         else j:='A';
   End;

PROCEDURE DoitJouer(g:T_Grille;var j:char);
   Begin ChgJoueur(j);
         If not PeutJouer(g,j)
         then ChgJoueur(j);
   End;

PROCEDURE AttendreSelectionD(g:T_Grille;j:char;var col,lig:shortint);
 Var Select:boolean;
     x,y:integer;
     ok,cpion:boolean;
   Begin DefCurseurGraphique_s(Rien,8,8);
         cpion:=false;
         Select:=false;
         While not Select and not keypressed do
         begin While not BoutonPresse_s(1) and not keypressed do
               begin x:=PosX_s; y:=PosY_s;
                     ConvCoord(x,y,col,lig,ok);
                     If ok
                     then begin If (g[col,lig]=j) and not cpion
                                then begin DefCurseurGraphique_s(Pion,8,8);
                                           cpion:=true;
                                     end;
                                If (g[col,lig]<>j) and cpion
                                then begin DefCurseurGraphique_s(Rien,8,8);
                                           cpion:=false;
                                     end;
                          end
                     else begin If cpion then
                                begin DefCurseurGraphique_s(Rien,8,8);
                                      cpion:=false;
                                end;
                          end;
               end;
               Select:=g[col,lig]=j;
         end;
         Repeat Until not BoutonPresse_s(1);
   End;

FUNCTION CaseAccessible(cold,ligd,cola,liga:shortint;v:char):boolean;
   Begin CaseAccessible:=
         (v=' ') and (abs(cola-cold)<=2) and (abs(liga-ligd)<=2);
   End;

PROCEDURE AttendreSelectionA(g:T_Grille;cold,ligd:shortint;var cola,liga:shortint);
 Var Select:boolean;
     x,y:integer;
     ok,ccase:boolean;
   Begin DefCurseurGraphique_s(Rien,8,8);
         ccase:=false;
         Select:=false;
         While not Select and not keypressed do
         begin While not BoutonPresse_s(1) and not keypressed do
               begin x:=PosX_s; y:=PosY_s;
                     ConvCoord(x,y,cola,liga,ok);
                     If ok
                     then begin If CaseAccessible(cold,ligd,cola,liga,g[cola,liga])
                                   and not ccase
                                then begin DefCurseurGraphique_s(Pion,8,8);
                                           ccase:=true;
                                     end;
                                If ccase
                                   and not CaseAccessible(cold,ligd,cola,liga,
                                                      g[cola,liga])
                                then begin DefCurseurGraphique_s(Rien,8,8);
                                           ccase:=false;
                                     end;
                          end
                     else begin If ccase then
                                begin DefCurseurGraphique_s(Rien,8,8);
                                      ccase:=false;
                                end;
                          end;
               end;
               Select:=CaseAccessible(cold,ligd,cola,liga,g[cola,liga])
         end;
         Repeat Until not BoutonPresse_s(1);
   End;

PROCEDURE EffectuerMvt(var g:T_Grille;j:char;xd,yd,xa,ya:shortint);
   Begin Curseur_s(false);
         If (abs(xa-xd)<2) and (abs(ya-yd)<2)
         Then begin Place(xa,ya,j);
                    g[xa,ya]:=j;
              end
         Else begin Place(xa,ya,j);
                    g[xa,ya]:=j;
                    Place(xd,yd,' ');
                    g[xd,yd]:=' ';
              end;
         Curseur_s(true);
   End;

PROCEDURE EffectuerCaptures(var g:T_Grille;j:char;xo,yo:shortint);
 Var a,b:shortint;
     k:char;
   Begin k:=j; ChgJoueur(k);
         For a:=max(xo-1,1) to min(xo+1,7) do
         For b:=max(yo-1,1) to min(yo+1,7) do
         If g[a,b]=k
         then begin g[a,b]:=j;
                    Place(a,b,j);
              end;
   End;

FUNCTION Vainqueur(g:T_Grille):string;
 Var i,j:shortint;
     a,b:integer;
   Begin a:=0; b:=0;
         For i:=1 to 7 do
         For j:=1 to 7 do
         Case g[i,j] of
              'A':inc(a);
              'B':inc(b);
         End;
         If a>b then Vainqueur:='Rouges'
                else Vainqueur:='Verts';
         { a=b est impossible sur 49 cases toutes remplies }
   End;

PROCEDURE AfficheRenseig(g:T_Grille;jj:char);
 Var i,j:shortint;
     a,b:integer;
   Begin a:=0; b:=0;
         For i:=1 to 7 do
         For j:=1 to 7 do
         begin Case g[i,j] of
                    'A':inc(a);
                    'B':inc(b);
               End;
         end;
         SetFillStyle(SolidFill,LightBlue);
         Bar(10,200,CoinHGX-10,300);
         OutTextXY(20,233,'Rouges: '+cat(a));
         OutTextXY(20,266,'Verts:  '+cat(b));
         If jj='A' then OutTextXY(120,233,'*')
                  else OutTextXY(120,266,'*')
   End;

PROCEDURE Effacement;
 Var i:byte;
   Begin SetFillStyle(SolidFill,Black);
         For i:=0 to 31 do
         begin Bar(i*10,0,10+i*10,479);
               Bar(639-i*10,0,629-i*10,479);
               Delay(50);
         end;
   End;

BEGIN ModeGraphique;
      DessineGrille;
      InitGrille(g);
      InitSouris;
      Curseur_s(true);
      Fini:=false; J:='B';
      While not Keypressed and not Fini do
      begin DoitJouer(g,j);
            AfficheRenseig(g,j);

            AttendreSelectionD(g,j,cold,ligd);
            If not keypressed
            Then begin AttendreSelectionA(g,cold,ligd,cola,liga);
                       EffectuerMvt(g,j,cold,ligd,cola,liga);
                       EffectuerCaptures(g,j,cola,liga);
                       Fini:=not PeutJouer(g,'A') and not PeutJouer(g,'B');
                 end;
      end;
      Curseur_s(false);
      AfficheRenseig(g,j);
      SetFillStyle(SolidFill,Black);
      Bar(110,200,CoinHGX-10,300);
      If Fini
      Then begin OutTextXY(10,100,'La partie est termin‚e');
                 OutTextXY(10,120,'Les '+Vainqueur(g)+' ont gagn‚');
                 OutTextXY(10,450,'Appuyez sur une touche pour retourner au systŠme d''exploitation');
          end;
      If Keypressed
      Then begin OutTextXY(10,100,'La partie a ‚t‚ interrompue');
                 OutTextXY(10,450,'Appuyez sur une touche pour retourner au systŠme d''exploitation');
           end;
      VideClavier;
      Attendre; VideClavier;
      Effacement; Delay(750);
      CloseGraph;
END.