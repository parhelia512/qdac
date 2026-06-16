program TestPlanMask;

{$APPTYPE CONSOLE}

uses
  SysUtils, DateUtils,
  qtimetypes;

{=================== 参考实现（原暴力扫描版本） ==================}
function GetNextTimeBruteForce(var Plan: TQPlanMask): TDateTime;
var
  Y, M, D, H, N, S, MS: Word;

  function AcceptItem(const ALimit: TQTimeLimitItem; AValue: Word): Boolean;
  begin
    Result := False;
    if (ALimit.Flags and (PLAN_MASK_ANY or PLAN_MASK_IGNORE)) <> 0 then
      Result := True
    else
    begin
      if (ALimit.Flags and PLAN_MASK_RANGE) <> 0 then
        Result := (AValue >= Word(ALimit.Start)) and (AValue <= Word(ALimit.Stop))
      else if (ALimit.Flags and PLAN_MASK_REPEAT) <> 0 then
        Result := (AValue >= Word(ALimit.Start)) and (AValue <= Word(ALimit.Stop))
      else if (ALimit.Flags and PLAN_MASK_LAST) = 0 then
        Result := AValue = Word(ALimit.Start);
      if Result and ((ALimit.Flags and PLAN_MASK_REPEAT) <> 0) then
        Result := ((AValue - ALimit.Start) mod ALimit.Interval) = 0;
    end;
  end;

  function AcceptArray(const ALimit: PQTimeLimit; AValue: Word): Boolean;
  var
    I: Integer;
  begin
    if Length(ALimit^) = 0 then
      Exit(True);
    for I := 0 to High(ALimit^) do
    begin
      Result := AcceptItem(ALimit^[I], AValue);
      if Result then
        Break;
    end;
  end;

  function AcceptDay(Y, M, D: Word): Boolean;
  var
    I: Integer;
    WD, MD: Word;
    ALimit: PQTimeLimit;
    ADate, AWDPrior, AWDNext: TDateTime;
    AY, AM, AD: Word;
    AIsLeapYear: Boolean;
  begin
    Result := False;
    ALimit := @Plan.Limits^[tlpDayOfMonth];
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
            Result := (D = MonthDays[AIsLeapYear][M] + ALimit^[I].Start)
        end
        else
          Result := AcceptItem(ALimit^[I], D);
        if Result then
          Break;
      end;
    end
    else
      Result := True;
    if not Result then
      Exit;
    ALimit := @Plan.Limits^[tlpDayOfWeek];
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
        begin
          ADate := EncodeDate(Y, M, 1) + 7 * ALimit^[I].Stop;
          ADate := ADate + ALimit^[I].Start - DayOfTheWeek(ADate);
          DecodeDate(ADate, AY, AM, AD);
          Result := (D = AD) and (M = AM) and (Y = AY);
        end
        else if (ALimit^[I].Flags and PLAN_MASK_WORKDAY) <> 0 then
          Result := IsWorkDay(ADate)
        else
          Result := AcceptItem(ALimit^[I], WD);
        if Result then
          Break;
      end;
    end;
  end;

  function CalcDateBF: Boolean;
  var
    AY, AM, AD: Word;
    AMaxYear: Word;
    AIsLeapYear: Boolean;
  begin
    AY := Y; AM := M; AD := D;
    Result := False;
    AMaxYear := YearOf(Plan.StopTime);
    while AY <= AMaxYear do
    begin
      if AcceptArray(@Plan.Limits^[tlpYear], AY) then
      begin
        AIsLeapYear := IsLeapYear(AY);
        while AM <= 12 do
        begin
          if AcceptArray(@Plan.Limits^[tlpMonthOfYear], AM) then
          begin
            while AD <= MonthDays[AIsLeapYear][AM] do
            begin
              if AcceptDay(AY, AM, AD) then
              begin
                if (AD <> D) or (AM <> M) or (AY <> Y) then
                begin H := 0; N := 0; S := 0; end;
                Y := AY; M := AM; D := AD;
                Result := True; Exit;
              end;
              Inc(AD);
            end;
          end;
          Inc(AM); AD := 1;
        end;
      end;
      Inc(AY); AM := 1; AD := 1;
    end;
  end;

  function CalcTimeBF: Boolean;
  var
    NH, NM, NS: Word;
  begin
    Result := False;
    NH := H; NM := N; NS := S;
    while NH < 24 do
    begin
      if AcceptArray(@Plan.Limits^[tlpHour], NH) then
      begin
        while NM < 60 do
        begin
          if AcceptArray(@Plan.Limits^[tlpMinute], NM) then
          begin
            while NS < 60 do
            begin
              if AcceptArray(@Plan.Limits^[tlpSecond], NS) then
              begin
                H := NH; N := NM; S := NS;
                Result := True; Exit;
              end;
              Inc(NS);
            end;
          end;
          Inc(NM); NS := 0;
        end;
      end;
      Inc(NH); NM := 0; NS := 0;
    end;
  end;

