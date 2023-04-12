program ej15p2;
const valor_alto=9999;
type
ONG=record
  codP:integer;
  // nom:str;
  codL:integer;
  sLuz:integer;
  sGas:integer;
  dChapa:integer;
  sAgua:integer;
  sSanitario:integer;
end;
avances=record
  codP:integer;
  codL:integer;
  cLuz:integer;
  cGas:integer;
  vConstr:integer;
  vConAgua:integer;
  vConGas:integer;
  eSanitario:integer;
end;
maestro=file of ONG;
detalle=file of avances;
arc_det=array[1..10] of file of avances;
reg_det=array[1..10] of avances;
procedure leer(var arc:detalle;var dato:avances);
begin
  if(not(eof(arc))) then
    read(arc,dato)
  else
    dato.codP:=valor_alto;
end;
procedure ini_det(var deta:arc_det;var r_det:reg_det);
var i:integer;s:string;
begin
  for i:=1 to 10 do begin
    Str(i,s);
    assign(deta[i],'det'+s);
    reset(deta[i]);
    leer(deta[i],r_det[i]);
  end;
end;
procedure cerrar_det(var deta:arc_det);
var i:integer;
begin
  for i:=1 to 10 do 
    close(deta[i]);
end;
procedure Minimo(var det:arc_det;var r_det:reg_det;var min:avances);
var i,actual:integer;
begin
  min.codP:=valor_alto;
  for i:=1 to 10 do begin
    if(r_det[i].codP<min.codP) then begin
      min:=r_det[i];
      actual:=i;
    end;
    if(r_det[i].codP=min.codP) then 
      if(r_det[i].codL<min.codL) then begin
        min:=r_det[i];
        actual:=i;
      end;
    leer(det[actual],r_det[actual]);
  end;
end;
procedure actualizarMaestro();
var ma:maestro;det:arc_det;r_det:reg_det;min:avances;o:ong;sinChapa:integer;
begin
  assign(ma,'maestro15');
  reset(ma);
  ini_det(det,r_det);
  Minimo(det,r_det,min);
  sinChapa:=0;
  while(min.codP<>valor_alto) do begin
    read(ma,o);
    while(o.codP<>min.codP) and (o.codL<>min.codL)do begin  
      if(o.dChapa=0) then
        sinChapa:=sinChapa+1;
      read(ma,o);
      o.sLuz:=o.sLuz-min.cLuz;
      o.sAgua:=o.sAgua-min.vConAgua;
      o.sGas:=o.sGas-min.vConGas;
      o.sSanitario:=o.sSanitario-min.eSanitario;
      o.dChapa:=o.dChapa-min.vConstr;
     if(o.dChapa=0) then
      sinChapa:=sinChapa+1;
      Minimo(det,r_det,min);
      seek(ma,filepos(ma)-1);
      write(ma,o);
    end;
    writeln('Localidad sin viviendas de chapa: ',sinChapa);
    close(ma);
    cerrar_det(det);
  end;
end;
begin
 actualizarMaestro();
end.