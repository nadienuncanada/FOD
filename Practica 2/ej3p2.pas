program ej3p2;
const valor_alto=9999;
  df=30;
type
str=string[20];
productos=record
  cod:integer;
  nom:str;
  desc:str;
  sd:integer;
  sm:integer;
  pre:real;
end;
ventas=record
  cod:integer;
  cant:integer;
end;
maestro=file of productos;
detalle=file of ventas;
arc_det= array[1..df] of file of ventas;
reg_det=array[1..df] of ventas;
procedure leer(var arch:detalle,var dato:ventas);
begin
  if(not(eof(arch))) then
    read(arch,dato)
  else
    dato.cod:=valor_alto;
end;
procedure minimo(var r_det:reg_det;var min:ventas;var deta:arc_det);
var i,actual,aux,tot:integer;mae:maestro;reg:productos;
begin
  min.cod:=valor_alto;
  for i:=0 to df do begin
    if(r_det[i].cod<min.cod) then begin//recorres el vector de ventas actualizando min y la pos
        actual:=i;//despues va a servir para saber que dato actualizar
        min:=r_det[i];//actualizas minimo
      end;
    if(min.cod <> valor_alto) then
      leer(deta[actual],r_det[actual]);//cargas el vector con el archivo del actual que usaste/fue le minimo y hay que cambiarlo
  end;
  for i:= 1 to n do begin//preparar todos los detalles con nombre det i,y prepararlos en el array.
    assign (deta[i], 'det'+i); 
    reset(deta[i]);
    leer(deta[i],r_det[i]);
  end;
  assign(mae,'maestro');//abrimos el maestro
  reset(mae);//lo ponemos para modificarlo
  minimo(r_det,min,deta);//llamamos a minimo
  while(min.cod<>valor_alto) do begin //emepezamos a trabajar con lo que minimo nos dejo
    aux:=min.cod;//guardamos el cod del minimo
    tot:=0;//lo utilizamos para ir guardando las cant de ventas para luego al maestro restarle al stock
    while(aux=min.cod) do begin// mientras sigamos en el mismo cod
      tot:=tot+min.cant;//actualizamos tot
      minimo(r_det,min,deta);//llamamos a minimo para chekear el siguiente minimo y si es el mismo se actualiza el tot
    end;
    read(mae,reg);//leemos maestro
    while(reg.cod<>aux) do //hasta que no sea el mismo codigo
      read(mae,reg);//lo buscamos hasta encontrarlo comprandolo con aux que tiene el cod del minimo
      reg.sd:=reg.sd-tot;//actualizamos el stock del maestro
      seek(mae,filepos(mae)-1);//posicionamos
      write(mae,reg);//guardamos
  end;
  close(mae);//cerramos el maestro que fue actualizado
  for i:=0 to df do// cerramos todos los archivos.
    close(reg_det[i]);
end;
//Además, se deberá informar en un archivo de texto: nombre de producto,
//descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
//debajo del stock mínimo.

procedure sinStock();
var arch:maestro;texto:text;p:productos;
begin
  assign(texto,'sinStock.txt');//asigno un arch txt
  rewrite(texto);// lo hago solo para escribir
  assign(mae,'maestro');//agarro el maestro
  reset(mae);//
  while(not(eof(mae))) do begin
  read(mae,p);
  if(p.sd<p.sm) then begin
    with p begin
      writeln(texto,cod,nom);
      writeln(texto,sd,sm,pre,desc);
    end;
  end;
 end;
 close(mae);
end;

var min:ventas;r_det:reg_det;deta:arc_det
begin
 minimo(r_det,min,deta);
 sinStock();
end.