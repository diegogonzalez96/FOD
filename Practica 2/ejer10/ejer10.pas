program ejer10;

const
	valorAlto = 9999;

type
	acceso = record
		anio: integer;
		mes: integer;
		dia: integer;
		id: integer;
		tiempo: integer;
	end;
	
	maestro = file of acceso;
	
{----------------- LEER MAESTRO ---------------}

procedure leer_acceso(var a: acceso);
begin
	write('Anio: '); readln(a.anio);
	if (a.anio <> -1) then begin
		write('Mes: '); readln(a.mes);
		write('Dia: '); readln(a.dia);
		write('ID de Usuario: '); readln(a.id);
		write('Tiempo de acceso: '); readln(a.tiempo);
		writeln('-------------');
	end;
end;

{--------------------- CARGAR ARCHIVO MAESTRO ----------------------}
	
procedure cargar_maestro(var mae: maestro);
var
	a: acceso;
begin
	rewrite(mae);
	leer_acceso(a);
	while(a.anio <> -1) do begin
		write(mae, a);
		leer_acceso(a);
	end;
	close(mae);
	writeln('ARCHIVO MAESTRO CARGADO');
end;

{------------- MOSTRAR EN PANTALLA EL ARCHIVO MAESTRO -------------}

procedure imprimir_maestro(var mae: maestro);
var
	a: acceso;
begin
	reset(mae);
	writeln('ARCHIVO MAESTRO');
	while(not eof(mae)) do begin
		read(mae, a);
		writeln();
		writeln('Anio: ', a.anio );
		writeln('Mes: ', a.mes);
		writeln('Dia: ', a.dia);
		writeln('ID de Usuario: ', a.id);
		writeln('Tiempo de acceso: ', a.tiempo);
	end;
	close(mae);
end;

{--------------------- LEER ARCHIVO ----------------------}

procedure leer(var mae: maestro; var a: acceso);
begin
	if(not eof(mae)) then begin
		read(mae, a);
    end
    else begin
      a.anio:= valorAlto;
    end;
end;

{--------------------- LISTAR EN PANTALLA ---------------------}

procedure listar(var mae: maestro);
var
	aux, a: acceso;
	totMes, totDia: integer;
begin
	reset(mae);
	leer(mae, a);
	write('Ingrese anio a buscar: '); readln(aux.anio);
	writeln();
	writeln('Anio:--- ', aux.anio);
	while(a.anio < aux.anio) do
		leer(mae, a);
	if (a.anio = aux.anio) then begin
		while(a.anio = aux.anio) do begin
			writeln('	Mes:--- ', a.mes);
			aux.mes:= a.mes;
			totMes:= 0;
			while(a.mes = aux.mes) and (a.anio = aux.anio) do begin
				writeln('		Dia:--- ', a.dia);
				aux.dia:= a.dia;
				totDia:= 0;
				while(a.dia = aux.dia) and (a.mes = aux.mes) and (a.anio = aux.anio) do begin
					aux.id:= a.id;
					aux.tiempo:= 0;
					while (a.id = aux.id) and (a.dia = aux.dia) and (a.mes = aux.mes) and (a.anio = aux.anio) do begin
						aux.tiempo:= aux.tiempo + a.tiempo;
						leer(mae, a);
					end;
					totDia:= totDia + aux.tiempo;
					writeln('			idUsuario: ', aux.Id, ', Tiempo total de acceso: ', aux.tiempo , ', en el dia ',aux.dia , ' del mes ',aux.mes);
				end;
				totMes:= totMes + totDia;
				writeln('		Tiempo total diario: ', totDia, ', dia ', aux.dia, ' mes ', aux.mes);
				writeln();
			end;
			writeln('	Tiempo total mensual: ', totMes, ' mes ', aux.mes);
			writeln();
		end;
	end;
	writeln('ANIO NO ENCONTRADO'); 
	close(mae);
end;

{--------------------- PROGRAMA PRINCIPAL ----------------------}

var
	mae: maestro;
begin
	assign(mae, 'ejer10_arcMaestro');
	//cargar_maestro(mae);
	imprimir_maestro(mae);
	listar(mae);
end.








