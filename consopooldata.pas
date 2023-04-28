UNIT consopooldata;

{$mode objfpc}{$H+}

INTERFACE

USES
  Classes, SysUtils, coreunit, IdTCPServer, IdContext, IdGlobal, StrUtils,
  IdTCPClient, math, fileutil, nosodig.crypto, Zipper, fphttpclient, opensslsockets,
  IdSSLOpenSSL, IdHTTP, nosotime;

Type

  TLimitStr = String[50];

  TBlockRec = packed record
    blocknumber : integer;
    Mined       : boolean;
    PoWIncome   : int64;
    Paid        : boolean;
    TotalPaid   : int64;
    Bounty      : int64;
    end;

  TSourceData = packed record
    address  : string[40];
    IP       : string[15];
    classA   : integer;
    Classb   : integer;
    ClassC   : integer;
    ClassD   : integer;
    Password : string[32];
    LastBlock: integer;
    end;

  SumaryData = Packed Record
    Hash    : String[40];
    Custom  : String[40];
    Balance : int64;
    Score   : int64;
    LastOP  : int64;
    end;

   TMinersIPs = Packed Record
     Address : TLimitStr;
     ArrIPs  : array of TLimitStr;
     end;

  ThreadPayment = class(TThread)
   private
     Address: string;
   protected
     procedure Execute; override;
   public
     constructor Create(const CreatePaused: Boolean; TAddress:string);
   end;

  ThreadVPNs = class(TThread)
   protected
     procedure Execute; override;
   public
     constructor Create(const CreatePaused: Boolean);
   end;

  PoolServerEvents = class
    class procedure OnExecute(AContext: TIdContext);
    class procedure OnConnect(AContext: TIdContext);
  end;

  TSolution   = Packed Record
    Hash    : string;
    address : string;
    Diff    : string;
    end;

   TMinersData = Packed Record
    address      : string[40];
    Balance      : int64;
    LastPay      : integer;
    Shares       : integer;
    LastPayOrder : String[120];
    end;

   TMinersDataNew = Packed Record
    address      : string[40];
    Balance      : int64;
    LastPay      : integer;
    Shares       : integer;
    LastPayOrder : String[120];
    Password     : string[16];
    BlockRegister: integer;
    LastActive   : integer;
    end;

   TCounter = Packed record
    data         : string[60];
    counter      : integer;
    inblock      : integer;
    end;

   TVPNIPs  = Packed record
    IP           : String[15];
    Block        : integer;
    end;

   TPendingPay = packed record
    address      : string[40];
    Balance      : int64;
    end;

   TSourcesArray = Array[0..255] of integer;


Procedure AddPaymentToFile(Block,destino,monto,OrderID:String);
function SendOrder(OrderString:String):String;

{Miners data file}
Procedure MigrateMinersFile();
Procedure CreateMinersFile();
Procedure SaveMiners();
Procedure LoadMiners();

Procedure CreateBlockzero();
Procedure createPaymentsFile();
Procedure CreateVPNfile();
Procedure LoadVPNFile();
Procedure SaveVPNFile(ThisArray: array of TVPNIPs);
Procedure ProcessPEndingCredits();
Procedure createNodesFile();
Procedure Createcclassesfile;
Function GetNodesFileData():String;
function SaveMnsToDisk(lineText:string): boolean;
function GetMyLastUpdatedBlock():int64;
Function MinersCount():integer;
Function GetMinerBalance(address:string):int64;
Function GetMinerData(address:string):string;
Procedure ClearAddressBalance(Address, LastPayInfo:string);
Function GetTotalDebt():Int64;

Procedure AddShare(Share:string);
Function SharesCount():Integer;
Function ShareAlreadyExists(Share:string):boolean;
Procedure CreditShare(Address,IPUser:String);
function GetPoolPotBalance(ClearBalance : boolean = false):int64;
Procedure AddPoolPotBalance(Balance:int64);
Procedure SetPoolPotBalance(Balance:int64);
Function ShareIsValid(Share,Address,MinerProgram,IPUser,CreditAddress, RAWIP:STring):integer;

Procedure SetSolution(Data:TSolution);
Function GetSolution():TSolution;

Function ResetLogs():boolean;
Procedure RawToLogFile(Linea:String);
function SaveConfig():boolean;
Procedure LoadConfig();
Function UpdateScreen():Boolean;
Procedure SetUpdateScreen();
Procedure InitServer();
function CheckIPMiners(UserIP:String):Boolean;
Function GetIpFiltered(LIP:String):String;
Function TryMessageToMiner(AContext: TIdContext;message:string):boolean;
Procedure TryClosePoolConnection(AContext: TIdContext; closemsg:string='');
Function StartPool():String;
Function UpTime():string;
Function StopPool():String;
Procedure ToLog(Texto:string;ShowOnScreen:integer = 0);
Function GetBlockBest():String;
Function GetBlockBestAddress():String;
Procedure SetBlockBest(ThisValue:String; Laddress: string);
Procedure CreditDonationToDeveloper(Amount:int64);
Procedure LoadCClasses;
Procedure CreditFundsToProject(Amount:int64);
Function DistributeBlockPayment():string;
Procedure RunPayments();
Procedure RunVerification();
Procedure GenerateReport(destination:integer);
Procedure CounterReport(linea:String;Destination:integer);
Procedure BuildNewBlock();
Procedure ResetBlock();
Procedure RunVPNsThread;
Function GetPrefixIndex():Integer;
Procedure ResetPrefixIndex();
function GetPrefixStr(IndexValue:integer = -1):string;
Procedure SendSolution(Data:TSolution);

// Payment threads
Procedure SetPayThreads(Tvalue:integer;AddressList:string; ResetTotalPaid:Boolean = true);
Function GetPayThreads():integer;
Procedure IncreasePayThread(Address:String;Amount:int64);
Procedure DecreasePayThreads(WasGood:boolean;Amount:int64;Address:String='');
// Pool Balance
Procedure SetPoolBalance(ThisValue:int64);
Function GetPoolBalance():Int64;
Procedure IncreasePoolPot(amount:string);
// LastBlockRate
Procedure SetLastBlockRate(ThisValue:int64);
Function GetLastBlockRate():Int64;
// ShareIndex
Procedure SaveShareIndex();
Procedure LoadShareIndex();
Procedure CreditFrequency(Diff : string);
Procedure ShareIndexReport();
// Sumary
function GetAddressBalanceFromSumary(address:string):int64;
// Mainnet hashrate
Function GetBlockValue(Block:integer;valuename:string):string;
Procedure FillSolsArray();
Procedure CalculateMainNetHashrate();
Procedure GetBlocksMinedByPool();
// Debug Counters
Procedure AddUserMiner(Minerv:String);
Procedure ClearUserMinerArray(ClearAll:boolean = true);
Function IPsCOunt():Integer;
Function EnoughSharesByIp(LIP:String):Boolean;
Function EnoughSharesByAddress(UserAddress:String):Boolean;
Procedure AddUserAddress(userAddress:string);
Procedure ClearUserAddressArray(ClearAll:boolean = true);
Procedure AddShareIP(userip:string);
Procedure ClearShareIPArray(ClearAll:boolean = true);
Procedure AddWrongShareMiner(userip:string);
Procedure ClearWrongShareMiner(ClearAll:boolean = true);
Procedure AddWrongShareIp(ThisData:string);
Procedure ClearWrongShareIp(ClearAll:boolean = true);
// Array MinersIPs
Procedure ClearAMI();
Procedure AddToAMI(Address,IP : string);
Function GetAMIString():String;
Function GetIPData(LData:String):String;
Procedure SaveAMIToFile(Block:Integer);
Function GetAMIBlockData(Block:Integer):String;
// Tor filtering
Function GetTorNodesFile():boolean;
Function GetTorExitNodesFile():boolean;
Procedure LoadTorNodes();
Function IsTorIP(IP:String):boolean;
Procedure AddTorAllowed(IP:String);
Procedure ResetTorAllowed();
Function IPTorAllowed(IP:String):boolean;
Procedure AddTorBlocked(IP:String);
Procedure ResetTorBlocked();
Function IPTorBlocked(IP:String):boolean;
// VPN filter
Function GetVPNBanList():String;
Function GetDupliaddresses():String;
Procedure LoadDupAds();
Procedure ProcessNewVPNs(VPNsList:String);
Function IncludeVPN(LocIP:String;block:integer):boolean;
Function VPNIPExists(LocIP:String):boolean;
Procedure RunVPNClean(block:integer);
Procedure ExportVPNs();
// Active pays
Procedure ClearActivePays();
Procedure DecActivePays();
Procedure IncActivePays();
function ActivePaysCount():integer;
// Array Sources
Procedure ResetArraySources();
Procedure AddNewRecord(Address, password,IP:String;Block:Integer);
Procedure OutputSourcesToFile(wasmined:boolean);
Procedure SaveSourcesToDisk();
Procedure LoadSourcesFromDisk();
// Array blocks
Procedure LoadArrBlocksFromDisk();
Procedure SaveArrBlocksToFile();
Procedure UpdateArrayBlocks(ThisRec:TBlockRec);
Function GetArrayBlocksLast:TBlockRec;
Procedure OutputLastDayBlocks();


CONST
  fpcVersion = {$I %FPCVERSION%};
  AppVersion = 'v0.92';
  DefHelpLine= 'Type help for available commands';
  DefWorst = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF';
  ZipSumaryFilename = 'sumary.zip';
  SumaryFilename    = 'data'+directoryseparator+'sumary.psk';
  DeveloperAddress  = 'N3weyyb4HYw4KF3tXWkLbSbMcXzAZFH';
  ProjectAddress    = 'NPrjectPrtcRandmJacptE5';
  NTPServers        = 'ts2.aco.net:hora.roa.es:time.esa.int:time.stdtime.gov.tw:stratum-1.sjc02.svwh.net:ntp1.sp.se:1.de.pool.ntp.org:';
  VPNsBlocksLife    = 24;
  oneNoso           = 100000000;
  PoolPot           = 'POOLPOT';

  // Predefined Types for OutPut
  uToBoth      = 0;
  uToFile      = 1;
  uToConsole   = 2;



VAR
  // Array of sources to new PoPW format
  ArraySources : array of TSourceData;
  ClassAcount  : array[0..255] of integer;
  ClassBCount  : array[0..255] of TSourcesArray;

  // Array of block recrods
  ArrBlocks    : array of TBlockRec;

  // Like a CONST
  StoreShares : boolean = False;
  // Counters
  UserMiner       : array of TCounter;
  UserIPArr       : array of TCounter;
  ShareIPArr      : array of TCounter;
  WrongShareMiner : array of TCounter;
  WrongShareIp    : array of TCounter;

  // Files
  configfile, LogFile, OldLogFile, PaysFile : TextFile;
  MinersFile   : File of TMinersData;
  MinersFileNew: File of TMinersDataNew;
  VPNIPsFile   : file of TVPNIPs;
  // Sumary
  ARRAY_Sumary : Array of SumaryData;
  FILE_Sumary  : file of SumaryData;
  // New Array of miners IPs
  ARRAY_MinersIPs : Array of TMinersIPs;
    ARRAY_BAckUPAMI : Array of TMinersIPs; // Works to disitribute payments
  // Config values
  PoolName     : string[15] = 'mypool';
  PoolPort     : integer = 8082;
  MinDiffBase  : string  = '00000';
  PoolFee      : integer = 200;
  PoolPay      : integer = 48;
  PoolAddress  : String  = '';
  PublicKey    : String  = '';
  PrivateKey   : String  = '';
  PoolAuto     : boolean = true;
  AutoDiff     : boolean = true;
  AutoValue    : integer = 500;
  PoolDonate   : integer = 5;
  AMIPass      : string = 'default';
  KillPool     : boolean = false;
  ProfitAddress: string = '';
  ProfitInterval : integer = 100;
  // Operative
  MinTreshold  : int64 = 40000000;
  previousNodes: string;
  ThisBlockMNs : boolean = false;
  ThisBlockDUPS: boolean = false;
  ArraySols    : array of integer;
  ArrayMiner   : array of string;
  ShareIndex   : array[0..15] of integer;
  Command      : string  = '';
  LastCommand  : string  = '';
  ThisChar     : Char;
  LastHelpShown: String = '';
  FinishProgram: Boolean = false;
  OnMainScreen : Boolean = True;
  OnLogScreen  : Boolean = false;
    RefreshScreen : Boolean = true;
    RefreshAge    : Int64 = 0;
    UpdateServerInfo : boolean = false;
    RefreshUpTime : int64 = 0;
    RefreshPoolBalance : boolean = false;
    RefreshPoolHeader  : boolean = false;
  LogLines     : Array of String;
  NewLogLines  : Array of string;
  MainnetTimeStamp : int64 = 0;
  RejectedShares   : integer = 0;
  RestartAfterQuit : boolean = false;
  FileToRestart    : string = '';
  MaxSharesPerBlock: integer = 1;
  MaxPaysPerBlock  : integer = 50;
  BannedAddresses  : string = '';
  Global_PendingToCredit : int64 = 0;
  Global_PoolProfit      : int64 = 0;
  // Mainnet
  LastConsensusTry : int64   = 0;
  WaitingConsensus :Boolean = false;
  CurrentBlock     : integer = 0;
  MainBestDiff     : String = DefWorst;
  MainnetHashRate  : int64 = 0;
  BlocksMinedByPool: integer = 0;
  ArrayPendingCredit : Array of TPendingPay;
  // Pool
  PoolBalance      : int64 = 0;
  CheckPaysThreads : Boolean = false;
  OpenPayThreads     : integer = 0;
    GoodPayments     : integer = 0;
    BadPayments      : integer = 0;
    TotalPaid        : int64 = 0;
    PendingAddresses : string = '';
  LastPaidBlock : integer = 0;
  LastBlockRate : int64 = 0;
  PoolServer : TIdTCPServer;
  PrefixIndex: Integer = 0;
  MinerDiff  : String = '';
  IPMiners: integer = 100;
  //ArrMiners : Array of TMinersData;
  ArrMinersNew : Array of TMinersDataNew;
  ArrShares : Array of TLimitStr;
    //Replace ArrShares
    ThisBlockShares : string = '';
    ThisBlockSharesCount : integer = 0;
  BlockTargetHash : String = '';
  ThisBlockBest   : String = DefWorst;
  ThisBlockBestAddress : string = '';
  Solution        : String = '';
  BlockPrefixesRequested : integer = 0;
  BestPoolSolution: TSolution;
  SESSION_BestHashes : Integer = 0;
  SESSION_Started    : Int64 = 0;
  SESSION_Shares     : integer = 0;
  SESSION_HashPerShare : QWord = 0;

  SLTor         : TStringList;
  TorCount      : integer = 0;
  TorAllowed    : String = '';
  TorBlocked    : string = '';
  ARRAy_VPNIPs  : Array of TVPNIPs;
  VPNCount      : integer = 0;
  ActivePays    : integer = 0;

  // Critical sections
  CS_UpdateScreen    : TRTLCriticalSection;
  CS_PrefixIndex     : TRTLCriticalSection;
  CS_LogLines        : TRTLCriticalSection;
  CS_Miners          : TRTLCriticalSection;
  CS_Shares          : TRTLCriticalSection;
  CS_BlockBest       : TRTLCriticalSection;
  CS_Solution        : TRTLCriticalSection;
  CS_PaysFile        : TRTLCriticalSection;
  CS_PayThreads      : TRTLCriticalSection;
  CS_PoolBalance     : TRTLCriticalSection;
  CS_LastBlockRate   : TRTLCriticalSection;
  CS_USerMiner       : TRTLCriticalSection;
  CS_UserIPArr       : TRTLCriticalSection;
  CS_ShareIPArr      : TRTLCriticalSection;
  CS_WrongShareMiner : TRTLCriticalSection;
  CS_WrongShareIp    : TRTLCriticalSection;
  CS_ArraySumary     : TRTLCriticalSection;
  CS_ArrayMinersIPS  : TRTLCriticalSection;
  CS_TorAllowed      : TRTLCriticalSection;
  CS_TorBlocked      : TRTLCriticalSection;
  CS_VPNIPs          : TRTLCriticalSection;
  // Active threads paying
  CS_Activepays      : TRTLCriticalSection;
  // Array Sources
  CS_ArrSources      : TRTLCriticalSection;
  // Array blocks
  CS_ArrBlocks       : TRTLCriticalSection;

IMPLEMENTATION

{$REGION VPNs thread}

constructor ThreadVPNs.Create(const CreatePaused: Boolean);
Begin
inherited Create(CreatePaused);
FreeOnTerminate := True;
End;

procedure ThreadVPNs.Execute;
var
  TempDups : string;
Begin
if not VPNsThreadRunning then
   begin
   VPNsThreadRunning := true;
   //ToLog(',VPN thread Started!');
      TRY
      ProcessNewVPNs(GetVPNBanList);
      //RunVPNClean(GetMainConsensus.block);
      //SaveVPNFile;
      if length(ArrayPendingCredit)>0 then
         begin
         TempDups := GetDupliaddresses;
         if TempDups <> '' then BannedAddresses := TempDups;
         ProcessPEndingCredits;
         end;
      EXCEPT ON E:Exception do
        ToLog(',CRITICAL ThreadVPNs: '+e.Message);
      END;
   ToLog(',DUPs thread Ended!');
   VPNsThreadRunning := false;
   end;
End;

{$ENDREGION}

{$REGION Payment thread}

constructor ThreadPayment.Create(const CreatePaused: Boolean; TAddress:string);
Begin
inherited Create(CreatePaused);
Address := TAddress;
FreeOnTerminate := True;
End;

