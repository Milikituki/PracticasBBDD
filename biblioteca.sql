create DATABASE biblioteca;

create table
    usuarios (
        id_usuario int AUTO_INCREMENT primary key,
        nombre varchar(50) not null,
        correo varchar(100),
        edad int
    );

insert into
    libros (titulo, autor, anio)
VALUES
    ("Don Quijote", "Miguel de Cervantes", 1605),
    ("1984", "George Orwell", 1949),
    ("El principito", "Antoine de Saint-Exupéry", 1943);

insert into
    usuarios (nombre, edad)
values
    ("Ana", 22),
    ("Luis", 25),
    ("Marta", 18),
    ("Carlos", 30);

update libros
set
    disponible = false
where
    titulo = "El Principito";

update usuarios
set
    correo = "ana@correo.com"
WHERE
    id_usuario = 1;

update usuarios
set
    edad = + 1
where
    edad > 25;

--No está bien, le pone 1 a la edad
update usuarios
set
    edad = 30
where
    nombre = "Carlos";

update usuarios
set
    edad = edad + 1
where
    edad > 25;

delete from libros
where
    id_libro = 2;

delete from usuarios
where
    edad < 18;

select
    *
from
    usuarios;

select
    *
from
    libros;