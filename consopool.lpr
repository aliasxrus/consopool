PROGRAM consopool;

{$mode objfpc}{$H+}

USES
  {$IFDEF UNIX}
   cthreads,
  {$ENDIF}
  Classes, SysUtils, CRT, consopooldata, coreunit, NosoDig.Crypto, strutils
  { you can add units after this };

Type
  ConsoLineInfo = packed record
   texto : string;
   colour : integer;
   end;

var
// GUI RELATED
  AutoConsole   : boolean = true;
  ConsoleActive : boolean = true;
  ConsoleLines  : array of string;
  LAstShowed    : integer = 0;
  MNsTextDown   : string;

// Prints the specified line of the screen
Procedure PrintLine(number:integer;IfText:String='');
var
  BlockAge : int64 = 0;
Begin
TextBackground(Black);
GotoXY(1,number);ClrEOL;
if number = 1 then
   begin
   Textcolor(Blue);TextBackground(White);
   Write(Format(' Noso PoPW pool - Nosohash %s [FPC=%s] Donate: %d%% ',[AppVersion,fpcVersion,PoolDonate]));
   end;
IF ((number > 1) and (not OnMainScreen)) then exit;
if number = 2 then
   begin
   Textcolor(white);TextBackground(Green);Write(Format(' %d ',[PoolPort]));
   TextBackground(Black);Write('  ');
   Textcolor(white);TextBackground(Green);Write(Format(' %s%% ',[FormatFloat('0.00',PoolFee/100)]));
   TextBackground(Black);Write('  ');
   Textcolor(white);TextBackground(Green);Write(Format(' %d ',[PoolPay]));
   TextBackground(Black);Write('  ');
   if AutoDiff then TextBackground(Green) else TextBackground(Red);
   Textcolor(white);Write(Format(' %s [%d] ',[MinDiffBase, AutoValue]));
   end;
if number = 3 then
   begin
   Textcolor(White);TextBackground(Blue);
   Write(Format(' %s [ %s Noso ]',[PoolAddress,Int2Curr(GetPoolBalance)]));
   end;
if number = 4 then
   begin
   if IfText='1' then
      begin
      Textcolor(Red);TextBackground(black);
      Write(Format(' %s ',['Syncing']));
      end;
   if IfText<>'1' then
      begin
      Textcolor(white);TextBackground(green);
      Write(Format(' %d [%d/%d] ',[MainConsensus.block,ContactedNodes,LengthNodes]));
      TextBackground(Black);Write('  ');
      Textcolor(white);TextBackground(green);
      Write(Format(' %s ',[Copy(MainConsensus.lbhash,1,10)]));
      TextBackground(Black);Write('  ');
      Textcolor(white);TextBackground(green);
      BlockAge := UTCTime-MainConsensus.LBTimeEnd;
      Write(Format(' %d ',[BlockAge]));
      if ( (BlockAge > 60) and (LastPaidBlock<MainConsensus.block) ) then
         begin
         RunPayments();
         LastPaidBlock:=MainConsensus.block;
         end;
      PrintLine(7);
      end;
   RefreshAge := UTCTime;
   end;
if number = 5 then
   begin
   if PoolServer.Active then
      begin
      TextColor(yellow);TextBackground(Green);Write(Format(' %s ',['( (LISTENING) )']))
      end
   else
      begin
      TextColor(White);TextBackground(Red);Write(Format(' %s ',['OFF']))
      end;
   TextBackground(Black);Write('  ');
   Textcolor(white);TextBackground(green);Write(BlockPrefixesRequested.ToString);
   TextBackground(Black);Write('  ');
   Textcolor(white);TextBackground(green);Write(MinersCount.ToString);
   TextBackground(Black);Write('  ');
   Textcolor(white);TextBackground(green);Write(SharesCount.ToString);
   TextBackground(Black);Write('  ');
   Textcolor(white);TextBackground(green);Write(BestHashReadeable(ThisBlockBest));
   UpdateServerInfo := false;
   TextBackground(Black);Write('  ');
   Textcolor(white);TextBackground(green);Write(BestHashReadeable(MainBestDiff));
   PrintLine(7);
   end;
