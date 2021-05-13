USE Hospital;
 
 SELECT * FROM Agendar;
 SELECT * FROM Alergias;
 SELECT * FROM Auxiliares;
 SELECT * FROM CPs;
 SELECT * FROM Descricoes;
 SELECT * FROM Enfermeiros;
 SELECT * FROM Funcionarios;
 SELECT * FROM Info_Op;
 SELECT * FROM Inquerito;
 SELECT * FROM Local_Op;
 SELECT * FROM Medicos;
 SELECT * FROM NIFs;
 SELECT * FROM Operar;
 SELECT * FROM Paciente_Alergia;
 SELECT * FROM Pacientes;
 SELECT * FROM Pagar;
 SELECT * FROM Pessoas;
 SELECT * FROM Preco_Pag;

 -- 2.1 Qual o �ltimo inqu�rito realizado? [Paciente (Nome), Data, Funcion�rio(Nome)]

 SELECT CONCAT(N1.Nome, ' ', N1.Apelido) as Paciente, Data_Inq, CONCAT(N2.Nome, ' ', N2.Apelido) as Funcionario
 FROM NIFs N1, NIFs N2, Pessoas P1, Pessoas P2, Pacientes, Funcionarios, Inquerito
 WHERE Data_Inq = (SELECT MAX(Data_Inq) FROM Inquerito)
 AND Inquerito.ID_Pac = Pacientes.ID_Pac
 AND Pacientes.ID_Pac = P1.ID
 AND P1.NIF = N1.NIF
 AND Inquerito.ID_Func = Funcionarios.ID_Func
 AND Funcionarios.ID_Func = P2.ID
 AND P2.NIF = N2.NIF;

-- 2.2. Quantos m�dicos existem de cada especialidade? [Especialidade, N_M�dicos]

SELECT Especialidade, COUNT(ID_Med) as NoMedicos
FROM Medicos
GROUP BY Especialidade;

-- 2.3. Quais os dois enfermeiros que mais opera��es assistiram? [Enfermeiro(Nome), N_Opera��es]

SELECT NIFs.Nome as Enfermeiro, SQ1.N_Operacoes as N_Operacoes
FROM (SELECT TOP 2 ID_Enf, COUNT(Operar.ID_Op) as N_Operacoes
        FROM Operar
        GROUP BY ID_Enf
        ORDER BY N_Operacoes DESC) SQ1,
        Enfermeiros, Funcionarios, Pessoas, NIFs
WHERE NIFs.NIF = Pessoas.NIF
AND Pessoas.ID = Funcionarios.ID_Func
AND Funcionarios.ID_Func = Enfermeiros.ID_Enf
AND Enfermeiros.ID_Enf = SQ1.ID_Enf;

-- 2.4. Quais os pacientes que realizaram mais de 2 opera��es nos �ltimos 30 dias? Ordene-os alfabeticamente. [Pacientes (Nome), N_Opera��es]

SELECT NIFs.Nome as Paciente, SQ1.N_Operacoes as N_Operacoes
FROM (SELECT Local_Op.ID_Pac, COUNT(Operar.ID_Op) as N_Operacoes
        FROM Operar, Local_Op
        WHERE Operar.ID_Op = Local_Op.ID_Op
		AND Operar.ID_Med = Local_Op.ID_Med
		AND Operar.ID_Enf = Local_Op.ID_Enf
		AND Operar.ID_Pac = Local_Op.ID_Pac
        AND DATEDIFF(DAY, GETDATE(), Local_Op.Data_Op) <= 30
        GROUP BY Local_Op.ID_Pac) SQ1, 
        Pacientes, Pessoas, NIFs
WHERE SQ1.N_Operacoes > 2
AND SQ1.ID_Pac = Pacientes.ID_Pac
AND Pacientes.ID_Pac = Pessoas.ID
AND Pessoas.NIF = NIFs.NIF
ORDER BY Paciente;

-- 2.5. Quais os enfermeiros que tamb�m fazem de auxiliares? [Enfermeiros (nome)]

SELECT NIFs.Nome as Enfermeiros
FROM (SELECT ID_Enf as ID
        FROM Enfermeiros
        INNER JOIN Auxiliares
        ON ID_Enf = ID_Aux) SQ1, Funcionarios, Pessoas, NIFs
