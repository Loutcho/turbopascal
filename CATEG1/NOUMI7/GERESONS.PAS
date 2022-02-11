PROCEDURE SignalVide;
 Var i,j:byte;
   Begin For j:=1 to 5 do
         For i:=1 to 60 do
         begin Sound(i*i*j); delay(1); end;
         NoSound;
   End;

PROCEDURE SignalNiv;
 Var i:shortint;
   Begin For i:=-128 to 127 do
             begin sound(round(160-i*i/128));
                   Delay(2);
             end;
         Nosound;
   End;

PROCEDURE SignalLig;
 Var i:byte;
   Begin For i:=1 to 5 do
             begin Sound(i*500+50);
                   Delay(5);
                   Sound((6-i)*500+50);
                   Delay(5);
             end;
             Nosound;
   End;

PROCEDURE SignalFin;
 Var i:word;
   Begin For i:=0 to 2000 do
             Sound(round(2000-i/2-i/2*sin(i/10)));
         Nosound;
   End;
