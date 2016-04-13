unit zubkoleso;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
 System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  ComObj, math, Vcl.Samples.Spin, CommonUnit;

type
  Wheels = array of array of Double;
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Edit3: TEdit;
    Label3: TLabel;
    Edit4: TEdit;
    Label4: TLabel;
    SpinEdit1: TSpinEdit;
    Button2: TButton;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ma: Wheels;
  A1: OleVariant;
  qwerty: array of double;
  wheel1color, wheel2color, foncolor: TColor;
  x0, y0, delx, dely: integer;
  mashtab: Integer;
  koleso, koleso1, koleso0, koleso10: Wheels;
  I, z1, z2: Integer;
  m, alfa, x: extended;
  J: Integer;
  bit: TBitmap;
  ugol: integer;
  h: extended;
  eps: extended;
  r: extended;
  rb: extended;
  ra: extended;
  rf: extended;
  a: extended;
  ro: extended;
  t00: extended;
  t01: extended;
  t02: extended;
  t03: extended;
  t04: extended;
  t05: extended;
  S1: Extended;
  S2: Extended;
  S3: Extended;
  S4: Extended;
  Form1: TForm1;

implementation
 uses CosmosWorksLib_TLB, SldWorks_TLB, SwConst_TLB;
{$R *.dfm}

function d(t1, m, alfa:extended): extended;
begin
  Result:=r*t1-Pi*m/4;
end;

function p(t1,m, alfa:extended): extended;
begin
  Result:=d(t1,m, alfa)*Cos(DegToRad(alfa))+eps*Sin(DegToRad(alfa));
end;

function b(t2, m, alfa:extended): extended;
begin
  Result:=r*t2-Pi*m/4+h*Tan(DegToRad(alfa))+ro*(1-Sin(DegToRad(alfa)))/Cos(DegToRad(alfa));
end;

function b1(t2,m, alfa:extended): extended;
begin
  Result:=Sqrt(Sqr(a)+Sqr(b(t2,m, alfa)));
end;

function xe(t1,m, alfa: extended): Extended;
begin
  Result:=r*Sin(t1)-p(t1,m, alfa)*Cos(t1+DegToRad(alfa));
end;

function ye(t1, m, alfa: extended): Extended;
begin
  Result:=r*Cos(t1)+p(t1,m, alfa)*Sin(t1+DegToRad(alfa));
end;

function xv(t2,m, alfa: extended): Extended;
begin
  Result:=r*Sin(t2)+((1+ro/b1(t2,m, alfa))*(a*Sin(t2)-b(t2,m, alfa)*Cos(t2)));
end;

function yv(t2,m, alfa: extended): Extended;
begin
  Result:=r*Cos(t2)+((1+ro/b1(t2,m, alfa))*(a*Cos(t2)+b(t2,m, alfa)*Sin(t2)));
end;

function formuls(m, alfa, x: extended; z: integer):Wheels;
var
  count: Integer;
  t1, t2: extended;
  masx, masy, masx0, masy0, masx1, masy1, masx10, masy10: array of Extended;
  masx2, masy2, masx22, masy22: array of array of Extended;
  MasPolygon: wheels;
  I: Integer;
  J, c: Integer;
  Mas: Wheels;
