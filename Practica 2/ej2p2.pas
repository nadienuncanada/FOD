program ej2p2 ;
const
  valor_alto=9999;
type
str=string[12];
maestro=record
  codinteger;
  apestr;
  nomstr;
  matsFinteger;
  matcFinteger;
end;
detalle=record
  codinteger;
  matsFinteger;
  matcFinteger;
end;
archM=file of maestro;
archD=file of detalle;
procedure abrir_mae(var archMaearchM;var txtmtext);
begin
  assign(txtm,'maestroej2.txt');
  reset(txtm);
  assign(archMae,'maestroB');
  rewrite(archMae);
end;
procedure abrir_det(var archDearchD;var txtdtext);
begin
  assign(txtd,'detalleej2.txt');
  reset(txtd);
  assign(archDe,'detalleB');
  rewrite(archDe);
end;
procedure txt_a_bin();invocar
var archMaearchM;archDearchD;txtd,txtmtext;ddetalle;mmaestro;
begin
  abrir_mae(archMae,txtm);
  abrir_det(archDe,txtd);
  while(not(EOF(txtd))) do begin
    with d do begin
      readln(txtd,cod,matsF,matcF);
    end;
    write(archDe,d);
  end;
  while(not(EOF(txtm))) do begin
    with m do begin
      readln(txtm,cod,ape);
      readln(txtm,matsF,matcF,nom);
    end;
    write(archMae,m);
  end;
  close(archDe);
  close(archMae);
  close(txtd);
  close(txtm);
end;
procedure leer(var archDearchD;var datodetalle);
begin
  if(not(eof(archDe))) then
  read(archDe,dato)
  else
    dato.cod=valor_alto;
end;
procedure act_maes();invocar
var archDearchD;archMaearchM;regmmaestro;regddetalle;auxCod,CF,SFinteger;
begin
 assign(archDe,'detalleB');abrimos el detalle
 assign(archMae,'maestroB');abrimos el maestro
 reset(archDe);leer y esc
 reset(archMae);leer y es
 read(archMae,regm);leemos el primer maestro
 leer(archDe,regd);arrancamos el detalle
  while(regd.codvalor_alto) do beginmientras no se final del detalle
    auxCod=regd.cod;aux guarda el cod
    CF=0;contador
    SF=0;contador
    while(auxCod=regd.cod) do beginmientras estemeos en el mismo cod
      CF=CF+regd.matcF;acumulamos datos
      SF=SF+regd.matsF;acumulamos datos
      leer(archDe,regd);seguimos leyendo
    end;
    while(auxCodregm.cod) do si llegamos aca es porque cambiamos de detalle
      read(archMae,regm);buscamos el maestro siguiente, ya que tenemos el sig detalle
    regm.matsF=regm.matsF+SF;
    regm.matcF=regm.matcF+CF;modificamos el maestro
    seek(archMae,filepos(archMae)-1); nos corremos uno para atras para guardalor bien, ya que siempre se hace un read al principio o en el while de arriba
    write(archMae,regm);escribimos dato
  end;end del primer while
  close(archDe);
  close(archMae);
end;
procedure bin_a_txt();invocar para ver reflejado los cambios en txt
var archMaearchM;txtmtext;mmaestro;
begin
    assign(archMae,'maestroB');
    reset(archMae);
    assign(txtm,'maestroej2.txt');
    rewrite(txtm);
  while(not(eof(archMae))) do begin
    read(archMae,m);
    with m do begin
      writeln(txtm,cod,ape);
      writeln(txtm,matsF,' ',matcF,nom);
    end;
  end;
  close(archMae);
  close(txtm);
end;
procedure bin_a_txt_4();invocar para ver reflejado los cambios en txt
var archMaearchM;txtmtext;mmaestro;
begin
    assign(archMae,'maestroB');
    reset(archMae);
    assign(txtm,'maestroej2.txt');
    rewrite(txtm);
  while(not(eof(archMae))) do begin
    read(archMae,m);
    if(m.matsF4) then begin
      with m do begin
        writeln(txtm,cod,ape);
        writeln(txtm,matsF,' ',matcF,nom);
      end;
    end;
  end;
  close(archMae);
  close(txtm);
end;
begin
 txt_a_bin();
 act_maes();
 bin_a_txt();
 bin_a_txt_4();imprime solo los que tienen mas de 4 cursadas
end.