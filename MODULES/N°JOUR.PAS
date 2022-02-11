program tryalgo;
uses crt;

var
  nj : byte;
  jour,mois,annee : integer;

function NoJour(j,m,a : integer) : byte;
{ 0 = dimanche, etc...}
var
  an,siecle,nb,js : integer;
begin
  if (m > 2) then dec(m,2) else
  begin
    inc(m,10);
    dec(a);
  end;
  an := a mod 100;
  siecle := trunc(a/100);
  nb := trunc((13*m-1)/5)+trunc(an/4)+trunc(siecle/4);
  js := (nb+an+j-(2*siecle)) mod 7;
  NoJour := js;
end; {fin func nojour}

begin
  clrscr;
  write('Jour, mois, ann‚e : ');readln(jour,mois,annee);
  nj := nojour(jour,mois,annee);
  write(nj,'  ',jour,mois,annee);
  readln;
end.