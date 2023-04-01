program ej7p2;
const valor_alto=9999;
type
str=string[20];
productos=record
  cod:integer;
  nom:str;
  pre:real;
  stockA:integer;
  stockM:integer;
end;
ventas=record
  cod:integer;
  cantV:integer;
end;
maestro=file of productos;
detalle= file of ventas;
procedure leer(var deta:detalle;var dato:ventas);
begin
  if(not(eof(deta))) then
    read(deta,dato)
  else
    dato.cod:=valor_alto;
end;
procedure actualizarMaestro();
var ma:maestro;det:detalle;tot:integer;regm:productos;regd,aux:ventas;
begin 
  assign(ma,'maestro7');
  reset(ma);
  assign(det,'detalle7');
  reset(det);
  read(ma,regm);
  leer(det,regd);
  while(regd.cod<>valor_alto) do begin
    tot:=0;
    aux:=regd;
    while(regd.cod=aux.cod) do begin
      tot:=tot+regd.cantV;
      leer(det,regd);
    end;
    while(aux.cod<>regm.cod) do 
      read(ma,regm);
    regm.stockA:=regm.stockA-tot;
    seek(ma,filepos(ma)-1);
    write(ma,regm);
  end;
  close(ma);
  close(det);
end;
procedure listarSM();
var ma:maestro;p:productos;texto:text;
begin
  assign(ma,'maestro7');
  reset(ma);
  assign(texto,'stock_minimo.txt');
  rewrite(texto);
  while (not(eof(ma))) do begin
    read(ma,p);
    if(p.stockA<p.stockM) then begin
      with p do begin
        writeln(texto,cod,' ',pre:0:2,' ',nom);
        writeln(texto,stockA,' ',stockM);
      end;
    end;  
  end;
  close(ma);
  close(texto);
end;
procedure crearDetalle();//creo el detalle
var deta:detalle;v:ventas;
begin
  assign(deta,'detalle7');//asigno el archivo 
  rewrite(deta);
    v.cod:=0;
  while(v.cod<>-1) do begin
    writeln('Ingrese cod: ');
    readln(v.cod);
    if(v.cod<>-1) then begin
      writeln('Ingrese cantidad vendida: ');
      readln(v.cantV);
      write(deta,v);
    end;
  end;
  close(deta);
end;
procedure txt_a_bin();//paso el maestro de txt a binario 
var txtM:text;p:productos;ma:maestro;
begin
  assign(txtM,'maestro7.txt');
  reset(txtM);
  assign(ma,'maestro7');
  rewrite(ma);
  while(not(eof(txtM))) do begin
    with p do begin
      readln(txtM,cod,pre,nom);
      readln(txtM,stockA,stockM); 
    end;
    write(ma,p);
  end;
  close(ma);
  close(txtM);
end;

begin
 crearDetalle();
 txt_a_bin();
 actualizarMaestro();
 listarSM();
end.