begin //процедура расчета контура колеса
  count:=0;
  eps:=x*m;
  h:=1.25*m;
  r:=z*m/2;
  ro:=0.38*m;
  rb:=r*Cos(DegToRad(alfa));
  rf:=r-h+eps;
  ra:=r+m+eps;
  a:=eps-h+ro;
  t00:=(Pi*m/4-(r+eps)*Tan(DegToRad(alfa)))/r;
  t01:=(Pi*m/4-h*Tan(DegToRad(alfa))-ro*(1-Sin(DegToRad(alfa)))/Cos(DegToRad(alfa)))/r;
  t02:=(Pi*m/4-(h-eps*Sqr(Cos(DegToRad(alfa)))-ro*(1-Sin(DegToRad(alfa))))/(Cos(DegToRad(alfa))*Sin(DegToRad(alfa))))/r;
  t03:=(Pi*m/4-(r-eps)*Tan(DegToRad(alfa))+Sqrt(Sqr(ra)-Sqr(r)*Sqr(Cos(DegToRad(alfa))))/Cos(DegToRad(alfa)))/r;
  t04:=a*Sin(xe(t03,m, alfa)/ra);
  t05:=2*Pi/2-t04;
  S1:=2*t01/10;
  S2:=(t05-t04)/10;
  S3:=(t01-t02)/10;
  S4:=(t03-t02)/10;

  t1:=t02;
  t2:=t02;

  while t1<(t03+0.001) do
    begin
      SetLength(masx,count+1);
      SetLength(masy,count+1);
      masx[count]:=xe(t1,m, alfa);
      masy[count]:=ye(t1,m, alfa);
      count:=count+1;
      t1:=t1+S4;
    end;
  count:=0;
  while t2<(t01+0.001) do
    begin
      SetLength(masx1,count+1);
      SetLength(masy1,count+1);
      masx1[count]:=xv(t2,m, alfa);
      masy1[count]:=yv(t2,m, alfa);
      count:=count+1;
      t2:=t2+S3;
    end;

  SetLength(masx2,length(masy),z);
  SetLength(masy2,length(masy),z);
  SetLength(masx22,length(masy),z);
  SetLength(masy22,length(masy),z);
  SetLength(masx10,length(masx1));
  SetLength(masy10,length(masx1));
  SetLength(mas,length(masy)+length(masy)+length(masx1)+length(masx1),2);
  i:=0;
    begin
      count:=0;
      for J := Length(masx2)-1 downto 0 do
        begin
          masx2[j,i]:=masx[j]*Cos(DegToRad((360/z)*i))-masy[j]*Sin(DegToRad((360/z)*i));
          masy2[j,i]:=masx[j]*Sin(DegToRad((360/z)*i))+masy[j]*Cos(DegToRad((360/z)*i));
          Mas[count,0]:=masx2[j,i];
          Mas[count,1]:=masy2[j,i];
          count:=count+1;
        end;
      for J := 0 to Length(masx10)-1 do
        begin
          masx10[j]:=masx1[j]*Cos(DegToRad((360/z)*i))-masy1[j]*Sin(DegToRad((360/z)*i));
          masy10[j]:=masx1[j]*Sin(DegToRad((360/z)*i))+masy1[j]*Cos(DegToRad((360/z)*i));
          Mas[count,0]:=masx10[j];
          Mas[count,1]:=masy10[j];
          count:=count+1;
        end;
      for J := Length(masx10)-1 downto 0 do
        begin
          masx10[j]:=-masx1[j]*Cos(DegToRad((360/z)*i))-masy1[j]*Sin(DegToRad((360/z)*i));
          masy10[j]:=-masx1[j]*Sin(DegToRad((360/z)*i))+masy1[j]*Cos(DegToRad((360/z)*i));
          Mas[count,0]:=masx10[j];
           Mas[count,1]:=masy10[j];
          count:=count+1;
        end;
      for J := 0 to Length(masx2)-1 do
        begin
          masx22[j,i]:=-masx[j]*Cos(DegToRad((360/z)*i))-masy[j]*Sin(DegToRad((360/z)*i));
          masy22[j,i]:=-masx[j]*Sin(DegToRad((360/z)*i))+masy[j]*Cos(DegToRad((360/z)*i));
          Mas[count,0]:=masx22[j,i];
          Mas[count,1]:=masy22[j,i];
          count:=count+1;
        end;
    end;
  Result:=Mas;
end;

procedure DrawKol(m, x, b: extended; z: integer);
var
  e: integer;
  d, da, ra, r, angle: extended;
  SW: ISldWorks;
  ID: IDispatch;
  MD: IModelDoc2;
  CP: ISketchPoint;
  Points: array [0 .. 10] of ISketchPoint;
  Lines: array [0 .. 10] of ISketchSegment;
  SelMgr: ISelectionMgr;
begin
  d := m * z;
  r := d / 2;
  da := d + m*2*x;
  ra := da / 2;
  if z < 40 then
    angle := 50;
  if z >= 40 then
    angle := 40;
  SW := CreateOleObject('SldWorks.Application') as ISldWorks;
