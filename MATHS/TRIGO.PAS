FUNCTION tan(x:real):real;
   Begin tan:=sin(x)/cos(x);
   End;

FUNCTION arcsin(x:real):real;
   Begin arcsin:=arctan(x/sqrt(1-x*x)); End;

FUNCTION arccos(x:real):real;
   Begin arccos:=pi/2-arctan(x/sqrt(1-x*x)); End;

FUNCTION sh(x:real):real;
   Begin sh:=(exp(x)-exp(-x))/2; End;

FUNCTION ch(x:real):real;
   Begin ch:=(exp(x)+exp(-x))/2; End;

FUNCTION th(x:real):real;
   Begin th:=(exp(x)-exp(-x))/(exp(x)+exp(-x)); End;

FUNCTION argsh(x:real):real;
   Begin argsh:=ln(x/sqrt(x*x+1)); End;

FUNCTION argch(x:real):real;
   Begin argch:=ln(x+sqrt(x*x+1)); End;

FUNCTION argth(x:real):real;
   Begin argth:=0.5*ln((1+x)/(1-x)); End;