WHERE SQ1.ID = Funcionarios.ID_Func
AND Funcionarios.ID_Func = Pessoas.ID
AND Pessoas.NIF = NIFs.NIF;

-- 2.6. Quais os pacientes que pagaram mais de 500� em opera��es? [Pacientes(nome e apelido), Valor_Gasto]

SELECT NIFs.Nome as Nome, NIFs.Apelido as Apelido, Valor_Gasto
FROM (SELECT ID_Paciente as ID, SUM(Preco) as Valor_Gasto
        FROM Pagar, Preco_Pag
        WHERE Pagar.ID_Op = Preco_Pag.ID_Op
        AND Pagar.ID_Med = Preco_Pag.ID_Med
        AND Pagar.ID_Enf = Preco_Pag.ID_Enf
        AND Pagar.ID_Pac = Preco_Pag.ID_Pac
        GROUP BY ID_Paciente) SQ1,
        Pacientes, Pessoas, NIFs
WHERE SQ1.Valor_Gasto > 500
AND SQ1.ID = Pacientes.ID_Pac
AND Pacientes.ID_Pac = Pessoas.ID
AND Pessoas.NIF = NIFs.NIF;

-- 2.7. Qual o total de inqu�ritos realizado por cada funcion�rio no ano de 2020?[Funcion�rios (Nome), Total_Inqu�ritos]

SELECT NIFs.Nome as Funcionario, NoInqs
FROM (SELECT ID_Func, COUNT(*) as NoInqs
        FROM Inquerito, Descricoes
        WHERE Inquerito.ID_Pac = Descricoes.ID_Pac
        AND Inquerito.Data_Inq = Descricoes.Data_Inq
        AND YEAR(Descricoes.Data_Inq) = 2020 
        GROUP BY ID_Func) SQ1,
        Funcionarios, Pessoas, NIFs
