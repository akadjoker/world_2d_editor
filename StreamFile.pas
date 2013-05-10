unit StreamFile;

interface

uses
  SysUtils,
  Classes;

type
  TFileRead = class
  public
    m_file: TFileStream;
    constructor Create;
    destructor Destroy; override;
		function Open(filename: String;
      mode: Word = fmOpenRead or fmShareDenyWrite) : boolean;

    function ReadBuffer(Var buffer; bufferSize: LongWord) : boolean;
    function ReadString(Var text: String) : boolean;
    function ReadInt(Var value: integer) : boolean;
		function ReadInt8(Var value: Byte) : boolean;
		function ReadInt16(Var value: Word) : boolean; overload;
    function ReadInt16(Var value: SmallInt) : boolean; overload;
		function ReadInt32(Var value: Longword) : boolean; overload;
    function ReadInt32(Var value: Longint) : boolean; overload;
		function Seek(offset: Longint; origin: Word = soFromCurrent): Longint;
		procedure Close();

  end;

    TFileWrite = class
  public
   m_file: TFileStream;
    constructor Create;
    destructor Destroy; override;
		function Open(filename: String) : boolean;

    function WriteBuffer(var buffer; bufferSize: LongWord) : boolean;
    function Write(const buffer; bufferSize: LongWord) : boolean;
    function WriteString( text: string) : boolean;
    function WriteInt( value: integer) : boolean;
		function WriteInt8( value: Byte) : boolean;
		function WriteInt16( value: Word) : boolean; overload;
    function WriteInt16( value: SmallInt) : boolean; overload;
		function WriteInt32( value: Longword) : boolean; overload;
    function WriteInt32( value: Longint) : boolean; overload;
		function Seek(offset: Longint; origin: Word = soFromCurrent): Longint;
		procedure Close();
  private

  end;

  function ReadCRLFString(aStream : TStream) : AnsiString;
  procedure WriteCRLFString(aStream : TStream; const aString : AnsiString);

implementation
function ReadCRLFString(aStream : TStream) : AnsiString;
var
   c : AnsiChar;
begin
   Result:='';
   while Copy(Result, Length(Result)-1, 2)<>#13#10 do begin
      aStream.Read(c, 1);
      Result:=Result+c;
   end;
   Result:=Copy(Result, 1, Length(Result)-2);
end;

// WriteCRLFString
//
procedure WriteCRLFString(aStream : TStream; const aString : AnsiString);
const
   cCRLF : Integer = $0A0D;
begin
   with aStream do begin
      Write(aString[1], Length(aString));
      Write(cCRLF, 2);
   end;
end;

procedure SaveAnsiStringToFile(fs : TStream;const fileName: String; const data : AnsiString);
var
   n : Cardinal;

begin
//	fs:=CreateFileStream(fileName, fmCreate);
   try
      n:=Length(data);
      if n>0 then
      	fs.Write(data[1], n);
   finally
   	fs.Free;
   end;
end;

// LoadStringFromFile
//
function LoadAnsiStringFromFile(fs : TStream;const fileName : String) : AnsiString;
var
   n : Cardinal;
//	fs : TStream;
begin
   if FileExists(fileName) then begin
  // 	fs:=CreateFileStream(fileName, fmOpenRead+fmShareDenyNone);
      try
         n:=fs.Size;
   	   SetLength(Result, n);
         if n>0 then
         	fs.Read(Result[1], n);
      finally
   	   fs.Free;
      end;
   end else Result:='';
end;

