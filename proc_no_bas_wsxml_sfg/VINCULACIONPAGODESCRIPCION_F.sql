USE SFGPRODU;
--  DDL for Function VINCULACIONPAGODESCRIPCION_F
--------------------------------------------------------

  IF OBJECT_ID('WSXML_SFG.VINCULACIONPAGODESCRIPCION_F', 'FN') IS NOT NULL
    DROP FUNCTION WSXML_SFG.VINCULACIONPAGODESCRIPCION_F;
GO


  CREATE FUNCTION WSXML_SFG.VINCULACIONPAGODESCRIPCION_F (@p_CODPUNTODEVENTA NUMERIC(22,0), @p_CODTIPOVINCULACIONPAGO NUMERIC(22,0)) 
  RETURNS NVARCHAR(2000) AS
 BEGIN
  DECLARE @result NVARCHAR(2000) = '';
  
		DECLARE @l_PUNTODEVENTA TINYINT, @l_AGRUPACNXNIT INT, @l_AGRUPACNXCAD INT
		EXEC WSXML_SFG.SFGTIPOVINCULACIONPAGO_CONSTANT @l_PUNTODEVENTA OUTPUT, @l_AGRUPACNXNIT OUTPUT, @l_AGRUPACNXCAD OUTPUT
 
	  IF @p_CODTIPOVINCULACIONPAGO = @l_PUNTODEVENTA BEGIN
		SELECT @result = 'Punto ' + ISNULL(CODIGOGTECHPUNTODEVENTA, '') + '. ' + ISNULL(NOMPUNTODEVENTA, '') FROM WSXML_SFG.PUNTODEVENTA WHERE ID_PUNTODEVENTA = @p_CODPUNTODEVENTA;
	  END
	  ELSE IF @p_CODTIPOVINCULACIONPAGO = @l_AGRUPACNXNIT BEGIN
		SELECT @result =  ISNULL(NIT, '') + '. ' + ISNULL(REPRESENTANTELEGAL, '') FROM
		(SELECT ISNULL(PDV.IDENTIFICACION, '') + ISNULL('-' + ISNULL(PDV.DIGITOVERIFICACION, ''), '') AS NIT,
				MAX(CTR.NOMBREREPRESENTANTELEGAL) AS REPRESENTANTELEGAL
		 FROM WSXML_SFG.PUNTODEVENTA PDV
		 INNER JOIN WSXML_SFG.CONTRATO CTR ON (CTR.IDENTIFICACIONCONTRATO = PDV.IDENTIFICACION)
		 WHERE PDV.IDENTIFICACION = (SELECT IDENTIFICACION FROM WSXML_SFG.PUNTODEVENTA WHERE ID_PUNTODEVENTA = @p_CODPUNTODEVENTA)
		 GROUP BY PDV.IDENTIFICACION, PDV.DIGITOVERIFICACION) s
		;
	  END
	  ELSE IF @p_CODTIPOVINCULACIONPAGO = @l_AGRUPACNXCAD BEGIN
		SELECT @result = NOMAGRUPACIONPUNTODEVENTA FROM WSXML_SFG.PUNTODEVENTA
		INNER JOIN AGRUPACIONPUNTODEVENTA ON (CODAGRUPACIONPUNTODEVENTA = ID_AGRUPACIONPUNTODEVENTA)
		WHERE ID_PUNTODEVENTA = @p_CODPUNTODEVENTA;
	  END 
  
	IF @@ROWCOUNT = 0
		RETURN @result;
	RETURN @result;
END; 

