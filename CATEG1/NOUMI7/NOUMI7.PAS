(* ********************************************************************** *)
(* *****************************ÚÄÄÄÄÄÄÄÄÄÄ¿***************************** *)
(* *****************************³  NOUMI7  ³***************************** *)
(* *****************************ÀÄÄÄÄÄÄÄÄÄÄÙ***************************** *)
(* ********************************************************************** *)

PROGRAM Tetris_Luc;

        USES       Crt,Dos;

        CONST      NivMin   = 0;           NivMax   = 19;
                   ColsMin  = 6;           ColsMax  = 18;
                   LigsMin  = 10;          LigsMax  = 22;
                   Col1     = 30;          Lig1     = 10;
                   LongMax  = 15;              (* Longueur d'un nom *)
                   NbEnreg  = 10;               (* Nombre de noms    *)
                   NbPrevus = 03;          (* Nombre de blocs pr‚vus *)
                   CoteX    = 18;          (* Dimension d'un carr‚ *)
                   CoteY    = 18;
                   Ext      : string = '.NM7';

        TYPE       Str2   = String[2];  Str4   = String[4];
                   Str20  = String[20];
                   StrScore = String[LongMax];
                   T_Point= Record  x,y:byte  End;
                   T_Bloc = Array[1..4] of T_Point;
                   T_Prevus=Array[1..NbPrevus] of byte;
                   Tableau= Array[1..ColsMax,1..LigsMax] of byte;
                   T_Enreg= Record score:longint;
                                   nblignes:integer;
                                   nom:strScore;
                            End;
                   F_Enreg= File of T_Enreg;
                   T_Police=Array[0..255,1..16] of byte;
                   F_Police=File Of T_Police;

        VAR        Son,Quitter,Handicap             :   Boolean;
                   Niveau,Cols,Ligs,NbBlocs         :   Byte;
                   F                                :   F_Enreg;
                   page                             :   Byte;
                   Police                           :   T_Police;

 {$I  INTECRAN.PAS}        (* interruptions ‚cran *)
 {$I  PRATIQUE.PAS}        (* proc‚dures et fonctions utiles *)
 {$I  GERE_ERR.PAS}        (* gestion des erreurs *)
 {$I  GERESONS.PAS}        (* gestion des sons *)
 {$I  GERESCOR.PAS}        (* gestion des scores *)
 {$I  MISCELLA.PAS}        (* fourre-tout *)
 {$I  PHASEJEU.PAS}        (* jeu proprement dit *)
 {$I  GERECLAV.PAS}        (* gestion du clavier (menu principal) *)

PROCEDURE ChargePolice(var Police:T_Police);
 Var fp:F_Police;
   Begin Assign(fp,'POLICE.DAT');
         {$I-}
         Reset(fp);
         Read(fp,police);
         Close(fp);
         {$I+}
         Etudier(Ioresult);
   End;

BEGIN (* PROGRAMME PRINCIPAL *)
      page:=0;
      niveau:=15;
      Cols:=10;
      Ligs:=20;
      Son:=true;
      Handicap:=false;
      Quitter:=false;
      NbBlocs:=0;
      Randomize;
      Assign(f,DetermineNomFic(cols,ligs,handicap));
      ChargePolice(Police);
      AfficheMenu(son,handicap,niveau,cols,ligs,NbBlocs);
      While not Quitter do
            begin Attendre;
                  GC(F,Son,Handicap,Niveau,Cols,Ligs,NbBlocs,Quitter);
            end;
      ModeVideo($3);
END.  (* PROGRAMME PRINCIPAL *)