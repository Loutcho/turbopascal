PROGRAM EditeurDeRegistresDeCouleursDAC;

        USES Crt,Dos;

        CONST CoteX=20;
              CoteY=20;

        TYPE T_RVB          =    Record Rouge,Vert,Bleu:byte End;
             T_RegistresDAC =    Array[0..255] of T_RVB;
             F_RegistresDAC =    File Of T_RegistresDAC;

        VAR  F:F_RegistresDAC;
             Tampon:T_RegistresDAC;
             Quitter:boolean;
             x:byte;
             NomDos:string;

{$I  INTECRAN.PAS}

FUNCTION Cat(n:word):string;
 Var s:string;
   Begin str(n,s);
         Cat:=s;
   End;

PROCEDURE SaisirChaine(x,y:byte;message:string;
                    var Chaine :string;var Ok:boolean);
 Var Valider,Avorter:boolean;
     t:char;
   Begin Chaine:='';Chaine[0]:=#0;
         VaEnXY(x,y);
         Ecrire(message);
         Valider:=false; Avorter:=false;
         While not Valider and not Avorter do
         begin VaEnXY(x+length(message),y);
               Ecrire(Chaine);
               Repeat until keypressed;
               t:=readkey;
               If t<>#0 then Case upcase(t) of
                                  #27:begin Avorter:=true;
                                            Ok:=false;
                                      end;
                                  #13:begin Valider:=true;
                                            Ok:=true;
                                      end;
                                  #32..#255:Chaine:=Chaine+t;
                                  #8:begin VaEnXY(x+length(message)+length(chaine)-1,y);
                                           Ecryre(' ');
                                           delete(chaine,length(chaine),1);
                                     end;
                             End
                        else begin t:=readkey;
                                   Case t of
                                   #71:Chaine:='';
                                   End;
                             end;
         end;
         TextAttr:=0;
         VaEnXY(x,y);
         Ecrire(message+chaine);
   End;

PROCEDURE RegistresDACDefaut(b:boolean);
 Var reg:registers;
   Begin reg.ah:=$12;
         reg.bl:=$31;
         If b then reg.al:=0
              else reg.al:=1;
         Intr($10,reg);
   End;

PROCEDURE InitTampon(var tampon:T_RegistresDAC);
 Var i:byte;
     reg:registers;
   Begin For i:=0 to 255 do
         begin reg.ah:=$10;
               reg.al:=$15;
               reg.bx:=i;
               Intr($10,reg);
               With tampon[i] do
               begin rouge:=reg.dh;
                     vert :=reg.ch;
                     bleu :=reg.cl;
               end;
         end;
   End;

