program ejer1_cargarEmpleados;
type
	empleado = record
		codigo: integer;
		nombre: String;
		monto: real;
	end;
	
	arc_empleado = file of empleado;
	
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

{------------------ CARGAR ARCHIVO MAESTRO -----------------}

procedure cargar_archivo(var arc: arc_empleado);
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

var
	arc: arc_empleado;
begin
	assign(arc, 'archivoEmpleadoEj1');
	cargar_archivo(arc);
	writeln('ARCHIVO DETALLE CARGADO');
end.
