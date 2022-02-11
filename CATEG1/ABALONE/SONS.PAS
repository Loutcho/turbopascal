PROCEDURE SonPoussee;
 Var i:byte;
   Begin Sound(25);
         Delay(40);
         NoSound;
         Delay(5);
   End;

PROCEDURE SonEject;
 Var t:longint;
   Begin For t:=0 to 50 do
         begin sound(-t+70);
               SetRGBPalette(EGABlack,(t*t)mod 64,t mod 64,(64-t) mod 64);
         end;
         Nosound;
         SetRGBPalette(EGABlack,36,12,36);
   End;