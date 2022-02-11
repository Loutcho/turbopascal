 PROGRAM LITPAL;

        USES Dos;

        TYPE tab = array [1..17] of byte;

        VAR t:tab;
            r:registers;

BEGIN r.ah:=$10; r.al:=$09; r.es:=seg(t); r.dx:=ofs(t);
      Intr($10,r);
      For r.ah:=1 to 17 do Write(t[r.ah],' ');
END.