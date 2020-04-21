program ejer1;

const
	valorAlto= 999;
type
	empleado = record
		codigo: integer;
		nombre: String;
		monto: real;
	end;
	
	arc_empleado = file of empleado;
	arc_maestro = file of empleado;

{-------LEO LA INFORMACION DEL EMPLEADO SI NO ES END OF FILE-------}

procedure leer (var arc_e: arc_empleado; var e: empleado);
begin
	if (not eof(arc_e)) then
		read(arc_e, e)
	else
		e.codigo := valorAlto;
end;

{-------RECORRO EL ARCHIVO EMPLEADO Y CARGO EL ARCHIVO MAESTRO-------}

procedure recorrido_carga(var arc_e: arc_empleado; var arc_m: arc_maestro);
var
	e, e2: empleado;
begin
	reset(arc_e);
	reset(arc_m);
	leer(arc_e, e);
	while(e.codigo <> valorAlto) do begin
		read(arc_m, e2);
		while(e.codigo = e2.codigo) do begin
			e2.monto := e2.monto + e.monto;
			leer(arc_e, e);
		end;
		seek(arc_m, filepos(arc_m)-1);
		write(arc_m, e2);
	end;
	close(arc_e);
	close(arc_m);
	writeln('Archivo maestro cargado');
	writeln();
end;

{-------------MOSTRAR EN PANTALLA EL ARCHIVO MAESTRO-----------------}

procedure imprimir_arc_maestro(var arc_m: arc_maestro);
var
	e: empleado;
begin
	reset(arc_m);
	writeln('ARCHIVO MAESTRO');
	while(not eof(arc_m)) do begin
		read(arc_m, e);
		writeln();
		writeln('Codigo: ', e.codigo);
		writeln('Nombre: ', e.nombre);
		writeln('Monto: ', e.monto:2:2);
		writeln('-------------------------');
	end;
	close(arc_m);
end;

{---------MOSTRAR EN PANTALLA EL ARCHIVO EMPLEADO----------}

procedure imprimir_arc_empleado(var arc_e: arc_empleado);
var
	e: empleado;
begin
	reset(arc_e);
	writeln('ARCHIVO EMPLEADO');
	while(not eof(arc_e)) do begin
		read(arc_e, e);
		writeln();
		writeln('Codigo: ', e.codigo);
		writeln('Nombre: ', e.nombre);
		writeln('Monto: ', e.monto:2:2);
		writeln('-------------------------');
	end;
	close(arc_e);
end;

{--------------- LEER EMPLEADOS ---------------}

procedure leer_empleado(var e: empleado);
begin
	write('Codigo: '); readln(e.codigo);
	if (e.codigo <> -1) then begin
		write('Nombre: '); readln(e.nombre);
		write('Monto: '); readln(e.monto);
		writeln('-------------');
	end;
end;

{-------------------- CARGAR ARCHIVO MAESTRO --------------}

procedure cargar_archivo_maestro(var arc: arc_maestro);
var
	e: empleado;
begin
	rewrite(arc);
	writeln('COMO PRECONDICION DEBEN ESTAR ORDENADOS POR CODIGO, Y TIENE QUE HABER UN CODIGO POR EMPLEADO');
	writeln('COMO ES EL ARCHIVO MAESTRO DEBEN ESTAR UNA SOLA VEZ CADA EMPLEADO');
	writeln();
	leer_empleado(e);
	while(e.codigo <> -1) do begin
		write(arc, e);
		leer_empleado(e);
	end;
	close(arc);
end;

{------------------ CARGAR ARCHIVO EMPLEADO -----------------}

procedure cargar_archivo_empleado(var arc: arc_empleado);
var
	e: empleado;
begin
	rewrite(arc);
	writeln('COMO PRECONDICION DEBEN ESTAR ORDENADOS POR CODIGO');
	writeln('COMO PRECONDICION EL EMPLEADO DETALLE DEBE ESTAR EN EL ARCHIVO MAESTRO');
	writeln();
	leer_empleado(e);
	while(e.codigo <> -1) do begin
		write(arc, e);
		leer_empleado(e);
	end;
	close(arc);
end;


{-----------------PROGRAMA PRINCIPAL---------------------}

var
	arc_e: arc_empleado;
	arc_m: arc_maestro;
begin
	assign(arc_e, 'archivoEmpleadoEj1');
	assign(arc_m, 'archivoMaestroEj1');
	cargar_archivo_maestro(arc_m);
	cargar_archivo_empleado(arc_e);
	imprimir_arc_empleado(arc_e);
	recorrido_carga(arc_e, arc_m);
	imprimir_arc_maestro(arc_m);
end.





















