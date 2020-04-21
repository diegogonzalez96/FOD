program ejer3;
type
	empleado = record
		numero: integer;
		apellido: String;
		nombre: String;
		edad: integer;
		dni: integer;
	end;
	
	arc_empleado = file of empleado;
	
{---------------------LEER REGISTRO------------------------------}
	
procedure leer_empleado (var e: empleado);
begin
	writeln('Ingrese apellido de empleado: ');
	readln(e.apellido);
	if (e.apellido <> ' ') then begin
		writeln('Ingrese numero de empleado: ');
		readln(e.numero);
		writeln('Ingrese nombre de empleado: ');
		readln(e.nombre);
		writeln('Ingrese edad de empleado: ');
		readln(e.edad);
		writeln('Ingrese dni de empleado: ');
		readln(e.dni);
	end;
end;

{------------------------CREAR ARCHIVO----------------------------}

procedure crear_archivo (var arc_logico: arc_empleado; var arc_fisico:String);
var
	e: empleado;
begin
	writeln('Ingrese nombre fisico: ');
	readln(arc_fisico);
	assign(arc_logico, arc_fisico);
	rewrite(arc_logico);
	leer_empleado(e);
	while (e.apellido <> ' ') do begin
		write(arc_logico,e);
		leer_empleado(e);
	end;
	close(arc_logico);
end;

{---------------------IMPRIMIR REGISTRO-------------------------}

procedure imprimir_registro (e: empleado);
begin
	writeln('Informacion de empleado: ');
	write(e.nombre, ' - ', e.apellido, ' - ', e.numero, ' - ', e.edad, ' - ', e.dni);
	writeln;
	writeln;
end;

{-------------------BUSCAR NOMBRE O APELLIDO-----------------------}

procedure incisob1 (e: empleado; nombre: String; var ok: boolean);
begin
	if ((nombre = e.apellido)or(nombre = e.nombre)) then begin
		imprimir_registro(e);
		ok:= true;
	end;
end;

{--------------------BUSCAR NOMBRE DE EMPLEADO-----------------------}

procedure recorrido_incisob1 (var arc_logico: arc_empleado);
var
	e:empleado;
	nombre: string;
	ok: boolean;
begin
	ok:= false;
	reset(arc_logico);
	writeln('Ingrese nombre a buscar: ');
	readln(nombre);
	while (not eof(arc_logico)) do begin
		read(arc_logico,e);
		incisob1(e, nombre,ok);
	end;
	if (ok = false) then begin
		writeln('No se encontro la persona.');
		writeln;
	end;
	close(arc_logico);
end;

{------------------LISTAR EMPLEADOS EN PANTALLA---------------------}

procedure recorrido_incisob2 (var arc_logico: arc_empleado);
var
	e:empleado;
begin
	reset(arc_logico);
	while (not eof(arc_logico)) do begin
		read(arc_logico,e);
		imprimir_registro(e);
	end;
	close(arc_logico);
end;

{---------------LISTAR PERSONAS MAYORES DE 60 AÑOS------------------}

procedure recorrido_incisob3 (var arc_logico: arc_empleado);
var
	e:empleado;
begin
	reset(arc_logico);
	while (not eof(arc_logico)) do begin
		read(arc_logico,e);
		if (e.edad > 60) then 
			imprimir_registro(e);
	end;
	close(arc_logico);
end;

{-----------------PROGRAMA PRINCIPAL----------------------}

var
	arc_logico: arc_empleado;
	opcion: integer;
	arc_fisico: string;
begin
	writeln('-------------------------------------');
	writeln('Ingrese la opcion: ');
	writeln('1: Crear archivo');
	writeln('2: Buscar datos de empleado');
	writeln('3: Listar empleados');
	writeln('4: Listar empleados mayores a 60 años');
	writeln('5: Salir');
	writeln;
	readln(opcion);
	writeln('-------------------------------------');
	while (opcion <> 5) do begin
		case opcion of 
			1: crear_archivo(arc_logico, arc_fisico);
			2: recorrido_incisob1(arc_logico);
			3: recorrido_incisob2(arc_logico);
			4: recorrido_incisob3(arc_logico);
		end;
		writeln('-------------------------------------');
		writeln('Ingrese la opcion: ');
		writeln('1: Crear archivo');
		writeln('2: Buscar datos de empleado');
		writeln('3: Listar empleados');
		writeln('4: Listar empleados mayores a 60 años');
		writeln('5: Salir');
		writeln;
		readln(opcion);
		writeln('-------------------------------------');
	end;
end.
	
		
		
		
	
	

















		
