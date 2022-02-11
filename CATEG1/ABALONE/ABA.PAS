PROGRAM ABALONE;

        USES Crt,Dos,Graph;

        CONST HorsGrille=1;
              Oqp=2;
              CouleurBoule=4;BouleNoire=0; BouleBlanche=4;
              MasqueNum=8+16+32+64;
              On=true; Off=false;
              BGauche=1;BDroit=2;

        TYPE T_Grille = Array [-4..4,-4..4] of byte;
             T_Data   = Record g:T_Grille;
                               ne,be:shortint;
                               tour:word;
                        End;
             F_Data   = File Of T_Data;

        VAR Gd,Gm:integer;
            Quitter:boolean;
            data:T_Data;
            f:F_Data;
            x,y:integer;

{$I  SOURIS.PAS}
{$I  PRATIQUE.PAS}
{$I  GRAPHISM.PAS}
{$I  SONS.PAS}
{$I  SAVELOAD.PAS}
{$I  GC.PAS}

BEGIN
      ModeGraphique(Gd,Gm);
      AfficheCadre;
      InitSouris;
      InitCouleurs;
      InitGrille(data.g);
      DessineGrille;
      PlaceBoules(data.g);
      Souris(On);

      quitter:=false;
      With data do
      begin ne:=0; be:=0; tour:=0;
      end;
      While not quitter do
      begin Souris(Off);
            AfficheRenseig(data);
            Souris(On);
            Attendre;
            x:=XSouris;y:=YSouris;
            ConvertirCoord2(x,y);
            GC(quitter,x,y,data,f);
            If (data.ne=6) or (data.be=6)
            Then begin AfficheRenseig(data);
                       If data.ne=6 then Message('Les Blancs ont gagn‚.')
                                    else Message('Les Noirs ont gagn‚.');
                       Quitter:=true;
                 end;
      end;

      Souris(Off);
      RestoreCrtMode; CloseGraph;
END.