procedure ThreadPayment.Execute;
var
  Balance    : int64;
  Fee        : int64;
  ToSend     : int64;
  TrxTime    : int64;
  trfHash    : String;
  OrdHash    : String;
  SignString : String;
  TextToSend : string;
  Resultado  : String = '';
  WasGood    : boolean = false;
  LastPayInfo: string = '';
  ErrorCode  : integer = 0;
Begin
Repeat
   sleep(5);
until ActivePaysCount <2;
if Address = ProfitAddress then
   begin
   Balance := (GLOBAL_PoolProfit*95) div 100;
   end
else
   begin
   Balance := GetMinerBalance(address);
   IncActivePays();
   end;
Fee     := GetFee(Balance);
ToSend  := Balance - Fee;
if ToSend<=0 then
   begin
   LastPayInfo := (GetMainConsensus.block+1).ToString+':'+ToSend.ToString+':'+'TooSmallAmount';
   ClearAddressBalance(Address, LastPayInfo);
   AddPaymentToFile((GetMainConsensus.block+1).ToString,Address,Balance.ToString,Resultado);
   WasGood := true;
   DecreasePayThreads(WasGood, Balance, Address);
   exit;
   end;
if not IsValidHashAddress(Address) then
   begin
   LastPayInfo := (GetMainConsensus.block+1).ToString+':'+ToSend.ToString+':'+'InvalidAddress';
   ClearAddressBalance(Address, LastPayInfo);
   AddPaymentToFile((GetMainConsensus.block+1).ToString,Address,Balance.ToString,Resultado);
   WasGood := true;
   DecreasePayThreads(WasGood, Balance, Address);
   exit;
   end;
TrxTime := GetMainConsensus.LBTimeEnd+60;
trfHash := GetTransferHash(TrxTime.ToString+PoolAddress+address+ToSend.ToString+IntToStr(GetMainConsensus.block));
OrdHash := GetOrderHash('1'+TrxTime.ToString+trfHash);

SignString := GetStringSigned(TrxTime.ToString+PoolAddress+Address+ToSend.ToString+
                     Fee.ToString+'1',PrivateKey);

TextToSend := 'NSLORDER 1 0.16 '+TrxTime.ToString+' ORDER 1 $TRFR '+OrdHash+' 1 TRFR '+TrxTime.ToString+
              ' PoolPay_'+PoolName+' 1 '+PublicKey+' '+PoolAddress+' '+Address+' '+Fee.ToString+' '+ToSend.ToString+' '+
              SignString+' '+trfHash;
Resultado  := SendOrder(TextToSend);
if Copy(Resultado,1,2) ='OR' then
   begin
   LastPayInfo := (GetMainConsensus.block+1).ToString+':'+ToSend.ToString+':'+Resultado;
   ClearAddressBalance(Address, LastPayInfo);
   AddPaymentToFile((GetMainConsensus.block+1).ToString,Address,Balance.ToString,Resultado);
   WasGood := true;
   DecreasePayThreads(True,Balance, Address);
   if Address = ProfitAddress then
      ToLog(Format('/Profit payment done: %s',[Int2curr(ToSend)]));
   end
else if Resultado <> '' then
   begin
   if parameter(Resultado,0) = 'ERROR' then
      begin
      ErrorCode := StrToIntDef(Parameter(Resultado,1),-1);
      if ErrorCode <> 98 then
         begin
         ToLog(Format(' Payment fail [%s]: %s',[Address,ErrorCode.ToString]));
         DecreasePayThreads(False,Balance, Address);
         end
      else
         begin
         ToLog(' Payment duplicated: '+OrdHash);
         LastPayInfo := (GetMainConsensus.block+1).ToString+':'+ToSend.ToString+':'+Resultado;
         ClearAddressBalance(Address, LastPayInfo);
         AddPaymentToFile((GetMainConsensus.block+1).ToString,Address,Balance.ToString,Resultado);
         WasGood := true;
         DecreasePayThreads(True,Balance, Address);
         end;
      end
   else // Unspecified response
      begin
      ToLog(' Payment unspecified error: '+Resultado);
      DecreasePayThreads(False,Balance, Address);
      end;
   end
else if resultado = '' then // Empty response from node
   begin
   ToLog(' Payment empty response error: '+OrdHash);
   DecreasePayThreads(False,Balance);
   end;
if Address <> ProfitAddress then DecActivePays();
End;

Procedure AddPaymentToFile(Block,destino,monto,OrderID:String);
var
  ThisFile : TextFile;
Begin
if fileexists('payments.txt') then
   begin
   EnterCriticalSection(CS_PaysFile);
   Append(PaysFile);
   Writeln(PaysFile,Format('%s %s %s %s',[block,destino,monto,OrderID]));
   CloseFile(PaysFile);
   LeaveCriticalSection(CS_PaysFile);
   end;
AssignFile(ThisFile,'addresses'+directoryseparator+destino+'.txt');
TRY
if not fileExists('addresses'+directoryseparator+destino+'.txt') then rewrite(ThisFile)
else Append(ThisFile);
Writeln(ThisFile,Format('%s %s %s',[block,monto,OrderID]));
CloseFile(ThisFile);
EXCEPT on E:Exception do
   begin
   ToLog(' Error saving payment to address file: '+destino+'->'+E.Message);
   end;
END{Try};
End;

// Sends a order to the mainnet
function SendOrder(OrderString:String):String;
var
  Client : TidTCPClient;
  RanNode : integer;
  ThisNode : TNodeData;
  Trys : integer = 0;
  WasDone : Boolean = false;
Begin
Result := '';
Client := TidTCPClient.Create(nil);
REPEAT
   RanNode := Random(LengthNodes);
   ThisNode := GetNodeIndex(RanNode);
   Client.Host:=ThisNode.host;
   Client.Port:=ThisNode.port;
   Client.ConnectTimeout:= 3000;
   Client.ReadTimeout:=3000;
   TRY
   Client.Connect;
   Client.IOHandler.WriteLn(OrderString);
   Result := Client.IOHandler.ReadLn(IndyTextEncoding_UTF8);
   WasDone := True;
   EXCEPT on E:Exception do
      begin
      WasDone := False;
      end;
   END{Try};
Inc(Trys);
UNTIL ( (WasDone) or (Trys=3) );
if client.Connected then Client.Disconnect();
client.Free;
End;

{$ENDREGION}

{$REGION Summary}

function GetSumary():boolean;
var
  TCPClient      : TidTCPClient;
  MyStream       : TMemoryStream;
  DownloadedFile : Boolean = false;
  HashLine       : string;
  RanNode        : integer;
  ThisNode       : TNodeData;
Begin
Result         := false;
RanNode := Random(LengthNodes);
ThisNode := GetNodeIndex(RanNode);
TCPClient := TidTCPClient.Create(nil);
TCPClient.Host:=ThisNode.host;
TCPClient.Port:=ThisNode.port;
TCPClient.ConnectTimeout:= 3000;
TCPClient.ReadTimeout:=3000;
MyStream       := TMemoryStream.Create;
TRY
TCPClient.Connect;
TCPClient.IOHandler.WriteLn('GETZIPSUMARY');
   TRY
   HashLine := TCPClient.IOHandler.ReadLn(IndyTextEncoding_UTF8);
   TCPClient.IOHandler.ReadStream(MyStream);
   result := true;
   MyStream.SaveToFile(ZipSumaryFilename);
   ToLog(' Sumary downloaded');
   EXCEPT on E:Exception do
      begin
      ToLog('Error downloading sumary: '+E.Message);
      end;
   END{Try};
EXCEPT on E:Exception do
   begin

   end;
END{try};
if TCPClient.Connected then TCPClient.Disconnect();
TCPClient.Free;
MyStream.Free;
End;

// Unzip the received sumary file
Procedure UnZipSumary();
var
  UnZipper: TUnZipper;
Begin
TRY
UnZipper := TUnZipper.Create;
   TRY
   UnZipper.FileName := ZipSumaryFilename;
   UnZipper.OutputPath := '';
   UnZipper.Examine;
   UnZipper.UnZipAllFiles;
   FINALLY
   UnZipper.Free;
   END;
EXCEPT on E:Exception do
   begin
   tolog (' Error unzipping sumary file');
   end;
END{Try};
End;

// Loads a sumary to memory
Procedure LoadSumary();
var
  Counter : integer = 0;
Begin
EnterCriticalSection(CS_ArraySumary);
TRY
SetLength(ARRAY_Sumary,0);
assignfile(FILE_Sumary,SumaryFilename);
Reset(FILE_Sumary);
SetLength(ARRAY_Sumary,fileSize(FILE_Sumary));
for Counter := 0 to Filesize(FILE_Sumary)-1 do
   Begin
   seek(FILE_Sumary,Counter);
   read(FILE_Sumary,ARRAY_Sumary[Counter]);
   end;
CloseFile(FILE_Sumary);
ToLog(' Sumary loaded');
EXCEPT on E:Exception do
   begin
   ToLog(' Error loading sumary: '+E.Message);
   end
END{Try};
LEaveCriticalSection(CS_ArraySumary);
End;

// Return the summary balance for the specified address
function GetAddressBalanceFromSumary(address:string):int64;
var
  cont : integer;
Begin
Result := 0;
EnterCriticalSection(CS_ArraySumary);
for cont := 0 to length(ARRAY_Sumary)-1 do
   begin
   if ((address = ARRAY_Sumary[cont].Hash) or (address = ARRAY_Sumary[cont].Custom)) then
      begin
      result := ARRAY_Sumary[cont].Balance;
      break;
      end;
   end;
LEaveCriticalSection(CS_ArraySumary);
End;

{$ENDREGION}

{$REGION Miner data file}

Procedure CreateMinersFile();
Begin
TRY
rewrite(MinersFileNew);
CloseFile(MinersFileNew);
EXCEPT ON E:EXCEPTION do
   begin
   writeln('Error creating miners file');
   Halt(1);
   end;
END {TRY};
End;

Procedure LoadMiners();
var
  ThisData : TMinersDataNew;
Begin
reset(MinersFileNew);
EnterCriticalSection(CS_Miners);
SetLength(ArrMinersNew,0);
While not eof(MinersFileNew) do
   begin
   read(MinersFileNew,ThisData);
   Insert(ThisData,ArrMinersNew,Length(ArrMinersNew));
   end;
LeaveCriticalSection(CS_Miners);
CloseFile(MinersFileNew);
End;

Procedure SaveMiners();
var
  Counter      : integer;
  AlreadyAdded : string = '';
  FileIsOpen   : Boolean = false;
Begin
EnterCriticalSection(CS_Miners);
TRY
rewrite(MinersFileNew);
   TRY
   FileIsOpen := true;
   for counter := 0 to length(ArrMinersNew)-1 do
      begin
      if ( (ArrMinersNew[counter].Shares>0) or (ArrMinersNew[counter].Balance>0) or((ArrMinersNew[counter].LastPay+36)<GetMAinConsensus.block) ) then
         begin
         if not AnsiContainsStr(AlreadyAdded,ArrMinersNew[counter].address) then
            begin
            write(MinersFileNew,ArrMinersNew[counter]);
            AlreadyAdded := AlreadyAdded+ArrMinersNew[counter].address+',';
            end;
         end;
      end;
   EXCEPT ON E:EXCEPTION do
      begin
      ToLog('.CRITICAL: Error saving miners file. '+E.Message);
      end;
   END {TRY};
CloseFile(MinersFileNew);
EXCEPT ON E:EXCEPTION do
   begin
    ToLog('.CRITICAL: Error accesing miners file. '+E.Message);
   end;
END {TRY};
LeaveCriticalSection(CS_Miners);
LoadMiners;
End;

Procedure MigrateMinersFile();
var
  OldData : TMinersData;
  NewData : TMinersDataNew;
  TotalMi : integer = 0;
Begin
reset(MinersFile);
rewrite(MinersFileNew);
EnterCriticalSection(CS_Miners);
While not eof(MinersFile) do
   begin
   read(MinersFile,OldData);
   NewData := Default(TMinersDataNew);
   NewData.address      := OldData.address;
   NewData.Balance      := OldData.Balance;
   NewData.LastPay      := OldData.LastPay;
   NewData.Shares       := OldData.Shares;
   NewData.LastPayOrder := OldData.LastPayOrder;
   NewData.Password     := '';
   NewData.BlockRegister:= 0;
   NewData.LastActive   := 0;
   write(MinersFileNew,NewData);
   Inc(TotalMi);
   end;
LeaveCriticalSection(CS_Miners);
CloseFile(MinersFile);
CloseFile(MinersFileNew);
if TotalMi>0 then ToLog(Format(' Migrated data to PoPW: %d',[TotalMi]));
RenameFile ('miners'+DirectorySeparator+'miners.dat','miners'+DirectorySeparator+'minersold.dat');
End;

{$ENDREGION}

{$REGION create default files}

Procedure CreateBlockzero();
var
  ThisFile : TextFile;
Begin
AssignFile(ThisFile,'blocks'+DirectorySeparator+'0.txt');
TRY
rewrite(ThisFile);
CloseFile(ThisFile);
EXCEPT ON E:EXCEPTION do
   begin
   writeln('Error creating block 0');
   Halt(1);
   end;
END {TRY};
End;

Procedure createPaymentsFile();
var
  ThisFile : TextFile;
Begin
AssignFile(ThisFile,'payments.txt');
TRY
rewrite(ThisFile);
CloseFile(ThisFile);
EXCEPT ON E:EXCEPTION do
   begin
   writeln('Error creating payments file');
   Halt(1);
   end;
END {TRY};
End;

Procedure CreateVPNfile();
Begin
TRY
rewrite(VPNIPsFile);
CloseFile(VPNIPsFile);
EXCEPT ON E:EXCEPTION do
   begin
   writeln('Error creating VPNs file');
   Halt(1);
   end;
END {TRY};
End;

Procedure CreateNodesFile();
var
  ThisFile : TextFile;
Begin
AssignFile(ThisFile,'nodes.txt');
TRY
rewrite(ThisFile);
write(ThisFile,DefaultNodes);
CloseFile(ThisFile);
EXCEPT ON E:EXCEPTION do
   begin
   ToLog(' Error creating nodes file');
   Halt(1);
   end;
END {TRY};
previousNodes := DefaultNodes;
End;

Procedure Createcclassesfile;
var
  ThisFile : TextFile;
Begin
AssignFile(ThisFile,'cclasses.dat');
TRY
rewrite(ThisFile);
write(ThisFile,DefaultCclasses);
CloseFile(ThisFile);
EXCEPT ON E:EXCEPTION do
   begin
   ToLog(' Error creating CClasses file');
   Halt(1);
   end;
END {TRY};
previousNodes := DefaultNodes;
End;

{$ENDREGION}

{$REGION VPNs file management}

Procedure LoadVPNFile();
var
  ThisData : TVPNIPs;
Begin
EnterCriticalSection(CS_VPNIPs);
reset(VPNIPsFile);
SetLength(ARRAy_VPNIPs,0);
While not eof(VPNIPsFile) do
   begin
   read(VPNIPsFile,ThisData);
   Insert(ThisData,ARRAy_VPNIPs,Length(ARRAy_VPNIPs));
   end;
CloseFile(VPNIPsFile);
ToLog(' Loaded VPNs: '+IntToStr(length(ARRAy_VPNIPs)));
LeaveCriticalSection(CS_VPNIPs);
End;

Procedure SaveVPNFile(ThisArray: array of TVPNIPs);
var
  counter  : integer;
  CSVlist  : string = '';
  ThisFile : Textfile;
Begin
TRY
rewrite(VPNIPsFile);
For counter := 0 to length(ThisArray)-1 do
   begin
   write(VPNIPsFile,ThisArray[counter]);
   CSVlist := CSVlist+ThisArray[counter].IP+'.0/24'+',';
   end;
CloseFile(VPNIPsFile);
ToLog(' DUPs SAVED: '+IntToStr(length(ThisArray)));
EXCEPT ON E:Exception do
  ToLog('.CRITICAL SaveDuplicated: '+e.Message);
END;
Assignfile(thisFile,'duplicated.csv') ;
TRY
  Rewrite(ThisFile);
  writeln(ThisFile,CSVlist);
  CloseFile(ThisFile);
  ToLog(' DUPLICATED CSV saved ');
EXCEPT ON E:Exception do
  ToLog('.CRITICAL SaveDuplicated CSV: '+e.Message);
END;
End;

Function ConfirmPending(Address:string;Amount:int64): int64;
var
  counter : integer;
Begin
Result := 0;
EnterCriticalSection(CS_Miners);
for counter := 0 to length(ArrMinersNew)-1 do
   begin
   if ArrMinersNew[counter].address = address then
      begin
      ArrMinersNew[counter].balance:=ArrMinersNew[counter].balance+Amount;
      Result := Amount;
      break;
      end;
   end;
LEaveCriticalSection(CS_Miners);
End;

Procedure ProcessPEndingCredits();
var
  counter : integer;
  LTotalPAid : int64 = 0;
  ToJackpot : int64 = 0;
  Processed : int64;
  ProcessCount : integer = 0;
  Ignored   : int64 = 0;
  IgnoCount : integer = 0;
Begin
for counter := 0 to length(ArrayPendingCredit)-1 do
   begin
   if Not AnsiContainsStr(BannedAddresses,ArrayPendingCredit[counter].address) then
      begin
      Processed := ConfirmPending(ArrayPendingCredit[counter].address,ArrayPendingCredit[counter].Balance);
      if Processed > 0 then
         begin
         Inc(LTotalPAid,Processed);
         Inc(ProcessCount);
         end
      else
         begin
         Inc (Ignored,ArrayPendingCredit[counter].Balance);
         Inc(IgnoCount);
         end;
      end
   else
      begin
      //CreditFundsToProject(ArrayPendingCredit[counter].Balance);
      Inc(ToJackpot,ArrayPendingCredit[counter].Balance);
      end;
   end;
