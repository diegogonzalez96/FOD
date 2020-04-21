program ejer3;

const
	valorAlto = 999;

type
	producto = record
		codigo: integer;
		descripcion: string;
		precio: real;
		stock_actual: integer;
		stock_minimo: integer;
	end;
	
	pedido = record
		codigo: integer;
		cantidad: integer;
	end;
	
	arc_maestro = file of producto;
	arc_detalle = file of pedido;
	
	vector_detalle = array[1..4] of arc_detalle;
	vector_registro = array[1..4] of pedido;
	
{----------------- LEER PRODUCTO MAESTRO ---------------}

procedure leer_producto(var p: producto);
begin
	write('Codigo: '); readln(p.codigo);
	if (p.codigo <> -1) then begin
		write('Descripcion: '); readln(p.descripcion);
		write('Precio: '); readln(p.precio);
		write('Stock actual: '); readln(p.stock_actual);
		write('Stock minimo: '); readln(p.stock_minimo);
		writeln('-------------');
	end;
end;

{--------------------- CARGAR ARCHIVO MAESTRO ----------------------}
	
procedure cargar_archivo_maestro(var arc: arc_maestro);
var
	p: producto;
begin
	rewrite(arc);
	leer_producto(p);
	while(p.codigo <> -1) do begin
		write(arc, p);
		leer_producto(p);
	end;
	close(arc);
	writeln('ARCHIVO MAESTRO CARGADO');
end;

{-------------MOSTRAR EN PANTALLA EL ARCHIVO MAESTRO-----------------}

procedure imprimir_arc_maestro(var arc_m: arc_maestro);
var
	p: producto;
begin
	reset(arc_m);
	writeln('ARCHIVO MAESTRO');
	while(not eof(arc_m)) do begin
		read(arc_m, p);
		writeln();
		writeln('Codigo: ', p.codigo );
		writeln('Descripcion: ', p.descripcion);
		writeln('Precio: ', p.precio:2:2);
		writeln('Stock actual: ', p.stock_actual);
		writeln('Stock minimo: ', p.stock_minimo);
		writeln('-------------------------');
	end;
	close(arc_m);
end;

{------------------ LEER PEDIDOS DETALLE --------------}

procedure leer_detalle(var pd: pedido);
begin
	write('Codigo: '); readln(pd.codigo);
	if (pd.codigo <> -1) then begin
		write('Cantidad: '); readln(pd.cantidad);
		writeln('-------------');
	end;
end;

{-------------- CARGAR ARCHIVOS DETALLE DE LAS 4 SUCURSALES ---------}

procedure cargar_archivo_detalle(var vec_d: vector_detalle);
var
	i: integer; 
	pd: pedido;
begin
	for i:= 1 to 4 do begin
		rewrite(vec_d[i]);
		writeln('CARGAR SUCURSAL ', i);
		writeln();
		leer_detalle(pd);
		while(pd.codigo <> -1) do begin
			write(vec_d[i], pd);
			leer_detalle(pd);
		end;
		writeln('SUCURSAL ', i, ' CARGADA');
	end; 
	writeln();
	writeln('ARCHIVO DETALLE CARGADO');
end;

{---------MOSTRAR EN PANTALLA EL ARCHIVO DETALLE----------}

procedure imprimir_arc_detalle(var vec_d: vector_detalle);
var
	pd: pedido;
	i: integer;
begin
	writeln();
	writeln('ARCHIVO DETALLE');
	for i:= 1 to 4 do begin
		reset(vec_d[i]);
		writeln('SUCURSAL ', i);
		while(not eof(vec_d[i])) do begin
			read(vec_d[i], pd);
			writeln();
			writeln('Codigo: ', pd.codigo);
			writeln('Cantidad: ', pd.cantidad);
			writeln('-------------------------');
		end;
		close(vec_d[i]);
	end;
end;

{--------------- LEO EL REGISTRO SI NO LLEGO A SU FINAL -----------}

