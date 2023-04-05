program ej17p2;
const valor_alto=9999;
df=10;
type
str=string[20];
fecha=record
  anio:integer;
  mes:integer;
  dia:integer;
end;
motos=record
  cod:integer;
  nom:str;
  desc:str;
  modelo:str;
  marca:str;
  stock:integer;
end;
ventas=record
  cod:integer;
  pre:real;
  f:fecha;
end;
maestro= file of motos;
detalle= file of ventas;
arc_det=array[1..df] of file of ventas;
reg_det=array [1..df] of ventas;
procedure leer(var deta:detalle;var dato:ventas);
begin
if(not(eof(deta))) then
  read(deta,dato)
else
  dato.cod:=valor_alto;
end;
procedure ini_det(var deta:arc_det;var r_det:reg_det);
var i:integer;//s:string;
begin
  for i:=1 to df do begin
    // Str(i,s);
    assign(deta[i],'det');
    reset(deta[i]);
    leer(deta[i],r_det[i]);
  end;
end;
procedure cerrar_det(var deta:arc_det);
var i:integer;
begin
  for i:=1 to df do 
    close(deta[i]);
end;
procedure Minimo(var deta:arc_det;var r_det:reg_det;var min:ventas);
var i,actual:integer;
begin
  for i:=1 to df do begin
    if(r_det[i].cod<min.cod) then begin
      min:=r_det[i];
      actual:=i;
    end;
  end;
  leer(deta[actual],r_det[actual]);
end;
procedure actualizarMaestro();
var ma:maestro;deta:arc_det;r_det:reg_det;min:ventas;m:motos;masV,masVact,maxCod:integer;
begin
  ini_det(deta,r_det);
  assign(ma,'maestro17');
  reset(ma);
  Minimo(deta,r_det,min);
  masVact:=-1;
  while(min.cod<>valor_alto) do begin 
    read(ma,m);
    masV:=0;
    while(m.cod<>min.cod) do 
      read(ma,m);
    while(min.cod=m.cod) do begin
      m.stock:=m.stock-1;
      masV:=masV+1;
    end;
    if(masV>masVact) then begin;
      maxCod:=m.cod;
      masVact:=masV;
    end;
    seek(ma,filepos(ma)-1);
    write(ma,m);
  end;
  writeln('Codigo de la moto mas vendida: ',masVact);
  close(ma);
  cerrar_det(deta);
end;  
begin
 actualizarMaestro();
end.