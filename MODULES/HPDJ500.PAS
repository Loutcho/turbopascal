PROGRAM HPDJ500;

        USES Printer;

        TYPE Str2=string[2];
             Str3=string[3];
             Str4=string[4];

        CONST Esc=#27;

PROCEDURE ReInit;
   Begin Write(lst,Esc+'E');
   End;

PROCEDURE TestAuto;
   Begin Write(lst,Esc+'z');
   End;

PROCEDURE CtrlAlim(c:char);
   Begin Write(lst,Esc+'&l'+c+'H');
   End;

PROCEDURE ModeImpr(c:char);
   Begin Write(lst,Esc+'&k'+c+'W');
   End;

PROCEDURE Soulign(c:char);
   Begin If c in ['1'..'4']
         Then Write(lst,Esc+'&d'+c+'D')
         Else Write(lst,Esc+'&d'+c);
   End;

PROCEDURE FinLigne(c:char);
   Begin Write(lst,Esc+'&k'+c+'G');
   End;

PROCEDURE BouclageFinLigne(b:boolean);
   Begin If b
         then Write(lst,Esc+'&s0C')
         else Write(lst,Esc+'&s1C');
   End;

PROCEDURE ImprModeTransparent(n:byte);
   Begin Write(lst,Esc+'&p',n,'X');
   End;

PROCEDURE AffFonctions(b:boolean);
   Begin If b
         then Write(lst,Esc+'Y')
         else Write(lst,Esc+'Z');
   End;

PROCEDURE CtrlSoulign(b:boolean);
   Begin If b
         then Write(lst,Esc+'&k0E')
         else Write(lst,Esc+'&k1E');
   End;

PROCEDURE CtrlCode(b:boolean);
   Begin If b
         then Write(lst,Esc+'&k0F')
         else Write(lst,Esc+'&k1F');
   End;

PROCEDURE FormatPapier(s:Str2);
   Begin Write(lst,Esc+'&l'+s+'A');
   End;

PROCEDURE Orientation(c:char);
   Begin Write(lst,Esc+'&l'+c+'O');
   End;

PROCEDURE Interligne(n:byte);
   Begin Write(lst,Esc+'&l',n,'D');
   End;

PROCEDURE HauteurPage(n:byte);
   Begin Write(lst,Esc+'&l',n,'P');
   End;

PROCEDURE SautPerforation(b:boolean);
   Begin If b
         then Write(lst,Esc+'&l1L')
         else Write(lst,Esc+'&l0L')
   End;

PROCEDURE Marges(c:char;n:byte);
   Begin Case c of
         'E':Write(lst,Esc+'9');
         'G':Write(lst,Esc+'&a',n,'L');
         'D':Write(lst,Esc+'&a',n,'N');
         End;
   End;

PROCEDURE MargeSup(n:byte);
   Begin Write(lst,Esc+'&l',n,'E');
   End;

PROCEDURE HauteurTexte(n:byte);
   Begin Write(lst,Esc+'&l',n,'F');
   End;

PROCEDURE ModeReducTexte(b:boolean);
   Begin If b
         Then Write(lst,Esc+'&k5W')
         Else Write(lst,Esc+'&k6W')
   End;

PROCEDURE PosCAP(c:char;n:byte);
   Begin (* trop compliqu‚ *)
   End;

PROCEDURE Police(s:Str3);
   Begin Write(lst,Esc+'('+s);
   End;

PROCEDURE Espacement(c:char);
   Begin Write(lst,Esc+'(s'+c+'P');
   End;

PROCEDURE Densite(n:byte);
   Begin Write(lst,Esc+'(s',n,'H');
   End;

PROCEDURE ForceCorps(n:byte);
   Begin Write(lst,Esc+'(s',n,'V');
   End;

PROCEDURE Style(c:char);
   Begin Write(lst,Esc+'(s'+c+'S');
   End;

PROCEDURE Graisse(c:char);
   Begin Write(lst,Esc+'(s'+c+'B');
   End;

PROCEDURE TypeCar(s:str4);
   Begin Write(lst,Esc+'(s'+s+'T');
   End;

PROCEDURE QualiteImpr(c:char);
   Begin Write(lst,Esc+'(s'+c+'Q');
   End;

(* le reste est trop compliqu‚ *)

BEGIN ReInit; Interligne(12); Densite(20); ForceCorps(6);
END.