program ej18p2;
const valor_alto=9999;
type
str=string[50];
fecha=record
  dia:integer;
  mes:integer;
  anio:integer;
end;
casos=record
  codL:integer;
  nomL:str;
  codM:integer;
  nomM:str;
  codH:integer;
  nomH:str;
  f:fecha;
  cantP:integer;
end;
archivo=file of casos;
procedure txt_a_bin();
var texto:text;arc:archivo;c:casos;
begin
  assign(texto,'casos18.txt');
  reset(texto);
  assign(arc,'casos18');
  rewrite(arc);
  while(not(eof(texto))) do begin
    with c do begin
      readln(texto,codL,nomL);
      readln(texto,codM,nomM);
      readln(texto,codH,nomH);
      readln(texto,f.dia,f.mes,f.anio,cantP);
    end;
    write(arc,c);
  end;
  close(texto);
  close(arc);
end;
procedure leer(var arc:archivo;var dato:casos);
begin
  if(not(eof(arc))) then
    read(arc,dato)
  else
  dato.codL:=valor_alto;
end;
procedure listado();
var arc:archivo;c,aux:casos;cantCMun,cantCLoc,cantCTotP,cantCasoH:integer;textoR:text;
begin
  assign(textoR,'ResumenMunicipios18.txt');
  rewrite(textoR);
  assign(arc,'casos18');
  reset(arc);
  leer(arc,c);
  cantCTotP:=0;
  while(c.codL<>valor_alto) do begin
    writeln('Nombre de localidad: ',c.nomL); 
    aux:=c;
     cantCLoc:=0;
    while(c.codL=aux.codL) do begin
      writeln('Nombre de Municipio: ',aux.nomM);
      cantCMun:=0;
      while(c.codL=aux.codL) and (c.codM=aux.codM) do begin
        aux:=c;
        cantCasoH:=0;
        writeln('Nombre de Hospital: ',aux.nomH);
        while(c.codL=aux.codL) and(c.codM=aux.codM) and(c.codH=aux.codH) do begin 
          cantCasoH:=cantCasoH+c.cantP;
          leer(arc,c);
        end;
        writeln('Cantidad de casos: ',cantCasoH);
        cantCMun:=cantCMun+cantCasoH;
      end;
      writeln('Cantidad de Casos Municipio: ',cantCMun);
      cantCLoc:=cantCLoc+cantCMun;
      if(cantCMun>=1500) then begin
        writeln(textoR,cantCMun,' ',aux.nomL);
        writeln(textoR,aux.nomM);
      end;
    end;
      writeln('Cantidad de Casos Localidad: ',aux.nomL,' son: ',cantCLoc);
      cantCTotP:=cantCTotP+cantCLoc;
  end;
  writeln('Cantidad de Casos totales en la Provincia: ',cantCTotP);
  close(arc);
  close(textoR);
end;
begin
 txt_a_bin();
 listado();
end.