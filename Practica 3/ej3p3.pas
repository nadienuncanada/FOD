program ej3p3;
type
  str=string[20];
novela=record
  cod:integer;
  // gen:integer;
  nom:str;
  // dura:integer;
  // direc:str;
  // pre:real;

end;

archivo=file of novela;
procedure crear_archivo();
var arc:archivo;n:novela;
begin
  assign(arc,'archivo3');
  rewrite(arc);
  n.cod:=0;
  write(arc,n);
  while(n.cod<>-1) do begin
    writeln('Ingrese Codigo de Novela: ');
    readln(n.cod);
    if(n.cod<>-1) then begin
      // writeln('Ingrese Genero de Novela: ');
      // readln(e.gen);
      writeln('Ingrese Nombre de Novela: ');
      readln(n.nom);
      // writeln('Ingrese Duracion de Novela: ');
      // readln(e.dura);
      // writeln('Ingrese Director de Novela: ');
      // readln(e.direc);
      // writeln('Ingrese Precio de Novela: ');
      // readln(e.pre);
      write(arc,n);
    end;
  end;
  close(arc);
  writeln('Archivo Creado!');
end;
procedure eliminar ();
var num,pos:integer;arc:archivo;n,aux:novela;ok:boolean;
begin
  ok:=false;
  pos:=0;
  aux.cod:=0;
  assign(arc,'archivo3');
  reset(arc);
  writeln('Ingrese Codigo de Novela a Eliminar');
    readln(num);
  while(not(eof(arc))) and not(ok) do begin
    read(arc,n);
    if(n.cod=num) then begin//si es el numero que buscamos 
      n.cod:=-pos;//ponemos la posicion en que se encontro(en negativo) como su codigo
      seek(arc,0);//lo mandamos a la cabezera
      read(arc,aux);//copiamos lo que hay en la cabezera
      seek(arc,0);
      write(arc,n);//lo escribimos en la cabezera al dato a borrado
      seek(arc,filepos(arc)+pos-1);//vamos a la posicion en que se borro
      write(arc,aux);//y ponemos el que anteriormente estaba en la cabezera.
      ok:=true;
    end
    else
      pos:=pos+1;//si no era el codigo aumentamos en 1 pos que espara saber donde nos encontramos.
  end;
  close(arc);
  if (ok) then 
    writeln('Se elimino la novela')
  else
    writeln('La novela no se encuentra!');
end;
procedure modificar ();
var arc:archivo;n,aux:novela;ok:boolean;
begin
  ok:=false;
  assign(arc,'archivo3');
  reset(arc);
  writeln('Ingrese Codigo de Novela a Modificar');
    readln(aux.cod);
  writeln('Ingresa el nuevo nombre de la Novela');
    readln(aux.nom);
  if(aux.cod>0) then begin
    while(not(eof(arc))) and (not ok) do begin 
      read(arc,n);
      if(n.cod=aux.cod) then begin
        n.nom:=aux.nom;
        seek(arc,filepos(arc)-1);
        write(arc,n);
        ok:=true;
      end;
    end;
    close(arc);
    if(ok) then 
      writeln('Se encontro la novela y se modifico')
    else
      writeln('No se encontro la novela');
  end
  else 
    writeln('Codigo de Novela invalido!!!');
end;
procedure alta();
var arc:archivo;n,aux,cabezera:novela;
begin
  assign(arc,'archivo3');
  reset(arc);
  read(arc,aux);//leemos la cabezera para ver si hay espacio disponible
  writeln('Ingrese Codigo de Novela: ');
    readln(n.cod);
  writeln('Ingrese Nombre de Novela: ');
    readln(n.nom);
  if(aux.cod<0) then begin//si la cabezera tiene un lugar para guardar 
    seek(arc,filepos(arc)-aux.cod-1);//el -1 es por el primer read, nos ponemos en el lugar a sobreescribir para aprovechar el espacio
    read(arc,cabezera);//copiamos el dato que hay en esa posicion, esto para chekear si lo que hay es otra pos que se va a tener que ir a la cabezera
    seek(arc,0);//al inicio
    seek(arc,filepos(arc)-aux.cod);
    write(arc,n);//escribimos en el lugar el dato nuevo
    if(cabezera.cod<=0) then begin //si lo que habia en el lugar que escribimos tenia el dato de otro lugar borrado
      seek(arc,0);//vamos a la cabezera
      write(arc,cabezera);//metemos el nuevo dato que tiene la pos de otro lugar que se puede sobreescribir.
    end;
  end
  else begin//sino
    seek(arc,filesize(arc));// nos vamos al final del archivo
    write(arc,n);//y lo metemos al final.
  end;
  close(arc);
  writeln('Novela Agregada!');
end;
procedure listar();
var arc:archivo;texto:text;n:novela;
begin
  assign(arc,'archivo3');
  reset(arc);
  assign(texto,'archivo3.txt');
  rewrite(texto);
  while(not(eof(arc))) do begin
    read(arc,n);
    writeln(texto,n.cod,' ',n.nom);
  end;
  close(arc);
  close(texto);
  writeln('Archivo TXT creado!');
end;
procedure menu();
var opcion:char;
begin
	writeln(' ___________________________________________________________________________________');
	writeln('|          Welcome al menu de cositas de empleado                                   |');
	writeln('|Ingrese un caracter de los listados a continuacion para continuar:                 |');
	writeln('|a) Crear un archivo                                                                |');
	writeln('|b) Dar de alta                                                                     |');
	writeln('|c) Modificar datos de una Novela                                                   |');
	writeln('|d) Eliminar Novela                                                                 |');
	writeln('|e) Listar en TXT                                                                   |');
	writeln('|f) Cerrar                                                                          |');
	writeln('|___________________________________________________________________________________|');
	writeln();
	readln(opcion);
	if (opcion<>'f') then 
	begin
		case opcion of
			'a': crear_archivo();
			'b': alta();
			'c': modificar();
			'd': eliminar();
			'e': listar();
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