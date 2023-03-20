{5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares, deben contener: código de celular, el nombre,
descripción, marca, precio, stock mínimo y el stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
debería respetar el formato dado para este tipo de archivos en la NOTA 2.
NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
tres líneas consecutivas: en la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
“celulares.txt”.
}
program ej5;
type 
cadena=string[20];
celulares=record
	cod:integer;
	nom:cadena;
	desc:cadena;
	marca:cadena;
	precio:real;
	stockM:integer;
	stockD:integer;
end;
archivo= file of celulares;
procedure abrir_archivo(var arch:archivo);
var nom:cadena;
begin
	writeln();
	writeln('Ingrese el nombre del archivo a abrir: ');
	readln(nom);
	assign(arch,nom);
	reset(arch);
end;
procedure listar_cel_des();
var arch:archivo;c:celulares;
begin
		abrir_archivo(arch);
		while(not EOF(arch)) do begin
			read(arch,c);
			if(c.desc<>' ') then begin
			with c do begin
				writeln('Codigo: ',cod,' Precio: ',precio:0:2,' Marca: ',marca);
				writeln('Stock Disponible: ',stockD,' Stock Minimo: ',stockM,' Descripcion: ',desc);
				writeln('Nombre: ',nom);
				writeln('----------------------------------------------------------------');
			end;
			end;
		end;
		close(arch);
end;
procedure crear_archivoB();
var nom:cadena;arch:archivo;carga:text;c:celulares;
begin
	writeln('Ingrese Nombre del Archivo Binario: ');
	readln(nom);
	assign(arch,nom);
	assign(carga,'celulares.txt');
	reset(carga);
	rewrite(arch);
	while not(EOF(carga)) do begin
		with c do begin
			readln(carga,cod,precio,marca);
			readln(carga,stockD,stockM,desc);
			readln(carga,nom);
		end;
		write(arch,c);
	end;
	writeln('Archivo Cargado! ');
	close(arch);
	close(carga);
end;
procedure stockMinimo();
var arch:archivo;c:celulares;
begin
		abrir_archivo(arch);
		while(not EOF(arch)) do begin
			read(arch,c);
			if(c.stockM>c.stockD) then begin
			with c do begin
				writeln('Stoc Disponible Menor al Minimo!');
				writeln('Codigo: ',cod,' Precio: ',precio:0:2,' Marca: ',marca);
				writeln('Stock Disponible: ',stockD,' Stock Minimo: ',stockM,' Descripcion: ',desc);
				writeln('Nombre: ',nom);
				writeln('----------------------------------------------------------------');
			end;
			end;
		end;
		close(arch);
end;
procedure bin_a_txt();
var arch:archivo;c:celulares;texto:text;
begin
	abrir_archivo(arch);
	assign(texto,'celulares2.txt');
	rewrite(texto);
	while(not eof(arch)) do begin 
		read(arch,c);
		with c do begin
			writeln(texto,cod,' ',precio:0:2,marca);
			writeln(texto,stockD,stockM,desc);
			writeln(texto,nom);
		end;
	end;
	writeln('Archivo Exportado!');
	close(arch);
	close(texto);
end;
procedure txt_sin_stock();
var arch:archivo;texto:text;c:celulares;
begin
	abrir_archivo(arch);
	assign(texto,'sin_stock.txt');
	while(not eof(arch)) do begin
		read(arch,c);
		if(c.stockD=0) then begin
			with c do begin
				writeln(texto,cod, ' ',precio:0:2,marca);
				writeln(texto,stockD,stockM,desc);
				writeln(texto,nom);
			end;
		end;
	end;
	close(arch);
	close(texto);
end;
procedure leer_celular(var c:celulares);
begin
    write('Codigo del telefono: ');
    readln(c.cod);
    if (c.cod<> 0) then
    begin
        write('Nombre: ');
        readln(c.nom);
        write('Descripcion: ');
        readln(c.desc);
        write('Marca: ');
        readln(c.marca);
        write('Precio: ');
        readln(c.precio);
        write('Stock minimo: ');
        readln(c.stockM);
        write('Stock actual: ');
        readln(c.stockD);
    end;
end;
procedure aniadir();
var c:celulares;arch:archivo;
begin
	abrir_archivo(arch);
	leer_celular(c);
	while (c.cod<>0) do begin
		seek(arch,filesize(arch));
		write(arch,c);
		leer_celular(c);
	end;
	close(arch);
	writeln('Se le va a pedir el Nombre Para Guardar el Archivo: ');
	bin_a_txt();
end;
procedure modificar();
var nom,op:cadena;arch:archivo;ok:boolean;c:celulares;stock:integer;
begin
	abrir_archivo(arch);
	writeln('Ingrese el nombre del celular a modificar: ');
	readln(nom);
	ok:=false;
	while (not(eof(arch))) and not (ok) do begin
		read(arch,c);
		if(c.nom=nom) then begin
			writeln('Ingrese el nuevo stock: ');
			readln(stock);
			c.stockD:=stock;
			seek(arch,filepos(arch)-1);
			write(arch,c);
			ok:=true;
		end;
	end;
	if(not ok) then 
		writeln('El Celular no se encontro!')
	else
		writeln('Stock Modificado');
	writeln('Desea Modiciar Otro Celular? y=si/n=no');
	readln(op);
		if(op='y') then
			modificar();
		writeln('Gracias!');
	close(arch);
	writeln('Te va a pedir el nombre del archivo para guardarlo/actualizarlo');
	bin_a_txt();
end;
procedure menu();
var opcion:char;
begin
	writeln(' ___________________________________________________________________________________');
	writeln('|          Welcome al menu de cositas de empleado  |');
	writeln('|Ingrese un caracter de los listados a continuacion para continuar: |');
	writeln('|a) Crear un archivo Binario a Partir de un TXT  |');
	writeln('|b) Stock Minimo            |');
	writeln('|c) Listar Celulares Con Descripciones                   |');
	writeln('|d)  Exportar de Binario a TXT           |');
	writeln('|e)  Exportar a un TXT celulares sin STOCK            |');
	writeln('|f)  Aniadir Celular/es                                          |');
	writeln('|g)  Modificar Stock                                      |');
	writeln('|h)  Cerrar Menu                                          |');
	writeln(' ___________________________________________________________________________________');
	writeln();
	readln(opcion);
	if (opcion<>'h') then 
	begin
		case opcion of
			'a': crear_archivoB();
			'b': stockMinimo();
			'c': listar_cel_des();
			'd': bin_a_txt();
			'e': txt_sin_stock();
			'f':aniadir();
			'g': modificar();
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
