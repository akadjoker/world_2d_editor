unit GlDraw;




interface

uses dglopengl;






procedure glBegin(mode: GLenum);
procedure glEnd;


procedure glColor4ub(red, green, blue, alpha: GLubyte);

procedure glColor4ubv(v: PGLubyte);
procedure glColor4f(red, green, blue, alpha: GLfloat);
procedure glColor4b(red, green, blue, alpha: byte);

procedure glVertex2f(x, y: GLfloat);

procedure glVertex2fv(v: PGLfloat);

procedure glVertex3f(x, y, z: GLfloat);

procedure glTexCoord2f(s, t: GLfloat);
procedure glTexCoord2fv(v: PGLfloat);


procedure DrawSprite(sprite:GLuint; X,  Y,  Z,  W,  H:single);



implementation
uses GLUtils;


type

  PPoint2D = ^TPoint2D;
  TPoint2D = record
    X, Y : Single;
end;

type
  PPoints2D = ^TPoints2D;
  TPoints2D = array[ 0..0 ] of TPoint2D;

  TPoint3D = record
    X, Y, Z : Single;
  end;

type
  GLESPVertex = ^GLESTVertex;
  GLESTVertex = record
    U, V    : Single;
    Color   : LongWord;
    X, Y, Z : Single;
  end;






var
  RenderMode     : LongWord;
  RenderQuad     : Boolean;
  RenderTextured : Boolean=true;
  // Buffers
  newTriangle : Integer;
  bColor      : LongWord;
  bVertices   : array of GLESTVertex;
  bSize       : Integer;


procedure DrawSprite(sprite:GLuint; X,  Y,  Z,  W,  H:single);
var
box:array[0..11]of single;
tex:array[0..7]of single;
begin
tex[0]:=0;tex[1]:=0;
tex[2]:=1;tex[3]:=0;
tex[4]:=1;tex[5]:=1;
tex[6]:=0;tex[7]:=1;

box[0]:=x;  box[1]:=y+h;box[2]:=z;
box[3]:=x+w;box[4]:=y+h;box[5]:=z;
box[6]:=x+w;box[7]:=y;box[8]:=z;
box[9]:=x;  box[10]:=y;box[11]:=z;

	glBindTexture(GL_TEXTURE_2D,sprite);

	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
 
	glVertexPointer(3, GL_FLOAT  , 0,@box);
	glTexCoordPointer(2, GL_FLOAT, 0, @tex);
 
	glDrawArrays(GL_TRIANGLES,0,3);
 
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
end;

function CreateVertex(x,y,z:single;col:LongWord;u,v:single):GLESTVertex;
begin
result.x:=x;
result.y:=y;
result.z:=z;
result.u:=u;
result.v:=v;
result.Color:=col;
end;



{
procedure BltImage(x,y,w,h:single;z:single;Color:longword;blend:integer);
var
Quad: TQuad;
x1,y1,y2,x2:single;
xOffset,yOffset:integer;
begin
//Quad.tex:=texture;
Quad.blend:=blend;

x1 :=x;
y1 :=y;
x2 :=x+w;
y2 :=y+h;




        quad.v[0].z := z;
        quad.v[1].z := z;
        quad.v[2].z := z;
        quad.v[3].z := z;

        quad.v[0].x   := x1;
        quad.v[0].y   := y1;
        quad.v[0].color := Color;

        quad.v[1].x   := x2;
        quad.v[1].y   := y1;
        quad.v[1].color := Color;

        quad.v[2].x   := x2;
        quad.v[2].y   := y2;
        quad.v[2].color := Color;

        quad.v[3].x   := x1;
        quad.v[3].y   := y2;
        quad.v[3].color := Color;


        quad.v[0].u := 0.0;        quad.v[0].v := 0.0;
        quad.v[1].u := 1.0;        quad.v[1].v := 0.0;
        quad.v[2].u := 1.0;        quad.v[2].v := 1.0;
        quad.v[3].u := 0.0;        quad.v[3].v := 1.0;


DrawQuad(Quad);
end;

}



  procedure glBegin(mode: GLenum);
  begin
    bSize := 0;
    RenderTextured := FALSE;

    if Mode = GL_QUADS Then
      begin
        RenderQuad  := TRUE;
        newTriangle := 0;
        RenderMode  := GL_TRIANGLES;
      end else
        begin
          RenderQuad := FALSE;
          RenderMode := Mode;
        end;
  end;


procedure glEnd;
begin
  if bSize = 0 Then exit;

  if RenderTextured Then
    begin
      glEnableClientState( GL_TEXTURE_COORD_ARRAY );
      glTexCoordPointer( 2, GL_FLOAT, 24, @bVertices[ 0 ] );
    end;

  glEnableClientState( GL_COLOR_ARRAY );
  glColorPointer( 4, GL_UNSIGNED_BYTE, 24, @bVertices[ 0 ].Color );

  glEnableClientState( GL_VERTEX_ARRAY );
  glVertexPointer( 3, GL_FLOAT, 24, @bVertices[ 0 ].X );

  glDrawArrays( RenderMode, 0, bSize );

  glDisableClientState( GL_VERTEX_ARRAY );
  glDisableClientState( GL_COLOR_ARRAY );
  if RenderTextured Then           glDisableClientState( GL_TEXTURE_COORD_ARRAY );
