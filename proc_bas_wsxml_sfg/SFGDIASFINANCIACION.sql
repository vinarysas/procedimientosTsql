USE SFGPRODU;
--  DDL for Package Body SFGDIASFINANCIACION
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGDIASFINANCIACION */ 

 --------------------------------------------------------------------
  -- Ingresar un registro en la tabla diasfinanciacion ------------------
  --------------------------------------------------------------------
  IF OBJECT_ID('WSXML_SFG.SFGDIASFINANCIACION_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDIASFINANCIACION_AddRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDIASFINANCIACION_AddRecord( @p_codciclofacturacionpdv NUMERIC(22,0)
                     , @p_codpuntodeventa NUMERIC(22,0)
                     , @p_numdiasponderadosfac NUMERIC(22,0)
                     , @p_numdiasplazo NUMERIC(22,0)
                     , @p_numdiasmora NUMERIC(22,0)
                     , @p_codusuariomodificacion NUMERIC(22,0)
                     , @p_id_diasfinanciacion_out   NUMERIC(22,0) OUT) AS
  BEGIN
  SET NOCOUNT ON;

    insert into WSXML_SFG.diasfinanciacion
    (
           codciclofacturacionpdv
           , codpuntodeventa
           , numdiasponderadosfac
           , numdiasplazo
           , numdiasmora
           , codusuariomodificacion
           , fechahoramodificacion
           , active
    )
    values
    (
 @p_codciclofacturacionpdv
           , @p_codpuntodeventa
           , @p_numdiasponderadosfac
           , @p_numdiasplazo
           , @p_numdiasmora
           , @p_codusuariomodificacion
           , getdate()
           , 1
    );
    SET @p_id_diasfinanciacion_out = SCOPE_IDENTITY();

  END;
