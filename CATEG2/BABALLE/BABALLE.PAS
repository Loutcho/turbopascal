PROGRAM Babal;

        USES Crt,Graph;

        VAR x,y,vx,vy:real;
            module:real;
            xx,yy,k:real;
            Gd,Gm:integer;
            t:char;
            p:pointer;
            size:word;
            mode:char;

BEGIN Randomize;
      Gd:=VGA;
      Gm:=VGAHI;
      InitGraph(Gd,Gm,'');
      Circle(5,5,3);
      Size := ImageSize(2,2,8,8);
      GetMem(P, Size);
      GetImage(2,2,8,8,P^);
      PutImage(2,2,P^,XorPut);
      x:=0; y:=0;
      module:=1; k:=2*random*pi;
      vx:=module*cos(k); vy:=module*sin(k);
      mode:='X';
      t:=' ';
      Rectangle(0,0,639,479);

      Repeat PutImage(round(x)-3,round(y)-3, P^, XorPut);
             xx:=x+vx; yy:=y+vy;
             If (xx>0) and (xx<639)
             Then x:=xx
             Else vx:=-vx;
             If (yy>0) and (yy<479)
             Then y:=yy
             Else vy:=-vy;
             Case mode of
                  'X':PutImage(round(x)-3,round(y)-3, P^, XorPut);
             End;
             if keypressed
             Then begin t:=readkey;
                        Case t of
                             '*':begin k:=random;
                                       vx:=cos(2*k*pi);
                                       vy:=sin(2*k*pi);
                                 end;
                             '>':begin module:=2*module;
                                       vx:=module*cos(2*k*pi);
                                       vy:=module*sin(2*k*pi);
                                 end;
                             '<':begin module:=0.5*module;
                                       vx:=module*cos(2*k*pi);
                                       vy:=module*sin(2*k*pi);
                                 end;
                             'v':begin vx:=-vx;
                                 end;
                             'h':begin vy:=-vy;
                                 end;
                             'V':begin k:=0.25+random(2)/2;
                                       vx:=cos(2*k*pi);
                                       vy:=sin(2*k*pi);
                                 end;
                             'H':begin k:=0+random(2)/2;
                                       vx:=cos(2*k*pi);
                                       vy:=sin(2*k*pi);
                                 end;
                             't':mode:='T';
                             'x':mode:='X';
                             '0':begin vx:=0;
                                       vy:=0;
                                 end;
                        End;
                  end;
      Until t=#27;
END.
