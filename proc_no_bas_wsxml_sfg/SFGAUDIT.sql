USE SFGPRODU;
--  DDL for Package Body SFGAUDIT
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGAUDIT */ 
  IF OBJECT_ID('WSXML_SFG.SFGAUDIT_AUDITMAESTRO_INS', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAUDIT_AUDITMAESTRO_INS;
GO

CREATE     PROCEDURE WSXML_SFG.SFGAUDIT_AUDITMAESTRO_INS(
							@p_TABLA     VARCHAR(4000),
                            @p_KEY       NUMERIC(22,0),
                            @p_USUARIO   NUMERIC(22,0),
                            @p_secuencia NUMERIC(38,0) OUT
						) as

  begin
  set nocount on;
    /* TODO implementation required */

    INSERT INTO WSXML_SFG.AUDITMAESTRO
      (--ID_AUDITMAESTRO,
       TIPO_MODIFICACION,
       NOMBRE_TABLA,
       LLAVE,
       USUARIO,
       TERMINAL,
       SESSIONID)
    SELECT
     --@p_secuencia,
       'I',
       @p_TABLA,
       @p_KEY,
       CASE WHEN @p_USUARIO IS NULL THEN 1 ELSE @p_USUARIO END,
       SYSTEM_USER,
       @@SPID
	
	SET @p_secuencia = SCOPE_IDENTITY();

  end
GO


  IF OBJECT_ID('WSXML_SFG.SFGAUDIT_AUDITMAESTRO_UPD', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAUDIT_AUDITMAESTRO_UPD;
GO

CREATE     PROCEDURE WSXML_SFG.SFGAUDIT_AUDITMAESTRO_UPD(@p_TABLA     VARCHAR(4000),
                             @p_KEY       NUMERIC(22,0),
                             @p_USUARIO   NUMERIC(22,0),
                             @p_secuencia NUMERIC(38,0) OUT
							 ) as

  begin
  set nocount on;
    /* TODO implementation required */

    INSERT INTO WSXML_SFG.AUDITMAESTRO
      (--ID_AUDITMAESTRO,
       TIPO_MODIFICACION,
       NOMBRE_TABLA,
       LLAVE,
       USUARIO,
       TERMINAL,
       SESSIONID)
    SELECT
      --@p_secuencia,
       'U',
       @p_TABLA,
       @p_KEY,
       @p_USUARIO,
       SYSTEM_USER,
       @@SPID

	SET @p_secuencia = SCOPE_IDENTITY();
  end
  GO


  IF OBJECT_ID('WSXML_SFG.SFGAUDIT_AUDITMAESTRO_DEL', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAUDIT_AUDITMAESTRO_DEL;
GO

CREATE     PROCEDURE WSXML_SFG.SFGAUDIT_AUDITMAESTRO_DEL(@p_TABLA     VARCHAR(4000),
                             @p_KEY       NUMERIC(22,0),
                             @p_USUARIO   NUMERIC(22,0),
                             @p_secuencia NUMERIC(38,0) OUT
							 ) as

  begin
  set nocount on;
    /* TODO implementation required */

    INSERT INTO WSXML_SFG.AUDITMAESTRO
      (--ID_AUDITMAESTRO,
       TIPO_MODIFICACION,
       NOMBRE_TABLA,
       LLAVE,
       USUARIO,
       TERMINAL,
       SESSIONID)
    SELECT
      --@p_secuencia,
       'D',
       @p_TABLA,
       @p_KEY,
       @p_USUARIO,
       SYSTEM_USER,
       @@SPID
	   
	SET @p_secuencia = SCOPE_IDENTITY();
  end
  GO

  IF OBJECT_ID('WSXML_SFG.SFGAUDIT_AUDITDETALLE_UPD', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAUDIT_AUDITDETALLE_UPD;
GO

CREATE     PROCEDURE WSXML_SFG.SFGAUDIT_AUDITDETALLE_UPD(
							 @p_CAMPO     varchar(4000),
							 @p_NEWVALUE  VARCHAR(4000),
                             @p_OLDVALUE  varchar(4000),
                             @p_secuencia NUMERIC(38,0)
						) as

  begin
  set nocount on;
    If @p_OLDVALUE <> @p_NEWVALUE Begin
		INSERT INTO WSXML_SFG.AUDITDETALLE 
		(
		NOMBRE_CAMPO,
		VALOR_NUEVO,
		VALOR_ANTERIOR,
		CODAUDITMAESTRO
		)
		VALUES
		(
		@p_CAMPO,
		@p_NEWVALUE,
		@p_OLDVALUE,
		@p_secuencia
		);  
			
		
	End 

  end
GO

  IF OBJECT_ID('WSXML_SFG.SFGAUDIT_AUDITDETALLE_DEL', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAUDIT_AUDITDETALLE_DEL;
GO

CREATE     PROCEDURE WSXML_sfg.SFGAUDIT_AUDITDETALLE_DEL(
							@p_CAMPO     varchar(4000),
                            @p_OLDVALUE  varchar(4000),
                            @p_secuencia NUMERIC(38,0)
					) as
  begin
  set nocount on;
    insert into WSXML_SFG.AUDITDETALLE
	(
	NOMBRE_CAMPO,
	VALOR_NUEVO,
	VALOR_ANTERIOR,
	CODAUDITMAESTRO
	)
    VALUES
    (
    @p_CAMPO,
    NULL,
    @p_OLDVALUE,
    @p_secuencia
	);

  end
  GO



