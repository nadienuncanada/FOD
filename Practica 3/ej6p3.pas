program ej6p3;
const valor_alto=9999;
type
prendas=record
  cod:integer;
  stock:integer;
  pre:real;
end;
actualizacion=record
  cod:integer;
end;

maestro=file of prendas;
act=file of actualizacion;
procedure leer(var det:act;var reg:actualizacion);
begin
  if(not(eof(det))) then
    read(det,reg)
  else
    reg.cod:=valor_alto;
end;
procedure cargarPrendas();
var m:maestro;p:prendas;
begin
  assign(m,'maestro6');
  rewrite(m);
  p.cod:=0;
  write(m,p);
  while(p.cod<>-1) do begin
    writeln('Ingrese Codigo: ');
      readln(p.cod);
    if(p.cod<>-1) then begin
      writeln('Ingrese Stock: ');
        readln(p.stock);
      writeln('Ingrese Precio: ');
        readln(p.pre);
      write(m,p);
    end;
  end;
  close(m);
  writeln('Archivo Maestro Creado!');
end;
procedure crearPobsoletas();
var a:act;dato:actualizacion;
begin
  assign(a,'detalle6');
  rewrite(a);
  dato.cod:=0;
  while(dato.cod<>-1) do begin
    writeln('Ingrese Codigo de Prenda Obsoleta(Mayor a 0): ');
      readln(dato.cod);
    if(dato.cod<>-1) and(dato.cod>0)then
      write(a,dato);
  end;
  close(a);
  writeln('Archivo de Prendas que se van a Bajar Creado!');
end;
procedure bajaLogica();
var det:act;m:maestro;dato:actualizacion;p:prendas;
begin
  assign(det,'detalle6');
  reset(det);
  assign(m,'maestro6');
  reset(m);
  leer(det,dato);//leemos del detalle el codigo de la prenda que se va a borrar logicamente
  while(dato.cod<>valor_alto) do begin//mientras no de valor alto
    seek(m,0);//nos vamos al principio del archivo
    read(m,p);//leemos el maestro
    while(dato.cod<>p.cod) do//buscamos el codigo en el maestro
      read(m,p);//
    p.stock:=-1;//marcamos logicamente
    seek(m,filepos(m)-1);//nos paramos en su lugar
    write(m,p);//lo escribimos
    leer(det,dato);//leemos para seguir recorriendo el detalle y actualizar el maestro.
  end;
  close(m);
  close(det);
  writeln('Bajas Logicas Realizadas!');
end;
procedure listar();//listar archivo normal
var m:maestro;txt:text;p:prendas;
begin
  assign(m,'maestro6');
  reset(m);
  assign(txt,'maestro6.txt');
  rewrite(txt);
  while(not(eof(m))) do begin
    read(m,p);
    writeln(txt,p.cod,' ',p.stock,' ',p.pre:0:2);
  end;
  close(txt);
  close(m);
  writeln('Archivo Exportado a TXT!');
end;
procedure listarC();//listar archivo Compactado
var m:maestro;txtC:text;p:prendas;
begin
  assign(m,'maestro6Compactado');
  reset(m);
  assign(txtC,'maestro6Compactado.txt');
  rewrite(txtC);
  while(not(eof(m))) do begin
    read(m,p);
    writeln(txtC,p.cod,' ',p.stock,' ',p.pre:0:2);
  end;
  close(txtC);
  close(m);
  writeln('Archivo Compactado Exportado a TXT!');
end;
procedure Compactar();
var m,mN:maestro;p:prendas;
begin
  assign(m,'maestro6');
  reset(m);
  assign(mN,'maestro6Compactado');
  rewrite(mN);
  while(not(eof(m))) do begin//literal copia todos los registros menos los que tienen marca en el nuevo archivo.
    read(m,p);
    if(p.stock>0) then //la marca logica era sotck negativo
      write(mN,p);
  end;
  close(m);
  close(mN);
  writeln('Archivo Compactado Creado!!');
end;
procedure menu();
var opcion:char;
begin
	writeln(' ___________________________________________________________________________________');
	writeln('|          Welcome al menu de cositas de empleado                                   |');
	writeln('|Ingrese un caracter de los listados a continuacion para continuar:                 |');
	writeln('|a) Crear un archivo                                                                |');
	writeln('|b) Crear archivo detalle                                                           |');
	writeln('|c) Hacer Baja Logica con Detalle                                                   |');
	writeln('|d) Listar                                                                          |');
	writeln('|e) Compactar                                                                       |');
  writeln('|f) Listar Compactada                                                               |');
	writeln('|g) Cerrar                                                                          |');
	writeln('|___________________________________________________________________________________|');
	writeln();
	readln(opcion);
	if (opcion<>'g') then 
	begin
		case opcion of
			'a': cargarPrendas();
			'b': crearPobsoletas();
			'c': bajaLogica();
			'd': listar();
			'e': Compactar();
      'f': listarC();
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