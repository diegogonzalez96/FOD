program ejer4;

const
	valorAlto = 9999;
	dimF = 5;

type
	reg_detalle = record
		cod_usuario: integer;
		fecha: longint;
		tiempo_sesion: integer;
	end;
	
	reg_maestro = record
		cod_usuario: integer;
		fecha: longint;
		tiempo_total: integer;
	end;
	
	arc_maestro = file of reg_maestro;
	arc_detalle = file of reg_detalle;
	
	vec_detalle = array [1..dimF] of arc_detalle;
	vec_registro = array [1..dimF] of reg_detalle;

{----------------------- LEER ARCHIVO DETALLE -----------------------}
	
procedure leer_detalle(var d: reg_detalle);
begin
	write('Codigo de usuario: '); readln(d.cod_usuario);
	if (d.cod_usuario <> -1) then begin
		write('Fecha: '); readln(d.fecha);
		write('Tiempo de sesion: '); readln(d.tiempo_sesion);
	end;
end;

{-------------- CARGAR ARCHIVOS DETALLE DE LAS 5 MAQUINAS ---------}

procedure cargar_archivo_detalle(var vec_d: vec_detalle);
var
	i: integer; 
	regD: reg_detalle;
begin
	for i:= 1 to dimF do begin
		rewrite(vec_d[i]);
		writeln('MAQUINA ', i);
		writeln();
		leer_detalle(regD);
		while(regD.cod_usuario <> -1) do begin
			write(vec_d[i], regD);
			leer_detalle(regD);
		end;
		close(vec_d[i]);
		writeln('MAQUINA ', i, ' CARGADA');
	end; 
	writeln();
	writeln('ARCHIVO DETALLE CARGADO');
end;

{---------MOSTRAR EN PANTALLA EL ARCHIVO DETALLE----------}

procedure imprimir_arc_detalle(var vec_d: vec_detalle);
var
	regD: reg_detalle;
	i: integer;
begin
	writeln();
	writeln('ARCHIVO DETALLE');
	for i:= 1 to dimF do begin
		reset(vec_d[i]);
		writeln();
		writeln('MAQUINA ', i);
		while(not eof(vec_d[i])) do begin
			read(vec_d[i], regD);
			writeln();
			write('Codigo de usuario: ', regD.cod_usuario);
			write(' - Fecha: ', regD.fecha);
			writeln(' - Tiempo de sesion: ', regD.tiempo_sesion);
		end;
		close(vec_d[i]);
	end;
end;

{--------------- LEO EL REGISTRO SI NO LLEGO A SU FINAL -----------}

procedure leer (var arc_d: arc_detalle; var rd: reg_detalle);
begin
	if (not eof(arc_d)) then begin
		read(arc_d, rd);
	end
	else
		rd.cod_usuario:= valorAlto;
end;

{---------------------- PROCESO MINIMO -----------------------}

procedure minimo (var vec_d:vec_detalle; var vec_r:vec_registro; var regMin:reg_detalle);
var
   i, posMin, min: integer;
   fechaMin:longint;
   reg: reg_detalle;
begin
    regMin.cod_usuario:= valorAlto;
    min:= 9999;
    fechaMin:= 99999999;
    for i:= 1 to dimF do begin
        if (vec_r[i].cod_usuario < min) then begin
            min:= vec_r[i].cod_usuario;
            regMin:= vec_r[i];
            fechaMin:= vec_r[i].fecha;
            posMin:= i;
        end
        else
            if ((vec_r[i].cod_usuario = min) and (vec_r[i].fecha < fechaMin)) then begin
                fechaMin:= vec_r[i].fecha;
                regMin:= vec_r[i];
                posMin:= i;
            end;
    end;
    if (regMin.cod_usuario <> valorAlto) then begin
        leer(vec_d[posMin], reg);
        vec_r[posMin]:= reg;
        write(posMin, ' ');
    end;
end;

{------------------------- CREAR MAESTRO -----------------------}

procedure crear_maestro(var arc_m: arc_maestro; var vec_d: vec_detalle);
var
	vec_r: vec_registro;
	regMae: reg_maestro;
	regMin: reg_detalle;
	i: integer;
begin
	for i:= 1 to dimF do begin;
		reset(vec_d[i]);
		leer(vec_d[i], vec_r[i]);
	end;
	rewrite(arc_m);
	minimo(vec_d, vec_r, regMin);
	while (regMin.cod_usuario <> valorAlto) do begin
		regMae.cod_usuario:= regMin.cod_usuario;
		regMae.fecha:= regMin.fecha;
		regMae.tiempo_total:= 0;
		while((regMae.cod_usuario = regMin.cod_usuario) and (regMae.fecha = regMin.fecha)) do begin
			regMae.tiempo_total:= regMae.tiempo_total + regMin.tiempo_sesion;
			minimo(vec_d, vec_r, regMin);
		end;
		write(arc_m, regMae);
	end;
	for i:= 1 to dimF do
		close(vec_d[i]);
	writeln('ARCHIVO MAESTRO CARGADO');
	writeln();
end;

{-------------MOSTRAR EN PANTALLA EL ARCHIVO MAESTRO-----------------}

procedure imprimir_maestro(var arc_m: arc_maestro);
var
	rm: reg_maestro;
begin
	reset(arc_m);
	writeln('ARCHIVO MAESTRO');
	while(not eof(arc_m)) do begin
		read(arc_m, rm);
		writeln();
		write('Codigo de usuario: ', rm.cod_usuario);
		write(' - Fecha: ', rm.fecha);
		write(' - Tiempo total de sesiones: ', rm.tiempo_total);
	end;
	close(arc_m);
end;



{---------------------- PROGRAMA PRINCIPAL ----------------------}

var
	arc_m: arc_maestro;
	vec_d: vec_detalle;
	i: integer;
	j: string;
begin
	for i:= 1 to dimF do begin
		str(i, j);
		assign(vec_d[i], 'detalle_maquina ' + j);
	end;
	//writeln('CARGAR ARCHIVOS DETALLES');
	//cargar_archivo_detalle(vec_d);
	imprimir_arc_detalle(vec_d);
	assign(arc_m, 'ejer4_arcMaestro');
	crear_maestro(arc_m, vec_d);
	imprimir_maestro(arc_m);
end.


