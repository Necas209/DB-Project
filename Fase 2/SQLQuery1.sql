USE Hospital;
 
 -- 2.1

 SELECT N1.Nome as Paciente, Data_Inq, N2.Nome as Funcionario
 FROM NIFs as N1, NIFs as N2, Pessoas as P1, Pessoas as P2, Pacientes, Funcionarios, Inquerito
 WHERE Data_Inq = (SELECT MAX(Data_Inq) FROM Inquerito)
 AND Inquerito.ID_Pac = Pacientes.ID_Pac
 AND Pacientes.ID_Pac = P1.ID
 AND P1.NIF = N1.NIF
 AND Inquerito.ID_Func = Funcionarios.ID_Func
 AND Funcionarios.ID_Func = P2.ID
 AND P2.NIF = N2.NIF;

-- 2.2

SELECT Especialidade, COUNT(ID_Med) as NoMedicos
FROM Medicos
GROUP BY Especialidade;

-- 2.3

SELECT NIFs.Nome, SQ1.N_Operacoes as N_Operacoes
FROM (SELECT TOP 2 ID_Enf, COUNT(Operar.ID_Op) as N_Operacoes
        FROM Operar
        GROUP BY ID_Enf
        ORDER BY N_Operacoes DESC) SQ1,
        Enfermeiros, Funcionarios, Pessoas, NIFs
WHERE NIFs.NIF = Pessoas.NIF
AND Pessoas.ID = Funcionarios.ID_Func
AND Funcionarios.ID_Func = Enfermeiros.ID_Enf
AND Enfermeiros.ID_Enf = SQ1.ID_Enf;

-- 2.4

SELECT NIFs.Nome as Paciente, SQ1.N_Operacoes as N_Operacoes
FROM (SELECT Operar.ID_Pac, COUNT(Operar.ID_Op) as N_Operacoes
        FROM Operar, Local_Op
        WHERE Operar.ID_Op = Local_Op.ID_Op
        AND DATEDIFF(DAY, GETDATE(), Local_Op.Data_Op) <= 30
        GROUP BY Operar.ID_Pac) SQ1, 
        Pacientes, Pessoas, NIFs
WHERE SQ1.ID_Pac = Pacientes.ID_Pac
AND Pacientes.ID_Pac = Pessoas.ID
AND Pessoas.NIF = NIFs.NIF;

-- 2.5

SELECT NIFs.Nome as Enfermeiros
FROM (SELECT ID_Enf as ID
        FROM Enfermeiros
        INNER JOIN Auxiliares
        ON ID_Enf = ID_Aux) SQ1, Funcionarios, Pessoas, NIFs
WHERE SQ1.ID = Funcionarios.ID_Func
AND Funcionarios.ID_Func = Pessoas.ID
AND Pessoas.NIF = NIFs.NIF;

-- 2.6

SELECT NIFs.Nome as Nome, NIFs.Apelido as Apelido, Valor_Gasto
FROM (SELECT ID_Paciente as ID, SUM(Preco) as Valor_Gasto
        FROM Pagar, Preco_Pag
        WHERE Pagar.ID_Op = Preco_Pag.ID_Op
        AND Pagar.ID_Med = Preco_Pag.ID_Med
        AND Pagar.ID_Enf = Preco_Pag.ID_Enf
        AND Pagar.ID_Pac = Preco_Pag.ID_Pac
        GROUP BY ID_Paciente) SQ1,
        Pacientes, Pessoas, NIFs
WHERE SQ1.ID = Pacientes.ID_Pac
AND Pacientes.ID_Pac = Pessoas.ID
AND Pessoas.NIF = NIFs.NIF;

-- 2.7

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

 INSERT INTO NIFs(NIF, Nome, Apelido, Telefone)	
 VALUES
 (100000001, 'Joaquim', 'Macedo', 937466897),
 (506704339, 'Maria', 'Filipa', 917342571),
 (123456789, 'Joana', 'Marques', 967045322);

 INSERT INTO CPs(CP, Localidade)
 VALUES
 (2840-167, 'Seixal'),
 (4820-392, 'Fafe'),
 (5000-081, 'Vila Real');

 INSERT INTO Pessoas(ID, NIF, Morada, CP)
 VALUES
 (),
 (),
 ();

  INSERT INTO Pacientes(ID_Pac)
 VALUES
 (),
 (),
 ();

  INSERT INTO Alergias(ID_Alerg, Tipo)
 VALUES
 (),
 (),
 ();

  INSERT INTO Paciente_Alergia(ID_Pac, ID_Alerg)
 VALUES
 (),
 (),
 ();

  INSERT INTO Funcionarios(ID_Func, Salario)
 VALUES
 (),
 (),
 ();

  INSERT INTO Medicos(ID_Med, Especialidade)
 VALUES
 (),
 (),
 ();

  INSERT INTO Enfermeiros(ID_Enf, Turno, Horas_Extra)
 (),
 (),
 ();

 INSERT INTO Auxiliares(ID_Aux,	Antiguidade, Servico)
 VALUES
 (),
 (),
 ();

  INSERT INTO Descricoes(ID_Pac, Data_Inq, Descricao)
 VALUES
 (),
 (),
 ();

  INSERT INTO Inquerito(ID_Pac,	Data_Inq, ID_Func)
 VALUES
 (),
 (),
 ();

  INSERT INTO Info_Op(ID_Op, Data_Op, Duracao)
 VALUES
 (),
 (),
 ();

 INSERT INTO Operar(ID_Op, ID_Med, ID_Enf, ID_Pac)
 VALUES
 (),
 (),
 ();

  INSERT INTO Local_Op(ID_Op, ID_Med, ID_Enf, ID_Pac, Data_Op, Local_Op)
 VALUES
 (),
 (),
 ();

  INSERT INTO Agendar(ID_Op, ID_Med, ID_Enf, ID_Pac, ID_Aux, Data_Op, Data_Agend)
 VALUES
 (),
 (),
 ();

  INSERT INTO Preco_Pag(ID_Op, ID_Med, ID_Enf, ID_Pac, Preco)
 VALUES
 (),
 (),
 ();

  INSERT INTO Pagar(ID_Op, ID_Med, ID_Enf, ID_Pac, ID_Paciente, ID_Aux, Data_Pag)
 VALUES
 (),
 (),
 ();