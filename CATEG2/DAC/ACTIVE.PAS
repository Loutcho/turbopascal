PROGRAM ActivationDesRegistresDACcontenusDansUnFichierDAC;

        USES Crt,Dos;

        TYPE T_RVB          =    Record Rouge,Vert,Bleu:byte End;
             T_RegistresDAC =    Array[0..255] of T_RVB;
             F_RegistresDAC =    File Of T_RegistresDAC;

        VAR  Tampon:T_RegistresDAC;

{$I  INTECRAN.PAS}

PROCEDURE RegistresDACDefaut(b:boolean);
 Var reg:registers;
   Begin reg.ah:=$12;
         reg.bl:=$31;
         If b then reg.al:=0
              else reg.al:=1;
         Intr($10,reg);
   End;

PROCEDURE LitFichierDAC(NomDos:string;var tampon:T_RegistresDAC);
 Var f:F_RegistresDAC;
   Begin Assign(f,NomDos);
         {$I-}
         Reset(f);
         Read(f,tampon);
         Close(f);
         {$I+}
         If IoResult<>0
         then begin Write(#7);
                    Ecrire('SYNTAXE:      ACTIVE Nom_de_fichier');
              end;
   End;

PROCEDURE ActiveTampon(VAR tampon:T_RegistresDAC);
 Var reg:registers;
   Begin reg.ah:=$10;
         reg.al:=$12;
         reg.bx:=0;
         reg.cx:=256;
         reg.es:=seg(tampon);
         reg.dx:=ofs(tampon);
         Intr($10,reg);
   End;

BEGIN RegistresDACDefaut(false);
      LitFichierDAC(ParamStr(1),tampon);
      ActiveTampon(tampon);
END.