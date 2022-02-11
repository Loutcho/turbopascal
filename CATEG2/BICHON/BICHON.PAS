PROGRAM QuiCreeUneArborescenceBinaire; (* utilisez une disquette vierge *)

        USES Crt,Dos;

        VAR s,rep,fin:string;       ch:string;
            f:text;
            nivs:byte;
            code:integer;

PROCEDURE Incremente(var s:string);
 Var x:byte;
   Begin x:=length(s);
         While (x>1) and (s[x]='1') do
         begin s[x]:='0';
               x:=x-2;
         end;
         If (x=1) and (s[1]='1') then
         begin s[x]:='0';
               s:='0\'+s;
         end
         Else s[x]:='1';
   End;

BEGIN TextAttr:=LightGray;
      If ParamCount<>2 then
           begin Writeln('Syntaxe:');
                 Writeln('BICHON Unit‚ NbNiveaux');
                 Writeln(#13+#10+'Exemple:');
                 Writeln('BICHON C:\BICHON 3');
                 Halt;
           end
      Else begin rep:=ParamStr(1);
                 Val(ParamStr(2),nivs,code);
                 If Code<>0 then begin Writeln('Sp‚cification du nombre de niveaux incorrect');
                                       Halt(1);
                                 end;
           end;
      ChDir(rep);
      s:='0';
      fin:='';
      For code:=1 to nivs+1 do fin:=fin+'0\';
      If length(fin)<>0 then fin[0]:=chr(ord(fin[0])-1);
      GetDir(0,rep);
      TextAttr:=Yellow; Writeln(rep); TextAttr:=LightGray;
      While s<>fin do
      begin Write('ÃÄÄÄÄÄÄÄÄÄÄÄÄÄ');
            TextAttr:=Yellow;
            Writeln(s);
            TextAttr:=LightGray;
            Writeln('³');
            Writeln('³ þ1þ CREATION du r‚pertoire '+s);
            {$I-}
            MkDir(s);
            {$I+}
            If IoResult<>0 then
               begin Writeln('Erreur de cr‚ation');
                     Halt;
               end;
            Writeln('³ þ2þ CREATION du fichier TRALALA.!!!');
            Assign(f,s+'\TRALALA.!!!');
            Rewrite(f);
            ch:='Bonne chance!';
            Write(f,ch);
            Close(f);
            Writeln('³ þ3þ ATTRIBUTION lecture-seule au fichier TRALALA.!!!');
            SetFAttr(f,ReadOnly+Hidden);
            Incremente(s);
            Writeln('³');
      end;
      Writeln('ÀÄÄÄÄÄÄÄÄÄÄÄÄÄ'+#13+#10);
      Writeln('Ex‚cution de BICHON termin‚e.');
END.