procedure leer (var arc_d: arc_detalle; var pd: pedido);
begin
	if (not eof(arc_d)) then begin
		read(arc_d, pd);
	end
	else
		pd.codigo:= valorAlto;
end;

{----------------- MINIMO --------------}

procedure minimo (var vec_d:vector_detalle; var vec_r:vector_registro; var reg_min:pedido; var suc: integer);
var
   reg: pedido;  
   i, posMin, aux:integer;
begin
     reg_min.codigo:= valorAlto;
     aux:= 9999;
     for i:= 1 to 4 do begin
         if (vec_r[i].codigo < aux) then begin
            aux:= vec_r[i].codigo;
            reg_min:= vec_r[i];
            posMin:= i;
         end;
     end;
     if (reg_min.codigo <> valorAlto) then begin 
        leer(vec_d[posMin], reg);
        vec_r[posMin]:= reg;
        suc:= posMin;
     end;
end;

{-------------- IMPRIMIR REGISTRO ----------------}

procedure imprimir_registro(p: producto);
begin
	writeln('Codigo: ', p.codigo);
	writeln('Descripcion: ', p.descripcion);
	writeln('Precio: ', p.precio:2:2);
	writeln('Stock actual: ', p.stock_actual);
	writeln('Stock minimo: ', p.stock_minimo);
	writeln('-------------');
end;

{--------------- ACTUALIZAR MAESTRO -------------}

procedure actualizar_maestro(var arc_m: arc_maestro; var vec_d: vector_detalle);
var
	vec_r: vector_registro;
	prod: producto;
	reg_min: pedido;
	suc,i: integer;
begin
	for i:= 1 to 4 do begin
		reset(vec_d[i]);
		leer(vec_d[i], vec_r[i]); // PONGO EN EL VECTOR REGISTRO EL PRIMER ELEMENTO DE CADA DETALLE
	end;
	reset(arc_m);
	minimo(vec_d, vec_r, reg_min, suc); //SACO EL MINIMO ENTRE LOS ELEMENTOS DEL VECTOR REGISTRO
	while(reg_min.codigo <> valorAlto) do begin
		read(arc_m, prod);
		while(prod.codigo <> reg_min.codigo) do 
			read(arc_m, prod);
		while(prod.codigo = reg_min.codigo) do begin
			if (prod.stock_actual >= reg_min.cantidad) then //SI EL STOCK ACTUAL ES MAYOR O IGUAL A LA CANTIDAD HAGO EL PEDIDO Y RESTO EL STOCK
				prod.stock_actual:= prod.stock_actual - reg_min.cantidad
			else begin
				writeln('No se pudo satisfacer');
				writeln('Sucursal ', suc );
				imprimir_registro(prod);
				writeln('Cantidad que no pudo ser enviada: ', (reg_min.cantidad - prod.stock_actual));
				prod.stock_actual:= 0;
			end;
			if (prod.stock_actual < prod.stock_minimo) then begin //PREGUNTO SI EL STOCK QUE QUEDO ES MENOR AL STOCK MINIMO
				writeln('Producto debajo del stock minimo');
				imprimir_registro(prod);
			end;
			minimo(vec_d, vec_r, reg_min, suc);
		end;
		seek(arc_m,(filePos(arc_m)-1));
		write(arc_m, prod);
	end;
	close(arc_m);
end;


var
	arc_m: arc_maestro;
	vec_d: vector_detalle;
	i: integer;
	j: string;
begin
	assign(arc_m, 'ejer3_archivoMaestro');
	writeln('CARGAR ARCHIVO MAESTRO');
	cargar_archivo_maestro(arc_m);
	imprimir_arc_maestro(arc_m);
	for i:= 1 to 4 do begin
		str(i, j);
		assign(vec_d[i], 'detalle' + j);
	end;
	writeln('CARGAR ARCHIVOS DETALLES');
	cargar_archivo_detalle(vec_d);
	imprimir_arc_detalle(vec_d);
	actualizar_maestro(arc_m, vec_d);
	imprimir_arc_maestro(arc_m);
end.













	