begin
  Result := IncSecond(Plan.LastTime);
  if (Result >= Plan.StartTime) and (Result < Plan.StopTime) then
  begin
    DecodeDateTime(Result, Y, M, D, H, N, S, MS);
    repeat
      if CalcDateBF then
      begin
        if CalcTimeBF then
        begin
          Result := EncodeDateTime(Y, M, D, H, N, S, 0);
          Exit;
        end
        else
        begin
          Result := IncDay(EncodeDate(Y, M, D));
          DecodeDate(Result, Y, M, D);
          H := 0; N := 0; S := 0;
        end;
      end
      else
        Break;
    until Result > Plan.StopTime;
    Result := 0;
  end
  else
    Result := 0;
end;

{=================== 测试框架 ==================}
var
  TotalTests, PassedTests: Integer;

const
  TOLERANCE = 1 / 86400; // 1秒

{ 测试单个 mask: 从 ALastTime 开始迭代 NSteps 步，比较优化 vs 暴力 }
procedure TestSteps(const ADesc, AMask: string; ALastTime, AStartTime,
  AStopTime: TDateTime; NSteps: Integer);
var
  Plan, PlanRef: TQPlanMask;
  Next, NextRef: TDateTime;
  I: Integer;
  Ok: Boolean;
  S: string;
  ErrCount: Integer;
begin
  Plan := TQPlanMask.Create(AMask);
  PlanRef := TQPlanMask.Create(AMask);

  Plan.StartTime := AStartTime;
  Plan.StopTime := AStopTime;
  PlanRef.StartTime := AStartTime;
  PlanRef.StopTime := AStopTime;

  Plan.LastTime := ALastTime;
  PlanRef.LastTime := ALastTime;

  ErrCount := 0;
  for I := 1 to NSteps do
  begin
    Inc(TotalTests);
    Next := Plan.NextTime;
    NextRef := GetNextTimeBruteForce(PlanRef);

    if (Next = 0) and (NextRef = 0) then
      Ok := True  // 都无匹配
    else
      Ok := (Abs(Next - NextRef) <= TOLERANCE);

    if Ok then
    begin
      S := '';
      if Next <> 0 then
        S := DateTimeToStr(Next);
      WriteLn(Format('  PASS #%d: %s', [I, S]));
      Inc(PassedTests);
    end else
    begin
      Inc(ErrCount);
      WriteLn(Format('  FAIL #%d: opt=%s bf=%s', [I,
        DateTimeToStr(Next), DateTimeToStr(NextRef)]));
    end;

    if Next = 0 then
      Break;  // 没更多匹配了

    Plan.LastTime := Next;
    PlanRef.LastTime := NextRef;
  end;
  if ErrCount > 0 then
    WriteLn(Format('  >>> %s: %d 个错误', [ADesc, ErrCount]));
end;

{ 简化调用：使用默认的起止时间 }
procedure Test(const ADesc, AMask: string; ALastTime: TDateTime; NSteps: Integer);
begin
  WriteLn(Format('[%s] %s', [ADesc, AMask]));
  TestSteps(ADesc, AMask, ALastTime,
    EncodeDateTime(2000, 1, 1, 0, 0, 0, 0),
    EncodeDateTime(2099, 12, 31, 23, 59, 59, 0),
    NSteps);
end;

procedure TestNoMatch(const ADesc, AMask: string; ALastTime: TDateTime);
begin
  WriteLn(Format('[%s] %s (期望无匹配)', [ADesc, AMask]));
  TestSteps(ADesc, AMask, ALastTime,
    EncodeDateTime(2000, 1, 1, 0, 0, 0, 0),
    EncodeDateTime(2026, 12, 31, 23, 59, 59, 0),
    1);
end;

{=================== 测试用例 ==================}
procedure RunTests;
var
  T: TDateTime;
