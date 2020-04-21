program ejer12;

const
	valorAlto = 'ZZZZ';
	dimF = 2;
	
type
	vueloMae = record
		destino: string;
		fecha: string;
		hora: string;
		asientosDisp: integer;
	end;
	
	vueloDet = record
		destino: string;
		fecha: string;
		hora: string;
		asientosComp: integer;
	end;
	
	maestro = file of vueloMae;
	detalle = file of vueloDet;
	
	vec_detalle = array [1..dimF] of detalle;
	vec_registro = array [1..dimF] of vueloDet;
	
{----------------- LEER MAESTRO ---------------}

procedure leer_maestro(var m: vueloMae);
begin
	write('Destino de vuelo: '); readln(m.destino);
	if (m.destino <> 'zzz') then begin
		write('Fecha: '); readln(m.fecha);
		write('Hora: '); readln(m.hora);
		write('Asientos disponibles: '); readln(m.asientosDisp);
		writeln('-------------');
	end;
end;

{----------------- LEER DETALLE ---------------}

procedure leer_detalle(var d: vueloDet);
begin
	write('Destino de vuelo: '); readln(d.destino);
	if (d.destino <> 'zzz') then begin
		write('Fecha: '); readln(d.fecha);
		write('Hora: '); readln(d.hora);
		write('Asiento comprados: '); readln(d.asientosComp);
		writeln('-------------');
	end;
end;

{--------------------- CARGAR ARCHIVO MAESTRO ----------------------}
	
procedure cargar_maestro(var mae: maestro);
var
	m: vueloMae;
begin
	rewrite(mae);
	leer_maestro(m);
	while(m.destino <> 'zzz') do begin
		write(mae, m);
		leer_maestro(m);
	end;
	close(mae);
	writeln('ARCHIVO MAESTRO CARGADO');
end;
{-------------- CARGAR ARCHIVOS DETALLES ---------}

procedure cargar_detalle(var vec_d: vec_detalle);
var
	i: integer; 
	dd: vueloDet;
begin
	writeln('CARGAR DETALLES');
	for i:= 1 to dimF do begin
		rewrite(vec_d[i]);
		writeln();
		leer_detalle(dd);
		while(dd.destino <> 'zzz') do begin
			write(vec_d[i], dd);
			leer_detalle(dd);
		end;
		writeln('DETALLE ', i, 'CARGADO');
	end; 
	writeln();
	writeln('ARCHIVO DETALLE CARGADO');
end;

{------------- MOSTRAR EN PANTALLA EL ARCHIVO MAESTRO -------------}

procedure imprimir_maestro(var mae: maestro);
var
	m: vueloMae;
begin
	reset(mae);
	writeln('ARCHIVO MAESTRO');
	while(not eof(mae)) do begin
		read(mae, m);
		writeln();
		writeln('Destino: ', m.destino );
		writeln('Fecha: ', m.fecha);
		writeln('Hora: ', m.hora);
		writeln('Asientos Disponibles: ', m.asientosDisp);
		writeln('-------------------------');
	end;
	close(mae);
end;

{---------MOSTRAR EN PANTALLA EL ARCHIVO DETALLE----------}

procedure imprimir_detalle(var vec_d: vec_detalle);
var
	dd: vueloDet;
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
			writeln('Destino: ', dd.destino);
			writeln('Fecha: ', dd.fecha);
			writeln('Hora: ', dd.hora);
			writeln('Asientos comprados: ', dd.asientosComp);
			writeln('-------------------------');
		end;
		close(vec_d[i]);
	end;
end;

{--------------- LEO EL REGISTRO SI NO LLEGO A SU FINAL -----------}

procedure leer (var det: detalle; var dd: vueloDet);
begin
	if (not eof(det)) then begin
		read(det, dd);
	end
	else
		dd.destino:= valorAlto;
end;

{----------------- MINIMO --------------}

procedure minimo (var vec_d:vec_detalle; var vec_r:vec_registro; var reg_min:vueloDet);
var
   reg: vueloDet;  
   i, posMin: integer;
   aux: string;
begin
     reg_min.destino:= valorAlto;
     aux:= 'ZZZZ';
     for i:= 1 to dimF do begin
         if (vec_r[i].destino < aux) then begin
            aux:= vec_r[i].destino;
            reg_min:= vec_r[i];
            posMin:= i;
         end;
     end;
     if (reg_min.destino <> valorAlto) then begin 
        leer(vec_d[posMin], reg);
        vec_r[posMin]:= reg;
     end;
end;

{--------------- ACTUALIZAR MAESTRO -------------}

procedure actualizar_maestro(var mae: maestro; var vec_d: vec_detalle);
var
	vec_r: vec_registro;
	datoMae: vueloMae;
	reg_min: vueloDet;
	i, cantComp, auxAsi: integer;
begin
	for i:= 1 to dimF do begin
		reset(vec_d[i]);
		leer(vec_d[i], vec_r[i]); // PONGO EN EL VECTOR REGISTRO EL PRIMER ELEMENTO DE CADA DETALLE
	end;
	reset(mae);
	write('VUELOS CON ASIENTOS MENORES A: '); readln(auxAsi);
	writeln();
	minimo(vec_d, vec_r, reg_min); //SACO EL MINIMO ENTRE LOS ELEMENTOS DEL VECTOR REGISTRO
	while(reg_min.destino <> valorAlto) do begin
		read(mae, datoMae);
		cantComp:= 0;
		while(datoMae.destino <> reg_min.destino) do 
			read(mae, datoMae);
		while (datoMae.destino = reg_min.destino) and (datoMae.hora = reg_min.hora) and (datoMae.fecha = reg_min.fecha)do begin
			cantComp:= cantComp + reg_min.asientosComp;
			if ((datoMae.asientosDisp - cantComp) < auxAsi) then begin
				writeln('Destino: ', datoMae.destino);
				writeln('Fecha: ', datoMae.fecha, ' Hora: ', datoMae.hora);
				writeln();
			end;
			minimo(vec_d, vec_r, reg_min);
		end;
		seek(mae,(filePos(mae)-1));
		datoMae.asientosDisp:= datoMae.asientosDisp - cantComp;
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
	assign(mae, 'ejer12_arcMaestro');
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







