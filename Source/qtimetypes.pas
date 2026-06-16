unit qtimetypes;

interface

{
  ��Դ������QDAC��Ŀ����Ȩ��swish(QQ:109867294)���С�
  (1)��ʹ�����ɼ�����
  ���������ɸ��ơ��ַ����޸ı�Դ�룬�������޸�Ӧ�÷��������ߣ������������ڱ�Ҫʱ��
  �ϲ�������Ŀ���Թ�ʹ�ã��ϲ����Դ��ͬ����ѭQDAC��Ȩ�������ơ�
  ���Ĳ�Ʒ�Ĺ����У�Ӧ�������µİ汾����:
  ����Ʒʹ�õ�JSON����������QDAC��Ŀ�е�QJSON����Ȩ���������С�
  (2)������֧��
  �м������⣬�����Լ���QDAC�ٷ�QQȺ250530692��ͬ̽�֡�
  (3)������
  ����������ʹ�ñ�Դ�������Ҫ֧���κη��á���������ñ�Դ������а�������������
  ������Ŀ����ǿ�ƣ�����ʹ���߲�Ϊ�������ȣ��и���ľ���Ϊ�����ָ��õ���Ʒ��
  ������ʽ��
  ֧������ guansonghuan@sina.com �����������
  �������У�
  �����������
  �˺ţ�4367 4209 4324 0179 731
  �����У��������г����ŷ索����
}
{ ����Ԫʵ����ʱ�������(TQTimeStamp)��ʱ��������(TQInterval)������TQValue������
  ��Ҫ�ĳ��ϡ�����Ԫʵ�ֵ�TQTimeStamp��TQInterval������һЩ�㷨������֤�������͵�
  ���ȶ���8�ֽ�64λ�������ĺô��Ƿ���TQValueĬ�ϳ���8�ֽڣ�������Ҫʹ��ָ�롣
  TQTimeStamp��ϵͳ��TDateTimeʵ�ַ�ʽ��ͬ��������������ʽת����TQInterval������DateTime
  ���ͽ��мӼ����㡣

  �޶���־
  2015.12.21
  ==========
  * �Ƴ���ϵͳ��TSQLTimeStamp���͵Ķ��������������ٷʣ�
  2015.8.11
  =========
  * ��д TQPlanMask ��ʱ���趨��Χ��Ϊ���뵽�꣬ͬʱ���Ӷ� #��L��W ��������֧��

  2015.7.3
  =========
  * ������ TQPlanMask ʱ~��֮���ѡ����Ч������(�ഺ���棩
  + ���Ӷ� */n �����ʽ��֧��
  2014-9-12
  =========
  * ��ʼ�汾(��1��)
}
uses classes, qstring, sysutils, dateutils, math;
{$HPPEMIT '#pragma link "qtimetypes"'}

const
  MacroSecond1Second = 1000000;
  MS1Day: Int64 = 86400000;
  MS1Second: Int64 = 1000;
  Second1Day: Int64 = 86400;
  MS1Minute: Int64 = 60000;
  Second1Minute: Int64 = 60;
  Minute1Day: Int64 = 1440;
  MS1Hour: Int64 = 3600000;
  Minute1Hour: Int64 = 60;
  Hour1Day: Int64 = 24;
  Day1Year: Double = 365.24219;
  Day1Month: Double = 365.24219 / 12;
  Month1Year: Int64 = 12;
  // �ƻ���������
  PLAN_MASK_ANY = $01;
  PLAN_MASK_RANGE = $02;
  PLAN_MASK_REPEAT = $04;
  PLAN_MASK_IGNORE = $08;
  PLAN_MASK_LAST = $10;
  PLAN_MASK_WEEKOFMONTH = $20;
  PLAN_MASK_WORKDAY = $40;

type
  // ʱ����ֵ��¼
  PQInterval = ^TQInterval;
  PQTimeStamp = ^TQTimestamp;

  TQInterval = record
  private
    FData: Int64;
    function GetHour: Shortint;
    function GetMilliSecond: Smallint;
    function GetMinute: Shortint;
    function GetSecond: Shortint;
    procedure SetHour(const Value: Shortint);
    procedure SetMilliSecond(const Value: Smallint);
    procedure SetMinute(const Value: Shortint);
    procedure SetSecond(const Value: Shortint);
    function GetAsPgString: QStringW;
    function GetDay: Smallint;
    function GetMonth: Smallint;
    function GetYear: Integer;
    function GetMonths: Smallint;
    function GetMillSeconds: Int64;
    function GetDayMS: Int64; inline;
    procedure SetDay(const Value: Smallint);
    procedure SetYear(const Value: Integer);
    procedure SetMonth(const Value: Smallint);
    procedure SetAsPgString(const Value: QStringW);
    function GetAsISOString: QStringW;
    procedure SetAsISOString(const Value: QStringW);
    function GetWeek: Smallint;
    procedure SetWeek(const Value: Smallint);
    procedure SetAsString(const Value: QStringW);
    function GetAsOracleString: QStringW;
    procedure SetAsOracleString(const Value: QStringW);
    function GetAsSQLString: QStringW;
    procedure SetAsSQLString(const Value: QStringW);
    function GetIsZero: Boolean; inline;
    procedure SetMonthes(M: Int64);
    function GetIsNeg: Boolean;
    function GetDayToMs: Int64;
    function GetYearMonth: Integer;
    procedure SetDayToMs(const Value: Int64);
    procedure SetYearMonth(const Value: Integer);
  public
    class operator Add(const ADate: TDateTime; const AInterval: TQInterval)
      : TDateTime;
    class operator Add(const AInterval: TQInterval; const ADate: TDateTime)
      : TDateTime;
    class operator Add(const AInterval1, AInterval2: TQInterval): TQInterval;

    class operator Subtract(const ADate: TDateTime; const AInterval: TQInterval)
      : TDateTime;
    class operator Subtract(const AInterval1, AInterval2: TQInterval)
      : TQInterval;
    class operator Equal(const Left, Right: TQInterval): Boolean;
    class operator NotEqual(const Left, Right: TQInterval): Boolean;
    class operator GreaterThan(const Left, Right: TQInterval): Boolean; inline;
    class operator GreaterThanOrEqual(const Left, Right: TQInterval)
      : Boolean; inline;
    class operator LessThan(const Left, Right: TQInterval): Boolean; inline;
    class operator LessThanOrEqual(const Left, Right: TQInterval)
      : Boolean; inline;
    class function StringToInterval(const S: QStringW): TQInterval; static;
    class function DateTimeToInterval(const V: TDateTime): TQInterval; static;
    class function EncodeInterval(const Y: Integer; const M: Smallint)
      : TQInterval; overload; static;
    class function EncodeInterval(const D, H, N, S, MS: Smallint): TQInterval;
      overload; static;
    class function EncodeInterval(const Y: Integer;
      const M, D, H, N, S, MS: Smallint): TQInterval; overload; static;
    class function Compare(const V1, V2: TQInterval): Integer; static;
    class operator Implicit(const S: QStringW): TQInterval;
    class operator Implicit(const V: Smallint): TQInterval;
    function IncYear(const Y: Integer): PQInterval;
    function IncMonth(const M: Smallint): PQInterval;
    function IncDay(const D: Smallint): PQInterval;
    function IncHour(const H: Smallint): PQInterval;
    function IncMinute(const M: Smallint): PQInterval;
    function IncSecond(const S: Smallint): PQInterval;
    function IncMilliSecond(const MS: Smallint): PQInterval;
    function TryFromPgString(Value: QStringW): Boolean;
    function TryFromISOString(Value: QStringW): Boolean;
    function TryFromOracleString(Value: QStringW): Boolean;
    function TryFromSQLString(Value: QStringW): Boolean;
    function TryFromString(const Value: QStringW): Boolean;
    function Format(AFormat: QStringW; AHideZeros: Boolean): QStringW;
    procedure Clear;
    procedure Encode(Y: Integer; M, D, H, N, S, MS: Smallint); overload;
    procedure Encode(Y: Integer; M, D: Smallint); overload;
    procedure Decode(var Y: Integer; var M, D, H, N, S, MS: Smallint);
    property Year: Integer read GetYear write SetYear;
    property Month: Smallint read GetMonth write SetMonth;
    property Week: Smallint read GetWeek write SetWeek;
    property Day: Smallint read GetDay write SetDay;
    property Hour: Shortint read GetHour write SetHour;
    property Minute: Shortint read GetMinute write SetMinute;
    property Second: Shortint read GetSecond write SetSecond;
    property MilliSecond: Smallint read GetMilliSecond write SetMilliSecond;
    property AsString: QStringW read GetAsISOString write SetAsString;
    property AsPgString: QStringW read GetAsPgString write SetAsPgString;
    property AsOracleString: QStringW read GetAsOracleString
      write SetAsOracleString;
    property AsSQLString: QStringW read GetAsSQLString write SetAsSQLString;
    property AsISOString: QStringW read GetAsISOString write SetAsISOString;
    property IsZero: Boolean read GetIsZero;
    property IsNeg: Boolean read GetIsNeg;
    property YearMonth: Integer read GetYearMonth write SetYearMonth;
    property DayToMs: Int64 read GetDayToMs write SetDayToMs;
  end;

  /// <summary>�ƻ���ҵ��ʽ</summary>
  TQTimeLimitItem = record
    Start: Smallint;
    Stop: Smallint;
    Flags: Byte;
    Interval: Byte;
  end;

  TQTimeLimitPart = (tlpSecond, tlpMinute, tlpHour, tlpDayOfMonth,
    tlpMonthOfYear, tlpDayOfWeek, tlpYear);

  TQTimeLimit = array of TQTimeLimitItem;
  PQTimeLimit = ^TQTimeLimit;
  TQTimeLimits = array [TQTimeLimitPart] of TQTimeLimit;
  PQTimeLimits = ^TQTimeLimits;
  PQPlanMask = ^TQPlanMask;

  TQWorkDayFunction = function(ADate: TDateTime): Boolean;

  TQPlanTimeAcceptEvent = procedure(const ASender: PQPlanMask; ATime: TDateTime;
    var Accept: Boolean) of object;
  TQPlanTimeoutCheckResult = (pcrOk, pcrNotArrived, pcrTimeout, pcrExpired);

  TQPlanMask = record
  private
    FLimits: TQTimeLimits;
    FStartTime: TDateTime; // �ƻ���Ч��ʼʱ��
    FFirstTime: TDateTime; // �״�ִ��ʱ��
    FLastTime, FNextTime: TDateTime; // ĩ��ִ��ʱ��
    FStopTime: TDateTime; // �ƻ���Ч��ֹʱ��
    FContent: QStringW;
    FOnTimeAccept: TQPlanTimeAcceptEvent;
    procedure SetAsString(const S: QStringW);
    function GetAsString: QStringW;
    function GetNextTime: TDateTime;
    function AcceptDay(Y, M, D: Word): Boolean;
    function Accept(const ALimit: PQTimeLimit; AValue: Word): Boolean; overload;
    function Accept(const ALimit: TQTimeLimitItem; AValue: Word)
      : Boolean; overload;
    function GetLimits: PQTimeLimits;
  public
    class function Create: TQPlanMask; overload; static;
    class function Create(const AMask: QStringW): TQPlanMask; overload; static;
    function Timeout(ATime: TDateTime): TQPlanTimeoutCheckResult;
    procedure Reset;
    function Accept(ATime: TDateTime): Boolean; overload;
    property AsString: QStringW read GetAsString write SetAsString;
    property NextTime: TDateTime read GetNextTime;
    property StartTime: TDateTime read FStartTime write FStartTime;
    property StopTime: TDateTime read FStopTime write FStopTime;
    property FirstTime: TDateTime read FFirstTime write FFirstTime;
    property LastTime: TDateTime read FLastTime write FLastTime;
    property Content: QStringW read FContent write FContent;
    property Limits: PQTimeLimits read GetLimits;
  end;

  PSQLTimeStamp = ^TSQLTimeStamp;

  TSQLTimeStamp = record
    Year: Word;
    Month: Word;
    Day: Word;
    Hour: Word;
    Minute: Word;
    Second: Word;
    Fractions: Cardinal;
  end;

  TQTimestamp = record
  private
    Data: Int64;
    // ��һ��64λ��������¼ʱ�����������ʹ��TSQLTimeStamp
    function GetIsBC: Boolean;
    procedure SetIsBC(const Value: Boolean);
    function GetDay: Byte;
    function GetHour: Byte;
    function GetMacroSecond: Integer;
    function GetMilliSecond: Word;
    function GetMinute: Byte;
    function GetMonth: Byte;
    function GetSecond: Byte;
    function GetYear: Smallint;
    procedure SetDay(const Value: Byte);
    procedure SetHour(const Value: Byte);
    procedure SetMacroSecond(const Value: Integer);
    procedure SetMilliSecond(const Value: Word);
    procedure SetMinute(const Value: Byte);
    procedure SetMonth(const Value: Byte);
    procedure SetSecond(const Value: Byte);
    procedure SetYear(const Value: Smallint);
    function GetAsString: QStringW;
    procedure SetAsString(const Value: QStringW);
    function GetHasDate: Boolean;
    function GetHasTime: Boolean;
  public
    class operator Implicit(const AStamp: TSQLTimeStamp): TQTimestamp;
    class operator Implicit(const AStamp: TQTimestamp): TSQLTimeStamp;
    class operator Implicit(const AStamp: TDateTime): TQTimestamp;
    class operator Implicit(const AStamp: TQTimestamp): TDateTime;
    procedure Encode(const Y: Smallint; const M, D, H, N, S: Byte;
      const MS: Word); overload;
    procedure Encode(const Y: Smallint; const M, D: Byte); overload;
    procedure Encode(const H, N, S: Byte; const MS: Word); overload;
    procedure Clear;
    function IncYear(Y: Smallint = 1): PQTimeStamp;
    function IncMonth(M: Integer = 1): PQTimeStamp;
    function IncDay(D: Integer = 1): PQTimeStamp;
    function IncHour(H: Integer = 1): PQTimeStamp;
    function IncMinute(M: Integer = 1): PQTimeStamp;
    function IncSecond(S: Integer = 1): PQTimeStamp;
    function IncMillSecond(MS: Integer = 1): PQTimeStamp;
    function IncMacroSecond(MS: Integer = 1): PQTimeStamp;
    property IsBC: Boolean read GetIsBC write SetIsBC;
    property Year: Smallint read GetYear write SetYear;
    property Month: Byte read GetMonth write SetMonth;
    property Day: Byte read GetDay write SetDay;
    property Hour: Byte read GetHour write SetHour;
    property Minute: Byte read GetMinute write SetMinute;
    property Second: Byte read GetSecond write SetSecond;
    property MilliSecond: Word read GetMilliSecond write SetMilliSecond;
    property MacroSecond: Integer read GetMacroSecond write SetMacroSecond;
    property AsString: QStringW read GetAsString write SetAsString;
    property HasDate: Boolean read GetHasDate;
    property HasTime: Boolean read GetHasTime;
  end;

function MinInterval: TQInterval; inline;
function MaxInterval: TQInterval; inline;
function DefaultIsWorkDay(ADate: TDateTime): Boolean;

var
  IsWorkDay: TQWorkDayFunction = DefaultIsWorkDay;

implementation

resourcestring
  SOutOfIntervalRange = 'ʱ�������Ͳ�����ָ����ֵ %d (������Χ%d-%d)';
  SBadIntervalValue = '��Ч��ʱ����ֵ:%s';
  SBadPgIntervalString = '��Ч��PostgreSQLʱ��������ֵ:%s';
  SBadISOIntervalValue = '��Ч��ISOʱ��������ֵ:%s';
  SBadOracleIntervalValue = '��Ч��Oracleʱ��������ֵ:%s';
  SBadSQLIntervalString = '��Ч��SQLʱ��������ֵ:%s';
  SIntervalOutOfRange = 'ʱ����ֵ���������ķ�Χ����-699051��4��~699050��7��';
  SBadTimeValue = 'ָ����ʱ����������Ч:%d-%d-%d %d:%d:%d.%d';
  SMonthOutOfRange = 'ָ�����·�ֵ %d ����������Χ';
  SDayOutOfRange = 'ָ�������� %d ����������Χ (1-%d)';
  SHourOutOfRange = 'ָ����Сʱ�� %d ����������Χ(0-23)';
  SMinuteOutOfRange = 'ָ���ķ����� %d ����������Χ(0-59)';
  SSecondOutOfRange = 'ָ�������� %d ����������Χ(0-59)';
  SMSOutOfRange = 'ָ���ĺ����� %d ����������Χ(0-599)';
  SMacroSecondOutOfRange = 'ָ����΢���� %d ����������Χ(0-999999)';
  SBadDateTimeString = '��֧�ֵ�����ʱ���ַ���ֵ:%s';
  SBadPlanMask = 'ָ�����ַ� %s ��Ч��';

  // ��Сʱ����Ϊ-699051��4������-6363��2Сʱ3��6��112����
function MinInterval: TQInterval; inline;
begin
  Result.FData := Int64($8000008000000000);
end;

// �����ʱ��Ϊ699050��7������6362��21Сʱ56��53��887����
function MaxInterval: TQInterval; inline;
begin
  Result.FData := $7FFFFF7FFFFFFFFF;
end;

{ TQInterval }
class operator TQInterval.Add(const ADate: TDateTime;
  const AInterval: TQInterval): TDateTime;
var
  Y: Integer;
  M, D, H, N, S, MS: Smallint;
begin
  AInterval.Decode(Y, M, D, H, N, S, MS);
  Result := dateutils.IncMilliSecond
    (dateutils.IncSecond(dateutils.IncMinute(dateutils.IncHour(dateutils.IncDay
    (sysutils.IncMonth(dateutils.IncYear(ADate, Y), M), D), H), N), S), MS);
end;

class operator TQInterval.Add(const AInterval: TQInterval;
  const ADate: TDateTime): TDateTime;
begin
  Result := ADate + AInterval;
end;

// ����ʱ�������
class operator TQInterval.Add(const AInterval1, AInterval2: TQInterval)
  : TQInterval;
var
  M, MS: Int64;
begin
  M := AInterval1.GetMonths + AInterval2.GetMonths;
  MS := AInterval1.GetMillSeconds + AInterval2.GetMillSeconds;
  Result.FData := (M shl 40) or (MS and $FFFFFFFFFF);
end;

procedure TQInterval.Clear;
begin
  FData := 0;
end;

class function TQInterval.Compare(const V1, V2: TQInterval): Integer;
var
  ADelta: Extended;
begin
  ADelta := (V1.GetMonths * Day1Month * MS1Day + V1.GetMillSeconds) -
    (V2.GetMonths * Day1Month * MS1Day + V2.GetMillSeconds);
  if ADelta > 0 then
    Result := 1
  else if ADelta < 0 then
    Result := -1
  else
    Result := 0;
end;

class function TQInterval.DateTimeToInterval(const V: TDateTime): TQInterval;
var
  Y, M, D, H, N, S, MS: Word;
begin
  DecodeDateTime(V, Y, M, D, H, N, S, MS);
  Result.Encode(Y, M, D, H, N, S, MS);
end;

procedure TQInterval.Decode(var Y: Integer; var M, D, H, N, S, MS: Smallint);
var
  L: Int64;
  ANeg: Boolean;
begin
  ANeg := (FData and $8000000000000000) <> 0;
  if ANeg then
    L := (-FData shr 40)
  else
    L := FData shr 40;
  Y := L div Month1Year;
  if L < 0 then
  begin
    M := L mod Month1Year;
    if M <> 0 then
    begin
      Dec(Y);
      Inc(M, Month1Year);
    end;
  end
  else
    M := L mod Month1Year;
  if ANeg then
    Y := -Y;
  L := GetMillSeconds;
  D := L div MS1Day;
  if L < 0 then
    L := -L;
  // begin
  // Dec(D);
  // L := MS1Day + (L mod MS1Day);
  // end;
  L := L mod MS1Day;
  H := L div MS1Hour;
  L := L mod MS1Hour;
  N := L div MS1Minute;
  L := L mod MS1Minute;
  S := L div MS1Second;
  MS := L mod MS1Second;
end;

procedure TQInterval.Encode(Y: Integer; M, D, H, N, S, MS: Smallint);
var
  MT, MST: Int64;
  ANeg: Boolean;
begin
  while M < 0 do
  begin
    Dec(Y);
    Inc(M, 12);
  end;
  ANeg := Y < 0;
  if ANeg then
    Y := -Y;
  MT := Y * 12 + M;
  if ANeg then
    MT := -MT;
  if (MT > 8388607) or (MT < -8388608) then // ��24λ��ʾ��Χ
    raise Exception.Create(SIntervalOutOfRange);
  while MS < 0 do
  begin
    Dec(S);
    Inc(MS, 1000);
  end;
  while S < 0 do
  begin
    Dec(N);
    Inc(S, 60);
  end;
  while H < 0 do
  begin
    Dec(D);
    Inc(H, 24);
  end;
  ANeg := D < 0;
  if ANeg then
    D := -D;
  MST := D * MS1Day + H * MS1Hour + N * MS1Minute + S * MS1Second + MS;
  if MST > 549755813887 then // ��40λ��ʾ��Χ
    raise Exception.Create(SIntervalOutOfRange);
  if ANeg then
    MST := -MST;
  FData := MT shl 40 + (MST and $FFFFFFFFFF);
end;

class function TQInterval.EncodeInterval(const D, H, N, S, MS: Smallint)
  : TQInterval;
begin
  Result.Encode(0, 0, D, H, N, S, MS);
end;

class function TQInterval.EncodeInterval(const Y: Integer; const M: Smallint)
  : TQInterval;
begin
  Result.Encode(Y, M, 0, 0, 0, 0, 0);
end;

procedure TQInterval.Encode(Y: Integer; M, D: Smallint);
begin
  Encode(Y, M, D, 0, 0, 0, 0);
end;

class function TQInterval.EncodeInterval(const Y: Integer;
  const M, D, H, N, S, MS: Smallint): TQInterval;
begin
  Result.Encode(Y, M, D, H, N, S, MS);
end;

class operator TQInterval.Equal(const Left, Right: TQInterval): Boolean;
begin
  Result := (Left.FData = Right.FData);
end;

function TQInterval.Format(AFormat: QStringW; AHideZeros: Boolean): QStringW;
var
  P, pd, ps: PQCharW;
  Y: Integer;
  M, D, H, N, S, MS: Smallint;
  Str: QStringW;
  procedure CatValue(V: Smallint);
  begin
    if (V <> 0) or (not AHideZeros) then
    begin
      Str := IntToStr(V);
      Move(PQCharW(Str)^, pd^, Length(Str) shl 1);
      Inc(pd, Length(Str));
    end;
  end;
  procedure CatStr;
  var
    AQuoter: QCharW;
  begin
    AQuoter := P^;
    Inc(P);
    while P^ <> #0 do
    begin
      if P^ = AQuoter then
      begin
        Inc(P);
        if P^ = AQuoter then
        begin
          pd^ := AQuoter;
          Inc(pd);
          Inc(P);
        end
        else
          Break;
      end
      else
      begin
        pd^ := P^;
        Inc(pd);
        Inc(P);
      end;
    end;
  end;

begin
  P := PQCharW(AFormat);
  SetLength(Result, Length(AFormat) * 6);
  pd := PQCharW(Result);
  ps := pd;
  Decode(Y, M, D, H, N, S, MS);
  while P^ <> #0 do
  begin
    if (P^ = 'Y') or (P^ = 'y') then
      CatValue(Y)
    else if (P^ = 'M') or (P^ = 'm') then
      CatValue(M)
    else if (P^ = 'D') or (P^ = 'd') then
      CatValue(D)
    else if (P^ = 'H') or (P^ = 'h') then
      CatValue(H)
    else if (P^ = 'N') or (P^ = 'n') then
      CatValue(N)
    else if (P^ = 'S') or (P^ = 's') then
      CatValue(S)
    else if (P^ = 'Z') or (P^ = 'z') then
      CatValue(MS)
    else if (P^ = '''') or (P^ = '"') then
      CatStr
    else
    begin
      pd^ := P^;
      Inc(pd);
    end;
    Inc(P);
  end;
  SetLength(Result, (IntPtr(pd) - IntPtr(ps)) shr 1);
end;

// class operator TQInterval.Implicit(const AStamp: TQInterval): TSQLTimeStamp;
// var
// Y, M, D, H, N, S, MS: Smallint;
// begin
// AStamp.Decode(Y, M, D, H, N, S, MS);
// Result.Year := Y;
// Result.Month := M;
// Result.Day := D;
// Result.Hour := H;
// Result.Minute := N;
// Result.Second := S;
// Result.Fractions := MS * 1000;
// end;
//
// class operator TQInterval.Implicit(const AStamp: TSQLTimeStamp): TQInterval;
// begin
// Result.Encode(AStamp.Year, AStamp.Month, AStamp.Day, AStamp.Hour, AStamp.Minute,
// AStamp.Second, AStamp.Fractions div 1000);
// end;

class operator TQInterval.LessThan(const Left, Right: TQInterval): Boolean;
begin
  Result := Right > Left;
end;

class operator TQInterval.LessThanOrEqual(const Left,
  Right: TQInterval): Boolean;
begin
  Result := (Right.FData = Left.FData) or (Right > Left);
end;

class operator TQInterval.NotEqual(const Left, Right: TQInterval): Boolean;
begin
  Result := (Left.FData <> Right.FData);
end;

function TQInterval.GetAsISOString: QStringW;
var
  Y: Integer;
  M, D, H, N, S, MS: Smallint;
begin
  Decode(Y, M, D, H, N, S, MS);
  Result := 'P';
  if Y <> 0 then
    Result := Result + IntToStr(Y) + 'Y';
  if M <> 0 then
    Result := Result + IntToStr(M) + 'M';
  if D <> 0 then
    Result := Result + IntToStr(D) + 'D';
  if (H <> 0) or (N <> 0) or (S <> 0) then
  begin
    Result := Result + 'T';
    if H <> 0 then
      Result := Result + IntToStr(H) + 'H';
    if N <> 0 then
      Result := Result + IntToStr(N) + 'M';
    if (S <> 0) or (MS <> 0) then
    begin
      Result := Result + IntToStr(S);
      if MS <> 0 then
      begin
        if (MS mod 100) = 0 then
          Result := Result + '.' + IntToStr(MS div 100)
        else if (MS mod 10) = 0 then
          Result := Result + '.' + IntToStr(MS div 10)
        else if MS > 100 then
          Result := Result + '.' + IntToStr(MS)
        else if MS > 10 then
          Result := Result + '.0' + IntToStr(MS)
        else
          Result := Result + '.00' + IntToStr(MS);
      end;
      Result := Result + 'S';
    end;
  end;
end;

function TQInterval.GetAsOracleString: QStringW;
var
  Y: Integer;
  M, D, H, N, S, MS: Smallint;
  SY, SM, SD, SS, SF: QStringW;
begin
  Decode(Y, M, D, H, N, S, MS);
  Result := 'INTERVAL ''';
  if (Y <> 0) or (M <> 0) then
  begin
    if Y <> 0 then
    begin
      SY := IntToStr(Y);
      Result := Result + SY;
      if M <> 0 then
      begin
        SM := IntToStr(M);
        Result := Result + '-' + SM + ''' YEAR(' + IntToStr(Length(SY)) +
          ') TO MONTH(' + IntToStr(Length(SM)) + ')';
      end
      else
        Result := Result + ''' YEAR(' + IntToStr(Length(SY)) + ')';
    end
    else
    begin
      SM := IntToStr(M);
      Result := Result + SM + ''' MONTH(' + IntToStr(Length(SM)) + ')';
    end;
  end;
  if (D <> 0) or (H <> 0) or (N <> 0) or (S <> 0) or (MS <> 0) then
  begin
    if Length(Result) > 10 then
      Result := Result + ' + INTERVAL ''';
    if D <> 0 then
    begin
      SD := IntToStr(D);
      Result := Result + SD + ' ';
      SF := 'DAY(' + IntToStr(Length(SD)) + ')';
    end;
    if (H <> 0) or (N <> 0) or (S <> 0) or (MS <> 0) then
    begin
      SS := IntToStr(H);
      Result := Result + SS;
      if Length(SF) = 0 then
        SF := 'HOUR(' + IntToStr(Length(SS)) + ')';
      if (N <> 0) or (S <> 0) or (MS <> 0) then
      begin
        SS := IntToStr(N);
        Result := Result + ':' + SS;
        if (S <> 0) or (MS <> 0) then
        begin
          SS := IntToStr(S);
          Result := Result + ':' + SS;
          if MS <> 0 then
          begin
            Result := Result + '.';
            if (MS mod 100) = 0 then
              Result := Result + IntToStr(MS div 100) + ''' ' + SF +
                ' TO SECOND(' + IntToStr(Length(SS)) + ',1)'
            else if (MS mod 10) = 0 then
              Result := Result + IntToStr(MS div 10) + ''' ' + SF +
                ' TO SECOND(' + IntToStr(Length(SS)) + ',2)'
            else
              Result := Result + IntToStr(MS) + ''' ' + SF + ' TO SECOND(' +
                IntToStr(Length(SS)) + ',3)';
          end
          else
            Result := Result + ''' ' + SF + ' TO SECOND(' +
              IntToStr(Length(SS)) + ')';
        end
        else
          Result := Result + ''' ' + SF + ' TO MINUTE(' +
            IntToStr(Length(SS)) + ')';
      end
      else
      begin
        if D = 0 then
          Result := Result + ''' ' + SF
        else
          Result := Result + ''' ' + SF + ' TO HOUR(' +
            IntToStr(Length(SS)) + ')';
      end;
    end
    else
      Result := Result + ''' ' + SF;
  end;
end;

function TQInterval.GetAsPgString: QStringW;
var
  Y: Integer;
  M, D, H, N, S, MS: Smallint;
begin
  Decode(Y, M, D, H, N, S, MS);
  if Y <> 0 then
    Result := IntToStr(Y) + ' year '
  else
    SetLength(Result, 0);
  if M <> 0 then
    Result := Result + IntToStr(M) + ' month ';
  if D <> 0 then
    Result := Result + IntToStr(D) + ' day ';
  if H <> 0 then
    Result := Result + IntToStr(H) + ' hour ';
  if N <> 0 then
    Result := Result + IntToStr(N) + ' minute ';
  if S <> 0 then
    Result := Result + IntToStr(S) + ' second ';
  if MS <> 0 then
    Result := Result + IntToStr(MS) + ' millsecond ';
  Result := StrDupX(PQCharW(Result), Length(Result) - 1);
end;

function TQInterval.GetAsSQLString: QStringW;
var
  Y: Integer;
  M, D, H, N, S, MS: Smallint;
begin
  Decode(Y, M, D, H, N, S, MS);
  if (Y <> 0) or (M <> 0) then
    Result := IntToStr(Y) + '-' + IntToStr(M)
  else
    Result := '';
  if D <> 0 then
    Result := Result + ' ' + IntToStr(D);
  if (H <> 0) or (N <> 0) or (S <> 0) or (MS <> 0) then
  begin
    Result := Result + ' ' + IntToStr(H) + ':' + IntToStr(N) + ':' +
      IntToStr(S);
    if MS <> 0 then
    begin
      Result := Result + '.';
      if (MS mod 100) = 0 then
        Result := Result + IntToStr(MS div 100)
      else if (MS mod 10) = 0 then
        Result := Result + IntToStr(MS div 10)
      else if MS < 10 then
        Result := Result + '00' + IntToStr(MS)
      else if MS < 100 then
        Result := Result + '0' + IntToStr(MS)
      else
        Result := Result + IntToStr(MS);
    end;
  end;
end;

function TQInterval.GetDay: Smallint;
begin
  Result := GetMillSeconds div MS1Day;
  if Result < 0 then
    Dec(Result);
end;

function TQInterval.GetHour: Shortint;
begin
  Result := GetDayMS div MS1Hour;
end;

function TQInterval.GetIsNeg: Boolean;
begin
  Result := (FData and $8000008000000000) <> 0;
end;

function TQInterval.GetIsZero: Boolean;
begin
  Result := FData = 0;
end;

function TQInterval.GetDayMS: Int64;
begin
  Result := GetMillSeconds mod MS1Day;
  if Result < 0 then
    Result := MS1Day + Result;
end;

function TQInterval.GetDayToMs: Int64;
begin
  Result := GetMillSeconds;
end;

function TQInterval.GetMilliSecond: Smallint;
begin
  Result := GetDayMS mod MS1Second;
end;

function TQInterval.GetMillSeconds: Int64;
begin
  Result := FData and $FFFFFFFFFF;
  if (Result and $8000000000) <> 0 then
    Result := Result or $FFFFFF0000000000;
end;

function TQInterval.GetMinute: Shortint;
begin
  Result := (GetDayMS mod MS1Hour) div MS1Minute;
end;

function TQInterval.GetMonth: Smallint;
var
  M: Int64;
begin
  M := GetMonths;
  if M < 0 then
  begin
    Result := (M mod Month1Year);
    if Result <> 0 then
      Inc(Result, Month1Year);
  end
  else
    Result := M mod Month1Year;
end;

function TQInterval.GetMonths: Smallint;
begin
  Result := FData shr 40;
end;

function TQInterval.GetSecond: Shortint;
begin
  Result := (GetDayMS mod MS1Minute) div MS1Second;
end;

function TQInterval.GetWeek: Smallint;
begin
  Result := Day div 7;
end;

function TQInterval.GetYear: Integer;
var
  M: Int64;
begin
  M := GetMonths;
  if M < 0 then
  begin
    Result := M div Month1Year;
    if (M mod Month1Year) <> 0 then
      Dec(Result);
  end
  else
    Result := M div Month1Year;
end;

function TQInterval.GetYearMonth: Integer;
begin
  Result := GetMonths;
end;

class operator TQInterval.GreaterThan(const Left, Right: TQInterval): Boolean;
begin
  Result := Left.GetMonths * Day1Month * MS1Day + Left.GetMillSeconds >
    Right.GetMonths * Day1Month * MS1Day + Right.GetMillSeconds;
end;

class operator TQInterval.GreaterThanOrEqual(const Left,
  Right: TQInterval): Boolean;
begin
  Result := Left.GetMonths * Day1Month * MS1Day + Left.GetMillSeconds >=
    Right.GetMonths * Day1Month * MS1Day + Right.GetMillSeconds;
end;

class operator TQInterval.Implicit(const S: QStringW): TQInterval;
begin
  Result.AsString := S;
end;

class operator TQInterval.Implicit(const V: Smallint): TQInterval;
begin
  if (V > 6362) or (V < -6362) then
    raise Exception.Create(SIntervalOutOfRange);
  Result.FData := V * MS1Day;
end;

function TQInterval.IncDay(const D: Smallint): PQInterval;
begin
  Day := Day + D;
  Result := @Self;
end;

function TQInterval.IncHour(const H: Smallint): PQInterval;
begin
  Hour := Hour + H;
  Result := @Self;
end;

function TQInterval.IncMilliSecond(const MS: Smallint): PQInterval;
begin
  MilliSecond := MilliSecond + MS;
  Result := @Self;
end;

function TQInterval.IncMinute(const M: Smallint): PQInterval;
begin
  Minute := Minute + M;
  Result := @Self;
end;

function TQInterval.IncMonth(const M: Smallint): PQInterval;
begin
  Month := Month + M;
  Result := @Self;
end;

function TQInterval.IncSecond(const S: Smallint): PQInterval;
begin
  Second := Second + S;
  Result := @Self;
end;

function TQInterval.IncYear(const Y: Integer): PQInterval;
begin
  Year := Year + Y;
  Result := @Self;
end;

procedure TQInterval.SetAsISOString(const Value: QStringW);
begin
  if not TryFromISOString(Value) then
    raise Exception.CreateFmt(SBadISOIntervalValue, [Value]);
end;

procedure TQInterval.SetAsOracleString(const Value: QStringW);
begin
  if not TryFromOracleString(Value) then
    raise Exception.CreateFmt(SBadOracleIntervalValue, [Value]);
end;

procedure TQInterval.SetAsPgString(const Value: QStringW);
begin
  if not TryFromPgString(Value) then
    raise Exception.CreateFmt(SBadPgIntervalString, [Value]);
end;

procedure TQInterval.SetAsSQLString(const Value: QStringW);
begin
  if not TryFromSQLString(Value) then
    raise Exception.CreateFmt(SBadSQLIntervalString, [Value]);
end;

procedure TQInterval.SetAsString(const Value: QStringW);
begin
  if not(TryFromISOString(Value) or TryFromPgString(Value) or
    TryFromOracleString(Value)) then
    raise Exception.CreateFmt(SBadIntervalValue, [Value]);
end;

procedure TQInterval.SetDay(const Value: Smallint);
begin
  Encode(Year, Month, Value, Hour, Minute, Second, MilliSecond);
end;

procedure TQInterval.SetDayToMs(const Value: Int64);
begin
  FData := (FData and $FFFFFF0000000000) or (Value and $FFFFFFFFFF);
end;

procedure TQInterval.SetHour(const Value: Shortint);
begin
  Encode(Year, Month, Day, Value, Minute, Second, MilliSecond);
end;

procedure TQInterval.SetMilliSecond(const Value: Smallint);
begin
  Encode(Year, Month, Day, Hour, Minute, Second, Value);
end;

procedure TQInterval.SetMinute(const Value: Shortint);
begin
  Encode(Year, Month, Day, Hour, Value, Second, MilliSecond);
end;

procedure TQInterval.SetMonth(const Value: Smallint);
begin
  SetMonthes((Year * 12) + Value);
end;

procedure TQInterval.SetMonthes(M: Int64);
begin
  if (M > 8388607) or (M < -8388608) then // ��24λ��ʾ��Χ
    raise Exception.Create(SIntervalOutOfRange);
  FData := (M shl 40) or (FData and $FFFFFFFFFF);
end;

procedure TQInterval.SetSecond(const Value: Shortint);
begin
  Encode(Year, Month, Day, Hour, Minute, Value, MilliSecond);
end;

procedure TQInterval.SetWeek(const Value: Smallint);
begin
  Day := Value * 7;
end;

procedure TQInterval.SetYear(const Value: Integer);
begin
  SetMonthes(Value * 12 + Month);
end;

procedure TQInterval.SetYearMonth(const Value: Integer);
begin
  FData := (Int64(Value) shl 40) or (FData and $FFFFFFFFFF);
end;

class function TQInterval.StringToInterval(const S: QStringW): TQInterval;
begin
  Result.AsString := S;
end;

class operator TQInterval.Subtract(const AInterval1, AInterval2: TQInterval)
  : TQInterval;
var
  M, MS: Int64;
begin
  M := AInterval1.GetMonths - AInterval2.GetMonths;
  MS := AInterval1.GetMillSeconds - AInterval2.GetMillSeconds;
  Result.FData := (M shl 40) or (MS and $FFFFFFFFFF);
end;

class operator TQInterval.Subtract(const ADate: TDateTime;
  const AInterval: TQInterval): TDateTime;
var
  Y: Integer;
  M, D, H, N, S, MS: Smallint;
begin
  AInterval.Decode(Y, M, D, H, N, S, MS);
  Result := dateutils.IncMilliSecond
    (dateutils.IncSecond(dateutils.IncMinute(dateutils.IncHour(dateutils.IncDay
    (sysutils.IncMonth(dateutils.IncYear(ADate, -Y), -M), -D), -H), -N),
    -S), -MS);
end;

function TQInterval.TryFromISOString(Value: QStringW): Boolean;
var
  P: PQCharW;
  pred: QCharW;
  V: Int64;
  Y: Integer;
  M, D, H, N, S, MS, W: Smallint;
  function ParseValue: Boolean;
  begin
    Result := True;
    if ParseInt(P, V) <> 0 then
    begin
      case P^ of
        'Y':
          Y := V;
        'M':
          begin
            if pred = 'P' then
              M := V
            else
              N := V;
          end;
        'D':
          D := V;
        'W':
          W := V;
        'H':
          H := V;
        'S':
          S := V;
        '.':
          begin
            S := V;
            Inc(P);
            if ParseInt(P, V) <> 0 then
            begin
              MS := V;
              if MS < 10 then
                MS := MS * 100
              else if MS < 100 then
                MS := MS * 10;
              Result := P^ = 'S';
            end;
          end
      else
        Result := False;
      end;
    end
    else if (P^ = 'T') and (pred = 'P') then
      pred := 'T'
    else
      Result := False;
  end;

begin
  Y := 0;
  M := 0;
  W := 0;
  D := 0;
  H := 0;
  N := 0;
  S := 0;
  MS := 0;
  P := PQCharW(Value);
  Result := False;
  if P^ = 'P' then
  begin
    Inc(P);
    pred := 'P';
    while (P^ <> #0) and ParseValue do
      Inc(P);
    if P^ = #0 then
    begin
      Result := True;
      if W <> 0 then
        Inc(D, W * 7);
      Encode(Y, M, D, H, N, S, MS);
    end;
  end;
end;

/// Oracle��ʱ������ʽ
function TQInterval.TryFromOracleString(Value: QStringW): Boolean;
var
  P, pexp, ptype: PQCharW;
  V: Int64;
  Y, M, D, H, N, S, MS: Smallint;
  AFromUnit, AToUnit, ANextUnit, AInc: Smallint;
  AExp, SFrom, STo: QStringW;
const
  PT_NONE = -1;
  PT_YEAR = 0;
  PT_MONTH = 1;
  PT_DAY = 2;
  PT_HOUR = 3;
  PT_MINUTE = 4;
  PT_SECOND = 5;
  SpaceChars: PQCharW = ' '#9#13#10;
  function GetPrecsion: Integer;
  var
    R: Int64;
  begin
    Result := 2;
    SkipSpaceW(ptype);
    if ptype^ = '(' then
    begin
      Result := -1;
      if ParseInt(ptype, R) <> 0 then
      begin
        SkipSpaceW(ptype);
        if ptype^ = ')' then
        begin
          Result := R;
          Inc(ptype);
          SkipSpaceW(ptype);
        end;
      end;
    end;
  end;
  function UnitType(const S: QStringW): Integer;
  var
    pt: PQCharW;
  begin
    pt := PQCharW(S);
    if StartWithW(pt, 'YEAR', True) then
      Result := PT_YEAR
    else if StartWithW(pt, 'MONTH', True) then
      Result := PT_MONTH
    else if StartWithW(pt, 'DAY', True) then
      Result := PT_DAY
    else if StartWithW(pt, 'HOUR', True) then
      Result := PT_HOUR
    else if StartWithW(pt, 'MINUTE', True) then
      Result := PT_MINUTE
    else if StartWithW(pt, 'SECOND', True) then
      Result := PT_SECOND
    else
      Result := PT_NONE;
  end;

begin
  Y := 0;
  M := 0;
  D := 0;
  H := 0;
  N := 0;
  S := 0;
  MS := 0;
  // Oracle��ʱ������INTERVAL YEAR TO MONTH��INTERVAL DAY TO SECOND������ʽ,�ֱ�������º��ղ���
  P := PQCharW(Value);
  Result := True;
  // Oracle��ʱ�����ĸ�ʽ�ɺ����Year to month ���� month to year���������µ�λ��
  if not StartWithW(P, 'interval', True) then
  begin
    Result := False;
    Exit;
  end;
  Inc(P, 8);
  SkipSpaceW(P);
  if P^ <> '''' then
  begin
    Result := False;
    Exit;
  end;
  Inc(P);
  pexp := P;
  while (P^ <> #0) and (P^ <> '''') do
    Inc(P);
  if P^ <> '''' then
  begin
    Result := False;
    Exit;
  end;
  AExp := Trim(StrDupX(pexp, (IntPtr(P) - IntPtr(pexp)) shr 1));
  pexp := PQCharW(AExp);
  Inc(P);
  SkipSpaceW(P);
  // ��ʼ���͵ļ��
  SFrom := UpperCase(DecodeTokenW(P, SpaceChars, QCharW(#0), True));
  if not StartWithW(P, 'TO', True) then
  begin
    Result := False;
    Exit;
  end;
  Inc(P, 2);
  SkipSpaceW(P);
  STo := UpperCase(P);
  AFromUnit := UnitType(SFrom);
  if Length(STo) > 0 then
    AToUnit := UnitType(STo)
  else
    AToUnit := AFromUnit;
  if (AFromUnit = PT_NONE) or (AToUnit = PT_NONE) then
  begin
    Result := False;
    Exit;
  end
  else if (AFromUnit in [PT_YEAR, PT_MONTH]) or (AToUnit in [PT_YEAR, PT_MONTH])
  then
  begin
    Result := (AFromUnit in [PT_YEAR, PT_MONTH]) and
      (AToUnit in [PT_YEAR, PT_MONTH]);
    if not Result then
      Exit;
    // ��->�»���->��(����ֵ�����ԣ�
    if ParseInt(pexp, V) <> 0 then
    begin
      if AFromUnit = PT_YEAR then
        Y := V
      else
        M := V;
      SkipSpaceW(pexp);
      if pexp^ = '-' then
      begin
        Inc(pexp);
        SkipSpaceW(pexp);
      end
      else if pexp^ = #0 then
      begin
        Result := AFromUnit <> AToUnit;
        if not Result then
          Exit;
      end;
    end
    else
    begin
      Result := False;
      Exit;
    end;
    if (AFromUnit <> AToUnit) and (ParseInt(pexp, V) <> 0) then
    begin
      if AToUnit = PT_YEAR then
        Y := V
      else
        M := V;
    end
    else
      Result := False;
  end
  else // Day to Second
  begin
    if AFromUnit < AToUnit then
      AInc := 1
    else
      AInc := -1;
    ANextUnit := AFromUnit;
    repeat
      if ParseInt(pexp, V) <> 0 then
      begin
        if ANextUnit = PT_DAY then
        begin
          D := V;
          if AToUnit > PT_DAY then // Day to xxx
          begin
            if IsSpaceW(pexp) then
              SkipSpaceW(pexp)
            else
              Result := False;
          end
          else
          begin
            SkipSpaceW(pexp);
            if pexp^ <> #0 then
              Result := False;
          end;
        end
        else if ANextUnit = PT_HOUR then
        begin
          H := V;
          if AToUnit = PT_DAY then // xxx To Day
          begin
            if IsSpaceW(pexp) then
              SkipSpaceW(pexp)
            else
              Result := False;
          end
          else
          begin
            SkipSpaceW(pexp);
            if AToUnit = PT_HOUR then
              Result := pexp^ = #0
            else
            begin
              Result := pexp^ = ':';
              if Result then
                Inc(pexp);
            end;
          end;
        end
        else if ANextUnit = PT_MINUTE then
        begin
          N := V;
          SkipSpaceW(pexp);
          if AToUnit = PT_MINUTE then
            Result := pexp^ = #0
          else
          begin
            Result := pexp^ = ':';
            if Result then
              Inc(pexp);
          end;
        end
        else if ANextUnit = PT_SECOND then
        begin
          S := V;
          if pexp^ = '.' then
          begin
            Inc(pexp);
            if ParseInt(pexp, V) <> 0 then
            begin
              if V < 10 then
                MS := V * 100
              else if V < 100 then
                MS := V * 10
              else if V < 1000 then
                MS := V
              else
              begin
                while V > 1000 do
                  V := V div 10;
                MS := V;
              end;
            end
            else
              Result := False;
          end;
          SkipSpaceW(pexp);
          if Result then
            Result := pexp^ = #0;
        end;
      end;
      if AToUnit = ANextUnit then
        Break
      else
        Inc(ANextUnit, AInc);
    until Result = False;
  end;
  if Result then
    Encode(Y, M, D, H, N, S, MS);
end;

function TQInterval.TryFromPgString(Value: QStringW): Boolean;
var
  P: PQCharW;
  V: Int64;
  Y1000, Y100, Y10, Y, M, D, H, N, S, MS, W: Smallint;

  function CheckTrailer(const S: PQCharW; Len: Integer): Boolean;
  var
    ps: PQCharW;
  begin
    ps := P;
    if StartWithW(P, S, True) then
    begin
      Inc(P, Len);
      if (P^ = 's') or (P^ = 'S') then
        Inc(P)
      else if StartWithW(P, '(s)', True) then
        Inc(P, 3);
      Result := (P^ = #0) or IsSpaceW(P);
      if not Result then
        P := ps;
    end
    else
      Result := False;
  end;

  function ParseValue: Boolean;
  begin
    Result := True;
    if ParseInt(P, V) <> 0 then
    begin
      SkipSpaceW(P);
      if (P^ = 'y') or (P^ = 'Y') then
      begin
        if (P^ = #0) or IsSpaceW(P) or CheckTrailer('year', 4) then
          Y := V
        else
          Result := False;
      end
      else if (P^ = 'm') or (P^ = 'M') then
      begin
        if (P^ = #0) or IsSpaceW(P) or CheckTrailer('min', 3) or
          CheckTrailer('minute', 6) then
          N := V
        else if CheckTrailer('mon', 3) or CheckTrailer('month', 5) then
          M := V
        else if StartWithW(P, 'ms', True) or CheckTrailer('millisecond', 11)
        then
          MS := V
        else if CheckTrailer('millennium', 10) then
          Y1000 := V
        else
          Result := False;
      end
      else if (P^ = 'w') or (P^ = 'W') then
      begin
        if (P^ = #0) or IsSpaceW(P) or CheckTrailer('week', 4) then
          W := V
        else
          Result := False;
      end
      else if (P^ = 'd') or (P^ = 'D') then // �ղ���
      begin
        if (P^ = #0) or IsSpaceW(P) or CheckTrailer('day', 3) then
          D := V
        else if CheckTrailer('dec', 3) or CheckTrailer('decade', 6) then
          Y10 := V
        else
          Result := False;
      end
      else if (P^ = 'h') or (P^ = 'H') then
      begin
        if (P^ = #0) or IsSpaceW(P) or CheckTrailer('hour', 4) then
          H := V
        else
          Result := False;
      end
      else if (P^ = 's') or (P^ = 'S') then
      begin
        if (P^ = #0) or IsSpaceW(P) or CheckTrailer('sec', 3) or
          CheckTrailer('second', 6) then
          S := V
        else
          Result := False;
      end
      else if (P^ = 'c') or (P^ = 'C') then
      begin
        if CheckTrailer('cent', 4) or CheckTrailer('century', 7) then
          Y100 := V
        else
          Result := False;
      end
      else if P^ = ':' then // hh:nn:ss.zzz
      begin
        H := V;
        Inc(P);
        if ParseInt(P, V) <> 0 then
        begin
          N := V;
          if P^ = ':' then
          begin
            Inc(P);
            if ParseInt(P, V) <> 0 then
            begin
              S := V;
              if P^ = '.' then
              begin
                Inc(P);
                if ParseInt(P, V) <> 0 then
                  MS := V;
              end;
            end;
          end;
        end;
      end;
    end
    else if StartWithW(P, 'ago', True) then
    begin
      Y := -Y;
      M := -M;
      D := -D;
      W := -W;
      H := -H;
      N := -N;
      S := -S;
      MS := -MS;
    end
    else
      Result := False;
  end;

begin
  P := PQCharW(Value);
  Y := 0;
  Y10 := 0;
  Y100 := 0;
  Y1000 := 0;
  M := 0;
  W := 0;
  D := 0;
  H := 0;
  N := 0;
  S := 0;
  MS := 0;
  if P^ = '@' then
  begin
    Inc(P);
    SkipSpaceW(P);
  end;
  while (P^ <> #0) and ParseValue do
    SkipSpaceW(P);
  if P^ <> #0 then
    Result := False
  else
  begin
    if W <> 0 then
      Inc(D, W * 7);
    if Y10 <> 0 then
      Inc(Y, Y10 * 10);
    if Y100 <> 0 then
      Inc(Y, Y100 * 100);
    if Y1000 <> 0 then
      Inc(Y, Y1000 * 1000);
    Encode(Y, M, D, H, N, S, MS);
    Result := True;
  end;
end;

function TQInterval.TryFromSQLString(Value: QStringW): Boolean;
var
  P: PQCharW;
  V: Int64;
  Y, M, D, H, N, S, MS: Smallint;
  function ParseValue: Boolean;
  begin
    Result := True;
    if ParseInt(P, V) <> 0 then
    begin
      if P^ = '-' then
      begin
        Y := V;
        Inc(P);
        if ParseInt(P, V) <> 0 then
        begin
          if (P^ = #0) or IsSpaceW(P) then
            M := V
          else
            Result := False;
        end;
      end
      else
      begin
        if IsSpaceW(P) then
        begin
          D := V;
          SkipSpaceW(P);
        end;
        if ParseInt(P, V) <> 0 then // Hour
        begin
          if P^ = ':' then
          begin
            H := V;
            Inc(P);
            if ParseInt(P, V) <> 0 then // Minute
            begin
              N := V;
              if P^ = ':' then
              begin
                Inc(P);
                if ParseInt(P, V) <> 0 then // Second
                begin
                  S := V;
                  if P^ = '.' then // MS
                  begin
                    Inc(P);
                    if ParseInt(P, V) <> 0 then
                    begin
                      if MS < 10 then
                        MS := V * 100
                      else if MS < 100 then
                        MS := V * 10
                      else
                        MS := V;
                    end
                    else
                      Result := False;
                  end // MSEnd
                  else
                  begin
                    SkipSpaceW(P);
                    Result := P^ = #0;
                  end;
                end
                else
                  Result := False;
                // Second End
              end
              else
              begin
                SkipSpaceW(P);
                Result := P^ = #0;
              end;
              // Minute End
            end
            else
              Result := False;
          end
          else
            Result := False;
          // Hour End
        end
        else
          Result := False;
        // Day End
      end;
    end;
  end;

begin
  // SQL ��-�� �� ʱ:��:��
  P := PQCharW(Value);
  while (P^ <> #0) and ParseValue do
    SkipSpaceW(P);
  Result := P^ = #0;
  if Result then
    Encode(Y, M, D, H, N, S, MS);
end;

function TQInterval.TryFromString(const Value: QStringW): Boolean;
begin
  Result := (TryFromISOString(Value) or TryFromPgString(Value) or
    TryFromOracleString(Value));
end;

// TQTimeStamp
{ TQTimeStamp }
// ���հ������ʱ������ͣ�ʼ�ղ�����ʱ����Ϣ����ʽΪ��
// ΢��(20λ),��(6λ->26),��(6λ->32),ʱ(5λ->37),��(5λ->42),��(4λ->46),��Ԫǰ��־(1λ->47)
// ����λ(1λ->48),��(16λ->64)
class operator TQTimestamp.Implicit(const AStamp: TSQLTimeStamp): TQTimestamp;
begin
  Result.Data := (Int64(AStamp.Fractions) and $FFFFF) + // ΢��
    ((Int64(AStamp.Second) shl 20) and $3F00000) + // ��
    ((Int64(AStamp.Minute) shl 26) and $FC000000) + // ��
    ((Int64(AStamp.Hour) shl 32) and $1F00000000) + // ʱ
    ((Int64(AStamp.Day) shl 37) and $3E000000000) + // ��
    ((Int64(AStamp.Month) shl 42) and $3C0000000000) + // ��
    ((Int64(AStamp.Year) shl 48) and Int64($FFFF000000000000)); // ��
end;

class operator TQTimestamp.Implicit(const AStamp: TQTimestamp): TSQLTimeStamp;
begin
  Result.Fractions := AStamp.Data and $0FFFFF;
  Result.Second := (AStamp.Data shr 20) and $3F;
  Result.Minute := (AStamp.Data shr 26) and $3F;
  Result.Hour := (AStamp.Data shr 32) and $1F;
  Result.Day := (AStamp.Data shr 37) and $1F;
  Result.Month := (AStamp.Data shr 42) and $F;
  Result.Year := (AStamp.Data shr 48) and $FFFF;
end;

class operator TQTimestamp.Implicit(const AStamp: TDateTime): TQTimestamp;
var
  Y, M, D, H, N, S, MS: Word;
begin
  DecodeDate(AStamp, Y, M, D);
  DecodeTime(AStamp, H, N, S, MS);
  Result.Encode(Y, M, D, H, N, S, MS);
end;

class operator TQTimestamp.Implicit(const AStamp: TQTimestamp): TDateTime;
begin
  Result := EncodeDate((AStamp.Data shr 48) and $FFFF, (AStamp.Data shr 42) and
    $F, (AStamp.Data shr 37) and $1F) + EncodeTime((AStamp.Data shr 32) and $1F,
    (AStamp.Data shr 26) and $3F, (AStamp.Data shr 20) and $3F,
    (AStamp.Data and $0FFFFF) div 1000);
end;

function TQTimestamp.IncDay(D: Integer): PQTimeStamp;
var
  MD: Integer;
begin
  Result := @Self;
  if D = 0 then
    Exit;
  if D > 0 then // ������
  begin
    D := Day + D;
    Day := 1;
    repeat
      MD := MonthDays[IsLeapYear(Year)][Month];
      if D > MD then
      begin
        IncMonth;
        Dec(D, MD);
      end
      else
      begin
        Day := D;
        Break;
      end;
    until False;
  end
  else // ��С��
  begin
    D := Day + D;
    Day := 1;
    repeat
      if D < 0 then
      begin
        IncMonth(-1);
        Inc(D, MonthDays[IsLeapYear(Year)][Month]);
      end
      else
      begin
        Day := D;
        Break;
      end;
    until False;
  end;
end;

function TQTimestamp.IncHour(H: Integer): PQTimeStamp;
begin
  H := Hour + H;
  if H > Hour1Day then
  begin
    IncDay(H div Hour1Day);
    Hour := H mod Hour1Day;
  end
  else if H < 0 then
  begin
    IncDay(H div Hour1Day - 1);
    Hour := (H mod Hour1Day) + Hour1Day;
  end
  else
    Hour := H;
  Result := @Self;
end;

function TQTimestamp.IncMacroSecond(MS: Integer): PQTimeStamp;
begin
  MS := MacroSecond + MS;
  if MS > MacroSecond1Second then
  begin
    IncSecond(MS div MacroSecond1Second);
    MacroSecond := MS mod MacroSecond1Second;
  end
  else if MS < 0 then
  begin
    IncSecond(MS div MacroSecond1Second - 1);
    MacroSecond := MacroSecond1Second + MS mod MacroSecond1Second;
  end
  else
    MacroSecond := MS;
  Result := @Self;
end;

function TQTimestamp.IncMillSecond(MS: Integer): PQTimeStamp;
begin
  MS := MilliSecond + MS;
  if MS > MS1Second then
  begin
    IncSecond(MS div MS1Second);
    MilliSecond := MS mod MS1Second;
  end
  else if MS < 0 then
  begin
    IncSecond(MS div MS1Second - 1);
    MilliSecond := MS1Second + MS mod MS1Second;
  end
  else
    MilliSecond := MS;
  Result := @Self;
end;

function TQTimestamp.IncMinute(M: Integer): PQTimeStamp;
begin
  M := Minute + M;
  if M > Minute1Hour then
  begin
    IncHour(M div Minute1Hour);
    Minute := M mod Minute1Hour;
  end
  else if M < 0 then
  begin
    IncHour(M div Minute1Hour - 1);
    Minute := Minute1Hour + M mod Minute1Hour;
  end
  else
    Minute := M;
  Result := @Self;
end;

function TQTimestamp.IncMonth(M: Integer): PQTimeStamp;
var
  AMaxDay: Byte;
begin
  Result := @Self;
  if M = 0 then
    Exit;
  M := Month + M;
  if M > Month1Year then
  begin
    IncYear(M div Month1Year);
    Month := M mod Month1Year;
  end
  else if M < 0 then
  begin
    IncYear(M div Month1Year - 1);
    Month := Month1Year + (M mod Month1Year);
  end
  else
    Month := M;
  AMaxDay := MonthDays[IsLeapYear(Year)][Month];
  if Day > AMaxDay then
    Day := AMaxDay;
end;

function TQTimestamp.IncSecond(S: Integer): PQTimeStamp;
begin
  S := Second + S;
  if S > Second1Minute then
  begin
    IncMinute(S div Second1Minute);
    Second := S mod Second1Minute;
  end
  else if S < 0 then
  begin
    IncMinute(S div Second1Minute - 1);
    Second := Second1Minute - S mod Second1Minute;
  end
  else
    Second := S;
  Result := @Self;
end;

function TQTimestamp.IncYear(Y: Smallint): PQTimeStamp;
begin
  Result := @Self;
  if Y <> 0 then
    Year := Year + Y;
end;

{ TQTimeStampHelper }

procedure TQTimestamp.Clear;
begin
  Data := 0;
end;

procedure TQTimestamp.Encode(const Y: Smallint; const M, D, H, N, S: Byte;
  const MS: Word);
begin
  if (Y <> 0) or (M <> 0) or (D <> 0) then // ������
  begin
    if (M < 1) or (M > 12) or (D < 1) or (D > 31) then
      raise Exception.CreateFmt(SBadTimeValue, [Y, M, D, H, N, S, MS]);
    if D > MonthDays[IsLeapYear(Y)][M] then
      raise Exception.CreateFmt(SBadTimeValue, [Y, M, D, H, N, S, MS]);
    if (Y = 1582) and (M = 10) and (D >= 5) and (D <= 14) then
      // 1582-10-5~1582-10-14������������Ч������
      raise Exception.CreateFmt(SBadTimeValue, [Y, M, D, H, N, S, MS]);
  end
  else if (H > 23) or (N > 59) or (S > 59) or (MS > 999) then
    raise Exception.CreateFmt(SBadTimeValue, [Y, M, D, H, N, S, MS]);
  Data := (Int64(MS * 1000) and $00000000000FFFFF) + // ΢��
    ((Int64(S) shl 20) and $0000000003F00000) + // ��
    ((Int64(N) shl 26) and $00000000FC000000) + // ��
    ((Int64(H) shl 32) and $0000001F00000000) + // ʱ
    ((Int64(D) shl 37) and $000003E000000000) + // ��
    ((Int64(M) shl 42) and $00003C0000000000) + // ��
    ((Int64(Y) shl 48) and Int64($FFFF000000000000)); // ��
end;

procedure TQTimestamp.Encode(const Y: Smallint; const M, D: Byte);
begin
  Encode(Y, M, D, 0, 0, 0, 0);
end;

procedure TQTimestamp.Encode(const H, N, S: Byte; const MS: Word);
begin
  Encode(0, 0, 0, H, N, S, MS);
end;

function TQTimestamp.GetAsString: QStringW;
  function AddTime: QStringW;
  var
    MS: Word;
  begin
    Result := IntToStr(Hour) + ':' + IntToStr(Minute) + ':' + IntToStr(Second);
    MS := MilliSecond;
    if MS <> 0 then
    begin
      if (MS mod 100) = 0 then
        Result := Result + '.' + IntToStr(MS div 100)
      else if (MS mod 10) = 0 then
        Result := Result + '.' + IntToStr(MS div 10)
      else if MS < 10 then
        Result := Result + '.00' + IntToStr(MS)
      else if MS < 100 then
        Result := Result + '.0' + IntToStr(MS)
      else
        Result := Result + '.' + IntToStr(MS);
    end;
  end;

begin
  if HasDate then
  begin
    Result := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day);
    if HasTime then
      Result := Result + 'T' + AddTime;
  end
  else
  begin
    SetLength(Result, 0);
    Result := AddTime;
  end;
end;

function TQTimestamp.GetDay: Byte;
begin
  Result := (Data shr 37) and $1F;
end;

function TQTimestamp.GetHasDate: Boolean;
begin
  Result := (Data and $FFFF3FE000000000) <> 0; // 46�ǹ�Ԫ��־��47λδ��
end;

function TQTimestamp.GetHasTime: Boolean;
begin
  Result := (Data and $0000001FFFFFFFFF) <> 0;
end;

function TQTimestamp.GetHour: Byte;
begin
  Result := (Data shr 32) and $1F;
end;

function TQTimestamp.GetIsBC: Boolean;
begin
  Result := (Data and $400000000000) <> 0;
end;

function TQTimestamp.GetMacroSecond: Integer;
begin
  Result := Data and $0FFFFF;
end;

function TQTimestamp.GetMilliSecond: Word;
begin
  Result := (Data and $0FFFFF) div 1000;
end;

function TQTimestamp.GetMinute: Byte;
begin
  Result := (Data shr 26) and $3F;
end;

function TQTimestamp.GetMonth: Byte;
begin
  Result := (Data shr 42) and $F;
end;

function TQTimestamp.GetSecond: Byte;
begin
  Result := (Data shr 20) and $3F;
end;

function TQTimestamp.GetYear: Smallint;
begin
  Result := (Data shr 48) and $FFFF;
end;

procedure TQTimestamp.SetAsString(const Value: QStringW);
var
  ATemp: TDateTime;
begin
  if TryStrToTime(Value, ATemp) or ParseDateTime(PQCharW(Value), ATemp) or
    ParseWebTime(PQCharW(Value), ATemp) then
  begin
    Self := ATemp;
  end
  else
    raise Exception.CreateFmt(SBadDateTimeString, [Value]);
end;

procedure TQTimestamp.SetDay(const Value: Byte);
begin
  if (Value < 1) or (Value > MonthDays[IsLeapYear(Year)][Month]) then
    raise Exception.CreateFmt(SMonthOutOfRange,
      [Value, MonthDays[IsLeapYear(Year)][Month]]);
  Data := (Data and $FFFFFC1FFFFFFFFF) or
    ((Int64(Value) shl 37) and $3E000000000);
end;

procedure TQTimestamp.SetHour(const Value: Byte);
begin
  if Value > 23 then
    raise Exception.CreateFmt(SHourOutOfRange, [Value]);
  Data := (Data and $FFFFFFE0FFFFFFFF) or
    ((Int64(Value) shl 32) and $1F00000000);
end;

procedure TQTimestamp.SetIsBC(const Value: Boolean);
begin
  if Value then
    Data := Data or $400000000000
  else
    Data := Data and $FFFFBFFFFFFFFFFF;
end;

procedure TQTimestamp.SetMacroSecond(const Value: Integer);
begin
  if Value > 999999 then
    raise Exception.CreateFmt(SMacroSecondOutOfRange, [Value]);
  Data := (Data and $FFFFFFFFFFF00000) or (Value and $FFFFF);
end;

procedure TQTimestamp.SetMilliSecond(const Value: Word);
begin
  if Value > 999 then
    raise Exception.CreateFmt(SMSOutOfRange, [Value]);
  Data := (Data and $FFFFFFFFFFF00000) or
    ((Value * 1000 and $FFFFF) + ((Data and $FFFFF) mod 1000));
end;

procedure TQTimestamp.SetMinute(const Value: Byte);
begin
  if Value > 59 then
    raise Exception.CreateFmt(SMinuteOutOfRange, [Value]);
  Data := (Data and $FFFFFFFF03FFFFFF) or ((Int64(Value) shl 26) and $FC000000);
end;

procedure TQTimestamp.SetMonth(const Value: Byte);
begin
  if (Value < 1) or (Value > 12) then
    raise Exception.CreateFmt(SMonthOutOfRange, [Value]);
  Data := (Data and $FFFFC3FFFFFFFFFF) or
    ((Int64(Value) shl 42) and $3C0000000000);
end;

procedure TQTimestamp.SetSecond(const Value: Byte);
begin
  if Value > 59 then
    raise Exception.CreateFmt(SSecondOutOfRange, [Value]);
  Data := (Data and $FFFFFFFFFC0FFFFF) or ((Int64(Value) shl 20) and $3F00000);
end;

procedure TQTimestamp.SetYear(const Value: Smallint);
begin
  Data := (Data and $FFFFFFFFFFFF) or
    ((Int64(Value) shl 48) and $FFFF000000000000);
end;

function DefaultIsWorkDay(ADate: TDateTime): Boolean;
begin
  Result := DayOfTheWeek(ADate) in [1 .. 5];
end;

{ TQPlanMask }

function TQPlanMask.Accept(const ALimit: PQTimeLimit; AValue: Word): Boolean;
var
  I: Integer;
begin
  if Length(ALimit^) = 0 then
    Result := True
  else
  begin
    Result := False;
    for I := 0 to High(ALimit^) do
    begin
      Result := Accept(ALimit^[I], AValue);
      if Result then
        Break;
    end;
  end;
end;

function TQPlanMask.Accept(const ALimit: TQTimeLimitItem; AValue: Word)
  : Boolean;
begin
  Result := False;
  if (ALimit.Flags and (PLAN_MASK_ANY or PLAN_MASK_IGNORE)) <> 0 then
    Result := True
  else if (ALimit.Flags and PLAN_MASK_RANGE) <> 0 then
    Result := (AValue >= Word(ALimit.Start)) and (AValue <= Word(ALimit.Stop))
  else if (ALimit.Flags and PLAN_MASK_REPEAT) <> 0 then
    Result :=(AValue>=Word(ALimit.Start)) and (AValue<=Word(ALimit.Stop)) and (((AValue - ALimit.Start) mod ALimit.Interval) = 0)
  else if (ALimit.Flags and PLAN_MASK_LAST) = 0 then
    Result := AValue = Word(ALimit.Start);
end;

function TQPlanMask.Accept(ATime: TDateTime): Boolean;
var
  Y, M, D, H, N, S, MS: Word;
begin
  if Assigned(FOnTimeAccept) then
    FOnTimeAccept(@Self, ATime, Result)
  else if (ATime > FStartTime) and (ATime < FStopTime) and (ATime > FLastTime)
  then
  begin
    DecodeDateTime(ATime, Y, M, D, H, N, S, MS);
    Result := Accept(@FLimits[tlpYear], Y) and Accept(@FLimits[tlpMonthOfYear],
      M) and AcceptDay(Y, M, D) and Accept(@FLimits[tlpHour], H) and
      Accept(@FLimits[tlpMinute], N) and Accept(@FLimits[tlpSecond], S);
  end
  else
    Result := False;
end;

function TQPlanMask.AcceptDay(Y, M, D: Word): Boolean;
var
  I: Integer;
  WD, MD: Word;
  ALimit: PQTimeLimit;
  ADate, AWDPrior, AWDNext: TDateTime;
  AY, AM, AD: Word;
  AIsLeapYear: Boolean;
begin
  Result := False;
  ALimit := @FLimits[tlpDayOfMonth];
  AIsLeapYear := IsLeapYear(Y);
  if Length(ALimit^) > 0 then
  begin
    for I := 0 to High(ALimit^) do
    begin
      if (ALimit^[I].Flags and PLAN_MASK_LAST) <> 0 then
      begin
        if (ALimit^[I].Flags and PLAN_MASK_WORKDAY) <> 0 then
        begin
          MD := MonthDays[AIsLeapYear][M] + ALimit^[I].Start;
          if MD > MonthDays[AIsLeapYear][M] then
            MD := MonthDays[AIsLeapYear][M];
          ADate := EncodeDate(Y, M, MD);
          if not IsWorkDay(ADate) then
          begin
            AWDPrior := ADate - 1;
            while not IsWorkDay(AWDPrior) do
              AWDPrior := AWDPrior - 1;
            AWDNext := ADate + 1;
            while not IsWorkDay(AWDNext) do
              AWDNext := AWDNext + 1;
            if (ADate - AWDPrior) > (AWDNext - ADate) then
              ADate := AWDNext
            else
              ADate := AWDPrior;
          end;
          DecodeDate(ADate, AY, AM, AD);
          Result := (D = AD) and (M = AM) and (Y = AY);
        end
        else
          Result := (D = MonthDays[AIsLeapYear][M] + ALimit^[I].Start) // L-n
      end
      else
        Result := Accept(ALimit^[I], D);
      if Result then
        Break;
    end;
  end
  else
    Result := True;
  if not Result then
    Exit;
  ALimit := @FLimits[tlpDayOfWeek];
  if Length(ALimit^) > 0 then
  begin
    ADate := EncodeDate(Y, M, D);
    WD := DayOfTheWeek(ADate);
    Result := False;
    for I := 0 to High(ALimit^) do
    begin
      if (ALimit^[I].Flags and PLAN_MASK_LAST) <> 0 then
      begin
        if Word(ALimit^[I].Start) = WD then
        begin
          MD := MonthDays[AIsLeapYear][M];
          ADate := EncodeDate(Y, M, MD);
          while DayOfTheWeek(ADate) <> WD do
            ADate := ADate - 1;
          Result := D = DayOf(ADate);
          if Result and ((ALimit^[I].Flags and PLAN_MASK_WORKDAY) <> 0) then
            Result := IsWorkDay(ADate);
        end;
      end
      else if (ALimit^[I].Flags and PLAN_MASK_WEEKOFMONTH) <> 0 then
      // ����ָ�����ܵ���n
      begin
        // �������ڵĵ�n��
        ADate := EncodeDate(Y, M, 1) + 7 * ALimit^[I].Stop;
        ADate := ADate + ALimit^[I].Start - DayOfTheWeek(ADate);
        DecodeDate(ADate, AY, AM, AD);
        Result := (D = AD) and (M = AM) and (Y = AY);
      end
      else if (ALimit^[I].Flags and PLAN_MASK_WORKDAY) <> 0 then
        Result := IsWorkDay(ADate)
      else
        Result := Accept(ALimit^[I], WD);
      if Result then
        Break;
    end;
  end;
end;

class function TQPlanMask.Create(const AMask: QStringW): TQPlanMask;
begin
  Result.AsString := AMask;
end;

class function TQPlanMask.Create: TQPlanMask;
begin
  Result.Reset;
end;

function TQPlanMask.GetAsString: QStringW;
var
  I: TQTimeLimitPart;
  J: Integer;
begin
  Result := '';
  for I := tlpSecond to tlpYear do
  begin
    if Length(FLimits[I]) > 0 then
    begin
      for J := 0 to High(FLimits[I]) do
      begin
        if J > 0 then
          Result := Result + ',';
        if (FLimits[I][J].Flags and PLAN_MASK_ANY) <> 0 then
        begin
          if I <> tlpYear then
            Result := Result + '*';
          Break;
        end
        else if (FLimits[I][J].Flags and PLAN_MASK_IGNORE) <> 0 then
        begin
          Result := Result + '?';
          Break;
        end
        else if (FLimits[I][J].Flags and PLAN_MASK_RANGE) <> 0 then
        begin
          Result := Result + IntToStr(FLimits[I][J].Start) + '-' +
            IntToStr(FLimits[I][J].Stop);
        end
        else
        begin
          if (FLimits[I][J].Flags and PLAN_MASK_LAST) <> 0 then
          begin
            if FLimits[I][J].Start < 0 then
              Result := Result + 'L' + IntToStr(FLimits[I][J].Start)
            else if FLimits[I][J].Start > 0 then
              Result := Result + IntToStr(FLimits[I][J].Start) + 'L'
            else
              Result := Result + 'L';
          end
          else if (FLimits[I][J].Start <> 0) or (I <> tlpDayOfWeek) then
            Result := Result + IntToStr(FLimits[I][J].Start);
        end;
        if (FLimits[I][J].Flags and PLAN_MASK_REPEAT) <> 0 then
          Result := Result + '/' + IntToStr(FLimits[I][J].Interval);
        if (FLimits[I][J].Flags and PLAN_MASK_WORKDAY) <> 0 then
          Result := Result + 'W';
        if (FLimits[I][J].Flags and PLAN_MASK_WEEKOFMONTH) <> 0 then
          Result := Result + '#' + IntToStr(FLimits[I][J].Stop);
      end;
      Result := Result + ' ';
    end
    else if I <> tlpYear then
      Result := Result + '* ';
  end;
  if Length(FContent) > 0 then
    Result := Result + FContent
  else
    SetLength(Result, Length(Result) - 1);
end;

function TQPlanMask.GetLimits: PQTimeLimits;
begin
  Result := @FLimits;
end;

{ NextAcceptValue: 对于给定的时间限制数组和当前值，返回下一个 >=AValue 的合法值。
  与 Accept 不同，它不是逐个检查，而是直接跳过不合法值跳到下一个。
  @ALimit 时间限制数组
  @AValue 当前值
  @AMax  允许的最大值（小时=23, 分钟=59, 秒=59）
  @ANext [out] 下一个合法值
  @return True=找到 }
function NextAcceptValue(const ALimit: PQTimeLimit; AValue, AMax: Word;
  out ANext: Word): Boolean;
var
  I: Integer;
  V, VBest: Word;
  AItem: TQTimeLimitItem;
begin
  Result := False;
  if Length(ALimit^) = 0 then
  begin
    ANext := AValue;
    Exit(True);
  end;
  VBest := $FFFF;
  for I := 0 to High(ALimit^) do
  begin
    AItem := ALimit^[I];
    V := $FFFF;
    if (AItem.Flags and PLAN_MASK_IGNORE) <> 0 then
    begin
      VBest := AValue;
      Break;
    end;
    if (AItem.Flags and PLAN_MASK_ANY) <> 0 then
    begin
      if (AItem.Flags and PLAN_MASK_REPEAT) <> 0 then
      begin
        if AValue <= Word(AItem.Stop) then
        begin
          if AValue < Word(AItem.Start) then
            V := Word(AItem.Start)
          else
          begin
            V := (AValue - Word(AItem.Start)) div Word(AItem.Interval);
            V := Word(AItem.Start) + V * Word(AItem.Interval);
            if V < AValue then
              Inc(V, Word(AItem.Interval));
          end;
          if V > Word(AItem.Stop) then
            V := $FFFF;
        end;
      end
      else
      begin
        VBest := AValue;
        Break;
      end;
    end
    else if (AItem.Flags and PLAN_MASK_RANGE) <> 0 then
    begin
      if AValue <= Word(AItem.Stop) then
      begin
        if AValue < Word(AItem.Start) then
          V := Word(AItem.Start)
        else
          V := AValue;
        if (AItem.Flags and PLAN_MASK_REPEAT) <> 0 then
        begin
          if V > Word(AItem.Start) then
            V := ((V - Word(AItem.Start) + Word(AItem.Interval) - 1)
              div Word(AItem.Interval)) * Word(AItem.Interval) + Word(AItem.Start);
          if V > Word(AItem.Stop) then
            V := $FFFF;
        end;
      end;
    end
    else if (AItem.Flags and PLAN_MASK_REPEAT) <> 0 then
    begin
      if AValue <= Word(AItem.Stop) then
      begin
        if AValue < Word(AItem.Start) then
          V := Word(AItem.Start)
        else
          V := ((AValue - Word(AItem.Start) + Word(AItem.Interval) - 1)
            div Word(AItem.Interval)) * Word(AItem.Interval) + Word(AItem.Start);
        if V > Word(AItem.Stop) then
          V := $FFFF;
      end;
    end
    else if (AItem.Flags and (PLAN_MASK_LAST or PLAN_MASK_WEEKOFMONTH
      or PLAN_MASK_WORKDAY)) = 0 then
    begin
      if AValue <= Word(AItem.Start) then
        V := Word(AItem.Start);
    end;
    if V < VBest then
      VBest := V;
  end;
  if (VBest <> $FFFF) and (VBest <= AMax) then
  begin
    ANext := VBest;
    Result := True;
  end;
end;

function TQPlanMask.GetNextTime: TDateTime;
var
  Y, M, D, H, N, S, MS: Word;

  function CalcDate: Boolean;
  var
    AY, AM, AD: Word;
    AMaxYear:Word;
    AIsLeapYear: Boolean;
  begin
    AY := Y;
    AM := M;
    AD := D;
    Result := False;
    AMaxYear:=YearOf(FStopTime);
    while AY <= AMaxYear do
    begin
      { 年: 使用跳跃算法 }
      if not NextAcceptValue(@FLimits[tlpYear], AY, AMaxYear, AY) then
        Exit;
      if AY > AMaxYear then
        Exit;
      AIsLeapYear := IsLeapYear(AY);
      if AY > Y then
      begin
        AM := 1;
        AD := 1;
      end;
      while AM <= 12 do
      begin
        { 月: 使用跳跃算法 }
        if not NextAcceptValue(@FLimits[tlpMonthOfYear], AM, 12, AM) then
          Break;
        if AM > 12 then
          Break;
        if (AY > Y) or (AM > M) then
          AD := 1;
        while AD <= MonthDays[AIsLeapYear][AM] do
        begin
          if AcceptDay(AY, AM, AD) then // Day 含 L/W/# 逻辑，保留原样
          begin
            if (AD <> D) or (AM <> M) or (AY <> Y) then
            begin
              H := 0;
              N := 0;
              S := 0;
            end;
            Y := AY;
            M := AM;
            D := AD;
            Result := True;
            Exit;
          end;
          Inc(AD);
        end;
        Inc(AM);
        AD := 1;
      end;
      Inc(AY);
      AM := 1;
      AD := 1;
    end;
  end;

  function CalcTime: Boolean;
  var
    NH, NM, NS: Word;
  begin
    Result := False;
    NH := H;
    while NH < 24 do
    begin
      { 时: 使用跳跃算法 }
      if not NextAcceptValue(@FLimits[tlpHour], NH, 23, NH) then
        Exit;
      if NH > 23 then
        Exit;
      if NH > H then
      begin
        NM := 0;
        NS := 0;
      end
      else
      begin
        NM := N;
        NS := S;
      end;
      while NM < 60 do
      begin
        { 分: 使用跳跃算法 }
        if not NextAcceptValue(@FLimits[tlpMinute], NM, 59, NM) then
          Break;
        if NM > 59 then
          Break;
        if (NH > H) or (NM > N) then
          NS := 0;
        while NS < 60 do
        begin
          { 秒: 使用跳跃算法 }
          if not NextAcceptValue(@FLimits[tlpSecond], NS, 59, NS) then
            Break;
          if NS > 59 then
            Break;
          H := NH;
          N := NM;
          S := NS;
          Result := True;
          Exit;
        end;
        Inc(NM);
      end;
      Inc(NH);
    end;
  end;

begin
  Result := IncSecond(FLastTime);
  // if (Result>FLastTime) and ((Result-FLastTime)<1/86400) then//��������뵱ǰʱ����ͬ���򴥷���������1��֮��
  // Result := IncSecond(FLastTime);
  if Assigned(FOnTimeAccept) then // �û��Լ�����ģ����ڲ����
    Result := 0
  else if (Result >= FStartTime) and (Result < FStopTime) then
  begin
    DecodeDateTime(Result, Y, M, D, H, N, S, MS);
    repeat
      if CalcDate then
      begin
        if CalcTime then
        begin
          Result := EncodeDateTime(Y, M, D, H, N, S, 0);
          Exit;
        end
        else
        begin
          Result := IncDay(EncodeDate(Y, M, D));
          DecodeDate(Result, Y, M, D);
          H := 0;
          N := 0;
          S := 0;
        end;
      end
      else
        Break;
    until Result > FStopTime;
    Result := 0;
  end
  else
    Result := 0;
end;

procedure TQPlanMask.Reset;
var
  I: TQTimeLimitPart;
begin
  for I := tlpSecond to tlpYear do
    SetLength(FLimits[I], 0);
  SetLength(FContent, 0);
  FStartTime := Now;
  FLastTime := FStartTime;
  FOnTimeAccept := nil;
  FStopTime := EncodeDateTime(2099, 12, 31, 23, 59, 59, 999);
end;

procedure TQPlanMask.SetAsString(const S: QStringW);
var
  P: PQCharW;
  AIdx: TQTimeLimitPart;
  V: Int64;
  AItemIndex: Integer;
const
  MASK_ANY: WideChar = '*';
  MASK_IGNORE: WideChar = '?';
  MASK_RANGE: WideChar = '-';
  MASK_INTERVAL: WideChar = '/';
  MASK_LAST: WideChar = 'L';
  MASK_LIST: WideChar = ',';
  MASK_WEEKOFMONTH: WideChar = '#';
  MASK_WORKDAY: WideChar = 'W';
  NullChar: WideChar = #0;
const
  ValueLimits: array [0 .. 13] of Word = (
    // Second
    0, 59,
    // Minute
    0, 59,
    // Hour
    0, 23,
    // Day of Month ����ͬ���·��в�ͬ������
    1, 31,
    // Month
    1, 12,
    // Day Of Week 1-���գ�2-��һ������7-����
    1, 7,
    // �������
    1970, 2099);
  WeekDayNames: array [1 .. 7] of QStringW = ('MON', // ��һ
    'TUE', // �ܶ�
    'WED', // ����
    'THU', // ����
    'FRI', // ����
    'SAT', // ����
    'SUN' // ����
    );
  MonthNames: array [1 .. 12] of QStringW = ('JAN', // һ��
    'FEB', // ����
    'MAR', // ����
    'APR', // ����
    'MAY', // ����
    'JUN', // ����
    'JUL', // ����
    'AUG', // ����
    'SEP', // ����
    'OCT', // ʮ��
    'NOV', // ʮһ��
    'DEC' // Dec.ʮ����
    );

  function ParseValue(Opt: Boolean): Boolean;
  var
    I: Integer;
  begin
    Result := ParseInt(P, V) <> 0;
    if not Result then
    begin
      if AIdx = tlpDayOfWeek then
      begin
        for I := 1 to 7 do
        begin
          if StartWithW(P, PWideChar(WeekDayNames[I]), True) then
          begin
            V := I;
            Inc(P, 3);
            Result := True;
            Break;
          end;
        end;
      end
      else if AIdx = tlpMonthOfYear then
      begin
        for I := 1 to 12 do
        begin
          if StartWithW(P, PWideChar(MonthNames[I]), True) then
          begin
            V := I;
            Inc(P, 3);
            Result := True;
            Break;
          end;
        end;
      end;
    end;
    if Result then
    begin
      if V >= 0 then
        Result := (V >= ValueLimits[Integer(AIdx) shl 1]) and
          (V <= ValueLimits[(Integer(AIdx) shl 1) + 1])
      else
        Result := AIdx = tlpDayOfMonth;
    end;
    if not(Result or Opt) then
      raise QException.CreateFmt(SBadPlanMask, [S]);
  end;

  function CalcMax(const ALimit: TQTimeLimit; const AMax: Word): Word;
  const
    PLAN_ANY_REPEAT = PLAN_MASK_ANY or PLAN_MASK_REPEAT;
  var
    I: Integer;
  begin
    Result := 0;
    for I := 0 to High(ALimit) do
    begin
      if (ALimit[I].Flags and PLAN_ANY_REPEAT) <> 0 then
        Exit(AMax);
      if Word(ALimit[I].Stop) > Result then
        Result := Word(ALimit[I].Stop);
    end;
  end;
  procedure CalcStopTime;
  var
    Y, M, D, H, N, S: Word;
  begin
    // �ж��Ƿ�̶������
    Y := CalcMax(FLimits[tlpYear], 9999);
    if Y = 9999 then
      Exit;
    M := CalcMax(FLimits[tlpMonthOfYear], 12);
    D := CalcMax(FLimits[tlpDayOfMonth], MonthDays[IsLeapYear(Y)][M]);
    H := CalcMax(FLimits[tlpHour], 23);
    N := CalcMax(FLimits[tlpMinute], 59);
    S := CalcMax(FLimits[tlpSecond], 59);
    TryEncodeDateTime(Y, M, D, H, N, S, 0, FStopTime);
  end;

begin
  Reset;
  if Length(S) > 0 then
  begin
    P := PWideChar(S);
    SkipSpaceW(P);
    AIdx := tlpSecond;
    while (P^ <> NullChar) and (AIdx <= tlpYear) do
    begin
      SetLength(FLimits[AIdx], 1);
      AItemIndex := 0;
      if P^ = MASK_ANY then
      begin
        Inc(P);
        FLimits[AIdx][AItemIndex].Flags := PLAN_MASK_ANY;
      end
      else if P^ = MASK_IGNORE then
      begin
        if AIdx in [tlpDayOfWeek, tlpDayOfMonth] then
        begin
          Inc(P);
          FLimits[AIdx][AItemIndex].Flags := PLAN_MASK_IGNORE;
        end
        else
          raise QException.CreateFmt(SBadPlanMask, [S]);
      end
      else
      begin
        repeat
          if P^ = MASK_LAST then
          begin
            Inc(P);
            FLimits[AIdx][AItemIndex].Flags := FLimits[AIdx][AItemIndex]
              .Flags or PLAN_MASK_LAST;
            if IsSpaceW(P) then
              Break;
          end;
          if not ParseValue(AIdx in [tlpYear, tlpDayOfMonth, tlpDayOfWeek]) then
          // ��������
          begin
            if AIdx = tlpYear then
            begin
              FLimits[AIdx][AItemIndex].Flags := FLimits[AIdx][AItemIndex]
                .Flags or PLAN_MASK_ANY;
              Break;
            end
            else
            begin
              if (P^ = 'L') or (P^ = 'W') then
              begin
                if AIdx in [tlpDayOfWeek, tlpDayOfMonth] then
                  V := 0
              end
              else
                raise QException.CreateFmt(SBadPlanMask, [S]);
            end;
          end
          else
          begin
            if (V = 0) and (AIdx = tlpDayOfWeek) then // �ܵ�ʱ��0תΪ7
              V := 7;
          end;
          FLimits[AIdx][AItemIndex].Start := V;
          FLimits[AIdx][AItemIndex].Stop := V; // Ĭ����ʼ�����һ��
          if P^ = MASK_RANGE then // ��Χ
          begin
            Inc(P);
            ParseValue(False);
            if V < FLimits[AIdx][AItemIndex].Start then
              raise QException.CreateFmt(SBadPlanMask, [S]);
            FLimits[AIdx][AItemIndex].Stop := V;
            FLimits[AIdx][AItemIndex].Flags := FLimits[AIdx][AItemIndex]
              .Flags or PLAN_MASK_RANGE;
          end;
          if P^ = MASK_INTERVAL then // �ظ�
          begin
            Inc(P);
            ParseValue(False);
            FLimits[AIdx][AItemIndex].Interval := V;
            FLimits[AIdx][AItemIndex].Flags := FLimits[AIdx][AItemIndex]
              .Flags or PLAN_MASK_REPEAT;
            //���Ƿ�Χ���ظ��������ֵ����Ϊ���ɴﵽ��ֵ
            if (FLimits[AIdx][AItemIndex].Flags and PLAN_MASK_RANGE)=0 then
              FLimits[AIdx][AItemIndex].Stop:=32767;
          end;
          if P^ = MASK_WEEKOFMONTH then
          begin
            Inc(P);
            ParseValue(False);
            FLimits[AIdx][AItemIndex].Stop := V;
            FLimits[AIdx][AItemIndex].Flags := FLimits[AIdx][AItemIndex]
              .Flags or PLAN_MASK_WEEKOFMONTH;
          end;
          if P^ = MASK_WORKDAY then
          begin
            Inc(P);
            FLimits[AIdx][AItemIndex].Flags := FLimits[AIdx][AItemIndex]
              .Flags or PLAN_MASK_WORKDAY;
          end;
          if P^ = MASK_LAST then
          begin
            Inc(P);
            FLimits[AIdx][AItemIndex].Flags := FLimits[AIdx][AItemIndex]
              .Flags or PLAN_MASK_LAST;
          end;
          if P^ = MASK_LIST then // �б�
          begin
            SetLength(FLimits[AIdx], Length(FLimits[AIdx]) + 1);
            Inc(AItemIndex);
            Inc(P);
          end;
        until IsSpaceW(P) or (P^ = #0);
      end;
      SkipSpaceW(P);
      if AIdx<tlpYear then
        Inc(AIdx)
      else
        Break;
    end;
    if (P^ = '"') or (P^ = '''') then
      FContent := DequotedStrW(P, P^)
    else
      FContent := P;
    CalcStopTime;
  end;
end;

function TQPlanMask.Timeout(ATime: TDateTime): TQPlanTimeoutCheckResult;
var
  ANext: TDateTime;
  ADelta: Double;
const
  DTRes: Double = 1 / 864000000; // 0.1ms
begin
  if Accept(ATime) then
    Result := pcrOk
  else if ATime < FStartTime then
    Result := pcrNotArrived
  else if ATime > FStopTime then
    Result := pcrExpired
  else
  begin
    ANext := FNextTime;
    if Trunc(ANext) <> 0 then
    begin
      ADelta := ATime - ANext;
      if ADelta < -DTRes then
        Result := pcrNotArrived
      else
      begin
        if ADelta > 0 then
          Result := pcrTimeout
        else
          Result := pcrOk;
      end;
    end
    else
      Result := pcrNotArrived;
  end;
  if (Result in [pcrOk, pcrTimeout]) or (Trunc(FNextTime) = 0) then
  begin
    if FNextTime < DTRes then
      FLastTime := ATime
    else
      FLastTime := FNextTime;
    FNextTime := NextTime;
  end;
end;

end.
