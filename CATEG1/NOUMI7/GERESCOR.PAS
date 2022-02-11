FUNCTION DetermineNomFic(cols,ligs:byte;handicap:boolean):str20;
 Var s:str20;
     c:string[2];
   Begin c:=cat(cols);
         if length(c)=1 then c:='0'+c;
         s:='C'+c+'L'+cat(ligs);
         If handicap then s:=s+'-H'
                     else s:=s+'--';
         s:=s+Ext;
         DetermineNomFic:=s;
   End;

PROCEDURE Saisir(var n:strscore);
 Var t:char;
   Begin TextAttr:=White;
         VaEnXY(0,24);
         Ecrire('Quel est votre nom ? ');
         TextAttr:=LightRed; ClrEol; Curseur(0,7);
         t:=#0; n:='';
         VideClavier;
         While t<>#13 do
               begin Attendre;
                     t:=readkey;
                     If t<>#0 then Case t of
                                        #32..#254:begin if length(n)<LongMax
                                                        then n:=n+t
                                                        else n[LongMax]:=t;
                                                  end;
                                        #27:n:='';
                                        #8:delete(n,length(n),1);
                                   End
                              else begin t:=readkey;
                                         {Case t of
                                         #38:n:='Luc Rousseau';
                                         End;}
                                   end;
                     VaEnXY(21,24); Ecrire(n);
                     ClrEol; VaEnXY(21+length(n),24);
               end;
         n:=n+ChaineDe(' ',LongMax-length(n));
         Curseur(7,0);
   End;  (* Saisir *)

PROCEDURE Reecrire(VAR F:F_Enreg);
 Var E:T_Enreg;
     i:integer;
     Ior:word;
   Begin E.nom:=ChaineDe('.',LongMax);
         E.score:=0;
         E.nblignes:=0;
         {$I-}
         Rewrite(f);
         For i:=0 to NbEnreg-1 do
             begin Write(f,E);
             end;
         Close(f);
         {$I+}
         Etudier(Ioresult);
   End;  (* Reecrire *)

PROCEDURE Modifie(VAR F:F_Enreg;score:longint;nbl:integer;n:integer);
 Var i:integer;
     Enr:T_Enreg;
     nom:strScore;
   Begin  Saisir(nom);
          {$I-}
          Reset(f);
          For i:=NbEnreg-1 downto n+1 do
              begin Seek(f,i-1);
                    Read(f,Enr);
                    Seek(f,i);
                    Write(f,Enr);
              end;
          Enr.nom:=nom; Enr.score:=score; Enr.nblignes:=nbl;
          Seek(f,n);
          Write(f,Enr);
          Close(f);
          {$I+}
          Etudier(Ioresult);
   End;  (* Modifie *)

PROCEDURE AfficheScores(VAR F:F_Enreg;n:integer);
 Const LigPrems=8;
 Var i:shortint;
     Enr:T_Enreg;
   Begin ModeVideo($1); ActivePolice(police); Curseur(7,0);
         TextAttr:=10;
         VaEnXY(1,1);    Ecrire('ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
         VaEnXY(1,2);    Ecrire('³ MEILLEURS SCORES ³');
         VaEnXY(1,3);    Ecrire('ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
         TextAttr:=12;
         VaEnXY(0,LigPrems-3); Ecrire(ChaineDe('Ä',40));
         VaEnXY(0,LigPrems-1); Ecrire(ChaineDe('Ä',40));
         TextAttr:=11;
         VaEnXY(0,LigPrems-2);  Ecrire('Rang');
         VaEnXY(6,LigPrems-2);  Ecrire('Score');
         VaEnXY(14,LigPrems-2); Ecrire('Lignes');
         VaEnXY(23,LigPrems-2); Ecrire('Nom');
         TextAttr:=12;
         For i:=0 to NbEnreg-1 do
         begin VaEnXY(4,LigPrems+i); Ecryre('³');
               VaEnXY(13,LigPrems+i); Ecryre('³');
               VaEnXY(21,LigPrems+i); Ecryre('³');
         end;
         VaEnXY(0,LigPrems+NbEnreg); Ecrire(ChaineDe('Ä',40));
         {$I-}
         Reset(f);
         Close(f);
         {$I+}
         If IoResult<>0 then Reecrire(f);
         {$I-}
         Reset(f);
         TextAttr:=15;
         For i:=1 to NbEnreg do
             begin Seek(f,i-1);
                   Read(f,Enr);
                   If i=n then TextAttr:=15
                          else TextAttr:=7;
                   VaEnXY(3-length(cat(i)),i-1+LigPrems);
                          Ecrire(cat(i));
                   VaEnXY(12-length(cat(Enr.score)),i-1+LigPrems);
                          Ecrire(cat(Enr.score));
                   VaEnXY(20-length(cat(Enr.nblignes)),i-1+LigPrems);
                          Ecrire(cat(Enr.nblignes));
                   VaEnXY(23,i-1+LigPrems);
                          Ecrire(Enr.nom);
             end;
         Close(f);
         {$I+}
         Etudier(Ioresult);
   End;  (* AfficheScores *)

PROCEDURE TestScores(VAR F:F_Enreg;score:longint;nblignes:integer);
 Var Enr:T_Enreg;
     n,i:integer;
   Begin {$I-}
         Reset(f);
         Close(f);
         {$I+}
         If IoResult<>0 then Reecrire(f);
         {$I-}
         Reset(f);
         Read(f,Enr);
         n:=0;
         While (Enr.Score>=Score) and Not Eof(f) and (n<=NbEnreg) do
               begin Read(f,Enr);
                     n:=n+1;
               end;
         Close(f);
         {$I+}
         Etudier(IoResult);
         If score>Enr.score
         Then begin Modifie(F,score,nblignes,n);
                    AfficheScores(F,n+1);
              end;
         Attendre;
         VideClavier;
   End;  (* TestScores *)