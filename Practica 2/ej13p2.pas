program ej13p2;
const valor_alto=9999;
type
logs=record
  nro:integer;
end;
actualizar=record
  nro:integer;
  cantMen:integer;
end;
maestro=file of actualizar;
detalle=file of logs;
procedure leer(var det:detalle;var dato:logs);
begin
  if(not(eof(det))) then 
    read(det,dato)
  else
    dato.nro:=valor_alto;
end;
procedure txt_a_bin();
var ma:maestro;txtm:text;a:actualizar;
begin
  assign(ma,'maestro13');
  rewrite(ma);
  assign(txtm,'maestro13.txt');
  reset(txtm);
  while(not(eof(txtm))) do begin
    with a do
  read(txtm,nro,cantMen);
  write(ma,a);
  end;
  close(ma);
end;
procedure crearDetalle();
var det:detalle;l:logs;
begin
  assign(det,'detalle13');
  rewrite(det);
  l.nro:=0;
  while(l.nro<>-1) do begin
  writeln('Ingrese Nro de Usuario: ');
    readln(l.nro);
  if(l.nro<>-1) then
    write(det,l);
  end;
  close(det);
end;
procedure actualizarMaestro();
var ma:maestro;det:detalle;l:logs;a:actualizar;
begin
  assign(ma,'maestro13');
  reset(ma);
  assign(det,'detalle13');
  reset(det);
  leer(det,l);
   read(ma,a);
  while(l.nro<>valor_alto) do begin
    while(a.nro<>l.nro) and (l.nro<>valor_alto) do begin
      read(ma,a);
      end;
        while(a.nro=l.nro) and(l.nro<>valor_alto)do begin
          a.cantMen:=a.cantMen+1;
            leer(det,l);
        end;
    seek(ma,filepos(ma)-1);
    write(ma,a); 
  end;
  close(ma);
  close(det);
end;
procedure exportarMaestro();
var texto:text;reg:actualizar;ma:maestro;
begin
  //actualizarMaestro()// se puede hacer este llamando para cuando se da un nuevo detalle el maestro se actualize y el reporte tmb lo este
    assign(ma,'maestro13');
    reset(ma);
    assign(texto,'Informe13.txt');
    rewrite(texto);
    while (not(eof(ma))) do begin
      read(ma,reg);
      with reg do
        writeln(texto,nro,' ',cantMen);
    end;
    close(ma);
    close(texto);
end;

procedure exportarDetalleConResumen();
var det:detalle;l,act:logs;txtDR:text;cont:integer;
begin
  assign(txtDR,'detalleResumen13');
  rewrite(txtDR);
  assign(det,'detalle13');
  reset(det);
  leer(det,l);
  while(not(eof(det))) and (l.nro<>valor_alto)do begin
    act:=l;
    cont:=0;
    while(l.nro=act.nro) do begin
      cont:=cont+1;
      leer(det,l);
    end;
    writeln(txtDR,l.nro,' ',cont);
  end;
  close(det);
  close(txtDR);
end;
begin
txt_a_bin();//abre el maestro.
//crearDetalle();
actualizarMaestro();
 //exportarDetalleConResumen();
exportarMaestro();
writeln('Todo oki :)');
end.