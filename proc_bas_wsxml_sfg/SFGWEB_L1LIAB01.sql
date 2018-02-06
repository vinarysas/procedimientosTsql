USE SFGPRODU;
/* package body SFGWEB_L1LIAB01 */ 

  --Add Record in the table CATEGORIA_ACIERTOS_L1LIAB01



 IF EXISTS (SELECT * FROM sys.objects WHERE type_desc LIKE '%STORED_PROCEDURE' AND OBJECT_NAME(object_id) = 'SFGWEB_L1LIAB01_PopulateGRID')
	DROP PROCEDURE WSXML_SFG.SFGWEB_L1LIAB01_PopulateGRID;
GO

CREATE     PROCEDURE WSXML_SFG.SFGWEB_L1LIAB01_PopulateGRID(@p_FECHA_01   DATETIME,
                         @p_FECHA_02   DATETIME,
                         @p_PRODUCTO   FLOAT = 0,
                         @p_CATEGORIA3 FLOAT = 0,
                         @p_CATEGORIA4 FLOAT = 0,
                         @p_CATEGORIA5 FLOAT = 0,
                         @p_CATEGORIA6 FLOAT = 0) AS

  BEGIN
  SET NOCOUNT ON;

    if @p_PRODUCTO = 0 begin


        select *
          from (

                SELECT *

                  FROM (SELECT isnull(VW_REPORTE__L1LIAB01_01.NOMBRECATEGORIA,
                                    VW_REPORTE__L1LIAB01_02.NOMBRECATEGORIA) NOMBRECATEGORIA,
                                isnull(VW_REPORTE__L1LIAB01_02.PAG_ANT_MAS_PAGADO_HOY -
                                    VW_REPORTE__L1LIAB01_01.PAG_ANT_MAS_PAGADO_HOY,
                                    VW_REPORTE__L1LIAB01_02.PAG_ANT_MAS_PAGADO_HOY) AS VALOR,
                                VW_REPORTE__L1LIAB01_02.SORTEO,
                                VW_REPORTE__L1LIAB01_02.NOMPRODUCTO
                           FROM (select *
                                   from WSXML_SFG.VW_REPORTE__L1LIAB01_02
                                  where (dbo.trunc_date(VW_REPORTE__L1LIAB01_02.FECHAHORAGENERACION) =
                                        CONVERT(DATETIME, CONVERT(DATE,@p_FECHA_02)))
                                    and VW_REPORTE__L1LIAB01_02.ID_CATEGORIA_ACIERTOS_L1LIAB01 in
                                        (@p_CATEGORIA3,
                                         @p_CATEGORIA4,
                                         @p_CATEGORIA5,
                                         @p_CATEGORIA6)) VW_REPORTE__L1LIAB01_02,
                                (select *
                                   from WSXML_SFG.VW_REPORTE__L1LIAB01_01
                                  where (dbo.trunc_date(VW_REPORTE__L1LIAB01_01.FECHAHORAGENERACION) =
                                        CONVERT(DATETIME, CONVERT(DATE,@p_FECHA_01-1)))
                                    and VW_REPORTE__L1LIAB01_01.ID_CATEGORIA_ACIERTOS_L1LIAB01 in
                                        (@p_CATEGORIA3,
                                         @p_CATEGORIA4,
                                         @p_CATEGORIA5,
                                         @p_CATEGORIA6)) VW_REPORTE__L1LIAB01_01
                          WHERE VW_REPORTE__L1LIAB01_02.SORTEO =
                                VW_REPORTE__L1LIAB01_01.SORTEO
                            AND VW_REPORTE__L1LIAB01_02.ID_SORTEO_L1LIAB01 <>
                                VW_REPORTE__L1LIAB01_01.ID_SORTEO_L1LIAB01
                            AND VW_REPORTE__L1LIAB01_02.ID_PRODUCTO =
                                VW_REPORTE__L1LIAB01_01.ID_PRODUCTO
                            AND VW_REPORTE__L1LIAB01_02.ID_CATEGORIA_ACIERTOS_L1LIAB01 =
                                VW_REPORTE__L1LIAB01_01.ID_CATEGORIA_ACIERTOS_L1LIAB01
                            AND VW_REPORTE__L1LIAB01_02.ID_CONTROL_L1LIAB01 <>
                                VW_REPORTE__L1LIAB01_01.ID_CONTROL_L1LIAB01
                            AND VW_REPORTE__L1LIAB01_02.FECHAHORAGENERACION >
                                VW_REPORTE__L1LIAB01_01.FECHAHORAGENERACION) T PIVOT(SUM(VALOR) FOR NOMBRECATEGORIA IN(['3 Aciertos de 6'], ['4 Aciertos de 6'], ['5 Aciertos de 6'],['6 Aciertos de 6'])) PIV ) T
         order by SORTEO desc;

    end
    else begin


        select *
          from (

                SELECT *

                  FROM (SELECT isnull(VW_REPORTE__L1LIAB01_01.NOMBRECATEGORIA,
                                    VW_REPORTE__L1LIAB01_02.NOMBRECATEGORIA) NOMBRECATEGORIA,
                                isnull(VW_REPORTE__L1LIAB01_02.PAG_ANT_MAS_PAGADO_HOY -
                                    VW_REPORTE__L1LIAB01_01.PAG_ANT_MAS_PAGADO_HOY,
                                    VW_REPORTE__L1LIAB01_02.PAG_ANT_MAS_PAGADO_HOY) AS VALOR,
                                VW_REPORTE__L1LIAB01_02.SORTEO,
                                VW_REPORTE__L1LIAB01_02.NOMPRODUCTO
                           FROM (select *
                                   from WSXML_SFG.VW_REPORTE__L1LIAB01_02
                                  where (dbo.trunc_date(VW_REPORTE__L1LIAB01_02.FECHAHORAGENERACION) =
                                        CONVERT(DATETIME, CONVERT(DATE,@p_FECHA_02)))
                                    and VW_REPORTE__L1LIAB01_02.ID_CATEGORIA_ACIERTOS_L1LIAB01 in
                                        (@p_CATEGORIA3,
                                         @p_CATEGORIA4,
                                         @p_CATEGORIA5,
                                         @p_CATEGORIA6)
                                    AND VW_REPORTE__L1LIAB01_02.ID_PRODUCTO =
                                        @p_PRODUCTO) VW_REPORTE__L1LIAB01_02,
                                (select *
                                   from WSXML_SFG.VW_REPORTE__L1LIAB01_01
                                  where (dbo.trunc_date(VW_REPORTE__L1LIAB01_01.FECHAHORAGENERACION) =
                                        CONVERT(DATETIME, CONVERT(DATE,@p_FECHA_01-1)))
                                    and VW_REPORTE__L1LIAB01_01.ID_CATEGORIA_ACIERTOS_L1LIAB01 in
                                        (@p_CATEGORIA3,
                                         @p_CATEGORIA4,
                                         @p_CATEGORIA5,
                                         @p_CATEGORIA6)
                                    AND VW_REPORTE__L1LIAB01_01.ID_PRODUCTO =
                                        @p_PRODUCTO) VW_REPORTE__L1LIAB01_01
                          WHERE VW_REPORTE__L1LIAB01_02.SORTEO =
                                VW_REPORTE__L1LIAB01_01.SORTEO
                            AND VW_REPORTE__L1LIAB01_02.ID_SORTEO_L1LIAB01 <>
                                VW_REPORTE__L1LIAB01_01.ID_SORTEO_L1LIAB01
                            AND VW_REPORTE__L1LIAB01_02.ID_PRODUCTO =
                                VW_REPORTE__L1LIAB01_01.ID_PRODUCTO
                            AND VW_REPORTE__L1LIAB01_02.ID_CATEGORIA_ACIERTOS_L1LIAB01 =
                                VW_REPORTE__L1LIAB01_01.ID_CATEGORIA_ACIERTOS_L1LIAB01
                            AND VW_REPORTE__L1LIAB01_02.ID_CONTROL_L1LIAB01 <>
                                VW_REPORTE__L1LIAB01_01.ID_CONTROL_L1LIAB01
                            AND VW_REPORTE__L1LIAB01_02.FECHAHORAGENERACION >
                                VW_REPORTE__L1LIAB01_01.FECHAHORAGENERACION) T PIVOT(SUM(VALOR) FOR NOMBRECATEGORIA IN(['3 Aciertos de 6'], ['4 Aciertos de 6'], ['5 Aciertos de 6'], ['6 Aciertos de 6'])) PIV ) T
         order by SORTEO desc;

    end 


  
  END
 GO



 IF EXISTS (SELECT * FROM sys.objects WHERE type_desc LIKE '%STORED_PROCEDURE' AND OBJECT_NAME(object_id) = 'SFGWEB_L1LIAB01_PopulateGRIDCarta')
	DROP PROCEDURE WSXML_SFG.SFGWEB_L1LIAB01_PopulateGRIDCarta;
