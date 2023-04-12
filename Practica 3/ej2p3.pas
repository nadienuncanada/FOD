program ej2p3;
type
str=string[20];
asistentes=record
  nro:integer;
  ape:str; 
  dni:integer;
end;
archivo=file of asistentes;
procedure crear_archivo();
var arch:archivo;a:asistentes;
begin
  assign(arch,'archivo2');
  rewrite(arch);
  a.nro:=0;
  while(a.nro<>-1) do begin
    writeln('Ingrese Numero de Asistente: ');
      readln(a.nro);
    if(a.nro<>-1) then begin
      writeln('Inmgrese Apellido de Asistente: ');
        readln(a.ape);
      writeln('Ingrese DNI de Asistente: ');
        readln(a.dni);
      write(arch,a);
    end;
  end;
  close(arch);
  writeln('Archivo Creado!');
end;
procedure elimLogica();
var arch:archivo;a:asistentes;
begin
  assign(arch,'archivo2');
  reset(arch);
  while(not(eof(arch))) do begin
    read(arch,a);
    if(a.nro<1000) then begin
      a.ape:='@'+a.ape;
      seek(arch,filepos(arch)-1);
      write(arch,a);
    end;
  end;
  close(arch);
  writeln('Archivo Con Bajas Logicas Modificado!');
end;
procedure listar();
var arch:archivo; a:asistentes;
begin
	assign(arch,'archivo2');
  reset(arch);
	while not(EOF(arch)) do//recorro mientras no eof
	begin
		read(arch,a);
		writeln('|Numero ', a.nro, '| Apellido ',a.ape,' |DNI: ',a.dni);
	end;
	writeln();
	close(arch);//cierro archivo
end;
begin
//  crear_archivo();
 writeln('Listados');
 listar();
 writeln('Procede a hacerse la baja logica');
 elimLogica();
 writeln('Listados despues de hacer baja logica');
 listar();
end.