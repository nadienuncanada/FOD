program ej14p2;
const valor_alto='ZZZZZ';
type
str=string[20];
vuelos=record
  destino:str;
  fecha:integer;
  hora:integer;
  cantAsien:integer;
end;
archivos=record
  destino:str;
  fecha:integer;
  hora:integer;
  cantAsienC:integer;
end;
lista=^nodo;
nodo=record
	dato:vuelos;
	sig:lista;
end;
maestro=file of vuelos;
detalles=file of archivos;
procedure leer(var det:detalles;var reg:archivos);
begin
  if(not(eof(det))) then
    read(det,reg)
  else
    reg.destino:=valor_alto;
end;
procedure txt_a_bin();
var ma:maestro;v:vuelos;txtm:text;
begin
  assign(txtm,'maestro14.txt');
  reset(txtm);
  assign(ma,'maestro14');
  rewrite(ma);
  while(not(eof(txtm))) do begin
    with v do 
      readln(txtm,fecha,hora,cantAsien,destino);
    write(ma,v);
  end;
  close(ma);
  close(txtm);
end;
procedure txt_a_binDet();
var det:detalles;a:archivos;txtD:text;
begin
  assign(txtD,'detalle14.txt');
  reset(txtD);
  assign(det,'detalle14');
  rewrite(det);
  while(not(eof(txtD))) do begin
    with a do
      readln(txtD,fecha,hora,cantAsienC,destino);
    write(det,a);
  end;
  close(det);
  close(txtD);
end;
procedure txt_a_binDet2();
var det2:detalles;a:archivos;txtD2:text;
begin
  assign(txtD2,'detalle14-2.txt');
  reset(txtD2);
  assign(det2,'detalle14-2');
  rewrite(det2);
  while(not(eof(txtD2))) do begin
    with a do 
      readln(txtD2,fecha,hora,cantAsienC,destino);
    write(det2,a);
  end;
  close(det2);
  close(txtD2);
end;
procedure Minimo(var det,det2:detalles;var reg:archivos;var reg2:archivos;var min:archivos); 
begin
 if ((reg.destino<reg2.destino)or((reg.destino=reg2.destino)and(reg.fecha<reg2.fecha)) or ((reg.destino=reg2.destino)and(reg.fecha=reg2.fecha) and (reg.hora<reg2.hora))) then
  begin
        min:=reg;
        leer(det,reg);
    end
    else
    begin
        min:=reg2;
        leer(det2,reg2);
    end;
    writeln('El Minimo Devolvio: ',min.destino);
end;
procedure imprimir(l:lista);
begin
  writeln('Lista de Vuelos con menos de 20 asientos:');
  while(l<>nil) do begin
    writeln('Destino',l^.dato.destino,' Fecha: ',l^.dato.fecha,' Hora: ',l^.dato.hora);
    l:=l^.sig;
  end;
end;

procedure actualizarMaestro();
var det2,det:detalles;reg,reg2,min:archivos;ma:maestro;v:vuelos;nuevo,l,ult:lista;cantV,i:integer;
begin
  l:=nil;
  min.destino:=valor_alto;
  assign(ma,'maestro14');
  reset(ma);
  assign(det,'detalle14');
  reset(det);
  assign(det2,'detalle14-2');
  reset(det2);
  cantV:=30;//se puede cambiar;
  leer(det,reg);
  leer(det2,reg2);
  Minimo(det,det2,reg,reg2,min);
  while(min.destino<>valor_alto) do begin
    read(ma,v);
    while(v.destino<>min.destino)or(v.fecha<>min.fecha)or(v.hora<>min.hora) do begin
      read(ma,v);
      writeln('Minimo:',min.destino);
      writeln('Actual:',v.destino);
      i:=0;
    end;
      while (min.destino=v.destino) and (min.fecha=v.fecha)  and (min.hora=v.hora) do begin
        i:=i+1;
        writeln('Itere con: ',v.destino,i,' veces');
        v.cantAsien:=v.cantAsien-min.cantAsienC;
        Minimo(det,det2,reg,reg2,min);
      end;
      writeln('Modificando: ',v.destino,' ahora con: ',v.cantAsien);
      seek(ma,filepos(ma)-1);
      write(ma,v);
      if(v.cantAsien<cantV) then begin
        new(nuevo);nuevo^.dato.destino:=v.destino;nuevo^.dato.fecha:=v.fecha;nuevo^.dato.hora:=v.hora;nuevo^.sig:=nil;
		    if l=nil then begin
		    	l:=nuevo;
			   ult:=nuevo;
			  end else begin
			   ult^.sig:=nuevo;
			   ult:=nuevo;
		    end;
      end;
  end;
  close(ma);
  close(det);
  close(det2);
  imprimir(l);
end;

procedure exportarMaestro();
var texto:text;reg:vuelos;ma:maestro;
begin
    assign(ma,'maestro14');
    reset(ma);
    assign(texto,'maestro14EXP.txt');
    rewrite(texto);
    while (not(eof(ma))) do begin
      read(ma,reg);
      with reg do
        writeln(texto,fecha,' ',hora,' ',cantAsien,destino);
    end;
    close(ma);
    close(texto);
end;

begin
 txt_a_bin();
 txt_a_binDet();
txt_a_binDet2();
 actualizarMaestro();
 exportarMaestro();
end.