GO

  CREATE PROCEDURE WSXML_SFG.SFGWEB_L1LIAB01_PopulateGRIDCarta(@p_CODCICLOFACTURACIONPDV FLOAT,
                              @p_CODLINEADENEGOCIO      FLOAT,
                              @p_CODTIPOPRODUCTO        FLOAT,
                              @pg_PRODUCTO              NVARCHAR(2000),
                              @pg_REDPDV                NVARCHAR(2000),
                              @pg_CADENA                NVARCHAR(2000)) AS
 BEGIN

    DECLARE @p_FECHA_01   DATETIME;
    DECLARE @p_FECHA_02   DATETIME;
    DECLARE @p_PRODUCTO   FLOAT = @pg_PRODUCTO;
    DECLARE @p_CATEGORIA3 FLOAT = 3;
    DECLARE @p_CATEGORIA4 FLOAT = 4;
    DECLARE @p_CATEGORIA5 FLOAT = 5;
    DECLARE @p_CATEGORIA6 FLOAT = 6;
   
  SET NOCOUNT ON;

    SELECT @p_FECHA_01 = MIN(CONVERT(DATETIME,A.FECHAARCHIVO))-1, @p_FECHA_02 = MAX(A.FECHAARCHIVO)
      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL A
     WHERE A.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
       AND A.FACTURADO = 1
       AND A.ACTIVE = 1
       AND A.TIPOARCHIVO = 2;

    SELECT @p_PRODUCTO = P.ID_PRODUCTO
      FROM WSXML_SFG.PRODUCTO P
     WHERE CONVERT(NUMERIC,P.CODIGOGTECHPRODUCTO) = CONVERT(NUMERIC,@pg_PRODUCTO)
       AND P.ACTIVE = 1;

    if @p_PRODUCTO = 0 begin


        select *
          from (

                SELECT *

                  FROM (SELECT isnull(VW_L1LIAB01_PREMIOSPAGOS01.NOMBRECATEGORIA,
                                    VW_L1LIAB01_PREMIOSPAGOS02.NOMBRECATEGORIA) NOMBRECATEGORIA,
                                case when isnull(VW_L1LIAB01_PREMIOSPAGOS02.PAG_ANT_MAS_PAGADO_HOY, 0) > 0 then
                                   isnull(VW_L1LIAB01_PREMIOSPAGOS02.PAG_ANT_MAS_PAGADO_HOY -
                                    VW_L1LIAB01_PREMIOSPAGOS01.PAG_ANT_MAS_PAGADO_HOY,
                                    VW_L1LIAB01_PREMIOSPAGOS02.PAG_ANT_MAS_PAGADO_HOY) end AS VALOR,
                                VW_L1LIAB01_PREMIOSPAGOS01.SORTEO,
                                VW_L1LIAB01_PREMIOSPAGOS02.NOMPRODUCTO,
								ROW_NUMBER() OVER(ORDER BY isnull(VW_L1LIAB01_PREMIOSPAGOS01.NOMBRECATEGORIA,
                                    VW_L1LIAB01_PREMIOSPAGOS02.NOMBRECATEGORIA)) rownum
                           FROM (select *
                                   from WSXML_SFG.VW_L1LIAB01_PREMIOSPAGOS02
                                  where (dbo.trunc_date(VW_L1LIAB01_PREMIOSPAGOS02.FECHAHORAGENERACION) =
                                        dbo.trunc_date(@p_FECHA_02))
                                        AND VW_L1LIAB01_PREMIOSPAGOS02.PAG_ANT_MAS_PAGADO_HOY > 0 
                                    and VW_L1LIAB01_PREMIOSPAGOS02.ID_CATEGORIA_ACIERTOS_L1LIAB01 in
                                        (@p_CATEGORIA3,
                                         @p_CATEGORIA4,
                                         @p_CATEGORIA5,
                                         @p_CATEGORIA6)) VW_L1LIAB01_PREMIOSPAGOS02,
                                (select *
                                   from WSXML_SFG.VW_L1LIAB01_PREMIOSPAGOS01
                                  where (dbo.trunc_date(VW_L1LIAB01_PREMIOSPAGOS01.FECHAHORAGENERACION) =
                                        dbo.trunc_date(@p_FECHA_01))
                                        
                                    and VW_L1LIAB01_PREMIOSPAGOS01.ID_CATEGORIA_ACIERTOS_L1LIAB01 in
                                        (@p_CATEGORIA3,
                                         @p_CATEGORIA4,
                                         @p_CATEGORIA5,
                                         @p_CATEGORIA6) 
                                    
                          ) VW_L1LIAB01_PREMIOSPAGOS01
                          WHERE VW_L1LIAB01_PREMIOSPAGOS02.SORTEO =
                                VW_L1LIAB01_PREMIOSPAGOS01.SORTEO
                            AND VW_L1LIAB01_PREMIOSPAGOS02.ID_SORTEO_L1LIAB01 <>
                                VW_L1LIAB01_PREMIOSPAGOS01.ID_SORTEO_L1LIAB01
                            AND VW_L1LIAB01_PREMIOSPAGOS02.ID_PRODUCTO =
                                VW_L1LIAB01_PREMIOSPAGOS01.ID_PRODUCTO
                            AND VW_L1LIAB01_PREMIOSPAGOS02.ID_CATEGORIA_ACIERTOS_L1LIAB01 =
                                VW_L1LIAB01_PREMIOSPAGOS01.ID_CATEGORIA_ACIERTOS_L1LIAB01
                            AND VW_L1LIAB01_PREMIOSPAGOS02.ID_CONTROL_L1LIAB01 <>
                                VW_L1LIAB01_PREMIOSPAGOS01.ID_CONTROL_L1LIAB01
                            AND VW_L1LIAB01_PREMIOSPAGOS02.FECHAHORAGENERACION >
                                VW_L1LIAB01_PREMIOSPAGOS01.FECHAHORAGENERACION
                            ) T PIVOT(SUM(VALOR) FOR NOMBRECATEGORIA IN(['3 Aciertos de 6'], ['4 Aciertos de 6'], ['5 Aciertos de 6'], ['6 Aciertos de 6'])) PIV ) T
         where rownum <= 50
         order by SORTEO desc;

    end
    else begin


        select *
          from (

                SELECT *

                  FROM (SELECT isnull(VW_L1LIAB01_PREMIOSPAGOS01.NOMBRECATEGORIA,
                                    VW_L1LIAB01_PREMIOSPAGOS02.NOMBRECATEGORIA) NOMBRECATEGORIA,
                                isnull(VW_L1LIAB01_PREMIOSPAGOS02.PAG_ANT_MAS_PAGADO_HOY -
                                    VW_L1LIAB01_PREMIOSPAGOS01.PAG_ANT_MAS_PAGADO_HOY,
                                    VW_L1LIAB01_PREMIOSPAGOS02.PAG_ANT_MAS_PAGADO_HOY) AS VALOR,
                                VW_L1LIAB01_PREMIOSPAGOS02.SORTEO,
                                VW_L1LIAB01_PREMIOSPAGOS02.NOMPRODUCTO,
								ROW_NUMBER() OVER(ORDER BY isnull(VW_L1LIAB01_PREMIOSPAGOS01.NOMBRECATEGORIA,
                                    VW_L1LIAB01_PREMIOSPAGOS02.NOMBRECATEGORIA)) rownum
                           FROM (select *
                                   from WSXML_SFG.VW_L1LIAB01_PREMIOSPAGOS02
                                  where (dbo.trunc_date(VW_L1LIAB01_PREMIOSPAGOS02.FECHAHORAGENERACION) =
                                        dbo.trunc_date(@p_FECHA_02))
                                    and VW_L1LIAB01_PREMIOSPAGOS02.ID_CATEGORIA_ACIERTOS_L1LIAB01 in
                                        (@p_CATEGORIA3,
                                         @p_CATEGORIA4,
                                         @p_CATEGORIA5,
                                         @p_CATEGORIA6)
                                    AND VW_L1LIAB01_PREMIOSPAGOS02.ID_PRODUCTO =
                                        @p_PRODUCTO) VW_L1LIAB01_PREMIOSPAGOS02,
                                (select *
                                   from WSXML_SFG.VW_L1LIAB01_PREMIOSPAGOS01
                                  where (dbo.trunc_date(VW_L1LIAB01_PREMIOSPAGOS01.FECHAHORAGENERACION) =
                                        dbo.trunc_date(@p_FECHA_01))
                                    and VW_L1LIAB01_PREMIOSPAGOS01.ID_CATEGORIA_ACIERTOS_L1LIAB01 in
                                        (@p_CATEGORIA3,
                                         @p_CATEGORIA4,
                                         @p_CATEGORIA5,
                                         @p_CATEGORIA6)
                                    AND VW_L1LIAB01_PREMIOSPAGOS01.ID_PRODUCTO =
                                        @p_PRODUCTO) VW_L1LIAB01_PREMIOSPAGOS01
                          WHERE VW_L1LIAB01_PREMIOSPAGOS02.SORTEO =
                                VW_L1LIAB01_PREMIOSPAGOS01.SORTEO
                            AND VW_L1LIAB01_PREMIOSPAGOS02.ID_SORTEO_L1LIAB01 <>
                                VW_L1LIAB01_PREMIOSPAGOS01.ID_SORTEO_L1LIAB01
                            AND VW_L1LIAB01_PREMIOSPAGOS02.ID_PRODUCTO =
                                VW_L1LIAB01_PREMIOSPAGOS01.ID_PRODUCTO
                            AND VW_L1LIAB01_PREMIOSPAGOS02.ID_CATEGORIA_ACIERTOS_L1LIAB01 =
                                VW_L1LIAB01_PREMIOSPAGOS01.ID_CATEGORIA_ACIERTOS_L1LIAB01
                            AND VW_L1LIAB01_PREMIOSPAGOS02.ID_CONTROL_L1LIAB01 <>
                                VW_L1LIAB01_PREMIOSPAGOS01.ID_CONTROL_L1LIAB01
                            AND VW_L1LIAB01_PREMIOSPAGOS02.FECHAHORAGENERACION >
                                VW_L1LIAB01_PREMIOSPAGOS01.FECHAHORAGENERACION
                            ) T PIVOT(SUM(VALOR) FOR NOMBRECATEGORIA IN(['3 Aciertos de 6'],['4 Aciertos de 6'],['5 Aciertos de 6'],['6 Aciertos de 6'])) PIV ) T
         where rownum <= 50
         order by SORTEO desc;

    end 

   
  END
