PROGRAM DeChangementsRapidesDeRepertoires;

        USES Crt,Dos;

        TYPE Str12 = String[12];
             T_5 = Array [1..5] Of SearchRec;

        VAR Cinq:T_5;
            NbrReps:byte;
            NumCour:byte;
            RepCour:string;
            Quitter:boolean;

        CONST CoinHGX=50;
              CoinHGY=4;

PROCEDURE Curseur(deb,fin:byte);
 Var reg:registers;
   Begin reg.ah:=$01;
         reg.ch:=deb;
         reg.cl:=fin;
         Intr($10,reg);
   End; (* Curseur *)

PROCEDURE DessineCadre(x,y,xx,yy,c:byte);
 Var i:byte;
   Begin TextAttr:=c;
         For i:=1 to xx do
         begin GotoXY(x+i,y);
               Write('Ä');
               GotoXY(x+i,y+yy+1);
               Write('Ä');
         end;
         For i:=1 to yy do
         begin GotoXY(x,y+i);
               Write('³');
               GotoXY(x+xx+1,y+i);
               Write('³');
         end;
         GotoXY(x,y);           Write('Ú');
         GotoXY(x,y+yy+1);      Write('À');
         GotoXY(x+xx+1,y);      Write('¿');
         GotoXY(x+xx+1,y+yy+1); Write('Ù');
   End;  (* DessineCadre *)

PROCEDURE Attendre;
   Begin While not keypressed do;
   End;

PROCEDURE VideClavier;
 Var t:char;
   Begin While keypressed do t:=readkey;
   End;

FUNCTION Complete(s:string;taille:byte):string;
 Var i:byte;
   Begin For i:=length(s) to taille-1 do
         s:=s+' ';
         Complete:=s;
   End;

PROCEDURE InitCinq(VAR RepCour:string;Var Cinq:T_5;Var NbrReps,NumCour:byte);
 Var Sr:SearchRec;
   Begin NbrReps:=0;
         FindFirst('*.*',AnyFile,Sr);
         While (DosError=0) and (nbrreps<5) do
         begin If (Sr.Attr and Directory <> 0) and (Sr.name<>'.') then
               begin NbrReps:=NbrReps+1;
                     Cinq[NbrReps]:=Sr;
               end;
               FindNext(Sr);
         end;
         If NbrReps=0 then NumCour:=0 else NumCour:=1;
   End;  (* Init *)

PROCEDURE AuSuivant(Var Cinq:T_5);
 Var Sr:SearchRec;
     i:byte;
   Begin Sr:=Cinq[5];
         FindNext(Sr);
         While (DosError=0) and (Sr.attr and Directory =0) do FindNext(Sr);
         If DosError<>0 then begin end
                        else begin For i:=1 to 4 do Cinq[i]:=Cinq[i+1];
                                   cinq[5]:=Sr;
                             end;
   End;  (* AuSuivant *)

PROCEDURE AfficheRepCour(VAR RepCour:string);
   Begin TextAttr:=LightGray;
         GotoXY(2,2);
         Write('R‚pertoire courant: ');
         TextAttr:=White;
         Write(Complete(repcour,58));
   End;

FUNCTION AttrC(attrf:byte):str12;
 Var a:str12;
   Begin A:='';
         If Attrf and ReadOnly <>0
            Then a:=a+'LS-'
            Else a:=a+'  -';
         If Attrf and Hidden <>0
            Then a:=a+'CA-'
            Else a:=a+'  -';
         If Attrf and SysFile <>0
            Then a:=a+'SY-'
            Else a:=a+'  -';
         If Attrf and Archive <>0
            Then a:=a+'AR-'
            Else a:=a+'  -';
         AttrC:=a;
   End;

