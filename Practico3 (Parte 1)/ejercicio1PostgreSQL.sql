drop schema if exists ejercicio1 cascade;
CREATE schema ejercicio1;



DROP TABLE IF EXISTS  ejercicio1.producto ;
CREATE TABLE  ejercicio1.producto  (
   COD_PRODUCTO  int NOT NULL,
   DESCRIPCION  varchar(40) default NULL,
   PRECIO  decimal(9,2) default NULL,
  PRIMARY KEY  ( COD_PRODUCTO )
);

--
-- Dumping data for table  ejercicio1 . producto 
--

/*!40000 ALTER TABLE  producto  DISABLE KEYS */;
INSERT INTO  ejercicio1.producto  ( COD_PRODUCTO , DESCRIPCION , PRECIO ) VALUES 
 (1,'Acondicionador de Aire SPLIT GE 3000F','1794.56'),
 (2,'Acondicionador de Aire SPLIT GE 1500F','998.00'),
 (3,'Home Cinema c/DVD PHILIPS MX3090','946.30'),
 (4,'Reproducto DVD PHILIPS ','314.70'),
 (5,'TV Sony 21" ','1465.60'),
 (6,'TV Sony 29" ','2950.58'),
 (7,'TV PLASMA PHILIPS 42"','6999.00'),
 (8,'Heladera Ariston MT451 NF 450L','2472.60'),
 (9,'Heladera Gafa HGF3880P 420L','1815.80'),
 (10,'Heladera Whirlpool WRM36D 325L','2081.00'),
 (11,'Heladera Whirlpool WRX48X 439L','3330.50'),
 (12,'TV BGH LCD 32" BL 3201S','5332.60'),
 (13,'Filmadora JVC GRD350','1998.90'),
 (14,'Camara Digital Olimpus 6MPX X760','841.10'),
 (15,'Rerproductor MP3 PHILIPS 1GB SA1115','397.80'),
 (16,'Microondas BGH Quick Chef 30L ','1899.00'),
 (17,'Lavasecarropas LONGVIE LS3817','2195.30'),
 (18,'Lavavajilla Whirlpool RLD20A','1420.00'),
 (19,'Cocina LONGVIE 3501X','2224.00'),
 (20,'Calefactor LONGVIE 6000 Cal/h','679.00'),
 (21,'Calefon LONGVIE C212BSN 12L','740.00'),
 (22,'CTI Nokia NK1600 Kit Prepago','202.80');
INSERT INTO  ejercicio1.producto  ( COD_PRODUCTO , DESCRIPCION , PRECIO ) VALUES 
 (23,'Mesa 1x3m madera','452.00');



--
-- Table structure for table  ejercicio1 . cliente 
--

CREATE TABLE ejercicio1.cliente (
   NRO_CLIENTE  int NOT NULL,
   APELLIDO  varchar(20) NOT NULL,
   NOMBRE  varchar(40) default NULL,
   DIRECCION  varchar(30) default NULL,
   TELEFONO  varchar(15) default NULL,
  PRIMARY KEY  ( NRO_CLIENTE )
); 

--
-- Dumping data for table  ejercicio1 . cliente 
--

INSERT INTO  ejercicio1.cliente  ( NRO_CLIENTE , APELLIDO , NOMBRE , DIRECCION , TELEFONO ) VALUES
 (1,'ALVAREZ','MATIAS','San Martin 20','0358-4676529'),
 (2,'ARIAS SCHIAVI','JUAN PABLO','Bs. As. 150','0358-4676235'),
 (3,'BARALE','MAYCO','Bs. As. 1363','0358-4676235'),
 (4,'BETTIOL','NICOLAS MATIAS','Mendoza 1258','0358-155458497'),
 (5,'BONO','FEDERICO','Jujuy 3540','0358-4598712'),
 (6,'CABRAL','HERNAN','Pje. Mercedario 758','0358-4639741'),
 (7,'CAMPAGNA','JULIETA','Roma 1158','0358-4482567'),
 (8,'CAMPOS','GONZALO','Lago Traful 2987','0358-4795412'),
 (9,'CARDETTI','SILVINA','Belgrano 150','0358-4601100'),
 (10,'CARRENO','GERMAN','Dean funes 358','0358-155478445'),
 (11,'CASTELLI','JESUS','Dinkeldein 450','0358-459128'),
 (12,'CASTELLINA','FRANCO','Carlos Goudard 2589','0358-156448114'),
 (13,'CHIOTTA','FRANCISCO','Maria Olguin 1348','0358-174145654'),
 (14,'DOMINGUEZ','ELIANA','Cabrera 1589','0358- 555741'),
 (15,'TURLETTI','LUCAS','Laguna Blanca 933 1ro A','0358-4798562'),
 (16,'PAUTASSO','MATIAS','Paunero 750','0358-458726'),
 (17,'ONTIVERO','MARIANO','Sobremonte 1789','0358-4623332');
