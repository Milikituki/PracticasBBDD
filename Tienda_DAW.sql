CREATE DATABASE Tienda_DAW;


-- Clientes
CREATE TABLE clientes (
  id_cliente INT AUTO_INCREMENT NOT NULL,
  nombre     VARCHAR(60)  NOT NULL,
  email      VARCHAR(100) NOT NULL UNIQUE,
  ciudad     VARCHAR(50)  NOT NULL,
  fecha_alta DATE         NOT NULL,
  PRIMARY KEY (id_cliente)
);

-- Categorías
CREATE TABLE categorias (
  id_categoria INT AUTO_INCREMENT NOT NULL,
  nombre       VARCHAR(60) NOT NULL UNIQUE,
  PRIMARY KEY (id_categoria)
);

-- Productos (1:N con categorías)

CREATE TABLE productos (
  id_producto  INT AUTO_INCREMENT NOT NULL,
  nombre       VARCHAR(80)  NOT NULL,
  precio       DECIMAL(10,2) NOT NULL,
  stock        INT NOT NULL,
  id_categoria INT NOT NULL,
 
  PRIMARY KEY (id_producto),
  
  CONSTRAINT fk_productos_categorias
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

-- Pedidos (1:N con clientes)

CREATE TABLE pedidos (
  id_pedido   INT AUTO_INCREMENT NOT NULL,
  id_cliente  INT NOT NULL,
  fecha       DATE NOT NULL,
  estado      ENUM('PENDIENTE','PAGADO','ENVIADO','CANCELADO') NOT NULL,
  total       DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (id_pedido),

  CONSTRAINT fk_pedidos_clientes
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

-- Líneas de pedido (N:M pedidos-productos) tabla intermedia

CREATE TABLE lineas_pedido (
  id_pedido       INT NOT NULL,
  id_producto     INT NOT NULL,
  cantidad        INT NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL,
 
  PRIMARY KEY (id_pedido, id_producto),

  CONSTRAINT fk_lineas_pedidos
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  
    CONSTRAINT fk_lineas_productos
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);


INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_alta) VALUES
(1,'Ana Ruiz','ana@correo.es','Sevilla','2024-01-10'),
(2,'Luis Pérez','luis@correo.es','Madrid','2024-02-05'),
(3,'Marta Gil','marta@correo.es','Valencia','2024-03-01');


INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_alta) VALUES 
(1000,'Maria Ruiz','maria@correo.es','Sevilla','2024-01-10');

select * from clientes;

INSERT INTO clientes (nombre, email, ciudad, fecha_alta) VALUES ('Pedro Ruiz','pr@correo.es','Madrid','2024-01-10');


INSERT INTO categorias (id_categoria, nombre) VALUES
(10,'Periféricos'),
(11,'Almacenamiento'),
(12,'Redes');



INSERT INTO productos (id_producto, nombre, precio, stock, id_categoria) VALUES
(100,'Teclado mecánico',79.90,15,10),
(101,'Ratón gaming',39.90,40,10),
(102,'SSD 1TB',89.00,20,11),
(103,'Router WiFi 6',129.00,8,12);

INSERT INTO pedidos (id_pedido, id_cliente, fecha, estado, total) VALUES
(500,1,'2024-05-03','PAGADO',119.80),
(501,1,'2024-05-10','PENDIENTE',89.00),
(502,2,'2024-05-12','ENVIADO',129.00),
(503,3,'2024-05-13','CANCELADO',39.90);

INSERT INTO lineas_pedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES
(500,100,1,79.90),
(500,101,1,39.90),
(501,102,1,89.00),
(502,103,1,129.00),
(503,101,1,39.90);



-- Consultas de práctica 



-- A) SELECT / WHERE / operadores


-- 1) Clientes de Sevilla
select * from clientes where ciudad = "Sevilla";
-- 2) Productos con stock bajo (<10)
select * from productos where stock <10;

-- 3) Pedidos entre dos fechas (incluye extremos)
SELECT* from pedidos where fecha BETWEEN '2026-02-18' and '2025-01-01';

-- 4) Pedidos con estado en lista cuyo estado sea pagado o enviado
SELECT* from pedidos where estado = 'en lista';
select * from pedidos
  where estado in('Pagado','Enviado');

-- 5) Productos cuyo nombre empieza por 'R'
select * from productos where nombre LIKE "R%";

-- 6) Emails que contienen 'correo'
select * from clientes where email like "%correo%";
-- 7) Total >= 100 y NO cancelado
select * from pedidos where total >= 100 AND estado != "CANCELADO";

-- 8) Productos de categorías 10 o 12 (IN)
select * from productos where id_categoria = 10 OR id_categoria = 12;
select * from productos where id_categoria in (10,12);
-- 9) Pedidos con total NO en {89,129} (NOT IN)
select * from pedidos where total not in (89,129);

