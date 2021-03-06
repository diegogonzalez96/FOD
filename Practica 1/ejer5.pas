program ejer5;

type
	articulo = record
		codigo:integer;
		nombre:string;
		descripcion:string;
		precio:real;
		stockMin:integer;
		stockDisp:integer;
	end;
	
	arc_articulos = file of articulo;


{------------LEER REGISTRO ARTICULO---------------------}

{procedure leer_articulos (var a:articulo);
begin
	writeln('INGRESE DATOS DEL ELECTRODOMESTICO:');
	writeln('Ingrese nombre: : '); readln(a.nombre);
	if (a.nombre <> ' ') then begin
		writeln('Ingrese codigo: '); readln(a.codigo);
		writeln('Ingrese descripcion: '); readln(a.descripcion);
		writeln('Ingrese precio: '); readln(a.precio);
		writeln('Ingrese stock minimo: '); readln(a.stockMin);
		writeln('Ingrese stock disponible: '); readln(a.stockDisp);
	end;
end;}


{---------CREAR ARCHIVO ELECTRODOMESTICO CON electro.txt--------------}

procedure crear_archivo_electro(var arc:arc_articulos);
var
	carga: Text;
	a: articulo;
begin
	assign(carga,'carga.txt');
	reset(carga);
	rewrite(arc);
	while(not eof(carga)) do begin
		readln(carga, a.codigo, a.precio, a.nombre);
		readln(carga, a.stockDisp, a.stockMin, a.descripcion);
		write(arc, a);
	end;
	writeln('Archivo de electrodomesticos cargado');
	close(carga);
	close(arc);
end;

{-------------------IMPRIMIR REGISTRO-------------------------}

procedure imprimir_registro(a: articulo);
begin
	writeln('Informacion de electrodomestico: ');
	writeln(a.codigo, ' ', a.precio:2:2, ' ', a.nombre);
	writeln;
	writeln(a.stockDisp, ' ', a.stockDisp, ' ', a.descripcion);
	writeln;
	writeln;
end;

{-----------LISTAR ELECTRODOMESTICOS CON STOCK MENOR AL MINIMO--------------}

procedure recorrer_inciso5b(var arc:arc_articulos);
var
	a:articulo;
begin
	reset(arc);
	while(not eof(arc)) do begin
		read(arc, a);
		if (a.stockDisp < a.stockMin) then begin
			imprimir_registro(a);
			writeln('--------------------------');
		end;
	end;
	close(arc);
end;

{-------------LISTAR TODOS LOS ELECTRODOMESTICOS-----------------}
{LO HAGO SOLO PARA VERIFICAR QUE SE CARGARON BIEN}

procedure recorrer_informar(var arc:arc_articulos);
var
	a:articulo;
begin
	reset(arc);
	while(not eof(arc)) do begin
		read(arc, a);
		imprimir_registro(a);
		writeln('--------------------------');
	end;
	close(arc);
end;

{-----------------ELECTRODOMESTICO CON DESCRIPCION A BUSCAR---------------}

procedure inciso5c (a: articulo; desc: String; var ok: boolean);
begin
	if (desc = a.descripcion) then begin
		writeln;
		imprimir_registro(a);
		ok:= true;
	end;
end;

{-------------LISTAR ELECTRODOMESTICOS CON DESCRIPCION A BUSCAR--------------}

procedure recorrer_inciso5c(var arc:arc_articulos);
var
	desc:string;
	a:articulo;
	ok:boolean;
begin
	ok:= false;
	reset(arc);
	writeln('Ingrese descripcion a buscar: ');
	readln(desc);
	while (not eof(arc)) do begin
		read(arc,a);
		inciso5c(a, desc, ok);
	end;
	if (ok = false) then begin
		writeln('No se encontro descripcion.');
		writeln;
	end;
	writeln;
	close(arc);
end;

{----------------EXPORTAR ARCHIVO BINARIO A UN ARCHIVO TEXTO------------------------}

procedure recorrer_inciso5d(var arc:arc_articulos);
var
	carga:text;
	a:articulo;
begin
	assign(carga, 'electro.txt');
	reset(arc);
	rewrite(carga);
	while (not eof(arc)) do begin
		read(arc,a);
		writeln(carga, a.codigo,' ', a.precio:2:2, a.nombre);
		writeln(carga, a.stockDisp,' ', a.stockMin, a.descripcion);
	end;
	close(arc);
	close(carga);
	writeln('Archivo exportado.');
	writeln('--------------------------');
end;

{--------------------PROGRAMA PRINCIPAL-------------------------}

var
	arc:arc_articulos;
	opcion:integer;
	arc_fisico:string;
begin
	write('Ingrese nombre de archivo de electrodomesticos: '); readln(arc_fisico);
	assign(arc, arc_fisico);
	writeln('MENU DE OPCIONES');
	writeln('1: Crear archivo');
	writeln('2: Listar en pantalla aquellos con stock menor al minimo');
	writeln('3: Listar en pantalla');
	writeln('4: Buscar descripcion');
	writeln('5: Exportar archivo');
	writeln('6: Salir');
	writeln;
	readln(opcion);
	writeln('-------------------------------------');
	while (opcion <> 6) do begin
		case opcion of
			1: crear_archivo_electro(arc);
			2: recorrer_inciso5b(arc);
			3: recorrer_informar(arc);
			4: recorrer_inciso5c(arc);
			5: recorrer_inciso5d(arc);
		end;
		writeln('-------------------------------------');
		writeln('MENU DE OPCIONES');
		writeln('1: Crear archivo');
		writeln('2: Listar en pantalla aquellos con stock menor al minimo');
		writeln('3: Listar en pantalla');
		writeln('4: Buscar descripcion');
		writeln('5: Exportar archivo');
		writeln('6: Salir');
		writeln;
		readln(opcion);
		writeln('-------------------------------------');
	end;
end.
	
