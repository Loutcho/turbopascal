PROGRAM FIXPAL;

        USES Crt,Dos;

        TYPE tab = array [1..17] of byte;

        VAR t:tab;
            r:registers;
            i:byte;
            c:char;

BEGIN For TextAttr:=0 to 16 do Write('лл');
      i:=0;
      While c<>#27 do
      begin c:=readkey;
            Case c of
                 '+':inc(t[i]);
                 '-':dec(t[i]);
                 '?':Readln(i);
            End;
            r.ah:=$10; r.al:=$02; r.es:=seg(t); r.dx:=ofs(t);
            Intr($10,r);
      end;
      
END.