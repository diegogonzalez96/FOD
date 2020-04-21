program ejer11;

const
	valorAlto = 9999;
	dimF = 3;
	
type
	regMae = record
		nroUsuario: integer;
		nomUsuario: string;
		nombre: string;
		apellido: string;
		cantMail: integer;
	end;
	
	regDet = record
		nroUsuario: integer;
		destino: string;
		mensaje: string;
	end;
	
	maestro = file of regMae;
	detalle = file of regDet;
	
	vec_detalle = array [1..dimF] of detalle;
	vec_registro = array [1..dimF] of regDet;
	
{----------------- LEER MAESTRO ---------------}

procedure leer_maestro(var m: regMae);
begin
	write('Numero de usuario: '); readln(m.nroUsuario);
	if (m.nroUsuario <> -1) then begin
		write('Nombre de usuario: '); readln(m.nomUsuario);
		write('Nombre: '); readln(m.nombre);
		write('Apellido: '); readln(m.apellido);
		write('Cantidad de Mail: '); readln(m.cantMail);
		writeln('-------------');
	end;
end;

{----------------- LEER DETALLE ---------------}

procedure leer_detalle(var d: regDet);
begin
	write('Numero de usuario: '); readln(d.nroUsuario);
	if (d.nroUsuario <> -1) then begin
		write('Destino: '); readln(d.destino);
		write('Cuerpo de mensaje: '); readln(d.mensaje);
	end;
end;

{--------------------- CARGAR ARCHIVO MAESTRO ----------------------}
	
procedure cargar_maestro(var mae: maestro);
var
	m: regMae;
begin
	rewrite(mae);
	leer_maestro(m);
	while(m.nroUsuario <> -1) do begin
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
	dd: regDet;
begin
	writeln('CARGAR DETALLES');
	for i:= 1 to dimF do begin
		rewrite(vec_d[i]);
		writeln();
		leer_detalle(dd);
		while(dd.nroUsuario <> -1) do begin
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
	m: regMae;
begin
	reset(mae);
	writeln('ARCHIVO MAESTRO');
	while(not eof(mae)) do begin
		read(mae, m);
		writeln();
		writeln('Numero de usuario: ', m.nroUsuario );
		writeln('Nombre de usuario: ', m.nomUsuario);
		writeln('Nombre: ', m.nombre);
		writeln('Apellido: ', m.apellido);
		writeln('Cantidad de mail: ', m.cantMail);
		writeln('-------------------------');
	end;
	close(mae);
end;

{---------MOSTRAR EN PANTALLA EL ARCHIVO DETALLE----------}

procedure imprimir_detalle(var vec_d: vec_detalle);
var
	dd: regDet;
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
			writeln('Numero de usuario: ', dd.nroUsuario);
			writeln('Destino: ', dd.destino);
			writeln('Cuerpo de mensaje: ', dd.mensaje);
			writeln('-------------------------');
		end;
		close(vec_d[i]);
	end;
end;

{--------------- LEO EL REGISTRO SI NO LLEGO A SU FINAL -----------}

procedure leer (var det: detalle; var dd: regDet);
begin
	if (not eof(det)) then begin
		read(det, dd);
	end
	else
		dd.nroUsuario:= valorAlto;
end;

{----------------- MINIMO --------------}

procedure minimo (var vec_d:vec_detalle; var vec_r:vec_registro; var reg_min:regDet);
var
   reg: regDet;  
   i, posMin, aux: integer;
begin
     reg_min.nroUsuario:= valorAlto;
     aux:= 9999;
     for i:= 1 to dimF do begin
         if (vec_r[i].nroUsuario < aux) then begin
            aux:= vec_r[i].nroUsuario;
            reg_min:= vec_r[i];
            posMin:= i;
         end;
     end;
     if (reg_min.nroUsuario <> valorAlto) then begin 
        leer(vec_d[posMin], reg);
        vec_r[posMin]:= reg;
     end;
end;

{--------------- ACTUALIZAR MAESTRO -------------}

procedure actualizar_maestro(var mae: maestro; var vec_d: vec_detalle);
var
	vec_r: vec_registro;
	datoMae: regMae;
	reg_min: regDet;
	i, auxMail: integer;
begin
	for i:= 1 to dimF do begin
		reset(vec_d[i]);
		leer(vec_d[i], vec_r[i]); // PONGO EN EL VECTOR REGISTRO EL PRIMER ELEMENTO DE CADA DETALLE
	end;
	reset(mae);
	minimo(vec_d, vec_r, reg_min); //SACO EL MINIMO ENTRE LOS ELEMENTOS DEL VECTOR REGISTRO
	while(reg_min.nroUsuario <> valorAlto) do begin
		read(mae, datoMae);
		auxMail:= 0;
		if (datoMae.nroUsuario = reg_min.nroUsuario) then begin 
			while(datoMae.nroUsuario = reg_min.nroUsuario) do begin
				auxMail:= auxMail + 1;
				minimo(vec_d, vec_r, reg_min);
			end;
			seek(mae,(filePos(mae)-1));
			datoMae.cantMail:= datoMae.cantMail + auxMail;
			write(mae, datoMae);
		end;
		writeln('Numero de Usuario: ', datoMae.nroUsuario, ' Cantidad de mensajes enviados: ', datoMae.cantMail);
		writeln();
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
	assign(mae, 'ejer11_arcMaestro');
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
	
		
