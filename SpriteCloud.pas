unit SpriteCloud;


interface
uses
   dglopengl,pixmap,VertexBuffer,HGE;


  type
  TSpriteCloud=class
  private
   buffer:TGLXVertexBuffer;
   bufferIndex, numSprites:integer;
   maxsprites:integer;
   idx:integer;
   invTexWidth,invTexHeight:single;
   fTexture:TTexture;
   procedure settriangle(index:integer;x,y:single;u,v:single;color:Color4f);
  public
  constructor Create(tex:TTexture);
  destructor Destroy();

  procedure drawSprite(q:THGEQuad) ;overload;

  procedure drawSprite( x,  y,  width,  height,angle:single;srcX,srcY,srcWidth,srcHeight:single) ;overload ;
  procedure drawSprite( x,  y,  width,  height,angle:single;srcX,srcY,srcWidth,srcHeight:single;flipx,flipy:boolean) ;overload ;
  procedure drawSprite( x,  y,  width,  height:single;srcX,srcY,srcWidth,srcHeight:single) ;overload;
  procedure drawSprite( x,  y,  width,  height:single;flipx,flipy:boolean) ;overload ;
  procedure drawSprite( x,  y,originx,originy,  width,  height,scale,rotation:single;srcX,srcY,srcWidth,srcHeight:single;flipx,flipy:boolean) ;overload ;




  procedure beginBatch();
  procedure endBatch();

  end;

implementation


FUNCTION FSIN(S:SINGLE):SINGLE;
begin
result:=sin(s);
end;
FUNCTION FCOS(S:SINGLE):SINGLE;
begin
result:=cos(s);
end;

procedure TSpriteCloud.drawSprite(q:THGEQuad) ;
var
X1,Y1,X2,Y2,X3,Y3,X4,Y4:SINGLE;
u1,v1,u2,v2,u3,v3,u4,v4:SINGLE;
color:Color4f;
begin

x1:=q.v[0].X; y1:=q.v[0].y;
x2:=q.v[1].X; y2:=q.v[1].y;
x3:=q.v[2].X; y3:=q.v[2].y;
x4:=q.v[3].X; y4:=q.v[3].y;

u1:=q.v[0].tx; v1:=q.v[0].ty;
u2:=q.v[1].tx; v2:=q.v[1].ty;
u3:=q.v[2].tx; v3:=q.v[2].ty;
u4:=q.v[3].tx; v4:=q.v[3].ty;

color.r:=1;
color.g:=1;
color.b:=1;
color.a:=1;





       setTriangle(idx,x1,y1    ,u1,v1,color);inc(idx);
       setTriangle(idx,x2,y2    ,u2,v2,color);inc(idx);
       setTriangle(idx,x3,y3    ,u3,v3,color);inc(idx);

       setTriangle(idx,x3,y3 ,   u3,v3,color);inc(idx);
       setTriangle(idx,x4,y4 ,   u4,v4,color);inc(idx);
       setTriangle(idx,x1,y1 ,   u1,v1,color);inc(idx);



      inc(  numSprites);



end;


procedure TSpriteCloud.drawSprite( x,  y,  width,  height,angle:single; srcX,srcY,srcWidth,srcHeight:single) ;
var
cos,sin,rad,halfWidth,halfHeight:single;
u,v,u2,v2:single;
X1,Y1,X2,Y2,X3,Y3,X4,Y4:SINGLE;
color:Color4f;
begin
color.r:=1;
color.g:=1;
color.b:=1;
color.a:=1;




         halfWidth  := width / 2;
         halfHeight := height / 2;


         rad := angle* (PI / 180);
         cos := fcos(rad);
         sin := fsin(rad);
                
         x1 := -halfWidth * cos - (-halfHeight) * sin;
         y1 := -halfWidth * sin + (-halfHeight) * cos;
         x2 := halfWidth * cos - (-halfHeight) * sin;
         y2 := halfWidth * sin + (-halfHeight) * cos;

         x3 := halfWidth * cos - halfHeight * sin;
         y3 := halfWidth * sin + halfHeight * cos;
         x4 := -halfWidth * cos - halfHeight * sin;
         y4 := -halfWidth * sin + halfHeight * cos;


        x1 :=x1+ x;
        y1 :=y1+ y;
        x2 :=x2+ x;
        y2 :=y2+ y;
        x3 :=x3+ x;
        y3 :=y3+ y;
        x4 :=x4+ x;
        y4 :=y4+ y;



	     u := srcX * invTexWidth;
		   v := srcY * invTexHeight;
		   u2 := (srcX + srcWidth)  * invTexWidth;
		   v2 := (srcY + srcHeight) * invTexHeight;


       setTriangle(idx,x1,y1    ,u,v,color);inc(idx);
       setTriangle(idx,x2,y2  ,u,v2,color);inc(idx);
       setTriangle(idx,x3,y3,u2,v2,color);inc(idx);

       setTriangle(idx,x3,y3 ,u2,v2,color);inc(idx);
       setTriangle(idx,x4,y4   ,u2,v,color);inc(idx);
       setTriangle(idx,x1,y1     ,u ,v,color);inc(idx);





      inc(  numSprites);