WHERE SQ1.ID_Func = Funcionarios.ID_Func
AND Funcionarios.ID_Func = Pessoas.ID
AND Pessoas.NIF = NIFs.NIF;

 -- 1.

 INSERT INTO NIFs(NIF, Nome, Apelido, Telefone)	VALUES
 (100000001, 'Joaquim', 'Macedo', 976711074),
 (100000002, 'Maria', 'Ventura', 947089902),
 (100000003, 'Joana', 'Marques', 986058286),
 (100000004, 'Diogo', 'Medeiros', 281876574),
 (100000005, 'Rui', 'Pinto', 234686761),
 (100000006, 'Ricardo', 'Araujo', 260267139),
 (100000007, 'Judite', 'Pereira', 937466897),
 (100000008, 'Elizabete', 'Rodrigues', 917342571),
 (100000009, 'Joaquim', 'Fernandes', 967045322),
 (100000010, 'Filipa', 'Costa', 966841841),
 (100000011, 'Jo�o', 'Pedro', 937004002); 

 INSERT INTO CPs(CP, Localidade) VALUES
 ('2840-167', 'Seixal'),
 ('4820-392', 'Fafe'),
 ('5000-081', 'Vila Real'),
 ('4000-011', 'Porto');

 INSERT INTO Pessoas(ID, NIF, Morada, CP) VALUES
 (1001, 100000001, 'Rua Manuel 2', '5000-081'),
 (1002, 100000002, 'Rua Azevedo Pinto 23', '4820-392'),
 (1003, 100000003, 'Rua Capitao Marques 74 Andar 1', '2840-167'),
 (1004, 100000004, 'Rua Manuel 8', '5000-081'),
 (1005, 100000005, 'Rua Azevedo Pinto 9', '4820-392'),
 (1006, 100000006, 'Rua Capitao Marques 74 Andar 2', '2840-167'),
 (1007, 100000007, 'Rua Manuel 5', '5000-081'),
 (1008, 100000008, 'Rua Azevedo Pinto 49', '4820-392'),
 (1009, 100000009, 'Rua Capitao Marques 74 R/C', '2840-167'),
 (1010, 100000010, 'Travessa do Agro Bom', '4820-392'),
 (1011, 100000011, 'Rua Fernandes Tom�s', '4000-011');

  INSERT INTO Pacientes(ID_Pac) VALUES
 (1001),
 (1002),
 (1003),
 (1004),
 (1005);

  INSERT INTO Alergias(ID_Alerg, Tipo) VALUES
 (1, 'Alergia aos p�lens'),
 (2, 'Alergia aos �caros'),
 (3, 'Alergia alimentar'),
 (4, 'Alergia a medicamento');

  INSERT INTO Paciente_Alergia(ID_Pac, ID_Alerg) VALUES
 (1001, 3),
 (1002, 4),
 (1003, 2);

  INSERT INTO Funcionarios(ID_Func, Salario) VALUES
 (1004, 1000),
 (1005, 900),
 (1006, 650),
 (1007, 1200),
 (1008, 600),
 (1009, 800),
 (1010, 650),
 (1011, 700);

  INSERT INTO Medicos(ID_Med, Especialidade) VALUES
 (1004, 'Cardiologia'),
 (1009, 'Anestesiologia'),
 (1007, 'Anestesiologia'),
 (1005, 'Neurologia');

  INSERT INTO Enfermeiros(ID_Enf, Turno, Horas_Extra) VALUES
 (1006, 'Manh�', 0),
 (1008, 'Tarde', 10),
 (1010, 'Noite', 3);

 INSERT INTO Auxiliares(ID_Aux,	Antiguidade, Servico) VALUES
 (1006, 5, 'Ortopedia'),
 (1008, 10, 'Geral'),
 (1011, 25, 'Urg�ncias');

  INSERT INTO Descricoes(ID_Pac, Data_Inq, Descricao) VALUES
 (1001, '2020-01-21', NULL),
 (1002, '2021-03-05', 'O paciente indicou alergia a paracetamol'),
 (1003, '2020-12-21', 'O paciente indicou alergia a �caros');

  INSERT INTO Inquerito(ID_Pac,	Data_Inq, ID_Func) VALUES
 (1001, '2020-01-21', 1006),
 (1002, '2021-03-05', 1008),
 (1003, '2020-12-21', 1006);

  INSERT INTO Info_Op(Data_Op, Duracao) VALUES
 ('2021-04-23', 5),
 ('2021-04-15', 14),
 ('2021-05-29', NULL),
 ('2020-09-11', 9);

 INSERT INTO Operar(ID_Op, ID_Med, ID_Enf, ID_Pac) VALUES
 (1, 1004, 1006, 1002),
 (2, 1005, 1006, 1004),
 (3, 1004, 1008, 1002),
 (4, 1005, 1010, 1002);

 INSERT INTO Local_Op(ID_Op, ID_Med, ID_Enf, ID_Pac, Data_Op, Local_Op) VALUES
 (1, 1004, 1006, 1002, '2021-04-23', 'Bloco B'),
 (2, 1005, 1006, 1004, '2021-04-15', 'Bloco A'),
 (3, 1004, 1008, 1002, '2021-05-29', 'Bloco D'),
 (4, 1005, 1010, 1002, '2021-05-01', 'Bloco C');

  INSERT INTO Agendar(ID_Op, ID_Med, ID_Enf, ID_Pac, Data_Op, ID_Aux, Data_Agend) VALUES
 (1, 1004, 1006, 1002, '2021-04-23', 1006, '2020-12-21'),
 (2, 1005, 1006, 1004, '2021-04-15', 1008, '2020-01-21'),
 (3, 1004, 1008, 1002, '2021-05-29', 1011, '2021-03-05'),
 (4, 1005, 1010, 1002, '2021-05-01', 1006, '2021-04-24');

  INSERT INTO Preco_Pag(ID_Op, ID_Med, ID_Enf, ID_Pac, Preco) VALUES
 (1, 1004, 1006, 1002, 400),
 (2, 1005, 1006, 1004, 1000),
 (4, 1005, 1010, 1002, 800);

  INSERT INTO Pagar(ID_Op, ID_Med, ID_Enf, ID_Pac, ID_Paciente, ID_Aux, Data_Pag)
 VALUES
 (1, 1004, 1006, 1002, 1002, 1008, '2021-04-30'),
 (2, 1005, 1006, 1004, 1004, 1008, '2021-04-20'),
 (4, 1005, 1010, 1002, 1002, 1011, '2021-05-01');