{
procedure WriteWideString(const ws: WideString; stream: TStream);
var
  nChars: LongInt;
begin
  nChars := Length(ws);
  stream.WriteBuffer(nChars, SizeOf(nChars);
  if nChars > 0 then
    stream.WriteBuffer(ws[1], nChars * SizeOf(ws[1]));
end;

function ReadWideString(stream: TStream): WideString;
var
  nChars: LongInt;
begin
  stream.ReadBuffer(nChars, SizeOf(nChars));
  SetLength(Result, nChars);
  if nChars > 0 then
    stream.ReadBuffer(Result[1], nChars * SizeOf(Result[1]));
end;
procedure WriteWideString(const ws: WideString; stream: TStream);
var
  nBytes: LongInt;
begin
  nBytes := SysStringByteLen(Pointer(ws));
  stream.WriteBuffer(nBytes, SizeOf(nBytes));
  if nBytes > 0 then
    stream.WriteBuffer(Pointer(ws)^, nBytes);
end;

function ReadWideString(stream: TStream): WideString;
var
  nBytes: LongInt;
  buffer: PAnsiChar;
begin
  stream.ReadBuffer(nBytes, SizeOf(nBytes));
  if nBytes > 0 then begin
    GetMem(buffer, nBytes);
    try
      stream.ReadBuffer(buffer^, nBytes);
      Result := SysAllocStringByteLen(buffer, nBytes)
    finally
      FreeMem(buffer);
    end;
  end else
    Result := '';
end;
         }

procedure savestringtostream;
var
  SourceString: string;
  MemoryStream: TMemoryStream;
begin
  SourceString := 'Hello, how are you doing today?';
  MemoryStream := TMemoryStream.Create;
  try
    // Write the string to the stream. We want to write from SourceString's
    // data, starting at a pointer to SourceString (this returns a pointer to
    // the first character), dereferenced (this gives the actual character).
    MemoryStream.WriteBuffer(Pointer(SourceString)^, Length(SourceString));
    // Go back to the start of the stream
    MemoryStream.Position := 0;
    // Read it back in to make sure it worked.
    SourceString := 'I am doing just fine!';
    // Set the length, so we have space to read into
    SetLength(SourceString, MemoryStream.Size);
    MemoryStream.ReadBuffer(Pointer(SourceString)^, MemoryStream.Size);
   // Caption := SourceString;
  finally
    MemoryStream.Free;
  end;
end;


procedure WriteStringToFS(const s: string; const fs: TFileStream);
var
  i: integer;
begin
  i := 0;
  i := Length(s);
  if i > 0 then
    fs.WriteBuffer(s[1], i);
end;

function ReadStringFromFS(const fs: TFileStream): string;
var
  i: integer;
  s: string;
begin
  i := 0;
  s := '';
  fs.ReadBuffer(i, SizeOf(i));
  SetLength(s, i);
  fs.ReadBuffer(s, i);
  Result := s;
end;

constructor TFileRead.Create;
begin
  m_file := nil;
end;

destructor TFileRead.Destroy;
begin
  if(m_file <> nil) then
    m_file.Destroy;
end;

function TFileRead.Open(filename: String; mode: Word) : boolean;
begin
  if(nil <> m_file) then
    m_file.Destroy;

  m_file := TFileStream.Create(filename, mode);

  result := (m_file.Handle <> 0);
end;

function TFileRead.ReadBuffer(Var buffer; bufferSize: LongWord) : boolean;
begin
   try
     m_file.ReadBuffer(buffer, bufferSize);
     result := true;
   except
     result := false;
   end;
end;

function TFileRead.ReadString(Var text: String) : boolean;
var
   c : AnsiChar;
begin
   text:='';
   while Copy(text, Length(text)-1, 2)<>#13#10 do begin
      m_file.Read(c, 1);
      text:=text+c;
   end;
   text:=Copy(text, 1, Length(text)-2);

 result:=true;

end;

function TFileRead.ReadInt8(Var value: Byte) : boolean;
begin
  result := ReadBuffer(value, SizeOf(Byte));
end;
function TFileRead.ReadInt(Var value: integer) : boolean;
begin
  result := ReadBuffer(value, SizeOf(integer));
end;
function TFileRead.ReadInt16(Var value: Word) : boolean;
begin
  result := ReadBuffer(value, SizeOf(Word));
end;

function TFileRead.ReadInt16(Var value: SmallInt) : boolean;
begin
  result := ReadBuffer(value, SizeOf(SmallInt));
end;

function TFileRead.ReadInt32(Var value: Longword) : boolean;
begin
  result := ReadBuffer(value, SizeOf(Longword));
end;

function TFileRead.ReadInt32(Var value: Longint) : boolean;
begin
  result := ReadBuffer(value, SizeOf(Longint));
end;

function TFileRead.Seek(offset: Longint; origin: Word): Longint;
begin
  result := m_file.Seek(offset, origin);
end;

procedure TFileRead.Close();
begin
  m_file.Destroy;
end;

//**************************************************

constructor TFileWrite.Create;
begin
  m_file := nil;
end;

destructor TFileWrite.Destroy;
begin
  if(m_file <> nil) then
    m_file.Destroy;
end;

function TFileWrite.Open(filename: String) : boolean;
begin
  if(nil <> m_file) then     m_file.Destroy;
    

  m_file := TFileStream.Create(filename,fmCreate);

  result := (m_file.Handle <> 0);
end;
function TFileWrite.Write(const buffer; bufferSize: LongWord) : boolean;
begin
   try
     m_file.WriteBuffer(buffer, bufferSize);
     result := true;
   except
     result := false;
   end;
end;

function TFileWrite.WriteBuffer(var buffer; bufferSize: LongWord) : boolean;
begin
   try
     m_file.WriteBuffer(buffer, bufferSize);
     result := true;
   except
     result := false;
   end;
end;

function TFileWrite.WriteString( text: string) : boolean;
const
   cCRLF : Integer = $0A0D;
begin
      m_file.Write(text[1], Length(text));
      m_file.Write(cCRLF, 2);
end;

function TFileWrite.WriteInt8( value: Byte) : boolean;
begin
  result := WriteBuffer(value, SizeOf(Byte));
end;

function TFileWrite.WriteInt16( value: Word) : boolean;
begin
  result := WriteBuffer(value, SizeOf(Word));
end;

function TFileWrite.WriteInt16( value: SmallInt) : boolean;
begin
  result := WriteBuffer(value, SizeOf(SmallInt));
end;

function TFileWrite.WriteInt32( value: Longword) : boolean;
begin
  result := WriteBuffer(value, SizeOf(Longword));
end;

function TFileWrite.WriteInt32( value: Longint) : boolean;
begin
  result := WriteBuffer(value, SizeOf(Longint));
end;
function TFileWrite.WriteInt( value: integer) : boolean;
begin
  result := WriteBuffer(value, SizeOf(integer));
end;
function TFileWrite.Seek(offset: Longint; origin: Word): Longint;
begin
  result := m_file.Seek(offset, origin);
end;

procedure TFileWrite.Close();
begin
  m_file.Destroy;
end;

end.
