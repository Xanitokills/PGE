-- Jerarqu?a Geogr?fica
CREATE TABLE MAE_Departamento (
    ID_Departamento INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Codigo_Ubigeo CHAR(2) NOT NULL UNIQUE
);

CREATE TABLE MAE_Provincia (
    ID_Provincia INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Codigo_Ubigeo CHAR(4) NOT NULL UNIQUE,
    ID_Departamento INT,
    CONSTRAINT FK_Provincia_Departamento FOREIGN KEY (ID_Departamento) REFERENCES MAE_Departamento(ID_Departamento)
);

CREATE TABLE MAE_Distrito (
    ID_Distrito INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Codigo_Ubigeo CHAR(6) NOT NULL UNIQUE,
    ID_Provincia INT,
    CONSTRAINT FK_Distrito_Provincia FOREIGN KEY (ID_Provincia) REFERENCES MAE_Provincia(ID_Provincia)
);






-- ?reas
CREATE TABLE MAE_AREA (
    ID_Area INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Abreviacion NVARCHAR(50) NOT NULL,
    Estado BIT NOT NULL DEFAULT 1
);

-- Roles
CREATE TABLE MAE_ROL (
    ID_ROL INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(50) NOT NULL,
    Descripcion NVARCHAR(255),
    Estado BIT NOT NULL DEFAULT 1
);

-- Permisos
CREATE TABLE MAE_PERMISO (
    ID_Permiso INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL, -- Ejemplo: 'Crear_Acta', 'Leer_Componente'
    Descripcion NVARCHAR(255),
    Modulo NVARCHAR(100), -- Ejemplo: 'Gesti?n de Actas'
    Estado BIT NOT NULL DEFAULT 1
);

CREATE TABLE MAE_ROL_PERMISO (
    ID_ROL INT,
    ID_Permiso INT,
    PRIMARY KEY (ID_ROL, ID_Permiso),
    CONSTRAINT FK_RolPermiso_Rol FOREIGN KEY (ID_ROL) REFERENCES MAE_ROL(ID_ROL),
    CONSTRAINT FK_RolPermiso_Permiso FOREIGN KEY (ID_Permiso) REFERENCES MAE_PERMISO(ID_Permiso)
);

-- Cargos
CREATE TABLE MAE_Cargo (
    ID_Cargo INT IDENTITY(1,1) PRIMARY KEY,
    Nombre_Cargo NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(255),
    Estado BIT NOT NULL DEFAULT 1
);
-- Usuarios
CREATE TABLE MAE_USUARIOS (
    ID_Usuario INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(50) NOT NULL,
    Apellido_Paterno NVARCHAR(50) NOT NULL,
    Apellido_Materno NVARCHAR(50) NOT NULL,
    ID_Cargo INT,
    Correo NVARCHAR(100) NOT NULL UNIQUE,
    Nombre_Usuario NVARCHAR(50) NOT NULL UNIQUE,
    Password_Hash NVARCHAR(255) NOT NULL,
    ID_Rol INT NOT NULL,
    ID_Area INT NOT NULL,
    ID_Distrito INT,
    Token NVARCHAR(255),
    Estado BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Usuario_Rol FOREIGN KEY (ID_Rol) REFERENCES MAE_ROL(ID_Rol),
    CONSTRAINT FK_Usuario_Area FOREIGN KEY (ID_Area) REFERENCES MAE_AREA(ID_Area),
    CONSTRAINT FK_Usuario_Cargo FOREIGN KEY (ID_Cargo) REFERENCES MAE_Cargo(ID_Cargo),
    CONSTRAINT FK_Usuario_Distrito FOREIGN KEY (ID_Distrito) REFERENCES MAE_Distrito(ID_Distrito)
);

-- Comisi?n de Transferencia
CREATE TABLE MAE_Comision_Transferencia (
    ID_Comision INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    ID_Usuario_Secretaria INT,
    Descripcion NVARCHAR(255),
    Estado BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Comision_Usuario FOREIGN KEY (ID_Usuario_Secretaria) REFERENCES MAE_USUARIOS(ID_Usuario)
);

