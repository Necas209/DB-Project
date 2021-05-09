use Hospital;
 
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

 INSERT INTO Pessoas(ID, NIF, Morada, Cp)
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