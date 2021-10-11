{$H-,R-,S-}
unit Girl1;

interface

uses
  Windows, SysUtils, Graphics, Forms, Dialogs,
  gifunit, jpeg, Classes, ExtCtrls;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
 z=80; // замедление для 800 мгц

var
Form1: TForm1;
ji: tJpegImage;
b,b1,bf,br,be:  tBitMap;
mb: array[1..30,1..2] of tBitMap;
qb: integer;
nat,wpered,stop: boolean;
qt,w1,d,j,s,x,xn,y,yn,xm,ym,nb,
h,x1,x2,hi,sir,wis,ni,j1: integer;
pf: tPixelFormat;
mh,nMain: boolean;{true-максимальная высота}
e: tCanvas;
sr: string;
g_hAppMutex: THandle;
GifFile: TGifFile;
imf:string[128];
net,
sGif, // создан Gif
gif:boolean;
df : TSearchRec;
t:cardinal;

implementation

{$R *.DFM}


function UE: boolean;
var
g_hAppCritSecMutex: THandle;
dw: Longint;
begin
g_hAppCritSecMutex :=
CreateMutex( nil, true, PChar(Application.Title+'.OneInstance32.CriticalSection'));
// if GetLastError - лениво писать
g_hAppMutex:=
CreateMutex( nil, false, PChar(Application.Title+'OneInstance32.Default'));

dw := WaitForSingleObject( g_hAppMutex, 0 );

Result :=  (dw <> WAIT_TIMEOUT);
// необязательно вследствие последующего закрытия
ReleaseMutex( g_hAppCritSecMutex );
CloseHandle( g_hAppCritSecMutex );
end;

PROCEDURE ost;
begin
if LongBool( g_hAppMutex ) then
begin
ReleaseMutex( g_hAppMutex); // необязательно
CloseHandle( g_hAppMutex );
end;
end;

PROCEDURE TForm1.FormCreate(Sender: TObject);
begin
if paramCount>0 then begin
  sr:=paramStr(1);
  if (sr[1]='/')and(sr[2] in ['p','c']) then halt;
end;
g_hAppMutex := 0;
nMain:=true;
xm:=-1;
left:=screen.width;
setwindowLong(Handle,GWL_STYLE,
getWindowLong(Handle,GWL_STYLE) and not WS_CAPTION);
ClientHeight:=Height;

nat:=true; stop:=false; timer1.enabled:=true;
end;

PROCEDURE zj(b: tbitmap; s:string);
begin
ji:=tJpegImage.create;
ji.LoadFromFile(s);
ji.dibneeded;
b.height:=ji.Height; b.width:=ji.Width;
b.canvas.Draw(0,0,ji);
ji.free;
end;

PROCEDURE c1(var src: tbitmap);
const p:integer=50{150}{128};
var
p0:pbytearray;
r,g,b,rr,gg,bb,x,x1,x2,x3,y,v: Integer;
e: boolean;
begin
pf:=src.pixelformat;
src.pixelformat:=pf24bit;

p0:=src.scanline[0]; rr:=p0[0]; gg:=p0[1]; bb:=p0[2];
w1:=0;
for y:=0 to src.Height-1 do begin
  p0:=src.scanline[y];
  x1:=0; x2:=1; x3:=2; e:=false; v:=0;
  for x:=0 to src.Width-1 do begin
    r:=p0[x1];
    g:=p0[x2];
    b:=p0[x3];
    d:=abs(r-rr)+abs(g-gg)+abs(b-bb);
    if (v=2) and (d<p)and not gif then
      begin p0[x1-3]:=rr; p0[x2-3]:=gg; p0[x3-3]:=bb; v:=0 end;

    if v=1 then begin d:=1; v:=2 end;

    if d>p then begin
       e:=true;
       if v=0 then begin  v:=1; d:=1; end;
    end;

    if (d<p) and not gif then begin
      if (d>0) then begin
      p0[x1]:=rr;
      p0[x2]:=gg;
      p0[x3]:=bb;
    end;
    end;

    inc(x1,3); inc(x2,3); inc(x3,3);
  end;
  if e then w1:=y-1;
end;
src.pixelformat:=pf;
if w1=0 then w1:=src.Height;
end;

PROCEDURE soz;
var n,x,y:integer; ns:string[4];
begin
//Служебная процедура
//Создание из нескольких картинок одной для этой программы
b:=graphics.tBitmap.create;
b1:=graphics.tBitmap.create;
b.height:=800; b.width:=2000;
n:=0;
for y:=1 to 2 do for x:=1 to 10 do begin
  inc(n);
  ns:=intToStr(n); while length(ns)<4 do ns:='0'+ns;
  b1.loadFromFile('идет___'+ns+'.bmp');
  xn:=(x-1)*200; yn:=(y-1)*400;
  b.canvas.copyRect(rect(xn,yn,xn+200,yn+400),
    b1.canvas,rect(0,0,200,400));
   Application.processMessages;
end;
b.saveToFile('идет_.bmp');
b.free;
b1.free;
halt;
end;

