program ej5p2;
const valor_alto=9999;
df=50;
type
str=string[20];
nacimientos=record
  nro:integer;
  nom:str;
  matriM:str;
end;
fallecimientos=record
  nro:integer;
  nomF:str;
  matriMF:str;
  fe:integer;
  hora:integer;
  lugar:str;
end;
recopilacion=record
  nro:integer;
  nom:str;
  matriM:str;//nacimiento
  matriMF:str;//fallecimiento
  fe:integer;
  hora:integer;
  lugar:str;
end;
maestro=file of recopilacion;
detalles=file of nacimientos;//archivo tipo nacimiento
detalles2=file of fallecimientos;//archivo tipo fallecimiento
arc_det=array[1..df] of file of nacimientos;//array de arch nacimientos
arc_det2=array[1..df] of file of fallecimientos;//array de arch fallecimientos
reg_det=array[1..df] of nacimientos;//array de nacimientos
reg_det2=array[1..df] of fallecimientos;//array de fallecimientos
procedure leer(var arc:detalles;var dato:nacimientos);
begin
  if(not(eof(arc))) then
    read(arc,dato)
  else
    dato.nro:=valor_alto;
end;
procedure leer2(var arc:detalles2;var dato:fallecimientos);
begin
  if(not(eof(arc))) then
    read(arc,dato)
  else
    dato.nro:=valor_alto;
end;
procedure ini_det(var arc:arc_det;var arc2:arc_det2;var r_det:reg_det;var r_det2:reg_det2);
var i:integer;s:string;
begin
  for i:=1 to df do begin
    //Str(i,s);
    assign(arc[i],'det');//+s
    assign(arc2[i],'det2');//+s
    reset(arc[i]);
    reset(arc2[i]);
    leer(arc[i],r_det[i]);
    leer2(arc2[i],r_det2[i])
  end;
end;

procedure minimo(var deta:arc_det;var r_det:reg_det;var min:nacimientos);
var i,actual:integer;
begin
  min.nro:=valor_alto;
  for i:=1 to df do begin
    if(r_det[i].nro<min.nro) then begin
      min:=r_det[i];
      actual:=i;
    end;
  end;
  if(min.nro<>valor_alto) then 
    leer(deta[actual],r_det[actual]);
end;
procedure minimo2(var deta2:arc_det2;var r_det2:reg_det2;var min2:fallecimientos);
var i,actual2:integer;
begin
  min2.nro:=valor_alto;
  for i:=1 to df do begin
    if(r_det2[i].nro=min2.nro) then begin
      min2:=r_det2[i];
      actual2:=i;
    end;
  end;
  if(min2.nro<>valor_alto) then 
    leer2(deta2[actual2],r_det2[actual2]);
end;
procedure close_all(var deta:arc_det;var deta2:arc_det2);
var i:integer;
begin
  for i:=1 to df do begin
    close(deta[i]);
    close(deta2[i]);
  end;
end;
procedure crearMaestro(var Mae:maestro;var deta:arc_det;var deta2:arc_det2);//si el codigo del min es igual al min2 entonces encontre ambas cosas, sino sigue vivo,
var r_det:reg_det;r_det2:reg_det2;min:nacimientos;min2:fallecimientos;r:recopilacion;
begin
  ini_det(deta,deta2,r_det,r_det2);
  assign(Mae,'maestro');
  rewrite(Mae);
  minimo(deta,r_det,min);//inicializo min=nacidos
  minimo2(deta2,r_det2,min2);//inicializo min2=fallecidos
  while(min.nro<>valor_alto) do begin//sigue iterando hasta no tener mas vivos
    r.nro:=min.nro;//se llena nro,nom,matriM
    r.nom:=min.nom;
    r.matriM:=min.matriM;
    if(min.nro=min2.nro) then begin //si son iguales los codigos encontre tanto naci como falleci
      r.matriMF:=min2.matriMF;
      r.fe:=min2.fe;
      r.lugar:=min2.lugar;
      minimo2(deta2,r_det2,min2);//llamo al min2 que actualiza fallecidos
    end
    else begin// si no fallecio relleno los campos con "error"
      r.matriMF:='-1';
      r.fe:=-1;
      r.lugar:='No murio';
     end;
    write(Mae,r);
    minimo(deta,r_det,min);//llamo a minimo siempre mientras min.cod<>valor_alto.
  end;
  close(Mae);//cierro los archivos con los que trabajo
  close_all(deta,deta2);
end;
procedure bin_a_txt();
var ma:maestro;texto:text;r:recopilacion;
begin
  assign(ma,'maestro');
  reset(ma);
  assign(texto,'maestro.txt');
  rewrite(texto);
  while(not(eof(ma))) do begin
    read(ma,r);
    with r do begin
      writeln('Nro: ',nro,' Nombre: ',nom);
      writeln('Matricula Medico Nacimiento: ',matriM);
      writeln('Matricual Medico Fallecimiento: ',matriMF);
      writeln(' Fecha de Fallecimiento: ',fe,' Lugar de Fallecimiento: ',lugar);
      writeln('Hora de fallecimiento: ',hora);
    end;
  end;
end;

var Mae:maestro;deta:arc_det;deta2:arc_det2;
begin
 crearMaestro(Mae,deta,deta2);
end.