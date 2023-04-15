program ej7p3;
type
aves=record
  cod:integer;
  nom:string[20];
end;
archivo=file of aves;
procedure cargarAves();
var arc:archivo;a:aves;
begin
  assign(arc,'archivo7');
  rewrite(arc);
  a.cod:=0;
  while(a.cod<>-1) do begin 
    writeln('Ingrese Codigo: ');
      readln(a.cod);
    if(a.cod<>-1) then begin
      writeln('Ingrese Nombre de la Especie:');
        readln(a.nom);
      write(arc,a);
    end;  
  end;
  close(arc);
  writeln('Archivo Creado!');
end;
procedure eliminar();
var arc:archivo;a,aux:aves;
begin
  writeln('Ingrese Codigo de Especie a Borrar: ');
    readln(aux.cod);
  assign(arc,'archivo7');
  reset(arc);
  while(not(eof(arc))) do begin
    read(arc,a);
    if(a.cod=aux.cod) then begin
      a.cod:=-a.cod;
      seek(arc,filepos(arc)-1);
      write(arc,a);
    end
  end;
  close(arc);
  writeln('Archivo Marcado como Borrado!');
end;
procedure compactar();
var arc:archivo;a,aux:aves;pos:integer;
begin
  assign(arc,'archivo7');
  reset(arc);
  while(not(eof(arc)))do begin
    read(arc,a);
    if(a.cod<0) then begin//si encontre uno a borrar
      if(eof(arc)) then begin//si estoy al final y es un negativo// esto se puede hacer de otra manera, haciendolo siempre al final ya que en ambos se hace un truncate
        seek(arc,filepos(arc)-1);
        Truncate(arc);// lo saco.
      end
      else begin
        pos:=filepos(arc)-1;//me guardo su posicion(com -1 porque con el read queda 1 adelante)
        seek(arc,filesize(arc)-1);// vamos al final del archivoa
        read(arc,aux);//agarra el ultimo dato
        seek(arc,filepos(arc)-1);//me paro el en dato copiado
        Truncate(arc);//borro el ultimo porque lo voy a pasar la pos nueva
        seek(arc,pos);//voy a la pos que voy a poner el ultimo dato
        write(arc,aux);//lo escribo
        seek(arc,filepos(arc)-1);//esto para que vuelva a chekear el que pusimo por si es otro que tenia que borrar o al final quedo un dato a borrar
      end;
    end;
  end;
  close(arc);
  writeln('Archivo Compactado!');
end;
procedure listar();
var arc:archivo;a:aves;txt:text;
begin
  assign(arc,'archivo7');
  reset(arc);
  assign(txt,'archivo7.txt');
  rewrite(txt);
  while(not(eof(arc))) do begin
    read(arc,a);
    writeln(txt,a.cod,' ',a.nom);
  end;
  close(arc);
  close(txt);
  writeln('Archivo Listado!');
end;
procedure menu();
var opcion:char;
begin
	writeln(' ___________________________________________________________________________________');
	writeln('|          Welcome al menu de cositas de empleado                                   |');
	writeln('|Ingrese un caracter de los listados a continuacion para continuar:                 |');
	writeln('|a) Crear un archivo                                                                |');
	writeln('|b) Eliminar                                                                        |');
	writeln('|c) Listar                                                                          |');
	writeln('|d) Compactar                                                                       |');
	writeln('|e) Cerrar                                                                          |');
	writeln('|___________________________________________________________________________________|');
	writeln();
	readln(opcion);
	if (opcion<>'e') then 
	begin
		case opcion of
			'a': cargarAves();
			'b': eliminar();
			'c': listar();
			'd': compactar();
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