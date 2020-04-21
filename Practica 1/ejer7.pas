program ejer7;

type
	novela = record
		codigo: integer;
		nombre: string;
		genero: string;
		precio: real;
	end;
	
	arc_novelas = file of novela;
	
procedure leer_novela(var n:novela);
begin
	writeln('INGRESE DATOS DE NOVELA');
	writeln('Ingrese codigo: '); readln(n.codigo);
	if(n.codigo <> -1) then begin
		write('Ingrese nombre: '); readln(n.nombre);
		write('Ingrese genero: '); readln(n.genero);
		write('Ingrese precio: '); readln(n.precio);
	end;
end;

{---------CREAR ARCHIVO ELECTRODOMESTICO CON electro.txt--------------}

procedure crear_archivo_novela(var arc:arc_novelas);
var
	n:novela;
	carga:text;
begin
	assign(carga, 'novelas.txt');
	reset(carga);
	rewrite(arc);
	while(not eof(carga)) do begin
		readln(carga, n.codigo, n.precio, n.genero);
		readln(carga, n.nombre);
		write(arc, n);
	end;
	writeln('Archivo de novelas cargado');
	close(carga);
	close(arc);
end;

{-------------------IMPRIMIR REGISTRO-------------------------}

procedure imprimir_registro(n:novela);
begin
	writeln('Informacion de novela: ');
	writeln(n.codigo, ' ', n.precio:2:2, ' ', n.genero);
	writeln(n.nombre);
	writeln;
	writeln;
end;

{-------------LISTAR TODAS LAS NOVELAS-----------------}
{LO HAGO SOLO PARA VERIFICAR QUE SE CARGARON BIEN}

procedure recorrer_informar(var arc:arc_novelas);
var
	n:novela;
begin
	reset(arc);
	while(not eof(arc)) do begin
		read(arc, n);
		imprimir_registro(n);
		writeln('--------------------------');
	end;
	close(arc);
end;

{--------------------AGREGAR NOVELA-----------------------}

procedure agregar_novela(var arc: arc_novelas);
var
	n: novela;
begin
	reset(arc);
	seek(arc, filesize(arc));
	leer_novela(n);
	while (n.codigo <> -1) do begin
		write(arc,n);
		leer_novela(n);
	end;
	close(arc);
end;

{-------------------------MODIFICAR NOVELA----------------------------}

procedure modificar_novela(var arc:arc_novelas);
var
	cod, opcion: integer;
	n: novela;
begin
	reset(arc);
	writeln('Ingrese codigo de novela a buscar'); 
	write('Codigo: '); readln(cod);
	read(arc,n);
	while(not eof(arc) and (cod <> n.codigo)) do 
		read(arc, n);
	if (cod = n.codigo) then begin
		writeln('QUE DESEA MODIFICAR?');
		writeln('1: Codigo');
		writeln('2: Nombre');
		writeln('3: Genero');
		writeln('4: Precio');
		writeln('Ingrese opcion: '); readln(opcion);
		case opcion of
			1: begin 
				writeln('Ingrese nuevo codigo: '); readln(n.codigo);
				seek(arc, filepos(arc)-1);
				write(arc,n);
			end;
			2: begin
				writeln('Ingrese nuevo nombre: '); readln(n.nombre);
				seek(arc, filepos(arc)-1);
				write(arc, n);
			end;
			3: begin 
				writeln('Ingrese nuevo genero: '); readln(n.genero);
				seek(arc, filepos(arc)-1);
				write(arc, n);
			end;
			4: begin 
				writeln('Ingrese nuevo precio: '); readln(n.precio);
				seek(arc, filepos(arc)-1);
				write(arc,n);
			end;
		end;
	end;
	writeln('No se encontro la novela con codigo: ', n.codigo);
	close(arc);
end;

{--------------------PROGRAMA PRINCIPAL-------------------------}

var
	arc:arc_novelas;
	arc_fisico:string;
	opcion:integer;
begin
	write('Ingrese nombre de archivo de novelas: '); readln(arc_fisico);
	assign(arc, arc_fisico);
	writeln('MENU DE OPCIONES');
	writeln('1: Crear archivo');
	writeln('2: Listar en pantalla');
	writeln('3: Agregar una novela');
	writeln('4: Modificar una novela');
	writeln('5: Salir');
	writeln;
	write('Ingrese opcion: ') ;readln(opcion);
	writeln('-------------------------------------');
	while (opcion <> 5) do begin
		case opcion of
			1: crear_archivo_novela(arc);
			2: recorrer_informar(arc);
			3: agregar_novela(arc);
			4: modificar_novela(arc);
		end;
		writeln('-------------------------------------');
		writeln('MENU DE OPCIONES');
		writeln('1: Crear archivo');
		writeln('2: Listar en pantalla');
		writeln('3: Agregar una novela');
		writeln('4: Modificar una novela');
		writeln('5: Salir');
		writeln;
		write('Ingrese opcion: ') ;readln(opcion);
		writeln('-------------------------------------');
	end;
end.










