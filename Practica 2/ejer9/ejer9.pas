program ejer9;

const
	valorAlto = 'ZZZZ';
	dimF = 2;
	
type
	datoMaestro = record
		nomProv: string;
		cantAlf: integer;
		totalEnc: integer;
	end;
	
	datoDetalle = record
		nomProv: string;
		codigo: integer;
		cantAlf: integer;
		cantEnc: integer;
	end;
	
	maestro = file of datoMaestro;
	detalle = file of datoDetalle;
	
	vec_detalle = array [1..dimF] of detalle;
	vec_registro = array [1..dimF] of datoDetalle;
	
{----------------- LEER DATOS MAESTRO ---------------}

procedure leer_datoMaestro(var dm: datoMaestro);
begin
	write('Nombre de provincia: '); readln(dm.nomProv);
	if (dm.nomProv <> 'zzz') then begin
		write('Cantidad de alfabetizados: '); readln(dm.cantAlf);
		write('Total de encuestados: '); readln(dm.totalEnc);
		writeln('-------------');
	end;
end;

{------------------ LEER DATOS DETALLE --------------}

procedure leer_detalle(var dd: datoDetalle);
begin
	write('Nombre de provincia: '); readln(dd.nomProv);
	if (dd.nomProv <> 'zzz') then begin
		write('Codigo de localidad: '); readln(dd.codigo);
		write('Cantidad de alfabetizados: '); readln(dd.cantAlf);
		write('Cantidad de encuestados: '); readln(dd.cantEnc);
		writeln('-------------');
	end;
end;

{-------------- CARGAR ARCHIVOS DETALLES ---------}

procedure cargar_detalle(var vec_d: vec_detalle);
var
	i: integer; 
	dd: datoDetalle;
begin
	writeln('CARGAR DETALLES');
	for i:= 1 to dimF do begin
		rewrite(vec_d[i]);
		writeln();
		leer_detalle(dd);
		while(dd.nomProv <> 'zzz') do begin
			write(vec_d[i], dd);
			leer_detalle(dd);
		end;
		writeln('DETALLE ', i, 'CARGADO');
	end; 
	writeln();
	writeln('ARCHIVO DETALLE CARGADO');
end;

{--------------------- CARGAR ARCHIVO MAESTRO ----------------------}
	
procedure cargar_maestro(var mae: maestro);
var
	dm: datoMaestro;
begin
	rewrite(mae);
	leer_datoMaestro(dm);
	while(dm.nomProv <> 'zzz') do begin
		write(mae, dm);
		leer_datoMaestro(dm);
	end;
	close(mae);
	writeln('ARCHIVO MAESTRO CARGADO');
end;

{-------------MOSTRAR EN PANTALLA EL ARCHIVO MAESTRO-----------------}

procedure imprimir_maestro(var mae: maestro);
var
	dm: datoMaestro;
begin
	reset(mae);
	writeln('ARCHIVO MAESTRO');
	while(not eof(mae)) do begin
		read(mae, dm);
		writeln();
		writeln('Nombre de provincia: ', dm.nomProv );
		writeln('Cantidad de alfabetizados: ', dm.cantAlf);
		writeln('Total de encuestados: ', dm.totalEnc);
		writeln('-------------------------');
	end;
	close(mae);
end;

{---------MOSTRAR EN PANTALLA EL ARCHIVO DETALLE----------}

procedure imprimir_detalle(var vec_d: vec_detalle);
var
	dd: datoDetalle;
	i: integer;
begin
	writeln();
	writeln('ARCHIVO DETALLE');
	for i:= 1 to dimF do begin
		reset(vec_d[i]);
		writeln('DETALLE ', i);
		while(not eof(vec_d[i])) do begin
			read(vec_d[i], dd);
			writeln();
			writeln('Nombre de provincia: ', dd.nomProv);
			writeln('Codigo de localidad: ', dd.codigo);
			writeln('Cantidad de alfabetizado: ', dd.cantAlf);
			writeln('Cantidad de encuestados: ', dd.cantEnc);
			writeln('-------------------------');
		end;
		close(vec_d[i]);
	end;
end;

{--------------- LEO EL REGISTRO SI NO LLEGO A SU FINAL -----------}

procedure leer (var det: detalle; var dd: datoDetalle);
begin
	if (not eof(det)) then begin
		read(det, dd);
	end
	else
		dd.nomProv:= valorAlto;
end;

{----------------- MINIMO --------------}

procedure minimo (var vec_d:vec_detalle; var vec_r:vec_registro; var reg_min:datoDetalle);
var
   reg: datoDetalle;  
   i, posMin: integer;
   aux: string;
begin
     reg_min.nomProv:= valorAlto;
     aux:= 'zzzz';
     for i:= 1 to dimF do begin
         if (vec_r[i].nomProv < aux) then begin
            aux:= vec_r[i].nomProv;
            reg_min:= vec_r[i];
            posMin:= i;
         end;
     end;
     if (reg_min.nomProv <> valorAlto) then begin 
        leer(vec_d[posMin], reg);
        vec_r[posMin]:= reg;
     end;
end;

{--------------- ACTUALIZAR MAESTRO -------------}

procedure actualizar_maestro(var mae: maestro; var vec_d: vec_detalle);
var
	vec_r: vec_registro;
	datoMae: datoMaestro;
	reg_min: datoDetalle;
	i, auxAlf, auxEnc: integer;
begin
	for i:= 1 to dimF do begin
		reset(vec_d[i]);
		leer(vec_d[i], vec_r[i]); // PONGO EN EL VECTOR REGISTRO EL PRIMER ELEMENTO DE CADA DETALLE
	end;
	reset(mae);
	minimo(vec_d, vec_r, reg_min); //SACO EL MINIMO ENTRE LOS ELEMENTOS DEL VECTOR REGISTRO
	while(reg_min.nomProv <> valorAlto) do begin
		read(mae, datoMae);
		auxAlf:= 0;
		auxEnc:= 0;
		while(datoMae.nomProv <> reg_min.nomProv) do 
			read(mae, datoMae);
		while(datoMae.nomProv = reg_min.nomProv) do begin
			auxAlf:= auxAlf + reg_min.cantAlf;
			auxEnc:= auxEnc + reg_min.cantEnc;
			minimo(vec_d, vec_r, reg_min);
		end;
		seek(mae,(filePos(mae)-1));
		datoMae.cantAlf:= datoMae.cantAlf + auxAlf;
		datoMae.totalEnc:= datoMae.totalEnc + auxEnc;
		write(mae, datoMae);
	end;
	close(mae);
end;

{--------------------- PROGRAMA PRINCIPAL ----------------------}

var
	mae: maestro;
	vec_d: vec_detalle;
	i: integer;
	j: string;
begin
	assign(mae, 'ejer9_arcMaestro');
	//cargar_maestro(mae);
	imprimir_maestro(mae);
	for i:= 1 to dimF do begin
		str(i, j);
		assign(vec_d[i], 'detalle' + j);
	end;
	//cargar_detalle(vec_d);
	imprimir_detalle(vec_d);
	actualizar_maestro(mae, vec_d);
	imprimir_maestro(mae);
end.











