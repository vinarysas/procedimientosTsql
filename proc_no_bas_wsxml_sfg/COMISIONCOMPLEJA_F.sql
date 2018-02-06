USE SFGPRODU;
--  DDL for Function COMISIONCOMPLEJA_F
--------------------------------------------------------

  IF OBJECT_ID('WSXML_SFG.COMISIONCOMPLEJA_F', 'FN') IS NOT NULL
    DROP FUNCTION WSXML_SFG.COMISIONCOMPLEJA_F;
GO

  CREATE FUNCTION WSXML_SFG.COMISIONCOMPLEJA_F (@p_CODTIPOCOMISION NUMERIC(22,0), @p_COUNTNIVELES NUMERIC(22,0), @p_LEVELDEFINITION NVARCHAR(2000)) RETURNS NUMERIC(22,0) AS
 BEGIN
  DECLARE @commissionid NUMERIC(22,0);
  DECLARE @coutdetailid NUMERIC(22,0);
  DECLARE @modifieruser NUMERIC(22,0) = 1;
  DECLARE @readablecoms WSXML_SFG.COMISIONNIVELLIST;
  DECLARE @msg NVARCHAR(2000);
 
  -- Split into readable data
    --SET @readablecoms = COMISIONNIVELLIST();

    DECLARE tlevel CURSOR FOR 
	SELECT value 
	FROM STRING_SPLIT(@p_LEVELDEFINITION, '|')
	
	OPEN tlevel;
	
	DECLARE @l_tlevel_value VARCHAR(MAX)
	
	
	FETCH NEXT FROM tlevel INTO @l_tlevel_value
	
	WHILE (@@FETCH_STATUS = 0)
        BEGIN
		
			--DECLARE @leveldata   STRINGARRAY;
			DECLARE  @leveldata TABLE (ID INT, VALOR VARCHAR(2000));
			DECLARE @newcomlevel COMISIONNIVEL;
			DECLARE @thisrangoin FLOAT;
			DECLARE @thisrangofn FLOAT;
			DECLARE @thisvalorpr FLOAT;
			DECLARE @thisvalortr FLOAT;
			
			DECLARE @ID INT;
			
		/* -- Validar
			INSERT @leveldata
			SELECT @ID = ROW_NUMBER() OVER(ORDER BY value asc), value
			FROM STRING_SPLIT(@l_tlevel_value, '-')
			
		*/	
			IF @@ROWCOUNT <> 4  
				RETURN CAST('-20054 Invalid number of parameters for level' AS INT)
	
			
			
			-- Compose level
			BEGIN
				  SET @thisrangoin = CAST((SELECT VALOR FROM @leveldata WHERE ID = 1) AS INT);
				  SET @thisrangofn = CASE WHEN (SELECT VALOR FROM @leveldata WHERE ID = 2) = 'NULL' THEN NULL ELSE CAST((SELECT VALOR FROM @leveldata WHERE ID = 1) AS INT) END;
				  SET @thisvalorpr = CAST((SELECT VALOR FROM @leveldata WHERE ID = 3) AS INT);
				  SET @thisvalortr = CAST((SELECT VALOR FROM @leveldata WHERE ID = 4) AS INT);
				  
				  INSERT INTO @newcomlevel VALUES (@ID, @thisrangoin, @thisrangofn, @thisvalorpr, @thisvalortr);
				  --readablecoms.Extend(1);
				  --readablecoms(readablecoms.Count) := @newcomlevel;
				  --INSERT INTO @readablecoms VALUES (@newcomlevel) -- Validar
				
				IF @@ROWCOUNT = 0 BEGIN
					SET @msg = '-20054 Cannot read level data for definition (' + ISNULL(@p_LEVELDEFINITION, '') + '): ' + isnull(ERROR_MESSAGE(), '');
					RETURN CAST(@msg AS INT)--RAISERROR(@msg, 16, 1);
				END
				  
			END;
		
		FETCH NEXT FROM tlevel INTO @l_tlevel_value
		END;

		
	
	CLOSE tlevel
	DEALLOCATE tlevel 
	

	IF((SELECT COUNT(*) FROM @readablecoms) <> @p_COUNTNIVELES) BEGIN
		--RAISERROR('-20054 Invalid number of levels for complex commission', 16, 1);
		RETURN CAST('-20054 Invalid number of levels for complex commission' AS INT);
	
	END
	
	
    -- Insert new commission. Look up for existant
    BEGIN
      -- Read each considerable commission
        DECLARE @foundid NUMERIC(22,0) = 0;
		
		BEGIN
			DECLARE existant CURSOR FOR 
				SELECT ID_RANGOCOMISION, COUNT(ID_RANGOCOMISIONDETALLE) AS LEVELCOUNT
				FROM WSXML_SFG.RANGOCOMISION
					INNER JOIN WSXML_SFG.RANGOCOMISIONDETALLE ON (CODRANGOCOMISION = ID_RANGOCOMISION)
				WHERE CODTIPOCOMISION = @p_CODTIPOCOMISION
				GROUP BY ID_RANGOCOMISION
				HAVING COUNT(ID_RANGOCOMISIONDETALLE) = @p_COUNTNIVELES; 
			OPEN existant;
			
			DECLARE @ID_RANGOCOMISION NUMERIC(22,0), @LEVELCOUNT INT
			
			
			FETCH NEXT FROM existant INTO @ID_RANGOCOMISION,@LEVELCOUNT
			WHILE @@FETCH_STATUS=0
				BEGIN
					DECLARE @matches NUMERIC(22,0) = 1;
					DECLARE @marker  NUMERIC(22,0) = 1;
					
					BEGIN
					
						DECLARE exdetail CURSOR FOR SELECT ID_RANGOCOMISIONDETALLE, RANGOINICIAL, RANGOFINAL, VALORPORCENTUAL, VALORTRANSACCIONAL
                             FROM WSXML_SFG.RANGOCOMISIONDETALLE
                             WHERE CODRANGOCOMISION = @ID_RANGOCOMISION
                             ORDER BY RANGOINICIAL; 
							 
						OPEN exdetail;
						
						DECLARE @ID_RANGOCOMISIONDETALLE FLOAT, @RANGOINICIAL FLOAT, @RANGOFINAL FLOAT, @VALORPORCENTUAL FLOAT, @VALORTRANSACCIONAL FLOAT
						

						FETCH NEXT FROM exdetail INTO @ID_RANGOCOMISIONDETALLE, @RANGOINICIAL, @RANGOFINAL, @VALORPORCENTUAL, @VALORTRANSACCIONAL
						WHILE @@FETCH_STATUS=0
						
						BEGIN
							
							IF @RANGOINICIAL <> (SELECT RANGOINICIAL FROM @newcomlevel WHERE ID = @marker ) OR
							 @RANGOFINAL <> (SELECT RANGOFINAL FROM @newcomlevel WHERE ID = @marker ) OR
							 @VALORPORCENTUAL <> (SELECT VALORPORCENTUAL FROM @newcomlevel WHERE ID = @marker )  OR
							 @VALORTRANSACCIONAL <> (SELECT VALORTRANSACCIONAL FROM @newcomlevel WHERE ID = @marker )  BEGIN
								SET @matches = 0;
								RETURN '';
							END
							
							ELSE BEGIN
								SET @marker = @marker + 1;
							END
								
							FETCH NEXT FROM exdetail INTO @ID_RANGOCOMISIONDETALLE, @RANGOINICIAL, @RANGOFINAL, @VALORPORCENTUAL, @VALORTRANSACCIONAL
						END
						CLOSE exdetail;
						DEALLOCATE exdetail;
					END 
					
					IF @matches = 1 BEGIN
					  SET @commissionid = @ID_RANGOCOMISION
					  SET @foundid = 1;
					  RETURN '';
					END 
					
				
			FETCH NEXT FROM existant INTO @ID_RANGOCOMISION,@LEVELCOUNT
			END
			
			CLOSE existant;
			DEALLOCATE existant;
		END;
	END
RETURN @commissionid;
END 

