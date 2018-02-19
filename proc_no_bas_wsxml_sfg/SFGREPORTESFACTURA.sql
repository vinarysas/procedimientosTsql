USE SFGPRODU;
--  DDL for Package Body SFGREPORTESFACTURA
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGREPORTESFACTURA */ 

  IF OBJECT_ID('WSXML_SFG.SFGREPORTESFACTURA_Ventas', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREPORTESFACTURA_Ventas;
GO

CREATE     PROCEDURE WSXML_SFG.SFGREPORTESFACTURA_Ventas(@p_CODREDPDV             NUMERIC(22,0),
                  @p_GROUPCODREDPDV        NUMERIC(22,0),
                  @p_CODPUNTODEVENTA       NUMERIC(22,0),
                  @p_GROUPPUNTODEVENTA     NUMERIC(22,0),
                  @p_CODCADENA             NUMERIC(22,0),
                  @p_GROUPCODCADENA        NUMERIC(22,0),
                  @p_CODGTECH              NUMERIC(22,0),
                  @p_GROUPCODGTECH         NUMERIC(22,0),
                  @p_CODDEPTO              NUMERIC(22,0),
                  @p_GROUPCODDEPTO         NUMERIC(22,0),
                  @p_CODCIUDAD             NUMERIC(22,0),
                 @p_GROUPCODCIUDAD        NUMERIC(22,0)) AS
 BEGIN
  DECLARE @StrSqlCampos            VARCHAR(1000) = 'Select rf.ValorTransaccion vlrtran,rf.ValorComision vlrcomi,rf.ValorVentaBruta vlrbruta ';
  DECLARE @StrSqlInner             VARCHAR(1000) = '';
  DECLARE @StrSqlGrupos            VARCHAR(1000) = ' ';
  DECLARE @StrSqlTablas            VARCHAR(1000) = ' From WSXML_SFG.REGISTROFACTURACION rf ';
  DECLARE @StrSqlWhere             VARCHAR(1000) = ' Where ';
  DECLARE @StrSqlFinal             VARCHAR(MAX) = '';
   
  SET NOCOUNT ON;
    /* TODO implementation required */

        /*campos*/
        IF @p_CODREDPDV > -2 BEGIN
          SET @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' INNER JOIN WSXML_SFG.PUNTODEVENTA pdv';
          SET @StrSqlInner  = ' ON rf.CODPUNTODEVENTA = pdv.ID_PUNTODEVENTA';
          SET @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
          SET @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' INNER JOIN WSXML_SFG.REDPDV r';
          SET @StrSqlInner  = ' ON pdv.CODREDPDV = r.ID_REDPDV';
          SET @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
          /*Filtro Where*/
          IF Len(@StrSqlWhere) = 7 BEGIN
            IF @p_CODREDPDV =-1 BEGIN
                SET @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' r.ID_REDPDV>'+ISNULL(@p_CODREDPDV, '');
            END
            ELSE BEGIN
                SET @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' r.ID_REDPDV='+ISNULL(@p_CODREDPDV, '');
            END 
          END
          ELSE BEGIN
            IF @p_CODREDPDV =-1 BEGIN
                SET @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND r.ID_REDPDV>'+ISNULL(@p_CODREDPDV, '');
            END
            ELSE BEGIN
                SET @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND r.ID_REDPDV='+ISNULL(@p_CODREDPDV, '');
            END 
          END 
        END 

        IF @p_CODPUNTODEVENTA > -2 BEGIN
          IF @StrSqlTablas not like '%PUNTODEVENTA%'BEGIN
            SET @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' INNER JOIN WSXML_SFG.PUNTODEVENTA pdv';
            SET @StrSqlInner  = ' ON rf.CODPUNTODEVENTA = pdv.ID_PUNTODEVENTA';
            SET @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
          END 
          /*Filtro Where*/
          IF Len(@StrSqlWhere) = 7 BEGIN
            IF @p_CODPUNTODEVENTA =-1 BEGIN
            SET @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' pdv.ID_PUNTODEVENTA>'+ISNULL(@p_CODPUNTODEVENTA, '');
            END
            ELSE BEGIN
            SET @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' pdv.ID_PUNTODEVENTA='+ISNULL(@p_CODPUNTODEVENTA, '');
            END 
          END
          ELSE BEGIN
            IF @p_CODPUNTODEVENTA =-1 BEGIN
            SET @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND pdv.ID_PUNTODEVENTA>'+ISNULL(@p_CODPUNTODEVENTA, '');
            END
            ELSE BEGIN
            SET @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND pdv.ID_PUNTODEVENTA='+ISNULL(@p_CODPUNTODEVENTA, '');
            END 
          END 
        END 

        IF @p_CODCADENA > -2 BEGIN
          IF @StrSqlTablas not like '%PUNTODEVENTA%'BEGIN
            SET @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' INNER JOIN WSXML_SFG.PUNTODEVENTA pdv';
            SET @StrSqlInner  = ' ON rf.CODPUNTODEVENTA = pdv.ID_PUNTODEVENTA';
            SET @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
          END 
          IF @StrSqlTablas not like '%CONTRATO%'BEGIN
            SET @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' INNER JOIN WSXML_SFG.CONTRATO c';
            SET @StrSqlInner  = ' ON pdv.CODCONTRATO = c.ID_CONTRATO';
            SET @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
          END 
          /*Filtro Where*/
          IF Len(@StrSqlWhere) = 7 BEGIN
            IF @p_CODCADENA =-1 BEGIN
                SET @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' c.CODAGRUPACIONPUNTODEVENTA>'+ISNULL(@p_CODCADENA, '');
            END
            ELSE BEGIN
                SET @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' c.CODAGRUPACIONPUNTODEVENTA='+ISNULL(@p_CODCADENA, '');
            END 
          END
          ELSE BEGIN
            IF @p_CODCADENA =-1 BEGIN
                SET @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND c.CODAGRUPACIONPUNTODEVENTA>'+ISNULL(@p_CODCADENA, '');
            END
            ELSE BEGIN
                SET @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND c.CODAGRUPACIONPUNTODEVENTA='+ISNULL(@p_CODCADENA, '');
            END 
          END 
        END 

        IF @p_CODGTECH > -2 BEGIN
          IF @StrSqlTablas not like '%PUNTODEVENTA%'BEGIN
            SET @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' INNER JOIN WSXML_SFG.PUNTODEVENTA pdv';
            SET @StrSqlInner  = ' ON rf.CODPUNTODEVENTA = pdv.ID_PUNTODEVENTA';
            SET @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
          END 
          /*Filtro Where*/
          IF Len(@StrSqlWhere) = 7 BEGIN
            IF @p_CODGTECH =-1 BEGIN
                SET @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' pdv.CODIGOGTECHPUNTODEVENTA>'+ISNULL(@p_CODGTECH, '');
            END
            ELSE BEGIN
                SET @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' pdv.CODIGOGTECHPUNTODEVENTA='+ISNULL(@p_CODGTECH, '');
            END 
          END
          ELSE BEGIN
            IF @p_CODGTECH =-1 BEGIN
                SET @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND pdv.CODIGOGTECHPUNTODEVENTA>'+ISNULL(@p_CODGTECH, '');
            END
            ELSE BEGIN
                SET @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND pdv.CODIGOGTECHPUNTODEVENTA='+ISNULL(@p_CODGTECH, '');
            END 
          END 
        END 



        IF @p_CODCIUDAD > -2 BEGIN
          IF @StrSqlTablas not like '%PUNTODEVENTA%'BEGIN
            SET @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' INNER JOIN WSXML_SFG.PUNTODEVENTA pdv';
            SET @StrSqlInner  = ' ON rf.CODPUNTODEVENTA = pdv.ID_PUNTODEVENTA';
            SET @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
          END 
          IF @StrSqlTablas not like '%CIUDAD%'BEGIN
            SET @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' INNER JOIN WSXML_SFG.CIUDAD mun';
            SET @StrSqlInner  = ' ON pdv.CODCIUDAD = mun.ID_CIUDAD';
            SET @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
          END 
          /*Filtro Where*/
          IF Len(@StrSqlWhere) = 7 BEGIN
            IF @p_CODCIUDAD =-1 BEGIN
                SET @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mun.ID_CIUDAD>'+ISNULL(@p_CODCIUDAD, '');
            END
            ELSE BEGIN
                SET @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mun.ID_CIUDAD='+ISNULL(@p_CODCIUDAD, '');
            END 
          END
          ELSE BEGIN
            IF @p_CODCIUDAD =-1 BEGIN
                SET @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND mun.ID_CIUDAD>'+ISNULL(@p_CODCIUDAD, '');
            END
            ELSE BEGIN
                SET @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND mun.ID_CIUDAD='+ISNULL(@p_CODCIUDAD, '');
            END 
          END 
        END 

        /*grupos*/
        IF @p_GROUPCODREDPDV = -1 BEGIN
          IF @StrSqlCampos not like '%pdv.CODREDPDV%'BEGIN
            SET @StrSqlCampos = ISNULL(@StrSqlCampos, '') +',';
            SET @StrSqlCampos = ISNULL(@StrSqlCampos, '') +' pdv.CODREDPDV';
          END 
          IF  Len(@StrSqlGrupos) < 2 BEGIN
            SET @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +' Group by pdv.CODREDPDV';
          END 
          IF @StrSqlGrupos not like '%pdv.CODREDPDV%'BEGIN
            SET @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +',';
            SET @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') + ' pdv.CODREDPDV';
          END 
          SET @StrSqlCampos =  replace(@StrSqlCampos,'rf.ValorTransaccion vlrtran','sum(rf.ValorTransaccion) vlrtran');
          SET @StrSqlCampos =  replace(@StrSqlCampos,'rf.ValorComision vlrcomi','sum(rf.ValorComision) vlrcomi');
          SET @StrSqlCampos =  replace(@StrSqlCampos,'rf.ValorVentaBruta vlrbruta ','sum(rf.ValorVentaBruta) vlrbruta');
        END 

        IF @p_GROUPPUNTODEVENTA = -1 BEGIN
          IF @StrSqlCampos not like '%pdv.ID_PUNTODEVENTA%'BEGIN
            SET @StrSqlCampos = ISNULL(@StrSqlCampos, '') +',';
            SET @StrSqlCampos = ISNULL(@StrSqlCampos, '') +' pdv.ID_PUNTODEVENTA';
          END 
          IF  Len(@StrSqlGrupos) < 2 BEGIN
            SET @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +' Group by pdv.ID_PUNTODEVENTA';
          END 
          IF @StrSqlGrupos not like '%pdv.ID_PUNTODEVENTA%'BEGIN
            SET @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +',';
            SET @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') + ' pdv.ID_PUNTODEVENTA';
          END 
          SET @StrSqlCampos =  replace(@StrSqlCampos,'rf.ValorTransaccion vlrtran','sum(rf.ValorTransaccion) vlrtran');
          SET @StrSqlCampos =  replace(@StrSqlCampos,'rf.ValorComision vlrcomi','sum(rf.ValorComision) vlrcomi');
          SET @StrSqlCampos =  replace(@StrSqlCampos,'rf.ValorVentaBruta vlrbruta ','sum(rf.ValorVentaBruta) vlrbruta');
        END 

        IF @p_GROUPCODCADENA = -1 BEGIN
          IF @StrSqlCampos not like '%c.CODAGRUPACIONPUNTODEVENTA%'BEGIN
          SET @StrSqlCampos = ISNULL(@StrSqlCampos, '') +',';
          SET @StrSqlCampos = ISNULL(@StrSqlCampos, '') +' c.CODAGRUPACIONPUNTODEVENTA';
          END 
          IF  Len(@StrSqlGrupos) < 2 BEGIN
          SET @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +' Group by c.CODAGRUPACIONPUNTODEVENTA';
          END 
          IF @StrSqlGrupos not like '%c.CODAGRUPACIONPUNTODEVENTA%'BEGIN
          SET @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +',';
          SET @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') + ' c.CODAGRUPACIONPUNTODEVENTA';
          END 
          SET @StrSqlCampos =  replace(@StrSqlCampos,'rf.ValorTransaccion vlrtran','sum(rf.ValorTransaccion) vlrtran');
          SET @StrSqlCampos =  replace(@StrSqlCampos,'rf.ValorComision vlrcomi','sum(rf.ValorComision) vlrcomi');
          SET @StrSqlCampos =  replace(@StrSqlCampos,'rf.ValorVentaBruta vlrbruta ','sum(rf.ValorVentaBruta) vlrbruta');
        END 


        IF @p_GROUPCODGTECH = -1 BEGIN
          IF @StrSqlCampos not like '%pdv.CODIGOGTECHPUNTODEVENTA%'BEGIN
            SET @StrSqlCampos = ISNULL(@StrSqlCampos, '') +',';
            SET @StrSqlCampos = ISNULL(@StrSqlCampos, '') +' pdv.CODIGOGTECHPUNTODEVENTA';
          END 
          IF  Len(@StrSqlGrupos) < 2 BEGIN
            SET @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +' Group by pdv.CODIGOGTECHPUNTODEVENTA';
          END 
          IF @StrSqlGrupos not like '%pdv.CODIGOGTECHPUNTODEVENTA%'BEGIN
            SET @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +',';
            SET @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') + ' pdv.CODIGOGTECHPUNTODEVENTA';
          END 
          SET @StrSqlCampos =  replace(@StrSqlCampos,'rf.ValorTransaccion vlrtran','sum(rf.ValorTransaccion) vlrtran');
          SET @StrSqlCampos =  replace(@StrSqlCampos,'rf.ValorComision vlrcomi','sum(rf.ValorComision) vlrcomi');
          SET @StrSqlCampos =  replace(@StrSqlCampos,'rf.ValorVentaBruta vlrbruta ','sum(rf.ValorVentaBruta) vlrbruta');
        END 

        IF @p_GROUPCODCIUDAD = -1 BEGIN
          IF @StrSqlCampos not like '%mun.ID_CIUDAD%'BEGIN
            SET @StrSqlCampos = ISNULL(@StrSqlCampos, '') +',';
            SET @StrSqlCampos = ISNULL(@StrSqlCampos, '') +' mun.ID_CIUDAD';
          END 
          IF  Len(@StrSqlGrupos) < 2 BEGIN
            SET @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +' Group by mun.ID_CIUDAD';
          END 
          IF @StrSqlGrupos not like '%mun.ID_CIUDAD%'BEGIN
            SET @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +',';
            SET @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') + ' mun.ID_CIUDAD';
          END 
          SET @StrSqlCampos =  replace(@StrSqlCampos,'rf.ValorTransaccion vlrtran','sum(rf.ValorTransaccion) vlrtran');
          SET @StrSqlCampos =  replace(@StrSqlCampos,'rf.ValorComision vlrcomi','sum(rf.ValorComision) vlrcomi');
          SET @StrSqlCampos =  replace(@StrSqlCampos,'rf.ValorVentaBruta vlrbruta ','sum(rf.ValorVentaBruta) vlrbruta');
        END 


        /*tratamiento de sql*/
        IF  Len(@StrSqlWhere) = 7 BEGIN
            SET @StrSqlWhere = ' ';
        END 
        SET @StrSqlFinal = ISNULL(@StrSqlCampos, '') + ISNULL(@StrSqlTablas, '') + ISNULL(@StrSqlWhere, '') + ISNULL(@StrSqlGrupos, '');
        execute  (@StrSqlFinal);

  END
GO

  IF OBJECT_ID('WSXML_SFG.SFGREPORTESFACTURA_ConsolidacionTransacciones', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREPORTESFACTURA_ConsolidacionTransacciones;
GO
  CREATE PROCEDURE WSXML_SFG.SFGREPORTESFACTURA_ConsolidacionTransacciones(@p_CODCICLOFACT          NUMERIC(22,0),
                  @p_GROUPCODCICLOFACT     NUMERIC(22,0),
                  @p_CODPUNTODEVENTA       NUMERIC(22,0),
                  @p_GROUPPUNTODEVENTA     NUMERIC(22,0),
                  @p_CODLINEANEGOCIO       NUMERIC(22,0),
                  @p_GROUPLINEANEGOCIO     NUMERIC(22,0),
                  @p_CODCIUDAD             NUMERIC(22,0),
                 @p_GROUPCODCIUDAD        NUMERIC(22,0)) as
 begin
  declare @StrSqlCampos            VARCHAR(1000) = 'select pdv.nompuntodeventa,m.codpuntodeventa,m.codciclofacturacionpdv,
  m.codlineadenegocio,l.nomlineadenegocio,m.saldoanteriorencontragtech,m.saldoanteriorencontrafiducia,
  m.saldoanteriorafavorgtech,m.saldoanteriorafavorfiducia,m.nuevosaldoencontragtech,
  m.nuevosaldoencontrafiducia,m.nuevosaldoafavorgtech,m.nuevosaldoafavorfiducia';
  declare @StrSqlInner             VARCHAR(1000) = ' ';
  declare @StrSqlGrupos            VARCHAR(1000) = ' ';
  declare @StrSqlTablas            VARCHAR(1000) = ' from WSXML_SFG.maestrofacturacionpdv m inner join WSXML_SFG.puntodeventa pdv
  on m.codpuntodeventa = pdv.id_puntodeventa inner join WSXML_SFG.lineadenegocio l on m.codlineadenegocio =  l.id_lineadenegocio ';
  declare @StrSqlWhere             VARCHAR(1000) = ' Where ';
  declare @StrSqlFinal             VARCHAR(MAX) = '';
  declare @CursorTmp               VARCHAR(MAX);
  --declare @e_errorpropio     EXCEPTION;
 
SET NOCOUNT ON;
/*campos*/
  IF @p_CODCICLOFACT > -2 BEGIN
    set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' INNER JOIN WSXML_SFG.ciclofacturacionpdv c';
    set @StrSqlInner  = ' ON  m.codciclofacturacionpdv = c.id_ciclofacturacionpdv';
    set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
    /*Filtro Where*/
    IF Len(@StrSqlWhere) = 7 BEGIN
      IF @p_CODCICLOFACT =-1 BEGIN
          set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' m.codciclofacturacionpdv>'+ISNULL(@p_CODCICLOFACT, '');
      END
      ELSE BEGIN
          set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' m.codciclofacturacionpdv='+ISNULL(@p_CODCICLOFACT, '');
      END 
    END
    ELSE BEGIN
      IF @p_CODCICLOFACT =-1 BEGIN
          set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' m.codciclofacturacionpdv>'+ISNULL(@p_CODCICLOFACT, '');
      END
      ELSE BEGIN
          set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' m.codciclofacturacionpdv='+ISNULL(@p_CODCICLOFACT, '');
      END 
    END 
  END 

  IF @p_CODPUNTODEVENTA > -2 BEGIN
    IF @StrSqlTablas not like '%puntodeventa%'BEGIN
      set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' inner join WSXML_SFG.puntodeventa pdv';
      set @StrSqlInner  = ' ON m.CODPUNTODEVENTA = pdv.ID_PUNTODEVENTA';
      set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
    END 
    /*Filtro Where*/
    IF Len(@StrSqlWhere) = 7 BEGIN
      IF @p_CODPUNTODEVENTA =-1 BEGIN
      set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' m.CODPUNTODEVENTA>'+ISNULL(@p_CODPUNTODEVENTA, '');
      END
      ELSE BEGIN
      set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' m.CODPUNTODEVENTA='+ISNULL(@p_CODPUNTODEVENTA, '');
      END 
    END
    ELSE BEGIN
      IF @p_CODPUNTODEVENTA =-1 BEGIN
      set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND m.CODPUNTODEVENTA>'+ISNULL(@p_CODPUNTODEVENTA, '');
      END
      ELSE BEGIN
      set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND m.CODPUNTODEVENTA='+ISNULL(@p_CODPUNTODEVENTA, '');
      END 
    END 
  END 

  IF @p_CODLINEANEGOCIO > -2 BEGIN
    IF @StrSqlTablas not like '%lineadenegocio%'BEGIN
      set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' inner join WSXML_SFG.lineadenegocio  l';
      set @StrSqlInner  = ' ON m.CODLINEADENEGOCIO = l.id_lineadenegocio';
      set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
    END 
    /*Filtro Where*/
    IF Len(@StrSqlWhere) = 7 BEGIN
      IF @p_CODLINEANEGOCIO =-1 BEGIN
          set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' m.codlineadenegocio>'+ISNULL(@p_CODLINEANEGOCIO, '');
      END
      ELSE BEGIN
          set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' m.codlineadenegocio='+ISNULL(@p_CODLINEANEGOCIO, '');
      END 
    END
    ELSE BEGIN
      IF @p_CODLINEANEGOCIO =-1 BEGIN
          set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND m.codlineadenegocio>'+ISNULL(@p_CODLINEANEGOCIO, '');
      END
      ELSE BEGIN
          set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND m.codlineadenegocio='+ISNULL(@p_CODLINEANEGOCIO, '');
      END 
    END 
  END 

  IF @p_CODCIUDAD > -2 BEGIN
    IF @StrSqlTablas not like '%puntodeventa%'BEGIN
      set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' inner join WSXML_SFG.puntodeventa pdv';
      set @StrSqlInner  = ' ON m.CODPUNTODEVENTA = pdv.ID_PUNTODEVENTA';
      set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
    END 
    IF @StrSqlTablas not like '%CIUDAD%'BEGIN
      set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' INNER JOIN CIUDAD mun';
      set @StrSqlInner  = ' ON pdv.CODCIUDAD = mun.ID_CIUDAD';
      set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
    END 
    /*Filtro Where*/
    IF Len(@StrSqlWhere) = 7 BEGIN
      IF @p_CODCIUDAD =-1 BEGIN
          set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mun.ID_CIUDAD>'+ISNULL(@p_CODCIUDAD, '');
      END
      ELSE BEGIN
          set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mun.ID_CIUDAD='+ISNULL(@p_CODCIUDAD, '');
      END 
    END
    ELSE BEGIN
      IF @p_CODCIUDAD =-1 BEGIN
          set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND mun.ID_CIUDAD>'+ISNULL(@p_CODCIUDAD, '');
      END
      ELSE BEGIN
          set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND mun.ID_CIUDAD='+ISNULL(@p_CODCIUDAD, '');
      END 
    END 
  END 

  /*grupos*/
  IF @p_GROUPCODCICLOFACT = -1 BEGIN
    IF @StrSqlCampos not like '%m.codciclofacturacionpdv%'BEGIN
      set @StrSqlCampos = ISNULL(@StrSqlCampos, '') +',';
      set @StrSqlCampos = ISNULL(@StrSqlCampos, '') +' m.codciclofacturacionpdv';
    END 
    IF  Len(@StrSqlGrupos) < 2 BEGIN
      set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +' Group by pdv.nompuntodeventa,l.nomlineadenegocio,m.codpuntodeventa,m.codlineadenegocio,m.codciclofacturacionpdv';
  --    StrSqlGrupos := StrSqlGrupos ||' Group by m.codpuntodeventa,m.codlineadenegocio,m.saldoanteriorencontragtech,m.saldoanteriorencontrafiducia,m.saldoanteriorafavorgtech,
  --m.saldoanteriorafavorfiducia,m.nuevosaldoencontragtech,m.nuevosaldoencontrafiducia,m.nuevosaldoafavorgtech,
  --m.nuevosaldoafavorfiducia,m.codciclofacturacionpdv';

    END 
    IF @StrSqlGrupos not like '%m.codciclofacturacionpdv%'BEGIN
      set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +',';
      set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') + ' m.codciclofacturacionpdv';
    END 

    IF @StrSqlCampos not like '%sum%'BEGIN
      set @StrSqlCampos =  replace(@StrSqlCampos,'m.saldoanteriorencontragtech','sum(m.saldoanteriorencontragtech) saldoanteriorencontragtech');
      set @StrSqlCampos =  replace(@StrSqlCampos,'m.saldoanteriorencontrafiducia','sum(m.saldoanteriorencontrafiducia) saldoanteriorencontrafiducia');
      set @StrSqlCampos =  replace(@StrSqlCampos,'m.saldoanteriorafavorgtech','sum(m.saldoanteriorafavorgtech) saldoanteriorafavorgtech');
      set @StrSqlCampos =  replace(@StrSqlCampos,'m.saldoanteriorafavorfiducia','sum(m.saldoanteriorafavorfiducia) saldoanteriorafavorfiducia');
      set @StrSqlCampos =  replace(@StrSqlCampos,'m.nuevosaldoencontragtech','sum(m.nuevosaldoencontragtech) nuevosaldoencontragtech');
      set @StrSqlCampos =  replace(@StrSqlCampos,'m.nuevosaldoencontrafiducia','sum(m.nuevosaldoencontrafiducia) nuevosaldoencontrafiducia');
      set @StrSqlCampos =  replace(@StrSqlCampos,'m.nuevosaldoafavorgtech','sum(m.nuevosaldoafavorgtech) nuevosaldoafavorgtech');
      set @StrSqlCampos =  replace(@StrSqlCampos,'m.nuevosaldoafavorfiducia','sum(m.nuevosaldoafavorfiducia) nuevosaldoafavorfiducia');
    END 

  END 

  IF @p_GROUPPUNTODEVENTA = -1 BEGIN
    IF @StrSqlCampos not like '%m.codpuntodeventa%'BEGIN
      set @StrSqlCampos = ISNULL(@StrSqlCampos, '') +',';
      set @StrSqlCampos = ISNULL(@StrSqlCampos, '') +' m.codpuntodeventa';
    END 
    IF  Len(@StrSqlGrupos) < 2 BEGIN
      set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +' Group by pdv.nompuntodeventa,l.nomlineadenegocio,m.codpuntodeventa,m.codlineadenegocio,m.codciclofacturacionpdv';
    END 
    IF @StrSqlGrupos not like '%m.codpuntodeventa%'BEGIN
      set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +',';
      set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') + ' m.codpuntodeventa';
    END 
    IF @StrSqlCampos not like '%sum%'BEGIN
      set @StrSqlCampos =  replace(@StrSqlCampos,'m.saldoanteriorencontragtech','sum(m.saldoanteriorencontragtech) saldoanteriorencontragtech');
      set @StrSqlCampos =  replace(@StrSqlCampos,'m.saldoanteriorencontrafiducia','sum(m.saldoanteriorencontrafiducia) saldoanteriorencontrafiducia');
      set @StrSqlCampos =  replace(@StrSqlCampos,'m.saldoanteriorafavorgtech','sum(m.saldoanteriorafavorgtech) saldoanteriorafavorgtech');
      set @StrSqlCampos =  replace(@StrSqlCampos,'m.saldoanteriorafavorfiducia','sum(m.saldoanteriorafavorfiducia) saldoanteriorafavorfiducia');
      set @StrSqlCampos =  replace(@StrSqlCampos,'m.nuevosaldoencontragtech','sum(m.nuevosaldoencontragtech) nuevosaldoencontragtech');
      set @StrSqlCampos =  replace(@StrSqlCampos,'m.nuevosaldoencontrafiducia','sum(m.nuevosaldoencontrafiducia) nuevosaldoencontrafiducia');
      set @StrSqlCampos =  replace(@StrSqlCampos,'m.nuevosaldoafavorgtech','sum(m.nuevosaldoafavorgtech) nuevosaldoafavorgtech');
      set @StrSqlCampos =  replace(@StrSqlCampos,'m.nuevosaldoafavorfiducia','sum(m.nuevosaldoafavorfiducia) nuevosaldoafavorfiducia');
    END 
  END 

  IF @p_GROUPCODCIUDAD = -1 BEGIN
    IF @StrSqlCampos not like '%mun.ID_CIUDAD%'BEGIN
      set @StrSqlCampos = ISNULL(@StrSqlCampos, '') +',';
      set @StrSqlCampos = ISNULL(@StrSqlCampos, '') +' mun.ID_CIUDAD';
    END 
    IF  Len(@StrSqlGrupos) < 2 BEGIN
      set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +' Group by pdv.nompuntodeventa,l.nomlineadenegocio,m.codpuntodeventa,m.codlineadenegocio,m.codciclofacturacionpdv,mun.ID_CIUDAD';
    END 
    IF @StrSqlGrupos not like '%mun.ID_CIUDAD%'BEGIN
      set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +',';
      set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') + ' mun.ID_CIUDAD';
    END 
    IF @StrSqlCampos not like '%sum%'BEGIN
      set @StrSqlCampos =  replace(@StrSqlCampos,'m.saldoanteriorencontragtech','sum(m.saldoanteriorencontragtech) saldoanteriorencontragtech');
      set @StrSqlCampos =  replace(@StrSqlCampos,'m.saldoanteriorencontrafiducia','sum(m.saldoanteriorencontrafiducia) saldoanteriorencontrafiducia');
      set @StrSqlCampos =  replace(@StrSqlCampos,'m.saldoanteriorafavorgtech','sum(m.saldoanteriorafavorgtech) saldoanteriorafavorgtech');
      set @StrSqlCampos =  replace(@StrSqlCampos,'m.saldoanteriorafavorfiducia','sum(m.saldoanteriorafavorfiducia) saldoanteriorafavorfiducia');
      set @StrSqlCampos =  replace(@StrSqlCampos,'m.nuevosaldoencontragtech','sum(m.nuevosaldoencontragtech) nuevosaldoencontragtech');
      set @StrSqlCampos =  replace(@StrSqlCampos,'m.nuevosaldoencontrafiducia','sum(m.nuevosaldoencontrafiducia) nuevosaldoencontrafiducia');
      set @StrSqlCampos =  replace(@StrSqlCampos,'m.nuevosaldoafavorgtech','sum(m.nuevosaldoafavorgtech) nuevosaldoafavorgtech');
      set @StrSqlCampos =  replace(@StrSqlCampos,'m.nuevosaldoafavorfiducia','sum(m.nuevosaldoafavorfiducia) nuevosaldoafavorfiducia');
    END 
  END 

  /*tratamiento de sql*/
  IF  Len(@StrSqlWhere) = 7 BEGIN
      set @StrSqlWhere = ' ';
  END 
  set @StrSqlFinal = ISNULL(@StrSqlCampos, '') + ISNULL(@StrSqlTablas, '') + ISNULL(@StrSqlWhere, '') + ISNULL(@StrSqlGrupos, '');
  execute  (@StrSqlFinal);
END 
GO

  IF OBJECT_ID('WSXML_SFG.SFGREPORTESFACTURA_ValorVentas', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREPORTESFACTURA_ValorVentas;
GO
  CREATE PROCEDURE WSXML_SFG.SFGREPORTESFACTURA_ValorVentas(@p_CODCICLOFACT   NUMERIC(22,0),
                  @p_GROUPCODCICLOFACT     NUMERIC(22,0),
                  @p_CODPUNTODEVENTA       NUMERIC(22,0),
                  @p_GROUPPUNTODEVENTA     NUMERIC(22,0),
                  @p_CODLINEANEGOCIO       NUMERIC(22,0),
                  @p_GROUPLINEANEGOCIO     NUMERIC(22,0),
                  @p_CODCIUDAD             NUMERIC(22,0),
                 @p_GROUPCODCIUDAD        NUMERIC(22,0)) as
 begin
  declare @StrSqlCampos            VARCHAR(1000) = 'select
  pdv.nompuntodeventa,
  l.nomlineadenegocio,
  df.codproducto,
  df.cantidadventa,
  df.valorventa,
  df.cantidadanulacion,
  df.valoranulacion,
  mf.codpuntodeventa,
  mf.codlineadenegocio,
  mf.codciclofacturacionpdv';
  declare @StrSqlInner             VARCHAR(1000) = ' ';
  declare @StrSqlGrupos            VARCHAR(1000) = ' ';
  declare @StrSqlTablas            VARCHAR(1000) = ' from WSXML_SFG.detallefacturacionpdv df inner join WSXML_SFG.maestrofacturacionpdv mf
  on df.codmaestrofacturacionpdv=mf.id_maestrofacturacionpdv
  inner join WSXML_SFG.puntodeventa pdv
  on mf.codpuntodeventa=pdv.id_puntodeventa
  inner join WSXML_SFG.lineadenegocio l
  on mf.codlineadenegocio  = l.id_lineadenegocio ';
  declare @StrSqlWhere             VARCHAR(1000) = ' Where ';
  declare @StrSqlFinal             VARCHAR(MAX) = '';
  declare @CursorTmp               VARCHAR(MAX);
  --declare @e_errorpropio     EXCEPTION;
   
  SET NOCOUNT ON;

    IF @p_CODCICLOFACT > -2 BEGIN
      set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' INNER JOIN WSXML_SFG.ciclofacturacionpdv c';
      set @StrSqlInner  = ' ON  mf.codciclofacturacionpdv = c.id_ciclofacturacionpdv';
      set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
      /*Filtro Where*/
      IF Len(@StrSqlWhere) = 7 BEGIN
        IF @p_CODCICLOFACT =-1 BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mf.codciclofacturacionpdv>'+ISNULL(CONVERT(VARCHAR,@p_CODCICLOFACT), '');
        END
        ELSE BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mf.codciclofacturacionpdv='+ISNULL(CONVERT(VARCHAR,@p_CODCICLOFACT), '');
        END 
      END
      ELSE BEGIN
        IF @p_CODCICLOFACT =-1 BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mf.codciclofacturacionpdv>'+ISNULL(CONVERT(VARCHAR,@p_CODCICLOFACT), '');
        END
        ELSE BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mf.codciclofacturacionpdv='+ISNULL(CONVERT(VARCHAR,@p_CODCICLOFACT), '');
        END 
      END 
    END 

    IF @p_CODPUNTODEVENTA > -2 BEGIN
      IF @StrSqlTablas not like '%puntodeventa%'BEGIN
        set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' inner join WSXML_SFG.puntodeventa pdv';
        set @StrSqlInner  = ' ON mf.CODPUNTODEVENTA = pdv.ID_PUNTODEVENTA';
        set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
      END 
      /*Filtro Where*/
      IF Len(@StrSqlWhere) = 7 BEGIN
        IF @p_CODPUNTODEVENTA =-1 BEGIN
        set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mf.CODPUNTODEVENTA>'+ISNULL(CONVERT(VARCHAR,@p_CODPUNTODEVENTA), '');
        END
        ELSE BEGIN
        set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mf.CODPUNTODEVENTA='+ISNULL(CONVERT(VARCHAR,@p_CODPUNTODEVENTA), '');
        END 
      END
      ELSE BEGIN
        IF @p_CODPUNTODEVENTA =-1 BEGIN
        set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND mf.CODPUNTODEVENTA>'+ISNULL(CONVERT(VARCHAR,@p_CODPUNTODEVENTA), '');
        END
        ELSE BEGIN
        set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND mf.CODPUNTODEVENTA='+ISNULL(CONVERT(VARCHAR,@p_CODPUNTODEVENTA), '');
        END 
      END 
    END 

    IF @p_CODLINEANEGOCIO > -2 BEGIN
      IF @StrSqlTablas not like '%lineadenegocio%'BEGIN
        set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' inner join WSXML_SFG.lineadenegocio  l';
        set @StrSqlInner  = ' ON mf.CODLINEADENEGOCIO = l.id_lineadenegocio';
        set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
      END 
      /*Filtro Where*/
      IF Len(@StrSqlWhere) = 7 BEGIN
        IF @p_CODLINEANEGOCIO =-1 BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mf.codlineadenegocio>'+ISNULL(CONVERT(VARCHAR,@p_CODLINEANEGOCIO), '');
        END
        ELSE BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mf.codlineadenegocio='+ISNULL(CONVERT(VARCHAR,@p_CODLINEANEGOCIO), '');
        END 
      END
      ELSE BEGIN
        IF @p_CODLINEANEGOCIO =-1 BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND mf.codlineadenegocio>'+ISNULL(CONVERT(VARCHAR,@p_CODLINEANEGOCIO), '');
        END
        ELSE BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND mf.codlineadenegocio='+ISNULL(CONVERT(VARCHAR,@p_CODLINEANEGOCIO), '');
        END 
      END 
    END 

    IF @p_CODCIUDAD > -2 BEGIN
      IF @StrSqlTablas not like '%puntodeventa%'BEGIN
        set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' inner join WSXML_SFG.puntodeventa pdv';
        set @StrSqlInner  = ' ON mf.CODPUNTODEVENTA = pdv.ID_PUNTODEVENTA';
        set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
      END 
      IF @StrSqlTablas not like '%CIUDAD%'BEGIN
        set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' INNER JOIN WSXML_SFG.CIUDAD mun';
        set @StrSqlInner  = ' ON pdv.CODCIUDAD = mun.ID_CIUDAD';
        set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
      END 
      /*Filtro Where*/
      IF Len(@StrSqlWhere) = 7 BEGIN
        IF @p_CODCIUDAD =-1 BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mun.ID_CIUDAD>'+ISNULL(CONVERT(VARCHAR,@p_CODCIUDAD), '');
        END
        ELSE BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mun.ID_CIUDAD='+ISNULL(CONVERT(VARCHAR,@p_CODCIUDAD), '');
        END 
      END
      ELSE BEGIN
        IF @p_CODCIUDAD =-1 BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND mun.ID_CIUDAD>'+ISNULL(CONVERT(VARCHAR,@p_CODCIUDAD), '');
        END
        ELSE BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND mun.ID_CIUDAD='+ISNULL(CONVERT(VARCHAR,@p_CODCIUDAD), '');
        END 
      END 
    END 

    /*grupos*/
    IF @p_GROUPCODCICLOFACT = -1 BEGIN
      IF @StrSqlCampos not like '%mf.codciclofacturacionpdv%'BEGIN
        set @StrSqlCampos = ISNULL(@StrSqlCampos, '') +',';
        set @StrSqlCampos = ISNULL(@StrSqlCampos, '') +' mf.codciclofacturacionpdv';
      END 
      IF  Len(@StrSqlGrupos) < 2 BEGIN
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +' Group by df.codproducto,pdv.nompuntodeventa,l.nomlineadenegocio,mf.codpuntodeventa,mf.codlineadenegocio,mf.codciclofacturacionpdv';
      END 
      IF @StrSqlGrupos not like '%mf.codciclofacturacionpdv%'BEGIN
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +',';
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') + ' mf.codciclofacturacionpdv';
      END 

      IF @StrSqlCampos not like '%sum%'BEGIN
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.cantidadventa','sum(df.cantidadventa) cantidadventa');
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.valorventa','sum(df.valorventa) valorventa');
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.cantidadanulacion','sum(df.cantidadanulacion) cantidadanulacion');
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.valoranulacion','sum(df.valoranulacion) valoranulacion');
      END 

    END 

    IF @p_GROUPPUNTODEVENTA = -1 BEGIN
      IF @StrSqlCampos not like '%mf.codpuntodeventa%'BEGIN
        set @StrSqlCampos = ISNULL(@StrSqlCampos, '') +',';
        set @StrSqlCampos = ISNULL(@StrSqlCampos, '') +' mf.codpuntodeventa';
      END 
      IF  Len(@StrSqlGrupos) < 2 BEGIN
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +' Group by df.codproducto,pdv.nompuntodeventa,l.nomlineadenegocio,mf.codpuntodeventa,mf.codlineadenegocio,mf.codciclofacturacionpdv';
      END 
      IF @StrSqlGrupos not like '%mf.codpuntodeventa%'BEGIN
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +',';
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') + ' mf.codpuntodeventa';
      END 
      IF @StrSqlCampos not like '%sum%'BEGIN
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.cantidadventa','sum(df.cantidadventa) cantidadventa');
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.valorventa','sum(df.valorventa) valorventa');
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.cantidadanulacion','sum(df.cantidadanulacion) cantidadanulacion');
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.valoranulacion','sum(df.valoranulacion) valoranulacion');
      END 
    END 

    IF @p_GROUPCODCIUDAD = -1 BEGIN
      IF @StrSqlCampos not like '%mun.ID_CIUDAD%'BEGIN
        set @StrSqlCampos = ISNULL(@StrSqlCampos, '') +',';
        set @StrSqlCampos = ISNULL(@StrSqlCampos, '') +' mun.ID_CIUDAD';
      END 
      IF  Len(@StrSqlGrupos) < 2 BEGIN
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +'  Group by df.codproducto,pdv.nompuntodeventa,l.nomlineadenegocio,mf.codpuntodeventa,mf.codlineadenegocio,mf.codciclofacturacionpdv,mun.ID_CIUDAD';
      END 
      IF @StrSqlGrupos not like '%mun.ID_CIUDAD%'BEGIN
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +',';
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') + ' mun.ID_CIUDAD';
      END 
      IF @StrSqlCampos not like '%sum%'BEGIN
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.cantidadventa','sum(df.cantidadventa) cantidadventa');
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.valorventa','sum(df.valorventa) valorventa');
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.cantidadanulacion','sum(df.cantidadanulacion) cantidadanulacion');
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.valoranulacion','sum(df.valoranulacion) valoranulacion');
      END 
    END 


    /*tratamiento de sql*/
    IF  Len(@StrSqlWhere) = 7 BEGIN
        set @StrSqlWhere = ' ';
    END 
    set @StrSqlFinal = ISNULL(@StrSqlCampos, '') + ISNULL(@StrSqlTablas, '') + ISNULL(@StrSqlWhere, '') + ISNULL(@StrSqlGrupos, '');

    execute  (@StrSqlFinal);

  END
GO


  IF OBJECT_ID('WSXML_SFG.SFGREPORTESFACTURA_PremioPagado', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREPORTESFACTURA_PremioPagado;
GO
  CREATE PROCEDURE WSXML_SFG.SFGREPORTESFACTURA_PremioPagado(@p_CODCICLOFACT          NUMERIC(22,0),
            @p_GROUPCODCICLOFACT     NUMERIC(22,0),
            @p_CODPUNTODEVENTA       NUMERIC(22,0),
            @p_GROUPPUNTODEVENTA     NUMERIC(22,0),
            @p_CODLINEANEGOCIO       NUMERIC(22,0),
            @p_GROUPLINEANEGOCIO     NUMERIC(22,0),
            @p_CODCIUDAD             NUMERIC(22,0),
           @p_GROUPCODCIUDAD        NUMERIC(22,0)) as
 begin
  declare @StrSqlCampos            VARCHAR(1000) = 'select pdv.nompuntodeventa,
  l.nomlineadenegocio,
  df.codproducto,
  df.cantidadpremiopago,
  df.valorpremiopago,
  mf.codpuntodeventa,
  mf.codlineadenegocio,
  mf.codciclofacturacionpdv';
  declare @StrSqlInner             VARCHAR(1000) = ' ';
  declare @StrSqlGrupos            VARCHAR(1000) = ' ';
  declare @StrSqlTablas            VARCHAR(1000) = ' from WSXML_SFG.detallefacturacionpdv df  inner join WSXML_SFG.maestrofacturacionpdv mf
  on df.codmaestrofacturacionpdv=mf.id_maestrofacturacionpdv
  inner join WSXML_SFG.puntodeventa pdv
  on mf.codpuntodeventa=pdv.id_puntodeventa
  inner join lineadenegocio l
  on mf.codlineadenegocio  = l.id_lineadenegocio ';
  declare @StrSqlWhere             VARCHAR(1000) = ' Where ';
  declare @StrSqlFinal             VARCHAR(MAX) = '';
  declare @CursorTmp               VARCHAR(MAX);
  --declare @e_errorpropio     EXCEPTION;
   
  SET NOCOUNT ON;
    /*campos*/
    IF @p_CODCICLOFACT > -2 BEGIN
      set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' INNER JOIN WSXML_SFG.ciclofacturacionpdv c';
      set @StrSqlInner  = ' ON  mf.codciclofacturacionpdv = c.id_ciclofacturacionpdv';
      set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
      /*Filtro Where*/
      IF Len(@StrSqlWhere) = 7 BEGIN
        IF @p_CODCICLOFACT =-1 BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mf.codciclofacturacionpdv>'+ISNULL(@p_CODCICLOFACT, '');
        END
        ELSE BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mf.codciclofacturacionpdv='+ISNULL(@p_CODCICLOFACT, '');
        END 
      END
      ELSE BEGIN
        IF @p_CODCICLOFACT =-1 BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mf.codciclofacturacionpdv>'+ISNULL(@p_CODCICLOFACT, '');
        END
        ELSE BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mf.codciclofacturacionpdv='+ISNULL(@p_CODCICLOFACT, '');
        END 
      END 
    END 

    IF @p_CODPUNTODEVENTA > -2 BEGIN
      IF @StrSqlTablas not like '%puntodeventa%'BEGIN
        set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' inner join WSXML_SFG.puntodeventa pdv';
        set @StrSqlInner  = ' ON mf.CODPUNTODEVENTA = pdv.ID_PUNTODEVENTA';
        set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
      END 
      /*Filtro Where*/
      IF Len(@StrSqlWhere) = 7 BEGIN
        IF @p_CODPUNTODEVENTA =-1 BEGIN
        set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mf.CODPUNTODEVENTA>'+ISNULL(@p_CODPUNTODEVENTA, '');
        END
        ELSE BEGIN
        set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mf.CODPUNTODEVENTA='+ISNULL(@p_CODPUNTODEVENTA, '');
        END 
      END
      ELSE BEGIN
        IF @p_CODPUNTODEVENTA =-1 BEGIN
        set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND mf.CODPUNTODEVENTA>'+ISNULL(@p_CODPUNTODEVENTA, '');
        END
        ELSE BEGIN
        set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND mf.CODPUNTODEVENTA='+ISNULL(@p_CODPUNTODEVENTA, '');
        END 
      END 
    END 

    IF @p_CODLINEANEGOCIO > -2 BEGIN
      IF @StrSqlTablas not like '%lineadenegocio%'BEGIN
        set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' inner join WSXML_SFG.lineadenegocio  l';
        set @StrSqlInner  = ' ON mf.CODLINEADENEGOCIO = l.id_lineadenegocio';
        set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
      END 
      /*Filtro Where*/
      IF Len(@StrSqlWhere) = 7 BEGIN
        IF @p_CODLINEANEGOCIO =-1 BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mf.codlineadenegocio>'+ISNULL(@p_CODLINEANEGOCIO, '');
        END
        ELSE BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mf.codlineadenegocio='+ISNULL(@p_CODLINEANEGOCIO, '');
        END 
      END
      ELSE BEGIN
        IF @p_CODLINEANEGOCIO =-1 BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND mf.codlineadenegocio>'+ISNULL(@p_CODLINEANEGOCIO, '');
        END
        ELSE BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND mf.codlineadenegocio='+ISNULL(@p_CODLINEANEGOCIO, '');
        END 
      END 
    END 

    IF @p_CODCIUDAD > -2 BEGIN
      IF @StrSqlTablas not like '%puntodeventa%'BEGIN
        set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' inner join WSXML_SFG.puntodeventa pdv';
        set @StrSqlInner  = ' ON mf.CODPUNTODEVENTA = pdv.ID_PUNTODEVENTA';
        set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
      END 
      IF @StrSqlTablas not like '%CIUDAD%'BEGIN
        set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' INNER JOIN CIUDAD mun';
        set @StrSqlInner  = ' ON pdv.CODCIUDAD = mun.ID_CIUDAD';
        set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
      END 
      /*Filtro Where*/
      IF Len(@StrSqlWhere) = 7 BEGIN
        IF @p_CODCIUDAD =-1 BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mun.ID_CIUDAD>'+ISNULL(@p_CODCIUDAD, '');
        END
        ELSE BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mun.ID_CIUDAD='+ISNULL(@p_CODCIUDAD, '');
        END 
      END
      ELSE BEGIN
        IF @p_CODCIUDAD =-1 BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND mun.ID_CIUDAD>'+ISNULL(@p_CODCIUDAD, '');
        END
        ELSE BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND mun.ID_CIUDAD='+ISNULL(@p_CODCIUDAD, '');
        END 
      END 
    END 

    /*grupos*/
    IF @p_GROUPCODCICLOFACT = -1 BEGIN
      IF @StrSqlCampos not like '%mf.codciclofacturacionpdv%'BEGIN
        set @StrSqlCampos = ISNULL(@StrSqlCampos, '') +',';
        set @StrSqlCampos = ISNULL(@StrSqlCampos, '') +' mf.codciclofacturacionpdv';
      END 
      IF  Len(@StrSqlGrupos) < 2 BEGIN
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +' Group by df.codproducto,pdv.nompuntodeventa,l.nomlineadenegocio,mf.codpuntodeventa,mf.codlineadenegocio,mf.codciclofacturacionpdv';
      END 
      IF @StrSqlGrupos not like '%mf.codciclofacturacionpdv%'BEGIN
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +',';
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') + ' mf.codciclofacturacionpdv';
      END 

      IF @StrSqlCampos not like '%sum%'BEGIN
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.cantidadpremiopago','sum(df.cantidadpremiopago) cantidadpremiopago');
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.valorpremiopago','sum(df.valorpremiopago) df.valorpremiopago');
      END 

    END 

    IF @p_GROUPPUNTODEVENTA = -1 BEGIN
      IF @StrSqlCampos not like '%mf.codpuntodeventa%'BEGIN
        set @StrSqlCampos = ISNULL(@StrSqlCampos, '') +',';
        set @StrSqlCampos = ISNULL(@StrSqlCampos, '') +' mf.codpuntodeventa';
      END 
      IF  Len(@StrSqlGrupos) < 2 BEGIN
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +' Group by df.codproducto,pdv.nompuntodeventa,l.nomlineadenegocio,mf.codpuntodeventa,mf.codlineadenegocio,mf.codciclofacturacionpdv';
      END 
      IF @StrSqlGrupos not like '%mf.codpuntodeventa%'BEGIN
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +',';
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') + ' mf.codpuntodeventa';
      END 
      IF @StrSqlCampos not like '%sum%'BEGIN
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.cantidadpremiopago','sum(df.cantidadpremiopago) cantidadpremiopago');
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.valorpremiopago','sum(df.valorpremiopago) df.valorpremiopago');
      END 
    END 

    IF @p_GROUPCODCIUDAD = -1 BEGIN
      IF @StrSqlCampos not like '%mun.ID_CIUDAD%'BEGIN
        set @StrSqlCampos = ISNULL(@StrSqlCampos, '') +',';
        set @StrSqlCampos = ISNULL(@StrSqlCampos, '') +' mun.ID_CIUDAD';
      END 
      IF  Len(@StrSqlGrupos) < 2 BEGIN
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +'  Group by df.codproducto,pdv.nompuntodeventa,l.nomlineadenegocio,mf.codpuntodeventa,mf.codlineadenegocio,mf.codciclofacturacionpdv,mun.ID_CIUDAD';
      END 
      IF @StrSqlGrupos not like '%mun.ID_CIUDAD%'BEGIN
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +',';
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') + ' mun.ID_CIUDAD';
      END 
      IF @StrSqlCampos not like '%sum%'BEGIN
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.cantidadpremiopago','sum(df.cantidadpremiopago) cantidadpremiopago');
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.valorpremiopago','sum(df.valorpremiopago) df.valorpremiopago');
      END 
    END 


    /*tratamiento de sql*/
    IF  Len(@StrSqlWhere) = 7 BEGIN
        set @StrSqlWhere = ' ';
    END 
    set @StrSqlFinal = ISNULL(@StrSqlCampos, '') + ISNULL(@StrSqlTablas, '') + ISNULL(@StrSqlWhere, '') + ISNULL(@StrSqlGrupos, '');
    execute  (@StrSqlFinal);
  END; 
GO

  IF OBJECT_ID('WSXML_SFG.SFGREPORTESFACTURA_Comisiones', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGREPORTESFACTURA_Comisiones;
GO
  CREATE PROCEDURE WSXML_SFG.SFGREPORTESFACTURA_Comisiones(@p_CODCICLOFACT          NUMERIC(22,0),
            @p_GROUPCODCICLOFACT     NUMERIC(22,0),
            @p_CODPUNTODEVENTA       NUMERIC(22,0),
            @p_GROUPPUNTODEVENTA     NUMERIC(22,0),
            @p_CODLINEANEGOCIO       NUMERIC(22,0),
            @p_GROUPLINEANEGOCIO     NUMERIC(22,0),
            @p_CODCIUDAD             NUMERIC(22,0),
           @p_GROUPCODCIUDAD        NUMERIC(22,0)) as
 begin
    declare @StrSqlCampos            VARCHAR(1000) = 'select pdv.nompuntodeventa,
    l.nomlineadenegocio,
    df.codproducto,
    df.valorcomision,
    df.retencionpremiospagados,
    df.valorcomisionneta,
    df.valorventaneta,
    mf.codpuntodeventa,
    mf.codlineadenegocio,
    mf.codciclofacturacionpdv';
    declare @StrSqlInner             VARCHAR(1000) = ' ';
    declare @StrSqlGrupos            VARCHAR(1000) = ' ';
    declare @StrSqlTablas            VARCHAR(1000) = ' from detallefacturacionpdv df inner join maestrofacturacionpdv mf
    on df.codmaestrofacturacionpdv=mf.id_maestrofacturacionpdv
    inner join puntodeventa pdv
    on mf.codpuntodeventa=pdv.id_puntodeventa
    inner join lineadenegocio l
    on mf.codlineadenegocio  = l.id_lineadenegocio ';
    declare @StrSqlWhere             VARCHAR(1000) = ' Where ';
    declare @StrSqlFinal             VARCHAR(MAX) = '';
    declare @CursorTmp               VARCHAR(MAX);
    --declare @e_errorpropio     EXCEPTION;
     
    SET NOCOUNT ON;

    /*campos*/
    IF @p_CODCICLOFACT > -2 BEGIN
      set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' INNER JOIN WSXML_SFG.ciclofacturacionpdv c';
      set @StrSqlInner  = ' ON  mf.codciclofacturacionpdv = c.id_ciclofacturacionpdv';
      set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
      /*Filtro Where*/
      IF Len(@StrSqlWhere) = 7 BEGIN
        IF @p_CODCICLOFACT =-1 BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mf.codciclofacturacionpdv>'+ISNULL(@p_CODCICLOFACT, '');
        END
        ELSE BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mf.codciclofacturacionpdv='+ISNULL(@p_CODCICLOFACT, '');
        END 
      END
      ELSE BEGIN
        IF @p_CODCICLOFACT =-1 BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mf.codciclofacturacionpdv>'+ISNULL(@p_CODCICLOFACT, '');
        END
        ELSE BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mf.codciclofacturacionpdv='+ISNULL(@p_CODCICLOFACT, '');
        END 
      END 
    END 

    IF @p_CODPUNTODEVENTA > -2 BEGIN
      IF @StrSqlTablas not like '%puntodeventa%'BEGIN
        set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' inner join WSXML_SFG.puntodeventa pdv';
        set @StrSqlInner  = ' ON mf.CODPUNTODEVENTA = pdv.ID_PUNTODEVENTA';
        set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
      END 
      /*Filtro Where*/
      IF Len(@StrSqlWhere) = 7 BEGIN
        IF @p_CODPUNTODEVENTA =-1 BEGIN
        set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mf.CODPUNTODEVENTA>'+ISNULL(@p_CODPUNTODEVENTA, '');
        END
        ELSE BEGIN
        set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mf.CODPUNTODEVENTA='+ISNULL(@p_CODPUNTODEVENTA, '');
        END 
      END
      ELSE BEGIN
        IF @p_CODPUNTODEVENTA =-1 BEGIN
        set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND mf.CODPUNTODEVENTA>'+ISNULL(@p_CODPUNTODEVENTA, '');
        END
        ELSE BEGIN
        set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND mf.CODPUNTODEVENTA='+ISNULL(@p_CODPUNTODEVENTA, '');
        END 
      END 
    END 

    IF @p_CODLINEANEGOCIO > -2 BEGIN
      IF @StrSqlTablas not like '%lineadenegocio%'BEGIN
        set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' inner join WSXML_SFG.lineadenegocio  l';
        set @StrSqlInner  = ' ON mf.CODLINEADENEGOCIO = l.id_lineadenegocio';
        set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
      END 
      /*Filtro Where*/
      IF Len(@StrSqlWhere) = 7 BEGIN
        IF @p_CODLINEANEGOCIO =-1 BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mf.codlineadenegocio>'+ISNULL(@p_CODLINEANEGOCIO, '');
        END
        ELSE BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mf.codlineadenegocio='+ISNULL(@p_CODLINEANEGOCIO, '');
        END 
      END
      ELSE BEGIN
        IF @p_CODLINEANEGOCIO =-1 BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND mf.codlineadenegocio>'+ISNULL(@p_CODLINEANEGOCIO, '');
        END
        ELSE BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND mf.codlineadenegocio='+ISNULL(@p_CODLINEANEGOCIO, '');
        END 
      END 
    END 

    IF @p_CODCIUDAD > -2 BEGIN
      IF @StrSqlTablas not like '%puntodeventa%'BEGIN
        set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' inner join WSXML_SFG.puntodeventa pdv';
        set @StrSqlInner  = ' ON mf.CODPUNTODEVENTA = pdv.ID_PUNTODEVENTA';
        set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
      END 
      IF @StrSqlTablas not like '%CIUDAD%'BEGIN
        set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +' INNER JOIN WSXML_SFG.CIUDAD mun';
        set @StrSqlInner  = ' ON pdv.CODCIUDAD = mun.ID_CIUDAD';
        set @StrSqlTablas = ISNULL(@StrSqlTablas, '') +ISNULL(@StrSqlInner, '');
      END 
      /*Filtro Where*/
      IF Len(@StrSqlWhere) = 7 BEGIN
        IF @p_CODCIUDAD =-1 BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mun.ID_CIUDAD>'+ISNULL(@p_CODCIUDAD, '');
        END
        ELSE BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' mun.ID_CIUDAD='+ISNULL(@p_CODCIUDAD, '');
        END 
      END
      ELSE BEGIN
        IF @p_CODCIUDAD =-1 BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND mun.ID_CIUDAD>'+ISNULL(@p_CODCIUDAD, '');
        END
        ELSE BEGIN
            set @StrSqlWhere = ISNULL(@StrSqlWhere, '') + ' AND mun.ID_CIUDAD='+ISNULL(@p_CODCIUDAD, '');
        END 
      END 
    END 

    /*grupos*/
    IF @p_GROUPCODCICLOFACT = -1 BEGIN
      IF @StrSqlCampos not like '%mf.codciclofacturacionpdv%'BEGIN
        set @StrSqlCampos = ISNULL(@StrSqlCampos, '') +',';
        set @StrSqlCampos = ISNULL(@StrSqlCampos, '') +' mf.codciclofacturacionpdv';
      END 
      IF  Len(@StrSqlGrupos) < 2 BEGIN
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +' Group by df.codproducto,pdv.nompuntodeventa,l.nomlineadenegocio,mf.codpuntodeventa,mf.codlineadenegocio,mf.codciclofacturacionpdv';
      END 
      IF @StrSqlGrupos not like '%mf.codciclofacturacionpdv%'BEGIN
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +',';
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') + ' mf.codciclofacturacionpdv';
      END 

      IF @StrSqlCampos not like '%sum%'BEGIN
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.valorcomision','sum(df.valorcomision) valorcomision');
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.retencionpremiospagados','sum(df.retencionpremiospagados) retencionpremiospagados');
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.valorcomisionneta','sum(df.valorcomisionneta) valorcomisionneta');
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.valorventaneta','sum(df.valorventaneta) valorventaneta');
      END 

    END 

    IF @p_GROUPPUNTODEVENTA = -1 BEGIN
      IF @StrSqlCampos not like '%mf.codpuntodeventa%'BEGIN
        set @StrSqlCampos = ISNULL(@StrSqlCampos, '') +',';
        set @StrSqlCampos = ISNULL(@StrSqlCampos, '') +' mf.codpuntodeventa';
      END 
      IF  Len(@StrSqlGrupos) < 2 BEGIN
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +' Group by df.codproducto,pdv.nompuntodeventa,l.nomlineadenegocio,mf.codpuntodeventa,mf.codlineadenegocio,mf.codciclofacturacionpdv';
      END 
      IF @StrSqlGrupos not like '%mf.codpuntodeventa%'BEGIN
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +',';
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') + ' mf.codpuntodeventa';
      END 
      IF @StrSqlCampos not like '%sum%'BEGIN
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.valorcomision','sum(df.valorcomision) valorcomision');
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.retencionpremiospagados','sum(df.retencionpremiospagados) retencionpremiospagados');
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.valorcomisionneta','sum(df.valorcomisionneta) valorcomisionneta');
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.valorventaneta','sum(df.valorventaneta) valorventaneta');
      END 
    END 

    IF @p_GROUPCODCIUDAD = -1 BEGIN
      IF @StrSqlCampos not like '%mun.ID_CIUDAD%'BEGIN
        set @StrSqlCampos = ISNULL(@StrSqlCampos, '') +',';
        set @StrSqlCampos = ISNULL(@StrSqlCampos, '') +' mun.ID_CIUDAD';
      END 
      IF  Len(@StrSqlGrupos) < 2 BEGIN
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +'  Group by df.codproducto,pdv.nompuntodeventa,l.nomlineadenegocio,mf.codpuntodeventa,mf.codlineadenegocio,mf.codciclofacturacionpdv,mun.ID_CIUDAD';
      END 
      IF @StrSqlGrupos not like '%mun.ID_CIUDAD%'BEGIN
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') +',';
        set @StrSqlGrupos = ISNULL(@StrSqlGrupos, '') + ' mun.ID_CIUDAD';
      END 
      IF @StrSqlCampos not like '%sum%'BEGIN
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.valorcomision','sum(df.valorcomision) valorcomision');
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.retencionpremiospagados','sum(df.retencionpremiospagados) retencionpremiospagados');
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.valorcomisionneta','sum(df.valorcomisionneta) valorcomisionneta');
        set @StrSqlCampos =  replace(@StrSqlCampos,'df.valorventaneta','sum(df.valorventaneta) valorventaneta');
      END 
    END 


    /*tratamiento de sql*/
    IF  Len(@StrSqlWhere) = 7 BEGIN
        set @StrSqlWhere = ' ';
    END 
    set @StrSqlFinal = ISNULL(@StrSqlCampos, '') + ISNULL(@StrSqlTablas, '') + ISNULL(@StrSqlWhere, '') + ISNULL(@StrSqlGrupos, '');

    execute  (@StrSqlFinal);

End;
GO