PROCEDURE AfficheCinq(VAR Cinq:T_5;nbrreps,numcour:byte);
 Var i:byte;
   Begin For i:=1 to 5 do
         begin GotoXY(CoinHGX+1,CoinHGY+i);
               If i<=nbrreps
               then begin If i=numcour
                             then TextAttr:=White+16*Blue
                             else TextAttr:=White;
                          {If cinq[i].name='..'
                             then Write('parent')
                             else }
                          Write(complete(cinq[i].name,15)+AttrC(cinq[i].attr));
                    end
               else begin TextAttr:=DarkGray;
                          Write({'indisponible'}complete('',27));
                    end;
         end;
         If nbrreps=0 then
         begin TextAttr:=LightGray;
               GotoXY(CoinHGX+1,CoinHGY+2);
               Write('   aucun    ');
               GotoXY(CoinHGX+1,CoinHGY+3);
               Write('   sous-    ');
               GotoXY(CoinHGX+1,CoinHGY+4);
               Write(' r‚pertoire ');
         end;
   End;  (* Affiche *)

PROCEDURE ModifierAttr(NomDos:str12;attr:byte);
 Var f:file;
   Begin If NomDos<>'..'
         Then begin Assign(f,NomDos);
                    {$I-}
                    SetFAttr(f,attr);
                    {$I+}
                    If IoResult<>0 then begin end;
              end;
   End;

PROCEDURE GC(Var Quitter:boolean;
             Var Cinq:T_5;
             Var nbrreps,numcour:byte;
             Var repcour:string);
 Var t:char;
     Sr:SearchRec;
     SauveNumCour:byte;
   Begin t:=readkey;
         If t<>#0 then begin t:=upcase(t);
                             Case t of
                             'A'..'Z':begin {$I-}
                                            ChDir(t+':');
                                            GetDir(0,repcour);
                                            {$I+}
                                            If IoResult<>0 then begin end;
                                            AfficheRepCour(repcour);
                                            InitCinq(repcour,cinq,nbrreps,numcour);
                                            AfficheCinq(Cinq,nbrreps,numcour);
                                      end;
                             #27:quitter:=true;
                             #13:begin {$I-}
                                       ChDir(Cinq[numcour].name);
                                       GetDir(0,repcour);
                                       {$I+}
                                       If IoResult<>0 then begin end;
                                       AfficheRepCour(repcour);
                                       InitCinq(repcour,cinq,nbrreps,numcour);
                                       AfficheCinq(Cinq,nbrreps,numcour);
                                 end;
                             End; {du case}
                       end
                  else begin t:=readkey;
                             Case t of
                             #63:begin SauveNumCour:=NumCour;
                                       Sr:=cinq[1];
                                       ModifierAttr(Cinq[NumCour].name,
                                        ($27 and Cinq[NumCour].attr) xor ReadOnly);
                                       InitCinq(repcour,cinq,nbrreps,numcour);
                                       While Cinq[1].name<>Sr.name do AuSuivant(cinq);
                                       NumCour:=SauveNumCour;
                                       AfficheCinq(Cinq,nbrreps,numcour);
                                 end;
                             #64:begin SauveNumCour:=NumCour;
                                       Sr:=cinq[1];
                                       ModifierAttr(Cinq[NumCour].name,
                                        ($27 and Cinq[NumCour].attr) xor Hidden);
                                       InitCinq(repcour,cinq,nbrreps,numcour);
                                       While Cinq[1].name<>Sr.name do AuSuivant(cinq);
                                       NumCour:=SauveNumCour;
                                       AfficheCinq(Cinq,nbrreps,numcour);
                                 end;
                             #65:begin SauveNumCour:=NumCour;
                                       Sr:=cinq[1];
                                       ModifierAttr(Cinq[NumCour].name,
                                        ($27 and Cinq[NumCour].attr) xor SysFile);
                                       InitCinq(repcour,cinq,nbrreps,numcour);
                                       While Cinq[1].name<>Sr.name do AuSuivant(cinq);
                                       NumCour:=SauveNumCour;
                                       AfficheCinq(Cinq,nbrreps,numcour);
                                 end;
                             #66:begin SauveNumCour:=NumCour;
                                       Sr:=cinq[1];
                                       ModifierAttr(Cinq[NumCour].name,
                                        ($27 and Cinq[NumCour].attr) xor Archive);
                                       InitCinq(repcour,cinq,nbrreps,numcour);
                                       While Cinq[1].name<>Sr.name do AuSuivant(cinq);
                                       NumCour:=SauveNumCour;
                                       AfficheCinq(Cinq,nbrreps,numcour);
                                 end;
                             #62:begin SauveNumCour:=NumCour;
                                       Sr:=cinq[1];
                                       ModifierAttr(Cinq[NumCour].name,0);
                                       InitCinq(repcour,cinq,nbrreps,numcour);
                                       While Cinq[1].name<>Sr.name do AuSuivant(cinq);
                                       NumCour:=SauveNumCour;
                                       AfficheCinq(Cinq,nbrreps,numcour);
                                 end;
                             #71:begin InitCinq(repcour,cinq,nbrreps,numcour);
                                       AfficheCinq(Cinq,nbrreps,numcour);
                                 end;
                             #72:begin If NbrReps<>0
                                       Then begin If NumCour>1
                                                  Then begin NumCour:=NumCour-1;
                                                             AfficheCinq(Cinq,nbrreps,numcour);
                                                       end
                                                  Else begin
                                                       end;
                                            end
                                       Else begin
                                            end;
                                 end;
                             #80:begin If NbrReps=5
                                       Then begin If NumCour=5
                                                  Then begin AuSuivant(cinq);
                                                             AfficheCinq(Cinq,nbrreps,numcour);
                                                       end
                                                  Else begin NumCour:=NumCour+1;
                                                             AfficheCinq(Cinq,nbrreps,numcour);
                                                       end;
                                            end
                                       Else begin If NumCour=NbrReps
                                                  Then begin
                                                       end
                                                  Else begin NumCour:=NumCour+1;
                                                             AfficheCinq(Cinq,nbrreps,numcour);
                                                       end;
                                            end;
                                 end;
                             End; {du case}
                       end;
   End;

