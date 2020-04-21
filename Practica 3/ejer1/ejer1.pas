program ejer1; {EJERCICIO 4 PRACTICA 1}
type
	empleado = record
		numero: integer;
		apellido: String;
		nombre: String;
		edad: integer;
		dni: integer;
	end;
	
	arc_empleado = file of empleado;
	
{--------------LEER REGISTRO EMPLEADO---------------------}	

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

{-----------------------CREAR ARCHIVO--------------------------------}

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

{-----------------AGREGAR EMPLEADOS----------------------}

procedure agregar_empleados (var arc_logico: arc_empleado);
var
	e:empleado;
begin
	reset(arc_logico);
	seek(arc_logico, filesize(arc_logico));
	leer_empleado(e);
	while (e.apellido <> ' ') do begin
		write(arc_logico, e);
		leer_empleado(e);
	end;
	close(arc_logico);
end;

{-----------------IMPRIMIR REGISTRO--------------------------}

procedure imprimir_registro (e: empleado);
begin
	writeln('Informacion de empleado: ');
	write(e.nombre, ' - ', e.apellido, ' - ', e.numero, ' - ', e.edad, ' - ', e.dni);
	writeln;
	writeln;
end;

{--------------EMPLEADOS CON NOMBRE Y APELLIDO ESPECIFICO------------}

procedure incisob1 (e: empleado; nombre: String; var ok: boolean);
begin
	if ((nombre = e.apellido)or(nombre = e.nombre)) then begin
		imprimir_registro(e);
		ok:= true;
	end;
end;

{---------------RECORRER Y LISTAR EMPLEADOS CON NOMBRE A BUSCAR-----------}

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

{----------LISTAR EMPLEADOS------------------}

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

{------------------EMPLEADOS MAYORES A 60 AÑOS--------------------}

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

{----------MODIFICAR EDAD DE UNO O MAS EMPLEADOS---------------}

procedure modificar_edad(var arc_logico: arc_empleado);
var
	auxNum, edadNue:integer;
	e: empleado;
	ok:boolean;
begin
	ok:= true;
	writeln('Ingrese numero de empleado a buscar: ');
	write('Numero: '); readln(auxNum);
	write('Ingrese la edad nueva: '); readln(edadNue);
	reset(arc_logico);
	while ((not eof(arc_logico)) and ok) do begin
		read(arc_logico, e);
		if (e.numero = auxNum) then begin
			e.edad := edadNue;
			seek(arc_logico, filepos(arc_logico)-1);
			write(arc_logico, e);
			ok:=false;
		end;
	end;
	close(arc_logico);
	writeln('-------------------------------------');
end;

{-----------------EXPORTAR ARCHIVO EMPLEADO A empleados.TXT---------------------}

procedure exportar_archivo(var arc_logico: arc_empleado);
var
	carga:Text;
	e:empleado;
begin
	assign (carga, 'empleados.txt');
	reset(arc_logico);
	rewrite(carga);
	while (not eof(arc_logico)) do begin
		read(arc_logico, e);
		with e do
			writeln(carga, 'Nombre: ', nombre, ' ', '  Apellido: ', apellido, ' ', '  Edad: ', edad, ' ', '  DNI: ',dni);
	end;
	close(arc_logico);
	close(carga);
	writeln('Terminada opcion 7.');
	writeln('-------------------');
end;

{-----------EXPORTAR ARCHIVO faltaDNI.txt--------------------}

procedure exportar_faltaDNI(var arc_logico: arc_empleado);
var
	carga:Text;
	e:empleado;
begin
	assign (carga, 'faltaDNI.txt');
	reset(arc_logico);
	rewrite(carga);
	while (not eof(arc_logico)) do begin
		read(arc_logico, e);
		if(e.dni = 0) then begin
			with e do
				writeln(carga, 'Nombre: ', nombre, ' ', '  Apellido: ', apellido, ' ', '  Edad: ', edad, ' ', '  DNI: ',dni);
		end;
	end;
	close(arc_logico);
	close(carga);
	writeln('Terminada opcion 8.');
	writeln('-------------------');
end;

{--------------PROGRAMA PRINCIPAL-----------------}

var
	arc_logico: arc_empleado;
	opcion: integer;
	arc_fisico: string;
begin
	writeln('-------------------------------------');
	writeln('Ingrese la opcion: ');
	writeln('1: Crear archivo');
	writeln('2: Agregar empleados');
	writeln('3: Buscar datos de empleado');
	writeln('4: Listar empleados');
	writeln('5: Listar empleados mayores a 60 años');
	writeln('6: Modificar edad');
	writeln('7: Exportar archivo');
	writeln('8: Exportar empleados sin DNI');
	writeln('9: Salir');
	writeln;
	readln(opcion);
	writeln('-------------------------------------');
	while (opcion <> 9) do begin
		case opcion of 
			1: crear_archivo(arc_logico, arc_fisico);
			2: agregar_empleados(arc_logico);
			3: recorrido_incisob1(arc_logico);
			4: recorrido_incisob2(arc_logico);
			5: recorrido_incisob3(arc_logico);
			6: modificar_edad(arc_logico);
			7: exportar_archivo(arc_logico);
			8: exportar_faltaDNI(arc_logico);
		end;
		writeln('-------------------------------------');
		writeln('Ingrese la opcion: ');
		writeln('1: Crear archivo');
		writeln('2: Agregar empleados');
		writeln('3: Buscar datos de empleado');
		writeln('4: Listar empleados');
		writeln('5: Listar empleados mayores a 60 años');
		writeln('6: Modificar edad');
		writeln('7: Exportar archivo');
		writeln('8: Exportar empleados sin DNI');
		writeln('9: Salir');
		writeln;
		readln(opcion);
		writeln('-------------------------------------');
	end;
end.