GO



 IF EXISTS (SELECT * FROM sys.objects WHERE type_desc LIKE '%STORED_PROCEDURE' AND OBJECT_NAME(object_id) = 'SFGWEB_L1LIAB01_PopulateGRIDCartaResumen')
	DROP PROCEDURE WSXML_SFG.SFGWEB_L1LIAB01_PopulateGRIDCartaResumen;
GO

  
  CREATE PROCEDURE WSXML_SFG.SFGWEB_L1LIAB01_PopulateGRIDCartaResumen(@p_CODCICLOFACTURACIONPDV FLOAT,
                              @p_CODLINEADENEGOCIO      FLOAT,
                              @p_CODTIPOPRODUCTO        FLOAT,
                              @pg_PRODUCTO              NVARCHAR(2000),
                              @pg_REDPDV                NVARCHAR(2000),
                              @pg_CADENA                NVARCHAR(2000)) AS
 BEGIN

    DECLARE @p_FECHA_01   DATETIME;
    DECLARE @p_FECHA_02   DATETIME;
    DECLARE @p_PRODUCTO   FLOAT = @pg_PRODUCTO;
    DECLARE @p_CATEGORIA3 FLOAT = 3;
    DECLARE @p_CATEGORIA4 FLOAT = 4;
    DECLARE @p_CATEGORIA5 FLOAT = 5;
    DECLARE @p_CATEGORIA6 FLOAT = 6;
   
  SET NOCOUNT ON;

    SELECT @p_FECHA_01 = MIN(A.FECHAARCHIVO), @p_FECHA_02 = MAX(A.FECHAARCHIVO)
      FROM WSXML_SFG.ENTRADAARCHIVOCONTROL A
     WHERE A.CODCICLOFACTURACIONPDV = @p_CODCICLOFACTURACIONPDV
       AND A.FACTURADO = 1
       AND A.ACTIVE = 1
       AND A.TIPOARCHIVO = 2;

    SELECT @p_PRODUCTO = P.ID_PRODUCTO
      FROM PRODUCTO P
     WHERE CONVERT(NUMERIC,P.CODIGOGTECHPRODUCTO) = CONVERT(NUMERIC,@pg_PRODUCTO)
       AND P.ACTIVE = 1;

    if @p_PRODUCTO = 0 begin


        select *
          from (

                SELECT *

                  FROM (SELECT isnull(VW_L1LIAB01_PREMIOSPAGOS01.NOMBRECATEGORIA,
                                    VW_L1LIAB01_PREMIOSPAGOS02.NOMBRECATEGORIA) NOMBRECATEGORIA,
                                case when isnull(VW_L1LIAB01_PREMIOSPAGOS02.PAG_ANT_MAS_PAGADO_HOY, 0) > 0 then
                                   isnull(VW_L1LIAB01_PREMIOSPAGOS02.PAG_ANT_MAS_PAGADO_HOY -
                                    VW_L1LIAB01_PREMIOSPAGOS01.PAG_ANT_MAS_PAGADO_HOY,
                                    VW_L1LIAB01_PREMIOSPAGOS02.PAG_ANT_MAS_PAGADO_HOY) end AS VALOR,
                                VW_L1LIAB01_PREMIOSPAGOS01.SORTEO,
                                VW_L1LIAB01_PREMIOSPAGOS02.NOMPRODUCTO,
								ROW_NUMBER() OVER(ORDER BY isnull(VW_L1LIAB01_PREMIOSPAGOS01.NOMBRECATEGORIA,
                                    VW_L1LIAB01_PREMIOSPAGOS02.NOMBRECATEGORIA)) rownum
                           FROM (select *
                                   from WSXML_SFG.VW_L1LIAB01_PREMIOSPAGOS02
                                  where (dbo.trunc_date(VW_L1LIAB01_PREMIOSPAGOS02.FECHAHORAGENERACION) =
                                        dbo.trunc_date(@p_FECHA_02))
                                        AND VW_L1LIAB01_PREMIOSPAGOS02.PAG_ANT_MAS_PAGADO_HOY > 0 
                                    and VW_L1LIAB01_PREMIOSPAGOS02.ID_CATEGORIA_ACIERTOS_L1LIAB01 in
                                        (@p_CATEGORIA3,
                                         @p_CATEGORIA4,
                                         @p_CATEGORIA5,
                                         @p_CATEGORIA6)) VW_L1LIAB01_PREMIOSPAGOS02,
                                (select *
                                   from WSXML_SFG.VW_L1LIAB01_PREMIOSPAGOS01
                                  where (dbo.trunc_date(VW_L1LIAB01_PREMIOSPAGOS01.FECHAHORAGENERACION) =
                                        dbo.trunc_date(@p_FECHA_01))
                                        
                                    and VW_L1LIAB01_PREMIOSPAGOS01.ID_CATEGORIA_ACIERTOS_L1LIAB01 in
                                        (@p_CATEGORIA3,
                                         @p_CATEGORIA4,
                                         @p_CATEGORIA5,
                                         @p_CATEGORIA6) 
                                    
                          ) VW_L1LIAB01_PREMIOSPAGOS01
                          WHERE VW_L1LIAB01_PREMIOSPAGOS02.SORTEO =
                                VW_L1LIAB01_PREMIOSPAGOS01.SORTEO
                            AND VW_L1LIAB01_PREMIOSPAGOS02.ID_SORTEO_L1LIAB01 <>
                                VW_L1LIAB01_PREMIOSPAGOS01.ID_SORTEO_L1LIAB01
                            AND VW_L1LIAB01_PREMIOSPAGOS02.ID_PRODUCTO =
                                VW_L1LIAB01_PREMIOSPAGOS01.ID_PRODUCTO
                            AND VW_L1LIAB01_PREMIOSPAGOS02.ID_CATEGORIA_ACIERTOS_L1LIAB01 =
                                VW_L1LIAB01_PREMIOSPAGOS01.ID_CATEGORIA_ACIERTOS_L1LIAB01
                            AND VW_L1LIAB01_PREMIOSPAGOS02.ID_CONTROL_L1LIAB01 <>
                                VW_L1LIAB01_PREMIOSPAGOS01.ID_CONTROL_L1LIAB01
                            AND VW_L1LIAB01_PREMIOSPAGOS02.FECHAHORAGENERACION >
                                VW_L1LIAB01_PREMIOSPAGOS01.FECHAHORAGENERACION
                            ) T PIVOT(SUM(VALOR) FOR NOMBRECATEGORIA IN(['3 Aciertos de 6'], ['4 Aciertos de 6'], ['5 Aciertos de 6'], ['6 Aciertos de 6'])) PIV ) T
         where rownum <= 50
         order by SORTEO desc;

    end
    else begin


        select *
          from (

                SELECT *

                  FROM (SELECT isnull(VW_L1LIAB01_PREMIOSPAGOS01.NOMBRECATEGORIA,
                                    VW_L1LIAB01_PREMIOSPAGOS02.NOMBRECATEGORIA) NOMBRECATEGORIA,
                                isnull(VW_L1LIAB01_PREMIOSPAGOS02.PAG_ANT_MAS_PAGADO_HOY -
                                    VW_L1LIAB01_PREMIOSPAGOS01.PAG_ANT_MAS_PAGADO_HOY,
                                    VW_L1LIAB01_PREMIOSPAGOS02.PAG_ANT_MAS_PAGADO_HOY) AS VALOR,
                                VW_L1LIAB01_PREMIOSPAGOS02.SORTEO,
                                VW_L1LIAB01_PREMIOSPAGOS02.NOMPRODUCTO,
								ROW_NUMBER() OVER(ORDER BY isnull(VW_L1LIAB01_PREMIOSPAGOS01.NOMBRECATEGORIA,
                                    VW_L1LIAB01_PREMIOSPAGOS02.NOMBRECATEGORIA)) rownum
                           FROM (select *
                                   from WSXML_SFG.VW_L1LIAB01_PREMIOSPAGOS02
                                  where (dbo.trunc_date(VW_L1LIAB01_PREMIOSPAGOS02.FECHAHORAGENERACION) =
                                        dbo.trunc_date(@p_FECHA_02))
                                    and VW_L1LIAB01_PREMIOSPAGOS02.ID_CATEGORIA_ACIERTOS_L1LIAB01 in
                                        (@p_CATEGORIA3,
                                         @p_CATEGORIA4,
                                         @p_CATEGORIA5,
                                         @p_CATEGORIA6)
                                    AND VW_L1LIAB01_PREMIOSPAGOS02.ID_PRODUCTO =
                                        @p_PRODUCTO) VW_L1LIAB01_PREMIOSPAGOS02,
                                (select *
                                   from WSXML_SFG.VW_L1LIAB01_PREMIOSPAGOS01
                                  where (dbo.trunc_date(VW_L1LIAB01_PREMIOSPAGOS01.FECHAHORAGENERACION) =
                                        dbo.trunc_date(@p_FECHA_01))
                                    and VW_L1LIAB01_PREMIOSPAGOS01.ID_CATEGORIA_ACIERTOS_L1LIAB01 in
                                        (@p_CATEGORIA3,
                                         @p_CATEGORIA4,
                                         @p_CATEGORIA5,
                                         @p_CATEGORIA6)
                                    AND VW_L1LIAB01_PREMIOSPAGOS01.ID_PRODUCTO =
                                        @p_PRODUCTO) VW_L1LIAB01_PREMIOSPAGOS01
                          WHERE VW_L1LIAB01_PREMIOSPAGOS02.SORTEO =
                                VW_L1LIAB01_PREMIOSPAGOS01.SORTEO
                            AND VW_L1LIAB01_PREMIOSPAGOS02.ID_SORTEO_L1LIAB01 <>
                                VW_L1LIAB01_PREMIOSPAGOS01.ID_SORTEO_L1LIAB01
                            AND VW_L1LIAB01_PREMIOSPAGOS02.ID_PRODUCTO =
                                VW_L1LIAB01_PREMIOSPAGOS01.ID_PRODUCTO
                            AND VW_L1LIAB01_PREMIOSPAGOS02.ID_CATEGORIA_ACIERTOS_L1LIAB01 =
                                VW_L1LIAB01_PREMIOSPAGOS01.ID_CATEGORIA_ACIERTOS_L1LIAB01
                            AND VW_L1LIAB01_PREMIOSPAGOS02.ID_CONTROL_L1LIAB01 <>
                                VW_L1LIAB01_PREMIOSPAGOS01.ID_CONTROL_L1LIAB01
                            AND VW_L1LIAB01_PREMIOSPAGOS02.FECHAHORAGENERACION >
                                VW_L1LIAB01_PREMIOSPAGOS01.FECHAHORAGENERACION
                            ) T PIVOT(SUM(VALOR) FOR NOMBRECATEGORIA IN(['3 Aciertos de 6'], ['4 Aciertos de 6'], ['5 Aciertos de 6'],['6 Aciertos de 6'])) PIV ) T
         where rownum <= 50
         order by SORTEO desc;

    end 

   
  END