GO

  --------------------------------------------------------------------
  -- Actualizar un registro de la tabla diasfinanciacion ----------------
  --------------------------------------------------------------------
  IF OBJECT_ID('WSXML_SFG.SFGDIASFINANCIACION_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDIASFINANCIACION_UpdateRecord;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDIASFINANCIACION_UpdateRecord( @pk_id_diasfinanciacion NUMERIC(22,0)
                     , @p_codciclofacturacionpdv NUMERIC(22,0)
                     , @p_codpuntodeventa NUMERIC(22,0)
                     , @p_numdiasponderadosfac NUMERIC(22,0)
                     , @p_numdiasplazo NUMERIC(22,0)
                     , @p_numdiasmora NUMERIC(22,0)
                     , @p_codusuariomodificacion NUMERIC(22,0)
                     , @p_active NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
     update WSXML_SFG.diasfinanciacion
     set
         codciclofacturacionpdv = @p_codciclofacturacionpdv,
         codpuntodeventa = @p_codpuntodeventa,
         numdiasponderadosfac = @p_numdiasponderadosfac,
         numdiasplazo = @p_numdiasplazo,
         numdiasmora = @p_numdiasmora,
         codusuariomodificacion = @p_codusuariomodificacion,
         fechahoramodificacion = getdate(),
         active = @p_active
     where id_diasfinanciacion = @pk_id_diasfinanciacion;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  --------------------------------------------------------------------
  -- Actualizar un registro de la tabla diasfinanciacion por el ciclo y punto de venta ----------------
  --------------------------------------------------------------------
  IF OBJECT_ID('WSXML_SFG.SFGDIASFINANCIACION_UpdateRecordCiclo', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDIASFINANCIACION_UpdateRecordCiclo;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDIASFINANCIACION_UpdateRecordCiclo( @p_codciclofacturacionpdv NUMERIC(22,0)
                     , @p_codpuntodeventa NUMERIC(22,0)
                     , @p_numdiasponderadosfac NUMERIC(22,0)
                     , @p_numdiasplazo NUMERIC(22,0)
                     , @p_numdiasmora NUMERIC(22,0)
                     , @p_codusuariomodificacion NUMERIC(22,0)
                     ) AS
  BEGIN
  SET NOCOUNT ON;
     update WSXML_SFG.diasfinanciacion
     set
         numdiasponderadosfac = case when @p_numdiasponderadosfac=-1 then numdiasponderadosfac else @p_numdiasponderadosfac end,
         numdiasplazo = case when @p_numdiasplazo=-1 then numdiasplazo else @p_numdiasplazo end,
         numdiasmora = case when @p_numdiasmora=-1 then numdiasmora else @p_numdiasmora end,
         codusuariomodificacion = @p_codusuariomodificacion,
         fechahoramodificacion = getdate()
     where
         codciclofacturacionpdv = @p_codciclofacturacionpdv
         and codpuntodeventa = @p_codpuntodeventa;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    IF @rowcount = 0 BEGIN
      RAISERROR('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1 BEGIN
      RAISERROR('-20053 Duplicate object instances.', 16, 1);
    END 
  END;
GO

  IF OBJECT_ID('WSXML_SFG.SFGDIASFINANCIACION_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDIASFINANCIACION_GetList;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDIASFINANCIACION_GetList(@p_ACTIVE NUMERIC(22,0)) AS
  BEGIN
  SET NOCOUNT ON;
    /* TODO implementation required */
      select
         id_diasfinanciacion,
         codciclofacturacionpdv,
         codpuntodeventa,
         numdiasponderadosfac,
         numdiasplazo,
         numdiasmora,
         codusuariomodificacion,
         fechahoramodificacion,
         active
  from WSXML_SFG.diasfinanciacion D
            WHERE D.active = CASE WHEN @p_ACTIVE = -1 THEN D.active ELSE @p_ACTIVE END;


  END
GO



  IF OBJECT_ID('WSXML_SFG.SFGDIASFINANCIACION_CalcularDias', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGDIASFINANCIACION_CalcularDias;
GO

CREATE     PROCEDURE WSXML_SFG.SFGDIASFINANCIACION_CalcularDias( @p_codciclofacturacionpdv NUMERIC(22,0)
                           , @p_codpuntodeventa NUMERIC(22,0)
                           , @p_DETALLETAREAEJECUTADA NUMERIC(22,0)
                           , @p_RETVALUE_OUT NUMERIC(22,0) OUT) AS
       DECLARE cDIASFINANCIACION CURSOR LOCAL FOR
          (
            select tbl2.codpuntodeventa,tbl2.id_ciclofacturacionpdv
            , sum(ValorDia) as DiasPonderados
            , isnull(DiasMora,0) as DiasMora
            --, isnull(DiasPlazo,0) as DiasPlazo
            from
            (
            select cf.id_ciclofacturacionpdv
                   , cf.fechaejecucion
                   , sum(rf.valortransaccion) as SumValor
                   , rf.fechatransaccion
                   , rf.codpuntodeventa
                   --, ((fechaejecucion - fechatransaccion) + 1) peso
                   , tbl.Total
                   , sum(rf.valortransaccion) * 100/ tbl.Total as Ponderado
                   , sum(rf.valortransaccion) * 100/ tbl.Total/100 as ValorDia
            from WSXML_SFG.ciclofacturacionpdv cf
                   inner join maestrofacturacionpdv mf on cf.id_ciclofacturacionpdv = mf.codciclofacturacionpdv
                   inner join detallefacturacionpdv df on mf.id_maestrofacturacionpdv = df.codmaestrofacturacionpdv
                   inner join registrofacturacion rf on df.id_detallefacturacionpdv = rf.coddetallefacturacionpdv
                   inner join
                   (
                    select
                          cf2.id_ciclofacturacionpdv
                          , mf2.codpuntodeventa
                          , sum(rf2.valortransaccion) as Total
                    from
                          WSXML_SFG.ciclofacturacionpdv cf2
                          , WSXML_SFG.maestrofacturacionpdv mf2
                          , WSXML_SFG.registrofacturacion rf2
                          , WSXML_SFG.detallefacturacionpdv df2
                    where
                          cf2.id_ciclofacturacionpdv = mf2.codciclofacturacionpdv
                          and mf2.id_maestrofacturacionpdv = df2.codmaestrofacturacionpdv
                          and df2.id_detallefacturacionpdv = rf2.coddetallefacturacionpdv
                    group by
                          cf2.id_ciclofacturacionpdv
                          ,  mf2.codpuntodeventa
                   )tbl on tbl.id_ciclofacturacionpdv = cf.id_ciclofacturacionpdv
                   and tbl.codpuntodeventa = mf.codpuntodeventa
            group by
                  cf.id_ciclofacturacionpdv,
                   cf.fechaejecucion,
                   rf.fechatransaccion,
                   rf.codpuntodeventa,
                   tbl.Total
            )tbl2
            left join
            (
            select mf.codciclofacturacionpdv,
                   mf.codpuntodeventa,
                   sum(ds.numdiasmoragtech) as DiasMora
                  -- (ds.fechalimitepagogtech - cf.fechaejecucion) as DiasPlazo
            from WSXML_SFG.detallesaldopdv ds,
                   WSXML_SFG.maestrofacturacionpdv mf,
                   WSXML_SFG.ciclofacturacionpdv cf
            where mf.id_maestrofacturacionpdv = ds.codmaestrofacturacionpdv
                   and cf.id_ciclofacturacionpdv = mf.codciclofacturacionpdv
            group by
                   mf.codciclofacturacionpdv,
                   mf.codpuntodeventa,
                   ds.fechalimitepagogtech,
                   cf.fechaejecucion
            )tbl3 on tbl2.codpuntodeventa = tbl3.codpuntodeventa
                  and tbl2.id_ciclofacturacionpdv = tbl3.codciclofacturacionpdv
            where
                 tbl2.codpuntodeventa = CASE WHEN @p_codpuntodeventa = -1 THEN tbl2.codpuntodeventa ELSE @p_codpuntodeventa END
                 and tbl2.id_ciclofacturacionpdv = CASE WHEN @p_codciclofacturacionpdv =   -1 THEN tbl2.id_ciclofacturacionpdv ELSE @p_codciclofacturacionpdv END
            group by tbl2.codpuntodeventa, tbl2.id_ciclofacturacionpdv , DiasMora
            --, DiasPlazo
         )
         
GO





