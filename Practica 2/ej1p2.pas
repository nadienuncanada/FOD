program ej1p2;
const
  valor_alto=9999;
type
str=string[12];
empleados=record
  cod:integer;
  nom:str;
  monto:real;
end;
archivo=file of empleados;
procedure leer(var arch:archivo;var dato:empleados);
begin
  if(not(EOF(arch))) then
    read(arch,dato)
  else
    dato.cod:=valor_alto;
end;
function leer_empleado(var e:empleados):empleados;
begin
  writeln('Ingrese cod: ');
  readln(e.cod);
  if(e.cod<>-1) then begin
    writeln('Ingrese nombre: ');
    readln(e.nom);
    writeln('Ingrese monto: ');
    readln(e.monto);
  end;
  leer_empleado:=e;
end;
procedure detalle();
var arch:archivo;e:empleados;nom:str;
begin
  writeln('Ingrese Nombre del Archivo Detalle: ');
  readln(nom);
  assign(arch,nom);
  rewrite(arch);
  e:=leer_empleado(e);
  while(e.cod<>-1) do begin
    write(arch,e);
    e:=leer_empleado(e);
  end;
  close(arch);
  writeln('Archivo detalle creado!');
end;
procedure maestro();
var archD,archM:archivo;nom:str;reg:empleados;actual:empleados;tot:real;
begin
  writeln('Ingrese Nombre de Archivo Maestro: ');//el nuevo
  readln(nom);
  assign(archM,nom);
  writeln('Ingrese Nombre de Archivo Detalle: ');//ya creado
  readln(nom);
  assign(archD,nom);
  rewrite(archM);//el que vamos a crear
  reset(archD);//ya creado

  leer(archD,reg);//leo archivo ya creado
  while(reg.cod<>valor_alto) do begin//mientras no sea el final
    actual:=reg;//creo una copia o actualiza cod
    tot:=0;
    while(actual.cod=reg.cod) do begin//mientras siga en el
      tot:=tot+reg.monto;//actualizo monto
      leer(archD,reg);//leo siguiente
    end;
    actual.monto:=tot;
    write(archM,actual);//aca sali y guarde en el nuevo 1 solo con todos los datos juntos
  end;
  close(archD);
  close(archM);
  writeln('Archivo Clonado con dato sin repetir!');
end;
procedure abrir_archivo(var arch:archivo);
var nom:str;
begin
  writeln('Ingrese Nombre de Archivo a Abrir: ');
  readln(nom);
  assign(arch,nom);
  reset(arch);
end;
procedure Imprimir();
var e:empleados;arch:archivo;
begin
  abrir_archivo(arch);
  while(not eof(arch)) do begin
  read(arch,e);
  writeln('Codigo: ',e.cod,' Nombre: ', e.nom,' Monto: ',e.monto:0:2);
  writeln(' ');
  end;
  close(arch);
end;
procedure Menu();
var op:integer;
begin
  writeln('1 para Crear Archivo Detalle-2 para Crear Archivo Maestro- 3 para cerrar');
  readln(op);
  if(op!=1) then begin
    detalle();
  end
  else if(op=2)then begin
    maestro();
  end
  else if(op=3) then begin
    writeln('Gracias!');
end
  else begin
    writeln('Ingrese Opcion Valida');
    Menu();
  end;
end;
begin
Menu();
Imprimir();
//Imprimir();
end.