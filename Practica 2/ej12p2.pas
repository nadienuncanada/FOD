program ej12p2;
const valor_alto=9999;
type
acceso=record
  anio:integer;
  mes:integer;
  dia:integer;
  id:integer;
  tiempo:integer;
end;
  archivo=file of acceso;
procedure importarArchivo();
var arch:archivo; a:acceso; texto:text;
begin
    assign(arch, 'accesos');
    rewrite(arch);
    assign(texto, 'accesos.txt');
    reset(texto);
    while(not(eof(texto))) do
    begin
        with a do
        begin
            read(texto, anio, mes, dia, id, tiempo);
        end;
        write(arch, a);
    end;
    close(arch);
    close(texto);
end;
procedure leer(var arch:archivo;var dato:acceso);
begin
  if(not(eof(arch))) then
    read(arch,dato)
  else
    dato.mes:=valor_alto;
end;
procedure recorrerArch(num:integer);
var arch:archivo;a,aux:acceso;totT,totTM,totTA:integer;
begin
  assign(arch,'accesos');
  reset(arch);
  leer(arch,a);
  while(a.anio<>num) and (a.mes<>valor_alto)do
    leer(arch,a);
  if(a.anio=num) then begin
    writeln('---------------Anio: ',a.anio,'----------------------');
     totTA:=0;
    while(a.anio=num) do begin//me fui del anio pedido
      aux:=a;
        while((a.mes=aux.mes)and(a.mes<>valor_alto)) do begin //cambia el mes
          writeln('Mes: ',a.mes);
            aux:=a;
            totTM:=0;
            while((a.dia=aux.dia) and(a.mes=aux.mes) and (a.mes<>valor_alto)) do begin//cuando cambia el dia
              writeln('Dia: ',a.dia);
                aux:=a;
                totT:=0;
                  while((a.id=aux.id) and (a.dia=aux.dia) and(a.mes=aux.mes) and (a.mes<>valor_alto)) do begin// cuando cambia el id
                    totT:=totT+a.tiempo;
                    leer(arch,a);
                  end;
                  totTM:=totTM+totT;
                  writeln('Id: ',aux.id,' Tiempo Total de acceso en el dia: ',aux.dia,' mes: ',aux.mes,' es: ',totT);//se imprime despues de cambiar de dia,pero puede ser el mismo id
            end;
            totTA:=totTA+totTM;
          writeln('Total de tiempo de acceso mes: ',aux.mes,' es:',totTM);  
          writeln('----------------Cambio de Mes--------------------');
        end;
    end;
    writeln('Total de tiempo de acceso anio: ',totTA);
  end
  else  
    writeln('El anio no se encuentra!');
  close(arch);
end;
begin
  importarArchivo();
  recorrerArch(2021);
end.