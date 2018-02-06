USE SFGPRODU;
--  DDL for Package Body SFGINF_DEPROCC3
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGINF_DEPROCC3 */ 

 IF OBJECT_ID('WSXML_SFG.SFGINF_DEPROCC3_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_DEPROCC3_GetList;
GO

CREATE   PROCEDURE WSXML_SFG.SFGINF_DEPROCC3_GetList(
                  @p_ACTIVE NUMERIC(22,0)
                  , @p_FECHAINICIO DATETIME
                  , @p_FECHAFIN DATETIME
                  , @P_CODCADENA NUMERIC(22,0)
                  , @p_ALI_ESTRATEGICO NVARCHAR(2000)
                  , @P_PRODUCTO NVARCHAR(2000)
                  , @p_SECUENCIA  NUMERIC(22,0)
                  , @p_LINEA  NUMERIC(22,0)
                  ) AS
  BEGIN
  SET NOCOUNT ON;

	  
      select
        case WHEN t.referenciagtech IS  NULL then t.referenciafiducia else t.referenciagtech end as  OTRO_TIPO_MOV
        , 'PROVEEDORES' as  PAGO_A
        from WSXML_SFG.maestrofacturacioncompconsig t;
	

  END;
GO


  IF OBJECT_ID('WSXML_SFG.SFGINF_DEPROCC3_GetResultado', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGINF_DEPROCC3_GetResultado;
GO

CREATE     PROCEDURE WSXML_SFG.SFGINF_DEPROCC3_GetResultado(
                  @p_ACTIVE NUMERIC(22,0)
                  , @p_FECHAINICIO DATETIME
                  , @p_FECHAFIN DATETIME
                  , @P_CODCADENA NUMERIC(22,0)
                  , @p_ALI_ESTRATEGICO NVARCHAR(2000)
                  , @P_PRODUCTO NVARCHAR(2000)
                  , @p_SECUENCIA  NUMERIC(22,0)
                  , @p_LINEA  NUMERIC(22,0)
                  ) AS
  BEGIN
  SET NOCOUNT ON;


	
       select
          case WHEN t.referenciagtech IS  NULL then t.referenciafiducia else t.referenciagtech end as  LA_REFERENCIA
          , 55  AS TERMINAL
          , 555 AS VALOR
          from WSXML_SFG.maestrofacturacioncompconsig t
          WHERE
                case WHEN t.referenciagtech IS  NULL then t.referenciafiducia else t.referenciagtech end = '12345670';
	
  END;
GO