end;


procedure glColor4ub(red, green, blue, alpha: GLubyte);
begin

  PByteArray( @bColor )[ 0 ] := red;
  PByteArray( @bColor )[ 1 ] := green;
  PByteArray( @bColor )[ 2 ] := blue;
  PByteArray( @bColor )[ 3 ] := alpha;

end;

procedure glColor4ubv(v: PGLubyte);
begin
  bColor := PLongWord( v )^;
end;

procedure glColor4f(red, green, blue, alpha: GLfloat);
begin

  PByteArray( @bColor )[ 0 ] := Round( red * 255 );
  PByteArray( @bColor )[ 1 ] := Round( green * 255 );
  PByteArray( @bColor )[ 2 ] := Round( blue * 255 );
  PByteArray( @bColor )[ 3 ] := Round( alpha * 255 );

end;
procedure glColor4b(red, green, blue, alpha: byte);
begin

glColor4f(red/255.0,green/255.0, blue/255.0, alpha/255.0);
end;


procedure glVertex2f(x, y: GLfloat);
  var
    vertex : GLESPVertex;
begin
  if ( not RenderTextured ) and ( bSize = Length( bVertices ) ) Then
    SetLength( bVertices, bSize + 1024 );

  vertex       := @bVertices[ bSize ];
  vertex.X     := x;
  vertex.Y     := y;
  vertex.Z     := 0;
  vertex.Color := bColor;
  INC( bSize );
  if RenderQuad Then
    begin
      INC( newTriangle );
      if newTriangle = 3 Then
        begin
          if bSize = Length( bVertices ) Then
            SetLength( bVertices, bSize + 1024 );
          bVertices[ bSize ] := bVertices[ bSize - 1 ];

          INC( bSize );
        end else
          if newTriangle = 4 Then
            begin
              if bSize = Length( bVertices ) Then
                SetLength( bVertices, bSize + 1024 );
              bVertices[ bSize ] := bVertices[ bSize - 5 ];

              INC( bSize );
              newTriangle := 0;
            end;
    end;
end;

procedure glVertex2fv(v: PGLfloat);
  var
    vertex : GLESPVertex;
begin
  if ( not RenderTextured ) and ( bSize = Length( bVertices ) ) Then
    SetLength( bVertices, bSize + 1024 );

  vertex       := @bVertices[ bSize ];
  vertex.X     := PPoint2D( v ).X;
  vertex.Y     := PPoint2D( v ).Y;
  vertex.Z     := 0;
  vertex.Color := bColor;
  INC( bSize );
  if RenderQuad Then
    begin
      INC( newTriangle );
      if newTriangle = 3 Then
        begin
          if bSize = Length( bVertices ) Then
            SetLength( bVertices, bSize + 1024 );
          bVertices[ bSize ] := bVertices[ bSize - 1 ];

          INC( bSize );
        end else
          if newTriangle = 4 Then
            begin
              if bSize = Length( bVertices ) Then
                SetLength( bVertices, bSize + 1024 );
              bVertices[ bSize ] := bVertices[ bSize - 5 ];

              INC( bSize );
              newTriangle := 0;
            end;
    end;
end;

procedure glVertex3f(x, y, z: GLfloat);
  var
    vertex : GLESPVertex;
begin
  if ( not RenderTextured ) and ( bSize = Length( bVertices ) ) Then
    SetLength( bVertices, bSize + 1024 );

  vertex       := @bVertices[ bSize ];
  vertex.X     := x;
  vertex.Y     := y;
  vertex.Z     := z;
  vertex.Color := bColor;
  INC( bSize );
  if RenderQuad Then
    begin
      INC( newTriangle );
      if newTriangle = 3 Then
        begin
          if bSize = Length( bVertices ) Then
            SetLength( bVertices, bSize + 1024 );
          bVertices[ bSize ] := bVertices[ bSize - 1 ];

          INC( bSize );
        end else
          if newTriangle = 4 Then
            begin
              if bSize = Length( bVertices ) Then
                SetLength( bVertices, bSize + 1024 );
              bVertices[ bSize ] := bVertices[ bSize - 5 ];

              INC( bSize );
              newTriangle := 0;
            end;
    end;
end;


procedure glTexCoord2f(s, t: GLfloat);
begin
  RenderTextured := TRUE;

  if bSize = Length( bVertices ) Then
    SetLength( bVertices, bSize + 1024 );
  bVertices[ bSize ].U := s;
  bVertices[ bSize ].V := t;
end;

procedure glTexCoord2fv(v: PGLfloat);
begin
  RenderTextured := TRUE;

  if bSize = Length( bVertices ) Then
    SetLength( bVertices, bSize + 1024 );
  bVertices[ bSize ].U := PPoint2D( v ).X;
  bVertices[ bSize ].V := PPoint2D( v ).Y;
end;




end.