PROCEDURE CreeFichierDAC(NomDos:string;VAR tampon:T_RegistresDAC);
 Var i:byte;
     rvb:T_RVB;
     f:F_RegistresDAC;
   Begin Assign(f,NomDos);
         {$I-}
         Rewrite(f);
         Write(f,tampon);
         Close(f);
         {$I+}
         If IoResult<>0 then Write(#7);
   End;

PROCEDURE LitFichierDAC(NomDos:string;var tampon:T_RegistresDAC);
 Var f:F_RegistresDAC;
   Begin Assign(f,NomDos);
         {$I-}
         Reset(f);
         Read(f,tampon);
         Close(f);
         {$I+}
         If IoResult<>0 then Write(#7);
   End;

PROCEDURE ActiveRegistreDAC(n:byte;rvb:T_RVB);
 Var reg:registers;
   Begin reg.ah:=$10;
         reg.al:=$10;
         reg.bx:=n;
         reg.ch:=rvb.vert;
         reg.cl:=rvb.bleu;
         reg.dh:=rvb.rouge;
         Intr($10,reg);
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

PROCEDURE CadreDeTravail;
   Begin TextAttr:=255;
         Ligne(0,17*CoteY,639,17*CoteY,255);
         Ligne(17*CoteX,0,17*CoteX,17*CoteY,255);
         Ligne(0,400,639,400,255);
         VaEnXY(1,28);  Ecrire('DAC[');
         VaEnXY(1,30);  Ecrire('ROUGE : ');
         VaEnXY(21,30); Ecrire('VERT  : ');
         VaEnXY(41,30); Ecrire('BLEU  : ');
         VaEnXY(1,24);  Ecrire('NOM : ');
   End;

PROCEDURE Palette;
 Var i:byte;
   Begin For i:=0 to 255 do
         RectanglePlein(CoteX*(i mod 16)+2,CoteY*(i div 16)+2,
                        CoteX*(i mod 16+1)-2,CoteY*(i div 16+1)-2,i);
   End;

PROCEDURE AfficheInfos(x:byte;rvb:T_RVB;NomDos:string);
   Begin TextAttr:=255;
         VaEnXY(5,28);  Ecrire(cat(x)+']  ');
         VaEnXY(9,30);  Ecrire(cat(rvb.rouge)+'  ');
         VaEnXY(29,30); Ecrire(cat(rvb.vert) +'  ');
         VaEnXY(49,30); Ecrire(cat(rvb.bleu) +'  ');
         VaEnXY(10,24);  Ecrire(NomDos);
   End;

PROCEDURE Circulaire(var b:byte;incr:shortint;min,max:byte);
   Begin If incr>0
         Then If b+incr<=max then b:=b+incr
                            else b:=min
         Else If b+incr>=min then b:=b+incr
                            else b:=max;
   End;

PROCEDURE GC(var Quitter:boolean;var tampon:T_RegistresDAC;var x:byte;
             var NomDos:string);
 Var t:char;
     Chaine:string;
     Ok:boolean;
   Begin t:=readkey;
         RectangleVide(CoteX*(x mod 16),CoteY*(x div 16),
                        CoteX*(x mod 16+1),CoteY*(x div 16+1),0);
         If t<>#0 then begin Case upcase(t) of
                             #27:begin TextAttr:=255;
                                       SaisirChaine(50,3,'Voulez-vous quitter? ',
                                                    Chaine,Ok);
                                       quitter:=Ok and (upcase(Chaine[1])='O');
                                 end;
                             '7':Circulaire(tampon[x].rouge,1,0,63);
                             '1':Circulaire(tampon[x].rouge,-1,0,63);
                             '8':Circulaire(tampon[x].vert,1,0,63);
                             '2':Circulaire(tampon[x].vert,-1,0,63);
                             '9':Circulaire(tampon[x].bleu,1,0,63);
                             '3':Circulaire(tampon[x].bleu,-1,0,63);
                             '4':if tampon[x].rouge<>0
                                    then tampon[x].rouge:=0
                                    else tampon[x].rouge:=31;
                             '5':if tampon[x].vert <>0
                                    then tampon[x].vert :=0
                                    else tampon[x].vert :=31;
                             '6':if tampon[x].bleu <>0
                                    then tampon[x].bleu :=0
                                    else tampon[x].bleu :=31;
                             '0':begin tampon[x].rouge:=0;
                                       tampon[x].vert :=0;
                                       tampon[x].bleu :=0;
                                 end;
                             End;
                       end
                  else begin t:=readkey;
                             Case t of
                             #60:begin TextAttr:=255;
                                       SaisirChaine(50,3,'Sauvegarder : ',Chaine,Ok);
                                       If Ok then CreeFichierDAC(Chaine,tampon);
                                 end;
                             #61:begin TextAttr:=255;
                                       SaisirChaine(50,3,'Charger : ',Chaine,Ok);
                                       If Ok then begin LitFichierDAC(Chaine,tampon);
                                                        ActiveTampon(tampon);
                                                        NomDos:=Chaine+'         ';
                                                  end;
                                 end;
                             #63:begin t:=readkey;
                                       tampon[x].rouge:=ord(t);
                                 end;
                             #64:begin t:=readkey;
                                       tampon[x].vert :=ord(t);
                                 end;
                             #65:begin t:=readkey;
                                       tampon[x].bleu :=ord(t);
                                 end;
                             #66:begin t:=readkey;
                                       tampon[x].rouge:=ord(t);
                                       tampon[x].bleu :=ord(t);
                                       tampon[x].vert :=ord(t);
                                 end;
                             #75:x:=(x-1) mod 256;
                             #77:x:=(x+1) mod 256;
                             #72:x:=(x-16) mod 256;
                             #80:x:=(x+16) mod 256;
                             End;
                       end;
   End;

BEGIN Randomize;    (* Initialisation du g‚n‚rateur de nombres al‚atoires *)
      Assign(f,'FICHIER.DAC');  (* Liaison logique entre NomDos et Handle *)
      ModeVideo($5F);           (* Initialisation du mode vid‚o *)
      Ligne(639,479,0,0,15);
      RegistresDACDefaut(false);
      LitFichierDAC(ParamStr(1),tampon);
      ActiveTampon(tampon);     (* Activation du tampon *)
      x:=0;
      NomDos:=ParamStr(1);
      CadreDeTravail;
      AfficheInfos(x,tampon[x],NomDos);
      Palette;

      Quitter:=false;
      While not Quitter do
      begin RectangleVide(CoteX*(x mod 16),CoteY*(x div 16),
                        CoteX*(x mod 16+1),CoteY*(x div 16+1),255);
            GC(quitter,tampon,x,NomDos);
            AfficheInfos(x,tampon[x],NomDos);
            ActiveRegistreDAC(x,tampon[x]);
      end;
      RegistresDACDefaut(true);
      ModeVideo($3);
END.