PROCEDURE zKAR;
var powtor:boolean;
begin
repeat
powtor:=false;
imf:='';
if paramCount>0 then imf:=paramstr(1);
if (imf[1]='/')and(imf[2]='n')
  then begin wpered:=false; delete(imf,1,2) end;
if (imf='')or(imf[1]='/')then imf:='i'+intToStr(ni)+'.gif';

if pos('\',imf)=0 then
  imf:=extractFilePath(paramstr(0))+imf;
imf:=upperCase(imf);
if findfirst(imf,faAnyFile,df)<>0 then begin
  if ni=0 then begin
    showMessage('Не нашла картинку '+imf);
    halt;
  end;
  ni:=0;
  powtor:=true;
end;
until not powtor;

gif:=extractFileExt(imf)='.GIF';
if Gif then begin
  GifFile:= TGifFile.Create;
  GifFile.LoadFromFile(imf);
  b.height:=GifFile.AsBitmap.height;
  b.width :=GifFile.AsBitmap.Width;
  b.canvas.Draw(0,0,GifFile.AsBitmap);
  c1(b);
end
else begin
if extractFileExt(imf)<>'.JPG' then begin
  showMessage('Файл с картинкой должен быть'+#13#10+
  'GIF или JPG, а не'+#13#10+imf);
  application.terminate;
end;

ji:=tJpegImage.create;
ji.LoadFromFile(imf);
ji.dibneeded;
b.height:=ji.Height; b.width:=ji.Width;
b.canvas.Draw(0,0,ji);
ji.free;
c1(b);
end;
wis:=400; sir:=200; d:=12; j1:=b.height-w1;
h:=screen.height-400+j1;
if mh then begin
  hi:=b.height div 2 - j1;
  wis:=screen.height;
  sir:=200*wis div hi;
  h:=j1*wis div hi;
  d:=d*wis div hi;
end;

end;

PROCEDURE main;
var x,y,i:integer;
begin
if not UE then begin ost; halt end;
mh:=false;//true;
if paramstr(1)='/i' then soz;
wpered:=true;
ni:=0; sGif:=false;
b:=graphics.tBitmap.create;
zKAR;

e:=tCanvas.create;
e.Handle:=GetDC(0);

setBKmode(e.Handle,Transparent);

be:=tBitmap.create;

be.width:=screen.width; be.height:=screen.height;

with be do
canvas.copyRect(rect(0,0,width,height),e,rect(0,0,width,height));

with form1 do begin
 width:=screen.width; height:=screen.Height; left:=0; top:=0;
 canvas.copyRect(rect(0,0,width,height),be.canvas,rect(0,0,width,height));
 visible:=true;
 Application.processMessages;
end;


br:=graphics.tBitmap.create;
br.width:=screen.width; br.height:=screen.height;
nMain:=false;
with form1.Canvas do begin
if wpered then s:=-sir *3 div 4
          else s:=screen.width;

/// Заполнение заранее
qb:=0;
for y:=0 to 1 do
for x:=0 to 9 do begin
  xn:=x*200; yn:=y*400;
  x1:=xn; x2:=xn+200;
  inc(qb);
  mb[qb,1]:=tBitMap.create;
  mb[qb,1].width:=sir;
  mb[qb,1].height:=wis;
  mb[qb,1].Transparent:=True;
  mb[qb,1].TransParentColor := b.canvas.pixels[0,0];
  mb[qb,1].canvas.copyRect(rect(0,0,sir,wis),
  b.canvas,rect(x1,yn,x2,yn+400));
  mb[qb,1].width:=sir-2;
  mb[qb,2]:=tBitMap.create;
  mb[qb,2].width:=sir;
  mb[qb,2].height:=wis;
  mb[qb,2].Transparent:=True;
  mb[qb,2].TransParentColor := b.canvas.pixels[0,0];
  mb[qb,2].canvas.copyRect(rect(0,0,sir,wis),
  b.canvas,rect(x2,yn,x1,yn+400));
  mb[qb,2].width:=sir-2;
end;
b.free;

br.canvas.draw(0,0,be);

repeat
nB:=0;
for y:=0 to 1 do
for x:=0 to 9 do begin
//задержка
  t:=getTickCount+z;  while getTickCount<=t do application.processMessages;
  qt:=0;
  inc(nb);
   br.canvas.draw(0,0,be);
    if wpered then i:=1 else i:=2;
    br.canvas.draw(s,h,mb[nb,i]);
   draw(0,0,br);
  if wpered then inc(s,d) else dec(s,d);
  if (s>screen.width-50)or(s<-sir+50) then begin
    if wpered then s:=screen.width - sir div 3 else s:=-sir *2 div 5;
    wpered:=not wpered;
  draw(0,0,be);
  if stop then begin  be.free; b1.free; br.free; ost; halt end;
  sgif:=true;
end;
end;
until false;
end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
inc(qt);
if nat then begin nat:=false; main end;
end;

PROCEDURE ost1;
begin
stop:=true; d:=d*5;
form1.timer1.interval:=0;
form1.canvas.draw(0,0,be);
wpered:=not wpered;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
if stop then exit;
if (xm<>y)and(ym<>y)and(xm>=0) then
ost1;
xm:=x; ym:=y;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
ost1
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
ost1;
end;

end.