Global_PendingToCredit := 0;
SetLEngth(ArrayPendingCredit,0);
AddPoolPotBalance(Ignored);
AddPoolPotBalance(ToJackpot);
ToLog(Format(' Confirmed credited : %s [ %s ] [ %s ]',[Int2curr(LTotalPAid),int2curr(ToJackpot),int2curr(Ignored)]));
ToLog(Format(' Total debt : %s ',[Int2curr(GetTotalDebt)]));
SaveMiners;
End;

{$ENDREGION}

{$REGION Nodes file}

Function GetNodesFileData():String;
var
  ThisFile : TextFile;
Begin
result := '';
AssignFile(ThisFile,'nodes.txt');
TRY
reset(ThisFile);
Readln(ThisFile,result);
PreviousNodes := Result;
CloseFile(ThisFile);
EXCEPT ON E:EXCEPTION do
   begin
   result := previousNodes
   end;
END {TRY};
End;

function SaveMnsToDisk(lineText:string): boolean;
var
  ThisFile : TextFile;
Begin
Result := true;
if LineText = '' then exit;
AssignFile(ThisFile,'nodes.txt');
TRY
rewrite(ThisFile);
   TRY
   write(ThisFile,lineText);
   EXCEPT ON E:EXCEPTION do
      begin
      ToLog('.Error saving MNs to file: '+E.Message);
      result := false;
      end;
   END {TRY};
CloseFile(ThisFile);
EXCEPT ON E:EXCEPTION do
   begin
   ToLog('.CRITICAL Saving MNs to disk: '+E.Message);
   result := false;
   end;
END {TRY};
End;

{$ENDREGION}

{$REGION Miscellaneous}

// Returns the last processed block
function GetMyLastUpdatedBlock():int64;
Var
  BlockFiles : TStringList;
  contador : int64 = 0;
  LastBlock : int64 = 0;
  OnlyNumbers : String;
Begin
BlockFiles := TStringList.Create;
   TRY
   FindAllFiles(BlockFiles, 'blocks'+DirectorySeparator, '*.txt', true);
   while contador < BlockFiles.Count do
      begin
      OnlyNumbers := copy(BlockFiles[contador], 8, length(BlockFiles[contador])-11);
      LastBlock := StrToIntDef(OnlyNumbers,-1);
      contador := contador+1;
      end;
   Result := LastBlock;
   EXCEPT on E:Exception do
      tolog (' Error getting my last updated block');
   END; {TRY}
BlockFiles.Free;
end;

Function UpTime():string;
var
  TotalSeconds,days,hours,minutes,seconds, remain : integer;
Begin
if SESSION_Started = 0 then
   begin
   Result := '00:00:00';
   exit;
   end;
Totalseconds := UTCTime-SESSION_Started;
Days := Totalseconds div 86400;
remain := Totalseconds mod 86400;
hours := remain div 3600;
remain := remain mod 3600;
minutes := remain div 60;
remain := remain mod 60;
seconds := remain;
if Days > 0 then Result:= Format('%dd %.2d:%.2d:%.2d', [Days, Hours, Minutes, Seconds])
else Result:= Format('%.2d:%.2d:%.2d', [Hours, Minutes, Seconds]);
End;

{$ENDREGION}

{$REGION Miners data management}

Function MinersCount():Integer;
Begin
EnterCriticalSection(CS_Miners);
Result := Length(ArrMinersNew);
LeaveCriticalSection(CS_Miners);
End;

Function GetMinerBalance(address:string):int64;
var
  counter : integer;
Begin
Result := 0;
EnterCriticalSection(CS_Miners);
for counter := 0 to length(ArrMinersNew)-1 do
   begin
   if ArrMinersNew[counter].address = address then
      begin
      result := ArrMinersNew[counter].Balance;
      break;
      end;
   end;
LeaveCriticalSection(CS_Miners);
End;

Function GetMinerData(address:string):string;
var
  counter    : integer;
  BlocksTill : integer;
Begin
Result := '';
EnterCriticalSection(CS_Miners);
for counter := 0 to length(ArrMinersNew)-1 do
   begin
   if ArrMinersNew[counter].address = address then
      begin
      BlocksTill := PoolPay-(GetMainConsensus.block-ArrMinersNew[counter].LastPay);
      If BlocksTill<0 then BlocksTill := 0;
      result := Format('%d %d %s',[ArrMinersNew[counter].Balance,BlocksTill,ArrMinersNew[counter].LastPayOrder]);
      break;
      end;
   end;
LeaveCriticalSection(CS_Miners);
End;

Procedure ClearAddressBalance(Address, LastPayInfo:string);
var
  counter : integer;
Begin
EnterCriticalSection(CS_Miners);
for counter := 0 to length(ArrMinersNew)-1 do
   begin
   if ArrMinersNew[counter].address = address then
      begin
      ArrMinersNew[counter].Balance := 0;
      ArrMinersNew[counter].LastPay:=GetMAinConsensus.block;
      ArrMinersNew[counter].LastPayOrder:=LastPayInfo;
      break;
      end;
   end;
LeaveCriticalSection(CS_Miners);
End;

Function GetTotalDebt():Int64;
var
  counter : integer;
Begin
result := 0;
EnterCriticalSection(CS_Miners);
for counter := 0 to length(ArrMinersNew)-1 do
   Inc(Result,ArrMinersNew[counter].Balance);
LeaveCriticalSection(CS_Miners);
End;

Procedure CreditShare(Address,IPUser:String);
var
  counter : integer;
  Credited : boolean = false;
  NewMiner : TMinersDataNew;
Begin
EnterCriticalSection(CS_Miners);
For counter := 0 to length(ArrMinersNew)-1 do
   begin
   if ArrMinersNew[counter].address = address then
      begin
      Credited := true;
      Inc(ArrMinersNew[counter].Shares);
      break
      end;
   end;
if Not Credited then
   begin
   NewMiner := Default(TMinersDataNew);
   NewMiner.address:=address;
   NewMiner.Shares:=1;
   NewMiner.Balance:=0;
   NewMiner.LastPay:=GetMainConsensus.block;
   Insert(NewMiner,ArrMinersNew,Length(ArrMinersNew));
   end;
LeaveCriticalSection(CS_Miners);
AddShareIP(IPUser);
End;

function GetPoolPotBalance(ClearBalance : boolean = false):int64;
var
  counter : integer;
Begin
Result := 0;
EnterCriticalSection(CS_Miners);
for counter := 0 to length(ArrMinersNew)-1 do
   begin
   if ArrMinersNew[counter].address = PoolPot then
      begin
      result := ArrMinersNew[counter].Balance;
      if clearbalance then ArrMinersNew[counter].Balance:=0;
      ArrMinersNew[counter].LastPay:=GetMainConsensus.block;
      break;
      end;
   end;
LeaveCriticalSection(CS_Miners);
End;

Procedure AddPoolPotBalance(Balance:int64);
var
  counter : integer;
  WasFound : boolean = false;
  NewMiner : TMinersDataNew;
Begin
EnterCriticalSection(CS_Miners);
for counter := 0 to length(ArrMinersNew)-1 do
   begin
   if ArrMinersNew[counter].address = PoolPot then
      begin
      Inc(ArrMinersNew[counter].Balance,balance);
      ArrMinersNew[counter].LastPay:=GetMainConsensus.block;
      WasFound := true;
      break;
      end;
   end;
If not WasFOund Then
   begin
   NewMiner := Default(TMinersDataNew);
   NewMiner.address:=poolpot;
   NewMiner.Shares:=0;
   NewMiner.Balance:=Balance;
   NewMiner.LastPay:=GetMainConsensus.block;
   Insert(NewMiner,ArrMinersNew,Length(ArrMinersNew));
   end;
LeaveCriticalSection(CS_Miners);
End;

Procedure SetPoolPotBalance(Balance:int64);
var
  counter  : integer;
  WasFound : boolean = false;
  NewMiner : TMinersDataNew;
Begin
EnterCriticalSection(CS_Miners);
for counter := 0 to length(ArrMinersNew)-1 do
   begin
   if ArrMinersNew[counter].address = PoolPot then
      begin
      ArrMinersNew[counter].Balance := balance;
      WasFound := true;
      break;
      end;
   end;
If not WasFOund Then
   begin
   NewMiner := Default(TMinersDataNew);
   NewMiner.address:=poolpot;
   NewMiner.Shares:=0;
   NewMiner.Balance:=Balance;
   NewMiner.LastPay:=GetMainConsensus.block;
   Insert(NewMiner,ArrMinersNew,Length(ArrMinersNew));
   end;
LeaveCriticalSection(CS_Miners);
End;

{$ENDREGION}

{$REGION Block shares management}

Function ShareAlreadyExists(Share:string):boolean;
var
  counter : integer;
Begin
Result := false;
EnterCriticalSection(CS_Shares);
For counter := 0 to length(ArrShares)-1 do
   begin
   if ArrShares[counter] = Share then
      begin
      result := true;
      break
      end;
   end;
LeaveCriticalSection(CS_Shares);
End;

Procedure AddShare(Share:string);
Begin
EnterCriticalSection(CS_Shares);
SetLength(ArrShares, length(ArrShares)+1);
ArrShares[LEngth(ArrShares)-1] := Share;
LeaveCriticalSection(CS_Shares);
End;

Function SharesCount():Integer;
Begin
EnterCriticalSection(CS_Shares);
Result := length(ArrShares);
LeaveCriticalSection(CS_Shares);
End;

Function ShareIsValid(Share,Address,MinerProgram,IPUser,CreditAddress, RAWIP:STring):integer;
var
  ThisHash, ThisDiff : string;
  ThisSolution : TSolution;
Begin
Result := 0;
if IPTorBlocked(RAWIP) then
   begin
   Inc(TorCount);
   Result := 11;
   exit;
   end;
if not IpTorAllowed(RAWIP) then
   begin
   If IsTorIP(RAWIP) then
      begin
      AddTorBlocked(RAWIP);
      Inc(TorCOunt);
      Result := 11;
      exit;
      end
   else
      begin
      AddTorAllowed(RAWIP);
      end;
   end;
if VPNIPExists(IPUser) then
   begin
   Inc(VPNCOunt);
   Result := -1;
   exit;
   end;
if ShareAlreadyExists(Share) then
   begin
   ToLog(Format(' Error 4 [%s] [%s]',[MinerProgram,IPUser]),uToFile);
   result := 4;
   Inc(RejectedShares);
   AddWrongShareMiner(MinerProgram);
   AddWrongShareIp(IPUser);
   end
else if ((length(Share)<18) or (length(Share)>33)) then
   begin
   ToLog(Format(' Error 7 [%s] [%s]',[MinerProgram,IPUser]),uToFile);
   result := 7;
   Inc(RejectedShares);
   AddWrongShareMiner(MinerProgram);
   AddWrongShareIp(IPUser);
   end
else
   begin
   ThisHash := NosoHash(Share+PoolAddress);
   ThisDiff := GetHashDiff(GetMainConsensus.LBHash,ThisHash);
   if ( (ThisDiff < MinerDiff) and (Copy(ThisDiff,1,7)<>'0000000') ) then // Valid share
      begin
      Result := 0;
      AddShare(Share+Address);
      CreditShare(CreditAddress,IPUser);
      AddUserAddress(Address);
      If StoreShares then CreditFrequency(ThisDiff);
      Inc(SESSION_Shares);
      if ThisDiff<MainBestDiff then
         begin
         ThisSolution.Hash:=Share;
         ThisSolution.address:=Address;
         ThisSolution.Diff:=ThisDiff;
         SetSolution(ThisSolution);
         SetBlockBest(ThisDiff, Address );
         end;
      if ThisDiff<GetBlockBEst then
         begin
         ThisSolution.Hash:=Share;
         ThisSolution.address:=Address;
         ThisSolution.Diff:=ThisDiff;
         SetBlockBest(ThisDiff, Address)
         end;
      end
   else
      begin
      result := 5;
      ToLog(Format(' Error 5 [%s] [%s]',[MinerProgram,IPUser]),uToFile);
      Inc(RejectedShares);
      AddWrongShareMiner(MinerProgram);
      AddWrongShareIp(IPUser);
      end;
   end;
End;

{$ENDREGION}

{$REGION Block solution}

Procedure SetSolution(Data:TSolution);
Begin
EnterCriticalSection(CS_Solution);
BestPoolSolution := Data;
if BestPoolSolution.Diff = '' then BestPoolSolution.Diff := 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF';
LeaveCriticalSection(CS_Solution);
End;

Function GetSolution():TSolution;
Begin
EnterCriticalSection(CS_Solution);
Result := BestPoolSolution;
LeaveCriticalSection(CS_Solution);
End;

{$ENDREGION}

{$REGION Logs management}

// Prepare logs files
Function ResetLogs():boolean;
var
  ThisLine : string;
Begin
result := true;
TRY
If not FileExists('logs'+DirectorySeparator+'oldlogs.txt') then
   Begin
   Rewrite(OldLogFile);
   CloseFile(OldLogFile);
   end;
If not FileExists('logs'+DirectorySeparator+'log.txt') then
   Begin
   Rewrite(logfile);
   CloseFile(logfile);
   end;
Reset(logfile);
Append(OldLogFile);
While not Eof(LogFile) do
   begin
   ReadLn(LogFile,ThisLine);
   WriteLn(OldLogFile,ThisLine);
   end;
CloseFile(LogFile);
CloseFile(OldLogFile);
Rewrite(LogFile);
CloseFile(LogFile);
EXCEPT ON E:Exception do
   begin
   Result := false;
   ToLog(' RESETLOGS: '+E.Message);
   end;
END {Try};
End;

Procedure RawToLogFile(Linea:String);
Begin
TRY
append(logfile);
WriteLn(LogFile,Linea);
CloseFile(LogFile);
EXCEPT ON E:EXCEPTION do
   begin
   end;
END {TRY};
End;

Procedure ToLog(Texto:string;ShowOnScreen:integer = 0);
Begin
if ShowOnScreen = uToFile then
   begin
   Texto := copy(Texto,1,1)+TimeToStr(now)+' '+copy(Texto,2, length(texto));
   RawToLogFile(copy(Texto,2, length(texto)))
   end
else if ShowOnScreen = uToConsole then
   begin
   EnterCriticalSection(CS_LogLines);
   Insert(Texto,LogLines,Length(LogLines));
   LeaveCriticalSection(CS_LogLines);
   end
else
   begin
   Texto := copy(Texto,1,1)+TimeToStr(now)+' '+copy(Texto,2, length(texto));
   RawToLogFile(copy(Texto,2, length(texto)));
   EnterCriticalSection(CS_LogLines);
   Insert(Texto,LogLines,Length(LogLines));
   LeaveCriticalSection(CS_LogLines);
   end;
End;

{$ENDREGION}

{$REGION User config management}

// Creates/saves config data
Function SaveConfig():boolean;
Begin
result := true;
TRY
rewrite(configfile);
writeln(configfile,'poolname '+PoolName);
writeln(configfile,'pooladdress '+PoolAddress);
writeln(configfile,'publickey '+PublicKey);
writeln(configfile,'privatekey '+PrivateKey);
writeln(configfile,'poolport '+IntToStr(PoolPort));
writeln(configfile,'diffbase '+MinDiffBase);
writeln(configfile,'poolfee '+IntToStr(PoolFee));
writeln(configfile,'poolpay '+IntToStr(PoolPay));
writeln(configfile,'ipminers '+IntToStr(IPMiners));
writeln(configfile,'autostart '+BoolToStr(PoolAuto,True));
writeln(configfile,'autodiff '+BoolToStr(AutoDiff,True));
writeln(configfile,'autovalue '+IntToStr(AutoValue));
writeln(configfile,'donate '+PoolDonate.ToString);
writeln(configfile,'amipass '+AMIPass);
writeln(configfile,'killpool '+BoolToStr(killpool,True));
writeln(configfile,'profitaddress '+ProfitAddress);
writeln(configfile,'profitinterval '+IntToStr(ProfitInterval));

CloseFile(configfile);
EXCEPT ON E:EXCEPTION do
   begin
   writeln('Error saving config file: '+E.Message);
   end
END {TRY};
End;

Procedure LoadConfig();
var
  linea : string;
Begin
TRY
reset(configfile);
EXCEPT ON E:EXCEPTION do
   begin
   writeln('Error opening config file: '+E.Message);
   exit
   end