-- Niveles de Gobierno
CREATE TABLE MAE_NIVEL_GOBIERNO (
    ID_Nivel_Gobierno INT IDENTITY(1,1) PRIMARY KEY,
    Nombre_Nivel_Gobierno NVARCHAR(100) NOT NULL, -- Ejemplo: 'Nacional', 'Regional', 'Local'
    Estado BIT NOT NULL DEFAULT 1
);

-- Entidades (Procuradur?as)
CREATE TABLE MAE_ENTIDAD (
    ID_Entidad INT IDENTITY(1,1) PRIMARY KEY,
    Nombre_Entidad NVARCHAR(100) NOT NULL,
    Abreviatura_Entidad NVARCHAR(70) NOT NULL,
    ID_Nivel_Gobierno INT,
    ID_Distrito INT,
    Estado BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Entidad_Nivel FOREIGN KEY (ID_Nivel_Gobierno) REFERENCES MAE_NIVEL_GOBIERNO(ID_Nivel_Gobierno),
    CONSTRAINT FK_Entidad_Distrito FOREIGN KEY (ID_Distrito) REFERENCES MAE_Distrito(ID_Distrito)
);

-- Tipos de Documento
CREATE TABLE MAE_TIPO_DOCUMENTO (
    ID_Tipo_Documento INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL, -- Ejemplo: 'Acta de Cierre', 'Presupuesto'
    Descripcion NVARCHAR(255),
    Estado BIT NOT NULL DEFAULT 1
);


ALTER TABLE MAE_TIPO_DOCUMENTO
ADD Fecha_Documento DATETIME;

-- Proceso de Transferencia
CREATE TABLE MAE_Proceso_Transferencia (
    ID_Proceso INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion NVARCHAR(255) NOT NULL,
    Fecha_Inicio DATE,
    Fecha_Fin DATE,
    ID_Comision INT,
    Estado BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Proceso_Comision FOREIGN KEY (ID_Comision) REFERENCES MAE_Comision_Transferencia(ID_Comision)
);


-- Componentes
CREATE TABLE MAE_Componente (
    ID_Componente INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL, -- Ejemplo: 'Presupuesto', 'Recursos Humanos'
    Descripcion NVARCHAR(255),
    Presupuesto DECIMAL(15,2),
    ID_Proceso INT,
    Estado BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Componente_Proceso FOREIGN KEY (ID_Proceso) REFERENCES MAE_Proceso_Transferencia(ID_Proceso)
);

-- Documentos
CREATE TABLE MAE_DOCUMENTO (
    ID_Documento INT IDENTITY(1,1) PRIMARY KEY,
    ID_Tipo_Documento INT,
    ID_Componente INT,
    Contenido NVARCHAR(MAX),
    Fecha_Creacion DATE,
    Nombre_Archivo NVARCHAR(255),
    Estado BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Documento_Tipo FOREIGN KEY (ID_Tipo_Documento) REFERENCES MAE_TIPO_DOCUMENTO(ID_Tipo_Documento),
    CONSTRAINT FK_Documento_Componente FOREIGN KEY (ID_Componente) REFERENCES MAE_Componente(ID_Componente)
);



-- Responsables de Componentes
CREATE TABLE MAE_RESPONSABLE_COMPONENTE (
    ID_ResponsableComponente INT IDENTITY(1,1) PRIMARY KEY,
    ID_Usuario INT NOT NULL,
    ID_Componente INT NOT NULL,
    Estado BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Responsable_Usuario FOREIGN KEY (ID_Usuario) REFERENCES MAE_USUARIOS(ID_Usuario),
    CONSTRAINT FK_Responsable_Componente FOREIGN KEY (ID_Componente) REFERENCES MAE_Componente(ID_Componente)
);

-- Reuniones
CREATE TABLE MAE_Reunion (
    ID_Reunion INT IDENTITY(1,1) PRIMARY KEY,
    ID_Componente INT,
    ID_Usuario_Responsable INT,
    Fecha DATE,
    Duracion TIME,
    Descripcion NVARCHAR(255),
    Estado BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Reunion_Componente FOREIGN KEY (ID_Componente) REFERENCES MAE_Componente(ID_Componente),
    CONSTRAINT FK_Reunion_Usuario FOREIGN KEY (ID_Usuario_Responsable) REFERENCES MAE_USUARIOS(ID_Usuario)
);

