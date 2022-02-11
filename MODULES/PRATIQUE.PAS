PROCEDURE Attendre;
   Begin While not keypressed do;
   End;

PROCEDURE VideClavier;
 Var t:char;
   Begin While keypressed do t:=readkey;;
   End;

FUNCTION Cat(n:longint):string;
 Var s:string;
   Begin Str(n,s);
         Cat:=s;
   End;

{FUNCTION Etat(b:boolean):str4;
   Begin If b then Etat:='Oui '
              else Etat:='Non ';
   End;}

{FUNCTION ChaineDe(c:char;n:byte):string;
 Var s:string;
   Begin s:='';
         While length(s)<n do s:=s+c;
         ChaineDe:=s;
   End;}

{FUNCTION LeadingZero(w : Word) : String;
 Var s : String;
   Begin Str(w:0,s);
         IF Length(s) = 1 THEN
         s := '0' + s;
         LeadingZero := s;
   End;}