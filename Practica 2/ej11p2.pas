program ej11p2;
const valor_alto='ZZZZZ';
type
  str=string[20];
  actualizar=record
    nom:str;
    cantA:integer;//cantidad de gente alfabetizada
    totE:integer;
  end;
  censo=record
    nom:str;
    codL:integer;
    cantA:integer;
    cantE:integer;
  end;
  maestro=file of actualizar;
  detalle=file of censo;

  procedure leer(var det:detalle;var c:censo);
  begin
  if(not(eof(det))) then
    read(det,c)
  else
    c.nom:=valor_alto;
  end;
  procedure txt_a_bin();
  var arc,arc2:detalle;c:censo;txtD,txtD2:text;
  begin
    assign(txtD,'censo.txt');
    reset(txtD);
    assign(txtD2,'censo2.txt');
    reset(txtD2);
    assign(arc,'censo11');
    rewrite(arc);
    assign(arc2,'censo11-2');
    rewrite(arc2);
    while(not(eof(txtD))) do begin
      with c do begin
        readln(txtD,codL,cantA,cantE);
        readln(txtD,nom);
      end;
      write(arc,c);
      writeln('hola');
    end;
    while(not(eof(txtD2))) do begin
      with c do begin
        readln(txtD2,codL,cantA,cantE);
        readln(txtD2,nom);
      end;
      write(arc2,c);
    end;
    close(txtD);
    close(txtD2);
    close(arc);
    close(arc2);
  end;
  procedure crearMaestro();
  var ma:maestro;a:actualizar;
  begin
    assign(ma,'maestro11');
    rewrite(ma);
    a.nom:='A';
    while(a.nom<>'ZZZ') do begin
      writeln('Ingrese Nombre de Provincia: ');
        readln(a.nom);
      if(a.nom<>'ZZZ') then begin
        writeln('Cantidad Alfabetos: ');
          readln(a.cantA);
        writeln('Totale Encuestados: ');
          readln(a.totE);
        write(ma,a);
      end;
    end;
    close(ma);
  end;

  procedure Minimo (var det:detalle;var det2:detalle;var min,reg,reg2:censo);
  begin
    //min:=valor_alto;
    if(reg.nom<=reg2.nom) then begin
      min:=reg;
      leer(det,reg);
    end
    else begin
    min:=reg2;
    leer(det2,reg2);
    end;
  end;
  procedure actualizarMaestro();
  var ma:maestro;det:detalle;det2:detalle;min,reg,reg2,aux:censo;a:actualizar;
  begin
    assign(det,'censo11');
    reset(det);
    assign(det2,'censo11-2');
    reset(det2);
    assign(ma,'maestro11');
    reset(ma);
    leer(det,reg);
    leer(det2,reg2);
    Minimo(det,det2,min,reg,reg2);
    while(min.nom<>valor_alto) do begin
      read(ma,a);
       writeln('Maestro: ',a.nom);
       writeln('Minimo: ',min.nom);
        writeln(a.nom=min.nom);
      while(a.nom<>min.nom) do begin
        read(ma,a);
      end;
      while(min.nom=a.nom) do begin
        a.cantA:=a.cantA+min.cantA;
        a.totE:=a.totE+min.cantE;
        Minimo(det,det2,min,reg,reg2);
      end;
      seek(ma,filepos(ma)-1);
      write(ma,a);
    end;
    close(ma);
    close(det);
    close(det2);
  end;
procedure exportarMaestro();
var texto:text;reg:actualizar;ma:maestro;
begin
    assign(ma,'maestro11');
    reset(ma);
    assign(texto,'maestro11.txt');
    rewrite(texto);
    while (not(eof(ma))) do
    begin
        read(ma,reg);
        with reg do
        begin
            writeln(texto, 'Provincia: ',nom,'| cant: ', cantA,'| enc: ', totE);
        end;
    end;
    close(ma);
    close(texto);
end;
begin
// txt_a_bin();
 //crearMaestro();
 //actualizarMaestro();
 //exportarMaestro();
//una vez que el programa corre despues los valores se van aumentando.
end.