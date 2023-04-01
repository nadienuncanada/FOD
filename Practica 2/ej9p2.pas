program ej9p2;
const
  valor_alto=9999;
type
votos=record
  codPro:integer;
  codL:integer;
  num:integer;
  cantVo:integer;
end;
maestro=file of votos;
procedure txt_a_bin();
var ma:maestro;txtM:text;v:votos;
begin
  assign(txtM,'maestro9.txt');
  reset(txtM);
  assign(ma,'maestro9');
  rewrite(ma);
  while(not(eof(txtM))) do begin
    with v do 
      readln(txtM,codPro,codL,num,cantVo);
    write(ma,v);
  end;
  close(ma);
  close(txtM);
end;

procedure leer(var arc:maestro;var dato:votos);
begin
  if(not(eof(arc))) then
    read(arc,dato)
  else
    dato.codPro:=valor_alto;
end;

procedure contabilizar();
var ma:maestro;v,aux:votos;gvp,gvt,gvl:integer;//gvl para provincia,gvp para totales
begin
  assign(ma,'maestro9');
  reset(ma);
  leer(ma,v);
  gvl:=0;
  gvt:=0;
  gvp:=0;
  while(v.codPro<>valor_alto) do begin
    aux:=v;
    writeln('Codigo de Provincia: ',v.codPro);
      while(v.codPro=aux.codPro) and (v.codL=aux.codL) do begin
        gvp:=gvp+v.cantVo;
        with v do 
          writeln('Codigo de Localidad: ',codL,' Total de votos: ',cantVo);
        gvl:=gvl+v.cantVo;
        leer(ma,v);
      end;
      gvt:=gvt+gvp;//total de votos general
      if(v.codPro<>aux.codPro) then begin//si salio chekeo si cambio de provincia o de localidad
        writeln('Cantidad de Votos Provincia: ',gvp);
        gvp:=0;
      end
      else begin//sino cambio de mesa.
        writeln('Cantidad de Votos por Localidad:  ',gvl);
        gvl:=0;
      end;
  end;
    writeln('Total de Voto General: ', gvt);
  close(ma);
end;

begin
txt_a_bin();
contabilizar();
end.