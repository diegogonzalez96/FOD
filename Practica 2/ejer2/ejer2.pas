program ejer2;

const
	valorAlto = 999;

type
	alumno = record
		codigo: integer;
		apellido: String;
		nombre: String;
		cantSinFinal: integer;
		cantConFinal: integer;
	end;
	
	detalle_alum = record
		codigo: integer;
		materia: 0..1; {0: aprobo; 1:desaprobo}
	end;
	
	detalle = file of detalle_alum;
	arc_maestro = file of alumno;
	
{----------------CREO EL ARCHIVO MAESTRO-------------------}

procedure crear_archivo_maestro(var arc_m: arc_maestro);
var
	txt: Text;
	a: alumno;
begin
	assign(txt, 'alumnos.txt');
	reset(txt);
	rewrite(arc_m);
	while(not eof(txt)) do begin
		readln(txt, a.codigo, a.apellido);
		readln(txt, a.cantSinFinal, a.cantConFinal, a.nombre);
		write(arc_m, a);
	end;
	close(txt);
	close(arc_m);
	writeln('ARCHIVO MAESTRO CARGADO');
end;

{---------------CREO EL ARCHIVO DETALLE-----------------}

procedure crear_archivo_detalle(var arc_d: detalle);
var
	txt: text;
	ad: detalle_alum;
begin
	assign(txt, 'detalle.txt');
	reset(txt);
	rewrite(arc_d);
	while(not eof(txt)) do begin
		readln(txt, ad.codigo, ad.materia);
		write(arc_d, ad);
	end;
	close(txt);
	close(arc_d);
	writeln('ARCHIVO DETALLE CARGADO');
end;

{------------------- IMPRIMO ARCHIVO MAESTRO ---------------------}

procedure listar_maestro(var arc_m: arc_maestro);
var
	txt: text;
	a: alumno;
begin
	assign(txt, 'reporteAlumnos.txt');
	rewrite(txt);
	reset(arc_m);
	while (not eof(arc_m)) do begin
		read(arc_m, a);
		writeln(txt, a.codigo, a.apellido);
		writeln(txt, a.cantSinFinal, a.cantConFinal, a.nombre);
	end;
	close(arc_m);
	close(txt);
	writeln('ARCHIVO DE TEXTO "reporteAlumnos.txt" CARGADO.');
end;

{---------------- IMPRIMO ARCHIVO DETALLE ---------------------}

procedure listar_detalle(var arc_d: detalle);
var
	txt: text;
	ad: detalle_alum;
begin
	assign(txt, 'reporteDetalle.txt');
	rewrite(txt);
	reset(arc_d);
	while(not eof(arc_d)) do begin
		read(arc_d, ad);
		writeln(txt, ad.codigo, ad.materia);
	end;
	close(arc_d);
	close(txt);
	writeln('ARCHIVO DE TEXTO "reporteDetalle.txt" CARGADO.');
end;
	
{--------------- LEER ---------------------}

procedure leer (var arc_d: detalle; var ad: detalle_alum);
begin
	if (not eof(arc_d)) then
		read(arc_d, ad)
	else
		ad.codigo:= valorAlto;
end;

{------------ ACTUALIZO ARCHIVO MAESTRO INCISO I Y II ------------}

procedure actualizar_maestro(var arc_m: arc_maestro; var arc_d: detalle);
var
	a: alumno;
	ad: detalle_alum;
begin
	reset(arc_m);
	reset(arc_d);
	leer(arc_d, ad);
	while(ad.codigo <> valorAlto) do begin
		read(arc_m, a);
		while(a.codigo <> ad.codigo) do begin
			read(arc_m, a);
		end;
		while(a.codigo = ad.codigo) do begin
			if(ad.materia = 1) then
				a.cantSinFinal:= a.cantSinFinal+1
            else
                a.cantConFinal:= a.cantConFinal+1;
            leer(arc_d, ad);
		end;
        seek(arc_m, filePos(arc_m)-1);
        write(arc_m, a);
	end;
    close(arc_m);
    close(arc_d);
    writeln('ACHIVO MAESTRO ACTUALIZADO');
	writeln();
end;

{-------------- INCISO F --------------}

procedure alumnos_mas4(var arc_m: arc_maestro);
var
	txt: text;
	a: alumno;
begin
	assign(txt, 'incisoFejer2.txt');
	rewrite(txt);
	reset(arc_m);
	while(not eof(arc_m)) do begin
		read(arc_m, a);
		if ((a.cantSinFinal - a.cantConFinal) >= 4) then begin
			writeln(txt, a.codigo, a.apellido);
			writeln(txt, a.cantSinFinal, a.cantConFinal, a.nombre);
		end;
	end;
	close(txt);
	close(arc_m);
	writeln('ARCHIVO DE TEXTO DEL INCISO F CARGADO');
end;

{-------------- PROGRAMA PRINCIPAL --------------}

var
	arc_m: arc_maestro;
	arc_d: detalle;
begin
	assign(arc_m, 'ejer2_arcMaestro');
	assign(arc_d, 'ejer2_arcDetalle');
	crear_archivo_maestro(arc_m);
	crear_archivo_detalle(arc_d);
	listar_detalle(arc_d);
	actualizar_maestro(arc_m, arc_d);
	listar_maestro(arc_m);
	alumnos_mas4(arc_m);
end.
	


	
	
	
	
	
	
	
	
	
	
	
	
		