end;

procedure TSpriteCloud.setTriangle(index:integer;x,y:single;u,v:single;color:Color4f);
begin
           BUFFER.Vertices[index]  :=vx3(x,y);
           buffer.TexCoords[index]:=vx2(u,v);
           buffer.Colors[index]   :=color;
end;

procedure TSpriteCloud.drawSprite( x,  y,originx,originy,  width,  height,scale,rotation:single;srcX,srcY,srcWidth,srcHeight:single;flipx,flipy:boolean) ;
var
worldOriginX,worldOriginY,cos,sin,rad,halfWidth,halfHeight:single;
u,v,u2,v2:single;
worldX,worldY,fx2,fy2,fx,fy,p1x,p1y,p2x,p2y,p3x,p3y,p4x,p4y,tmp,X1,Y1,X2,Y2,X3,Y3,X4,Y4:SINGLE;
color:Color4f;
begin
color.r:=1;
color.g:=1;
color.b:=1;
color.a:=1;




		// top left and bottom right corner points relative to origin
		worldOriginX := x + originX;
		worldOriginY := y + originY;
		fx := - originX;
		fy := - originY;
		fx2 :=  width - originX;
		fy2 :=  height - originY;

		// scale
    IF (scale<>1.0) THEN
    BEGIN
 		fx :=fx* scale;
		fy :=fy* scale;
		fx2 :=fx2* scale;
		fy2 :=fy2* scale;
    END;

		// construct corner points, start from top left and go counter clockwise
		 p1x := fx;
		 p1y := fy;
		 p2x := fx;
		 p2y := fy2;
		 p3x := fx2;
		 p3y := fy2;
		 p4x := fx2;
		 p4y := fy;


     IF (rotation<>0) then
     begin
         rad := rotation* (PI / 180);
         cos := fcos(rad);
         sin := fsin(rad);

		 x1 := cos * p1x - sin * p1y;
		 y1 := sin * p1x + cos * p1y;

		 x2 := cos * p2x - sin * p2y;
		 y2 := sin * p2x + cos * p2y;

		 x3 := cos * p3x - sin * p3y;
		 y3 := sin * p3x + cos * p3y;

		 x4 := cos * p4x - sin * p4y;
		 y4 := sin * p4x + cos * p4y;
      end else
      begin
      x1 := p1x;
			y1 := p1y;

			x2 := p2x;
			y2 := p2y;

			x3 := p3x;
			y3 := p3y;

			x4 := p4x;
			y4 := p4y;

      end;


		x1 :=x1+ worldOriginX;
    y1 :=y1+ worldOriginY;
		x2 :=x2+ worldOriginX;
    y2 :=y2+ worldOriginY;
		x3 :=x3+ worldOriginX;
    y3 :=y3+ worldOriginY;
		x4 :=x4+ worldOriginX;
    y4 :=y4+ worldOriginY;








	     u := srcX * invTexWidth;
		   v := srcY * invTexHeight;
		   u2 := (srcX + srcWidth)  * invTexWidth;
		   v2 := (srcY + srcHeight) * invTexHeight;


   if( flipX ) then
    begin
			 tmp := u;u := u2;u2 := tmp;
   end;

		if( flipY ) then
    begin
			 tmp := v;v := v2;v2 := tmp;
		end;



       setTriangle(idx,x1,y1    ,u,v,color);inc(idx);
       setTriangle(idx,x2,y2  ,u,v2,color);inc(idx);
       setTriangle(idx,x3,y3,u2,v2,color);inc(idx);

       setTriangle(idx,x3,y3 ,u2,v2,color);inc(idx);
       setTriangle(idx,x4,y4   ,u2,v,color);inc(idx);
       setTriangle(idx,x1,y1     ,u ,v,color);inc(idx);





      inc(  numSprites);
end;



procedure TSpriteCloud.drawSprite( x,  y,  width,  height,angle:single;srcX,srcY,srcWidth,srcHeight:single;flipx,flipy:boolean) ;
var
cos,sin,rad,halfWidth,halfHeight:single;
u,v,u2,v2:single;
tmp,X1,Y1,X2,Y2,X3,Y3,X4,Y4:SINGLE;
color:Color4f;
begin
color.r:=1;
color.g:=1;
color.b:=1;
color.a:=1;







         halfWidth  := width / 2;
         halfHeight := height / 2;


         rad := angle* (PI / 180);
         cos := fcos(rad);
         sin := fsin(rad);

         x1 := -halfWidth * cos - (-halfHeight) * sin;
         y1 := -halfWidth * sin + (-halfHeight) * cos;
         x2 := halfWidth * cos - (-halfHeight) * sin;
         y2 := halfWidth * sin + (-halfHeight) * cos;

         x3 := halfWidth * cos - halfHeight * sin;
         y3 := halfWidth * sin + halfHeight * cos;
         x4 := -halfWidth * cos - halfHeight * sin;
         y4 := -halfWidth * sin + halfHeight * cos;


        x1 :=x1+ x;
        y1 :=y1+ y;
        x2 :=x2+ x;
        y2 :=y2+ y;
        x3 :=x3+ x;
        y3 :=y3+ y;
        x4 :=x4+ x;
        y4 :=y4+ y;



	     u := srcX * invTexWidth;
		   v := srcY * invTexHeight;
		   u2 := (srcX + srcWidth)  * invTexWidth;
		   v2 := (srcY + srcHeight) * invTexHeight;


   if( flipX ) then
    begin
			 tmp := u;u := u2;u2 := tmp;
   end;

		if( flipY ) then
    begin
			 tmp := v;v := v2;v2 := tmp;
		end;



       setTriangle(idx,x1,y1    ,u,v,color);inc(idx);
       setTriangle(idx,x2,y2  ,u,v2,color);inc(idx);
       setTriangle(idx,x3,y3,u2,v2,color);inc(idx);

       setTriangle(idx,x3,y3 ,u2,v2,color);inc(idx);
       setTriangle(idx,x4,y4   ,u2,v,color);inc(idx);
       setTriangle(idx,x1,y1     ,u ,v,color);inc(idx);





      inc(  numSprites);
