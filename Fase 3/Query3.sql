/* 1. Crie um procedimento que, dados o telefone de um paciente, o nome e o apelido de um m�dico e uma data, verifique se o m�dico est� a operar 
nessa data e caso n�o esteja agende uma opera��o para o paciente. O procedimento deve ter como argumento de sa�da a especialidade do m�dico.*/

CREATE PROCEDURE VerifyDisp (@Telefone INTEGER, @Nome VARCHAR, @Apelido VARCHAR, @Data DATETIME)
AS
BEGIN
	DECLARE @ID_Pac INTEGER,
			@Esp VARCHAR(50),
			@ID_Med INTEGER,
			@ID_Op INTEGER

	SELECT @ID_Pac = ID_Pac
	FROM NIFs N, Pessoas P, Pacientes
	WHERE Telefone = @Telefone
	AND N.NIF = P.NIF
	AND ID = ID_Pac

	IF (@ID_Pac IS NULL)
	BEGIN
		PRINT ('N�o existe um paciente com o numero de telefone dado')
		RETURN NULL
	END

	SELECT @ID_Med = ID_Med, @Esp = Especialidade
	FROM NIFs N, Pessoas P, Funcionarios, Medicos
	WHERE Nome LIKE @Nome
	AND Apelido LIKE @Apelido
	AND N.NIF = P.NIF
	AND ID = ID_Func
	AND ID_Func = ID_Med

	IF (@ID_Med IS NULL)
	BEGIN
		PRINT ('O m�dico n�o existe')
		RETURN NULL
	END

	SELECT ID_Med, Data_Op
	FROM Local_Op
	WHERE ID_Med = @ID_Med
	AND CONVERT(date, Data_Op) = CONVERT(date, @Data)
	AND ABS(DATEDIFF(HOUR, Data_Op, @Data)) < 12

	IF (@@ROWCOUNT != 0)
	BEGIN
		PRINT ('O m�dico j� est� operar nessa data')
		RETURN NULL
	END

	INSERT INTO Info_Op (Data_Op)
	VALUES (@Data)
	SELECT @ID_Op = @@IDENTITY

	INSERT INTO Operar (ID_Op, ID_Med, ID_Enf, ID_Pac)
	VALUES (@ID_Op, @ID_Med, 1008, @ID_Pac)

	INSERT INTO Local_Op (ID_Op, ID_Med, ID_Enf, ID_Pac, Data_Op, Local_Op)
	VALUES (@ID_Op, @ID_Med, 1008, @ID_Pac, @Data, '')

	INSERT INTO Agendar (ID_Op, ID_Med, ID_Enf, ID_Pac, ID_Aux, Data_Op)
	VALUES (@ID_Op, @ID_Med, 1008, @ID_Pac, 1008, @Data)

	RETURN @Esp
END

/* 2. Assumindo que o sal�rio dos enfermeiros � complementado com um valor calculado em fun��o das opera��es em que participam, das quais recebem 
5% do valor da opera��o, crie um procedimento que, para um dado m�s e ano, apresente uma tabela com os ID, nome e apelidos dos enfermeiros e o total 
que cada um recebe nesse m�s.*/

CREATE PROCEDURE SalarioEnfs (@Mes INTEGER, @Ano INTEGER)
AS
BEGIN
	SELECT ID_Func, Nome, Apelido, (Salario + ISNULL(Extra, 0)) Total
	FROM Funcionarios, Pessoas P, NIFs N,
	(SELECT E.ID_Enf, Extra
	FROM Enfermeiros E
		LEFT JOIN
		(SELECT O.ID_Enf, SUM(P.Preco * 0.05) Extra
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

-- 3. Crie um trigger que apenas deixe inserir registos no relacionamento inqu�rito se o paciente tiver alergias.

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