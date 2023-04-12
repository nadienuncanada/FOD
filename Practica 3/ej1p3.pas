{Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.}
program ejercicio_3;
type
	cadena=string[20];
	empleado= record
		num:integer;
		ape:cadena;
		nom:cadena;
		edad:integer;
		dni:integer;
	end;
	archivo= file of empleado;
	var nom:cadena; e:empleado;
function leer_empleado():empleado;
begin
	write('Apellido: ');
	readln(e.ape);
	if (e.ape<>'fin') then
	begin
		write('nombre: ');
		readln(e.nom);
		write('edad: ');
		readln(e.edad);
		write('dni: ');
		readln(e.dni);
		write('numero de empleado: ');
		readln(e.num);
		writeln('____________________________________________________________________________________')
	end;
	leer_empleado:=e;
end;
procedure crear_archivo();
var arch:archivo;

procedure cargar_datos();
begin 
	e:=leer_empleado();
	while (e.ape<> 'fin') do
	begin
		write(arch, e);
		e:=leer_empleado();
	end;
	close(arch);
end;
begin
	writeln('Ingrese un nombre para el archivo: ');
	readln(nom);
	assign(arch,nom);
	rewrite(arch);
	cargar_datos();
end;

procedure abrir_archivo(var arch:archivo);
var nom:cadena;
begin
	writeln();
	writeln('Ingrese el nombre del archivo a abrir: ');
	readln(nom);
	assign(arch,nom);
	reset(arch);
end;
procedure buscar_empleado();
procedure buscar_nombre(var arch:archivo);
var nombre: cadena; e:empleado;
begin
	writeln();
	write('Ingrese el nombre a buscar: ');
	readln(nombre);
	while not(EOF(arch)) do
	begin
		read(arch,e);
		if (e.nom=nombre) then
			writeln(e.nom,' ', e.ape);
	end;
	writeln();
end;
procedure buscar_apellido(var arch:archivo);
var apellido: cadena; e:empleado;
begin
	writeln();
	write('Ingrese el apellido a buscar: ');
	readln(apellido);
	while not(EOF(arch)) do
	begin
		read(arch,e);
		if (e.ape=apellido) then
			writeln(e.nom,' ', e.ape);
	end;
	writeln();
end;
var arch: archivo;opcion: char;
begin
	abrir_archivo(arch);
	write('Ingrese "a" para buscar por nombre y "b" para buscar por apellido: ');
	readln(opcion);
	while ((opcion <> 'a') and (opcion <> 'b')) do
	begin
		writeln('Ingrese una opcion valida: ');
		readln(opcion);
	end;
	case opcion of
	'a': buscar_nombre(arch);
	'b': buscar_apellido(arch);
	end;
	close(arch);
end;	
procedure listar_empleados();
var arch:archivo; e:empleado;
begin
	abrir_archivo(arch);
	while not(EOF(arch)) do//recorro mientras no eof
	begin
		read(arch,e);
		writeln('*', e.num, '| ',e.nom, ' ', e.ape, ' Edad: ',e.edad);
	end;
	writeln();
	close(arch);//cierro archivo
end;

procedure mayores();
var arch:archivo;e:empleado;
begin
	abrir_archivo(arch);
	while not(EOF(arch)) do //recorro mientras no eof
	begin
		read(arch,e);
		if (e.edad>60) then
			writeln(e.nom, ' ', e.ape,' | ', e.edad, ' anios.');
	end;
	writeln();
	close(arch);//cierro archivo
end;
procedure aniadir2 (var arch:archivo);
var ok:boolean;e,nue:empleado;op:cadena;
begin
	ok:=true;
	nue:=leer_empleado;
	while (not(EOF(arch))) and(ok) do begin
		read(arch,e);
		if (e.num=nue.num) then 
			ok:=false
		else
		ok:=true;
	end;
	if not(ok) then
	writeln('No se puede agregar dicho Empleado porque ya existe un empleado con ese Numero.')
	else begin
		write(arch,nue);
		writeln('Empleado Agregado');
	end;
	writeln('Agregar Nuevo Empleado?: y=si/n=no');
	readln(op);
	if(op='y') then begin
		seek(arch,0);
		aniadir2(arch);
	end
	else begin
		close(arch);
		writeln('Gracias!');
	end;
end;
procedure aniadir();
var arch:archivo;
begin
	abrir_archivo(arch);
	aniadir2(arch);