if number = 6 then
   begin
   Textcolor(white);TextBackground(Black);
   write(Format(' %s  %d  %d[%d]  %s  [%s]  [%d]',[UpTime,SESSION_BestHashes, SESSION_Shares, RejectedShares, HashrateToShow(GetSessionSpeed),HashrateToShow(MainNetHashRate),BlocksMinedByPool]));
   PrintLine(7);
   RefreshUpTime := UTCTime;
   end;
if number = 7 then
   begin
   Textcolor(white);TextBackground(Black);
   Write('> '+Command);
   end;
if number = 8 then
   begin
   Textcolor(black);TextBackground(white);
   Write(Format(' %s ',[IfText]));
   LastHelpShown := IfText;
   end;
End;

Procedure ClearPanel();
Begin
if consoleActive then
   begin
   Textcolor(white);
   TextBackground(black);
   window(2,10,79,23);
   ClrScr;
   window(1,1,80,25);
   SetLength(ConsoleLines,0);
   Autoconsole := true;
   end;
End;

Function ParseConsoleLine(Texto:String):ConsoLineInfo;
Begin
if texto[1] = ',' then result.colour:=green
else if texto[1] = '.' then result.colour:=red
else if texto[1] = '/' then result.colour:=yellow
else result.colour:=white;
result.texto:=Copy(texto,2,length(Texto));
End;

Procedure ScrollAutoConsole(Texto:string);
Begin
TextBackground(Black);
TextColor(ParseConsoleLine(Texto).colour);
window(2,10,79,23);
GotoXy(78,14);WriteLn();
Write(ParseConsoleLine(Texto).texto);
Window(1,1,80,25);
End;

Procedure InsertOnConsole(Texto:String);
Begin
TextBackground(Black);
TextColor(ParseConsoleLine(Texto).colour);
window(2,10,79,23);
GotoXy(1,1);InsLine();
GotoXy(1,1);
WriteLn(ParseConsoleLine(Texto).texto);
Window(1,1,80,25);
End;

Procedure ScrollDownConsole();
Begin
if AutoConsole then exit;
Inc(LAstShowed);
ScrollAutoConsole(ConsoleLines[LastShowed]);
if LAstShowed = Length(ConsoleLines)-1 then AutoConsole := true;
End;

Procedure ScrollUpConsole();
Begin
if AutoConsole then LastShowed := Length(ConsoleLines)-1;
if LastShowed-14>= 0 then
   begin
   AutoConsole := False;
   InsertOnCOnsole(ConsoleLines[LastShowed-14]);
   Dec(LastShowed);
   end;
End;

Procedure RawToConsole(Texto:String);
Begin
Insert(Texto,ConsoleLines,Length(ConsoleLines));
if ( (AutoConsole) and (ConsoleActive) ) then
   begin
   ScrollAutoConsole(Texto);
   end;
End;

Procedure PageUpConsole();
var
  counter : integer;
Begin
for counter := 1 to 14 do
   ScrollUpConsole;
End;

Procedure PageDownConsole();
var
  counter : integer;
Begin
for counter := 1 to 14 do
   ScrollDownConsole;
End;

Procedure GoToEndConsole();
Begin
repeat
  ScrollDownConsole
until autoconsole;
End;

Procedure ShowHelp(commandtoshow:string);
Begin
if length(commandtoshow)>20 then setlength(commandtoshow,20);
RawToConsole(',Help');
if commandtoshow = '' then
   begin
   RawToConsole('/Available commands (case unsensitive): ');
   RawToConsole('/{Mandatory} [Optional] <Key shortcut>');
   RawToConsole('/Use Help {command} for more details');
   RawToConsole(' help <F1>               -> Shows this info');
   RawToConsole(' nodes <F2>              -> Shows the seed nodes');
   RawToConsole(' run                     -> Starts the pool');
   RawToConsole(' report {type} [options] -> Generates a report');
   RawToConsole(' cls                     -> Clears the console');
   RawToConsole(' exit <ALT+X>            -> Close the app');
   RawToConsole(' restart <ALT+R>         -> Restarts the app');
   end
else if commandtoshow = 'REPORT' then
   begin
   RawToConsole(',Report command');
   RawToConsole('/Available options');
   RawToConsole(' -n:number -> Shows up to number entries');
   RawToConsole(' -r        -> Resets the report');
   RawToConsole('/Available report');
   RawToConsole(' miners     -> Miner app used for SOURCE request');
   RawToConsole(' ips        -> User IPv4 on SOURCE request');
   RawToConsole(' shareip    -> User IPv4 off valid shares');
   RawToConsole(' wrongminer -> Miner app of wrong shares');
   RawToConsole(' wrongip    -> User IPv4 of wrong shares');
   end
