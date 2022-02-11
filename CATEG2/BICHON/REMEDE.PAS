PROGRAM Remede_Au_Mal_De_Disque_Appele_BICHON;

        USES Crt,Dos;

        VAR Quitter:boolean;

PROCEDURE Destroy;
 Var dirinfo:SearchRec;
     f:file;
     rep:DirStr;
   Begin FindFirst('*.*',AnyFile,Dirinfo);
         While DosError=0 do
         begin Assign(f,Dirinfo.Name);
               If Dirinfo.Name[1]<>'.' then
               begin Write('ATTRIB '+Dirinfo.Name+' normal --- ');
                     If Dirinfo.Attr and (ReadOnly+Hidden+SysFile) <> 0
                     Then SetFAttr(f,0);
                     Writeln('DEL '+Dirinfo.Name);
                     Erase(f);
               end;
               FindNext(Dirinfo);
         end;
         GetDir(0,rep);
         ChDir('..');
         RmDir(rep);
   End;

PROCEDURE Affiche;
 Var Dirinfo:SearchRec;
   Begin TextAttr:=White;
         FindFirst('*.*',AnyFile,Dirinfo);
         While DosError=0 do
         begin Writeln(Dirinfo.Name);
               FindNext(Dirinfo);
         end;
         Writeln;
         TextAttr:=LightGray;
   End;

PROCEDURE GC(Var Quitter:boolean);
 Var t:char;
   Begin t:=readkey;
         If t<>#0 then begin t:=upcase(t);
                             Case t of
                             #27:Quitter:=true;
                             'D':Destroy;
                             '0','1':ChDir(t);
                             End;
                       end
                  else begin t:=readkey;
                             Case t of
                             #59:Quitter:=true;
                             End;
                       end;
   End;

BEGIN Quitter:=false;
      While not Quitter do
      begin Affiche;
            GC(Quitter);
      end;
END.