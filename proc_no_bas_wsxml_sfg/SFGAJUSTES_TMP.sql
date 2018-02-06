USE SFGPRODU;
--  DDL for Package Body SFGAJUSTES_TMP
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGAJUSTES_TMP */ 



 IF OBJECT_ID('WSXML_SFG.SFGAJUSTES_TMP_IntegridadPdvTerCad', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAJUSTES_TMP_IntegridadPdvTerCad;
GO

CREATE   PROCEDURE WSXML_SFG.SFGAJUSTES_TMP_IntegridadPdvTerCad ( @p_CODIGOPUNTODEVENTA NVARCHAR(2000),
                                 @p_TERMINAL NUMERIC(22,0),
                                 @p_CODIGOCADENA NUMERIC(22,0),
                                 @p_ID_PUNTODEVENTA NUMERIC(22,0) OUT) AS
 BEGIN
 DECLARE @v_TERMINAL NUMERIC(22,0);
 DECLARE @v_CODCADENA NUMERIC(22,0);
 DECLARE @v_COUNTPDV NUMERIC(22,0);
 DECLARE @msg VARCHAR(2000)
  
 SET NOCOUNT ON;
         --Verificamos si existe un punto de venta
         SELECT @v_COUNTPDV = COUNT(1)
         FROM WSXML_SFG.PUNTODEVENTA
         WHERE CODIGOGTECHPUNTODEVENTA = @p_CODIGOPUNTODEVENTA;

         IF  @v_COUNTPDV= 0 BEGIN
            SET @p_ID_PUNTODEVENTA=0;
			SET @msg = '-20054 No existe un punto de venta con el codigo' + ISNULL(@p_CODIGOPUNTODEVENTA, '') + ''
            RAISERROR(@msg, 16, 1);
         END 

         --Capturamos los valores de terminal y codigo de cadena que el punto de venta tiene
         SELECT @p_ID_PUNTODEVENTA = PUNTODEVENTA.ID_PUNTODEVENTA, @v_TERMINAL = PUNTODEVENTA.NUMEROTERMINAL,@v_CODCADENA = AGRUPACIONPUNTODEVENTA.CODIGOAGRUPACIONGTECH
                        FROM WSXML_SFG.PUNTODEVENTA
				INNER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA ON PUNTODEVENTA.CODAGRUPACIONPUNTODEVENTA = AGRUPACIONPUNTODEVENTA.ID_AGRUPACIONPUNTODEVENTA
         WHERE CODIGOGTECHPUNTODEVENTA = @p_CODIGOPUNTODEVENTA ;

         --Verificamos que los valores de terminal y codigo cadena coincidan con los suministrados
         IF NOT (@v_TERMINAL=@p_TERMINAL) BEGIN
            SET @p_ID_PUNTODEVENTA=0;
			SET @msg = '-20054 La terminal del punto de venta ' + ISNULL(@p_CODIGOPUNTODEVENTA, '') + ' no coincide' 
            RAISERROR(@msg, 16, 1);
         END
         IF NOT(@v_CODCADENA = @p_CODIGOCADENA) BEGIN
            SET @p_ID_PUNTODEVENTA=0;
			SET @msg = '-20054 La cadena del punto de venta ' + ISNULL(@p_CODIGOPUNTODEVENTA, '') + ' no coincide' 
            RAISERROR(@msg, 16, 1);
         END

 END;
 GO

 IF OBJECT_ID('WSXML_SFG.SFGAJUSTES_TMP_VerExistenciaProducto', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAJUSTES_TMP_VerExistenciaProducto;
GO

CREATE   PROCEDURE WSXML_SFG.SFGAJUSTES_TMP_VerExistenciaProducto( @p_CODIGOPRODUCTO NUMERIC(22,0),
                                  @p_ID_PRODUCTO NUMERIC(22,0) OUT)AS
BEGIN
DECLARE @v_COUNT NUMERIC(22,0);
 DECLARE @msg VARCHAR(2000)
SET NOCOUNT ON;
   SELECT @v_COUNT = COUNT(1)
   FROM WSXML_SFG.PRODUCTO WHERE PRODUCTO.CODIGOGTECHPRODUCTO= @p_CODIGOPRODUCTO;

   IF @v_COUNT = 0  BEGIN
	SET @msg = '-20054 No existe un producto con el codigo ' + ISNULL(CONVERT(VARCHAR, @p_CODIGOPRODUCTO), '') + ' '
      RAISERROR(@msg, 16, 1);
   END  

   SELECT @p_ID_PRODUCTO = ID_PRODUCTO
   FROM WSXML_SFG.PRODUCTO WHERE PRODUCTO.CODIGOGTECHPRODUCTO= @p_CODIGOPRODUCTO;

END
GO

 IF OBJECT_ID('WSXML_SFG.SFGAJUSTES_TMP_CrearRegistroFacturacionVacio', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAJUSTES_TMP_CrearRegistroFacturacionVacio;
GO

CREATE   PROCEDURE WSXML_SFG.SFGAJUSTES_TMP_CrearRegistroFacturacionVacio (@p_CODPUNTODEVENTA NUMERIC(22,0),
                                          @p_CODPRODUCTO NUMERIC(22,0),
                                          @p_FECHA DATE,
                                          @p_CODTIPOREGISTRO NUMERIC(22,0),
                                          @p_CODUSUARIOMODIFICACION NUMERIC(22,0),
                                          @P_ID_REGISTROFACTURACION NUMERIC(22,0) OUT)
AS
BEGIN
DECLARE @v_COUNT NUMERIC(22,0);
 
SET NOCOUNT ON;
        SELECT @V_COUNT = COUNT(1)
        FROM WSXML_SFG.REGISTROFACTURACION
        INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
        WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO =   CONVERT(DATETIME,@p_FECHA)
        AND REGISTROFACTURACION.CODPRODUCTO = @p_CODPRODUCTO
        AND REGISTROFACTURACION.CODTIPOREGISTRO= @p_CODTIPOREGISTRO
        AND REGISTROFACTURACION.CODPUNTODEVENTA = @p_CODPUNTODEVENTA;

        IF @v_COUNT =0 BEGIN
                      DECLARE @p_CODRANGOCOMISION         NUMERIC(22,0);
                      DECLARE @p_ANTICIPO                 NUMERIC(22,0);
                      -- Reglas de facturacion aplicadas
                      DECLARE @p_CODCOMPANIA                NUMERIC(22,0);
                      DECLARE @p_CODREGIMEN                 NUMERIC(22,0);--
                      DECLARE @p_CODAGRUPACIONPUNTODEVENTA  NUMERIC(22,0);--
                      DECLARE @p_CODREDPDV                  NUMERIC(22,0);--
                      DECLARE @p_IDENTIFICACION             NUMERIC(22,0);--
                      DECLARE @p_DIGITOVERIFICACION         NUMERIC(22,0);--
                      DECLARE @p_CODCIUDAD                  NUMERIC(22,0);--
                      DECLARE @p_CODTIPOCONTRATOPDV         NUMERIC(22,0);
                      DECLARE @p_CODRAZONSOCIAL             NUMERIC(22,0);--
                      DECLARE @p_CODTIPOCONTRATOPRODUCTO    NUMERIC(22,0);
                      DECLARE @p_CODCANALDENEGOCIO          NUMERIC(22,0);
                      DECLARE @p_CODDUENOTERMINAL           NUMERIC(22,0);
                      DECLARE @TMPID NUMERIC(22,0);
                      DECLARE @P_CODSERVICIO NUMERIC(22,0);
                      DECLARE @p_CODENTRADAARCHIVOCONTROL NUMERIC(22,0);

           BEGIN


                      SELECT @p_CODREGIMEN = PUNTODEVENTA.CODREGIMEN,
                             @p_CODAGRUPACIONPUNTODEVENTA = PUNTODEVENTA.CODAGRUPACIONPUNTODEVENTA,
                             @p_CODREDPDV = PUNTODEVENTA.CODREDPDV,
                             @p_IDENTIFICACION = PUNTODEVENTA.IDENTIFICACION,
                             @p_DIGITOVERIFICACION = PUNTODEVENTA.DIGITOVERIFICACION,
                             @p_CODCIUDAD = PUNTODEVENTA.CODCIUDAD,
                             @p_CODRAZONSOCIAL = PUNTODEVENTA.CODRAZONSOCIAL,
                             @p_CODCANALDENEGOCIO = REDPDV.CODCANALNEGOCIO,
                             @p_CODDUENOTERMINAL = PUNTODEVENTA.CODDUENOTERMINAL
                                                  FROM WSXML_SFG.PUNTODEVENTA
                      INNER JOIN WSXML_SFG.REDPDV ON PUNTODEVENTA.CODREDPDV = REDPDV.ID_REDPDV
                      WHERE PUNTODEVENTA.ID_PUNTODEVENTA = @p_CODPUNTODEVENTA;

                      SELECT @p_CODTIPOCONTRATOPRODUCTO = PRODUCTOCONTRATO.CODTIPOCONTRATOPRODUCTO
                      FROM WSXML_SFG.PRODUCTOCONTRATO
                      INNER JOIN WSXML_SFG.PRODUCTO ON PRODUCTOCONTRATO.CODPRODUCTO = PRODUCTO.ID_PRODUCTO
                      WHERE PRODUCTO.ID_PRODUCTO = @p_CODPRODUCTO;

                      SELECT @p_CODCOMPANIA = RAZONSOCIALCONTRATO.CODCOMPANIA,@p_CODTIPOCONTRATOPDV = RAZONSOCIALCONTRATO.CODTIPOCONTRATOPDV,@P_CODSERVICIO = LINEADENEGOCIO.CODSERVICIO
                                                  FROM WSXML_SFG.RAZONSOCIALCONTRATO
                      INNER JOIN WSXML_SFG.SERVICIO ON RAZONSOCIALCONTRATO.CODSERVICIO = SERVICIO.ID_SERVICIO
                      INNER JOIN WSXML_SFG.LINEADENEGOCIO ON LINEADENEGOCIO.CODSERVICIO = SERVICIO.ID_SERVICIO
                      INNER JOIN WSXML_SFG.TIPOPRODUCTO ON TIPOPRODUCTO.CODLINEADENEGOCIO = LINEADENEGOCIO.ID_LINEADENEGOCIO
                      INNER JOIN WSXML_SFG.PRODUCTO ON PRODUCTO.CODTIPOPRODUCTO = TIPOPRODUCTO.ID_TIPOPRODUCTO
                      WHERE PRODUCTO.ID_PRODUCTO =  @p_CODPRODUCTO
                      AND RAZONSOCIALCONTRATO.CODRAZONSOCIAL  = @p_CODRAZONSOCIAL
                      AND RAZONSOCIALCONTRATO.CODCANALNEGOCIO = @p_CODCANALDENEGOCIO ;

                      SELECT @p_CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
                      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
                      WHERE FECHAARCHIVO = @p_FECHA
                      AND TIPOARCHIVO = @P_CODSERVICIO
                      AND ACTIVE = 1;


                     EXEC WSXML_SFG.SFGPLANTILLAPRODUCTO_GetPinpointComissionValues  
															@p_CODPUNTODEVENTA,
                                                            @p_CODPRODUCTO,
                                                            @p_CODRANGOCOMISION OUT,
                                                            @TMPID OUT,
                                                            @TMPID OUT,
                                                            @TMPID OUT,
                                                            @TMPID OUT,
                                                            @TMPID OUT,
                                                            @p_ANTICIPO


                      EXEC WSXML_SFG.SFGREGISTROFACTURACION_AddRecord @p_CODENTRADAARCHIVOCONTROL,@p_CODPUNTODEVENTA,@p_CODPRODUCTO,@p_CODTIPOREGISTRO,0,@p_FECHA,0,@p_CODRANGOCOMISION,@p_ANTICIPO,0,0,@p_CODCOMPANIA ,@p_CODREGIMEN,@p_CODAGRUPACIONPUNTODEVENTA,@p_CODREDPDV,@p_IDENTIFICACION,@p_DIGITOVERIFICACION,@p_CODCIUDAD,@p_CODTIPOCONTRATOPDV,@p_CODRAZONSOCIAL,@p_CODTIPOCONTRATOPRODUCTO,@p_CODDUENOTERMINAL,@p_CODUSUARIOMODIFICACION,@P_ID_REGISTROFACTURACION OUT



           END;
        END 

END;
GO



IF OBJECT_ID('WSXML_SFG.SFGAJUSTES_TMP_Agregar', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAJUSTES_TMP_Agregar;
GO

CREATE   PROCEDURE WSXML_SFG.SFGAJUSTES_TMP_Agregar(@p_CODPUNTODEVENTA   NUMERIC(22,0),
                          @p_CODUSUARIOINGRESA NUMERIC(22,0),
                          @p_COMENTARIO        NVARCHAR(2000),
                          @p_CODPRODUCTO       NUMERIC(22,0),
                          @p_COMISION          NUMERIC(22,0),
                          @p_IVACOMISION       NUMERIC(22,0),
                          @p_RETEFUENTE        NUMERIC(22,0),
                          @p_RETEICA           NUMERIC(22,0),
                          @p_RETEIVA           NUMERIC(22,0),
                          @p_RETECREE          NUMERIC(22,0),
                          @p_RETEUVT           NUMERIC(22,0),
                          @p_IVAPRODUCTO       NUMERIC(22,0)) AS
BEGIN
SET NOCOUNT ON;
  DECLARE @v_FECHAINICIO DATETIME;
  DECLARE @v_IDREGISTROFACTURACION NUMERIC(22,0);
  DECLARE @v_COUNTREG NUMERIC(22,0);
  BEGIN


       --Establecer la fecha de inicio de los dias de facturacion qye
       SELECT @v_FECHAINICIO = CONVERT(DATETIME, CONVERT(DATE,FECHAEJECUCION))
       FROM WSXML_SFG.CICLOFACTURACIONPDV
       WHERE ID_CICLOFACTURACIONPDV =(SELECT WSXML_SFG.ultimo_ciclofacturacion(GETDATE()));

       SET @v_FECHAINICIO= @v_FECHAINICIO+1;
       
       --VAlidar si es la semana del cierrre , se toma la mayor 
       
       IF CONVERT(DATETIME, CONVERT(VARCHAR(7), GETDATE(),120) + '-01')  >@v_FECHAINICIO BEGIN 
          SET @v_FECHAINICIO=CONVERT(DATETIME, CONVERT(VARCHAR(7), GETDATE(),120) + '-01');
       END    

       --Capturar el id del registro facturacion que tenga la mayor comision desde la fecha en v_FECHAINICIO hasta hoy

       SELECT @v_COUNTREG = COUNT(1)
       FROM WSXML_SFG.REGISTROFACTURACION
       INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
       WHERE   ENTRADAARCHIVOCONTROL.FECHAARCHIVO >= @v_FECHAINICIO AND CODPUNTODEVENTA= @p_CODPUNTODEVENTA AND CODPRODUCTO = @p_CODPRODUCTO AND CODTIPOREGISTRO=1
       --WHERE  ROWNUM=1 AND FECHATRANSACCION='22/JUl/2012' AND CODPUNTODEVENTA= p_CODPUNTODEVENTA AND CODPRODUCTO = p_CODPRODUCTO AND CODTIPOREGISTRO=1
       --ORDER BY REGISTROFACTURACION.VALORCOMISION DESC;


      IF @v_COUNTREG = 0 BEGIN
         EXEC WSXML_SFG.SFGAJUSTES_TMP_CrearRegistroFacturacionVacio  @p_CODPUNTODEVENTA,@p_CODPRODUCTO,@v_FECHAINICIO,1/*VENTA*/,@p_CODUSUARIOINGRESA,@v_IDREGISTROFACTURACION OUT
      END
      ELSE BEGIN
         SELECT @v_IDREGISTROFACTURACION = ID_REGISTROFACTURACION
         FROM WSXML_SFG.REGISTROFACTURACION
         INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL =ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
         WHERE   ENTRADAARCHIVOCONTROL.FECHAARCHIVO >=@v_FECHAINICIO AND CODPUNTODEVENTA= @p_CODPUNTODEVENTA AND CODPRODUCTO = @p_CODPRODUCTO AND CODTIPOREGISTRO=1
         --WHERE  ROWNUM=1 AND FECHATRANSACCION='22/jul/2012' AND CODPUNTODEVENTA= p_CODPUNTODEVENTA AND CODPRODUCTO = p_CODPRODUCTO AND CODTIPOREGISTRO=1
         ORDER BY REGISTROFACTURACION.VALORCOMISION DESC;
      END 


        DECLARE @v_ID_AJUSTE_TMP NUMERIC(22,0);
        DECLARE @v_PREVALORCOMISION FLOAT;
        DECLARE @v_PREVALORCOMISIONNETA FLOAT;
        DECLARE @v_PREVALORCOMISIONBRUTA FLOAT;
        DECLARE @v_PREVALORCOMISIONNOREDONDEADO FLOAT;
        DECLARE @v_PREIVACOMISION FLOAT;
        DECLARE @v_PRERETEFUENTE FLOAT;
        DECLARE @v_PRERETEICA FLOAT;
        DECLARE @v_PRERETEIVA FLOAT;
        DECLARE @v_PRERETECREE FLOAT;
        DECLARE @v_PRERETEUVT FLOAT;
        DECLARE @v_PREIVAPRODUCTO FLOAT;
        DECLARE @v_NEWVALORCOMISION FLOAT;
        DECLARE @v_NEWVALORCOMISIONNETA FLOAT;
        DECLARE @v_NEWVALORCOMISIONBRUTA FLOAT;
        DECLARE @v_NEWVALORCOMISIONNOREDONDEADO FLOAT;
        DECLARE @v_NEWIVACOMISION FLOAT;
        DECLARE @v_NEWRETEFUENTE FLOAT;
        DECLARE @v_NEWRETEICA FLOAT;
        DECLARE @v_NEWRETEIVA FLOAT;
        DECLARE @v_NEWRETECREE FLOAT;
        DECLARE @v_NEWRETEUVT FLOAT;
        DECLARE @v_NEWIVAPRODUCTO FLOAT;
        DECLARE @v_CODENTRADAARCHIVOCONTROL NUMERIC(22,0);
        DECLARE @v_COUNT NUMERIC(22,0);
        DECLARE @v_TMPID NUMERIC(22,0);
        DECLARE @v_CODTIPOREGISTRO NUMERIC(22,0);
        BEGIN


               --Capturar el valor actual de VALORCOMISION,VALORCOMISIONNETA,VALORCOMISIONBRUTA y VALORCOMISIONNOREDONDEO
               SELECT @v_PREVALORCOMISION = ISNULL(R.VALORCOMISION,0),
                      @v_PREIVACOMISION = ISNULL(R.IVACOMISION,0),
                      @v_PREVALORCOMISIONNETA = ISNULL(R.VALORCOMISIONNETA,0),
                      @v_PREVALORCOMISIONBRUTA = ISNULL(R.VALORCOMISIONBRUTA,0),
                      @v_PREVALORCOMISIONNOREDONDEADO = ISNULL(R.VALORCOMISIONNOREDONDEADO,0),
                      @v_CODENTRADAARCHIVOCONTROL = R.CODENTRADAARCHIVOCONTROL,
                      @v_CODTIPOREGISTRO = R.CODTIPOREGISTRO
                                    FROM WSXML_SFG.REGISTROFACTURACION R
               WHERE ID_REGISTROFACTURACION=@v_IDREGISTROFACTURACION;

               --Capturar los valores actuales de retenciones
               SELECT    @v_PRERETEFUENTE = ISNULL(SUM(CASE WHEN RR.CODRETENCIONTRIBUTARIA=1/*ReteFuente*/ THEN RR.VALORRETENCION ELSE 0 END),0),
                         @v_PRERETEICA = ISNULL(SUM(CASE WHEN RR.CODRETENCIONTRIBUTARIA=2/*ReteICA*/ THEN RR.VALORRETENCION ELSE 0 END),0),
                         @v_PRERETEIVA = ISNULL(SUM(CASE WHEN RR.CODRETENCIONTRIBUTARIA=3/*ReteIVA*/ THEN RR.VALORRETENCION ELSE 0 END),0),
                         @v_PRERETECREE = ISNULL(SUM(CASE WHEN RR.CODRETENCIONTRIBUTARIA=4/*ReteIVA*/ THEN RR.VALORRETENCION ELSE 0 END),0)
                                       FROM WSXML_SFG.RETENCIONREGFACTURACION RR
               WHERE RR.CODREGISTROFACTURACION= @v_IDREGISTROFACTURACION;

               --Capturar el valor actual de rentecion UVT
               SELECT @v_PRERETEUVT = ISNULL(SUM(RU.VALORRETENCION),0)
               FROM WSXML_SFG.RETUVTREGFACTURACION RU
               WHERE CODREGISTROFACTURACION = @v_IDREGISTROFACTURACION;


               IF @p_IVAPRODUCTO<>0 BEGIN
                  DECLARE @I_COUNT NUMERIC(22,0);
                  DECLARE @I_ID_PRODUCTOIMPUESTO NUMERIC(22,0);
                  DECLARE @I_IDIMPUESTOREGFACTURACION NUMERIC(22,0);
                BEGIN
                  SELECT @I_COUNT = COUNT(1)
                  FROM WSXML_SFG.IMPUESTOREGFACTURACION
                  WHERE CODREGISTROFACTURACION = @v_IDREGISTROFACTURACION
                  AND CODIMPUESTO = 1 /*IVA*/;

                  IF @I_COUNT >0  -- YA HAY UN REGISTRO EN IMPUESTOREGFACTURACION
                    BEGIN
                        SET @V_PREIVAPRODUCTO = 0;

                        SELECT @V_PREIVAPRODUCTO = SUM(VALORIMPUESTO)
                        FROM WSXML_SFG.IMPUESTOREGFACTURACION
                         WHERE CODREGISTROFACTURACION = @v_IDREGISTROFACTURACION
                        AND CODIMPUESTO = 1;

                        UPDATE WSXML_SFG.IMPUESTOREGFACTURACION SET VALORIMPUESTO = VALORIMPUESTO + @p_IVAPRODUCTO
                        WHERE CODREGISTROFACTURACION = @v_IDREGISTROFACTURACION
                        AND CODIMPUESTO = 1;

                        UPDATE WSXML_SFG.REGISTROFACTURACION SET VALORVENTABRUTA = VALORVENTABRUTA - @p_IVAPRODUCTO,
                                                       VALORVENTABRUTANOREDONDEADO = VALORVENTABRUTANOREDONDEADO- @p_IVAPRODUCTO,
                                                       VALORVENTANETA = VALORVENTANETA- @p_IVAPRODUCTO
                        WHERE ID_REGISTROFACTURACION = @v_IDREGISTROFACTURACION;

                        --SFGREGISTROFACTURACION.RecalcularPrefactRegSinImp(v_IDREGISTROFACTURACION,v_TMPID);
                        SET @V_NEWIVAPRODUCTO = @v_PREIVAPRODUCTO + @p_IVAPRODUCTO;
                    END;
                  ELSE
                    BEGIN
                        SET @V_PREIVAPRODUCTO = 0;

                        SELECT @I_COUNT = COUNT(1)
                        FROM WSXML_SFG.PRODUCTOIMPUESTO
                        WHERE CODPRODUCTO = @p_CODPRODUCTO;

                        IF @I_COUNT >0
                           BEGIN
                             SELECT @I_ID_PRODUCTOIMPUESTO = ID_PRODUCTOIMPUESTO
                             FROM WSXML_SFG.PRODUCTOIMPUESTO
                             WHERE CODPRODUCTO = @p_CODPRODUCTO;
                           END;
                        ELSE
                           BEGIN
                               RAISERROR('-20054 El producto no tiene configurado IVA. No se puede realizar el ajuste', 16, 1);
                           END;
                        

                        EXEC WSXML_SFG.SFGIMPUESTOREGFACTURACION_AddRecord 1/*IVA*/,@I_ID_PRODUCTOIMPUESTO,@v_CODENTRADAARCHIVOCONTROL,@v_IDREGISTROFACTURACION,@v_CODTIPOREGISTRO,@p_IVAPRODUCTO,@p_CODUSUARIOINGRESA,@I_IDIMPUESTOREGFACTURACION OUT
                        --SFGREGISTROFACTURACION.RecalcularPrefactRegSinImp(v_IDREGISTROFACTURACION,v_TMPID);

                         UPDATE WSXML_SFG.REGISTROFACTURACION SET VALORVENTABRUTA = VALORVENTABRUTA - @p_IVAPRODUCTO,
                                                       VALORVENTABRUTANOREDONDEADO = VALORVENTABRUTANOREDONDEADO- @p_IVAPRODUCTO,
                                                       VALORVENTANETA = VALORVENTANETA- @p_IVAPRODUCTO
                        WHERE ID_REGISTROFACTURACION = @v_IDREGISTROFACTURACION;

                        SET @V_NEWIVAPRODUCTO = @p_IVAPRODUCTO;
                    END;
                  
               END;
               END
               ELSE BEGIN
                  SET @v_NEWIVAPRODUCTO =0;
               END 


               --Capturar cuales serian los nuevos valores
               SET @v_NEWVALORCOMISIONNOREDONDEADO = ISNULL(@v_PREVALORCOMISIONNOREDONDEADO,0) + @p_COMISION;
               SET @v_NEWVALORCOMISION= ROUND(@v_PREVALORCOMISION + @p_COMISION,0);
               SET @v_NEWIVACOMISION= @v_PREIVACOMISION + @p_IVACOMISION;
               SET @v_NEWRETEFUENTE= @v_PRERETEFUENTE + @p_RETEFUENTE;
               SET @v_NEWRETEICA = @v_PRERETEICA + @p_RETEICA;
               SET @v_NEWRETEIVA = @v_PRERETEIVA + @p_RETEIVA;
               SET @v_NEWRETECREE = @v_PRERETECREE + @p_RETECREE;
               SET @v_NEWRETEUVT = @v_PRERETEUVT + @p_RETEUVT;
               SET @v_NEWVALORCOMISIONBRUTA = @v_NEWVALORCOMISION + @v_NEWIVACOMISION;
               SET @v_NEWVALORCOMISIONNETA = @v_NEWVALORCOMISIONBRUTA - (@v_NEWRETEFUENTE+@v_NEWRETEICA+@v_NEWRETEIVA+@v_NEWRETEUVT+@v_NEWRETECREE);

               --Actualizar la data con la nueva informacion

               --Actualizar los valores de Valorcomision e IvaComision
               UPDATE WSXML_SFG.REGISTROFACTURACION SET VALORCOMISION = @v_NEWVALORCOMISION,
                                                IVACOMISION= @v_NEWIVACOMISION,
                                                VALORCOMISIONNETA=@v_NEWVALORCOMISIONNETA,
                                                VALORCOMISIONBRUTA=@v_NEWVALORCOMISIONBRUTA,
                                                Valorcomisionnoredondeado =@v_NEWVALORCOMISIONNOREDONDEADO
               WHERE ID_REGISTROFACTURACION=@v_IDREGISTROFACTURACION;

               --Actualizar los valores de RETEFUENTE

               SELECT @v_COUNT = COUNT(1)
               FROM WSXML_SFG.RETENCIONREGFACTURACION R
               WHERE R.CODREGISTROFACTURACION= @v_IDREGISTROFACTURACION
               AND R.Codretenciontributaria= 1/*ReteFuente*/;

               IF @v_COUNT = 0 BEGIN
                  EXEC WSXML_SFG.SFGRETENCIONREGFACTURACION_AddRecord 1/*ReteFuente*/,@v_CODENTRADAARCHIVOCONTROL,@v_IDREGISTROFACTURACION,1/*Venta*/,@v_NEWRETEFUENTE,@p_CODUSUARIOINGRESA,@v_TMPID OUT
               END
               ELSE BEGIN
                  UPDATE WSXML_SFG.RETENCIONREGFACTURACION SET VALORRETENCION = @v_NEWRETEFUENTE
                  WHERE CODREGISTROFACTURACION= @v_IDREGISTROFACTURACION AND Codretenciontributaria= 1/*ReteFuente*/;
               END 

              --Actualizar los valores de RETEICA

               SELECT @v_COUNT = COUNT(1)
               FROM WSXML_SFG.RETENCIONREGFACTURACION R
               WHERE R.CODREGISTROFACTURACION= @v_IDREGISTROFACTURACION
               AND R.Codretenciontributaria= 2/*RetICA*/;

               IF @v_COUNT = 0 BEGIN
                  EXEC WSXML_SFG.SFGRETENCIONREGFACTURACION_AddRecord  2/*RetICA*/,@v_CODENTRADAARCHIVOCONTROL,@v_IDREGISTROFACTURACION,1/*Venta*/,@v_NEWRETEICA,@p_CODUSUARIOINGRESA,@v_TMPID OUT
               END
               ELSE BEGIN
                   UPDATE WSXML_SFG.RETENCIONREGFACTURACION SET VALORRETENCION = @v_NEWRETEICA
                   WHERE CODREGISTROFACTURACION= @v_IDREGISTROFACTURACION AND Codretenciontributaria= 2/*RetICA*/;
               END 

              --Actualizar los valores de RETEIVA

               SELECT @v_COUNT = COUNT(1)
               FROM WSXML_SFG.RETENCIONREGFACTURACION R
               WHERE R.CODREGISTROFACTURACION= @v_IDREGISTROFACTURACION
               AND R.Codretenciontributaria= 3/*RetIVA*/;

               IF @v_COUNT = 0 BEGIN
                  EXEC WSXML_SFG.SFGRETENCIONREGFACTURACION_AddRecord  3/*RetIVA*/,@v_CODENTRADAARCHIVOCONTROL,@v_IDREGISTROFACTURACION,1/*Venta*/,@v_NEWRETEIVA,@p_CODUSUARIOINGRESA,@v_TMPID OUT
               END
               ELSE BEGIN
                   UPDATE WSXML_SFG.RETENCIONREGFACTURACION SET VALORRETENCION = @v_NEWRETEIVA
                   WHERE CODREGISTROFACTURACION= @v_IDREGISTROFACTURACION AND Codretenciontributaria= 3/*RetIVA*/;
               END 

               --Actualizar los valores de RETECREE

               SELECT @v_COUNT = COUNT(1)
               FROM WSXML_SFG.RETENCIONREGFACTURACION R
               WHERE R.CODREGISTROFACTURACION= @v_IDREGISTROFACTURACION
               AND R.Codretenciontributaria= 4/*RetCREE*/;

               IF @v_COUNT = 0 BEGIN
                  EXEC WSXML_SFG.SFGRETENCIONREGFACTURACION_AddRecord 4/*RetCREE*/,@v_CODENTRADAARCHIVOCONTROL,@v_IDREGISTROFACTURACION,1/*Venta*/,@v_NEWRETECREE,@p_CODUSUARIOINGRESA,@v_TMPID OUT
               END
               ELSE BEGIN
                   UPDATE WSXML_SFG.RETENCIONREGFACTURACION SET VALORRETENCION = @v_NEWRETECREE
                   WHERE CODREGISTROFACTURACION= @v_IDREGISTROFACTURACION AND Codretenciontributaria= 4/*RetCREE*/;
               END 

               --Actualizar los valores de RETEUVT

               SELECT @v_COUNT = COUNT(1)
               FROM WSXML_SFG.RETUVTREGFACTURACION R
               WHERE R.CODREGISTROFACTURACION= @v_IDREGISTROFACTURACION;

               IF @v_COUNT = 0 BEGIN
                  EXEC WSXML_SFG.SFGRETUVTREGFACTURACION_AddRecord 1,@v_CODENTRADAARCHIVOCONTROL,@v_IDREGISTROFACTURACION,1/*Venta*/,@v_NEWRETEUVT,1,@p_CODUSUARIOINGRESA,@v_TMPID OUT
               END
               ELSE BEGIN
                  UPDATE WSXML_SFG.RETUVTREGFACTURACION SET VALORRETENCION= @v_NEWRETEUVT
                  WHERE CODREGISTROFACTURACION= @v_IDREGISTROFACTURACION;
               END 



               --Insertamos los registros del ajuste
               --SET @v_ID_AJUSTE_TMP = AJUSTE_TMP_SEQ.NEXTVAL;

               INSERT INTO WSXML_SFG.AJUSTE_TMP(/*ID_AJUSTE,*/CODUSUARIOINGRESA,COMENTARIOAJUSTE,FECHAHORAINGRESO,CODREGISTROFACTURACION)
               VALUES(/*@v_ID_AJUSTE_TMP,*/@p_CODUSUARIOINGRESA,'Ajuste ingresado por usuario', GETDATE(),@v_IDREGISTROFACTURACION);

               INSERT INTO WSXML_SFG.AJUSTEDETALLE_TMP(/*CODAJUSTE_TMP,*/CAMPO,VALORPREVIO,VALORNUEVO)
               VALUES (/*@v_ID_AJUSTE_TMP,*/'Valor comision',ISNULL(@v_PREVALORCOMISION,0),@v_NEWVALORCOMISION);

               INSERT INTO WSXML_SFG.AJUSTEDETALLE_TMP(/*CODAJUSTE_TMP,*/CAMPO,VALORPREVIO,VALORNUEVO)
               VALUES (/*@v_ID_AJUSTE_TMP,*/'Valor Comision Bruta',ISNULL(@v_PREVALORCOMISIONBRUTA,0),@v_NEWVALORCOMISIONBRUTA);

               INSERT INTO WSXML_SFG.AJUSTEDETALLE_TMP(/*CODAJUSTE_TMP,*/CAMPO,VALORPREVIO,VALORNUEVO)
               VALUES (/*@v_ID_AJUSTE_TMP,*/'Valor Comision Neta',ISNULL(@v_PREVALORCOMISIONNETA,0),@v_NEWVALORCOMISIONNETA);

               INSERT INTO WSXML_SFG.AJUSTEDETALLE_TMP(/*CODAJUSTE_TMP,*/CAMPO,VALORPREVIO,VALORNUEVO)
               VALUES (/*@v_ID_AJUSTE_TMP,*/'Valor Comision No Redondeo',ISNULL(@v_PREVALORCOMISIONNOREDONDEADO,0),@v_NEWVALORCOMISIONNOREDONDEADO);

               INSERT INTO WSXML_SFG.AJUSTEDETALLE_TMP(/*CODAJUSTE_TMP,*/CAMPO,VALORPREVIO,VALORNUEVO)
               VALUES (/*@v_ID_AJUSTE_TMP,*/'IVA comision',ISNULL(@v_PREIVACOMISION,0),@v_NEWIVACOMISION);

               INSERT INTO WSXML_SFG.AJUSTEDETALLE_TMP(/*CODAJUSTE_TMP,*/CAMPO,VALORPREVIO,VALORNUEVO)
               VALUES (/*@v_ID_AJUSTE_TMP,*/'RETEFUENTE',ISNULL(@v_PRERETEFUENTE,0),@v_NEWRETEFUENTE);

               INSERT INTO WSXML_SFG.AJUSTEDETALLE_TMP(/*CODAJUSTE_TMP,*/CAMPO,VALORPREVIO,VALORNUEVO)
               VALUES (/*@v_ID_AJUSTE_TMP,*/'RETEICA',ISNULL(@v_PRERETEICA,0),@v_NEWRETEICA);

               INSERT INTO WSXML_SFG.AJUSTEDETALLE_TMP(/*CODAJUSTE_TMP,*/CAMPO,VALORPREVIO,VALORNUEVO)
               VALUES (/*@v_ID_AJUSTE_TMP,*/'RETEIVA',ISNULL(@v_PRERETEIVA,0),@v_NEWRETEIVA);

               INSERT INTO WSXML_SFG.AJUSTEDETALLE_TMP(/*CODAJUSTE_TMP,*/CAMPO,VALORPREVIO,VALORNUEVO)
               VALUES (/*@v_ID_AJUSTE_TMP,*/'RETECREE',ISNULL(@v_PRERETECREE,0),@v_NEWRETECREE);

               INSERT INTO WSXML_SFG.AJUSTEDETALLE_TMP(/*CODAJUSTE_TMP,*/CAMPO,VALORPREVIO,VALORNUEVO)
               VALUES (/*@v_ID_AJUSTE_TMP,*/'RETEUVT',ISNULL(@v_PRERETEUVT,0),@v_NEWRETEUVT);

               INSERT INTO WSXML_SFG.AJUSTEDETALLE_TMP(/*CODAJUSTE_TMP,*/CAMPO,VALORPREVIO,VALORNUEVO)
               VALUES (/*@v_ID_AJUSTE_TMP,*/'IVAPRODUCTO',ISNULL(@v_PREIVAPRODUCTO,0),@v_NEWIVAPRODUCTO);

               --Modificacion Guillermo Ni?o 25 01 13 -- Recalculo del revenue del registro calculado
			   -- Revisar
               --EXEC  WSXML_SFG.SFGREGISTROREVENUE_CalcularRevenueRegistro @v_IDREGISTROFACTURACION

               COMMIT;
         END;

  END;
END;
GO

IF OBJECT_ID('WSXML_SFG.SFGAJUSTES_TMP_CambiarArchivoControl', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAJUSTES_TMP_CambiarArchivoControl;
GO

CREATE   PROCEDURE WSXML_SFG.SFGAJUSTES_TMP_CambiarArchivoControl ( @P_CODREGISTROFACTURACION NUMERIC(22,0),
                                   @P_CODENTRADAARCHIVOCONTROL NUMERIC(22,0),
                                   @P_CODPUNTODEVENTA NUMERIC(22,0)) AS
BEGIN
SET NOCOUNT ON;


  DECLARE @v_COUNT INT;
  DECLARE @v_CODENTARCHIVOCONTROLANTERIOR NUMERIC(22,0);
  DECLARE @v_VALORTRANSACCIONES FLOAT;
  DECLARE @v_NUMTRANSACCIONES INT;
  DECLARE @v_CODTIPOREGISTRO NUMERIC(22,0);
  BEGIN
    --Verificar que el registrofacturacion existe
    SELECT @v_COUNT = COUNT(1)
    FROM WSXML_SFG.REGISTROFACTURACION
    WHERE ID_REGISTROFACTURACION = @P_CODREGISTROFACTURACION;

    IF @v_COUNT = 0 BEGIN
        RAISERROR('-20054 El registro facturacion no es valido', 16, 1);
    END 

    --Verificar que el entradaarchivocontrol existe
    SELECT @v_COUNT = COUNT(1)
    FROM WSXML_SFG.ENTRADAARCHIVOCONTROL
    WHERE ID_ENTRADAARCHIVOCONTROL = @P_CODENTRADAARCHIVOCONTROL;

    IF @v_COUNT = 0 BEGIN
        RAISERROR('-20054 El entrada archivo control no es valido', 16, 1);
    END 

    --Verificar que el punto de venta exista

    SELECT @v_COUNT = COUNT(1)
    FROM WSXML_SFG.PUNTODEVENTA
    WHERE ID_PUNTODEVENTA = @P_CODPUNTODEVENTA;

    --Obtener los valores del id del entradaarchivocontrolactual, el numero de transacciones y valor de las transacciones
    SELECT @v_CODENTARCHIVOCONTROLANTERIOR = CODENTRADAARCHIVOCONTROL,
             @v_CODTIPOREGISTRO = CODTIPOREGISTRO,
             @v_NUMTRANSACCIONES = NUMTRANSACCIONES,
             @v_VALORTRANSACCIONES = VALORTRANSACCION
       FROM WSXML_SFG.REGISTROFACTURACION
    WHERE ID_REGISTROFACTURACION  = @P_CODREGISTROFACTURACION;

	SELECT CODENTRADAARCHIVOCONTROL,CODTIPOREGISTRO,NUMTRANSACCIONES,VALORTRANSACCION
       FROM WSXML_SFG.REGISTROFACTURACION
    WHERE ID_REGISTROFACTURACION  = @P_CODREGISTROFACTURACION;
	
    UPDATE WSXML_SFG.REGISTROFACTURACION SET CODENTRADAARCHIVOCONTROL = @P_CODENTRADAARCHIVOCONTROL,CODPUNTODEVENTA = @P_CODPUNTODEVENTA
    WHERE ID_REGISTROFACTURACION  = @P_CODREGISTROFACTURACION;

    UPDATE WSXML_SFG.ENTRADAARCHIVOCONTROL SET     VALORTRANSACCIONES = VALORTRANSACCIONES - CASE WHEN @v_CODTIPOREGISTRO= 1 THEN ISNULL(@v_VALORTRANSACCIONES,0) ELSE ISNULL(@v_VALORTRANSACCIONES,0)*-1 END,
                                         NUMEROTRANSACCIONES= NUMEROTRANSACCIONES - CASE WHEN @v_CODTIPOREGISTRO= 1 THEN @v_NUMTRANSACCIONES ELSE @v_NUMTRANSACCIONES*-1 END
    WHERE ID_ENTRADAARCHIVOCONTROL = @v_CODENTARCHIVOCONTROLANTERIOR;

    UPDATE WSXML_SFG.ENTRADAARCHIVOCONTROL SET     VALORTRANSACCIONES = VALORTRANSACCIONES + CASE WHEN @v_CODTIPOREGISTRO= 1 THEN ISNULL(@v_VALORTRANSACCIONES,0) ELSE ISNULL(@v_VALORTRANSACCIONES,0)*-1 END,
                                         NUMEROTRANSACCIONES= NUMEROTRANSACCIONES + CASE WHEN @v_CODTIPOREGISTRO= 1 THEN @v_NUMTRANSACCIONES ELSE @v_NUMTRANSACCIONES*-1 END
    WHERE ID_ENTRADAARCHIVOCONTROL = @P_CODENTRADAARCHIVOCONTROL;

    UPDATE WSXML_SFG.IMPUESTOREGFACTURACION SET CODENTRADAARCHIVOCONTROL = @P_CODENTRADAARCHIVOCONTROL
    WHERE CODREGISTROFACTURACION = @P_CODREGISTROFACTURACION;

  END;

END ;
GO


IF OBJECT_ID('WSXML_SFG.SFGAJUSTES_TMP_AgregarAjusteAdicionVentas', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGAJUSTES_TMP_AgregarAjusteAdicionVentas;
GO

CREATE   PROCEDURE WSXML_SFG.SFGAJUSTES_TMP_AgregarAjusteAdicionVentas(@p_CODIGOPUNTODEVENTAGTECH NVARCHAR(2000),
                                     @p_CODIGOTIPOTRANSACCION NVARCHAR(2000),
                                     @p_CODIGOPRODUCTOGTECH NVARCHAR(2000),
                                     @p_NUMTRANSACCIONES NUMERIC(22,0),
                                     @p_VALORTRANSACCIONES FLOAT)

AS
BEGIN
DECLARE @v_CODREGISTROFACTURACION NUMERIC(22,0);
DECLARE @v_CODPUNTODEVENTA NUMERIC(22,0);
DECLARE @v_CODTIPOTRANSACCION NUMERIC(22,0);
DECLARE @v_CODPRODUCTO NUMERIC(22,0);
DECLARE @v_COUNT  NUMERIC(22,0);
DECLARE @v_FECHAINICIO DATETIME;

 
SET NOCOUNT ON;

   --Establecer la fecha de inicio de los dias de facturacion qye
   SELECT @v_FECHAINICIO = CONVERT(DATETIME, CONVERT(DATE,FECHAEJECUCION)) +1
   FROM WSXML_SFG.CICLOFACTURACIONPDV
   WHERE ID_CICLOFACTURACIONPDV =(SELECT wsxml_sfg.ultimo_ciclofacturacion(GETDATE()));
   
   SET @v_FECHAINICIO='29/dec/2016';
  
  --Obtener el id SFG del puntod de venta
  SELECT @v_CODPUNTODEVENTA = PUNTODEVENTA.ID_PUNTODEVENTA
  FROM WSXML_SFG.PUNTODEVENTA WHERE CODIGOGTECHPUNTODEVENTA =     @p_CODIGOPUNTODEVENTAGTECH;

  --Obtener el id sfg Del produdcto
  SELECT @v_CODPRODUCTO = PRODUCTO.ID_PRODUCTO
  FROM WSXML_SFG.PRODUCTO WHERE CODIGOGTECHPRODUCTO = @p_CODIGOPRODUCTOGTECH;

  --Obtener el id SFG del tipo de transacciones
  SET @v_CODTIPOTRANSACCION = CAST(@p_CODIGOTIPOTRANSACCION AS NUMERIC(38,0));

  --Buscar el registrofacturacion
  SELECT @v_COUNT = COUNT(1)
  FROM WSXML_SFG.REGISTROFACTURACION
  INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
  WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO >=@v_FECHAINICIO
  AND  REGISTROFACTURACION.CODPUNTODEVENTA =@v_CODPUNTODEVENTA
  AND REGISTROFACTURACION.CODPRODUCTO=@v_CODPRODUCTO
  AND REGISTROFACTURACION.CODTIPOREGISTRO = @v_CODTIPOTRANSACCION;

  IF @v_COUNT >0 BEGIN  -- Si hay algun registro de facturacion

    SELECT @v_CODREGISTROFACTURACION = MAX(REGISTROFACTURACION.ID_REGISTROFACTURACION)
    FROM WSXML_SFG.REGISTROFACTURACION
    INNER JOIN WSXML_SFG.ENTRADAARCHIVOCONTROL ON REGISTROFACTURACION.CODENTRADAARCHIVOCONTROL = ENTRADAARCHIVOCONTROL.ID_ENTRADAARCHIVOCONTROL
    WHERE ENTRADAARCHIVOCONTROL.FECHAARCHIVO >=@v_FECHAINICIO
    AND  REGISTROFACTURACION.CODPUNTODEVENTA =@v_CODPUNTODEVENTA
    AND REGISTROFACTURACION.CODPRODUCTO=@v_CODPRODUCTO
    AND REGISTROFACTURACION.CODTIPOREGISTRO = @v_CODTIPOTRANSACCION;


  END
  ELSE BEGIN-- no existe y toca crearlo
		EXEC WSXML_SFG.SFGAJUSTES_TMP_CrearRegistroFacturacionVacio @v_CODPUNTODEVENTA,@v_CODPRODUCTO,@v_FECHAINICIO,@v_CODTIPOTRANSACCION,1,@v_CODREGISTROFACTURACION OUT
  END 

   DECLARE @TMPIDNUMBER     NUMERIC(22,0);
   DECLARE @v_ID_AJUSTE_TMP NUMERIC(22,0);
   DECLARE @v_PREVIOTRX     NUMERIC(22,0);
   DECLARE @v_PREVIOVENTAS  NUMERIC(22,0);
   DECLARE @v_NUEVOTRX      NUMERIC(22,0);
   DECLARE @v_NUEVOVENTAS   NUMERIC(22,0);

    BEGIN
   --Insertamos los registros del ajuste
   --SET @v_ID_AJUSTE_TMP = AJUSTE_TMP_SEQ.NEXTVAL;

   SELECT @v_PREVIOTRX = NUMTRANSACCIONES, @v_PREVIOVENTAS = VALORTRANSACCION
     FROM WSXML_SFG.REGISTROFACTURACION
    WHERE ID_REGISTROFACTURACION = @v_CODREGISTROFACTURACION;

   UPDATE WSXML_SFG.REGISTROFACTURACION
      SET NUMTRANSACCIONES = NUMTRANSACCIONES + @p_NUMTRANSACCIONES,
          VALORTRANSACCION = VALORTRANSACCION + @p_VALORTRANSACCIONES
    WHERE ID_REGISTROFACTURACION = @v_CODREGISTROFACTURACION;

   -- Revisar
   -- EXEC WSXML_SFG.SFGREGISTROFACTURACION_RecalcularPrefactRegistro   @v_CODREGISTROFACTURACION, @TMPIDNUMBER

   SELECT @v_NUEVOTRX = NUMTRANSACCIONES, @v_NUEVOVENTAS = VALORTRANSACCION
     FROM WSXML_SFG.REGISTROFACTURACION
    WHERE ID_REGISTROFACTURACION = @v_CODREGISTROFACTURACION;

   INSERT INTO WSXML_SFG.AJUSTE_TMP
     (/*ID_AJUSTE,*/
      CODUSUARIOINGRESA,
      COMENTARIOAJUSTE,
      FECHAHORAINGRESO,
      CODREGISTROFACTURACION)
   VALUES
     (/*@v_ID_AJUSTE_TMP,*/
      1,
      'Ajuste ingresado por usuario modificando ventas',
      getdate(),
      @v_CODREGISTROFACTURACION);

   INSERT INTO WSXML_SFG.AJUSTEDETALLE_TMP
     ( /*CODAJUSTE_TMP,*/ CAMPO, VALORPREVIO, VALORNUEVO)
   VALUES
     (
      /*@v_ID_AJUSTE_TMP,*/
      'Numero de transacciones',
      ISNULL(@v_PREVIOTRX, 0),
      @v_NUEVOTRX);

   INSERT INTO WSXML_SFG.AJUSTEDETALLE_TMP
     ( /*CODAJUSTE_TMP,*/ CAMPO, VALORPREVIO, VALORNUEVO)
   VALUES
     (
      /*@v_ID_AJUSTE_TMP,*/
      'Valor transacciones',
      ISNULL(@v_PREVIOVENTAS, 0),
      @v_NUEVOVENTAS);

 END;


end 
GO