//  if SW = nil then
//    hr := E_OutOfMemory;

  If SW.Visible = false then
    SW.Visible := true;

  ID := SW.NewDocument
    ('C:\ProgramData\SolidWorks\SOLIDWORKS 2016\templates\gost-part.prtdot', 0,
    0, 0);
  ID := SW.ActivateDoc2('Колесо зубчатое', false, e);
  ID := SW.ActiveDoc;
  MD := SW.NewPart as IModelDoc2;
  SelMgr := MD.ISelectionManager;

  if MD.SelectByID('', 'EXTSKETCHPOINT', 0, 0, 0) then
    CP := SelMgr.IGetSelectedObject(1) as ISketchPoint;

  MD.InsertSketch;                                         //построение окружности
  Lines[0] := MD.ICreateCircle2(0, 0, 0, qwerty[1] / 500, 0, 0);
  CP.Select(true);
  MD.SketchAddConstraints('sgCONCENTRIC');
  MD.ClearSelection;

  Lines[0].Select(true);
  MD.AddDimension(-(ra + 10) / 1000, 0, 0);
  (MD.Parameter('D1@Эскиз1') as IDimension).SystemValue := qwerty[1] / 500;
  MD.ClearSelection;
  MD.FeatureManager.FeatureExtrusion2(true, false, false, 0, 0, b /500, 0, //вытягивание окружности
    false, false, false, false, 0.0, 0.0, false, false, false, false, true,
    false, true, 0, 0, true);

  MD.CreateSpline(A1);
  MD.FeatureManager.FeatureCut3(False, True, False, 1, 1, 0.01, 0.01, False, False, False, False, 1.74532925199433E-02, 1.74532925199433E-02, False, False, False, False, False, True, True, True, True, False, 0, 0, False) ;

  MD.Extension.SelectByID2('', 'FACE', qwerty[4] / 1000, qwerty[5] / 1000, b / 200, false, 0, nil, 0);
  MD.Extension.SelectByID2('', 'EDGE', qwerty[1] / 100, 0, 0, true, 0, nil, 0);
  MD.ActivateSelectedFeature;
  MD.ClearSelection2(true);
  MD.Extension.SelectByID2('Вырез-Вытянуть1', 'BODYFEATURE', 0, qwerty[1] / 1000,
    b / 200, false, 4, nil, 0);
  MD.Extension.SelectByID2('', 'EDGE', qwerty[1] / 1000, 0, 0, true, 1, nil, 0);
  MD.FeatureManager.FeatureCircularPattern4(z, 6.3, false, 'NULL', false,
    true, false);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  z: integer;
  m, b, x: extended;
begin
  m := StrToFloat(Edit1.Text);
  b := StrToFloat(Edit3.Text);
  x := StrToFloat(Edit4.Text);
  z := SpinEdit1.Value;
  ma := formuls(m,20,x,z);
  SetLength(qwerty,Length(ma)*3);
  for I := 0 to Length(ma)-1 do
  begin
    qwerty[i*3]:=ma[i,0];
    qwerty[i*3+1]:=ma[i,1];
    qwerty[i*3+2]:=0;
  end;
  A1 := VarArrayCreate([0, Length(qwerty)-1], varDouble);
  for I := 0 to Length(qwerty)-1 do
  begin
    A1[i]:=qwerty[i]/1000;
  end;
  DrawKol(m, x, b, z);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  z: integer;
  m, b, x: extended;
  SW: ISldWorks;
  ID: IDispatch;
  MD: IModelDoc2;
  CP: ISketchPoint;
  SelMgr: ISelectionMgr;
  e:integer;
  Lines: array [0 .. 11] of ISketchSegment;
begin
  m := StrToFloat(Edit1.Text);
  b := StrToFloat(Edit3.Text);
  x := StrToFloat(Edit4.Text);
  z := SpinEdit1.Value;
  ma := formuls(m,20,x,z);
  SetLength(qwerty,Length(ma)*3);
  for I := 0 to Length(ma)-1 do
  begin
    qwerty[i*3]:=ma[i,0];
    qwerty[i*3+1]:=ma[i,1];
    qwerty[i*3+2]:=0;
  end;
  A1 := VarArrayCreate([0, Length(qwerty)-1], varDouble);
  for I := 0 to Length(qwerty)-1 do
  begin
    A1[i]:=qwerty[i]/1000+0.025;
  end;

  SW := CreateOleObject('SldWorks.Application') as ISldWorks;
 If SW.Visible = false then
    SW.Visible := true;

  ID := SW.NewDocument
    ('C:\ProgramData\SolidWorks\SOLIDWORKS 2016\templates\gost-part.prtdot', 0,
    0, 0);
  ID := SW.ActivateDoc2('Колесо зубчатое', false, e);
  ID := SW.ActiveDoc;
  MD := SW.NewPart as IModelDoc2;
  SelMgr := MD.ISelectionManager;

