unit pixmap;




interface

const
SAVE_TYPE_TGA = 0;
SAVE_TYPE_BMP = 1;
SAVE_TYPE_DDS = 2;
SAVE_TYPE_PNG = 3 ;

type
PPixmap=^TPixmap;
TPixmap=packed record
   width:integer;
	 height:integer;
	 format:integer;
   pixels:array of byte;
end;

PBuffer=^Tdata;
Tdata=array of byte;

    const
     dllname='pixmap.dll';


               function  SOIL_load_image
	(
		const filename:pchar;
		var width,height, channels:integer;
		force_channels:integer):PBuffer;cdecl; external dllname ;





function  pixmap_get_pixel(const pixmap:PPixmap;x,y:integer):integer;cdecl; external dllname;
procedure pixmap_set_pixel(const pixmap:PPixmap;x,y,color:integer);cdecl; external dllname ;
procedure pixmap_draw_line(const pixmap:PPixmap;x,y,x2,y2,color:integer);cdecl; external dllname ;

function  pixmap_new( width,  height,  format:integer):PPixmap;cdecl; external dllname ;

function pixmap_rescale(map:PPixmap; width,  heigh:integer):PPixmap;cdecl; external dllname ;

function  pixmap_load(const filename:PAnsiChar; req_format:integer):PPixmap;cdecl; external dllname;
function  pixmap_save(map:PPixmap;const filename:PAnsiChar; req_format:integer):boolean;cdecl; external dllname;

function  pixmap_loadmemory(buffer:pointer;size:integer;req_format:integer):PPixmap;cdecl; external dllname ;

procedure		pixmap_draw_rect   (const Pixmap:Ppixmap;x,y,width,height, col:integer);cdecl; external dllname ;
procedure		pixmap_draw_circle (const Pixmap:Ppixmap;x,y,radius,col:integer);cdecl; external dllname ;
procedure   pixmap_fill_rect   (const Pixmap:Ppixmap;x,y,width,height, col:integer);cdecl; external dllname ;
procedure	  pixmap_fill_circle (const Pixmap:Ppixmap;x,y,radius,col:integer);cdecl; external dllname ;


function  pixmap_load_power_of2(const filename:PAnsiChar; req_format:integer):PPixmap;cdecl; external dllname ;
function  pixmap_loadmemory_power_of2(buffer:pointer;size:integer;req_format:integer):PPixmap;cdecl; external dllname ;


procedure pixmap_draw_pixmap(const src_pixmap:PPixmap;
 								             const  dst_pixmap:PPixmap;
								    src_x,  src_y,  src_width,  src_height,
								    dst_x,  dst_y,  dst_width,  dst_height:integer);cdecl; external dllname ;

procedure pixmap_free(pixmap:PPixmap);cdecl; external dllname ;


implementation

end.
