program ej10p2;
const valor_alto=9999;
type
horas=record
  depto:integer;
  divi:integer;
  num:integer;
  cate:integer;
  canth:integer;
end;
valor=record
  cate:integer;
  valor:real;
end;
maestro=file of horas;
arc_val=file of valor;
VecVal=array[1..15] of real;//cargar con el archivo y por cada cate es una pos en el vector.
procedure leer(var arc:maestro;var dato:horas);
begin
  if(not(eof(arc))) then
    read(arc,dato)
  else
    dato.depto:=valor_alto;
end;
procedure cargarVec(var vec:VecVal);
var v:valor;txtCant:text;
begin
  assign(txtCant,'categorias.txt');
  reset(txtCant);
  while(not(eof(txtCant))) do begin
    readln(txtCant,v.cate,v.valor);
    vec[v.cate]:=v.valor;
  end;
  close(txtCant);
end;
procedure txt_a_bin();
var  txt:text;ma:maestro;h:horas;
begin
  assign(txt,'maestro10.txt');//cambiarle el nombre al txt que me pasen.
  reset(txt);
  assign(ma,'maestro10');
  rewrite(ma);
  while(not(eof(txt))) do begin
    with h do
    readln(txt,depto,divi,num,cate,canth);
  write(ma,h);
  end;
  close(ma);
  close(txt);
end;

procedure recorrerMaestro(var v:VecVal);
var ma:maestro;h,aux,aux2:horas;totHsDep,totHsDiv,totHsEm,cate:integer;impACob,montTDiv,montTDep:real;
begin
  txt_a_bin();
  cargarVec(v);
  assign(ma,'maestro10');
  reset(ma);
  leer(ma,h);
  cate:=0;
  while(h.depto<>valor_alto) do begin
    aux:=h;
    totHsDep:=0;
    montTDep:=0;
    writeln('Departamento: ',h.depto);
      while(aux.depto=h.depto) do begin
        totHsDiv:=0;
        montTDiv:=0;
        aux:=h;
        writeln('Division: ',aux.divi);
          while(h.divi=aux.divi) and (h.depto<>valor_alto)and(h.depto=aux.depto) do begin
            totHsEm:=0;
            aux:=h;
            while((h.num=aux.num) and(h.depto=aux.depto) and (h.divi=aux.divi)and (h.depto<>valor_alto))do begin
              totHsEm:=totHsEm+h.canth;
              leer(ma,h);
            end;
            impACob:=v[aux.cate]*totHsEm;
            writeln('Numero de Empleado: ',aux.num,' Total de Hs: ',totHsEm,' Importe a Cobrar: ',impACob:0:2);
            montTDiv:=montTDiv+impACob;
            totHsDiv:=totHsDiv+totHsEm;
          end;
          writeln('Total Horas Division: ', totHsDiv);
          writeln('Monto Total por Division: ',montTDiv:0:2);
          totHsDep:=totHsDep+totHsDiv;
          montTDep:=montTDep+montTDiv;
      end;
      writeln('Total Horas Departamento: ', totHsDep);
      writeln('Monto Total por Departamento: ',montTDep:0:2);
  end;
  close(ma);
end;

var v:VecVal;
begin
 recorrerMaestro(v);
end.