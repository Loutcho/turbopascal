FUNCTION TypeDePC:byte;
   Begin TypeDePC:=Mem[$F000:$FFFE];
   End; (* TypeDePC *)

FUNCTION Configuration:word;
 Var r:registers;
   Begin Intr($11,r);
         Configuration:=r.ax;
   End; (* Configuration *)

FUNCTION ExisteLectDisq(conf:word):boolean;
   Begin ExisteLectDisq:=((conf and 1) = 1)
   End; (* ExisteLectDisq *)

FUNCTION ExisteCoproc(tpc:byte;conf:word):boolean;
   Begin Case tpc of
              $FC:begin ExisteCoproc:=((conf and 2)=2);
                  end;
         Else begin ExisteCoproc:=false;
              end;
         End;
   End; (* ExisteCoproc *)

FUNCTION NumModeVideoSys(conf:word):byte;
   Begin NumModeVideoSys:=((conf and $0030) shr 4);
   End; (* NumModeVideoSys *)

FUNCTION NbLectDisq(conf:word):byte;
   Begin NbLectDisq:=((conf and $00C0) shr 6)+1;
   End; (* NbLectDisq *)

FUNCTION NbPortsSerie(conf:word):byte;
   Begin NbPortsSerie:=((conf and $0E00) shr 9)
   End; (* NbPortsSerie *)

FUNCTION NbPortsParalleles(conf:word):byte;
   Begin NbPortsParalleles:=((conf and $C000) shr 14)
   End; (* NbPortsParalleles *)

FUNCTION TailleRAM:word;
 Var r:registers;
   Begin Intr($12,r);
         TailleRAM:=r.ax;
   End; (* TailleRAM *)

FUNCTION TailleRAMsuppl:word;
 Var r:registers;
   Begin r.ah:=$88;
         Intr($15,r);
         TailleRAMsuppl:=r.ax;
   End; (* TailleRAM *)

FUNCTION VersionDOS:real;
 Var r:registers;
   Begin r.ah:=$30;
         Intr($21,r);
         If r.al=0 then VersionDOS:=1
                   else VersionDOS:=r.al+0.01*r.ah;
   End; (* VersionDOS *)