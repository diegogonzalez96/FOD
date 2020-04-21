program ejer8;

const
	valorAlto = 9999;
	dimF = 15;
	
type
	empleado = record
		departamento: integer;
		division: integer;
		numero: integer;
		categoria: integer;
		horas: integer;
	end;
	
	maestro = file of empleado;
	
	vector = array[1..dimF] of real;
	
{----------------- LEER PRODUCTO MAESTRO ---------------}

procedure leer_empleado(var e: empleado);
begin
	write('Departamento: '); readln(e.departamento);
	if (e.departamento <> -1) then begin
		write('Division: '); readln(e.division);
		write('Numero de empleado: '); readln(e.numero);
		write('Categoria: '); readln(e.categoria);
		write('Cantidad de horas extras: '); readln(e.horas);
		writeln('-------------');
	end;
end;

{--------------------- CARGAR ARCHIVO MAESTRO ----------------------}
	
procedure cargar_maestro(var mae: maestro);
var
	e: empleado;
begin
	rewrite(mae);
	leer_empleado(e);
	while(e.departamento <> -1) do begin
		write(mae, e);
		leer_empleado(e);
	end;
	close(mae);
	writeln('ARCHIVO MAESTRO CARGADO');
end;

{------------- MOSTRAR EN PANTALLA EL ARCHIVO MAESTRO -------------}

procedure imprimir_maestro(var mae: maestro);
var
	e: empleado;
begin
	reset(mae);
	writeln('ARCHIVO MAESTRO');
	while(not eof(mae)) do begin
		read(mae, e);
		writeln();
		writeln('Departamento: ', e.departamento);
		writeln('Division: ', e.division);
		writeln('Numero de empleado: ', e.numero);
		writeln('Categoria: ', e.categoria);
		writeln('Cantidad de horas extras: ', e.horas);
		writeln('-------------');
	end;
	close(mae);
end;

{-------------------- CARGAR VECTOR DE CATEGORIAS -------------------}

procedure cargar_vector(var texto:text; var v: vector);
var
	cat: integer;
	monto: real;
begin
	reset(texto);
	while(not eof(texto)) do begin
		readln(texto, cat, monto);
		v[cat]:= monto;
	end;
	close(texto);
end;

{------------------ IMPRIMIR VECTOR DE CATEGORIAS ------------------}

procedure imprimir_vector(v: vector);
var
	i:integer;
begin
	writeln('VECTOR DE CATEGORIAS');
	for i:= 1 to dimF do
		writeln('Categoria ', i, ' - Monto: ', v[i]:2:2);
end;

{--------------------- LEER ARCHIVO ----------------------}

procedure leer(var mae:maestro; var e:empleado);
begin
	if(not eof(mae)) then begin
		read(mae, e);
    end
    else begin
      e.departamento:= valorAlto;
    end;
end;

{--------------------- LISTAR EN PANTALLA ---------------------}

procedure listar(var mae: maestro; v:vector);
var
	e: empleado;
	auxDep, auxDiv, auxEmp, horas, horDiv, horDep: integer;
	cobro, totDiv, totDep: real;
begin
	reset(mae);
	leer(mae, e);
	writeln();
	while(e.departamento <> valorAlto) do begin
		auxDep:= e.departamento;
		horDep:= 0;
		totDep:= 0;
		writeln('DEPARTAMENTO: ', auxDep);
		while(e.departamento = auxDep) and (e.departamento <> valorAlto) do begin
			auxDiv:= e.division;
			horDiv:= 0;
			totDiv:= 0;
			writeln('DIVISION:  ', e.division);
			while(e.division = auxDiv) and (e.departamento = auxDep) and (e.departamento <> valorAlto) do begin
				auxEmp:= e.numero;
				horas:= 0;
				writeln('NUMERO DE EMPLEADO  TOTAL DE HS  IMPORTE A COBRAR');
				while (e.numero = auxEmp) and (e.division = auxDiv) and (e.departamento = auxDep) and (e.departamento <> valorAlto) do begin
					horas:= horas + e.horas;
					leer(mae, e);
				end;
				cobro:= v[e.categoria] * horas;
				horDiv:= horDiv + horas;
				totDiv:= totDiv + cobro;
				writeln(' ', auxEmp, '			', horas, '		', cobro:2:2);
			end;
			horDep:= horDep + horDiv;
			totDep:= totDep + totDiv;
			writeln('TOTAL DE HORAS POR DIVISION: ', horDiv);
			writeln('MONTO TOTAL POR DIVISION: ', totDiv:2:2);
			writeln();
		end;
		writeln('TOTAL HORAS DEPARTAMENTO: ', horDep);
		writeln('MONTO TOTAL DEPARTAMENTO: ', totDep:2:2);
		writeln();
	end;
	close(mae);
end;

{--------------------- PROGRAMA PRINCIPAL ----------------------}

var
	mae: maestro;
	texto: text;
	v: vector;
begin
	assign(mae, 'ejer8_arcMaestro');
	assign(texto, 'categorias.txt');
	cargar_vector(texto, v);
	imprimir_vector(v);
	writeln();
	//cargar_maestro(mae);
	imprimir_maestro(mae);
	listar(mae, v);
end.
