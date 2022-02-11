PROGRAM Projections;

        USES Crt,Graph;

        CONST NbP=100;

        TYPE Point3d = Record x,y,z:real;
                       End;
             PointEcran = Record x,y:integer;
                          End;
             Chenille = Array [1..NbP]of Point3d;


        CONST Oeil:Point3d=(x:0;y:-1;z:0);
              DemiLong=0.11;
              DemiProf=1;
              DemiLarg=0.08;
              a=DemiLong/32;
              b=DemiProf/32;
              c=DemiLarg/32;

        VAR che:chenille;
            M,N:Point3d;
            tete,i:integer;
            coul:byte;

PROCEDURE Attendre;
   Begin While not keypressed do;
   End;

PROCEDURE VideClavier;
 Var t:char;
   Begin While keypressed do t:=readkey;;
   End;

PROCEDURE ModeGraphique;
 Var Gd,Gm:integer;
     i:byte;
   Begin Gd:=VGA; Gm:=VGAHI;
         InitGraph(Gd,Gm,'');
         If GraphResult<>GrOk then Halt;
   End;

PROCEDURE Tourne(axe:char;angle:real;var m:Point3d);
 Var c,s:real;
     n:Point3d;
   Begin c:=cos(angle); s:=sin(angle);
         Case upcase(axe) of
              'X': begin n.y:=c*m.y-s*m.z;
                         n.z:=s*m.y+c*m.z;
                         n.x:=m.x;
                   end;
              'Y': begin n.z:=c*m.z-s*m.x;
                         n.x:=s*m.z+c*m.x;
                         n.y:=m.y;
                   end;
              'Z': begin n.x:=c*m.x-s*m.y;
                         n.y:=s*m.x+c*m.y;
                         n.z:=m.z;
                   end;
         End;
         m:=n;
   End;

PROCEDURE Projette(M:Point3d;var I:PointEcran);
 Var k:real;
     N:Point3d;
   Begin k:=-Oeil.y/(M.y-Oeil.y);
         N.x:=k*M.x; N.y:=0; N.z:=k*M.z;
         I.x:=320+round(N.x*2666);
         I.y:=240-round(N.z*2666);
   End;

PROCEDURE Place(M:Point3d;c:byte);
 Var A,B:PointEcran;
   Begin Projette(M,A);
         PutPixel(A.x,A.y,c);
   End;

PROCEDURE Ligne(A,B:Point3d;c:byte);
 Var I,J:PointEcran;
     AA,BB:Point3d;
   Begin SetColor(c);
         Projette(A,I);
         Projette(B,J);
         Line(I.x,I.y,J.x,J.y);
         if c<>0 then SetColor(DarkGray);
         AA.x:=A.x; AA.y:=A.y; AA.z:=DemiLarg;
         BB.x:=B.x; BB.y:=B.y; BB.z:=DemiLarg;
         Projette(AA,I);
         Projette(BB,J);
         Line(I.x,I.y,J.x,J.y);

         AA.x:=A.x; AA.y:=A.y; AA.z:=-DemiLarg;
         BB.x:=B.x; BB.y:=B.y; BB.z:=-DemiLarg;
         Projette(AA,I);
         Projette(BB,J);
         Line(I.x,I.y,J.x,J.y);

         AA.x:=DemiLong; AA.y:=A.y; AA.z:=A.z;
         BB.x:=DemiLong; BB.y:=B.y; BB.z:=B.z;
         Projette(AA,I);
         Projette(BB,J);
         Line(I.x,I.y,J.x,J.y);

         AA.x:=-DemiLong; AA.y:=A.y; AA.z:=A.z;
         BB.x:=-DemiLong; BB.y:=B.y; BB.z:=B.z;
         Projette(AA,I);
         Projette(BB,J);
         Line(I.x,I.y,J.x,J.y);

         AA.x:=A.x; AA.y:=2*DemiProf; AA.z:=A.z;
         BB.x:=B.x; BB.y:=2*DemiProf; BB.z:=B.z;
         Projette(AA,I);
         Projette(BB,J);
         Line(I.x,I.y,J.x,J.y);

         AA.x:=A.x; AA.y:=0; AA.z:=A.z;
         BB.x:=B.x; BB.y:=0; BB.z:=B.z;
         Projette(AA,I);
         Projette(BB,J);
         Line(I.x,I.y,J.x,J.y);
   End;

PROCEDURE Deplace(M:Point3d;var N:Point3d);
 Var r:word;
   Begin N.x:=M.x+a*random(3)-a;
         N.y:=M.y+b*random(3)-b;
         N.z:=M.z+c*random(3)-c;
         If abs(N.x)>DemiLong then N.x:=M.x;
         If abs(N.y-DemiProf)>DemiProf then N.y:=M.y;
         If abs(N.z)>DemiLarg then N.z:=M.z;
   End;

FUNCTION Suivant(n:integer):integer;
   Begin If n=nbp then suivant:=1 else suivant:=n+1;
   End;

BEGIN ModeGraphique;
      Randomize;
      For i:=1 to NbP do
      begin che[i].x:=0; che[i].y:=a; che[i].z:=0;
      end;
      tete:=1;
      While not keypressed do
      begin M:=che[suivant(tete)];
            Deplace(che[tete],N);
            Ligne(M,che[suivant(suivant(tete))],black);
            Ligne(che[tete],N,white);
            tete:=suivant(tete);
            che[tete]:=N;
      end;
      Attendre;
      VideClavier;
      CloseGraph;
END.