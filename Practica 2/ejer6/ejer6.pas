program ejer6;

const
	valorAlto = 9999;
	
type
	infoCliente = record
		codigo: integer;
		nombre: string;
		apellido: string;
	end;
	
	infoFecha = record
		dia: integer;
		mes: integer;
		anio: integer;
	end;
	
	venta = record
		cliente: infoCliente;
		fecha: infoFecha;
		monto: integer;
	end;
	
	maestro = file of venta;
	
{----------------- LEER MAESTRO ---------------}

procedure leer_venta(var v: venta);
begin
	write('Codigo: '); readln(v.cliente.codigo);
	if (v.cliente.codigo <> -1) then begin
		write('Nombre: '); readln(v.cliente.nombre);
		write('Apellido: '); readln(v.cliente.apellido);
		write('Dia: '); readln(v.fecha.dia);
		write('Mes: '); readln(v.fecha.mes);
		write('Anio: '); readln(v.fecha.anio);
		write('Monto: '); readln(v.monto);
		writeln('-------------');
	end;
end;

{--------------------- CARGAR ARCHIVO MAESTRO ----------------------}
	
procedure cargar_maestro(var mae: maestro);
var
	v: venta;
begin
	rewrite(mae);
	leer_venta(v);
	while(v.cliente.codigo <> -1) do begin
		write(mae, v);
		leer_venta(v);
	end;
	close(mae);
	writeln('ARCHIVO MAESTRO CARGADO');
end;

{------------- MOSTRAR EN PANTALLA EL ARCHIVO MAESTRO -------------}

procedure imprimir_maestro(var mae: maestro);
var
	v: venta;
begin
	reset(mae);
	writeln('ARCHIVO MAESTRO');
	while(not eof(mae)) do begin
		read(mae, v);
		writeln();
		writeln('Codigo: ', v.cliente.codigo );
		writeln('Nombre: ', v.cliente.nombre);
		writeln('Apellido: ', v.cliente.apellido);
		writeln('Dia: ', v.fecha.dia);
		writeln('Mes: ', v.fecha.mes);
		writeln('Anio: ', v.fecha.anio);
		writeln('Monto: ', v.monto);
		writeln('-------------------------');
	end;
	close(mae);
end;

{--------------------- LEER ARCHIVO ----------------------}

procedure leer(var mae:maestro; var v:venta);
begin
	if(not eof(mae)) then begin
		read(mae, v);
    end
    else begin
      v.cliente.codigo:= valorAlto;
    end;
end;

{-------------------------- RECORRER -----------------------------}

procedure recorrer (var mae: maestro);
var
	v: venta;
	totAnual, totMensual, total, auxCod, auxAnio, auxMes: integer;
begin
	reset(mae);
	total:= 0;
	leer(mae, v);
	while(v.cliente.codigo <> valorAlto) do begin
		auxCod:= v.cliente.codigo;
		writeln('CLIENTE: ');
		writeln('Codigo: ', v.cliente.codigo, ' Nombre: ', v.cliente.nombre, ' Apellido: ', v.cliente.apellido);
		while(v.cliente.codigo = auxCod) and (v.cliente.codigo <> valorAlto) do begin
			auxAnio:= v.fecha.anio;
			totAnual:= 0;
			while(v.fecha.anio = auxAnio) and (v.cliente.codigo = auxCod) and (v.cliente.codigo <> valorAlto) do begin
				auxMes:= v.fecha.mes;
				totMensual:= 0;
				while (v.fecha.mes = auxMes) and (v.fecha.anio = auxAnio) and (v.cliente.codigo = auxCod) and (v.cliente.codigo <> valorAlto) do begin
					totMensual:= totMensual + v.monto;
					total:= total + v.monto;
					leer(mae, v);
				end;
				writeln('Monto mensual, mes ', auxMes, ' es: ', totMensual);
				totAnual:= totAnual + totMensual;
			end;
			writeln('Monto anual, anio ', auxAnio, ' es: ', totAnual);
		end;
		total:= total + totAnual;
		writeln('----------------------------------');
	end;
	writeln('Monto total vendido por la empresa: ', total);
	close(mae);
end;

{--------------------- PROGRAMA PRINCIPAL ----------------------}

var
	mae: maestro;
begin
	assign(mae, 'ejer6_arcMaestro');
	//cargar_maestro(mae);
	imprimir_maestro(mae);
	recorrer(mae);
end.
	
		

