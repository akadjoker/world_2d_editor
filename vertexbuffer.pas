
unit VertexBuffer;

interface


uses
 SysUtils,dglOpenGL;



{@exclude}
Const MAX_VERTICES = 4194304;



  type

  Vector2f= record
  x,y:single
  end;
  Vector3f= record
  x,y,z:single
  end;

  Color4f=record
  r,g,b,a:single;
  end;

  TVertex = record
    U, V    : Single;
    Color   : Color4f;
    X, Y, Z : Single;
  end;

  PVertex = ^TVertex;
  TVertexArray = array [0..MAX_VERTICES] of TVertex;
//  PVertexArray = ^TVertexArray;

  


Type TGLXVertexBuffer = Class
  private
   { Private declarations }

   index:integer;
   

    procedure SetMaxVertices(count:integer);

  public
    Vertices  : array of Vector3f;
    TexCoords : array of Vector2f;
    Colors    : array of Color4f;

    countvertex:integer;

    constructor Create(maxSprites:integer);
    Destructor Destroy;


    procedure addVertex(vertex:Vector3f;uv:Vector2f;color:Color4f);overload;
    function  addVertex(x,y,z,u,v:single;color:Color4f):integer;overload;

    procedure setVertex(value:integer;x,y,z,u,v:single;color:Color4f);



    procedure Render(count:integer;Mode: Cardinal );





  end;

  
TextureRegion=object

 u1, v1,
 u2, v2:single;

 procedure init(realw,realh:single;x,y, width, height:single);
end;






function vx2(u,v:single):Vector2f;
function vx3(x,y:single):Vector3f;

function makecolor(r,g,b,a:single):Color4f;

implementation
function makecolor(r,g,b,a:single):Color4f;
begin
result.r:=r;result.g:=g;result.b:=b;result.a:=a;
end;

function vx2(u,v:single):Vector2f;
begin
result.x:=u;
result.y:=v;
end;
function vx3(x,y:single):Vector3f;
begin
result.x:=x;
result.y:=y;
result.z:=0.0;
end;


 procedure TextureRegion.init(realw,realh:single;x,y, width, height:single);
 begin
        u1 := x / realw;
        v1 := y / realh;
        u2 := u1 + width / realw;
        v2 := v1 + height / realh;

 end;


// Class TGLXVertexBuffer
//==============================================================================
constructor TGLXVertexBuffer.Create(maxSprites:integer);
begin
SetMaxVertices(maxSprites);

end;

//------------------------------------------------------------------------------
destructor TGLXVertexBuffer.Destroy;
begin
     setlength(Vertices ,0);
     setlength(TexCoords,0);
     setlength(Colors,0);


end;



//------------------------------------------------------------------------------
procedure TGLXVertexBuffer.SetMaxVertices(count:integer);
begin
    countvertex :=count;
     setlength(Vertices ,countvertex*sizeof(Vector3f));
     setlength(TexCoords,countvertex*sizeof(Vector2f));
     setlength(Colors   ,countvertex*sizeof(Color4f));

end;
procedure TGLXVertexBuffer.addVertex(vertex:Vector3f;uv:Vector2f;color:Color4f);
begin
self.Vertices[index]:=vertex;
self.TexCoords[index]:=uv;
self.Colors[index]:=color;
inc(index);
end;



procedure TGLXVertexBuffer.setVertex(value:integer;x,y,z,u,v:single;color:Color4f);

begin
Vertices[value].x:=x;
Vertices[value].y:=y;
Vertices[value].z:=z;

TexCoords[value].x:=u;
TexCoords[value].y:=v;

Colors[value]:=color;

end;

function TGLXVertexBuffer.addVertex(x,y,z,u,v:single;color:Color4f):integer;

begin
Vertices[index].x:=x;
Vertices[index].y:=y;
Vertices[index].z:=z;
TexCoords[index].x:=u;
TexCoords[index].y:=v;
Colors[index]:=color;
result:=index;
inc(index);


end;



//------------------------------------------------------------------------------


procedure TGLXVertexBuffer.Render(count:integer;Mode: Cardinal);
begin

  //
  //


    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);



    glVertexPointer    (3, GL_FLOAT, sizeof(Vector3f), @Vertices[0]);
    glColorPointer     (4, GL_FLOAT, sizeof(Color4f), @Colors[0]);
    glTexCoordPointer  (2, GL_FLOAT, sizeof(Vector2f), @TexCoords[0]);

      {

    glVertexPointer    (3, GL_FLOAT,0, @Vertices[0]);
    glTexCoordPointer  (2, GL_FLOAT, 0, @TexCoords[0]);
    glColorPointer     (4, GL_FLOAT, 0, @Colors[0]);
     }



       glDrawArrays(Mode, 0, count);




          glDisableClientState(GL_VERTEX_ARRAY);
          glDisableClientState(GL_TEXTURE_COORD_ARRAY);
          glDisableClientState(GL_COLOR_ARRAY);




end;
















end.
