PROCEDURE LectureDe(var niveau,cols,ligs:byte;var tempo:word);
 Var f:File Of Byte;
     tempoH,tempoL:byte;
   Begin Assign(f,'CONFIG'+ext);
         {$I-}
         Reset(f);
         Read(f,niveau);
         Read(f,cols);   Read(f,ligs);
         Read(f,TempoH); Read(f,tempoL);
         Close(f);
         {$I+}
         If IoResult<>0 then
            begin niveau:=NivMin;
                  cols:=10; Ligs:=LigsMax;
                  Tempo:=5000;
            end
            else  Tempo:=TempoH*256+TempoL;
   End;

PROCEDURE Attendre;
   Begin Repeat until keypressed;
   End;

PROCEDURE VideClavier;
 Var t:char;
   Begin If keypressed then Repeat t:=readkey until not keypressed;
   End;

FUNCTION Cat(n:longint):string;
 Var s:string;
   Begin Str(n,s);
         Cat:=s;
   End;

FUNCTION Etat(b:boolean):str4;
   Begin If b then Etat:='Oui '
              else Etat:='Non ';
   End;

FUNCTION ChaineDe(c:char;n:byte):string;
 Var s:string;
   Begin s:='';
         While length(s)<n do s:=s+c;
         ChaineDe:=s;
   End;

FUNCTION LeadingZero(w : Word) : String;
 Var s : String;
   Begin Str(w:0,s);
         IF Length(s) = 1 THEN
         s := '0' + s;
         LeadingZero := s;
   End;

FUNCTION ChaineHeure(h,m,s:word):str20;
 Var st:str20;
   Begin st:=LeadingZero(h)+':'+LeadingZero(m)+':'+LeadingZero(s);
         ChaineHeure:=st;
   End;