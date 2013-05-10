unit SpriteBatch;



interface
uses
  dglopengl,pixmap,VertexBuffer,hge;

  const
    VERTEX_BUFFER_SIZE = 1000;







  type
  TSpriteBatch=class
  private
   invTexWidth,invTexHeight:single;
   color:cardinal;

    FVertArray: PHGEVertexArray;
    FPrim: Integer;
    FCurPrimType: Integer;
    FCurBlendMode: Integer;
    FCurTexture: TTexture;
    FZ:single;

   procedure drawVertex(v1,v2,v3,v4:THGEVertex;tex:TTexture;Blend:integer);
   procedure settriangle(index:integer;x,y:single;u,v:single;color:Color4f);
   procedure renderMesh(const EndScene: Boolean=false);
  public
  constructor Create();
  destructor Destroy();

  procedure drawSprite(Quad:THGEQuad) ;overload;

  procedure drawSprite(Texture:TTexture; x, y:single;blend:integer) ;overload ;
  procedure drawSprite(Texture:TTexture; x,  y,  width,  height,angle:single;srcX,srcY,srcWidth,srcHeight:single;blend:integer) ;overload ;
  procedure drawSprite(Texture:TTexture; x,  y,  width,  height,angle:single;srcX,srcY,srcWidth,srcHeight:single;flipx,flipy:boolean;blend:integer) ;overload ;
  procedure drawSprite(Texture:TTexture; x,  y,  width,  height:single;srcX,srcY,srcWidth,srcHeight:single;blend:integer) ;overload;
  procedure drawSprite(Texture:TTexture; x,  y,  width,  height:single;flipx,flipy:boolean;blend:integer) ;overload ;
  procedure drawSprite(Texture:TTexture; x,  y,  originx,originy,  width,  height,scale,rotation:single;srcX,srcY,srcWidth,srcHeight:single;flipx,flipy:boolean;blend:integer) ;overload ;
  procedure drawSprite(Texture:TTexture; x,  y,  originx,originy,  width,  height,scale,rotation:single;srcX,srcY,srcWidth,srcHeight:single;flipx,flipy:boolean;blend:integer;color:cardinal) ;overload ;




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

procedure TSpriteBatch.drawVertex(v1,v2,v3,v4:THGEVertex;tex:TTexture;Blend:integer);
var
V: array [0..3] of THGEVertex;
begin
v[0]:=v1;
v[1]:=v2;
v[2]:=v3;
v[3]:=v4;

  if Assigned(FVertArray) then
  begin
    if (FCurPrimType <> HGEPRIM_QUADS)
      or (FPrim >= VERTEX_BUFFER_SIZE div HGEPRIM_QUADS)
      or (FCurTexture <> Tex)
      or (FCurBlendMode <> Blend) then
    begin
      renderMesh;
      FCurPrimType := HGEPRIM_QUADS;
      if (FCurBlendMode <> Blend) then
      begin
       Gfx_SetBlendMode(Blend);
       FCurBlendMode:=Blend;
      end;
      if (Tex <> FCurTexture) then
      begin
              Tex.bind();
              FCurTexture := Tex;
           	

      end;
    end;

    Move(V,FVertArray[FPrim * HGEPRIM_QUADS],SizeOf(THGEVertex) * HGEPRIM_QUADS);
    Inc(FPrim);
  end;

end;

procedure TSpriteBatch.drawSprite(Quad:THGEQuad) ;
begin
  if Assigned(FVertArray) then
  begin
    if (FCurPrimType <> HGEPRIM_QUADS)
      or (FPrim >= VERTEX_BUFFER_SIZE div HGEPRIM_QUADS)
      or (FCurTexture <> Quad.Tex)
      or (FCurBlendMode <> Quad.Blend) then
    begin
      renderMesh;
      FCurPrimType := HGEPRIM_QUADS;
      if (FCurBlendMode <> Quad.Blend) then
      begin
       Gfx_SetBlendMode(Quad.Blend);
       FCurBlendMode:=Quad.Blend;
      end;
      if (Quad.Tex <> FCurTexture) then
      begin
        if Assigned(Quad.Tex) then Quad.Tex.bind()        else           glBindTexture(GL_TEXTURE_2D, 0);
          FCurTexture := Quad.Tex;
      end;
    end;

    Move(Quad.V,FVertArray[FPrim * HGEPRIM_QUADS],SizeOf(THGEVertex) * HGEPRIM_QUADS);
    Inc(FPrim);
  end;



end;