END {TRY};
TRY
while not eof(configfile) do
   begin
   readln(configfile,linea);
   if uppercase(Parameter(linea,0)) = 'POOLNAME' then PoolName := Parameter(linea,1);
   if uppercase(Parameter(linea,0)) = 'POOLPORT' then PoolPort := StrToIntDef(Parameter(linea,1),Poolport);
   if uppercase(Parameter(linea,0)) = 'DIFFBASE' then MinDiffBase := '00000';{Parameter(linea,1);}
   if uppercase(Parameter(linea,0)) = 'POOLFEE' then PoolFee := StrToIntDef(Parameter(linea,1),PoolFee);
   if uppercase(Parameter(linea,0)) = 'POOLPAY' then PoolPay := StrToIntDef(Parameter(linea,1),PoolPay);
   if uppercase(Parameter(linea,0)) = 'POOLADDRESS' then PoolAddress := Parameter(linea,1);
   if uppercase(Parameter(linea,0)) = 'PUBLICKEY' then PublicKey := Parameter(linea,1);
   if uppercase(Parameter(linea,0)) = 'PRIVATEKEY' then PrivateKey := Parameter(linea,1);
   if uppercase(Parameter(linea,0)) = 'IPMINERS' then IPMiners := StrToIntDef(Parameter(linea,1),IPMiners);
   if uppercase(Parameter(linea,0)) = 'AUTOSTART' then PoolAuto := StrToBool(Parameter(linea,1));
   if uppercase(Parameter(linea,0)) = 'AUTODIFF' then AutoDiff := StrToBool(Parameter(linea,1));
   if uppercase(Parameter(linea,0)) = 'AUTOVALUE' then AutoValue := StrToIntDef(Parameter(linea,1),AutoValue);
   if uppercase(Parameter(linea,0)) = 'DONATE' then PoolDonate := StrToIntDef(Parameter(linea,1),PoolDonate);
   if uppercase(Parameter(linea,0)) = 'AMIPASS' then AMIPass := Parameter(linea,1);
   if uppercase(Parameter(linea,0)) = 'KILLPOOL' then KillPool := StrToBool(Parameter(linea,1));
   if uppercase(Parameter(linea,0)) = 'PROFITADDRESS' then ProfitAddress := Parameter(linea,1);
   if uppercase(Parameter(linea,0)) = 'PROFITINTERVAL' then ProfitInterval := StrToIntDef(Parameter(linea,1),ProfitInterval);
   if PoolDonate>99 then PoolDonate := 99;
   end;
EXCEPT ON E:EXCEPTION do
   begin
   writeln('Error reading config file: '+E.Message);
   exit
   end
END {TRY};
TRY
CloseFile(configfile);
EXCEPT ON E:EXCEPTION do
   begin
   writeln('Error closing config file: '+E.Message);
   exit
   end
END {TRY};
End;

{$ENDREGION}

{$REGION Screen refresh}

Function UpdateScreen():Boolean;
Begin
EnterCriticalSection(CS_UpdateScreen);
Result := RefreshScreen;
RefreshScreen := false;
LeaveCriticalSection(CS_UpdateScreen);
End;

Procedure SetUpdateScreen();
Begin
EnterCriticalSection(CS_UpdateScreen);
RefreshScreen := True;
LeaveCriticalSection(CS_UpdateScreen);
End;

{$ENDREGION}

{$REGION SERVER}

Procedure InitServer();
Begin
PoolServer := TIdTCPServer.Create(nil);
PoolServer.DefaultPort:=PoolPort;
PoolServer.Active:=false;
PoolServer.UseNagle:=true;
PoolServer.TerminateWaitTime:=5000;
PoolServer.OnExecute:=@PoolServerEvents.OnExecute;
PoolServer.OnConnect:=@PoolServerEvents.OnConnect;
End;

Function StartPool():String;
Var
  Success: boolean = false;
Begin
if PoolServer.Active then
   Begin
   Result := 'Pool already active';
   exit;
   end;
TRY
PoolServer.Bindings.Clear;
PoolServer.DefaultPort:=PoolPort;
PoolServer.Active:=true;
Success := true;
MinerDiff := AddCharR('F',MinDiffBase,32);
ToLog(' Server started at port '+PoolPort.ToString);
SESSION_Started := UTCTime;
SESSION_HashPerShare := Round(Power(16,GetDiffHashrate(MinerDiff)/100));
ToLog(' Hashes Per Share : '+SESSION_HashPerShare.ToString);
if Offset <> 0 then ToLog('.Time offset : '+Offset.ToString);
EXCEPT ON E:Exception do
   Result := E.Message;
END; {TRY}
If success then
   Begin
   Result := 'Pool server started';
   UpdateServerInfo := true;
   end;
End;

Function StopPool():String;
Var
  Success: boolean = false;
Begin
if not PoolServer.Active then
   Begin
   Result := 'Pool is already unactive';
   exit;
   end;
TRY
PoolServer.Active:=false;
Success := true;
SESSION_Started := 0;
EXCEPT On E:Exception do
   Result := E.Message;
END; {TRY}
If success then
   Begin
   Result := 'Pool stopped';
   UpdateServerInfo := true;
   end;
End;

{$ENDREGION}

{$REGION Block best}

Function GetBlockBest():String;
Begin
EnterCriticalSection(CS_BlockBest);
Result := ThisBlockBest;
LeaveCriticalSection(CS_BlockBest);
End;

Function GetBlockBestAddress():String;
Begin
EnterCriticalSection(CS_BlockBest);
Result := ThisBlockBestAddress;
LeaveCriticalSection(CS_BlockBest);
End;

Procedure SetBlockBest(ThisValue:String; Laddress: string);
Begin
EnterCriticalSection(CS_BlockBest);
ThisBlockBest := ThisValue;
ThisBlockBestAddress := LAddress;
LeaveCriticalSection(CS_BlockBest);
End;

{$ENDREGION}

Procedure LoadCClasses;
var
  ThisFile : TextFile;
  ThisLine : string;
Begin
AssignFile(ThisFile,'cclasses.dat');
DefaultCclasses := '';
TRY
Reset(ThisFile);
while not eof(thisfile) do
   begin
   ReadLn(ThisFile, ThisLine);
   ThisLine := Trim(ThisLine);
   DefaultCclasses := DefaultCclasses+ThisLine+' ';
   end;
Closefile(ThisFile);
DefaultCclasses := Trim(DefaultCclasses);
ToLog(Format(' C classes loaded',[]));
EXCEPT ON E:Exception do
   begin
   ToLog(Format(' Error Loading C classes file: %s',[E.Message]));
   end;
END;
End;

Procedure CreditDonationToDeveloper(Amount:int64);
var
  Counter  : integer;
  Found    : boolean = false;
  NewMiner : TMinersDataNew;
Begin
EnterCriticalSection(CS_Miners);
For counter := 0 to length(ArrMinersNew)-1 do
   begin
   if ArrMinersNew[counter].address =DeveloperAddress then
      begin
      Inc(ArrMinersNew[counter].Balance,amount);
      Found := true;
      Break;
      end;
   end;
If not found then
   begin
   NewMiner := Default(TMinersDataNew);
   NewMiner.address:=DeveloperAddress;
   NewMiner.Shares:=0;
   NewMiner.Balance:=Amount;
   NewMiner.LastPay:=GetMainConsensus.block;
   Insert(NewMiner,ArrMinersNew,Length(ArrMinersNew));
   end;
LEaveCriticalSection(CS_Miners);
ToLog(' Donated to dev: '+Int2curr(amount));
End;

Procedure CreditFundsToProject(Amount:int64);
var
  Counter  : integer;
  Found    : boolean = false;
  NewMiner : TMinersDataNew;
Begin
EnterCriticalSection(CS_Miners);
For counter := 0 to length(ArrMinersNew)-1 do
   begin
   if ArrMinersNew[counter].address =ProjectAddress then
      begin
      Inc(ArrMinersNew[counter].Balance,amount);
      Found := true;
      Break;
      end;
   end;
If not found then
   begin
   NewMiner := Default(TMinersDataNew);
   NewMiner.address:=ProjectAddress;
   NewMiner.Shares:=0;
   NewMiner.Balance:=Amount;
   NewMiner.LastPay:=GetMainConsensus.block;
   Insert(NewMiner,ArrMinersNew,Length(ArrMinersNew));
   end;
LEaveCriticalSection(CS_Miners);
//ToLog(' Credited to project: '+Int2curr(amount));
End;

Function DistributeBlockPayment():string;
var
  counter       : integer;
  TotalShares   : Integer = 0;
  ToDistribute  : int64;
  PerShare      : int64;
  Comision      : int64;
  Earned        : int64;
  BaseReward    : int64;
  DonationAmount: int64 = 0;
  TotalPending  : int64 = 0;
  FromPot       : int64 = 0;
Begin
Result := '';
BaseReward := GetMainConsensus.LBPoW;
ToDistribute := BaseReward;
Comision := (ToDistribute * PoolFee) div 10000;
BaseReward := ToDistribute - Comision;
FromPot := GetPoolPotBalance;
ToDistribute := BaseReward + fromPot;
EnterCriticalSection(CS_Miners);
Setlength(ArrayPendingCredit,0);
Setlength(ArrayPendingCredit,1);
ArrayPendingCredit[0].Balance := GetMainConsensus.block;
For counter := 0 to length(ArrMinersNew)-1 do
   TotalShares := TotalShares+ArrMinersNew[counter].Shares;
PerShare := ToDistribute div TotalShares;
For counter := 0 to length(ArrMinersNew)-1 do
   begin
   if ArrMinersNew[counter].Shares>0 then
      begin
      //ArrMinersNew[counter].Balance:=ArrMinersNew[counter].Balance+((ArrMinersNew[counter].Shares * PerShare));
      Setlength(ArrayPendingCredit,length(ArrayPendingCredit)+1);
      ArrayPendingCredit[length(ArrayPendingCredit)-1].address:=ArrMinersNew[counter].address;
      ArrayPendingCredit[length(ArrayPendingCredit)-1].Balance:=ArrMinersNew[counter].Shares * PerShare;
      Inc(TotalPending,ArrMinersNew[counter].Shares * PerShare);
      ArrMinersNew[counter].Shares := 0;
      end;
   end;
LeaveCriticalSection(CS_Miners);
Global_PendingToCredit := TotalPending;
ToLog(Format(' Total pending: %s [%s + %s]',[int2curr(TotalPending),int2curr(BaseReward),int2curr(FromPot)]));
SetPoolPotBalance(0);
Earned :=ToDistribute-(PerShare*TotalShares);
ToLog(Format(' Earned : %s ',[Int2curr(Earned)]));
if PoolDonate>0 then
   begin
   {
   DonationAmount := (Earned*PoolDonate) div 100;
   CreditDonationToDeveloper(DonationAmount);
   }
   end;
Result := PerShare.ToString+' '+Earned.ToString+' '+TotalShares.ToString+' '+DonationAmount.ToString;
End;

Procedure RunPayments();
var
  ThisBlock       : integer;
  counter         : integer;
  ThisThread      : ThreadPayment;
  CopyArray       : Array of TMinersDataNew;
  PayingAddresses : integer = 0;
  TotalToPay      : int64 = 0;
  AddressList     : string = '';
  ThisBlockPays   : integer = 0;
  ToProject       : int64 = 0;
  TotalProject    : int64 = 0;
Begin
ClearActivePays();
ThisBlock := GetMainConsensus.block;
SetLength(CopyArray,0);
SetPayThreads(0, '');
EnterCriticalSection(CS_Miners);
CopyArray := copy(ArrMinersNew,0,length(ArrMinersNew));
LeaveCriticalSection(CS_Miners);
For counter := 0 to length(CopyArray)-1 do
   begin
   if ((CopyArray[counter].Balance>MinTresHold)and(CopyArray[counter].LastPay+poolpay<= ThisBlock)and
       (CopyArray[counter].address<>PoolAddress) )then
      begin
      Inc(PayingAddresses);
      AddressList := AddressList+' '+CopyArray[counter].address;
      TotalToPay := TotalToPay + CopyArray[counter].Balance;
      ThisThread := ThreadPayment.create(true,CopyArray[counter].address);
      ThisThread.FreeOnTerminate:=true;
      ThisThread.Start;
      IncreasePaythread(CopyArray[counter].address,CopyArray[counter].Balance);
      Inc(ThisBlockPays);
      if ThisBlockPays >= MaxPaysPerBlock then break;
      sleep(1);
      end;
   if ((CopyArray[counter].Balance<MinTresHold)and(CopyArray[counter].LastPay+1008<= ThisBlock)and
       (CopyArray[counter].address<>PoolAddress) and
       (CopyArray[counter].address<>ProjectAddress) )then
      begin
      ToProject := CopyArray[counter].Balance;
      ClearAddressBalance(CopyArray[counter].address,ThisBlock.ToString+':'+
         CopyArray[counter].Balance.ToString+':'+'Expired');
      AddPoolPotBalance(ToProject);
      Inc(TotalProject,ToProject);
      end;
   if ((CopyArray[counter].Balance>0)and(CopyArray[counter].LastPay+poolpay<= ThisBlock)and(CopyArray[counter].address=PoolAddress) )then
      begin
      // Same address than pool address, do not send to save fees.
      ClearAddressBalance(CopyArray[counter].address,ThisBlock.ToString+':'+CopyArray[counter].Balance.ToString+':'+'OwnPayment');
      end;
   end;
if PayingAddresses>0 then
   begin
   ToLog(Format(' Paying to %d addresses : %s',[PayingAddresses,Int2Curr(TotalToPay)]));
   //SetPayThreads(PayingAddresses, Trim(AddressList));
   CheckPaysThreads := true;
   end
else
   begin
   SaveMiners();
   GenerateReport(uToFile);
   //UpdatePoolBalance;
   end;
if TotalProject >0 then
   ToLog(Format(',Expired to Pool pot : %s',[Int2Curr(TotalProject)]));
End;

Procedure RunVerification();
var
  ThisAddress     : string;
  Counter         : integer = 0;
  PayingAddresses : integer = 0;
  ThisThread      : ThreadPayment;
  AddressList     : string = '';
Begin
Repeat
   ThisAddress := Parameter(PendingAddresses,counter);
   If ThisAddress <> '' then
      begin
      Inc(PayingAddresses);
      AddressList := AddressList+' '+ThisAddress;
      ThisThread := ThreadPayment.create(true,Thisaddress);
      ThisThread.FreeOnTerminate:=true;
      ThisThread.Start;
      end;
   Inc(Counter);
until ThisAddress = '';
if PayingAddresses>0 then
   begin
   ToLog(Format(' Verifying %d payments',[PayingAddresses]));
   SetPayThreads(PayingAddresses, Trim(AddressList),false);
   CheckPaysThreads := true;
   end
End;

Procedure GenerateReport(destination:integer);
var
  CopyArray, finalArray : Array of TMinersDataNew ;
  counter, counter2   : integer;
  Inserted : boolean;
  ReportFile : TextFile;
  BalanceTotal : int64 = 0;
  SharesTotal  : int64 = 0;
  AddText,BalanText, sharestext, ToPayText : string;
  PoolProfit : int64 = 0;
  PoolDebt   : int64 = 0;
  ThisThread : ThreadPayment;
Begin
SetLength(CopyArray,0);
SetLength(finalArray,0);
EnterCriticalSection(CS_Miners);
CopyArray := copy(ArrMinersNew,0,length(ArrMinersNew));
LeaveCriticalSection(CS_Miners);
for counter := 0 to length(CopyArray)-1 do
   begin
   if ( (CopyArray[counter].Balance>0) or (CopyArray[counter].Shares>0) ) then
      begin
      BalanceTotal := BalanceTotal+ CopyArray[counter].Balance;
      SharesTotal  := SharesTotal + CopyArray[counter].Shares;
      Inserted := false;
      for counter2 := 0 to length(finalArray)-1 do
         begin
         if CopyArray[counter].Balance>FinalArray[counter2].Balance then
            begin
            insert(CopyArray[counter],FinalArray,counter2);
            Inserted := true;
            break;
            end;
         end;
      if not inserted then Insert(CopyArray[counter],FinalArray,Length(FinalArray));
      end;
   end;
if Destination = uToFile then
   begin
   AssignFile(ReportFile,'report.txt');
   Rewrite(ReportFile);
   writeln(ReportFile,'Block : '+GetMAinConsensus.block.ToString());
   writeln(ReportFile,'Miners: '+Length(FinalArray).ToString());
   WriteLn(ReportFile,'Debt  : '+Int2Curr(BalanceTotal));
   WriteLn(ReportFile,'Shares: '+SharesTotal.ToString);
   Writeln(ReportFile,'');
   for counter2 := 0 to length(finalArray)-1 do
      begin
      AddText   := format('%0:-35s',[FinalArray[counter2].address]);
      BalanText := Format('%0:12s',[Int2Curr(FinalArray[counter2].balance)]);
      sharestext:= Format('%0:5s',[FinalArray[counter2].Shares.ToString]);
      writeln(ReportFile,format('%s %s %s',[AddText,BalanText,sharestext]));
      end;
   CloseFile(ReportFile);
   PoolDebt := (BalanceTotal + Global_PendingToCredit);
   PoolProfit := GetAddressBalanceFromSumary(PoolAddress)-TotalPAid-PoolDebt;
   if ( (GetMainConsensus.block mod ProfitInterval = 0) and
        (IsValidHashAddress(ProfitAddress)) and
        (PoolProfit > onenoso) ) then
      begin
      Global_PoolProfit := PoolProfit;
      ThisThread := ThreadPayment.create(true,ProfitAddress);
      ThisThread.FreeOnTerminate:=true;
      ThisThread.Start;
      end;
   ToLog(format('/Report file Generated Block %d [Pool profit: %s ]',[GetMainConsensus.block,Int2Curr(PoolProfit)]));
   end