MD.Extension.SelectByID2('Point1@Исходная точка', 'EXTSKETCHPOINT', 0, 0, 0, False, 0, nil, 0);
MD.Extension.SelectByID2('Спереди', 'PLANE', 0, 0, 0, False, 0, nil, 0);
MD.ClearSelection2(true);
//Dim skSegment As Object
//MD.ICreateCenterLine(0, 0, 0, 0.085797, 0, 0);
 MD.CreateCenterLineVB(0, 0, 0, 0.085797, 0, 0);
 MD.ClearSelection2(true);
  Lines[0] := MD.ICreateLine2(0, 0.025, 0, 0.05, 0.025, 0);
  Lines[1] := MD.ICreateLine2(0.05, 0.025, 0, 0.05, 0.05, 0);
  Lines[2] := MD.ICreateLine2(0.05, 0.05, 0, 0.035, 0.05, 0);
  Lines[3] := MD.ICreateLine2(0.035, 0.05, 0, 0.035, 0.085, 0);
  Lines[4] := MD.ICreateLine2(0.035, 0.085, 0, 0.045, 0.085, 0);
  Lines[5] := MD.ICreateLine2(0.045, 0.085, 0, 0.045, 0.1, 0);
  Lines[6] := MD.ICreateLine2(0.045, 0.1, 0, -0.005, 0.1, 0);
  Lines[7] := MD.ICreateLine2(-0.005, 0.1, 0, -0.005, 0.085, 0);
  Lines[8] := MD.ICreateLine2(-0.005, 0.085, 0, 0.005, 0.085, 0);
  Lines[9] := MD.ICreateLine2(0.005, 0.085, 0, 0.005, 0.05, 0);
  Lines[10] := MD.ICreateLine2(0.005, 0.05, 0, 0, 0.05, 0);
  Lines[11] := MD.ICreateLine2(0, 0.05, 0, 0, 0.025, 0);
MD.ClearSelection2(True);

MD.FeatureManager.FeatureRevolve2(True, True, False, False, False, False, 0, 0, 6.2831853071796, 0, False, False, 0.01, 0.01, 0, 0, 0, True, True, True);
//MD.SelectionManager.EnableContourSelection := False
//MD.SketchManager.InsertSketch (True) ;
//MD.Extension.SelectByID2('Эскиз2', 'SKETCH', 0, 0, 0, False, 0, nil, 0);
//MD.Extension.SelectByID2('Спереди', 'PLANE', 0, 0, 0, True, 0, nil, 0);
//MD.DeSelectByID('Спереди', 'PLANE', 0, 0, 0);
//MD.Extension.SelectByID2('Справа', 'PLANE', 0, 0, 0, True, 0, nil, 0);
MD.Extension.SelectByID2('Эскиз2', 'SKETCH', 0, 0, 0, False, 0, nil, 0);
MD.Extension.SelectByID2('Справа', 'PLANE', 0, 0, 0, True, 0, nil, 0);

MD.CreateSpline(A1);

MD.Extension.SelectByID2('Spline1', 'SKETCHSEGMENT', -4.99999999993861E-03, 9.93706834089743E-02, 7.65569906904062E-03, False, 0, nil, 0);
MD.FeatureManager.FeatureCut3(False, True, False, 1, 1, 0.01, 0.01, False, False, False, False, 1.74532925199433E-02, 1.74532925199433E-02, False, False, False, False, False, True, True, True, True, False, 0, 0, False) ;

  MD.Extension.SelectByID2('', 'FACE', qwerty[4] / 1000, qwerty[5] / 1000, b / 200, false, 0, nil, 0);
  MD.Extension.SelectByID2('', 'EDGE', qwerty[1] / 100, 0, 0, true, 0, nil, 0);
  MD.ActivateSelectedFeature;
  MD.ClearSelection2(true);
  MD.Extension.SelectByID2('Вырез-Вытянуть1', 'BODYFEATURE', 0, qwerty[1] / 1000,
    b / 200, false, 4, nil, 0);
  MD.Extension.SelectByID2('', 'EDGE', qwerty[1] / 1000, 0, 0, true, 1, nil, 0);
  MD.FeatureManager.FeatureCircularPattern4(z, 6.3, false, 'NULL', false,
    true, false);

end;


end.