procedure TSpriteBatch.drawSprite(Texture:TTexture; x, y:single;blend:integer);
var
fx2,fy2:single;
BEGIN

 fx2 := x + texture.getWidth(true);
 fy2 := y + texture.getHeight(true);

 
    drawVertex(
    CreateHGEVertex(x,y,fz,color,0,0),
    CreateHGEVertex(x,fy2,fz,color,0,1),
    CreateHGEVertex(fx2,fy2,fz,color,1,1),
    CreateHGEVertex(fx2,y,fz,color,1,0),texture,blend);




END;

procedure TSpriteBatch.drawSprite(Texture:TTexture;  x,  y,  width,  height,angle:single; srcX,srcY,srcWidth,srcHeight:single;blend:integer) ;
var
cos,sin,rad,halfWidth,halfHeight:single;
u,v,u2,v2:single;
X1,Y1,X2,Y2,X3,Y3,X4,Y4:SINGLE;

begin



         invTexWidth := 1.0 / texture.getWidth(TRUE);
			   invTexHeight := 1.0 / texture.getHeight(TRUE);



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





    drawVertex(
    CreateHGEVertex(x1,y1,fz,color,u ,v),
    CreateHGEVertex(x2,y2,fz,color,u ,v2),
    CreateHGEVertex(x3,y3,fz,color,u2,v2),
    CreateHGEVertex(x4,y4,fz,color,u2,v),texture,blend);






end;

procedure TSpriteBatch.setTriangle(index:integer;x,y:single;u,v:single;color:Color4f);
begin
end;

procedure TSpriteBatch.drawSprite(Texture:TTexture;  x,  y,originx,originy,  width,  height,scale,rotation:single;srcX,srcY,srcWidth,srcHeight:single;flipx,flipy:boolean;blend:integer) ;
var
worldOriginX,worldOriginY,cos,sin,rad,halfWidth,halfHeight:single;
u,v,u2,v2:single;
worldX,worldY,fx2,fy2,fx,fy,p1x,p1y,p2x,p2y,p3x,p3y,p4x,p4y,tmp,X1,Y1,X2,Y2,X3,Y3,X4,Y4:SINGLE;

begin
      invTexWidth := 1.0 / texture.getWidth(TRUE);
			invTexHeight := 1.0 / texture.getHeight(TRUE);




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

   drawVertex(
    CreateHGEVertex(x1,y1,fz,color,u,v),
    CreateHGEVertex(x2,y2,fz,color,u,v2),
    CreateHGEVertex(x3,y3,fz,color,u2,v2),
    CreateHGEVertex(x4,y4,fz,color,u2,v),texture,blend);






end;

procedure TSpriteBatch.drawSprite(Texture:TTexture;  x,  y,originx,originy,  width,  height,scale,rotation:single;srcX,srcY,srcWidth,srcHeight:single;flipx,flipy:boolean;blend:integer;color:cardinal) ;
var
worldOriginX,worldOriginY,cos,sin,rad,halfWidth,halfHeight:single;
u,v,u2,v2:single;
worldX,worldY,fx2,fy2,fx,fy,p1x,p1y,p2x,p2y,p3x,p3y,p4x,p4y,tmp,X1,Y1,X2,Y2,X3,Y3,X4,Y4:SINGLE;

begin
      invTexWidth := 1.0 / texture.getWidth(TRUE);
			invTexHeight := 1.0 / texture.getHeight(TRUE);




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

   drawVertex(
    CreateHGEVertex(x1,y1,fz,color,u,v),
    CreateHGEVertex(x2,y2,fz,color,u,v2),
    CreateHGEVertex(x3,y3,fz,color,u2,v2),
    CreateHGEVertex(x4,y4,fz,color,u2,v),texture,blend);






end;


procedure TSpriteBatch.drawSprite(Texture:TTexture;  x,  y,  width,  height,angle:single;srcX,srcY,srcWidth,srcHeight:single;flipx,flipy:boolean;blend:integer) ;
var
cos,sin,rad,halfWidth,halfHeight:single;
u,v,u2,v2:single;
tmp,X1,Y1,X2,Y2,X3,Y3,X4,Y4:SINGLE;

begin

        invTexWidth := 1.0 / texture.getWidth(TRUE);
			invTexHeight := 1.0 / texture.getHeight(TRUE);








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

      drawVertex(
    CreateHGEVertex(x1,y1,fz,color,u,v),
    CreateHGEVertex(x2,y2,fz,color,u,v2),
    CreateHGEVertex(x3,y3,fz,color,u2,v2),
    CreateHGEVertex(x4,y4,fz,color,u2,v),texture,blend);







