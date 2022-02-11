TYPE Adresse = ^Element;
     Contenu = ...
     Element = Record info:contenu;
                      suiv:adresse;
               End;

FUNCTION PileVide(tete:adresse):boolean;
   Begin PileVide:=tete=nil;
   End;

PROCEDURE Empiler(info:contenu;var tete:adresse);
 Var p:adresse;
   Begin New(p);
         p^.suiv:=tete;
         tete:=p;
   End;

(* Pr‚condition : la pile n'est pas vide *)
PROCEDURE Depiler(var info:contenu;var tete:adresse);
 Var p:adresse;
   Begin info:=tete^.info;
         p:=tete;
         tete:=tete^.suiv;
         Dispose(p);
   End;