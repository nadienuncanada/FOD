program p1ej7;
type
cadena=string[12];
novelas=record
	cod:integer;
	precio:real;
	genero:cadena;
	nom:cadena;
end;
archivo=file of novelas;
procedure crear_archivo();
var nom:cadena;arch:archivo;carga:text;n:novelas;
begin
	writeln('Ingrese Nombre del Archivo Binario: ');
	readln(nom);
	assign(arch,nom);
	assign(carga,'novelas.txt');
	reset(carga);
	rewrite(arch);
	while not(EOF(carga)) do begin
		with n do begin
			readln(carga,cod,precio,genero);
			readln(carga,nom);
		end;
		write(arch,n);
	end;
	writeln('Archivo Cargado! ');
	close(arch);
	close(carga);
end;

procedure abrir_archivo(var arch:archivo);
var nom:cadena;
begin
	writeln('Ingrese Nombre del Archivo: ');
	readln(nom);
	assign(arch,nom);
	reset(arch);
end;
 procedure exportar();
 var texto:text;arch:archivo; n:novelas;
 begin
	abrir_archivo(arch);
	assign(texto,'novelas.txt');
	rewrite(texto);
	while not(eof(arch)) do begin
		read(arch,n);
		with n do begin
			writeln(texto,cod,' ',precio:0:2,' ',genero);
			writeln(texto,nom);
	end;
 end;
 writeln('Archivo Exportado!');
 close(arch);
 close(texto);
 end;
procedure agregar();
var arch:archivo;n:novelas;
begin 
	abrir_archivo(arch);
		writeln('Ingrese codigo: ');
		readln(n.cod);
			if(n.cod<>0) then begin
				writeln('Ingrese precio: ');
				readln(n.precio);
				writeln('Ingrese genero: ');
				readln(n.genero);
				writeln('Ingrese nombre: ');
				readln(n.nom);
			end;
		seek(arch,filesize(arch));
		write(arch,n);
		close(arch);
end;
function buscarpos(var arch:archivo):integer;
var n:novelas;ok:boolean;cod:integer;
begin
writeln('Ingrese Codigo a Buscar: ');
readln(cod);
	ok:=false;
	while(not eof(arch))  and (not ok)do begin
		read(arch,n);
		if(n.cod=cod) then begin
			buscarpos:=(filepos(arch))-1;
			ok:=true
		end;
	end;
	if (not ok) then
		buscarpos:=-1;
end;
procedure modificar_nom();
 var arch:archivo;pos:integer;nom:cadena;n:novelas;
 begin
	abrir_archivo(arch);
	pos:=buscarpos(arch);
	if(pos<>-1) then begin
		seek(arch,pos);
		read(arch,n);
		writeln('Ingrese Nuevo Nombre: ');
		readln(nom);
		n.nom:=nom;
		seek(arch,filepos(arch)-1);
		write(arch,n);
	end
	else
		writeln('Codigo de Novela No Existente!');
		close(arch);
 end; 
 procedure modificar_pre();
 var arch:archivo;pos:integer;pre:real;n:novelas;
 begin
	abrir_archivo(arch);
	pos:=buscarpos(arch);
	if(pos<>-1) then begin
		seek(arch,pos);
		read(arch,n);
		writeln('Ingrese Nuevo Precio: ');
		readln(pre);
		n.precio:=pre;
		seek(arch,filepos(arch)-1);
		write(arch,n);
	end
	else 
		writeln('Codigo de Novela No Existente!');
		close(arch);
 end; 
 procedure modificar_cod();
 var arch:archivo;pos:integer;cod:integer;n:novelas;
 begin
	abrir_archivo(arch);
	pos:=buscarpos(arch);
	if(pos<>-1) then begin
		seek(arch,pos);
		read(arch,n);
		writeln('Ingrese Nuevo Codigo: ');
		readln(cod);
		n.cod:=cod;
		seek(arch,filepos(arch)-1);
		write(arch,n);
	end
	else 
		writeln('Codigo de Novela No Existente!');
		close(arch);
 end;
  procedure modificar_genero();
 var arch:archivo;pos:integer;gen:cadena;n:novelas;
 begin
	abrir_archivo(arch);
	pos:=buscarpos(arch);
	if(pos<>-1) then begin
		seek(arch,pos);
		read(arch,n);
		writeln('Ingrese Nuevo Genero: ');
		readln(gen);
		n.genero:=gen;
		seek(arch,filepos(arch)-1);
		write(arch,n);
	end
	else 
		writeln('Codigo de Novela No Existente!');
		close(arch);
 end;  
procedure inb();
var op:char;
begin
writeln('-------------------MENU2------------------------');
writeln('"a" Agregar una Novela');
writeln('"b" Modificar Nombre Novela Existente');
writeln('"c" Modificar Precio Novela Existente');
writeln('"d" Modificar Codigo Novela Existente');
writeln('"e" Modificar Genero Novela Existente');
writeln('"f" Cerrar Menu');
writeln('-------------------------------------------------');
readln(op);
if (op<>'f') then begin 
	case op of
		'a': agregar();
		'b':modificar_nom();
		'c': modificar_pre();
		'd':modificar_cod();
		'e': modificar_genero();
	else begin
		writeln('Ingrese una Opcion Valida!');
		inb;
	end;
	end;
end;
end;
procedure menu();
var op:char;
begin
writeln('-------------------MENU--------------------------');
writeln('"a" Crear Archivo');
writeln('"b" Modificar Archivo');
writeln('"c" Exportar');
writeln('"d" Cerrar Menu');
writeln('---------------------------------------------------');
readln(op);
if (op<>'d') then 
	begin
		case op of
			'a': crear_archivo();
			'b': inb();
			'c': exportar();
		else begin
			writeln('Por favor, ingrese una opcion valida');
			menu;
		end;
		end;
		menu;
	end;
end;
begin
menu();
end.