GO
 


IF OBJECT_ID('WSXML_SFG.SFGWEB_L1LIAB01_GetResumenPremiosL1liab60', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEB_L1LIAB01_GetResumenPremiosL1liab60;
GO


CREATE PROCEDURE WSXML_SFG.SFGWEB_L1LIAB01_GetResumenPremiosL1liab60(@pCodCicloFacturacionPDV float,
                                     @pPeriodoPremioPAgado float) as
 begin 
    declare @v_sql VARCHAR(MAX);
    declare @v_nomcategoria VARCHAR(MAX);
  
 set nocount on;
    /*
	select 
    listagg('''' + ISNULL(NOMBRECATEGORIA, '') + '''', ',') within group (ORDER BY DIVISION, ID_CATEGORIASORTEO) 
    into @v_nomcategoria 
    from categoriasorteo;
	*/


	SELECT  @v_nomcategoria = STUFF(( SELECT  ','+ NOMBRECATEGORIA FROM WSXML_SFG.categoriasorteo a
	WHERE b.NOMBRECATEGORIA = a.NOMBRECATEGORIA FOR XML PATH('')),1 ,1, '')--  Members
	FROM WSXML_SFG.categoriasorteo b
	ORDER BY DIVISION, ID_CATEGORIASORTEO
          
           set @v_sql = '
           select * from (
			select * from (
              select   p.nomproducto as Producto, 
              c.nombrecategoria as categoria, 
              case when ' + ISNULL(@pPeriodoPremioPAgado, '') + ' = WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER(''PremiosVencidosDosMeses'') -1 then 
              l.premiospagadoshoy when ' + ISNULL(@pPeriodoPremioPAgado, '') + ' = WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER(''PremiosVencidosUnAno'')-1 then 
              l.premiospagadoshoymayor60 end
               as pagadoshoymenores,
			   ROW_NUMBER() OVER(order by producto) AS RowNumber
              from WSXML_SFG.l1liabtotalesporproducto l
              inner join WSXML_SFG.producto p on id_producto = codproducto 
              inner join WSXML_SFG.categoriasorteo c on c.id_categoriasorteo = l.codcategoria
              inner join WSXML_SFG.controlpremiosl1liab cl on cl.id_controlpremiosl1liab = l.codcontroll1liab
              inner join WSXML_SFG.entradaarchivocontrol e on e.fechaarchivo  = cl.fechareporte
              where e.codciclofacturacionpdv = '+ISNULL(@pCodCicloFacturacionPDV, '') +'  and e.tipoarchivo = 2
              --group by p.nomproducto, c.nombrecategoria
              --order by producto
			  ) s
			) s
            pivot(sum(pagadoshoymenores) for categoria in (' + isnull(@v_nomcategoria, '') + ')) PIV ';
            
            
            
            execute sp_executesql @v_sql
    
 end;
GO



IF OBJECT_ID('WSXML_SFG.SFGWEB_L1LIAB01_GetDetallePremiospagados', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEB_L1LIAB01_GetDetallePremiospagados;
GO


create procedure WSXML_SFG.SFGWEB_L1LIAB01_GetDetallePremiospagados(@pCodCicloFacturacionPDV float,
                                     @pCodProducto            float,
                                     @pPeriodoPremioPAgado    float) as
 begin
    declare @v_sql VARCHAR(MAX);
    declare @v_nomcategoria VARCHAR(MAX);
  
 set nocount on;

		SELECT  @v_nomcategoria = STUFF(( SELECT  ','+ NOMBRECATEGORIA FROM WSXML_SFG.categoriasorteo a
		WHERE b.NOMBRECATEGORIA = a.NOMBRECATEGORIA FOR XML PATH('')),1 ,1, '')--  Members
		FROM WSXML_SFG.categoriasorteo b
		ORDER BY DIVISION, ID_CATEGORIASORTEO

          
           set @v_sql = 'select * from (select * from (
              select   ps.sorteo,
              c.nombrecategoria as categoria, 
              case when ' + ISNULL(@pPeriodoPremioPAgado, '') + ' = WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER(''PremiosVencidosDosMeses'') -1 then 
              ps.premiospagadoshoy when ' + ISNULL(@pPeriodoPremioPAgado, '') + ' = WSXML_SFG.SFGINF_CARTASFIDUCIA_PARAMETRO_NUMBER(''PremiosVencidosUnAno'')-1 then 
              ps.premiospagadoshoymayor60 end as pagadoshoy
			  , ROW_NUMBER() OVER(order by Sorteo desc) AS "Row Number"
              from WSXML_SFG.l1liabtotalesporproducto l
              inner join WSXML_SFG.l1liabpremiosporsorteo ps on ps.codl1liabtotalespremios = l.id_l1liabtotalesporproducto
              inner join WSXML_SFG.producto p on id_producto = codproducto 
              inner join WSXML_SFG.categoriasorteo c on c.id_categoriasorteo = l.codcategoria
              inner join WSXML_SFG.controlpremiosl1liab cl on cl.id_controlpremiosl1liab = l.codcontroll1liab
              inner join WSXML_SFG.entradaarchivocontrol e on e.fechaarchivo  = cl.fechareporte
              where e.codciclofacturacionpdv = ' + ISNULL(@pCodCicloFacturacionPDV, '') + ' and codproducto = ' + ISNULL(@pCodProducto, '') + '  and e.tipoarchivo = 2
              --group by p.nomproducto, c.nombrecategoria
              --order by Sorteo desc
			  )s )s
            pivot(sum(pagadoshoy) for categoria in (' + isnull(@v_nomcategoria, '') + ')) PIV order by sorteo';
            
             execute sp_executesql @v_sql
  end;  
  GO
  
  
  
