program ej8p3;
type
str=string[20];
distribucion=record
  nom:str;
  cant:integer;
end;
archivo=file of distribucion;
procedure cargarArchivo();
var a:archivo;d:distribucion;
begin
  assign(a,'archivo8');
  rewrite(a);
  d.cant:=0;
  write(a,d);
  while(d.cant<>-1) do begin 
     writeln('Ingrese Cantidad de Desarrolladores: ');
      readln(d.cant);
    if(d.cant<>-1) then begin
      writeln('Ingrese Nombre de Distribucion: ');
        readln(d.nom);
      write(a,d);
    end;
  end;
  close(a);
  writeln('Archivo Creado!');
end;
function ExixteDistribucion(nom:str):integer;
var a:archivo;d:distribucion;encontre:boolean;pos:integer;
begin
  pos:=0;
  encontre:=false;
  assign(a,'archivo8');
  reset(a);
    while(not(eof(a))) and(not encontre) do begin
      read(a,d);
      if(d.nom=nom) then
        encontre:=true;
      pos:=pos+1;
    end;
    if(encontre) then begin
      writeln('El nombre buscado se encuentra!');
      ExixteDistribucion:=pos-1;
    end
    else begin
      writeln('El nombre buscado NO se encuentra!');
      ExixteDistribucion:=-1;
    end;
    close(a);
end;
procedure AltaDistribucion();
var a:archivo;d,aux:distribucion;
begin
  writeln('Cantidad de Desarrolladores: ');
    readln(d.cant);
  writeln('Nombre de la Distribucion: ');
    readln(d.nom);
  if(ExixteDistribucion(d.nom)<0) then begin
    assign(a,'archivo8');
    reset(a);
    read(a,aux);//leo la cabezera
    if(aux.cant<0) then begin//si es menor a 0
      seek(a,-aux.cant);//me paro en la pos que se guardo en cant
      read(a,aux);//leo el dato y lo guardo en aux
      seek(a,filepos(a)-1);//muevo el puntero al mismo lugar porque el read lo avanzo
        write(a,d);//dejo el nuevo dato
      seek(a,0);//me voy a la cabezera
        write(a,aux);//dejo el dato que se sobreescribio y el cual tiene la siguiente pos de dato borrado
    end
    else begin//sino agrego al final
      seek(a,filesize(a));
      write(a,d);
    end;
    close(a);
    writeln('Dato Agregado!');
  end
  else begin
    writeln('Ya existe la distribucion!');
  end;
end;
procedure listar();
var a:archivo;d:distribucion;txt:text;
begin
  assign(a,'archivo8');
  reset(a);
  assign(txt,'archivo8.txt');
  rewrite(txt);
  while(not(eof(a))) do begin
    read(a,d);
    writeln(txt,d.cant,' ',d.nom);
  end;
  close(a);
  close(txt);
  writeln('Archivo Listado!');
end;
procedure BajaDistribucion();
var a:archivo;d,aux:distribucion;
begin
  writeln('Ingrese Nombre de Distribucion a Buscar: ');
    readln(aux.nom);
  if(ExixteDistribucion(aux.nom)>0) then begin
     aux.cant:=(-ExixteDistribucion(aux.nom));//pongo en la cant la pos en la que se puede meter datos
     assign(a,'archivo8');
     reset(a);
     seek(a,0);//voy a buscar la cabezera
     read(a,d);//tengo la cabezera
     seek(a,-aux.cant);//voy de nuevo a la pos para dejar la anterior cabezera
     write(a,d);//pongo en la pos eliminada la anterior cabezera
     seek(a,0);//cabezera
     write(a,aux);//pongo el dato nuevo en la cabezera que tiene las pos donde se puede agregar datos.
     close(a);
    writeln('Dato Eliminado Logicamente!');
  end
  else
    writeln('Distribucion no existente');
end;
procedure menu();
var opcion:char;
begin
	writeln(' ___________________________________________________________________________________');
	writeln('|          Welcome al menu de cositas de empleado                                   |');
	writeln('|Ingrese un caracter de los listados a continuacion para continuar:                 |');
	writeln('|a) Crear un archivo                                                                |');
	writeln('|b) Alta                                                                            |');
	writeln('|c) Baja                                                                            |');
	writeln('|d) Listar                                                                          |');
	writeln('|e) Cerrar                                                                          |');
	writeln('|___________________________________________________________________________________|');
	writeln();
	readln(opcion);
	if (opcion<>'e') then 
	begin
		case opcion of
			'a': cargarArchivo();
			'b': AltaDistribucion();
			'c': BajaDistribucion();
			'd': listar();
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