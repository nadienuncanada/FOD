program ej16p2;
const valor_alto=9999;
df=100;
type
fecha=record
  anio:integer;
  mes:integer;
  dia:integer;
end;
emision=record
  f:fecha;
  cod:integer;
  stock:integer;
  ventas:integer;
end;
venta=record
  f:fecha;
  cod:integer;
  cantV:integer;
end;
maestro=file of emision;
detalle=file of venta;
arc_det=array[1..df] of file of venta;
reg_det=array[1..df]of venta;
procedure leer(var det:detalle;var dato:venta);
begin
  if(not(eof(det))) then
    read(det,dato)
  else
    dato.cod:=valor_alto;
end;
procedure ini_det(var det:arc_det;var r_det:reg_det);
var i:integer;s:string;
begin
  for i:=1 to df do begin
    Str(i,s);
    assign(det[i],'det'+s);
    reset(det[i]);
    leer(det[i],r_det[i]);
  end;
end;
procedure cerrar_det(var det:arc_det);
var i:integer;
begin
  for i:= 1 to df do 
    close(det[i]);
end;
procedure Minimo(var det:arc_det;var r_det:reg_det;var min:venta);
var i,actual:integer;
begin
  for i:=1 to df do begin
    if((r_det[i].cod<min.cod)or((r_det[i].cod=min.cod)and(r_det[i].f.anio<min.f.anio)) or((r_det[i].cod=min.cod)and(r_det[i].f.anio=min.f.anio)and(r_det[i].f.mes<min.f.mes))or((r_det[i].cod=min.cod)and(r_det[i].f.anio=min.f.anio)and(r_det[i].f.mes=min.f.mes)and(r_det[i].f.dia<min.f.dia)))then begin
      min:=r_det[i];
      actual:=i; 
    end;
    leer(det[actual],r_det[actual]);
  end;
end;
procedure actualizarMaestro();
var ma:maestro;det:arc_det;r_det:reg_det;min:venta;e,maxV,minV:emision;
begin
maxV.ventas:=-1;
minV.ventas:=valor_alto;
  assign(ma,'maestro');
  reset(ma);
  ini_det(det,r_det);
  Minimo(det,r_det,min);
  while(min.cod<>valor_alto) do begin//mientras el minimo no de valor alto esto corre(es decir el vec de archivos se vacio)
    read(ma,e);//lees el maestro
    while(e.cod<>min.cod) or(e.f.anio<>min.f.anio) or(e.f.mes<>min.f.mes) or (e.f.dia<>min.f.dia) do begin//mientras no estes posisionado en el maestro te moves
      if(e.ventas>maxV.ventas) then //pero antes te fijas si encontras un max ventas totales
        maxV:=e
      else if(e.ventas<minV.ventas) then//o un min ventas totales
       minV:=e;
       read(ma,e);
    end;
    while(e.cod=min.cod) and(e.f.dia=min.f.dia) and (e.f.mes=min.f.mes) and (e.f.anio=min.f.anio) do begin//mientras sigas en el mismo semanario
      e.ventas:=e.ventas-min.cantV;//actualizas la cant de ventas
      e.stock:=e.stock-min.cantV;// y el stock
      Minimo(det,r_det,min);// ves el siguiente minimo si es el mismo sigue actualizando, sino sale y lo guarda
    end;
    if(e.ventas>maxV.ventas) then //antes de guardar ya con el archivo actualizado te fijas si hay un max
      maxV:=e
    else if(e.ventas<minV.ventas) then//o un minimo
      minV:=e;
    seek(ma,filepos(ma)-1);//te moves a donde se tiene q guardar
    write(ma,e);// lo guardas
  end;
  writeln('El semanario que tuvo mas ventas fue: ',maxV.cod);//una vez que salis del llamado de los minimos, informas 
  writeln('El semanario que menos ventas tuvo fue: ',minV.cod);//quien tuvo la maxima cantidad de ventas totales, y el minimo
  close(ma);//cerras el maestro que actualizaste
  cerrar_det(det);//cerrar todos los detalles.
end;
begin
 actualizarMaestro();
end.