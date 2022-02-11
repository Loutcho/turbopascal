PROGRAM DacActuelle;

        USES Dos;

        TYPE T_RegCoulDAC = Record rouge,vert,bleu:byte End;
             T_TableDAC   = Array[0..255] of T_RegCoulDAC;
             F_TableDAC   = File of T_TableDAC;

        VAR td:T_TableDAC;
            f:F_TableDAC;

PROCEDURE LitRegCoulDAC(num:byte;var rcd:T_RegCoulDAC);
 Var r:registers;
   Begin r.ah:=$10; r.al:=$15; r.bx:=num;
         Intr($10,r);
         rcd.rouge:=r.dh; rcd.vert:=r.ch; rcd.bleu:=r.cl;
   End;

PROCEDURE LitTableDAC(var td:T_TableDAC);
 Var i:byte;
   Begin For i:=0 to 255 do LitRegCoulDAC(i,td[i]);
   End;

PROCEDURE CreeFichier(VAR f:F_TableDAC;VAR td:T_TableDAC);
   Begin Assign(f,'ACTUELLE');
         Rewrite(f);
         Write(f,td);
         Close(f);
   End;

BEGIN LitTableDAC(td);
      CreeFichier(f,td);
END.