INSERT INTO  ejercicio1.cliente  ( NRO_CLIENTE , APELLIDO , NOMBRE , DIRECCION , TELEFONO ) VALUES
 (18,'MONTANARI','GISELA','Sarmiento 458','0350-4987526'),
 (19,'VARELA','MANUEL','Alvear 1390','0358-155078905'),
 (20,'RIBERI','FRANCO','Constitucion 1154','0358-4680000'),
 (21,'ROMERO','SYDOR','Sadi Carnot 120','0358-4635975'),
 (22,'ROVERA','CHRISTIAN','Rio Cuarto - Belgrano 100','0358-457844'),
 (23,'LAGABLE','NATALIA','Rioja 990','155879145');


--
-- Table structure for table  ejercicio1 . factura 
--

DROP TABLE IF EXISTS  ejercicio1.factura ;
CREATE TABLE  ejercicio1.factura  (
   NRO_FACTURA  varchar(12) NOT NULL,
   FECHA  date NOT NULL,
   NRO_CLIENTE  int NOT NULL,
   MONTO  decimal(9,2) default NULL,
  PRIMARY KEY  ( NRO_FACTURA ),
  CONSTRAINT  FK_FACTURA_1  FOREIGN KEY ( NRO_CLIENTE ) REFERENCES  ejercicio1.cliente  ( NRO_CLIENTE )
); 

--
-- Dumping data for table  ejercicio1 . factura 
--

/*!40000 ALTER TABLE  factura  DISABLE KEYS */;
INSERT INTO  ejercicio1.factura  ( NRO_FACTURA , FECHA , NRO_CLIENTE , MONTO ) VALUES 
 ('000-0001','2020-03-31',1,'1795.00'),
 ('000-0002','2020-03-31',2,'90275.80'),
 ('000-0003','2020-04-02',2,'46768.00'),
 ('000-0004','2020-04-02',4,'16846.00'),
 ('000-0005','2020-04-02',5,'202.00'),
 ('000-0006','2020-04-02',3,'8000.00'),
 ('000-0007','2020-04-02',2,'6820.00');
/*!40000 ALTER TABLE  factura  ENABLE KEYS */;


--
-- Table structure for table  ejercicio1 . itemfactura 
--

DROP TABLE IF EXISTS  ejercicio1.itemfactura ;
CREATE TABLE  ejercicio1.itemfactura  (
   NRO_FACTURA  varchar(12) NOT NULL,
   COD_PRODUCTO  int NOT NULL,
   CANTIDAD  int NOT NULL,
   PRECIO  decimal(9,2) NOT NULL,
  PRIMARY KEY  ( NRO_FACTURA , COD_PRODUCTO ),
  CONSTRAINT  FK_ITEMFACTURA_1  FOREIGN KEY ( COD_PRODUCTO ) REFERENCES  ejercicio1.producto  ( COD_PRODUCTO ),
  CONSTRAINT  FK_ITEMFACTURA_2  FOREIGN KEY ( NRO_FACTURA ) REFERENCES  ejercicio1.factura  ( NRO_FACTURA )
);

--
-- Dumping data for table  ejercicio1 . itemfactura 
--

/*!40000 ALTER TABLE  itemfactura  DISABLE KEYS */;
INSERT INTO  ejercicio1.itemfactura  ( NRO_FACTURA , COD_PRODUCTO , CANTIDAD , PRECIO ) VALUES 
 ('000-0001',1,2,'1795.00'),
 ('000-0002',1,1,'1795.00'),
 ('000-0002',2,1,'998.00'),
 ('000-0002',3,2,'945.00'),
 ('000-0002',4,10,'3140.00'),
 ('000-0002',5,4,'1465.60'),
 ('000-0002',6,4,'2950.00'),
 ('000-0002',7,4,'7000.00'),
 ('000-0002',8,4,'2472.60'),
 ('000-0002',9,4,'1815.00'),
 ('000-0002',10,4,'2081.00'),
 ('000-0002',11,4,'3300.00'),
 ('000-0003',12,4,'5335.00'),
 ('000-0003',13,2,'1998.00'),
 ('000-0003',14,2,'841.00'),
 ('000-0003',15,2,'398.00'),
 ('000-0003',16,5,'1900.00'),
 ('000-0003',17,2,'2200.00'),
 ('000-0003',18,2,'1420.00'),
 ('000-0003',19,1,'2224.00'),
 ('000-0004',1,1,'1800.00'),
 ('000-0004',3,1,'946.00'),
 ('000-0004',7,2,'7050.00'),
 ('000-0005',22,1,'202.00'),
 ('000-0006',4,1,'1000.00'),
 ('000-0006',5,1,'1400.00'),
 ('000-0006',11,1,'3400.00'),
 ('000-0006',19,1,'2200.00'),
 ('000-0007',20,3,'680.00'),
 ('000-0007',21,1,'740.00'),
 ('000-0007',22,20,'202.00');
/*!40000 ALTER TABLE  itemfactura  ENABLE KEYS */;


--
-- Table structure for table  ejercicio1 . producto
--

