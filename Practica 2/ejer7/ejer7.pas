program ejer7;

const
	valorAlto = 9999;
	
type
	voto = record
		codProv: integer;
		codLoc: integer;
		mesa: integer;
		cant: integer;
	end;

	maestro = file of voto;
	
{----------------- LEER PRODUCTO MAESTRO ---------------}

procedure leer_votos(var v: voto);
begin
	write('Codigo de Provincia: '); readln(v.codProv);
	if (v.codProv <> -1) then begin
		write('Codigo de Localidad: '); readln(v.codLoc);
		write('Numero de mesa: '); readln(v.mesa);
		write('Cantidad de votos: '); readln(v.cant);
		writeln('-------------');
	end;
end;

{--------------------- CARGAR ARCHIVO MAESTRO ----------------------}
	
procedure cargar_maestro(var mae: maestro);
var
	v: voto;
begin
	rewrite(mae);
	leer_votos(v);
	while(v.codprov <> -1) do begin
		write(mae, v);
		leer_votos(v);
	end;
	close(mae);
	writeln('ARCHIVO MAESTRO CARGADO');
end;

{------------- MOSTRAR EN PANTALLA EL ARCHIVO MAESTRO -------------}

procedure imprimir_maestro(var mae: maestro);
var
	v: voto;
begin
	reset(mae);
	writeln('ARCHIVO MAESTRO');
	while(not eof(mae)) do begin
		read(mae, v);
		writeln();
		writeln('Codigo de provincia: ', v.codProv );
		writeln('Codigo de localidad: ', v.codLoc);
		writeln('Numero de mesa: ', v.mesa);
		writeln('Cantidad de votos: ', v.cant)
	end;
	close(mae);
end;

{--------------------- LEER ARCHIVO ----------------------}

procedure leer(var mae:maestro; var v:voto);
begin
	if(not eof(mae)) then begin
		read(mae, v);
    end
    else begin
      v.codProv:= valorAlto;
    end;
end;

{--------------------- LISTAR EN PANTALLA ---------------------}

procedure listar(var mae: maestro);
var
	v: voto;
	auxProv, totProv, auxLoc, totLoc: integer;
begin
	reset(mae);
	leer(mae, v);
	writeln();
	while(v.codProv <> valorAlto) do begin
		auxProv:= v.codProv;
		totProv:= 0;
		writeln('CODIGO DE PROVINCIA ', auxProv);
		while(v.codProv = auxProv) and (v.codProv <> valorAlto) do begin
			auxLoc:= v.codLoc;
			totLoc:= 0;
			writeln('Codigo de localidad	Total de votos ');
			while(v.codLoc = auxLoc) and (v.codProv = auxProv) and (v.codProv <> valorAlto) do begin
				totLoc:= totLoc + v.cant;
				totProv:= totProv + v.cant;
				leer(mae, v);
			end;
			writeln(auxLoc, '			', totLoc);
		end;
		writeln('TOTAL DE VOTOS PROVINCIA: ', totProv);
		writeln('----------------------------------');
	end;
	close(mae);
end;

{--------------------- PROGRAMA PRINCIPAL ----------------------}

var
	mae: maestro;
begin
	assign(mae, 'ejer7_arcMaestro');
	//cargar_maestro(mae);
	imprimir_maestro(mae);
	listar(mae);
end.
 
