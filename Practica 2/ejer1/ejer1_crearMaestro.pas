program ejer1_crearMaestro;
type
	empleado = record
		codigo: integer;
		nombre: String;
		monto: real;
	end;
	
	arc_maestro = file of empleado;

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

procedure cargar_archivo(var arc: arc_maestro);
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

{-------------------- PROGRAMA PRINCIPAL -----------------}

var
	arc: arc_maestro;
begin
	assign(arc, 'archivoMaestroEj1');
	cargar_archivo(arc);
	writeln('ARCHIVO MAESTRO CARGADO');
end.
