PROGRAM DessinDeCourbesIntegrales;

        USES Crt,Graph;

        VAR TG,XH,TD,XB:real;

PROCEDURE ModeGraphique;
 Var Gd,Gm:integer;
   Begin Gd:=VGA; Gm:=VGAHI;
         InitGraph(Gd,Gm,'');
         If GraphResult<>GrOk
         Then Halt;
   End;

FUNCTION f(t,x:real):real;
   Begin f:=cos(t*sin(t));
   End;

PROCEDURE Place(t,x:real);
 Var xx,yy:integer;
   Begin xx:=round(640*(t-TG)/(TD-TG));
         yy:=round(480*(x-XH)/(XB-XH));
         MoveTo(xx,yy);
         PutPixel(xx,yy,TextAttr);
   End;

PROCEDURE Deplace(t,x:real);
 Var xx,yy:integer;
   Begin xx:=round(640*(t-TG)/(TD-TG));
         yy:=round(480*(x-XH)/(XB-XH));
         LineTo(xx,yy);
   End;

PROCEDURE TraceAxes;
   Begin SetColor(LightRed);
         Place(TG,0); Deplace(TD,0);
         Place(0,XB); Deplace(0,XH);
         SetColor(TextAttr);
   End;

PROCEDURE TraceCourbe(t0,t1,xx,xmin,xmax,pas:real);
{                      ³  ³  ÀÄ condition initiale en t=t0 si pas>0, }
{                      ³  ³     en t=t1 sinon                        }
{                      ³  ÀÄÄÄÄ borne sup‚rieure de l'intervalle     }
{                      ÀÄÄÄÄÄÄÄ borne inf‚rieure de l'intervalle     }
 Var t,x:real;
   Begin If pas>0
         then begin t:=t0; x:=xx;
                    Place(t,x);
                    While (t<=t1) {and (x<=xmax)}
                          and not keypressed do
                    begin x:=x+pas*f(t,x);
                          t:=t+pas;
                          Deplace(t,x);
                    end;
              end
         else begin t:=t1; x:=xx;
                    Place(t,x);
                    While (t>=t0) and (x>=xmin)
                          and not keypressed do
                    begin x:=x+pas*f(t,x);
                          t:=t+pas;
                          Deplace(t,x);
                    end;
              end;
   End;

BEGIN ModeGraphique;
      TextAttr:=White;
      TG:=0;
      XH:=2;
      TD:=40;
      XB:=-1;
      TraceAxes;
      TraceCourbe(0,40,0,-5,5,0.01);
END.