else RawToConsole('.Unknown command: '+commandtoshow);
End;

Procedure ShowNodes();
Var
  Counter : integer;
  ThisNode : TNodeData;
Begin
RawToConsole(',Nodes List: '+LengthNodes.ToString);
RawToConsole(Format('  %-18s %s %6s %s',['Host', 'Port', 'Blow', '  PoW  ']));

For counter := 0 to LengthNodes-1 do
   begin
   ThisNode := GetNodeIndex(Counter);
   RawToConsole(Format('  %-18s %s %6s %d',[ThisNode.host, ThisNode.port.ToString, ThisNode.block.ToString, ThisNode.LBPoW]));
   end;

End;

Procedure LockAddress(LAddress:string);
Begin
if AnsiContainsStr(LockedAddressesString,LAddress) then
   rawtoconsole(' Address already locked')
else
   begin
   rawtoconsole('.Address locked: '+Laddress);
   LockedAddressesString := LockedAddressesString+LAddress;
   SaveConfig();
   end;
End;

Procedure UnlockAddress(LAddress:string);
Begin
if AnsiContainsStr(LockedAddressesString,LAddress) then
   begin
   LockedAddressesString := StringReplace(LockedAddressesString,LAddress,'',[rfReplaceAll, rfIgnoreCase]);
   rawtoconsole(',Address unlocked: '+LAddress);
   SaveConfig();
   end
else rawtoconsole(' Address is not locked');
End;

Procedure ClearAddress(LAddress:String);
Begin
if AnsiContainsStr(LockedAddressesString,LAddress) then
   begin
   ClearAddressBalance(LAddress,'Cleared');
   rawtoconsole('.Address cleared: '+Laddress);
   end
else rawtoconsole(' Address is not locked. You need lock first an address before clear it.');
End;

Procedure ShowBlockShares();
Var
  Counter : integer;
  ThisMiner : TMinersData;
Begin
RawToConsole(',Block shares: ');
EnterCriticalSection(CS_Miners);
For counter := 0 to Length(ArrMiners)-1 do
   begin
   ThisMiner := ArrMiners[Counter];
   RawToConsole(Format(' %0:-40s %12s %5s %d',[ThisMiner.address,Int2Curr(ThisMiner.Balance),
                         ThisMiner.Shares.ToString,ThisMiner.LastPay+poolpay-MainConsensus.block]));
   end;
LeaveCriticalSection(CS_Miners);
End;

Procedure PrintUpdateScreen();
Begin
PrintLine(1);
PrintLine(2);
PrintLine(3);
PrintLine(4);
PrintLine(5);
PrintLine(8,LastHelpShown);
PrintLine(7);
End;

Procedure DrawPanelBorders();
var
  counter : integer;
Begin
Textcolor(white);
TextBackground(black);
for counter := 10 to 23 do
   begin
   gotoxy(1,counter);write('|');
   gotoxy(80,counter);write('|');
   end;
for counter := 1 to 80 do
   begin
   gotoxy(counter,9);write('-');
   gotoxy(counter,24);write('-');
   end;
TextBackground(cyan);
Textcolor(black);
Gotoxy(1,25);write(' [F8] Change Mode {Comming soon...} ');
End;

Procedure CheckLogs();
var
  Texto : String;
Begin
if length(LogLines)>0 then
   begin
   Repeat
      begin
      EnterCriticalSection(CS_LogLines);
      Texto := LogLines[0];
      Delete(LogLines,0,1);
      LeaveCriticalSection(CS_LogLines);
      RawToConsole(Texto);
      end;
   until length(LogLines) = 0;
   end;
End;

Procedure CloseTheApp(mensaje:string);
Begin
TextColor(white);
gotoxy(80,25);WriteLn();
if mensaje<>'' then
   begin
   writeln(mensaje);
   writeln('Press enter to close');
   Readln;
   end;