IF OBJECT_ID('WSXML_SFG.SFGWEB_L1LIAB01_GetDetallePremiosconfiltros', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEB_L1LIAB01_GetDetallePremiosconfiltros;
GO



   create procedure WSXML_SFG.SFGWEB_L1LIAB01_GetDetallePremiosconfiltros(@pCodProducto                 float,
                                         @pFechadesde                  datetime,
                                         @pFechaHasta                  datetime,
                                         @pTipoConsulta                varchar(4000),
                                         @pCategorias                  varchar(4000)) as
 begin
    declare @v_sql NVARCHAR(MAX);
    declare @v_nomcategoria VARCHAR(MAX);
    declare @vcodproductos varchar(2000);
  
 set nocount on;
       
    --Lista productos a consultar
    if @pCodProducto = 0 begin

		  SELECT  @vcodproductos = STUFF(( SELECT  ','+ codproducto FROM (select distinct codproducto from  WSXML_SFG.producto_l1shrclc) a
				WHERE b.codproducto = a.codproducto FOR XML PATH('')),1 ,1, '')--  Members
		  FROM (select distinct codproducto from  WSXML_SFG.producto_l1shrclc) b

     end
     else begin
            set @vcodproductos= @pCodProducto;
     end 
             
          
    
    
           set @v_sql = 'select * from (select * from (
              select  CONVERT(VARCHAR,ps.sorteo) as sorteo,p.nomproducto as Producto,
              c.nombrecategoria as categoria, 
              case when ' +ISNULL(@pTipoConsulta, '') + ' = SFGINF_CARTASFIDUCIA.PARAMETRO_NUMBER(''PremiosVencidosDosMeses'') -1 then 
              ps.premiospagadoshoy when ' + ISNULL(@pTipoConsulta, '') + ' = SFGINF_CARTASFIDUCIA.PARAMETRO_NUMBER(''PremiosVencidosUnAno'')-1 then 
              ps.premiospagadoshoymayor60 when '+ isnull(@pTipoConsulta, '') + ' = SFGINF_CARTASFIDUCIA.PARAMETRO_NUMBER(''PremiosVencidosUnAno'') then
              ps.premioscaducosmayor365 else ps.premiospagadoshoy + ps.premiospagadoshoymayor60
               end as pagadoshoy
			   , ROW_NUMBER() OVER(order by Sorteo desc) AS "Row Number"
              from WSXML_SFG.l1liabtotalesporproducto l
              inner join WSXML_SFG.l1liabpremiosporsorteo ps on ps.codl1liabtotalespremios = l.id_l1liabtotalesporproducto
              inner join WSXML_SFG.producto p on id_producto = codproducto 
              inner join WSXML_SFG.categoriasorteo c on c.id_categoriasorteo = l.codcategoria
              inner join WSXML_SFG.controlpremiosl1liab cl on cl.id_controlpremiosl1liab = l.codcontroll1liab
              inner join WSXML_SFG.entradaarchivocontrol e on e.fechaarchivo  = cl.fechareporte
              where e.fechaarchivo between ''' + isnull(@pFechadesde, '') + ''' and ''' + isnull(@pFechaHasta, '') + ''' 
              and e.tipoarchivo = 2
              and codproducto in (select regexp_substr('''+isnull(@vcodproductos, '')+''' ,''[^,]+'', 1, level)
              connect by regexp_substr('''+isnull(@vcodproductos, '')+''' , ''[^,]+'', 1, level) is not null)
              --group by p.nomproducto, c.nombrecategoria
              )s ) s
            pivot(sum(pagadoshoy) for categoria in (' + ISNULL(@pCategorias, '') + ')) PIV order by sorteo desc';
            
             execute sp_executesql @v_sql
  end;
GO