end;
procedure modificar();
var e:empleado;num,eNueva:integer;op:cadena;arch:archivo;ok:boolean;
begin
	ok:=true;
	abrir_archivo(arch);
	writeln('Ingrese Numero de Empleado que se desea modificar: ');
	readln(num);
	while not (EOF(arch)) do begin
		read(arch,e);
		if(e.num=num) then begin
			writeln('La edad Actual es:  ',e.edad);
			writeln('Ingrese la edad Nueva: ');
			readln(eNueva);
			e.edad:=eNueva;
			seek(arch,filepos(arch)-1);
			write(arch,e);
			writeln('Edad Actualizada a:  ',eNueva);
			ok:=false;
		end;
	end;
	if (ok) then 
		writeln('El Numero de Empleado Ingresado No Existe!');
	writeln('Quiere operar con otro Empleado?: y=si/n=no');
	readln(op);
	if(op='y') then 
		modificar()
	else begin
		writeln('Gracias!');
		close(arch);
	end;
end;
procedure exportar();
var texto:text;e:empleado;arch:archivo;
begin
	abrir_archivo(arch);
	assign(texto,'todos_empleados');
	rewrite(texto);
	while (not(EOF(arch))) do begin
		read(arch,e);
		With e do
		writeln(texto,' ',num,' ',ape,' ',nom,' ',edad,' ',dni);
	end;
	close(arch);
	close(texto);
end;
procedure dnicero();
var arch:archivo;texto:text;e:empleado;
begin
	abrir_archivo(arch);
	assign(texto,'faltaDNIEmpleado.txt');
	rewrite(texto);
	while not(EOF(arch)) do begin
		read(arch,e);
		if(e.dni=00) then begin 
		with e do
			writeln(texto,' ',num,' ',ape,' ',nom,' ',edad,' ',dni);
		writeln('Se agrego un empleado a la lista!');
		end;
	end;
	close(arch);
	close(texto);
end;
procedure baja();
var arch:archivo;e,aux:empleado;n:integer;ok:boolean;
begin
  ok:=false;
  assign(arch,'maestro1');
  reset(arch);
  seek(arch,filesize(arch)-1);//me paro en el ultimo dato del archivo
  read(arch,aux);//lo leo y lo guardo en un aux
  writeln('Ingrese numero de empleado a eliminar: ');//pido el numero del empleado a borrar
    readln(n);
  seek(arch,0);//arranco en 0 para leer todo el archivo
  while(not(eof(arch))) and not(ok) do begin//mientras no se termine o ok se ponga true
    read(arch,e);//leo el dato del archivo
    if(e.num=n) then begin//si es el numero a buscar 
      seek(arch,filepos(arch)-1);//me paro en la posicion
      write(arch,aux);//lo sobre escribo
      seek(arch,filesize(arch)-1);//me paro en el ultimo dato del archivo.
      Truncate(arch);//y cierro el archivo con 1 menos que seria el que copie en la posicion del borrado
      ok:=true;//poco que decir
    end;
  end;
  if(ok) then//si se borro o no
    writeln('Empleado eliminado!')
  else 
    writeln('El empleado no existe!');
  close(arch);//cierro el archivo.
end;
procedure menu();
var opcion:char;
begin
	writeln(' ___________________________________________________________________________________');
	writeln('|          Welcome al menu de cositas de empleado                                   |');
	writeln('|Ingrese un caracter de los listados a continuacion para continuar:                 |');
	writeln('|a) Crear un archivo                                                                |');
	writeln('|b) Buscar empleados por nombre                                                     |');
	writeln('|c) Listar empleados                                                                |');
	writeln('|d) Listar empleados mayores a 60 anios                                             |');
	writeln('|e) Aniadir Empleado                                                                |');
	writeln('|f) Modificar Edad de un/unos Empleado/s                                            |');
	writeln('|g) Exportar Archivo a TXT                                                          |');
	writeln('|h) Crear Archivo TXT de los DNI 00                                                 |');
	writeln('|i) Realizar una Baja                                                               |');
  writeln('|j) cerrar                                                                          |');
	writeln('|___________________________________________________________________________________|');
	writeln();
	readln(opcion);
	if (opcion<>'j') then 
	begin
		case opcion of
			'a': crear_archivo();
			'b': buscar_empleado();
			'c': listar_empleados();
			'd': mayores();
			'e': aniadir();
			'f':modificar();
			'g':exportar();
			'h':dnicero();
      'i': baja();
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
