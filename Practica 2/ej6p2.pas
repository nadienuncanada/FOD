program ej6p2;
const df=10;
valor_alto=9999;
type
str=string[20];
informacion=record
  codL:integer;
  codC:integer;
  canCA:integer;
  canCN:integer;
  canCR:integer;
  canCF:integer;
end;
datomaestro=record
  codL:integer;
  nomL:str;
  codC:integer;
  nomC:str;
  canCA:integer;
  canCN:integer;
  canCR:integer;
  canCF:integer;
end;
maestro=file of datomaestro;
detalle=file of informacion;
arc_det=array[1..df] of file of informacion;
reg_det=array[1..df] of informacion;
procedure leer(var arc:detalle;var dato:informacion);
begin
  if(not(eof(arc))) then 
    read(arc,dato)
  else
  dato.codL:=valor_alto;
end;
procedure minimo(var deta:arc_det;var r_det:reg_det;var min:informacion);
var i,actual:integer;
begin
  min.codL:=valor_alto;
  for i:=1 to df do begin
    if(r_det[i].codL<min.codL) then begin//voy viendo los minimos
      min:=r_det[i];
      actual:=i;
    end;
    if(r_det[i].codL=min.codL) then// si mientras recorro consigo el mismo minimo tengo que buscar la segunda seccion 
      if(r_det[i].codC<min.codC) then begin// es decir busco el que menor codigo de cepa tenga. Si tiene menor codC se vuelve min sino el otro tenia un codC menor
        min:=r_det[i];
        actual:=i;
      end;
      leer(deta[actual],r_det[actual]);
  end;
end;
procedure ini_det(var deta:arc_det;var r_det:reg_det);// inicializo todos los archivos del vector;
var i:integer;s:string;
begin
 for i:=1 to df do begin
  //Str(i,s);
  assign(arc[i],'det'+s);
  reset(arc[i]);
  leer(arc[i],r_det[i]);// de paso cargo el vector con el primer dato de los archivos en el array reg_det.
 end;
end;
procedure actualizarMaestro(var deta:arc_det;var r_det:reg_det);
var min:informacion;ma:maestro;aux:datomaestro;
begin
  ini_det(deta,r_det);
  assign(ma,'maestro');
  reset(ma);
  minimo(deta,r_det,min);
  while(min.codL<>valor_alto) do begin
    read(ma,aux);
    while(aux.codL=min.codL and aux.codC=min.codC) do begin
        aux.codC:=min.codC;
        aux.canCF:=aux.canCF+min.canCF;//fallecidos se le suman 
        aux.canCR:=aux.canCN+min.canCR;//recuperados se le suman
        aux.canCA:=min.canCA;//activos se actualizan
        aux.canCN:=min.canCN;//nuevos se actualizan
        minimo(deta,r_det,min);
    end;
    while(aux.codL<>aux) do 
       read(ma,aux);
      seek(ma,filepos(ma)-1);
      write(ma,aux);
  end;
  close(ma);
end;
procedure informar50 ();
var ma:maestro;aux:datoaestro;cant:integer;
begin
  cant:=0;
  assign(ma,'maestro');
  reset(ma);
  while not(eof(ma)) do begin
    read(ma,aux);
    if(aux.canCA=50) do 
      cant:=cant +1;
  end;
  writeln(cant);
end;

var deta:arc_det;r_det:reg_det;
begin
actualizarMaestro(deta,r_det);
informar50();
end.