else if Destination = uToConsole then
   Begin
   ToLog(',Report',uToConsole);
   ToLog(' Block : '+GetMAinConsensus.block.ToString(),uToConsole);
   ToLog(' Miners: '+Length(FinalArray).ToString(),uToConsole);
   ToLog(' Debt  : '+Int2Curr(BalanceTotal),uToConsole);
   ToLog(' Shares: '+SharesTotal.ToString,uToConsole);
   AddText   := format('%0:-35s',['Address']);
   BalanText := Format('%0:12s',['Balance  ']);
   sharestext:= Format('%0:6s',['Shares']);
   ToPayText := Format('%0:6s',['To pay']);
   ToLog('/----------------------------------------------------------------------',uToConsole);
   ToLog(format('/%s | %s | %s | %s |',[AddText,BalanText,sharestext, ToPayText]),uToConsole);
   ToLog('/----------------------------------------------------------------------',uToConsole);
   for counter2 := 0 to length(finalArray)-1 do
      begin
      AddText   := format('%0:-35s',[FinalArray[counter2].address]);
      BalanText := Format('%0:12s',[Int2Curr(FinalArray[counter2].balance)]);
      sharestext:= Format('%0:6s',[FinalArray[counter2].Shares.ToString]);
      ToPayText := Format('%0:6d',[FinalArray[counter2].LastPay+poolpay-GetMainConsensus.block]);
      ToLog(format(' %s | %s | %s | %s |',[AddText,BalanText,sharestext, ToPayText]),uToConsole);
      end;
   ToLog('/----------------------------------------------------------------------',uToConsole);
   end;
End;

Procedure CounterReport(Linea:String;Destination:integer);
var
  counter, count2 : integer;
  copyArray,FinalArray : array of TCOunter;
  MinerApp, thisCounter, ThisinBlock  : String;
  ReportTitle, dataname : string;
  TotalRecords : integer = 0;
  Added : boolean;
  ReportType : string = '';
  NumberRecords : integer = 0;
  SubString  : string;
Begin
ReportType := Parameter(Linea,1);
if Pos(' -n:',linea) > 0 then
   begin
   substring := copy(linea,Pos(' -n:',linea)+4,length(linea));
   NumberRecords := StrToIntDef(Parameter(substring,0),0);
   end
else if Pos(' -r',linea) > 0 then
   begin
   if Uppercase(ReportType) = 'MINERS' then ClearUserMinerArray
   else if Uppercase(ReportType) = 'IPS' then ClearUserAddressArray
   else if Uppercase(ReportType) = 'SHAREIP' then ClearShareIPArray
   else if Uppercase(ReportType) = 'WRONGMINER' then ClearWrongShareMiner
   else if Uppercase(ReportType) = 'WRONGIP' then ClearWrongShareIp
   else ToLog('.Unknown report type: '+ReportType,uToConsole);
   exit;
   end;
if Uppercase(ReportType) = 'MINERS' then
   begin
   ReportTitle := 'Miners Report';
   Dataname    := 'MinerApp';
   SetLength(CopyArray,0);
   EnterCriticalSection(CS_USerMiner);
   CopyArray := Copy(UserMiner,0,length(UserMiner));
   LeaveCriticalSection(CS_USerMiner);
   end
else if Uppercase(ReportType) = 'IPS' then
   begin
   ReportTitle := 'Users Address Report';
   Dataname    := 'IP';
   SetLength(CopyArray,0);
   EnterCriticalSection(CS_UserIPArr);
   CopyArray := Copy(UserIPArr,0,length(UserIPArr));
   LeaveCriticalSection(CS_UserIPArr);
   end
else if Uppercase(ReportType) = 'SHAREIP' then
   begin
   ReportTitle := 'Shares IP Report';
   Dataname    := 'IP';
   SetLength(CopyArray,0);
   EnterCriticalSection(CS_ShareIPArr);
   CopyArray := Copy(ShareIPArr,0,length(ShareIPArr));
   LeaveCriticalSection(CS_ShareIPArr);
   end
else if Uppercase(ReportType) = 'WRONGMINER' then
   begin
   ReportTitle := 'Wrong Shares Miner Report';
   Dataname    := 'MinerApp';
   SetLength(CopyArray,0);
   EnterCriticalSection(CS_WrongShareMiner);
   CopyArray := Copy(WrongShareMiner,0,length(WrongShareMiner));
   LeaveCriticalSection(CS_WrongShareMiner);
   end
else if Uppercase(ReportType) = 'WRONGIP' then
   begin
   ReportTitle := 'Wrong Shares IP Report';
   Dataname    := 'User IP';
   SetLength(CopyArray,0);
   EnterCriticalSection(CS_WrongShareIp);
   CopyArray := Copy(WrongShareIp,0,length(WrongShareIp));
   LeaveCriticalSection(CS_WrongShareIp);
   end
else
   begin
   ToLog('.Unknown report type: '+ReportType,uToConsole);
   exit;
   end;
SetLength(FinalArray,0);
for counter := 0 to length(CopyArray)-1 do
   begin
   Added := false;
   for count2 := 0 to length(FinalArray)-1 do
      begin
      if CopyArray[counter].counter>FinalArray[count2].counter then
         begin
         Insert(CopyArray[counter],FinalArray,count2);
         Added := true;
         break;
         end;
      end;
   if not Added then Insert(CopyArray[counter],FinalArray,Length(FinalArray));
   end;

if Destination = uToConsole then
   begin
   if ( (NumberRecords=0) or (numberRecords>length(FinalArray)) ) then
      NumberRecords := length(FinalArray);
   ToLog(','+ReportTitle,uToConsole);
   ToLog('/--------------------------------------',uToConsole);
   MinerApp := Format('%0:-20s',[Dataname]);
   thisCounter := Format('%0:-5s',['Total']);
   thisinBlock := Format('%0:-5s',['Block']);
   ToLog(Format('/%s | %s | %s |',[MinerApp,ThisCounter, ThisinBlock]),uToConsole);
   ToLog('/--------------------------------------',uToConsole);
   for counter := 0 to NumberRecords-1 do
      begin
      MinerApp := Format('%0:-20s',[FinalArray[counter].data]);
      thisCounter := Format('%0:5s',[FinalArray[counter].counter.ToString]);
      thisinBlock := Format('%0:5s',[FinalArray[counter].inBlock.ToString]);
      ToLog(Format(' %s | %s | %s |',[MinerApp,ThisCounter,ThisInBlock]),uToConsole);
      Inc(TotalRecords);
      end;
   if TotalRecords= 0 then ToLog('.No records found',uToConsole);
   ToLog('/--------------------------------------',uToConsole);
   end;

End;

Procedure BuildNewBlock();
var
  BlockFile  : TextFile;
  Number     : integer;
  Distribute : string;
  BlockSpeed, TotalShares : int64;
Begin
Number := GetMainConsensus.block;
TotalShares := SharesCount;
AssignFile(BlockFile,'blocks'+DirectorySeparator+Number.ToString+'.txt');
TRY
   Rewrite(BlockFile);
   Writeln(BlockFile,Format('Block      : %s',[number.ToString]));
   WriteLn(Blockfile,format('Miner      : %s',[GetMainConsensus.LBMiner]));
   WriteLn(Blockfile,format('SolDiff    : %s',[GetMainConsensus.LBSolDiff]));
   WriteLn(Blockfile,format('PoW        : %s',[Int2Curr(GetMainConsensus.LBPoW)]));
   WriteLn(Blockfile,format('Miners     : %d',[MinersCount]));
   WriteLn(Blockfile,format('Shares     : %d',[TotalShares]));
   BlockSpeed := (SharesCount*SESSION_HashPerShare) div 575;
   SetLastBlockRate(BlockSpeed);
   WriteLn(Blockfile,format('Speed      : %d h/s',[BlockSpeed]));
   WriteLn(Blockfile,format('Best       : %s',[GetBlockBest]));
   WriteLn(Blockfile,format('BestMiner  : %s',[GetBlockBestAddress]));
   if GetMainConsensus.LBMiner = PoolAddress then
      begin
      Distribute := DistributeBlockPayment();
      WriteLn(Blockfile,format('PaidShares : %s',[Int2Curr(StrToIntDef(Parameter(Distribute,2),0))]));
      WriteLn(Blockfile,format('PerShare   : %s',[Int2Curr(StrToIntDef(Parameter(Distribute,0),0))]));
      WriteLn(Blockfile,format('Earned     : %s',[Int2Curr(StrToIntDef(Parameter(Distribute,1),0))]));
      WriteLn(Blockfile,format('Donated    : %s',[Int2Curr(StrToIntDef(Parameter(Distribute,3),0))]));
      ToLog(' ********************');
      ToLog('.Block mined: '+number.ToString);
      ToLog(' ********************');
      end;
   CloseFile(BlockFile);
   ToLog(Format(' Created block : %s [Debt: %s]',[number.ToString,Int2Curr(GetTotalDebt)]))
EXCEPT ON E:Exception do
END; {TRY}
SaveMiners();
//UpdatePoolBalance;
Insert(GetDiffHashrate(GetMainConsensus.LBSolDiff),ArraySols,length(ArraySols));
Delete(ArraySols,0,1);
CalculateMainNetHashrate;
Insert(GetMainConsensus.LBMiner,ArrayMiner,length(ArrayMiner));
ThisBlockMNs := false;
Delete(ArrayMiner,0,1);
GetBlocksMinedByPool;
End;

Procedure ResetBlock();
var
  BlockDataNew : TBlockRec;
Begin
GetPoolPotBalance;
MainBestDiff := DefWorst;
if GetMainConsensus.block > GetMyLastUpdatedBlock then
   begin
   BuildNewBlock();
   end;
EnterCriticalSection(CS_Shares);
SetLength(ArrShares,0);
LeaveCriticalSection(CS_Shares);
SaveAMIToFile(GetMainConsensus.block);
ClearAmi();
ResetPrefixIndex();
SetBlockBest(DefWorst,'');
SetSolution(Default(TSolution));
SESSION_Shares := 0;
SESSION_Started := UTCTime;
RejectedShares := 0;
if StoreShares then SaveShareIndex;
ClearUserMinerArray(False);
ClearUserAddressArray(False);
ClearShareIPArray(False);
ClearWrongShareMiner(False);
ClearWrongShareIP(False);
GetSumary;
UnZipSumary();
LoadSumary;
SetPoolBalance(GetAddressBalanceFromSumary(PoolAddress));
GetTorNodesFile();
GetTorExitNodesFile();
LoadTorNodes();
TorCOunt := 0;
VPNCount := 0;
CCBlocked := 0;
ResetTorAllowed;
ResetTorBlocked;
//{if GetMainConsensus.block mod 6 = 0 then }RunVPNsThread;
BlockDataNew := Default(TBlockRec);
BlockDataNew.blocknumber:=GetMainConsensus.block;
BlockDataNEw.Mined:=GetMainConsensus.LBMiner = PoolAddress;
if GetMainConsensus.LBMiner = PoolAddress then BlockDataNEw.PoWIncome:= GetMainConsensus.LBPoW
else BlockDataNEw.PoWIncome := 0;
BlockDataNEw.Paid:=false;
BlockDataNEw.Bounty:=GetArrayBlocksLast.Bounty;
BlockDataNEw.TotalPaid:=0;
UpdateArrayBlocks(BlockDataNew);
OutputSourcesToFile(GetMainConsensus.LBMiner = PoolAddress);
SaveSourcesToDisk;
ToLog(',Sources output completed');
//ProcessNewVPNs(GetVPNBanList);
//RunVPNClean(GetMainConsensus.block);
//SaveVPNFile;
ThisBlockDUPS := false;
End;

Procedure RunVPNsThread;
var
  ThisThread : ThreadVPNs;
Begin
ThisThread := ThreadVPNs.create(true);
ThisThread.FreeOnTerminate:=true;
ThisThread.Start;
Sleep(20);
End;

Function GetPrefixIndex():Integer;
Begin
EnterCriticalSection(CS_PrefixIndex);
Inc(BlockPrefixesRequested);
Result := PrefixIndex;
Inc(PrefixIndex);
LeaveCriticalSection(CS_PrefixIndex);
End;

Procedure ResetPrefixIndex();
Begin
EnterCriticalSection(CS_PrefixIndex);
PrefixIndex := 0;
BlockPrefixesRequested := 0;
LeaveCriticalSection(CS_PrefixIndex);
End;

function GetPrefixStr(IndexValue:integer = -1):string;
var
  Index, firstchar, secondchar, ThirdChar : integer;
  HashChars : integer;
Begin
if IndexValue = -1 then Index := GetPrefixIndex()
else Index := IndexValue;
HashChars := length(HasheableChars)-1;
firstchar := Index div (HashChars*HashChars);
Index     := Index mod (HashChars*HashChars);
secondchar:= Index div HashChars;
ThirdChar := Index mod HashChars;
result := HasheableChars[firstchar+1]+HasheableChars[secondchar+1]+HasheableChars[ThirdChar+1];
End;

function CheckIPMiners(UserIP:String):Boolean;
Begin
result := true;
End;

Function GetIpFiltered(LIP:String):String;
Begin
LIP :=  StringReplace(LIP,'.',' ',[rfReplaceAll, rfIgnoreCase]);
Result := Format('%s.%s.%s',[parameter(LIP,0),parameter(LIP,1),parameter(LIP,2)]);
End;

// Try to send a message safely
Function TryMessageToMiner(AContext: TIdContext;message:string):boolean;
Begin
result := true;
TRY
Acontext.Connection.IOHandler.WriteLn(message);
EXCEPT on E:Exception do
   begin
   ToLog(' Error sending message to miner: '+E.Message,uToFile);
   end;
END;{Try}
End;

// Try to close a pool connection safely
Procedure TryClosePoolConnection(AContext: TIdContext; closemsg:string='');
Begin
if closemsg <>'' then
   begin
   TryMessageToMiner(AContext,closemsg);
   end;
TRY
Acontext.Connection.IOHandler.InputBuffer.Clear;
AContext.Connection.Disconnect;
AContext.Connection.IOHandler.DiscardAll(); // ?? is valid
EXCEPT on E:Exception do
   ToLog(' Error closing miner conneciton: '+E.Message,uToFile);
END;{Try}
End;

Class Procedure PoolServerEvents.OnExecute(AContext: TIdContext);
Begin
// Probably unnecessary
End;

Class Procedure PoolServerEvents.OnConnect(AContext: TIdContext);
var
  IPUser, Linea    : String;
  RawIP            : STring;
  Command, Address, ThisShare : String;
  ValidShareValue : integer;
  MinerData       : string;
    MinBal : int64;
    MinTill: integer;
    MinPay : string;
  MinerDevice     : string = '';
  IpShares        : integer;
  CreditAddress   : string;
Begin
//*******************
// IMPLEMENT TIME FILTER WITH BLOCKAGE
RawIP := AContext.Connection.Socket.Binding.PeerIP;
IPUser := GetIpFiltered(RawIP);
Linea := '';
if VPNIPExists(IPUSer) then
   begin
   TryClosePoolConnection(AContext);
   Inc(VPNCOunt);
   end;
TRY
Linea := AContext.Connection.IOHandler.ReadLn('',3000,-1,IndyTextEncoding_UTF8);
EXCEPT On E:Exception do
   begin
   TRY
   AContext.Connection.Disconnect;
   EXCEPT On E:Exception do
      begin
      TryClosePoolConnection(AContext);
      exit;
      end
   END{Try};
   end;
END{Try};
Command := Parameter(Linea,0);
Address := Parameter(Linea,1);
TRY
If UpperCase(Command) = 'SOURCE' then
   begin
   AddUserMiner(Parameter(Linea,2));
   //AddNewRecord(Address,Parameter(Linea,3),RawIP,GetMainConsensus.block);
   //AddUserIP(IPUser);
   if ( (not IsValidHashAddress(Address)) or (address = '') ) then
      begin
      TryClosePoolConnection(AContext,'WRONG_ADDRESS');
      exit;
      end;
   if CheckIPMiners(IPUser) then
      begin
      MinerData := GetMinerData(Address);
      MinBal := StrToInt64Def(Parameter(MinerData,0),0);
      MinTill:= StrToIntDef(Parameter(MinerData,1),0);
      MinPay := Parameter(MinerData,2);
      // 1{MinerPrefix} 2{MinerAddress} 3{PoolMinDiff} 4{LBHash} 5{LBNumber} 6{MinerBalance}
      // 7{TillPayment} 8{LastPayInfo} 9{LastBlockPoolHashrate} {10}MainnetHashRate
      //{11}PoolFee 12{PoolUTCTime}

      TryClosePoolConnection(AContext,'OK '+{1}GetPrefixStr+' '+
                                            {2}PoolAddress+' '+
                                            {3}MinerDiff+' '+
                                            {4}GetMainConsensus.LBHash+' '+
                                            {5}GetMainConsensus.block.ToString+' '+
                                            {6}MinBal.ToString+' '+
                                            {7}MinTill.ToString+' '+
                                            {8}MinPay+' '+
                                            {9}GetLastBlockRate.ToString+' '+
                                            {10}MainnetHashRate.ToString+' '+
                                            {11}PoolFee.ToString+' '+
                                            {12}UTCTime.ToString+' '+
                                            {13}minerscount.ToString+' '+
                                            {14}PoolFee.ToString+' '+
                                            {15}GetAddressBalanceFromSumary(Address).ToString+' '+
                                            {16}MaxSharesPerBlock.ToString);
      end;
   end
else If UpperCase(Command) = 'SHARE' then
   //{1}Addess {2}Share {3}Miner
   begin
   If AnsiContainsStr(DefaultCClasses,IPUser) then
      begin
      TryClosePoolConnection(AContext,'False UNEXPECTED_PLEASE_REPORT');
      Inc(CCBlocked);
      exit;
      end;
   if EnoughSharesByIp(IPUser) then
      begin
      TryClosePoolConnection(AContext,'False SHARES_LIMIT');
      exit;
      end;
   if EnoughSharesByAddress(Address) then
      begin
      TryClosePoolConnection(AContext,'False SHARES_LIMIT');
      exit;
      end;
   ThisShare   := Parameter(Linea,2);
   MinerDevice := Parameter(Linea,3);
   CreditAddress := Parameter(Linea,6);
   If not IsValidHashAddress(CreditAddress) then CreditAddress := Address;
   ValidShareValue := ShareIsValid(ThisShare,Address,MinerDevice, IPUser, CreditAddress,RawIP);
   if ValidShareValue=0 then
      begin
      AddToAmi(Address,AContext.Connection.Socket.Binding.PeerIP);
      TryClosePoolConnection(AContext,'True');
      end
   else if ValidShareValue>0 then
      begin
      TryClosePoolConnection(AContext,'False '+ValidShareValue.ToString)
      end
   else TryClosePoolConnection(AContext)
   end
