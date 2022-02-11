PROCEDURE Sauvegarder(VAR data:T_data;VAR f:F_Data);
 Var NomDos:string;
   Begin Message('SAUVEGARDE: 1) taper une touche 2) choisir un nom de fichier');
         Saisir(NomDos);
         Assign(f,NomDos);
         {$I-}
         Rewrite(f);
         Write(f,data);
         Close(f);
         {$I+}
         If IoResult<>0
         Then Message('ATTENTION: Erreur de sauvegarde');
   End;  (* Sauvegarder *)

PROCEDURE Charger(var data:T_data;VAR f:F_Data);
 Var NomDos:string;
   Begin Message('CHARGEMENT: 1) taper une touche 2) choisir un nom de fichier');
         Saisir(NomDos);
         Assign(f,NomDos);
         {$I-}
         Reset(f);
         Read(f,data);
         Close(f);
         {$I+}
         If IoResult<>0
         Then Message('ATTENTION: Erreur de chargement.');
   End;  (* Charger *)