writeLn('ConsoPool Properly CLosed');
saveminers;
SaveConfig();
Poolserver.Active:=false;
PoolServer.Free;
DoneCriticalSection(CS_UpdateScreen);
DoneCriticalSection(CS_PrefixIndex);
DoneCriticalSection(CS_LogLines);
DoneCriticalSection(CS_Miners);
DoneCriticalSection(CS_Shares);
DoneCriticalSection(CS_BlockBest);
DoneCriticalSection(CS_Solution);
DoneCriticalSection(CS_PaysFile);
DoneCriticalSection(CS_PayThreads);
DoneCriticalSection(CS_PoolBalance);
DoneCriticalSection(CS_LastBlockRate);
DoneCriticalSection(CS_USerMiner);
DoneCriticalSection(CS_UserIPArr);
DoneCriticalSection(CS_ShareIPArr);
DoneCriticalSection(CS_WrongShareMiner);
DoneCriticalSection(CS_WrongShareIp);
DoneCriticalSection(CS_ArraySumary);

End;

BEGIN
InitCriticalSection(CS_UpdateScreen);
InitCriticalSection(CS_PrefixIndex);
InitCriticalSection(CS_LogLines);
InitCriticalSection(CS_Miners);
InitCriticalSection(CS_Shares);
InitCriticalSection(CS_BlockBest);
InitCriticalSection(CS_Solution);
InitCriticalSection(CS_PaysFile);
InitCriticalSection(CS_PayThreads);
InitCriticalSection(CS_PoolBalance);
InitCriticalSection(CS_LastBlockRate);
InitCriticalSection(CS_USerMiner);
InitCriticalSection(CS_UserIPArr);
InitCriticalSection(CS_ShareIPArr);
InitCriticalSection(CS_WrongShareMiner);
InitCriticalSection(CS_WrongShareIp);
InitCriticalSection(CS_ArraySumary);

SetLength(LogLines,0);
SetLength(NewLogLines,0);
SetLength(ArrMiners,0);
SetLength(ArrShares,0);
SetLength(ConsoleLines,0);
SetLength(UserMiner,0);
SetLength(UserIpArr,0);
SetLength(WrongShareMiner,0);
SetLength(WrongShareIp,0);
SetLength(ARRAY_Sumary,0);


ClrScr;
if not directoryexists('logs') then createdir('logs');
if not directoryexists('miners') then createdir('miners');
if not directoryexists('blocks') then createdir('blocks');
if not directoryexists('addresses') then createdir('addresses');
AssignFile(MinersFile,'miners'+DirectorySeparator+'miners.dat');
Assignfile(configfile, 'consopool.cfg');
Assignfile(logfile, 'logs'+DirectorySeparator+'log.txt');
Assignfile(OldLogFile, 'logs'+DirectorySeparator+'oldlogs.txt');
if not FileExists('blocks'+DirectorySeparator+'0.txt') then CreateBlockzero();
if not fileExists('payments.txt') then createPaymentsFile;
if not fileExists('nodes.txt') then createNodesFile;
if not fileExists('frequency.dat') then SaveShareIndex;
if StoreShares then LoadShareIndex;
Assignfile(PaysFile,'payments.txt');
if not FileExists('miners'+DirectorySeparator+'miners.dat') then CreateMinersFile();
LoadMiners();
If not ResetLogs then
   begin
   writeln('Error reseting log files');
   Exit;
   end;
if not FileExists('consopool.cfg') then SaveConfig();
LoadConfig();
LoadNodes(GetNodesFileData());
InitServer;

if PoolAddress='' then CloseTheApp('Pool address is empty');
if PublicKey  ='' then CloseTheApp('Public key is empty');
if PrivateKey  ='' then CloseTheApp('Private key is empty');
if not IsValidHashAddress(PoolAddress) then CloseTheApp('Pool address is not valid');
if GetAddressFromPublicKey(PublicKey) <> PoolAddress then CloseTheApp('Address and public key do not match');
if not KeysMatch(PublicKey,PrivateKey) then CloseTheApp('Keys do not match');