begin
  WriteLn('=== TQPlanMask 跳跃优化 vs 暴力扫描 ===');
  WriteLn;

  // 1. 任意值
  T := EncodeDateTime(2026, 6, 16, 10, 30, 0, 0);
  Test('任意', '* * * * * *', T, 3);

  // 2. 精确秒
  T := EncodeDateTime(2026, 6, 16, 10, 30, 0, 0);
  Test('秒=30', '30 * * * * *', T, 4);

  // 3. 每15秒 (解析器不支持 */15，用 0-59/15)
  T := EncodeDateTime(2026, 6, 16, 10, 30, 0, 0);
  Test('*/15', '0-59/15 * * * * *', T, 6);

  // 4. 范围+间隔
  T := EncodeDateTime(2026, 6, 16, 10, 30, 5, 0);
  Test('0-30/10', '0-30/10 * * * * *', T, 6);

  // 5. 精确分钟
  T := EncodeDateTime(2026, 6, 16, 10, 15, 0, 0);
  Test('分=30', '0 30 * * * *', T, 4);

  // 6. 精确小时+分钟
  T := EncodeDateTime(2026, 6, 16, 10, 0, 0, 0);
  Test('14:30', '0 30 14 * * *', T, 4);

  // 7. 指定日期+时间
  T := EncodeDateTime(2026, 5, 1, 0, 0, 0, 0);
  Test('6月15日', '0 30 14 15 6 *', T, 4);

  // 8. 工作日 9-17点每小时
  T := EncodeDateTime(2026, 6, 15, 0, 0, 0, 0); // 周一
  Test('工作日9-17', '0 0 9-17 * * 1-5', T, 10);

  // 9. 跨日期跳跃
  T := EncodeDateTime(2026, 6, 16, 10, 0, 0, 0);
  Test('每天6点', '0 0 6 * * *', T, 4);

  // 10. 月份跳跃
  T := EncodeDateTime(2026, 3, 1, 0, 0, 0, 0);
  Test('1/6月1日', '0 0 0 1 1,6 *', T, 4);

  // 11. 仅年 (DayOfWeek=0不在1-7范围，改用*或7)
  T := EncodeDateTime(2025, 1, 1, 0, 0, 0, 0);
  Test('2026/2028', '0 0 0 1 1 * 2026,2028', T, 4);

  // 12. 每5分钟 (解析器不支持 */5，用 0-59/5)
  T := EncodeDateTime(2026, 6, 16, 10, 7, 0, 0);
  Test('*/5分钟', '0 0-59/5 * * * *', T, 6);

  // 13. 精确值列表
  T := EncodeDateTime(2026, 6, 16, 0, 0, 0, 0);
  Test('8/12/16点', '0 0 8,12,16 * * *', T, 6);

  // 14. 无匹配
  T := EncodeDateTime(2026, 6, 16, 0, 0, 0, 0);
  TestNoMatch('2月30不存在', '0 0 0 30 2 *', T);

  // 15. 跨年
  T := EncodeDateTime(2026, 12, 31, 10, 0, 0, 0);
  Test('元旦', '0 0 0 1 1 *', T, 4);

  // 16. 每2小时 (解析器不支持 */2，用 0-23/2)
  T := EncodeDateTime(2026, 6, 16, 0, 0, 0, 0);
  Test('*/2小时', '0 0 0-23/2 * * *', T, 6);

  // 17. 仅最后一天
  T := EncodeDateTime(2026, 1, 15, 0, 0, 0, 0);
  Test('月末', '0 0 0 L * *', T, 4);

  // 18. 复杂组合: 每季度最后一天 12:00
  T := EncodeDateTime(2026, 1, 1, 0, 0, 0, 0);
  Test('季度末', '0 0 12 L 3,6,9,12 *', T, 6);

  // 19. 工作日
  T := EncodeDateTime(2026, 6, 13, 0, 0, 0, 0); // 周六
  Test('下一工作日', '0 0 0 * * 1-5', T, 6);

  // 20. 秒+分+时多层跳跃
  T := EncodeDateTime(2026, 6, 16, 8, 15, 23, 0);
  Test('多层跳跃', '0,30 10,20,30 8,10,12 * * *', T, 10);
end;

begin
  TotalTests := 0;
  PassedTests := 0;
  RunTests;
  WriteLn;
  WriteLn(Format('总计: %d 测试, %d 通过, %d 失败',
    [TotalTests, PassedTests, TotalTests - PassedTests]));
  if PassedTests = TotalTests then
    WriteLn('全部通过!')
  else
    WriteLn('有失败!');
  ReadLn;
end.
