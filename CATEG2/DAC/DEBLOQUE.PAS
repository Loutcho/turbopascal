PROGRAM Debloque;

        USES Dos;

        VAR reg:registers;

BEGIN reg.ah:=$12;
      reg.bl:=$31;
      reg.al:=0;
      Intr($10,reg);
END.

