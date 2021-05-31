-- Criação da base de dados
USE master;
CREATE DATABASE Hospital;
USE Hospital;
-- Eliminação da base de dados
USE master;
DROP DATABASE Hospital;
-- Criação das tabelas da BD Hospital
CREATE TABLE CPs(
	CP		   CHAR(8),
	Localidade VARCHAR(50) NOT NULL,
	PRIMARY KEY (CP),
	CHECK (CP LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9]')
);

CREATE TABLE NIFs(
	NIF		 INTEGER,
	Nome	 VARCHAR(50) NOT NULL,
	Apelido  VARCHAR(50) NOT NULL,
	Telefone INTEGER	 NOT NULL,
	PRIMARY KEY (NIF),
	CHECK (NIF >= 100000000 AND NIF <= 999999999),
	CHECK ((Telefone >= 200000000 AND Telefone < 300000000) OR (Telefone >= 900000000 AND Telefone <= 999999999))
	-- NIF e Telefone compostos por 9 dígitos, Telefone fixo começa por 2 e móvel por 9
);

CREATE TABLE Pessoas(
	ID		INTEGER     CHECK (ID > 0),
	NIF		INTEGER		NOT NULL UNIQUE,
	Morada  VARCHAR(50) NOT NULL,
	CP      CHAR(8)		NOT NULL,
	PRIMARY KEY (ID),
	FOREIGN KEY (NIF) REFERENCES NIFs(NIF),
	FOREIGN KEY (CP)  REFERENCES CPs(CP)
);

CREATE TABLE Pacientes(
	ID_Pac INTEGER,
	PRIMARY KEY (ID_Pac),
	FOREIGN KEY (ID_Pac) REFERENCES Pessoas(ID)
);

CREATE TABLE Alergias(
	ID_Alerg INTEGER	 CHECK (ID_Alerg > 0),
	Tipo	 VARCHAR(50) NOT NULL,
	PRIMARY KEY (ID_Alerg)
);

CREATE TABLE Paciente_Alergia(
	ID_Pac	 INTEGER,
	ID_Alerg INTEGER,
	PRIMARY KEY (ID_Pac, ID_Alerg),
	FOREIGN KEY (ID_Pac)   REFERENCES Pacientes(ID_Pac),
	FOREIGN KEY (ID_Alerg) REFERENCES Alergias(ID_Alerg)
);

CREATE TABLE Funcionarios(
	ID_Func INTEGER,
	Salario MONEY NOT NULL CHECK (Salario > 0),
	PRIMARY KEY (ID_Func),
	FOREIGN KEY (ID_Func) REFERENCES Pessoas(ID)
);

CREATE TABLE Medicos(
	ID_Med		  INTEGER,
	Especialidade VARCHAR(50) NOT NULL
	PRIMARY KEY (ID_Med),
	FOREIGN KEY (ID_Med) REFERENCES Funcionarios(ID_Func)
);

CREATE TABLE Enfermeiros(
	ID_Enf		INTEGER,
	Turno		VARCHAR(50)	NOT NULL,
	Horas_Extra INTEGER		NOT NULL CHECK (Horas_Extra >= 0),
	PRIMARY KEY (ID_Enf),
	FOREIGN KEY (ID_Enf) REFERENCES Funcionarios(ID_Func)
);

CREATE TABLE Auxiliares(
	ID_Aux		INTEGER,
	Antiguidade INTEGER		NOT NULL DEFAULT 0,
	Servico		VARCHAR(50) NOT NULL,
	CHECK (Antiguidade >= 0),
	PRIMARY KEY (ID_Aux),
	FOREIGN KEY (ID_Aux) REFERENCES Funcionarios(ID_Func)
);
 
CREATE TABLE Descricoes(
	ID_Pac	  INTEGER,
	Data_Inq  DATETIME	NOT NULL DEFAULT GETDATE(),
	Descricao VARCHAR(100), -- Duracao opcional
 	PRIMARY KEY (ID_Pac, Data_Inq),
	FOREIGN KEY (ID_Pac) REFERENCES Pacientes(ID_Pac)
);