-- Actas de Cierre
CREATE TABLE MAE_Acta_Cierre (
    ID_Acta INT IDENTITY(1,1) PRIMARY KEY,
    ID_Componente INT,
    ID_Usuario_Aprobador INT,
    Fecha DATE,
    Contenido NVARCHAR(MAX),
    Estado_Acta NVARCHAR(50), -- Ejemplo: 'Cerrado', 'Pendiente'
    Estado BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Acta_Componente FOREIGN KEY (ID_Componente) REFERENCES MAE_Componente(ID_Componente),
    CONSTRAINT FK_Acta_Usuario FOREIGN KEY (ID_Usuario_Aprobador) REFERENCES MAE_USUARIOS(ID_Usuario)
);

-- Relaci?n Proceso-Entidad
CREATE TABLE MAE_Proceso_Entidad (
    ID_Proceso INT,
    ID_Entidad INT,
    PRIMARY KEY (ID_Proceso, ID_Entidad),
    CONSTRAINT FK_ProcesoEntidad_Proceso FOREIGN KEY (ID_Proceso) REFERENCES MAE_Proceso_Transferencia(ID_Proceso),
    CONSTRAINT FK_ProcesoEntidad_Entidad FOREIGN KEY (ID_Entidad) REFERENCES MAE_ENTIDAD(ID_Entidad)
);
--modificacion


CREATE TABLE MAE_ENTIDAD_NIVEL_GOBIERNO (
ID_Entidad_Nivel_Gobierno INT IDENTITY (1,1) PRIMARY KEY,
Nombre_Entidad_Nivel_Gobierno NVARCHAR(100) NOT NULL,
Estado_Entidad_Nivel_Gobierno  BIT NOT NULL DEFAULT 1,
ID_Gobierno_Nacional INT,
ID_Gobierno_Regional INT ,
ID_Gobierno_Local INT ,


);


CREATE TABLE MAE_GOBIERNO_NACIONAL (
ID_Gobierno_Nacional INT IDENTITY (1,1) PRIMARY KEY,
Nombre_Gobierno_Nacional NVARCHAR(100) NOT NULL,
Estado_Gobierno_Nacional BIT NOT NULL DEFAULT 1
);

CREATE TABLE MAE_GOBIERNO_REGIONAL (
ID_Gobierno_Regional INT IDENTITY (1,1) PRIMARY KEY,
Nombre_Gobierno_Regional NVARCHAR(100) NOT NULL,
Estado_Gobierno_Regional BIT NOT NULL DEFAULT 1
);

CREATE TABLE MAE_GOBIERNO_LOCAL (
ID_Gobierno_Local INT IDENTITY (1,1) PRIMARY KEY,
Nombre_Gobierno_Local NVARCHAR(100) NOT NULL,
Estado_Gobierno_Local BIT NOT NULL DEFAULT 1
);



ALTER TABLE MAE_ENTIDAD_NIVEL_GOBIERNO
ADD CONSTRAINT FK_Entidad_GobiernoNacional 
FOREIGN KEY (ID_Gobierno_Nacional) 
REFERENCES MAE_GOBIERNO_NACIONAL(ID_Gobierno_Nacional);

ALTER TABLE MAE_ENTIDAD_NIVEL_GOBIERNO
ADD CONSTRAINT FK_Entidad_GobiernoRegional 
FOREIGN KEY (ID_Gobierno_Regional) 
REFERENCES MAE_GOBIERNO_REGIONAL(ID_Gobierno_Regional);

ALTER TABLE MAE_ENTIDAD_NIVEL_GOBIERNO
ADD CONSTRAINT FK_Entidad_GobiernoLocal 
FOREIGN KEY (ID_Gobierno_Local) 
REFERENCES MAE_GOBIERNO_LOCAL(ID_Gobierno_Local);

select * from MAE_RESPONSABLE_COMPONENTE
SELECT * FROM MAE_AREA

