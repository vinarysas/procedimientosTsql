USE SFGPRODU;
--  DDL for Package Body SFGINF_INVENTARIO
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_INVENTARIO */ 

  IF OBJECT_ID('WSXML_SFG.SFGINF_INVENTARIO_GetInventarioDefinition', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_INVENTARIO_GetInventarioDefinition;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_INVENTARIO_GetInventarioDefinition(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    IF @p_CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV BEGIN
      SELECT (TPR.ID_TIPOPRODUCTO * 10000) + AES.ID_ALIADOESTRATEGICO      AS ORDEN,
             CASE WHEN LEN(ISNULL(UPPER(TPR.NOMTIPOPRODUCTO), '') + ' ' + ISNULL(UPPER(AES.NOMALIADOESTRATEGICO), '')) > 30
                  THEN ISNULL(SUBSTRING(ISNULL(UPPER(TPR.NOMTIPOPRODUCTO), '') + ' ' + ISNULL(UPPER(AES.NOMALIADOESTRATEGICO), ''), 1, 27), '') + '...'
                  ELSE ISNULL(UPPER(TPR.NOMTIPOPRODUCTO), '') + ' ' + ISNULL(UPPER(AES.NOMALIADOESTRATEGICO), '')
             END                                                           AS NOMBRE,
             'SFGINF_INVENTARIO.GetInventarioDiario'                       AS PROCEDURENAME,
             (TPR.ID_TIPOPRODUCTO * 10000) + AES.ID_ALIADOESTRATEGICO      AS ID_CICLOFACTURACIONPDV
      FROM WSXML_SFG.CONFIGPRODUCTOINVENTARIO CPI
      INNER JOIN WSXML_SFG.PRODUCTO PRD ON (PRD.ID_PRODUCTO = CPI.CODPRODUCTO)
      INNER JOIN WSXML_SFG.TIPOPRODUCTO TPR ON (TPR.ID_TIPOPRODUCTO = PRD.CODTIPOPRODUCTO)
      INNER JOIN WSXML_SFG.ALIADOESTRATEGICO AES ON (AES.ID_ALIADOESTRATEGICO = PRD.CODALIADOESTRATEGICO)
      GROUP BY TPR.ID_TIPOPRODUCTO, TPR.NOMTIPOPRODUCTO, AES.ID_ALIADOESTRATEGICO, AES.NOMALIADOESTRATEGICO
      ORDER BY TPR.ID_TIPOPRODUCTO, AES.ID_ALIADOESTRATEGICO;
    END 
  END;
GO

IF OBJECT_ID('WSXML_SFG.SFGINF_INVENTARIO_GetInventarioDiario', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_INVENTARIO_GetInventarioDiario;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_INVENTARIO_GetInventarioDiario(
								@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                                @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                                @pg_CADENA                NVARCHAR(2000),
                                @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                                @pg_PRODUCTO              NVARCHAR(2000)) AS
 BEGIN
    DECLARE @TipoProducto NUMERIC(22,0);
    DECLARE @Proveedor    NUMERIC(22,0);
    DECLARE @Header       VARCHAR(MAX) = '';
    DECLARE @ProductList  WSXML_SFG.IDSTRINGVALUE;
	DECLARE @SQL NVARCHAR(MAX)
   
  SET NOCOUNT ON;
    IF ISNULL(@p_CODLINEADENEGOCIO, 0) = ISNULL(@p_CODLINEADENEGOCIO, 0) OR @pg_CADENA = @pg_CADENA OR @pg_ALIADOESTRATEGICO = @pg_ALIADOESTRATEGICO OR @pg_PRODUCTO = @pg_PRODUCTO BEGIN
      SELECT @TipoProducto = FLOOR(@p_CODCICLOFACTURACIONPDV / 10000), @Proveedor = (@p_CODCICLOFACTURACIONPDV % 10000);
      
	  INSERT INTO @ProductList 
	  SELECT ID_PRODUCTO, NOMPRODUCTO
	  FROM WSXML_SFG.PRODUCTO WHERE CODTIPOPRODUCTO = @TipoProducto 
		AND CODALIADOESTRATEGICO = @Proveedor 
	  ORDER BY CAST(CODIGOGTECHPRODUCTO AS NUMERIC(38,0));
    END 
    IF (SELECT COUNT(*) FROM @ProductList)> 0 BEGIN


		DECLARE ipx CURSOR FOR SELECT ID, VALUE FROM @ProductList
		OPEN ipx

          DECLARE @ProductName VARCHAR(30);
          DECLARE @ConfigValue CHAR(1);
		  DECLARE @ID NUMERIC(38,0), @VALUE varchar(2000)
		
		FETCH NEXT FROM ipx INTO @ID,@VALUE
        
        WHILE (@@FETCH_STATUS = 0)
        BEGIN
		
		  SET @ProductName = CASE WHEN LEN(@VALUE) > 22 THEN SUBSTRING(@VALUE, 1, 22) ELSE @VALUE END;


          SELECT @ConfigValue = CONFIGURACION FROM WSXML_SFG.CONFIGPRODUCTOINVENTARIO WHERE CODPRODUCTO = @ID;

		 
          SET @Header = Isnull(@Header, '') + ', SUM(CASE WHEN INV.CODPRODUCTO = ' + ISNULL(convert(varchar,@ID), '') + ' THEN ' + ISNULL(CASE WHEN @ConfigValue = 'D' THEN 'INV.CANTIDADSALDOINICIAL' ELSE 'INV.VALORSALDOINICIAL' END, '') + ' ELSE 0 END) AS "Inicial ' + ISNULL(@ProductName, '') + '"' +
                              ', SUM(CASE WHEN INV.CODPRODUCTO = ' + ISNULL(convert(varchar,@ID), '') + ' THEN ' + ISNULL(CASE WHEN @ConfigValue = 'D' THEN 'INV.CANTIDADVENTAS'       ELSE 'INV.VALORVENTAS'       END, '') + ' ELSE 0 END) AS "Ventas '  + ISNULL(@ProductName, '') + '"' +
                              ', SUM(CASE WHEN INV.CODPRODUCTO = ' + ISNULL(convert(varchar,@ID), '') + ' THEN ' + ISNULL(CASE WHEN @ConfigValue = 'D' THEN 'INV.CANTIDADCARGAS'       ELSE 'INV.VALORCARGAS'       END, '') + ' ELSE 0 END) AS "Cargas '  + ISNULL(@ProductName, '') + '"' +
                              ', SUM(CASE WHEN INV.CODPRODUCTO = ' + ISNULL(convert(varchar,@ID), '') + ' THEN ' + ISNULL(CASE WHEN @ConfigValue = 'D' THEN 'INV.CANTIDADSALDOFINAL'   ELSE 'INV.VALORSALDOFINAL'   END, '') + ' ELSE 0 END) AS "Final '   + ISNULL(@ProductName, '') + '"';
        
			IF @@ROWCOUNT = 0
				SELECT NULL; /* No existe configuracion de inventario */
			FETCH NEXT FROM ipx INTO @ID,@VALUE
        END
        
		CLOSE ipx;
        DEALLOCATE ipx;
     
      SET @sql = 
        'SELECT INV.FECHAINVENTARIO' + Isnull(@Header, '') + ' ' +
        'FROM WSXML_SFG.INVENTARIOPRODUCTO INV ' +
        'WHERE INV.FECHAINVENTARIO BETWEEN (CONVERT(DATETIME, CONVERT(DATE,GETDATE()) ) - 60) AND GETDATE() ' +
        'GROUP BY INV.FECHAINVENTARIO ORDER BY FECHAINVENTARIO DESC ';

      EXECUTE sp_executesql @sql;
    END
  END
GO

  IF OBJECT_ID('WSXML_SFG.SFGINF_INVENTARIO_ValorizacionCierre', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_INVENTARIO_ValorizacionCierre;
GO

  CREATE PROCEDURE WSXML_SFG.SFGINF_INVENTARIO_ValorizacionCierre(@p_CODCICLOFACTURACIONPDV NUMERIC(22,0),
                               @p_CODLINEADENEGOCIO      NUMERIC(22,0),
                               @pg_CADENA                NVARCHAR(2000),
                               @pg_ALIADOESTRATEGICO     NVARCHAR(2000),
                              @pg_PRODUCTO              NVARCHAR(2000)) AS
  BEGIN
  SET NOCOUNT ON;
    SELECT NULL;
  END;

GO