MainnetTimeStamp := GetMainnetTimestamp;
if MainnetTimeStamp<>0 then OffSet := UTCTime-MainnetTimeStamp;
MainConsensus := Default(TNodeData);
LastHelpShown := DefHelpLine;
UpdatePoolBalance;
FillSolsArray();
ToLog(' ********** New Session **********');
if PoolAuto then PrintLine(8,StartPool);
DrawPanelBorders;
REPEAT
   REPEAT
      If ((GetSolution.Diff<MainBestDiff) and (GetSolution.Hash<>'')) then SendSolution(GetSolution);
      if UpdateScreen then PrintUpdateScreen();
      CheckLogs();
      if ( ((LastConsensusTry+4<UTCTime) and (UTCTime-MainConsensus.LBTimeEnd>604) or (LastConsensusTry=0)) and
         (not WaitingConsensus) )then
         Begin
         PrintLine(4,'1');
         WaitingConsensus := true;
         CurrentBlock := GetMainConsensus.block;
         GetConsensus;
         ToLog(Format(' Consensus time : %d ms',[Consensustime]));
         if GetMainConsensus.block>CurrentBlock then
            begin
            CurrentBlock := GetMainConsensus.block;
            ResetBlock();
            UpdateServerInfo := true;
            end;
         WaitingConsensus := False;
         LastConsensusTry := UTCTime;
         PrintLine(4);
         End;
      if RefreshUpTime <> UTCtime then
         begin
         PrintLine(6);
         printline(5);
         end;
      if RefreshPoolHeader then
         begin
         RefreshPoolHeader := false;
         PrintLine(2);
         end;
      if RefreshPoolBalance then
         begin
         RefreshPoolBalance := false;
         PrintLine(3);
         end;
      if ( (MainConsensus.LBTimeEnd >= 300) and (MainConsensus.LBTimeEnd < 585)and (not ThisBlockMNs) ) then
         begin
         MNsTextDown := GetMNsFromNode;
         if Copy(HashMD5String(MNsTextDown+#13#10),0,5) = GetMainConsensus.MNsHash then
            begin
            if SaveMnsToDisk(MNsTextDown) then
               begin
               LoadNodes(GetNodesFileData());
               ToLog(Format(' Nodes updated: %d Verificators',[length(NodesArray)]));
               ThisBlockMNs := true;
               end;
            end
         else
            begin
            ToLog(Format(' Wrong MNs Hash: %s <> %s',[Copy(HashMD5String(MNsTextDown),0,5),GetMainConsensus.MNsHash]));
            ThisBlockMNs := true;
            end;
         end;
      if RefreshAge<> UTCTime then
         begin
         PrintLine(4);
         if ( (CheckPaysThreads) and (GetPayThreads= 0) ) then
            begin
            CheckPaysThreads := false;
            SaveMiners();
            ToLog(Format(' Completed payments (%d Good - %d Fail)',[GoodPayments,BadPayments]));
            GenerateReport(uToFile);
            UpdatePoolBalance;
            end;
         end;
      if UpdateServerInfo then PrintLine(5);
      Sleep(1);
   UNTIL Keypressed;
   ThisChar := Readkey;
   if ThisChar = #0 then
      begin
      ThisChar:=Readkey;
      if ThisChar=#59 then // F1
         begin
         Command := 'help';
         ThisChar := #13;
         end
      else if ThisChar=#60 then // F2
         begin
         Command := 'nodes';
         ThisChar := #13;
         end
      else if ThisChar=#61 then // F3
         begin
         if LastCommand <> '' then Command := LastCommand;
         PrintLine(7);
         ThisChar := #0;
         end
      else if ThisChar=#45 then // alt+x
         begin
         Command := 'exit';
         ThisChar := #13;
         end
      else if ThisChar=#19 then // alt+r
         begin
         Command := 'restart';
         ThisChar := #13;
         end
      else if ThisChar=#72 then //up arrow
         begin
         If ConsoleActive then ScrollUpConsole;
         ThisChar := #0;
         end
      else if ThisChar=#80 then //up arrow
         begin
         If ConsoleActive then ScrollDownConsole;
         ThisChar := #0;
         end
      else if ThisChar=#73 then //page up
         begin
         If ConsoleActive then PageUpConsole;
         ThisChar := #0;
         end
      else if ThisChar=#81 then //page down
         begin
         If ConsoleActive then PageDownConsole;
         ThisChar := #0;
         end
      else if ThisChar=#79 then //END key
         begin
         If ConsoleActive then GoToEndConsole;
         ThisChar := #0;
         end
      else
         begin
         // For debugging purposes only
         //command := command+Ord(ThisChar).ToString;
         ThisChar := #0;
         end;
      end;
   if ( (length(command)>= 77) and (Ord(ThisChar) <> 8) ) then
      begin
      beep;
      ThisChar := #0;
      end;
   if ((Ord(ThisChar)>=32) and (Ord(ThisChar)<=126)) then
      begin
      Command := Command+ThisChar;
      PrintLine(7);
      end
   else if Ord(ThisChar) = 8 then
      begin
      SetLength(Command,Length(Command)-1);
      PrintLine(7);
      end
   else if Ord(ThisChar) = 13 then
      begin
      if Uppercase(Parameter(Command,0)) = 'EXIT' then FinishProgram := true
      else if Uppercase(Parameter(Command,0)) = 'HELP' then ShowHelp(Uppercase(Parameter(Command,1)))
      else if Uppercase(Parameter(Command,0)) = 'NODES' then ShowNodes
      else if Uppercase(Parameter(Command,0)) = 'RUN' then PrintLine(8,StartPool)
      else if Uppercase(Parameter(Command,0)) = 'STOP' then PrintLine(8,StopPool)
      else if Uppercase(Parameter(Command,0)) = 'SHARES' then ShowBlockShares
      else if Uppercase(Parameter(Command,0)) = 'LOCK' then LockAddress(Parameter(Command,1))
      else if Uppercase(Parameter(Command,0)) = 'UNLOCK' then UnlockAddress(Parameter(Command,1))
      else if Uppercase(Parameter(Command,0)) = 'CLEARADDRESS' then ClearAddress(Parameter(Command,1))
      else if Uppercase(Parameter(Command,0)) = 'STATUS' then
         begin
         RawToConsole(',Status');
         RawToConsole(' Best miner   : '+GetBlockBestAddress);
         RawToConsole(' Best hash    : '+GetBlockBest);
         RawToConsole(' Mainnet best : '+MainBestDiff);
         end
      else if Uppercase(Parameter(Command,0)) = 'RESTART' then
         begin
         FileToRestart := Parameter(Command,1);
         RestartAfterQuit := true;
         FinishProgram := true;
         end
      else if Uppercase(Parameter(Command,0)) = 'SHAREINDEX' then ShareIndexReport
      else if Uppercase(Parameter(Command,0)) = 'NETRATE' then FillSolsArray
      else if Uppercase(Parameter(Command,0)) = 'SAVE' then
         begin
         SaveMiners;
         ToLog(',Miners File saved',uToConsole);
         end
      else if Uppercase(Parameter(Command,0)) = 'DEBT' then ToLog(' Total debt: '+Int2Curr(GetTotalDebt))
      else if Uppercase(Parameter(Command,0)) = 'MAINREPORT' then GenerateReport(uToConsole)
      else if Uppercase(Parameter(Command,0)) = 'REPORT' then CounterReport(command,uToConsole)
      else if Uppercase(Parameter(Command,0)) = 'CLS' then ClearPanel
      else if Uppercase(Parameter(Command,0)) = 'TEST' then RunTest
      else if Uppercase(Parameter(Command,0)) = 'BALANCE' then
         begin
         ToLog(Format(',Pool Address: %s',[Int2Curr(GetAddressBalance(PoolAddress))]));
         end
      else if Uppercase(Parameter(Command,0)) = 'SYNC' then
         begin
         PrintLine(4,'1');
         WaitingConsensus := true;
         GetConsensus;
         ToLog(Format(' Consensus time : %d ms',[Consensustime]));
         WaitingConsensus := False;
         LastConsensusTry := UTCTime;
         PrintLine(4);
         end
      else if Command <> '' then
         begin
         PrintLine(8,' Error.'+DefHelpLine);
         rawToCOnsole('.Unknown command: '+Command);
         end;
      if command <> '' then LastCommand := Command;
      Command :='';
      PrintLine(7);
      end
   else if Ord(ThisChar) = 27 then FinishProgram := false;
   sleep(1);
UNTIL FinishProgram;
CloseTheApp('');
if RestartAfterQuit then
   begin
   if FileToRestart='' then
      begin
      {$IFDEF UNIX}
      FileToRestart:='consopool';
      {$ENDIF}
      {$IFDEF WINDOWS}
      FileToRestart:='consopool.exe';
      {$ENDIF}
      end;
   RunExternalProgram(FileToRestart);
   end;
Sleep(1000);
END.

