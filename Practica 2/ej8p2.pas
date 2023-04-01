program ej8p2;//esta bien pero no tan bien, funciona pero pedian los datos de otra manera, pero fue anda bien, habria que cambiarle un poco la logica y poco mas(en los cortes de control y eso).
const valor_alto=9999;
type
str=string[12];
  cliente=record 
    cod:integer;
    nom:str;
    ape:str;
    anio:integer;
    mes:integer;
    dia:integer;
    mont:real;
  end;
  maestro=file of cliente;
  procedure leer(var arc:maestro;var dato:cliente);
  begin
    if(not(eof(arc))) then
      read(arc,dato)
    else
      dato.cod:=valor_alto;
  end;
  procedure txt_a_bin();
  var ma:maestro;c:cliente;textoM:text;
  begin
    assign(textoM,'maestro8.txt');
    reset(textoM);
    assign(ma,'maestro8');
    rewrite(ma);
    while(not(eof(textoM))) do begin
      with c do begin
        readln(textoM,cod,mont,nom);
        readln(textoM,anio,mes,dia,ape);
      end;
      write(ma,c);
    end;
    close(ma);
    close(textoM);
  end;
  procedure recopilarMaestro();
  var ma:maestro;c,aux:cliente;montT:real;
  begin
    assign(ma,'maestro8');
    reset(ma);
    leer(ma,c);
    while(c.cod<>valor_alto) do begin
      aux:=c;
      montT:=0;
      while(c.anio=aux.anio) and (c.mes=aux.mes) and(c.cod<>valor_alto) do begin//esto es mientras siga siendo el mismo mes y anio, y la lista no se hjaya terminado
        montT:=montT+c.mont;//guarda el monto hasta q se cambie de anio 
        with c do begin
          writeln('Codigo: ',cod,' Monto: ',mont:0:2,' Nombre:',nom);//escribe los datos
          writeln('Anio: ',anio,' Mes: ',mes,' Dia: ',dia,' Apellido: ',ape);//escribe los datos
        end;
        leer(ma,c);//sigue leyendo
      end;
      writeln('-----RESUMEN-----: Anio: ',aux.anio,' Cod: ',aux.cod,' Nombre: ',aux.nom,'Monto total del anio: ',montT:0:2);//cambio anio 
    end;
  end;

begin
 txt_a_bin();
 recopilarMaestro();
end.