else If UpperCase(Command) = 'POOLINFO' then
   begin
   TryClosePoolConnection(AContext,minerscount.ToString+' '+GetLastBlockRate.ToString+' '+PoolFee.ToString+' '+MainNetHashRate.ToString);
   end
else If UpperCase(Command) = 'POOLPUBLIC' then
   begin
   TryClosePoolConnection(AContext,AppVersion+' '+IPsCount.ToString+' '+MaxSharesPerBlock.ToString+' '+PoolPay.ToString+' '+IPUser)
   end
else If UpperCase(Command) = 'POOLAMI' then
   begin
   if  Parameter(Linea,1) <> AMIPass then TryClosePoolConnection(AContext,'Invalid password')
   else
      begin
      if StrToIntDef(Parameter(Linea,2),-1)<0 then TryClosePoolConnection(AContext,GetAMIString)
      else TryClosePoolConnection(AContext,GetAMIBlockData(StrToIntDef(Parameter(Linea,2),-1)))
      end
   end
else
   begin
   TryClosePoolConnection(AContext,'Unknown :'+Linea);
   end;
EXCEPT ON E:EXCEPTION DO
  begin
  TryClosePoolConnection(AContext,'false ERROR_5001');
  ToLog('.ERROR 5001: '+E.Message);
  end;
END;
End;

Procedure SendSolution(Data:TSolution);
var
  TCPClient        : TidTCPClient;
  Node             : integer;
  Resultado        : string;
  Trys             : integer = 0;
  Success, WasGood : boolean;
  Mainnetbest      : string;
  ErrorCode        : String;
  SigNature        : string;
  SolTime          : string;
Begin
Soltime := UTCTime.ToString;
Signature := GetStringSigned(PoolAddress+GetSolution.Hash+SolTime,PrivateKey);
Node := Random(LengthNodes);
TCPClient := TidTCPClient.Create(nil);
TCPclient.ConnectTimeout:= 3000;
TCPclient.ReadTimeout:=3000;
REPEAT
   Node := Node+1; If Node >= LengthNodes then Node := 0;
   TCPclient.Host:=GetNodeIndex(Node).host;
   TCPclient.Port:=GetNodeIndex(Node).port;
   Success := false;
   TRY
   TCPclient.Connect;
   TCPclient.IOHandler.WriteLn('BESTHASH 1 2 3 4 '+PoolAddress+' '+GetSolution.Hash+' '+IntToStr(GetMainConsensus.block+1)+' '+
                               SolTime+' '+PublicKey+' '+SigNature);
   Resultado := TCPclient.IOHandler.ReadLn(IndyTextEncoding_UTF8);
   TCPclient.Disconnect();
   Success := true;
   EXCEPT on E:Exception do
      begin
      Success := false;
      end;
   END{try};
   Inc(Trys);
UNTIL ((Success) or (Trys = 5));
TCPClient.Free;
If success then
   begin
   WasGood := StrToBoolDef(Parameter(Resultado,0),false);
   ErrorCode := Parameter(Resultado,2);
   Mainnetbest := Parameter(Resultado,1);
   MainBestDiff := Mainnetbest;
   if WasGood then
      begin
      ToLog(',Besthash submited: '+BestHashReadeable(Data.Diff),uToFile);
      Inc(SESSION_BestHashes);
      end;
   end
else
   begin
   ToLog(' Unable to send solution',uToFile);
   SetSolution(GetSolution);
   end;
End;

Procedure SetPayThreads(Tvalue:integer;AddressList:string; ResetTotalPaid:Boolean = true);
Begin
EnterCriticalSection(CS_PayThreads);
OpenPayThreads := TValue;
GoodPayments := 0;
BadPayments  := 0;
if ResetTotalPaid then
   TotalPaid := 0;
PendingAddresses := AddressList;
LeaveCriticalSection(CS_PayThreads);
End;

Function GetPayThreads():integer;
Begin
EnterCriticalSection(CS_PayThreads);
Result := OpenPayThreads;
LeaveCriticalSection(CS_PayThreads);
End;

Procedure IncreasePayThread(Address:String;Amount:int64);
Begin
EnterCriticalSection(CS_PayThreads);
OpenPayThreads := OpenPayThreads+1;
PendingAddresses := PendingAddresses+' '+address;
PendingAddresses := Trim(PendingAddresses);
LeaveCriticalSection(CS_PayThreads);
End;

Procedure DecreasePayThreads(WasGood:boolean;Amount:int64;Address:String='');
Begin
EnterCriticalSection(CS_PayThreads);
OpenPayThreads := OpenPayThreads-1;
if wasGood then Inc(GoodPayments)
else Inc(BadPayments);
if WasGood then
   begin
   Inc(TotalPaid,Amount);
   end;
if Address <> '' then
   begin
   PendingAddresses := StringReplace(PendingAddresses,Address,'',[rfReplaceAll, rfIgnoreCase]);
   PendingAddresses := DelSpace1(PendingAddresses);
   PendingAddresses := Trim(PendingAddresses);
   end;
LeaveCriticalSection(CS_PayThreads);
End;

{$REGION Pool balance}

Procedure SetPoolBalance(ThisValue:int64);
Begin
EnterCriticalSection(CS_PoolBalance);
PoolBalance := ThisValue;
RefreshPoolBalance := true;
LeaveCriticalSection(CS_PoolBalance);
End;

Function GetPoolBalance():Int64;
Begin
EnterCriticalSection(CS_PoolBalance);
Result := PoolBalance;
LeaveCriticalSection(CS_PoolBalance);
End;

Procedure IncreasePoolPot(amount:string);
var
  IntAmount : int64;
Begin
IntAmount := StrToInt64def(amount,0);
if IntAmount > 0 then
   begin
   IntAmount := IntAmount * onenoso;
   AddPoolPotBalance(IntAmount);
   ToLog('.Added to pool pool: '+Int2curr(Intamount));
   SaveMiners();
   end;
End;

{$ENDREGION}

Procedure SetLastBlockRate(ThisValue:int64);
Begin
EnterCriticalSection(CS_LastBlockRate);
LastBlockRate := ThisValue;
LeaveCriticalSection(CS_LastBlockRate);
End;

Function GetLastBlockRate():Int64;
Begin
EnterCriticalSection(CS_LastBlockRate);
Result := LastBlockRate;
LeaveCriticalSection(CS_LastBlockRate);
End;

Procedure SaveShareIndex();
var
  ThisFile : File of integer;
  counter : integer;
Begin
Assignfile(ThisFile, 'frequency.dat');
TRY
Rewrite(ThisFile);
for counter := 0 to 15 do
   begin
   Seek(ThisFile,counter);
   Write(ThisFile,ShareIndex[counter]);
   end;
CloseFile(ThisFile);
EXCEPT ON E:EXCEPTION DO
   ToLog(' Error saving share index: '+E.Message);
END;{TRY}
if StoreShares then ShareIndexReport;
End;

Procedure LoadShareIndex();
var
  ThisFile : File of integer;
  counter : integer;
Begin
Assignfile(ThisFile, 'frequency.dat');
TRY
reset(ThisFile);
for counter := 0 to 15 do
   begin
   Seek(ThisFile,counter);
   Read(ThisFile,ShareIndex[counter]);
   end;
CloseFile(ThisFile);
EXCEPT ON E:EXCEPTION DO
   ToLog(' Error loading share index: '+E.Message);
END;{TRY}
End;

Procedure CreditFrequency(Diff : string);
var
  DiffLen  : integer;
  ThisChar : String;
  ThisValue : integer;
Begin
TRY
DiffLen := Length(MinDiffBase)+1;
ThisChar := Diff[Difflen];
ThisValue := Hex2Dec(ThisChar);
Inc(ShareIndex[ThisValue]);
EXCEPT ON E:EXCEPTION DO
   ToLog(' Error crediting frequency: '+E.Message);
END;{TRY}
End;

Procedure ShareIndexReport();
var
  counter  : integer;
  ThisFile : textfile;
  text1, text2, text3 : string;
  TotalShares : integer = 0;
Begin
TRY
Assignfile(ThisFile, 'sharereport.txt');
for counter := 1 to 15 do
   TotalShares := TotalShares+shareindex[counter];
rewrite(ThisFile);
writeln(ThisFile,format('TotalShares: %d',[TotalShares]));
for counter := 1 to 15 do
   begin
   Text1 := Uppercase(IntToHex(counter,1));
   Text2 := Format('%0:5d',[shareindex[counter]]);
   Text3 := formatFloat('0.00',(shareindex[counter]*100)/totalshares)+'%';
   Text3 := Format('%0:6s',[Text3]);
   writeln(ThisFile,format('%s %s %s',[text1,text2,text3]));
   end;
CloseFile(ThisFile);
ToLog(' Share index report created');
EXCEPT ON E:EXCEPTION do
   ToLog(' Error saving sharereport.txt: '+E.message);
END;{TRY}
End;

Function GetBlockValue(Block:integer;valuename:string):string;
var
  ThisFile : Textfile;
  FileName : string;
  Texto    : string;
Begin
Result := '';
FileName := 'blocks'+DirectorySeparator+Block.ToString+'.txt';
If fileExists(FileName) then
   begin
   AssignFile(ThisFile,Filename);
   TRY
   Reset(ThisFile);
   while not Eof(thisfile) do
      begin
      Readln(ThisFile,Texto);
      Texto := DelSpace1(Texto);
      if Uppercase(Parameter(texto,0)) = UpperCase(Valuename) then
         begin
         result := Parameter(texto,2);
         break;
         end;
      end;
   CloseFile(ThisFile);
   EXCEPT ON E:EXCEPTION do
      ToLog(' Error getting block value: '+E.Message);
   END;{TRY}
   end
else
   begin

   end;
End;

Procedure FillSolsArray();
var
  counter        : integer;
  ThisBlockDiff  : string;
  Thisblockminer : string;
  ThisBlockValue : integer;
  LastBlock  : integer;
Begin
SetLength(ArraySols,0);
SetLEngth(ArrayMiner,0);
LastBlock := GetMyLastUpdatedBlock;
for counter := LastBlock-143 to LastBlock do
   begin
   ThisBlockDiff := GetBlockValue(counter,'SolDiff');
   if thisblockDiff = '' then thisblockDiff := DefWorst;
   ThisBlockValue := GetDiffHashrate(thisblockDiff);
   Insert(ThisBlockValue,ArraySols,length(ArraySols));
   Thisblockminer := GetBlockValue(counter,'Miner');
   Insert(Thisblockminer,ArrayMiner,length(ArrayMiner));
   end;
CalculateMainNetHashrate;
GetBlocksMinedByPool();
End;

Procedure CalculateMainNetHashrate();
var
  counter        : integer;
  TotalValue     : integer = 0;
  TotalRate : double = 0;
Begin
for counter := 0 to length(ArraySols)-1 do
   TotalValue := TotalValue+ArraySols[counter];

TotalRate := (TotalValue/100)/length(ArraySols);

TotalRate := Power(16,TotalRate);
TotalRate := TotalRate/(575);
MainnetHashRate := Round(TotalRate);
End;

Procedure GetBlocksMinedByPool();
var
  mined : integer = 0;
  counter : integer;
Begin
for counter := 0 to length(ArrayMiner)-1 do
   if ArrayMiner[counter] = PoolAddress then Inc(Mined);
BlocksMinedByPool := mined;
End;

// ********
// Counters
// ********

Procedure AddUserMiner(Minerv:String);
var
  counter : integer;
  Added : boolean = false;
Begin
if minerv = '' then Minerv := 'Unknown';
EnterCriticalSection(CS_USerMiner);
For counter := 0 to length(UserMiner)-1 do
   begin
   if userminer[counter].data=Minerv then
      begin
      added := true;
      Inc(UserMiner[counter].counter);
      Inc(UserMiner[counter].inblock);
      break;
      end;
   end;
if not added then
   begin
   SetLEngth(Userminer,LEngth(UserMiner)+1);
   Userminer[length(userminer)-1].data:=minerv;
   Userminer[length(userminer)-1].counter:=1;
   Userminer[length(userminer)-1].inBlock:=1;
   end;
LEaveCriticalSection(CS_USerMiner);
End;

Procedure ClearUserMinerArray(ClearAll:boolean = true);
var
  counter:integer;
Begin
if ClearAll then
   begin
   EnterCriticalSection(CS_USerMiner);
   SetLEngth(UserMiner,0);
   LeaveCriticalSection(CS_USerMiner);
   end
else
   begin
   EnterCriticalSection(CS_USerMiner);
   For counter := 0 to length(USerMiner)-1 do
      USerMiner[counter].inblock:=0;
   LeaveCriticalSection(CS_USerMiner);
   end;
End;

Function IPsCOunt():Integer;
Begin
EnterCriticalSection(CS_ShareIPArr);
result :=  length(ShareIPArr);
LeaveCriticalSection(CS_ShareIPArr);
End;

Function EnoughSharesByIp(LIP:String):Boolean;
var
  counter : integer;
Begin
result := false;
EnterCriticalSection(CS_ShareIPArr);
For counter := 0 to length(ShareIPArr)-1 do
   begin
   if ShareIPArr[counter].data=LIP then
      begin
      If ShareIPArr[counter].inblock >= MaxSharesPerBlock then
         begin
         Result := true;
         break;
         end;
      end;
   end;
LeaveCriticalSection(CS_ShareIPArr);
End;

Function EnoughSharesByAddress(UserAddress:String):Boolean;
var
  counter : integer;
Begin
result := false;
EnterCriticalSection(CS_UserIPArr);
For counter := 0 to length(UserIPArr)-1 do
   begin
   if UserIPArr[counter].data=UserAddress then
      begin
      If UserIPArr[counter].inblock >= MaxSharesPerBlock then
         begin
         Result := true;
         break;
         end;
      end;
   end;
LeaveCriticalSection(CS_UserIPArr);
End;

Procedure AddUserAddress(userAddress:string);
var
  counter : integer;
  Added : boolean = false;
Begin
if userAddress = '' then userAddress := 'Unknown';
EnterCriticalSection(CS_UserIPArr);
For counter := 0 to length(UserIPArr)-1 do
   begin
   if UserIPArr[counter].data=userAddress then
      begin
      added := true;
      Inc(UserIPArr[counter].counter);
      Inc(UserIPArr[counter].inblock);
      break;
      end;
   end;
if not added then
   begin
   SetLEngth(UserIPArr,LEngth(UserIPArr)+1);
   UserIPArr[length(UserIPArr)-1].data:=userAddress;
   UserIPArr[length(UserIPArr)-1].counter:=1;
   UserIPArr[length(UserIPArr)-1].inBlock:=1;
   end;
LEaveCriticalSection(CS_UserIPArr);
End;

Procedure ClearUserAddressArray(ClearAll:boolean = true);
var
  counter:integer;
Begin
if ClearAll then
   begin
   EnterCriticalSection(CS_UserIPArr);
   SetLEngth(UserIPArr,0);
   LeaveCriticalSection(CS_UserIPArr);
   end
else
   begin
   EnterCriticalSection(CS_UserIPArr);
   For counter := 0 to length(UserIPArr)-1 do
      UserIPArr[counter].inblock:=0;
   LeaveCriticalSection(CS_UserIPArr);
   end;
End;

Procedure AddShareIP(userip:string);
var
  counter : integer;
  Added : boolean = false;
Begin
if userip = '' then userip := 'Unknown';
EnterCriticalSection(CS_ShareIPArr);
For counter := 0 to length(ShareIPArr)-1 do
   begin
   if ShareIPArr[counter].data=UserIP then
      begin
      added := true;
      Inc(ShareIPArr[counter].counter);
      Inc(ShareIPArr[counter].inblock);
      break;
      end;
   end;
if not added then
   begin
   SetLEngth(ShareIPArr,LEngth(ShareIPArr)+1);
   ShareIPArr[length(ShareIPArr)-1].data:=UserIP;
   ShareIPArr[length(ShareIPArr)-1].counter:=1;
   ShareIPArr[length(ShareIPArr)-1].inBlock:=1;
   end;
LeaveCriticalSection(CS_ShareIPArr);
End;

Procedure ClearShareIPArray(ClearAll:boolean = true);
var
  counter:integer;
Begin
if ClearAll then
   begin
   EnterCriticalSection(CS_ShareIPArr);
   SetLEngth(ShareIPArr,0);
   LeaveCriticalSection(CS_ShareIPArr);
   end
else
   begin
   EnterCriticalSection(CS_ShareIPArr);
   For counter := 0 to length(ShareIPArr)-1 do
      ShareIPArr[counter].inblock:=0;
   LeaveCriticalSection(CS_ShareIPArr);
   end;
End;

Procedure AddWrongShareMiner(userip:string);
var
  counter : integer;
  Added : boolean = false;
Begin
if userip = '' then userip := 'Unknown';
EnterCriticalSection(CS_WrongShareMiner);
For counter := 0 to length(WrongShareMiner)-1 do
   begin
   if WrongShareMiner[counter].data=UserIP then
      begin
      added := true;
      Inc(WrongShareMiner[counter].counter);
      Inc(WrongShareMiner[counter].inblock);
      break;
      end;
   end;