end;

procedure TSpriteCloud.drawSprite( x,  y,  width,  height:single;flipx,flipy:boolean) ;
var
worldOriginX,worldOriginY,tmp,x1,y1,x2,y2:single;
ax,ay,z,fx2,fy2,u,v,u2,v2:single;
color:Color4f;
begin
color.r:=1;
color.g:=1;
color.b:=1;
color.a:=1;


      		worldOriginX := x - (width / 2);
		      worldOriginY := y - (height/ 2);


	     u := 0.0;
		   v := 0.0;
		   u2 := 1.0;
		   v2 := 1.0;
       fx2 := worldOriginX + Width;
		   fy2 := worldOriginy + Height;


       
   if( flipX ) then
    begin
			 tmp := u;u := u2;u2 := tmp;
   end;

		if( flipY ) then
    begin
			 tmp := v;v := v2;v2 := tmp;
		end;


       setTriangle(idx,worldOriginX,worldOriginY    ,u,v,color);inc(idx);
       setTriangle(idx,worldOriginX,fy2  ,u,v2,color);inc(idx);
       setTriangle(idx,fx2,fy2,u2,v2,color);inc(idx);
       setTriangle(idx,fx2,fy2 ,u2,v2,color);inc(idx);
       setTriangle(idx,fx2,worldOriginY  ,u2,v,color);inc(idx);
       setTriangle(idx,worldOriginX,worldOriginY     ,u ,v,color);inc(idx);
      inc(  numSprites);
end;

procedure TSpriteCloud.drawSprite( x,  y,  width,  height:single;srcX,srcY,srcWidth,srcHeight:single) ;
var
x1,y1,x2,y2:single;
z,fx2,fy2,u,v,u2,v2:single;
color:Color4f;


begin
color.r:=1;
color.g:=1;
color.b:=1;
color.a:=1;




	     u := srcX * invTexWidth;
		   v := srcY * invTexHeight;
		   u2 := (srcX + srcWidth)  * invTexWidth;
		   v2 := (srcY + srcHeight) * invTexHeight;
       fx2 := x + Width;
		   fy2 := y - Height;



       setTriangle(idx,x,y    ,u,v,color);inc(idx);
       setTriangle(idx,x,fy2  ,u,v2,color);inc(idx);
       setTriangle(idx,fx2,fy2,u2,v2,color);inc(idx);
       setTriangle(idx,fx2,fy2 ,u2,v2,color);inc(idx);
       setTriangle(idx,fx2,y   ,u2,v,color);inc(idx);
       setTriangle(idx,x,y     ,u ,v,color);inc(idx);








      inc(  numSprites);


end;

  procedure TSpriteCloud.beginBatch();
  begin
  numSprites:=0;
  bufferIndex:= 0;
  idx:=0;
  fTexture.bind();


  end;
  procedure TSpriteCloud.endBatch();
  var
  spritesInBatch:integer;
  begin
//  spritesInBatch := idx div 20 ;


  buffer.Render( numSprites * 6,GL_TRIANGLES);

//  buffer.Render( spritesInBatch * 6 ,GL_TRIANGLES);

//  writeln(spritesInBatch * 6);
 // buffer.Render( spritesInBatch * 6,GL_TRIANGLES);
//  buffer.Render( 6,GL_TRIANGLES);


//  buffer.Render( bufferIndex ,GL_TRIANGLES);




 // idx:=0;
  numSprites:=0;
  end;


constructor TSpriteCloud.Create(tex:TTexture);
var
PIndices,n,x,i,j,index,len:integer;
begin
  idx:=0;
  maxsprites:=1000*4;
  buffer:=TGLXVertexBuffer.Create(maxsprites);
  numSprites:=0;
  bufferIndex:=0;
  fTexture:=tex;
  invTexWidth :=1.0/tex.GetWidth(true);
  invTexHeight:=1.0/tex.GetHeight(true);
end;

destructor TSpriteCloud.Destroy();
begin
buffer.Destroy;
end;


end.