alter table MAE_RESPONSABLE_COMPONENTE
add ID_CARGO INT;

alter table MAE_RESPONSABLE_COMPONENTE
add ID_AREA INT;


ALTER TABLE MAE_RESPONSABLE_COMPONENTE
ADD CONSTRAINT FK_ResposableComponente_Area 
FOREIGN KEY (ID_AREA) REFERENCES MAE_AREA(ID_AREA)


ALTER TABLE MAE_RESPONSABLE_COMPONENTE
ADD CONSTRAINT FK_CARGO_COMPONENTE_RESPONSABLE
FOREIGN KEY (ID_CARGO) REFERENCES MAE_CARGO(ID_CARGO)



SELECT * FROM MAE_ENTIDAD
SELECT * FROM MAE_ENTIDAD_NIVEL_GOBIERNO
SELECT * FROM MAE_GOBIERNO_LOCAL
SELECT * FROM MAE_GOBIERNO_REGIONAL
SELECT * FROM MAE_GOBIERNO_NACIONAL
SELECT * FROM MAE_Componente
SELECT * FROM MAE_RESPONSABLE_COMPONENTE


ALTER TABLE MAE_Componente
ADD Id_Sub_Componente INT;

ALTER TABLE MAE_ENTIDAD_NIVEL_GOBIERNO
ADD CONSTRAINT FK_CARGO_COMPONENTE_RESPONSABLE
FOREIGN KEY (ID_CARGO) REFERENCES MAE_CARGO(ID_CARGO)


---

ALTER TABLE MAE_ENTIDAD
ADD CONSTRAINT FK_Entidad_EntidadNivelGobierno 
FOREIGN KEY (ID_Entidad_Nivel_Gobierno) 
REFERENCES MAE_ENTIDAD_NIVEL_GOBIERNO(ID_Entidad_Nivel_Gobierno);

-- Si ID_Distrito es una clave foránea a otra tabla (no definida), descomenta y ajusta:
-- ALTER TABLE MAE_ENTIDAD
-- ADD CONSTRAINT FK_Entidad_Distrito 
-- FOREIGN KEY (ID_Distrito) 
-- REFERENCES MAE_DISTRITO(ID_Distrito); -- Asegúrate de crear esta tabla si es necesario



CREATE TABLE ACCIONES_PREDECEDORAS (
    ID_Acciones_Predecedora INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion NVARCHAR(500) NOT NULL,
    Estado BIT NOT NULL DEFAULT 1,
    NRO_Accion NVARCHAR(20),
    ID_Responsable_Entidad INT
);

ALTER TABLE ACCIONES_PREDECEDORAS
ADD NRO_ACCION_PREDECEDORA VARCHAR(20)