if not added then
   begin
   SetLEngth(WrongShareMiner,LEngth(WrongShareMiner)+1);
   WrongShareMiner[length(WrongShareMiner)-1].data:=UserIP;
   WrongShareMiner[length(WrongShareMiner)-1].counter:=1;
   WrongShareMiner[length(WrongShareMiner)-1].inBlock:=1;
   end;
LeaveCriticalSection(CS_WrongShareMiner);
End;

Procedure ClearWrongShareMiner(ClearAll:boolean = true);
var
  counter:integer;
Begin
if ClearAll then
   begin
   EnterCriticalSection(CS_WrongShareMiner);
   SetLEngth(WrongShareMiner,0);
   LeaveCriticalSection(CS_WrongShareMiner);
   end
else
   begin
   EnterCriticalSection(CS_WrongShareMiner);
   For counter := 0 to length(WrongShareMiner)-1 do
      WrongShareMiner[counter].inblock:=0;
   LeaveCriticalSection(CS_WrongShareMiner);
   end;
End;

Procedure AddWrongShareIp(ThisData:string);
var
  counter : integer;
  Added : boolean = false;
Begin
if ThisData = '' then ThisData := 'Unknown';
EnterCriticalSection(CS_WrongShareIp);
For counter := 0 to length(WrongShareIp)-1 do
   begin
   if WrongShareIp[counter].data=ThisData then
      begin
      added := true;
      Inc(WrongShareIp[counter].counter);
      Inc(WrongShareIp[counter].inblock);
      break;
      end;
   end;
if not added then
   begin
   SetLEngth(WrongShareIp,LEngth(WrongShareIp)+1);
   WrongShareIp[length(WrongShareIp)-1].data:=ThisData;
   WrongShareIp[length(WrongShareIp)-1].counter:=1;
   WrongShareIp[length(WrongShareIp)-1].inBlock:=1;
   end;
LeaveCriticalSection(CS_WrongShareIp);
End;

Procedure ClearWrongShareIp(ClearAll:boolean = true);
var
  counter:integer;
Begin
if ClearAll then
   begin
   EnterCriticalSection(CS_WrongShareIp);
   SetLEngth(WrongShareIp,0);
   LeaveCriticalSection(CS_WrongShareIp);
   end
else
   begin
   EnterCriticalSection(CS_WrongShareIp);
   For counter := 0 to length(WrongShareIp)-1 do
      WrongShareIp[counter].inblock:=0;
   LeaveCriticalSection(CS_WrongShareIp);
   end;
End;

{$REGION ami}

Procedure ClearAMI();
Begin
EnterCriticalSection(CS_ArrayMinersIPS);
TRY
SetLength(ARRAY_BAckUPAMI,0);
ARRAY_BAckUPAMI := copy(ARRAY_MinersIPs,0,length(ARRAY_MinersIPs));
SetLength(ARRAY_MinersIPs,0);
EXCEPT ON E:Exception do

END; {TRY}
LeaveCriticalSection(CS_ArrayMinersIPS);
End;

Function IncreaseOneMinersIP(LData:String):String;
var
  ThisIP : string;
  Count  : integer;
Begin
ThisIP := Parameter(LData,0);
Count   := StrToIntDef(Parameter(lData,1),1)+1;
Result := ThisIP + ' '+ Count.ToString;
End;

Procedure AddToAMI(Address,IP : string);
var
  counter, counter2 : integer;
  AddressF, IPF : Boolean;
  NewRecord     : TMinersIPs;
  ThisRecord    : TMinersIPs;
Begin
EnterCriticalSection(CS_ArrayMinersIPS);
TRY
AddressF := False; IPF := False;
for counter := 0 to length(ARRAY_MinersIPs)-1 do
   begin
   if ARRAY_MinersIPs[counter].Address = Address then
      begin
      ThisRecord := ARRAY_MinersIPs[counter];
      for counter2 := 0 to length(ThisRecord.ArrIPs)-1 do
         begin
         if Parameter(ThisRecord.ArrIPs[counter2],0) = IP then
            begin
            ThisRecord.ArrIPs[counter2] := IncreaseOneMinersIP(ThisRecord.ArrIPs[counter2]);
            IPF := True;
            //ToLog(' New recurrency to '+Address);
            ARRAY_MinersIPs[counter] := ThisRecord;
            Break;
            end;
         end;
      if not IPF then
         begin
         Insert(IP+' 1',ThisRecord.ArrIPs,length(ThisRecord.ArrIPs));
         ARRAY_MinersIPs[counter] := ThisRecord;
         end;
      AddressF := true;
      Break;
      end;
   end;
if not AddressF then
   begin
   NewRecord := Default(TMinersIPs);
   NewRecord.Address:=Address;
   SetLength(NewRecord.ArrIPs,0);
   insert(IP+' 1',NewRecord.ArrIPs,0);
   Insert(NewRecord,ARRAY_MinersIPs,length(ARRAY_MinersIPs));
   //ToLog(' New address: '+Address)
   end;
EXCEPT ON E:Exception do
   //ToLog('AMI ADD ERROR: '+e.Message );
END; {TRY}
LeaveCriticalSection(CS_ArrayMinersIPS);
End;

Function GetIPData(LData:String):String;
Begin
Result := Parameter(LData,0)+'['+Parameter(LData,1)+']';
End;

Function GetAMIString():String;
var
  counter,counter2 : integer;
  ThisAddress      : String;
  IPsList          : string;
  ThisRecord       : TMinersIPs;
Begin
Result := '';
EnterCriticalSection(CS_ArrayMinersIPS);
TRY
for counter := 0 to length(ARRAY_MinersIPs)-1 do
   begin
   ThisRecord := ARRAY_MinersIPs[counter];
   IPsList := '';
   for counter2 := 0 to length(ThisRecord.ArrIPs)-1 do
      begin
      IPsList := IPsList+ GetIPData(ThisRecord.ArrIPs[counter2]);
      end;
   Result := Result+' '+ThisRecord.Address+':'+IPsList;
   end;
EXCEPT ON E:Exception do
   Result := 'ERROR: '+E.Message;
END; {TRY}
LeaveCriticalSection(CS_ArrayMinersIPS);
Result := TRim(Result);
End;

Procedure SaveAMIToFile(Block:Integer);
var
  ThisFile : TextFile;
Begin
AssignFile(ThisFile,'ami/'+block.ToString+'.txt');
TRY
   Rewrite(ThisFile);
   WriteLn(ThisFile,GetAMIString);
   CloseFile(ThisFile);
EXCEPT ON E:Exception do

END; {TRY}
End;

Function GetAMIBlockData(Block:Integer):String;
var
  ThisFile : TextFile;
Begin
Result := '';
AssignFile(ThisFile,'ami/'+block.ToString+'.txt');
TRY
   Reset(ThisFile);
   ReadLn(ThisFile,Result);
   CloseFile(ThisFile);
EXCEPT ON E:Exception do
   Result := Format('Error for block %d : %s',[block,E.Message]);
END; {TRY}

End;

{$ENDREGION}

// Tor filtering functions

Function GetTorNodesFile():boolean;
var
  MS: TMemoryStream;
  DownLink : String = '';
  extension : string;
  Conector : TFPHttpClient;
Begin
result := false;
DownLink := 'https://raw.githubusercontent.com/SecOps-Institute/Tor-IP-Addresses/master/tor-nodes.lst';
MS := TMemoryStream.Create;
Conector := TFPHttpClient.Create(nil);
conector.ConnectTimeout:=1000;
conector.IOTimeout:=1000;
conector.AllowRedirect:=true;
   TRY
   Conector.Get(DownLink,MS);
   MS.SaveToFile('tornodes.txt');
   result := true;
   EXCEPT ON E:Exception do
      ToLog(' Error downloading Tor nodes list: '+E.Message);
   END{Try};
MS.Free;
conector.free;
End;

Function GetTorExitNodesFile():boolean;
var
  MS: TMemoryStream;
  DownLink : String = '';
  extension : string;
  Conector : TFPHttpClient;
Begin
result := false;
DownLink := 'https://raw.githubusercontent.com/SecOps-Institute/Tor-IP-Addresses/master/tor-exit-nodes.lst';
MS := TMemoryStream.Create;
Conector := TFPHttpClient.Create(nil);
conector.ConnectTimeout:=1000;
conector.IOTimeout:=1000;
conector.AllowRedirect:=true;
   TRY
   Conector.Get(DownLink,MS);
   MS.SaveToFile('torexitnodes.txt');
   result := true;
   EXCEPT ON E:Exception do
      ToLog(' Error downloading Tor exit-nodes list: '+E.Message);
   END{Try};
MS.Free;
conector.free;
End;

Procedure LoadTorNodes();
var
  NodesFile,ExitNodesFile : TextFile;
  ThisData : String;
  Added    : integer = 0;
Begin
SLTor.Clear;
AssignFile(NodesFile,'tornodes.txt');
AssignFile(ExitNodesFile,'torexitnodes.txt');
TRY
   Reset(NodesFile);
   While not eof(NodesFile) do
      begin
      Readln(NodesFile,ThisData);
      SLTor.Add(ThisData);
      Inc(Added);
      end;
   CLoseFIle(NodesFile);
   Reset(ExitNodesFile);
   While not eof(ExitNodesFile) do
      begin
      Readln(ExitNodesFile,ThisData);
      SLTor.Add(ThisData);
      Inc(Added);
      end;
   CLoseFIle(ExitNodesFile);
EXCEPT ON E:Exception do
   ToLog('Error loading TOR files: '+E.Message);
END{Try};
ToLog( ' Loaded TOR IPs : '+Added.ToString);
End;

Function IsTorIP(IP:String):boolean;
Begin
if SLTOR.IndexOf(IP)>=0 then result := true
else result := false;
End;

Procedure AddTorAllowed(IP:String);
Begin
EnterCriticalSection(CS_TorAllowed);
TorAllowed := ' '+IP;
LeaveCriticalSection(CS_TorAllowed);
End;

Procedure ResetTorAllowed();
Begin
EnterCriticalSection(CS_TorAllowed);
TorAllowed := '';
LeaveCriticalSection(CS_TorAllowed);
End;

Function IPTorAllowed(IP:String):boolean;
Begin
EnterCriticalSection(CS_TorAllowed);
if AnsiContainsStr(TorAllowed,IP) then result := true
else result := false;
LeaveCriticalSection(CS_TorAllowed);
End;

Procedure AddTorBlocked(IP:String);
Begin
EnterCriticalSection(CS_TorBlocked);
TorBlocked := ' '+IP;
LeaveCriticalSection(CS_TorBlocked);
End;

Procedure ResetTorBlocked();
Begin
EnterCriticalSection(CS_TorBlocked);
TorBlocked := '';
LeaveCriticalSection(CS_TorBlocked);
End;

Function IPTorBlocked(IP:String):boolean;
Begin
EnterCriticalSection(CS_TorBlocked);
if AnsiContainsStr(TorBlocked,IP) then result := true
else result := false;
LeaveCriticalSection(CS_TorBlocked);
End;

// VPN Filter

Function GetVPNBanList():String;
var
  readedLine : string = '';
  Conector : TFPHttpClient;
  InitTime  : int64;
Begin
Result := '';
InitTime := GetTickCount64;
Conector := TFPHttpClient.Create(nil);
conector.ConnectTimeout:=3000;
conector.IOTimeout:=3000;
   TRY
   readedLine := Conector.SimpleGet('http://iscal.ddns.net:49001/api/banList1');
   EXCEPT on E: Exception do
   begin
   ToLog(' Error GetVPNBanList: '+E.Message);
   end;
   END;//TRY
if readedline <> '' then
   begin
   ReadedLine := StringReplace(ReadedLine,'[','',[rfReplaceAll, rfIgnoreCase]);
   ReadedLine := StringReplace(ReadedLine,']','',[rfReplaceAll, rfIgnoreCase]);
   ReadedLine := StringReplace(ReadedLine,'"','',[rfReplaceAll, rfIgnoreCase]);
   ReadedLine := StringReplace(ReadedLine,',',' ',[rfReplaceAll, rfIgnoreCase]);
   readedline := Trim(ReadedLine);
   end;
Result := readedline;
Conector.Free;
ToLog(Format('.DUPs download time: %d ms',[GetTickCount64-InitTime]));
End;

Procedure SaveDupAds();
var
  ThisFile : textfile;
Begin
AssignFile(ThisFile,'dupads.text');
  TRY
  Rewrite(ThisFile);
  writeln(ThisFile,BannedAddresses);
  Closefile(ThisFile);
  EXCEPT on E: Exception do
    begin

    end;

  END;
End;

Procedure LoadDupAds();
var
  ThisFile : textfile;
Begin
AssignFile(ThisFile,'dupads.text');
  TRY
  Reset(ThisFile);
  Readln(ThisFile,BannedAddresses);
  Closefile(ThisFile);
  EXCEPT on E: Exception do
    begin

   end;
END;
End;

Function GetDupliaddresses():String;
var
  readedLine : string = '';
  Conector : TFPHttpClient;
  InitTime  : int64;
Begin
Result := '';
InitTime := GetTickCount64;
Conector := TFPHttpClient.Create(nil);
conector.ConnectTimeout:=3000;
conector.IOTimeout:=3000;
   TRY
   readedLine := Conector.SimpleGet('http://iscal.ddns.net:49001/api/banAddresses1');
   EXCEPT on E: Exception do
   begin
   ToLog(' Error GetDupliaddresses: '+E.Message);
   end;
   END;//TRY
if readedline <> '' then
   begin
   //ReadedLine := StringReplace(ReadedLine,'[','',[rfReplaceAll, rfIgnoreCase]);
   //ReadedLine := StringReplace(ReadedLine,']','',[rfReplaceAll, rfIgnoreCase]);
   //ReadedLine := StringReplace(ReadedLine,'"','',[rfReplaceAll, rfIgnoreCase]);
   //ReadedLine := StringReplace(ReadedLine,',',' ',[rfReplaceAll, rfIgnoreCase]);
   //readedline := Trim(ReadedLine);
   SaveDupAds;
   end;
Result := readedline;
Conector.Free;
//ToLog(Format('.BannedAddresses download time: %d ms',[GetTickCount64-InitTime]));
End;

Procedure ProcessNewVPNs(VPNsList:String);
var
  ThisIP    : String;
  Counter   : integer = 0;
  Included  : Integer = 0;
  Processed : integer = 0;
  InitTime  : int64;
  NewData       : TVPNIps;
  TEMP_ARRAY  : Array of TVPNIPs;
  ThisBlock : integer;
Begin
InitTime := GetTickCount64;
if VPNsList = '' then exit;

SetLEngth(TEMP_ARRAY,0);
ThisBlock := GetMainConsensus.block;
Repeat
   ThisIP := Parameter(VPNsList,counter);
   if ThisIP <> '' then
      begin
      NewData.IP    := ThisIP;
      NewData.Block := ThisBlock;
      Insert(NewData,TEMP_ARRAY,length(TEMP_ARRAY));
      //if IncludeVPN(ThisIP,GetMainConsensus.block) then Inc(Included);
      Inc(Processed);
      end;
   Inc(Counter);
until ThisIP = '';
ToLog(Format(',DUPs Process time: %d ms',[GetTickCount64-InitTime]));
InitTime := GetTickCount64;
EnterCriticalSection(CS_VPNIPs);
SetLEngth(ARRAY_VPNIPs,0);
ARRAY_VPNIPs:= copy(TEMP_ARRAY,0,length(TEMP_ARRAY));
LEaveCriticalSection(CS_VPNIPs);
ToLog(Format(',DUPs copy time: %d ms',[GetTickCount64-InitTime]));
SaveVPNFile(TEMP_ARRAY);

//ToLog(' VPNs procecessed: '+Processed.ToString);
//If Included > 0 then ToLog('.New VPN IPs: '+Included.ToString);
End;

Function IncludeVPN(LocIP:String;block:integer):boolean;
var
  counter       : integer;
  AlreadyExists : boolean = false;
  NewData       : TVPNIps;
Begin
Result := false;
EnterCriticalSection(CS_VPNIPs);
NewData.IP    := LocIP;
NewData.Block := Block;
Insert(NewData,ARRAy_VPNIPs,length(ARRAy_VPNIPs));
Result := true;
LEaveCriticalSection(CS_VPNIPs);
End;

Function VPNIPExists(LocIP:String):boolean;
var
  counter : integer;
Begin
result := false;
EnterCriticalSection(CS_VPNIPs);
for counter := 0 to length(ARRAy_VPNIPs)-1 do
   begin
   if ARRAy_VPNIPs[counter].IP = LocIP then
      begin
      result := true;
      break;
      end;
   end;
LeaveCriticalSection(CS_VPNIPs);
End;

Procedure RunVPNClean(block:integer);
var
  counter : integer = 0;
  IsDone  : boolean = false;
  Cleaned : integer = 0;
Begin
EnterCriticalSection(CS_VPNIPs);
Repeat
   if Counter >= Length(ARRAy_VPNIPs) then IsDOne := true
   else
      begin
      if ARRAy_VPNIPs[counter].Block+VPNsBlocksLife < block then
         begin
         Delete(ARRAy_VPNIPs,counter,1);
         Inc(Cleaned);
         end
      else Inc(Counter);
      end;
until IsDone;
LEaveCriticalSection(CS_VPNIPs);
if Cleaned > 0 then ToLog('.Cleaned VPNS: '+Cleaned.ToString);
End;