-- 10) Pedidos PAGADOS o ENVIADOS (OR)
select * from pedidos where estado = "PAGADO" or estado = "ENVIADO";


-- 11) Pedidos NO (PAGADO) (NOT)
select * from pedidos where not estado = "PAGADO";

-- 12) Productos con precio entre 40 y 100
select * from productos where precio BETWEEN 40 and 100;



-- B) ORDER BY / LIMIT / DISTINCT


-- 13) Productos más caros primero
select precio from productos order by precio DESC;

-- 14) Top 2 productos con menos stock
select stock, nombre from productos order by stock LIMIT 2;


-- 15) Ciudades distintas de clientes
select DISTINCT ciudad from clientes;
select ciudad, count(*) as cant_ciud 
from clientes 
where ciudad <> "Sevilla"
group by ciudad;

-- 16) Pedidos: primero los más recientes
select fecha, id_pedido from pedidos order by fecha;




-- C) Agregadas + GROUP BY + HAVING


-- 17) Número de pedidos por estado
select estado, COUNT(*) as numero_pedidos from pedidos group by estado;


-- 18) Facturación total por estado (solo estados con total > 100)
select estado, sum(total) as facturacion_total from pedidos group by estado having sum(total) > 100;
select estado, sum(total) as facturacion_total from pedidos group by estado having facturacion_total > 100;


-- 19) Precio medio y stock total por categoría (en productos)
select id_categoria, AVG(precio) as precio_medio, sum(stock) as stock_total from productos group by id_categoria;


-- 20) Unidades vendidas por producto (en lineas_pedido)
select id_producto, sum(cantidad) as unidades_vendidas from lineas_pedido group by id_producto;


-- 21) Pedido más caro y más barato (MAX/MIN)
select id_pedido, MIN(total), MAX(total) from pedidos group by id_pedido;

-- 22) Precio máximo, mínimo y medio de productos
select id_producto, nombre, min(precio), max(precio), avg(precio) from productos group by nombre;

-- 23) Stock total en la tienda
select stock, sum(stock) as stock_total from productos;

-- 24) Estados con 2 o más pedidos (HAVING COUNT)
select estado, count(id_pedido) as mas_dos_pedidos from pedidos group by estado having mas_dos_pedidos >2;



-- D) Subconsultas (SIN JOIN): IN / NOT IN / escalares


-- 25) Clientes que han hecho algún pedido (IN)
select * from clientes where id_cliente in(select id_cliente from pedidos);

-- 26) Clientes SIN pedidos (NOT IN)
select * from clientes where id_cliente not in(select id_cliente from pedidos);

-- 27) Pedidos por encima de la media del total
select * from pedidos where total > (select avg(total) from pedidos);

-- 28) Productos que aparecen en alguna línea de pedido
select * from productos where id_producto in (select id_producto from lineas_pedido);
-- 29) Productos que NO aparecen en líneas (nunca vendidos)
select * from productos where id_producto not in (select id_producto from lineas_pedido);
-- 30) Pedidos cuyo total es igual al máximo total
select * from pedidos where total = (select max(total) from pedidos);

-- E) EXISTS / NOT EXISTS (correlacionadas)


-- 31) Clientes que tienen al menos 1 pedido (EXISTS)
select * from clientes c where exists (select 1 from pedidos p where p.id_cliente = c.id_cliente);
-- 32) Clientes sin pedidos (NOT EXISTS)
select * from clientes c where not exists (select 1 from pedidos p where p.id_cliente = c.id_cliente);
-- 33) Pedidos que tienen líneas (EXISTS)


-- 34) Pedidos que NO tienen líneas (NOT EXISTS) (por si existieran)


-- 35) Para cada cliente, número de pedidos (columna calculada)


-- 36) Para cada pedido, número de líneas (columna calculada)



-- F) Funciones de fecha y texto


-- 37) Clientes dados de alta en 2024 (YEAR)
 select * from clientes
  where YEAR(fecha_alta) = '2024';

-- 38) Pedidos del mes de mayo (MONTH)


-- 39) Emails en mayúsculas (UPPER)


-- 40) Longitud del nombre del producto (CHAR_LENGTH)



-- F) INSERT / UPDATE / DELETE (PRUEBAS)
-- OJO: Estas sentencias CAMBIAN datos!!!!

-- 41) Insertar un cliente nuevo con todos los atributos


-- 42) Subir stock a 25 del producto 103


-- 43) Rebajar un 10% los productos de precio > 100


-- 44) Poner stock a 0 a productos sin ventas (NOT IN)


-- 45) Borrar pedidos cancelados


-- 46) Borrar líneas de un pedido concreto


-- 47) Borrar clientes sin pedidos (siempre que no estén referenciados)



-- G) ALTER TABLE (estructura) 
-- OJO: Esto MODIFICA la estructura de las tablas!!!!

-- 48) Añadir columna teléfono a clientes


-- 49) Cambiar longitud del nombre en productos


-- 50) Renombrar columna total -> total_eur 