PROCEDURE AfficheCommandes;
 Const lig=15;
   Begin TextAttr:=LightGray;

         GotoXY(45,CoinHGY+1); Write('  ÚÄÄ');
         GotoXY(45,CoinHGY+2); Write('  ÃÄÄ');
         GotoXY(45,CoinHGY+3); Write('ÄÄÅÄÄ');
         GotoXY(45,CoinHGY+4); Write('  ÃÄÄ');
         GotoXY(45,CoinHGY+5); Write('  ÀÄÄ');

         GotoXY(2,7);     Write('Sous-r‚pertoires du r‚pertoire courant: ');
         GotoXY(2,8);     Write('(et leurs attributs)');

         TextAttr:=Yellow+16*Blue;

         GotoXY(2,lig-1); Write(complete('A … Z        Changer d''unit‚',78));
         GotoXY(2,lig+0); Write(complete('',78));
         GotoXY(2,lig+1); Write(complete('F4           Annuler tous les attributs',78));
         GotoXY(2,lig+2); Write(complete('F5           Mettre/Annuler l''attribut lecture seule (LS)',78));
         GotoXY(2,lig+3); Write(complete('F6           Mettre/Annuler l''attribut cach‚         (CA)',78));
         GotoXY(2,lig+4); Write(complete('F7           Mettre/Annuler l''attribut systŠme       (SY)',78));
         GotoXY(2,lig+5); Write(complete('F8           Mettre/Annuler l''attribut archive       (AR)',78));
         GotoXY(2,lig+6); Write(complete('',78));
         GotoXY(2,lig+7); Write(complete('',78));
         GotoXY(2,lig+8); Write(complete('Echap        Quitter dans le r‚pertoire courant',78));
         
   End;

BEGIN TextAttr:=LightGray;
      ClrScr;
      Curseur(1,0);
      DessineCadre(1,1,78,1,LightGray);
      DessineCadre(1,13,78,10,Yellow+16*Blue);
      DessineCadre(1,CoinHGY,78,5,LightGray);
      AfficheCommandes;

      GetDir(0,RepCour);
      AfficheRepCour(repcour);

      InitCinq(repcour,cinq,nbrreps,numcour);
      AfficheCinq(Cinq,nbrreps,numcour);

      Quitter:=False;
      While not Quitter do
      begin Attendre;
            GC(Quitter,Cinq,nbrreps,numcour,repcour);
      end;
      TextAttr:=LightGray;
      ClrScr;
      Curseur(6,7);
END.