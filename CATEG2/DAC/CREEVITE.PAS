PROGRAM CreeViteUnFichierDAC;

        USES Crt,Dos;

        TYPE T_RVB          =    Record Rouge,Vert,Bleu:byte End;
             T_RegistresDAC =    Array[0..255] of T_RVB;
             F_RegistresDAC =    File Of T_RegistresDAC;

        VAR  T:T_RegistresDAC;
             i:byte;
             ir,iv,ib:shortint;
             s:string;

PROCEDURE CreeFichierDAC(NomDos:string;VAR tampon:T_RegistresDAC);
 Var i:byte;
     rvb:T_RVB;
     f:F_RegistresDAC;
   Begin Assign(f,NomDos);
         {$I-}
         Rewrite(f);
         Write(f,tampon);
         Close(f);
         {$I+}
         If IoResult<>0 then Write(#7);
   End;

BEGIN Randomize;
      If ParamCount>=1 then s:=Paramstr(1) else s:=' ';
      t[0].rouge:=0; t[0].vert:=0; t[0].bleu:=0;
      t[255].rouge:=63; t[255].vert:=63; t[255].bleu:=63;
      Case s[1] of
           '~': begin i:=1;
                      ir:=random(9)-4;
                      iv:=random(9)-4;
                      ib:=random(9)-4;
                      While i<=254 do
                      begin t[i].rouge:=(t[i-1].rouge+ir) mod 64;
                            t[i].vert:=(t[i-1].vert+iv) mod 64;
                            t[i].bleu:=(t[i-1].bleu+ib) mod 64;
                            inc(i);
                      end;
                end;
           'r': For i:=1 to 254 do
                begin t[i].rouge:=i mod 64;
                      t[i].vert:=random(64);
                      t[i].bleu:=random(64);
                end;
           'v': For i:=1 to 254 do
                begin t[i].rouge:=random(64);
                      t[i].vert:=i mod 64;
                      t[i].bleu:=random(64);
                end;
           'b': For i:=1 to 254 do
                begin t[i].rouge:=random(64);
                      t[i].vert:=random(64);
                      t[i].bleu:=i mod 64;
                end;
      Else For i:=1 to 254 do
           begin t[i].rouge:=random(64);
                 t[i].vert:=random(64);
                 t[i].bleu:=random(64);
           end
      End; {Case}
      If ParamCount>=2
      then CreeFichierDAC(Paramstr(2),t)
      else CreeFichierDAC('FICHIER',t);
END.