Procedure ExportVPNs();
var
  ThisFile : Textfile;
  counter : integer;
Begin
Assign(Thisfile,'vpns.txt');
EnterCriticalSection(CS_VPNIPs);
rewrite(ThisFile);
for counter := 0 to length(ARRAy_VPNIPs)-1 do
   begin
   writeln(ThisFile,ARRAy_VPNIPs[counter].IP+' '+ARRAy_VPNIPs[counter].Block.ToString);
   end;
CloseFile(ThisFile);
LEaveCriticalSection(CS_VPNIPs);
End;

Procedure ClearActivePays();
Begin
EnterCriticalSection(CS_Activepays);
ActivePays := 0;
LeaveCriticalSection(CS_Activepays);
End;

Procedure DecActivePays();
Begin
EnterCriticalSection(CS_Activepays);
Dec(ActivePays);
LeaveCriticalSection(CS_Activepays);
End;

Procedure IncActivePays();
Begin
EnterCriticalSection(CS_Activepays);
Inc(ActivePays);
LeaveCriticalSection(CS_Activepays);
End;

function ActivePaysCount():integer;
Begin
EnterCriticalSection(CS_Activepays);
result:= ActivePays;
LeaveCriticalSection(CS_Activepays);
End;

// ARRAY SOURCES HANDLING

Function GetClass_A(IP:String):integer;
Begin
IP :=  StringReplace(IP,'.',' ',[rfReplaceAll, rfIgnoreCase]);
Result := StrToIntDef(Parameter(IP,0),0);
End;

Function GetClass_B(IP:String):integer;
Begin
IP :=  StringReplace(IP,'.',' ',[rfReplaceAll, rfIgnoreCase]);
Result := StrToIntDef(Parameter(IP,1),0);
End;

Function GetClass_C(IP:String):integer;
Begin
IP :=  StringReplace(IP,'.',' ',[rfReplaceAll, rfIgnoreCase]);
Result := StrToIntDef(Parameter(IP,2),0);
End;

Function GetClass_D(IP:String):integer;
Begin
IP :=  StringReplace(IP,'.',' ',[rfReplaceAll, rfIgnoreCase]);
Result := StrToIntDef(Parameter(IP,3),0);
End;

Procedure ResetArraySources();
Begin
EnterCriticalSection(CS_ArrSources);
SetLength(ArraySources,0);
LeaveCriticalSection(CS_ArrSources);
End;

Function IsValidRecord(Address, password,IP:String;Block:Integer):boolean;
var
  counter : integer;
Begin
Result := true;
EnterCriticalSection(CS_ArrSources);
for counter := 0 to length(ArraySources)-1 do
   begin
   if ArraySources[counter].Address = address then
      begin
      if ( (ArraySources[counter].IP = IP) and (ArraySources[counter].Password = password) ) then
         begin
         ArraySources[counter].LastBlock:=Block;
         Result := false;
         Break;
         end
      else if ( (ArraySources[counter].IP <> IP) and (ArraySources[counter].Password = password) ) then
         begin
         ArraySources[counter].IP := IP;
         ArraySources[counter].LastBlock:=Block;
         Result := false;
         break;
         end
      end;
   if ArraySources[counter].IP = IP then
      begin
      if ArraySources[counter].Address <> address then
         begin
         Delete(ArraySources,counter,1);
         result := false;
         break;
         end;
      end;
   end;
LeaveCriticalSection(CS_ArrSources);
End;

Procedure AddNewRecord(Address, password,IP:String;Block:Integer);
Begin
if not IsValidRecord(Address, password, ip, block)then Exit;
EnterCriticalSection(CS_ArrSources);
SetLength(ArraySources,length(ArraySources)+1);
Arraysources[length(ArraySources)-1].address:=Address;
Arraysources[length(ArraySources)-1].IP:=IP;
Arraysources[length(ArraySources)-1].Password:=Password;
Arraysources[length(ArraySources)-1].classA:=GetClass_A(IP);
Arraysources[length(ArraySources)-1].classB:=GetClass_B(IP);
Arraysources[length(ArraySources)-1].classC:=GetClass_C(IP);
Arraysources[length(ArraySources)-1].classD:=GetClass_D(IP);
Arraysources[length(ArraySources)-1].lastblock := Block;
LeaveCriticalSection(CS_ArrSources);
End;

Procedure RestartSourcesCounters();
var
  counter,count2 : integer;
Begin
for counter := 0 to 255 do
   begin
   ClassAcount[counter] := 0;
   for count2 := 0 to 255 do
      ClassBCount[counter][count2] := 0;
   end;
End;

Procedure CreditToSource(IP:String);
Begin
// Class B
inc(ClassBCount[GetClass_A(IP)][GetClass_B(IP)]);
// Class A
if ClassBCount[GetClass_A(IP)][GetClass_B(IP)] = 1 then
   Inc(ClassAcount[GetClass_A(IP)]);
End;

Function GetClassBParticipants(ClassA:integer):integer;
var
  Counter : integer;
Begin
Result := 0;
for counter := 0 to 255 do
   inc(result,ClassBCount[ClassA][Counter]);
End;

Function GetUserPAyment(IP:String;MaxClassA:int64):int64;
var
  TothisBclass : int64;
Begin
TothisBclass := MaxClassA div ClassAcount[GetClass_A(IP)];
Result := TothisBclass div ClassBCount[GetClass_A(IP)][GetClass_B(IP)];
End;

Procedure OutputSourcesToFile(Wasmined:Boolean);
var
  ThisFile : textfile;
  counter,count2  : integer;
  ThisAddress, ThisIP,ThisPass,ThisBlock : String;
  ThisLine : string;
  TotalToDistribute : int64;
  PoolComision     : int64;
  AClassesCount : integer = 0;
  LBPowPayment  : int64;
  MaxPErAddress, MaxPerClassA : int64;
  TotalThisBlock : integer = 0;
  CopyArray : array of TSourceData;
  ThisPayment : int64;
  ThisPayShow : string;
  TotalPayment : int64 = 0;
  PRevBlockBounty : int64;
  BlockData : TBlockRec;
Begin
RestartSourcesCounters;
Assignfile(ThisFile,'newpopw/'+inttostr(GetMainConsensus.block)+'.txt');
EnterCriticalSection(CS_ArrSources);
SetLength(CopyArray,0);
CopyArray := copy(Arraysources,0,length(Arraysources));
LeaveCriticalSection(CS_ArrSources);
TRY
Rewrite(ThisFile);
writeln(ThisFile,'------------------------------------------------------------------');
writeln(ThisFile,'List');
writeln(ThisFile,'------------------------------------------------------------------');
ThisAddress := format('%0:-40s',['Address']);
ThisIP      := format('%0:20s',['IP']);
ThisPass    := format('%0:-20s',['Password']);
ThisBlock   := format('%0:10s',['Block']);
ThisLine := format('%s %s %s %s',[ThisAddress,ThisIP,ThisPass,ThisBlock]);
writeln(ThisFile,ThisLine);
for counter := 0 to length(CopyArray)-1 do
   begin
   ThisAddress := format('%0:-40s',[CopyArray[counter].address]);
   ThisIP      := format('%0:20s',[CopyArray[counter].IP]);
   ThisPass    := format('%0:-20s',[CopyArray[counter].Password]);
   ThisBlock   := format('%0:10s',[CopyArray[counter].LastBlock.ToString]);
   ThisLine := format('%s %s %s %s',[ThisAddress,ThisIP,ThisPass,ThisBlock]);
   if CopyArray[counter].LastBlock >= GetMainConsensus.block-1 then
      begin
      Inc(TotalThisBlock);
      CreditToSource(CopyArray[counter].IP);
      //writeln(ThisFile,ThisLine);
      end;
   end;
// Analisis
writeln(ThisFile,'------------------------------------------------------------------');
writeln(ThisFile,'Data');
writeln(ThisFile,'------------------------------------------------------------------');
If wasmined then TotalToDistribute := GetMainConsensus.LBPoW
else TotalToDistribute := 0;
ThisLine := Format('This Block POW : %s',[Int2Curr(TotalToDistribute)]);
  writeln(ThisFile,ThisLine);
if wasmined then PoolComision := (TotalToDistribute * PoolFee) div 10000
else PoolComision := 0;
ThisLine := Format('Pool comision : %s',[Int2Curr(PoolComision)]);
  writeln(ThisFile,ThisLine);
if wasmined then PRevBlockBounty := GetArrayBlocksLast.Bounty
else PRevBlockBounty := 0;
ThisLine := Format('Pool Bounty : %s',[Int2Curr(PRevBlockBounty)]);
  writeln(ThisFile,ThisLine);
TotalToDistribute := TotalToDistribute- PoolComision;
if wasmined then TotalToDistribute := TotalToDistribute + GetArrayBlocksLast.Bounty;
ThisLine := Format('To distribue: %s ',[Int2Curr(TotalToDistribute)]);
  writeln(ThisFile,ThisLine);
ThisLine := Format('Participants: %d (%d)',[TotalThisBlock,length(CopyArray)]);
  writeln(ThisFile,ThisLine);
if TotalThisBlock>0 then MaxPerAddress := TotalToDistribute div TotalThisBlock
else MaxPerAddress := 0;
ThisLine := 'Max per participant : '+Int2Curr(MaxPerAddress);
writeln(ThisFile,ThisLine);
for counter := 0 to 255 do
   begin
   if ClassAcount[counter] > 0 then Inc(AClassesCount);
   end;
ThisLine := 'Class A count : '+AClassesCount.tostring;
writeln(ThisFile,ThisLine);
if TotalThisBlock>0 then MaxPerClassA := TotalToDistribute div AClassesCount
else MaxPerClassA := 0;
ThisLine := 'Max per Class A : '+Int2Curr(MaxPerClassA);
writeln(ThisFile,ThisLine);
writeln(ThisFile,'------------------------------------------------------------------');
For counter := 0 to 255 do
   begin
   if ClassAcount[counter]>0 then
      begin
      ThisLine := Format('Class A %d -> %d B classes -> Participants: %d',[counter,ClassAcount[counter],GetClassBParticipants(counter)]);
      //writeln(ThisFile,ThisLine);
      end;
   end;
BlockData := GetArrayBlocksLast;
if wasmined then
   begin
   writeln(ThisFile,'------------------------------------------------------------------');
   writeln(ThisFile,'Payments');
   writeln(ThisFile,'------------------------------------------------------------------');
   for counter := 0 to length(CopyArray)-1 do
      begin
      if CopyArray[counter].LastBlock >= GetMainConsensus.block-1 then
         begin
         ThisPayment := GetUserPAyment(CopyArray[counter].IP,MaxPerClassA);
         if thispayment > MaxPerAddress then ThisPayment := MaxPerAddress;
         ThisAddress := format('%0:-40s',[CopyArray[counter].address]);
         ThisIP      := format('%0:20s',[CopyArray[counter].IP]);
         ThisPayShow := format('%0:-20s',[Int2Curr(ThisPayment)]);
         ThisLine := format('%s %s %s',[ThisAddress,ThisIP,ThisPayShow]);
         Inc(TotalPayment,ThisPayment);
         //writeln(ThisFile,ThisLine);
         end;
      end;
   writeln(ThisFile,'------------------------------------------------------------------');
   writeln(ThisFile,'Total paid   : '+Int2curr(TotalPayment));
   writeln(ThisFile,'Bounty saved : '+Int2curr(TotalToDistribute-TotalPayment));
   BlockData.TotalPaid:=TotalPayment;
   BlockData.PoWIncome:=GetMainConsensus.LBPoW-PoolComision;
   BlockData.Bounty := TotalToDistribute-TotalPayment;
   UpdateArrayBlocks(BlockData);
   end
else
   begin
   UpdateArrayBlocks(BlockData);
   end;
Closefile(ThisFile);
EXCEPT ON E:EXCEPTION do
   ToLog('.Error on output sources: '+E.Message);
END;
OutputLastDayBlocks;
End;

Procedure LoadSourcesFromDisk();
var
  thisfile : file of TSourceData;
  counter : integer;
  ThisData : TSourceData;
Begin
Assignfile(ThisFile,'sources.dat');
EnterCriticalSection(CS_ArrSources);
TRY
reset(Thisfile);
Setlength(Arraysources,filesize(ThisFile));
for counter := 0 to length(Arraysources)-1 do
   begin
   seek(thisfile,counter);
   read(Thisfile,Arraysources[counter]);
   end;
closeFile(ThisFile);
EXCEPT ON E:Exception do
   begin
   ToLog('.Error loading sources: '+E.Message);
   end;
END;
LeaveCriticalSection(CS_ArrSources);
End;

Procedure SaveSourcesToDisk();
var
  thisfile : file of TSourceData;
  counter : integer;
Begin
Assignfile(ThisFile,'sources.dat');
EnterCriticalSection(CS_ArrSources);
TRY
rewrite(Thisfile);
for counter := 0 to length(Arraysources)-1 do
   begin
   seek(thisfile,counter);
   write(Thisfile,Arraysources[counter]);
   end;
closeFile(ThisFile);
EXCEPT ON E:Exception do
   begin
   ToLog('.Error saving  sources: '+E.Message);
   end;
END;
LeaveCriticalSection(CS_ArrSources);
End;

// Array of blocks

Procedure LoadArrBlocksFromDisk();
var
  ThisFile : file of TBlockRec;
  counter  : integer;
Begin
SetLength(ArrBlocks,0);
if not fileexists('blockslist.dat') then SaveArrBlocksToFile;
AssignFile(Thisfile,'blockslist.dat');
EnterCriticalSection(CS_ArrBlocks);
Reset(ThisFile);
SetLength(ArrBlocks,filesize(ThisFile));
for counter := 0 to filesize(Thisfile)-1 do
   begin
   seek(thisfile,counter);
   read(thisfile,ArrBlocks[Counter]);
   end;
CloseFile(ThisFile);
LeaveCriticalSection(CS_ArrBlocks);
End;

Procedure SaveArrBlocksToFile();
var
  ThisFile : file of TBlockRec;
  counter  : integer;
Begin
AssignFile(Thisfile,'blockslist.dat');
EnterCriticalSection(CS_ArrBlocks);
Rewrite(ThisFile);
for counter := 0 to length(ArrBlocks)-1 do
   begin
   seek(thisfile,counter);
   write(thisfile,ArrBlocks[Counter]);
   end;
CloseFile(ThisFile);
LeaveCriticalSection(CS_ArrBlocks);
end;

Function GetArrayBlocksLast:TBlockRec;
Begin
if length(ArrBlocks) < 1 then result := default(TBlockRec)
else
   begin
   EnterCriticalSection(CS_ArrBlocks);
   result := ArrBlocks[length(ArrBlocks)-1];
   LeaveCriticalSection(CS_ArrBlocks);
   end;
End;

Procedure UpdateArrayBlocks(ThisRec:TBlockRec);
var
  counter : integer;
Begin
If ThisRec.blocknumber > GetArrayBlocksLast.blocknumber then
   begin
   EnterCriticalSection(CS_ArrBlocks);
   SetLength(ArrBlocks,length(ArrBlocks)+1);
   ArrBlocks[length(ArrBlocks)-1] := ThisRec;
   LeaveCriticalSection(CS_ArrBlocks);
   end
else
   Begin
   EnterCriticalSection(CS_ArrBlocks);
   for counter := length(ArrBlocks)-1 downto 0 do
      begin
      if ArrBlocks[counter].blocknumber = ThisRec.blocknumber then
         begin
         ArrBlocks[counter] := ThisRec;
         Break;
         end;
      end;
   LeaveCriticalSection(CS_ArrBlocks);
   end;
SaveArrBlocksToFile;
End;

Procedure OutputLastDayBlocks();
var
  ThisFile  : textfile;
  counter   : integer;
  LastBlock : integer;
  ThisBlock,ThisMined, thistotalpaid, thisbounty, thisPow : string;
  ThisLine  : STring;
Begin
assignfile(ThisFile,'blockslist.txt');
EnterCriticalSection(CS_ArrBlocks);
TRY
Rewrite(ThisFile);
   ThisBlock := Format('%0:10s',['Block']);
   ThisMined := format('%0:10s',['Mined']);
   Thispow   := Format('%0:15s',['Earned']);
   thistotalpaid := format('%0:15s',['Paid']);
   thisbounty := format('%0:15s',['Bounty']);
   ThisLine := format('%s %s %s %s %s',[ThisBlock,ThisMined,Thispow,thistotalpaid,thisbounty]);
   Writeln(ThisFile,ThisLine);
LastBlock := LEngth(ArrBlocks)-143;
if LastBlock < 0 then lastblock := 0;
for counter := LEngth(ArrBlocks)-1 downto lastblock do
   begin
   ThisBlock := Format('%0:10s',[ArrBlocks[counter].blocknumber.ToString]);
   ThisMined := format('%0:10s',[BoolToStr(ArrBlocks[counter].Mined,true)]);
   Thispow   := Format('%0:15s',[Int2curr(ArrBlocks[counter].PoWIncome)]);
   thisbounty := format('%0:15s',[Int2Curr(ArrBlocks[counter].Bounty)]);
   thistotalpaid := format('%0:15s',[Int2Curr(ArrBlocks[counter].TotalPaid)]);
   ThisLine := format('%s %s %s %s %s',[ThisBlock,ThisMined,ThisPow, thistotalpaid,thisbounty]);
   Writeln(ThisFile,ThisLine);
   end;
CloseFile(ThisFile);
EXCEPT ON E:Exception do
   ToLog('.Error saving  lastblocks: '+E.Message);
END;
LeaveCriticalSection(CS_ArrBlocks);
End;

END. // End unit

