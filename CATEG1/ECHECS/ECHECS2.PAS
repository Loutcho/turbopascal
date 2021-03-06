PROGRAM Echecs2;

TYPE
        Couleur=(Blanc,Noir,Aucune);

        TypePiece=(Pion,Cavalier,Fou,Tour,Dame,Roi,MarqueurEP,Aucune);

        Coords= {coordonn�es d'une case}
               Record
                      Colonne : byte; {parmi 1..8}
                      Ligne : byte;   {parmi 1..8}
               End;

        Kaze= {case de l'�chiquier}
             Record
                    CoulKaze:couleur;  {couleur de la case}
                    Contenu:byte;      {indice dans tableau de pi�ces}
             End;

        Piece= {pi�ce � jouer ou marqueur de possibilit� de prise e.p.}
              Record
                     Typ:TypePiece;     {type de pi�ce ou marqueur}
                     CoulPiece:couleur; {couleur de la pi�ce}
                     PosInit:Coords;    {coords pi�ce en d�b de partie}
                     Abouge:boolean;    {pi�ce a-t-elle boug� ds partie?}
                     Select:boolean;    {pi�ce est-elle en train d'� boug�e?}
                     PosAct:Coords;     {coords actuelles de la pi�ce}
                     PosFut:Coords;     {coords futures envisag�es de la p.}
                     IndicePion;        {indique quel pion prenable e.p.}
              End;

        Echiquier = Array [1..8,1..8] of Kaze;

        Pieces = Array[0..33] of Piece;

VAR E:Echiquier;
    P:Pieces;

PROCEDURE InitPieces(var P:Pieces);
Begin P[0].typ:=MarqueurEP;
      For i:=1 to 8 do
      begin P[i+8].typ:=Pion;
            P[i+8].coulpiece:=Blanc;
            P[i+8].PosInit.Colonne:=i;
            P[i+8].PosInit.Ligne:=2;
            P[i+8].PosAct.Colonne:=i;
            P[i+8].PosAct.Ligne:=2;
            P[i+16].typ:=Pion;
            P[i+16].coulpiece:=Noir;
            P[i+16].PosInit.Colonne:=i;
            P[i+16].PosInit.Ligne:=7;
            P[i+16].PosAct.Colonne:=i;
            P[i+16].PosAct.Ligne:=7;
      end;
End;

BEGIN {ppal}
END.  {ppal}