end;

procedure TSpriteBatch.drawSprite(Texture:TTexture;  x,  y,  width,  height:single;flipx,flipy:boolean;blend:integer) ;
var
worldOriginX,worldOriginY,tmp,x1,y1,x2,y2:single;
ax,ay,z,fx2,fy2,u,v,u2,v2:single;

begin
         invTexWidth := 1.0 / texture.getWidth(TRUE);
			invTexHeight := 1.0 / texture.getHeight(TRUE);




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

     drawVertex(
    CreateHGEVertex(worldOriginX,worldOriginY,fz,color,u,v),
    CreateHGEVertex(worldOriginX,fy2         ,fz,color,u,v2),
    CreateHGEVertex(fx2,fy2                  ,fz,color,u2,v2),
    CreateHGEVertex(fx2,worldOriginY,fz,color,u2,v),texture,blend);


end;

procedure TSpriteBatch.drawSprite(Texture:TTexture;  x,  y,  width,  height:single;srcX,srcY,srcWidth,srcHeight:single;blend:integer) ;
var
x1,y1,x2,y2:single;
z,fx2,fy2,u,v,u2,v2:single;



begin
     

      invTexWidth := 1.0 / texture.getWidth(TRUE);
			invTexHeight := 1.0 / texture.getHeight(TRUE);






	     u := srcX * invTexWidth;
		   v := srcY * invTexHeight;
		   u2 := (srcX + srcWidth)  * invTexWidth;
		   v2 := (srcY + srcHeight) * invTexHeight;
       fx2 := x + Width;
		   fy2 := y - Height;


    drawVertex(
    CreateHGEVertex(x  ,y,fz,color,u,v2),
    CreateHGEVertex(X  ,fy2,fz,color,u,v),
    CreateHGEVertex(fx2,fy2,fz,color,u2,v),
    CreateHGEVertex(FX2,y,fz,color,u2,v2),texture,blend);





end;

  procedure TSpriteBatch.beginBatch();
  begin
  if Assigned(FVertArray) then
   begin
      FreeMem(FVertArray);
      FVertArray := nil;
   end;


    GetMem(FVertArray,VERTEX_BUFFER_SIZE * SizeOf(THGEVertex));


    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);

    glVertexPointer    (3, GL_FLOAT,  sizeof (ThgeVertex), @FVertArray[0].x);
    glColorPointer     (4, GL_UNSIGNED_BYTE,  sizeof (ThgeVertex), @FVertArray[0].col);
    glTexCoordPointer  (2, GL_FLOAT,  sizeof (ThgeVertex), @FVertArray[0].tx);
    FCurTexture:=NIL;
  end;

    procedure TSpriteBatch.endBatch();
  begin
     renderMesh(True);
  	 glDisableClientState (GL_VERTEX_ARRAY);
     glDisableClientState (GL_TEXTURE_COORD_ARRAY);
   	 glDisableClientState (GL_COLOR_ARRAY);
     FCurTexture:=NIL;
 end;

  
  procedure 		TSpriteBatch.renderMesh(const EndScene: Boolean=false);
  var
  i:integer;
  vertex:THGEVertex;
  r,g,b,a:byte;
  color:longword;
  begin
   if Assigned(FVertArray) then
  begin
   if (FPrim <> 0) then
   begin
      for i:=0 to (FPrim*4) do// VERTEX_BUFFER_SIZE-1  do
         begin
          vertex:=FVertArray[i];
          color:=vertex.Col;
          COLOR_UnRGBA(color,r,g,b,a);
          vertex.Col:=ARGB(a,b,g,r);
          FVertArray[i]:=vertex;
         end;
         

//      glDrawArrays(GL_QUADS, 0, FPrim shl 2);
      glDrawArrays(GL_QUADS, 0, FPrim *4);
      FPrim := 0;
    end;

    if (EndScene) then
    begin
      FreeMem(FVertArray);
      FVertArray := nil;
    end ;
  end;
 end;




constructor TSpriteBatch.Create();
var
PIndices,n,x,i,j,index,len:integer;
begin
   color:=$FFFFFFFF;
   FVertArray :=nil;
  FPrim := 0;
  FCurPrimType := HGEPRIM_QUADS;
  FCurBlendMode := BLEND_DEFAULT;
  FCurTexture := nil;


end;

destructor TSpriteBatch.Destroy();
begin
if Assigned(FVertArray) then
begin
      FreeMem(FVertArray);
      FVertArray := nil;
end;

end;



end.
