unit GLUtils;



interface
uses  SysUtils;



//types
 type
  PByteArray     = ^TByteArray;
  TByteArray     = array[ 0..High(LongWord) shr 1 - 1 ] of Byte;
  PWordArray     = ^TWordArray;
  TWordArray     = array[ 0..High(LongWord) shr 2 - 1 ] of Word;
  PLongWordArray = ^TLongWordArray;
  TLongWordArray = array[ 0..High(LongWord) shr 3 - 1 ] of LongWord;




function GetStr( const Str : String; const d : AnsiChar; const b : Boolean ) : String;
function file_GetName( const FileName : String ) : String;
function file_GetExtension( const FileName : String ) : String;
function file_GetDirectory( const FileName : String ) : String;



function min( a, b : Single ) : Single;overload;
function max( a, b : Single ) : Single;overload;
function min( a, b : integer ) : integer;overload;
function max( a, b : integer ) : integer;overload;


  function FloatToStr( Value : Single; Digits : Integer = 2 ) : String;
  function StrToFloat( const Value : String ) : Single;

function IntToStr( Value : Integer ) : String;
function StrToInt( const Value : String ) : Integer;




const


  EPS = 0.000001;

  pi      = 3.141592654;
  rad2deg = 57.29578049;
  deg2rad = 0.017453292;

  ORIENTATION_LEFT  = -1;
  ORIENTATION_RIGHT = 1;
  ORIENTATION_ZERO  = 0;



var
  cosTable : array[ 0..360 ] of Single;
  sinTable : array[ 0..360 ] of Single;

implementation
var
  wideStr : PWideChar;
  filePath:string='';



function ArcTan2( dx, dy : Single ) : Single;
begin
  Result := abs( ArcTan( dy / dx ) * ( 180 / pi ) );
end;

function min( a, b : Single ) : Single;
begin
  if a > b Then Result := b else Result := a;
end;

function max( a, b : Single ) : Single;
begin
  if a > b Then Result := a else Result := b;
end;
function min( a, b : integer ) : integer;
begin
  if a > b Then Result := b else Result := a;
end;

function max( a, b : integer ) : integer;
begin
  if a > b Then Result := a else Result := b;
end;

procedure InitCosSinTables;
  var
    i         : Integer;
    rad_angle : Single;
begin
  for i := 0 to 360 do
    begin
      rad_angle := i * ( pi / 180 );
      cosTable[ i ] := cos( rad_angle );
      sinTable[ i ] := sin( rad_angle );
    end;
end;

function m_Cos( Angle : Integer ) : Single;
begin
  if Angle > 360 Then
    DEC( Angle, ( Angle div 360 ) * 360 )
  else
    if Angle < 0 Then
      INC( Angle, ( abs( Angle ) div 360 + 1 ) * 360 );
  Result := cosTable[ Angle ];
end;

function m_Sin( Angle : Integer ) : Single;
begin
  if Angle > 360 Then
    DEC( Angle, ( Angle div 360 ) * 360 )
  else
    if Angle < 0 Then
      INC( Angle, ( abs( Angle ) div 360 + 1 ) * 360 );
  Result := sinTable[ Angle ];
end;

function m_Distance( x1, y1, x2, y2 : Single ) : Single;
begin
  Result := sqrt( sqr( x1 - x2 ) + sqr( y1 - y2 ) );
end;

function m_FDistance( x1, y1, x2, y2 : Single ) : Single;
begin
  Result := sqr( x1 - x2 ) + sqr( y1 - y2 );
end;

function m_Angle( x1, y1, x2, y2 : Single ) : Single;
  var
    dx, dy : Single;
begin
  dx := ( X1 - X2 );
  dy := ( Y1 - Y2 );

  if dx = 0 Then
    begin
      if dy > 0 Then
        Result := 90
      else
        Result := 270;
      exit;
    end;

  if dy = 0 Then
    begin
      if dx > 0 Then
        Result := 0
      else
        Result := 180;
      exit;
    end;

  if ( dx < 0 ) and ( dy > 0 ) Then
    Result := 180 - ArcTan2( dx, dy )
  else
    if ( dx < 0 ) and ( dy < 0 ) Then
      Result := 180 + ArcTan2( dx, dy )
    else
      if ( dx > 0 ) and ( dy < 0 ) Then
        Result := 360 - ArcTan2( dx, dy )
      else
        Result := ArcTan2( dx, dy )
end;

function m_Orientation( x, y, x1, y1, x2, y2 : Single ) : Integer;
  var
    orientation : Single;
begin
  orientation := ( x2 - x1 ) * ( y - y1 ) - ( x - x1 ) * ( y2 - y1 );

  if orientation > 0 Then
    Result := ORIENTATION_RIGHT
  else
    if orientation < 0 Then
      Result := ORIENTATION_LEFT
    else
      Result := ORIENTATION_ZERO;
end;



procedure m_SinCos( Angle : Single; out s, c : Single );
begin
  s := Sin( Angle );
  c := Cos( Angle );
end;
function tan( x : Single ) : Single;
  var
    _sin,_cos : Single;
begin
  m_SinCos( x, _sin, _cos );
  tan := _sin / _cos;
end;


//*************************************************************************************

procedure Get_Mem( out Mem : Pointer; Size : LongWord );
begin
  if Size > 0 Then
    begin
      GetMem( Mem, Size );
      FillChar( Mem^, Size, 0 );
    end else
      Mem := nil;
end;

procedure Free_Mem( var Mem : Pointer );
begin
  FreeMem( Mem );
  Mem := nil;
end;







function GetStr( const Str : String; const d : AnsiChar; const b : Boolean ) : String;
  var
    i, pos, l : Integer;
begin
  pos := 0;
  l := Length( Str );
  for i := l downto 1 do
    if Str[ i ] = d Then
      begin
        pos := i;
        break;
      end;
  if b Then
    Result := copy( Str, 1, pos )
  else
    Result := copy( Str, l - ( l - pos ) + 1, ( l - pos ) );
end;

function file_GetName( const FileName : String ) : String;
  var
    tmp :String;
begin
  Result := GetStr( FileName, '/', FALSE );
  if Result = FileName Then
    Result := GetStr( FileName, '\', FALSE );
  tmp := GetStr( Result, '.', FALSE );
  if Result <> tmp Then
    Result := copy( Result, 1, Length( Result ) - Length( tmp ) - 1 );
end;

function file_GetExtension( const FileName : String ) : String;
  var
    tmp : String;
begin
  tmp := GetStr( FileName, '/', FALSE );
  if tmp = FileName Then
    tmp := GetStr( FileName, '\', FALSE );
  Result := GetStr( tmp, '.', FALSE );
  if tmp = Result Then
    Result := '';
end;

function file_GetDirectory( const FileName : String ) : String;
begin
  Result := GetStr( FileName, '/', TRUE );
  if Result = '' Then
    Result := GetStr( FileName, '\', TRUE );

end;

function IntToStr( Value : Integer ) : String;
begin
  Str( Value, Result );
end;

function StrToInt( const Value : String ) : Integer;
  var
    e : Integer;
begin
  Val( Value, Result, e );
  if e <> 0 Then
    Result := 0;
end;



function FloatToStr( Value : Single; Digits : Integer = 2 ) : String;
begin
  Str( Value:0:Digits, Result );
end;

function StrToFloat( const Value : String ) : Single;
  var
    e : Integer;
begin
  Val( Value, Result, e );
  if e <> 0 Then
    Result := 0;
end;

function u_BoolToStr( Value : Boolean ) : UTF8String;
begin
  if Value Then
    Result := 'TRUE'
  else
    Result := 'FALSE';
end;



end.
