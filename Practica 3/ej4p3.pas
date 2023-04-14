program ej4p3;
type
str=String[45];
reg_flor = record
nom:str;
cod:integer;
end;
tArchFlores=file of reg_flor;
procedure eliminarFlor();
var arc:tArchFlores;f,aux:reg_flor;ok:boolean;pos:integer;
begin
  pos:=0;
  ok:=false;
  writeln('Ingrese Codigo de flor a eliminar: ');
    readln(aux.cod);
  assign(arc,'archivo4');
  reset(arc);
  while(not(eof(arc))) and (not ok) do begin
    read(arc,f);
    if(f.cod=aux.cod) then begin
      f.cod:=-pos;//pogo la posicion en la que se encuentra el dato con un -(menos/negativo).
      seek(arc,0);//voy a la cabezera 
        read(arc,aux);//copio lo que hay en la cabezera
      seek(arc,0);//vuelvo a la cabezera
        write(arc,f);//dejo la nueva posicion en la que se puede meter datos
      seek(arc,-f.cod);//voy a la posicion del dato borrado
        write(arc,aux);//pongo la anterior cabezera, 0 u otro.
        ok:=true;
    end
    else
      pos:=pos+1;
  end;
  if(ok) then 
    writeln('Flor eliminada!')
  else
    writeln('El Codigo de Flor a eliminar no se encuentra!');
  close(arc);
end;
procedure cargarFlores();
var a:tArchFlores;f:reg_flor;
begin
  assign(a,'archivo4');
  rewrite(a);
  f.cod:=0;
  write(a,f);
  while(f.cod<>-1) do begin
    writeln('Ingrese codigo de Flor: ');
      readln(f.cod);
    if(f.cod<>-1) then begin
      writeln('Ingrese Nombre de Flor: ');
        readln(f.nom);
      write(a,f);
    end;
  end;
  close(a);
  writeln('Archivo Creado!');
end;
procedure agregarFlor();
var f,aux,aux2:reg_flor;var a: tArchFlores; nombre: string;codigo:integer;
begin
  writeln('ingrese codigo a agregar: ');
    readln(codigo);
  writeln('Ingrese Nombre a Agregar: ');
    readln(nombre);
  assign(a,'archivo4');
  reset(a);
  f.nom:=nombre;
  f.cod:=codigo;
  read(a,aux);//agarro el dato de la cabezera
  if(aux.cod<0) then begin
    seek(a,-aux.cod);
    read(a,aux2);//copio el registro en aux2 para despues ponerlo en la cabezera
    seek(a,-aux.cod);
    write(a,f);//sobre escribo el dato
    if(aux2.cod<=0) then begin
      seek(a,0);// voy a la cabezera
      write(a,aux2);//pongo el dato que estaba en la pos 
    end;
  end
  else begin
      seek(a,filesize(a));
      write(a,f);
  end;
  close(a);
  writeln('Flor Agregada!');
end;
procedure listar();
var a:tArchFlores;txt:text;f:reg_flor;
begin
  assign(a,'archivo4');
  reset(a);
  assign(txt,'archivo4.txt');
  rewrite(txt);
  while(not(eof(a))) do begin
    read(a,f);
    // if(f.cod>0) then //comentado para debugear, si lo descomento solo imprime lo que pide.
      writeln(txt,f.cod,' ',f.nom);
  end;
  close(a);
  close(txt);
  writeln('Archivo Exportado a TXT!');
end;
procedure menu();
var opcion:char;
begin
	writeln(' ___________________________________________________________________________________');
	writeln('|          Welcome al menu de cositas de empleado                                   |');
	writeln('|Ingrese un caracter de los listados a continuacion para continuar:                 |');
	writeln('|a) Crear un archivo                                                                |');
	writeln('|b) Agregar Flor                                                                    |');
	writeln('|c)    NO USAR                                                                      |');
	writeln('|d) Eliminar FLOR                                                                   |');
	writeln('|e) Listar en TXT                                                                   |');
	writeln('|f) Cerrar                                                                          |');
	writeln('|___________________________________________________________________________________|');
	writeln();
	readln(opcion);
	if (opcion<>'f') then 
	begin
		case opcion of
			'a': cargarFlores();
			'b': agregarFlor();
			// 'c': ();
			'd': eliminarFlor();//ej5
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