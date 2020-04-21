program ejer5;

const
	valorAlto = 9999;
	
type
	producto = record
		codigo: integer;
		nombre: string;
		precio: real;
		stock_actual: integer;
		stock_minimo: integer;
	end;
	
	venta = record
		codigo: integer;
		cant: integer;
	end;
	
	detalle = file of venta;
	maestro = file of producto;
	
{---------------- CREO EL ARCHIVO MAESTRO -------------------}

procedure crear_maestro(var mae: maestro);
var
	txt: Text;
	p: producto;
begin
	assign(txt, 'productos.txt');
	reset(txt);
	rewrite(mae);
	while(not eof(txt)) do begin
		readln(txt, p.codigo, p.nombre);
		readln(txt, p.precio, p.stock_actual, p.stock_minimo);
		write(mae, p);
	end;
	close(txt);
	close(mae);
	writeln('ARCHIVO MAESTRO CARGADO');
	writeln('--------------------------');
end;

{--------------- CREO EL ARCHIVO DETALLE -----------------}

procedure crear_detalle(var det: detalle);
var
	txt: text;
	v: venta;
begin
	assign(txt, 'ventas.txt');
	reset(txt);
	rewrite(det);
	while(not eof(txt)) do begin
		readln(txt, v.codigo, v.cant);
		write(det, v);
	end;
	close(txt);
	close(det);
	writeln('ARCHIVO DETALLE CARGADO');
	writeln('--------------------------');
end;

{------------- MOSTRAR EN PANTALLA EL ARCHIVO MAESTRO -----------------}

procedure imprimir_maestro(var mae: maestro);
var
	p: producto;
begin
	reset(mae);
	writeln('ARCHIVO MAESTRO');
	while(not eof(mae)) do begin
		read(mae, p);
		writeln();
		writeln('Codigo: ', p.codigo );
		writeln('Descripcion: ', p.nombre);
		writeln('Precio: ', p.precio:2:2);
		writeln('Stock actual: ', p.stock_actual);
		writeln('Stock minimo: ', p.stock_minimo);
		writeln('-------------------------');
	end;
	close(mae);
end;

{------------- MOSTRAR EN PANTALLA EL ARCHIVO DETALLE -----------------}

procedure imprimir_detalle(var det: detalle);
var
	v: venta;
begin
	reset(det);
	writeln('ARCHIVO DETALLE');
	while(not eof(det)) do begin
		read(det, v);
		writeln();
		write('Codigo: ',v.codigo );
		writeln(' / Cantidad vendida: ', v.cant);
		writeln('-------------------------');
	end;
	close(det);
end;

{------------------- LISTAR ARCHIVO MAESTRO ---------------------}

procedure listar_maestro(var mae: maestro);
var
	txt: text;
	p: producto;
begin
	assign(txt, 'reporte.txt');
	rewrite(txt);
	reset(mae);
	while (not eof(mae)) do begin
		read(mae, p);
		writeln(txt, p.codigo, p.nombre);
		writeln(txt, p.precio:2:2, ' ', p.stock_actual, ' ', p.stock_minimo);
	end;
	close(mae);
	close(txt);
	writeln('ARCHIVO DE TEXTO "reporte.txt" CARGADO.');
	writeln('--------------------------');
end;

{--------------------- LEER ARCHIVO ----------------------}

procedure leer(var det:detalle; var aux:venta);
begin
	if(not eof(det)) then begin
		read(det,aux);
    end
    else begin
      aux.codigo:= valorAlto;
    end;
end;

{---------------------- ACTUALIZAR MAESTRO ----------------------}

procedure actualizar_maestro(var mae: maestro; var det: detalle);
var
	p: producto;
	v: venta;
	codAct: integer;
begin
	reset(mae);
	reset(det);
	leer(det, v);
	while (v.codigo <> valoralto) do begin
		read(mae, p);
		while (p.codigo <> v.codigo) do
			read(mae, p);
		codAct:= v.codigo;
		while (codAct = v.codigo) do begin
			p.stock_actual:= p.stock_actual - v.cant;
			leer(det, v);
		end;
		seek(mae, FilePos(mae)- 1);
		write(mae, p);
	end;
    close(mae);
    close(det);
    writeln('ACHIVO MAESTRO ACTUALIZADO');
	writeln();
end;

{-------- LISTAR PRODUCTOS DEBAJO DE STOCK MINIMO ---------}

procedure listar_StockMinimo(var mae: maestro);
var
	txt: text;
	p: producto;
begin
	assign(txt, 'stock_minimo.txt');
	rewrite(txt);
	reset(mae);
	while (not eof(mae)) do begin
		read(mae, p);
		if (p.stock_actual < p.stock_minimo) then begin
			writeln(txt, p.codigo, p.nombre);
			writeln(txt, p.precio:2:2, ' ', p.stock_actual, ' ', p.stock_minimo);
		end;
	end;
	close(mae);
	close(txt);
	writeln('ARCHIVO DE TEXTO "stock_minimo.txt" CARGADO.');
	writeln('--------------------------');
end;

{-------------- PROGRAMA PRINCIPAL --------------}

var
	mae: maestro;
	det: detalle;
begin
	assign(mae, 'ejer5_arcMaestro');
	assign(det, 'ejer5_arcDetalle');
	crear_maestro(mae);
	imprimir_maestro(mae);
	listar_maestro(mae);
	crear_detalle(det);
	imprimir_detalle(det);
	actualizar_maestro(mae, det);
	imprimir_maestro(mae);
	listar_StockMinimo(mae);
end.
