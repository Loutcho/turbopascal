FUNCTION ChaineErreur(n:word):string;
 Var s:string;
   Begin Case n Of
              $0:s:='Pas d''erreur';
              $1:s:='Num�ro de fonction invalide';
              $2:s:='Fichier non trouv�';
              $3:s:='Chemin non trouv�';
              $4:s:='Trop de fichiers ouverts, plus de handle disponible';
              $5:s:='Acc�s refus�';
              $6:s:='Handle incorrect';
              $7:s:='MCB d�truit';
              $8:s:='M�moire insuffisante';
              $9:s:='Adresse de zone incorrecte';
              $A:s:='Environnement incorrect';
              $B:s:='Format incorrect';
              $C:s:='Code d''acc�s incorrect';
              $D:s:='Donn�e incorrecte';
              $E:s:='R�serv�';
              $F:s:='R�f�rence de disque incorrecte';
              $10:s:='Tentative de destruction du r�pertoire courant';
              $11:s:='P�riph�riques diff�rents';
              $12:s:='Plus de fichiers';
              $13:s:='Disque prot�g� contre l''�criture';
              $14:s:='Unit� inconnue';
              $15:s:='Disque pas pr�t';
              $16:s:='Commande incorrecte';
              $17:s:='Erreur de m�moire';
              $18:s:='Longueur de structure incorrecte';
              $19:s:='Erreur de positionnement du pointeur de fichier';
              $1A:s:='Disque non MS-DOS';
              $1B:s:='Secteur non trouv�';
              $1C:s:='Plus de papier dans l''imprimante';
              $1D:s:='Erreur d''�criture';
              $1E:s:='Erreur de lecture';
              $1F:s:='Erreur g�n�rale';
              $20:s:='Violation de r�seau (partage)';
              $21:s:='Violation de bloquage (lock)';
              $22:s:='Changement de disque incorrect';
              $23:s:='FCB non disponible';
              $24:s:='Tampon de partage satur�';
              $25..$31:s:='R�serv�';
              $32:s:='Requ�te de r�seau non support�e';
              $33:s:='Machine � distance n''est pas pr�te';
              $34:s:='Nom d�j� existant sur le r�seau';
              $35:s:='Nom du r�seau non trouv�';
              $36:s:='R�seau occup�';
              $37:s:='P�riph�rique n''existe plus sur le r�seau';
              $38:s:='Nombre de commandes du BIOS r�seau satur�';
              $39:s:='Erreur mat�riel dans la connexion du r�seau';
              $3A:s:='R�ponse de r�seau incorrecte';
              $3B:s:='Erreur de r�seau';
              $3C:s:='Adaptateur incompatible';
              $3D:s:='Queue d''impression pleine';
              $3E:s:='Queue d''impression non remplie';
              $3F:s:='Plus de place pour le fichier d''impression';
              $40:s:='Nom du r�seau effac�';
              $41:s:='Acc�s refus�';
              $42:s:='Type de p�riph�rique incorrect';
              $43:s:='Nom de r�seau non trouv�';
              $44:s:='Limite du nom du r�seau satur�e';
              $45:s:='Session du NETBIOS satur�e';
              $46:s:='Pause temporaire';
              $47:s:='Requ�te non accept�e';
              $48:s:='Redirection de l''imprimante ou du disque temporairement suspendue';
              $49..$4F:s:='R�serv�';
              $50:s:='Fichier existant d�ja';
              $51:s:='R�serv�';
              $52:s:='Pas possible de cr�er un r�pertoire';
              $53:s:='Erreur d''interruption 24h';
              $54:s:='En dehors de la structure';
              $55:s:='D�j� assign�';
              $56:s:='Mot de passe incorrect';
              $57:s:='Param�tres incorrects';
              $58:s:='Erreur d''�criture';
              152:s:='P�riph�rique non pr�t'; (* si j'ai bien compris *)
         Else s:='Erreur non d�termin�e';
         End;
         ChaineErreur:=s;
   End;

PROCEDURE MessageErreur(s:string);
   Begin TextAttr:=12+Blink;
         VaEnXY(0,24);
         Ecrire(s);
   End;  (* MessageErreur *)

PROCEDURE Etudier(Ior:word);
   Begin If Ior<>0
            then begin MessageErreur(ChaineErreur(Ior));
                       Attendre;VideClavier;
                       MessageErreur(ChaineDe(' ',80));
                 end;
   End;