CREATE TABLE Inquerito(
	ID_Pac   INTEGER,
	Data_Inq DATETIME,
	ID_Func	 INTEGER,
	PRIMARY KEY (ID_Pac, Data_Inq, ID_Func),
	FOREIGN KEY (ID_Func) REFERENCES Funcionarios(ID_Func),
	FOREIGN KEY (ID_Pac, Data_Inq) REFERENCES Descricoes(ID_Pac, Data_Inq),
);	

CREATE TABLE Info_Op(
	ID_Op   INTEGER,
	Data_Op DATETIME NOT NULL,
	Duracao INTEGER  DEFAULT NULL, -- Duracao opcional
	PRIMARY KEY (ID_Op)
);

CREATE TABLE Operar(
	ID_Op  INTEGER UNIQUE,
	ID_Med INTEGER,
	ID_Enf INTEGER,
	ID_Pac INTEGER,
	PRIMARY KEY (ID_Op, ID_Med, ID_Enf, ID_Pac),
	FOREIGN KEY (ID_Op)  REFERENCES Info_Op(ID_Op),
	FOREIGN KEY (ID_Med) REFERENCES Medicos(ID_Med),
	FOREIGN KEY (ID_Enf) REFERENCES Enfermeiros(ID_Enf),
	FOREIGN KEY (ID_Pac) REFERENCES Pacientes(ID_Pac)
);

CREATE TABLE Local_Op(
	ID_Op	 INTEGER	UNIQUE,
	ID_Med	 INTEGER,
	ID_Enf	 INTEGER,
	ID_Pac	 INTEGER,
	Data_Op  DATETIME,
	Local_Op VARCHAR(50) NOT NULL,
	PRIMARY KEY (ID_Op, ID_Med, ID_Enf, ID_Pac, Data_Op),
	FOREIGN KEY (ID_Op, ID_Med, ID_Enf, ID_Pac) REFERENCES Operar(ID_Op, ID_Med, ID_Enf, ID_Pac)
);

CREATE TABLE Agendar(
	ID_Op      INTEGER	UNIQUE,
	ID_Med     INTEGER,
	ID_Enf     INTEGER,
	ID_Pac     INTEGER,
	ID_Aux     INTEGER,
	Data_Op	   DATETIME,
	Data_Agend DATETIME DEFAULT GETDATE(),
	PRIMARY KEY (ID_Op, ID_Med, ID_Enf, ID_Pac, ID_Aux, Data_Op, Data_Agend),
	FOREIGN KEY (ID_Op, ID_Med, ID_Enf, ID_Pac, Data_Op) REFERENCES Local_Op(ID_Op, ID_Med, ID_Enf, ID_Pac, Data_Op)
);

CREATE TABLE Preco_Pag(
	ID_Op  INTEGER UNIQUE,
	ID_Med INTEGER,
	ID_Enf INTEGER,
	ID_Pac INTEGER,
	Preco  MONEY NOT NULL CHECK (Preco >= 0),
	PRIMARY KEY (ID_Op, ID_Med, ID_Enf, ID_Pac),
	FOREIGN KEY (ID_Op, ID_Med, ID_Enf, ID_Pac) REFERENCES Operar(ID_Op, ID_Med, ID_Enf, ID_Pac)
);

CREATE TABLE Pagar(
	ID_Op		INTEGER	UNIQUE,
	ID_Med		INTEGER,
	ID_Enf		INTEGER,
	ID_Pac		INTEGER,
	ID_Paciente INTEGER,
	ID_Aux      INTEGER, 
	Data_Pag    DATETIME DEFAULT GETDATE(),
	PRIMARY KEY (ID_Op, ID_Med, ID_Enf, ID_Pac, ID_Paciente, ID_Aux, Data_Pag),
	FOREIGN KEY (ID_Paciente) REFERENCES Pacientes(ID_Pac),
	FOREIGN KEY (ID_Aux) REFERENCES Auxiliares, 
	FOREIGN KEY (ID_Op, ID_Med, ID_Enf, ID_Pac) REFERENCES Preco_Pag(ID_Op, ID_Med, ID_Enf, ID_Pac)
);
