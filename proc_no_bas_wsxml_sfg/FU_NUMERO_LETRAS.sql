USE SFGPRODU;
--  DDL for Function FU_NUMERO_LETRAS
--------------------------------------------------------

  IF OBJECT_ID('WSXML_SFG.FU_NUMERO_LETRAS', 'FN') IS NOT NULL
    DROP FUNCTION WSXML_SFG.FU_NUMERO_LETRAS;
GO

  CREATE FUNCTION WSXML_SFG.FU_NUMERO_LETRAS (@numero numeric(38,0)) RETURNS VARCHAR(4000)

AS
BEGIN
     DECLARE @lnEntero INTEGER;
     DECLARE @lcRetorno VARCHAR(2000);
     DECLARE @lnTerna INTEGER;
     DECLARE @lcMiles VARCHAR(2000);
     DECLARE @lcCadena VARCHAR(2000);
     DECLARE @lnUnidades INTEGER;
     DECLARE @lnDecenas INTEGER;
     DECLARE @lnCentenas INTEGER;
     DECLARE @lnFraccion INTEGER;
     DECLARE @lnSw INTEGER;
 
     SET @lnEntero = FLOOR(@numero);--Obtenemos la parte Entera
     SET @lnFraccion = FLOOR(((@numero - @lnEntero) * 100));--Obtenemos la Fraccion del Monto
     SET @lcRetorno = '';
     SET @lnTerna = 1;
     IF @lnEntero > 0 BEGIN
     SET @lnSw = LEN(@lnEntero);
     WHILE @lnTerna <= @lnSw BEGIN
        -- Recorro terna por terna
        SET @lcCadena = '';
        SET @lnUnidades = (@lnEntero %10);
        SET @lnEntero = FLOOR(@lnEntero/10);
        SET @lnDecenas = (@lnEntero %10);
        SET @lnEntero = FLOOR(@lnEntero/10);
        SET @lnCentenas = (@lnEntero %10);
        SET @lnEntero = FLOOR(@lnEntero/10);

    -- Analizo las unidades
       IF (@lnUnidades = 1 AND @lnTerna = 1) BEGIN
         SET @lcCadena = 'UNO ' + ISNULL(@lcCadena, '');
       END 
       IF (@lnUnidades = 1 AND @lnTerna <> 1) BEGIN
         SET @lcCadena = 'UN ' + ISNULL(@lcCadena, '');
       END 
       IF (@lnUnidades = 2) BEGIN
         SET @lcCadena = 'DOS ' + ISNULL(@lcCadena, '');
       END 
       IF (@lnUnidades = 3) BEGIN
         SET @lcCadena = 'TRES ' + ISNULL(@lcCadena, '');
       END 
       IF (@lnUnidades = 4) BEGIN
         SET @lcCadena = 'CUATRO ' + ISNULL(@lcCadena, '');
       END 
       IF (@lnUnidades = 5) BEGIN
         SET @lcCadena = 'CINCO ' + ISNULL(@lcCadena, '');
       END 
       IF (@lnUnidades = 6) BEGIN
         SET @lcCadena = 'SEIS ' + ISNULL(@lcCadena, '');
       END 
       IF (@lnUnidades = 7) BEGIN
         SET @lcCadena = 'SIETE ' + ISNULL(@lcCadena, '');
       END 
       IF (@lnUnidades = 8) BEGIN
         SET @lcCadena = 'OCHO ' + ISNULL(@lcCadena, '');
       END 
       IF (@lnUnidades = 9) BEGIN
         SET @lcCadena = 'NUEVE ' + ISNULL(@lcCadena, '');
       END 



    -- Analizo las decenas

   SET @lcCadena =
    CASE /* DECENAS */
      WHEN @lnDecenas = 1 THEN
        CASE @lnUnidades
          WHEN 0 THEN 'DIEZ '
          WHEN 1 THEN 'ONCE '
          WHEN 2 THEN 'DOCE '
          WHEN 3 THEN 'TRECE '
          WHEN 4 THEN 'CATORCE '
          WHEN 5 THEN 'QUINCE '
          ELSE 'DIECI' + ISNULL(@lcCadena, '')
        END
      WHEN @lnDecenas = 2 AND @lnUnidades = 0 THEN 'VEINTE ' + ISNULL(@lcCadena, '')
      WHEN @lnDecenas = 2 AND @lnUnidades <> 0 THEN 'VEINTI' + ISNULL(@lcCadena, '')
      WHEN @lnDecenas = 3 AND @lnUnidades = 0 THEN 'TREINTA ' + ISNULL(@lcCadena, '')
      WHEN @lnDecenas = 3 AND @lnUnidades <> 0 THEN 'TREINTA Y ' + ISNULL(@lcCadena, '')
      WHEN @lnDecenas = 4 AND @lnUnidades = 0 THEN 'CUARENTA ' + ISNULL(@lcCadena, '')
      WHEN @lnDecenas = 4 AND @lnUnidades <> 0 THEN 'CUARENTA Y ' + ISNULL(@lcCadena, '')
      WHEN @lnDecenas = 5 AND @lnUnidades = 0 THEN 'CINCUENTA ' + ISNULL(@lcCadena, '')
      WHEN @lnDecenas = 5 AND @lnUnidades <> 0 THEN 'CINCUENTA Y ' + ISNULL(@lcCadena, '')
      WHEN @lnDecenas = 6 AND @lnUnidades = 0 THEN 'SESENTA ' + ISNULL(@lcCadena, '')
      WHEN @lnDecenas = 6 AND @lnUnidades <> 0 THEN 'SESENTA Y ' + ISNULL(@lcCadena, '')
      WHEN @lnDecenas = 7 AND @lnUnidades = 0 THEN 'SETENTA ' + ISNULL(@lcCadena, '')
      WHEN @lnDecenas = 7 AND @lnUnidades <> 0 THEN 'SETENTA Y ' + ISNULL(@lcCadena, '')
      WHEN @lnDecenas = 8 AND @lnUnidades = 0 THEN 'OCHENTA ' + ISNULL(@lcCadena, '')
      WHEN @lnDecenas = 8 AND @lnUnidades <> 0 THEN 'OCHENTA Y ' + ISNULL(@lcCadena, '')
      WHEN @lnDecenas = 9 AND @lnUnidades = 0 THEN 'NOVENTA ' + ISNULL(@lcCadena, '')
      WHEN @lnDecenas = 9 AND @lnUnidades <> 0 THEN 'NOVENTA Y ' + ISNULL(@lcCadena, '')
      ELSE @lcCadena end;
    -- Analizo las centenas

     SET @lcCadena =

    CASE /* CENTENAS */
      WHEN @lnCentenas = 1 AND @lnUnidades = 0 AND @lnDecenas = 0 THEN 'CIEN ' + ISNULL(@lcCadena, '')
      WHEN @lnCentenas = 1 AND NOT(@lnUnidades = 0 AND @lnDecenas = 0) THEN 'CIENTO ' + ISNULL(@lcCadena, '')
      WHEN @lnCentenas = 2 THEN 'DOSCIENTOS ' + ISNULL(@lcCadena, '')
      WHEN @lnCentenas = 3 THEN 'TRESCIENTOS ' + ISNULL(@lcCadena, '')
      WHEN @lnCentenas = 4 THEN 'CUATROCIENTOS ' + ISNULL(@lcCadena, '')
      WHEN @lnCentenas = 5 THEN 'QUINIENTOS ' + ISNULL(@lcCadena, '')
      WHEN @lnCentenas = 6 THEN 'SEISCIENTOS ' + ISNULL(@lcCadena, '')
      WHEN @lnCentenas = 7 THEN 'SETECIENTOS ' + ISNULL(@lcCadena, '')
      WHEN @lnCentenas = 8 THEN 'OCHOCIENTOS ' + ISNULL(@lcCadena, '')
      WHEN @lnCentenas = 9 THEN 'NOVECIENTOS ' + ISNULL(@lcCadena, '')
      ELSE @lcCadena END;

    -- Analizo la terna
     SET @lcCadena =
    CASE /* TERNA */
      WHEN @lnTerna = 1 THEN @lcCadena
      WHEN @lnTerna = 2 AND (@lnUnidades + @lnDecenas + @lnCentenas <> 0) THEN ISNULL(@lcCadena, '') + ' MIL '
      WHEN @lnTerna = 3 AND (@lnUnidades + @lnDecenas + @lnCentenas <> 0) AND
        @lnUnidades = 1 AND @lnDecenas = 0 AND @lnCentenas = 0 THEN ISNULL(@lcCadena, '') + ' MILLON '
      WHEN @lnTerna = 3 AND (@lnUnidades + @lnDecenas + @lnCentenas <> 0) AND
        NOT (@lnUnidades = 1 AND @lnDecenas = 0 AND @lnCentenas = 0) THEN ISNULL(@lcCadena, '') + ' MILLONES '
      WHEN @lnTerna = 4 AND (@lnUnidades + @lnDecenas + @lnCentenas <> 0) THEN ISNULL(@lcCadena, '') + ' MIL MILLONES '
      ELSE ''
    END;
    --Retornamos los Valores Obtenidos
    SET @lcRetorno = ISNULL(@lcCadena, '')  + ISNULL(@lcRetorno, '');
    SET @lnTerna = @lnTerna + 1;
    END;
  END 
  IF @lnTerna = 1 BEGIN
    SET @lcRetorno = 'CERO';
  END 
  --lcRetorno := RTRIM(lcRetorno) || ' CON ' || LTRIM(lnFraccion) || ' PESOS';  Se quitan los centavos
    SET @lcRetorno = ISNULL(RTRIM(@lcRetorno), '')  + ' PESOS';
RETURN @lcRetorno;
END;


