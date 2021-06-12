USE Hospital;

/* 1. Crie um procedimento que, dados o telefone de um paciente, o nome e o apelido de um médico e uma data, verifique se o médico está a operar 
nessa data e caso não esteja agende uma operação para o paciente. O procedimento deve ter como argumento de saída a especialidade do médico.*/

CREATE PROCEDURE VerifyDisp (@Telefone INTEGER, @Nome VARCHAR(50), @Apelido VARCHAR(50), @Data DATE, @Esp VARCHAR(50) OUTPUT)
AS
BEGIN
	DECLARE @ID_Pac INTEGER,
			@ID_Med INTEGER,
			@ID_Op INTEGER,
			@ID_Enf INTEGER,
			@ID_Aux INTEGER

	SELECT @ID_Med = ID_Med, @Esp = Especialidade
	FROM NIFs N, Pessoas P, Funcionarios, Medicos
	WHERE Nome LIKE @Nome
	AND Apelido LIKE @Apelido
	AND N.NIF = P.NIF
	AND ID = ID_Func
	AND ID_Func = ID_Med

	IF (@ID_Med IS NULL)
	BEGIN
		PRINT ('O médico não existe')
		RETURN -1
	END

	SELECT @ID_Pac = ID_Pac
	FROM NIFs N, Pessoas P, Pacientes
	WHERE Telefone = @Telefone
	AND N.NIF = P.NIF
	AND ID = ID_Pac

	IF (@ID_Pac IS NULL)
	BEGIN
		PRINT ('Não existe um paciente com o número de telefone dado')
		RETURN -1
	END

	SELECT * 
	FROM Agendar
	WHERE ID_Med = @ID_Med
	AND CONVERT(date, Data_Op) = @Data

	IF (@@ROWCOUNT != 0)
	BEGIN
		PRINT ('O médico já tem operações agendadas para essa data')
		RETURN -1
	END

	SELECT @ID_Enf = E.ID_Enf
	FROM Enfermeiros E
	LEFT JOIN (SELECT ID_Enf
				FROM Agendar
				WHERE CONVERT(date, Data_Op) = @Data
				GROUP BY ID_Enf) SQ1
	ON E.ID_Enf = SQ1.ID_Enf
	WHERE SQ1.ID_Enf IS NULL

	IF (@ID_Enf IS NULL)
	BEGIN
		PRINT ('Não há enfermeiros disponíveis')
		RETURN -1
	END

	SELECT @ID_Aux = ID_Aux
	FROM Auxiliares

	INSERT INTO Info_Op (Data_Op)
	VALUES (@Data)
	SET @ID_Op = @@IDENTITY

	INSERT INTO Operar (ID_Op, ID_Med, ID_Enf, ID_Pac)
	VALUES (@ID_Op, @ID_Med, @ID_Enf, @ID_Pac)

	INSERT INTO Local_Op (ID_Op, ID_Med, ID_Enf, ID_Pac, Data_Op, Local_Op)
	VALUES (@ID_Op, @ID_Med, @ID_Enf, @ID_Pac, @Data, '')

	INSERT INTO Agendar (ID_Op, ID_Med, ID_Enf, ID_Pac, ID_Aux, Data_Op)
	VALUES (@ID_Op, @ID_Med, @ID_Enf, @ID_Pac, @ID_Aux, @Data)

	RETURN 1
END

/* 2. Assumindo que o salário dos enfermeiros é complementado com um valor calculado em função das operações em que participam, das quais recebem 
5% do valor da operação, crie um procedimento que, para um dado mês e ano, apresente uma tabela com os ID, nome e apelidos dos enfermeiros e o total 
que cada um recebe nesse mês.*/

CREATE PROCEDURE SalarioEnfs (@Mes INTEGER, @Ano INTEGER)
AS
BEGIN
	SELECT ID_Func AS ID_Enf, Nome, Apelido, (Salario + ISNULL(Extra, 0)) AS Total
	FROM Funcionarios, Pessoas P, NIFs N,
		 (SELECT E.ID_Enf, Extra
		  FROM Enfermeiros E
		  LEFT JOIN (SELECT O.ID_Enf, SUM(Preco * 0.05) Extra
		  			 FROM Info_Op I, Operar O, Preco_Pag P
		  			 WHERE I.ID_Op = O.ID_Op
		  			 AND O.ID_Op = P.ID_Op 
		  			 AND O.ID_Med = P.ID_Med 
		  			 AND O.ID_Enf = P.ID_Enf 
		  			 AND O.ID_Pac = P.ID_Pac
		     		 AND MONTH(Data_Op) = @Mes 
		  			 AND YEAR(Data_Op) = @Ano
		  			 GROUP BY O.ID_Enf) SQ1
		  ON E.ID_Enf = SQ1.ID_Enf) SQ2
	WHERE SQ2.ID_Enf = ID_Func
	AND ID_Func = ID
	AND P.NIF = N.NIF
END

-- 3. Crie um trigger que apenas deixe inserir registos no relacionamento inquérito se o paciente tiver alergias.

CREATE TRIGGER InserirInq
ON Descricoes -- A tabela Inqueritos referencia a tabela Descricoes
INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO Descricoes (ID_Pac, Data_Inq, Descricao)
	SELECT ID_Pac, Data_Inq, Descricao
	FROM inserted, 
		(SELECT PA.ID_Pac ID
		 FROM Paciente_Alergia PA, Pacientes P, inserted I
		 WHERE I.ID_Pac = P.ID_Pac
		 AND P.ID_Pac = PA.ID_Pac
		 GROUP BY PA.ID_Pac) SQ1
	WHERE ID_Pac = ID
END