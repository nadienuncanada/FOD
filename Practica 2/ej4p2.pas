program ej4p2;
const valor_alto=9999;
df=5;
type
logs=record
  cod:integer;
  fe:integer;
  tise:integer;
end;
ma=record
  cod:integer;
  fe:integer;
  titot:integer;
end;
detalle=file of logs;//archivo detalle
maestro=file of ma;//archivo maestro
arc_det=array[1..df] of file of logs;//array de archivos detalle
reg_det=array[1..df] of logs;//array de registros de cada archivo del array de detalle
procedure leer(var arch:detalle;var dato:logs);
begin
  if(not(eof(arch))) then
    read(arch,dato)
  else 
    dato.cod:=valor_alto;
end;
procedure minimo(var r_det:reg_det;var min:logs;var deta:arc_det);//r_det=,min=el dato minimo,deta=elarchivo  
var i,actual:integer;
begin
 min.cod:=valor_alto;
 for i:=1 to df do begin
    if (r_det[i].cod<min.cod) then begin//para ver el minimo
        min:=r_det[i];
        actual:=i;
      end;
      if(r_det[i].cod=min.cod) then begin//si encontras el mismo minimo
        if(r_det[i].fe<min.fe) then begin//tener que ver cual es la menor fecha. Esto es necesario porque hay muchos detalles con distintas fechas
          min:=r_det[i];
          actual:=i;
        end;
      end;
    if(min.cod <> valor_alto) then//chekea que no se vuelvan todos minimo
    leer(deta[actual],r_det[actual]);
  end;
end;
procedure ini_det(var deta:arc_det;var r_det:reg_det);
var i:integer;a:string;
begin
  writeln('hola');
  for i:=1 to df do begin
    Str(i,a);
    assign(deta[i],'det'+a);
    reset(deta[i]);
  end;
  writeln('chau');
end;
procedure clo_det(var deta:arc_det);
var i:integer;
begin
  for i:=1 to df do
  close (deta[i]);
end;

procedure crearMaestro(var arch:maestro;var deta:arc_det);
var r_det:reg_det;min:logs;aux:ma;
begin
  ini_det(deta,r_det);//inicializa el vector de minimos de los archivos de detalles
  assign(arch,'maestro.txt');//asigno maestro
  rewrite(arch);//voy a escribir solamente en el maestro;
  minimo(r_det,min,deta);//mando el vector de detalles,el minimo y el array de detalles
  while(min.cod<>valor_alto) do begin
    aux.cod:=min.cod;
    while(aux.cod=min.cod) do begin//itera hasta que cambien de cod(osea de persona)
      aux.fe:=min.fe;
      aux.titot:=0;
      while(aux.fe=min.fe) do begin//itera hasta que cambie la fecha acumulando horas
        aux.titot:=aux.titot+min.tise;
        minimo(r_det,min,deta);
      end;
      write(arch,aux); //guardo en el maestro el cod con la horas acumuladas,
    end; 
  end;
  close(arch);
  clo_det(deta);
end;
var arch:maestro;deta:arc_det;
begin
crearMaestro(arch,deta);
end.