INSERT INTO ACCIONES_PREDECEDORAS (NRO_Accion, Descripcion, ID_Responsable_Entidad, Estado) VALUES
('1.1', 'Aprobación del plan de acción y formatos', NULL, 1),
('1.1.1', 'Revisión de las actividades del plan de acción y anexos (formatos)', NULL, 1),
('1.1.2', 'Aprobación del plan de acción y anexos (formatos)', NULL, 1),
('1.2', 'Transferencia de recursos presupuestarios', NULL, 1),
('1.2.1', 'Sesión de los responsables de presupuesto para la definición de plazos', NULL, 1),
('1.2.2', 'Solicitud de información del anexo 17', NULL, 1),
('1.2.3', 'Remisión de información del anexo 17', NULL, 1),
('1.2.4', 'Cierre de transferencia de presupuesto (suscripción de acta)', NULL, 1),
('1.2.5', 'Elaboración y remisión del proyecto de decreto supremo (DS)', NULL, 1),
('1.2.6', 'Aprobación y publicación del DS', NULL, 1),
('1.3', 'Transferencia de recursos humanos', NULL, 1),
('1.3.1', 'Sesión de los responsables de recursos humanos para la definición de plazos', NULL, 1),
('1.3.2', 'Solicitud de información de los anexos 1 a 3', NULL, 1),
('1.3.3', 'Remisión de información de los anexos 1 al 3', NULL, 1),
('1.3.4', 'Validación de la información de los anexos 1 al 3', NULL, 1),
('1.3.5', 'Remisión de los legajos de personal activo', NULL, 1),
('1.3.6', 'Validación de los legajos de personal activo', NULL, 1),
('1.3.7', 'Remisión de informe por subsistemas de gestión de recursos humanos', NULL, 1),
('1.3.8', 'Validación de informe por subsistemas de gestión de recursos humanos', NULL, 1),
('1.3.9', 'Cierre de transferencia de recursos humanos (suscripción de acta)', NULL, 1),
('1.4', 'Transferencia de bienes y servicios', NULL, 1),
('1.4.1', 'Sesión de los responsables de abastecimiento para la definición de plazos', NULL, 1),
('1.4.2', 'Solicitud de información de los anexos 4 a 10', NULL, 1),
('1.4.3', 'Entrega de la información de los anexos 4 a 10', NULL, 1),
('1.4.4', 'Transferencia de bienes muebles', NULL, 1),
('1.4.4.1', 'Verificación física de bienes muebles patrimoniales (suscripción de acta)', NULL, 1),
('1.4.4.2', 'Solicitud de transferencia de los bienes muebles patrimoniales formulada por la PGE al MVCS, en el marco de la normativa vigente.', NULL, 1),
('1.4.4.3', 'Evaluación de la solicitud y formulación de informe técnico para opinión favorable de baja por causal no prevista, y proyección de resolución de baja y transferencia de bienes muebles, en el marco de la normativa vigente.', NULL, 1),
('1.4.4.4', 'Aprobación de resolución de baja y transferencia de bienes muebles, en el marco de la normativa vigente.', NULL, 1),
('1.4.4.5', 'Suscripción del Acta de entrega - recepción correspondiente, conforme a la normativa vigente.', NULL, 1),
('1.4.5', 'Coordinaciones para la suscripción del convenio', NULL, 1),
('1.4.6', 'Cierre de transferencia de bienes y servicios (suscripción de acta)', NULL, 1),
('1.5', 'Transferencia del acervo documentario', NULL, 1),
('1.5.1', 'Sesión de los responsables de acervo documentario para la definición de plazos', NULL, 1),
('1.5.2', 'Solicitud de información de los anexos 15 y 16', NULL, 1),
('1.5.3', 'Entrega de la información de los anexos 15 y 16', NULL, 1),
('1.5.4', 'Validación de la información obrante en el archivo central (suscripción de acta)', NULL, 1),
('1.5.5', 'Entrega-recepción de la información obrante en el archivo central (suscripción de acta)', NULL, 1),
('1.5.6', 'Cierre de transferencia del acervo documentario (suscripción de acta)', NULL, 1),
('1.6', 'Transferencia de activos informáticos', NULL, 1),
('1.6.1', 'Sesión de los responsables de tecnologías de la información para la definición de plazos', NULL, 1),
('1.6.2', 'Solicitud de información de los anexos 11 a 14', NULL, 1),
('1.6.3', 'Entrega de la información de los anexos 11 a 14', NULL, 1),
('1.6.4', 'Validación de la información de los anexos 11 a 14', NULL, 1),
('1.6.5', 'Acuerdo de mecanismo de continuidad operativa en materia informática', NULL, 1),
('1.6.6', 'Cierre de transferencia de activos informáticos (suscripción de acta)', NULL, 1),
('1.7', 'Cierre de transferencia de procuraduría pública sectorial', NULL, 1),
('1.7.1', 'Elaboración del informe de cierre por parte de la secretaría técnica de cada órgano colegiado', NULL, 1),
('1.7.2', 'Aprobación del informe de cierre de cada órgano colegiado', NULL, 1),
('1.7.3', 'Cierre de transferencia (suscripción de acta)', NULL, 1);

select * from MAE_ENTIDAD
SELECT * FROM ACCIONES_PREDECEDORAS
SELECT  FROM UNIDA

UPDATE ACCIONES_PREDECEDORAS  SET Descripcion = 'Cierre de transferencia de procuraduría pública' 
WHERE ID_Acciones_Predecedora = 47
