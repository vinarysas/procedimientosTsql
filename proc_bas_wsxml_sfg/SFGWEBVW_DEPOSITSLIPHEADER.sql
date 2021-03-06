USE SFGPRODU;
--  DDL for Package Body SFGWEBVW_DEPOSITSLIPHEADER
--------------------------------------------------------

  /* PACKAGE BODY WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER */ 

-- Creates a new record in the VW_DEPOSITSLIPHEADER table
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_AddRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_AddRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_AddRecord(
    @p_LASTBILLINGDATE DATETIME,
    @p_BILLINGDATE DATETIME,
    @p_CHAINNUMBER NVARCHAR(2000),
    @p_POSNUMBER NVARCHAR(2000),
    @p_TERMINALNUMBER NVARCHAR(2000),
    @p_ID_MAESTROFACTURACIONTIRILLA NUMERIC(22,0),
    @p_REFERENCENUMBER VARCHAR(4000),
    @p_BILLPAYBILLING NUMERIC(22,0),
    @p_BILLPAYBANKACCOUNTNUMBER NVARCHAR(2000),
    @p_BILLPAYPRODTOTAMOU NUMERIC(22,0),
    @p_BILLPAYDEPONLPRODTOTAMOU NUMERIC(22,0),
    @p_BPNCMMIBILLPAYMN NUMERIC(22,0),
    @p_BPNCMMIEVOUCHERS NUMERIC(22,0),
    @p_BPNCMMIERECHARGE NUMERIC(22,0),
    @p_BPNCMMIDEPONLINE NUMERIC(22,0),
    @p_BPNCMMITOTCMMIWITHOUTVAT NUMERIC(22,0),
    @p_BPNCMMIVATOFTHECMMI NUMERIC(22,0),
    @p_BPNCMMITOTCMMIWITHVAT NUMERIC(22,0),
    @p_BPNCMMITOTCMMIWITHVATWITHOUT NUMERIC(22,0),
    @p_BPNTAXRENTA NUMERIC(22,0),
    @p_BPNTAXICA NUMERIC(22,0),
    @p_BPNTAXIVA NUMERIC(22,0),
    @p_BILLPAYTOTQUANTITYOWED NUMERIC(22,0),
    @p_BILLPAYBILLDUTYACCOUNTBALA23 NUMERIC(22,0),
    @p_PREPAIDBILLING NUMERIC(22,0),
    @p_PRPBANKACCOUNTNUMBER NVARCHAR(2000),
    @p_PRPEVOUCHERPRODTOTAMOU NUMERIC(22,0),
    @p_PRPERECHARGEPRODTOTAMOU NUMERIC(22,0),
    @p_PRPCMMIBILLPAYMN NUMERIC(22,0),
    @p_PRPCMMIEVOUCHERS NUMERIC(22,0),
    @p_PRPCMMIERECHARGE NUMERIC(22,0),
    @p_PRPCMMIDEPONLINE NUMERIC(22,0),
    @p_PRPCMMITOTCMMIWITHOUTVAT NUMERIC(22,0),
    @p_PRPCMMIVATOFTHECMMI NUMERIC(22,0),
    @p_PRPCMMITOTCMMIWITHVAT NUMERIC(22,0),
    @p_PRPCMMITOTCMMIWITHVATWITHOUT NUMERIC(22,0),
    @p_PRPTAXRENTA NUMERIC(22,0),
    @p_PRPTAXICA NUMERIC(22,0),
    @p_PRPTAXIVA NUMERIC(22,0),
    @p_PRPTOTQUANTITYOWED NUMERIC(22,0),
    @p_PRPCMMONDUTYACCOUNTBALANCE NUMERIC(22,0),
    @p_LOTTERYBILLING NUMERIC(22,0),
    @p_LOTTPENDINGBALANFIDUCIA NUMERIC(22,0),
    @p_LOTTPENDINGBALANGTECH NUMERIC(22,0),
    @p_LOTTPREVIOUSBALANTOTAMOUNT NUMERIC(22,0),
    @p_LOTTADJUSTMENTS NUMERIC(22,0),
    @p_LOTTCONSOLIDATEDTAXIVA NUMERIC(22,0),
    @p_LOTTTOTCURRENTWEEK NUMERIC(22,0),
    @p_LOTTTOTQUANTITYOWED NUMERIC(22,0),
    @p_LOTTOWEDFIDUCIARY NUMERIC(22,0),
    @p_LOTTOWEDGTECH NUMERIC(22,0),
    @p_LOTTGROSSCMMI NUMERIC(22,0),
    @p_LOTTINCOMETAX NUMERIC(22,0),
    @p_LOTTTAXINDUSTRYANDCMMERCE NUMERIC(22,0),
    @p_LOTTINSURANCEOWED NUMERIC(22,0),
    @p_LOTTCMMIFINAL NUMERIC(22,0),
    @p_LOTTGTEREFERENCENUMBERGTECH VARCHAR(4000),
    @p_LOTTGTEBANKACCOUNTNUMBERGT57 NVARCHAR(2000),
    @p_LOTTGTEPREVIOUSBALANCEGTECH NUMERIC(22,0),
    @p_LOTTFIDREFERENCENUMBERFID VARCHAR(4000),
    @p_LOTTFIDBANKACCOUNTNUMBERFID NVARCHAR(2000),
    @p_LOTTFIDPREVIOUSBALANCEFID NUMERIC(22,0),
    @p_ID_PUNTODEVENTA NUMERIC(22,0),
    @p_ID_AGRUPACIONPUNTODEVENTA NUMERIC(22,0),
    @p_CODTIPOPUNTODEVENTA NUMERIC(22,0),
    @p_CODPUNTODEVENTACABEZA NUMERIC(22,0),
    @p_SLIPXML NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    INSERT
    INTO WSXML_SFG.VW_DEPOSITSLIPHEADER
        (
            LASTBILLINGDATE,
            BILLINGDATE,
            CHAINNUMBER,
            POSNUMBER,
            TERMINALNUMBER,
            ID_MAESTROFACTURACIONTIRILLA,
            REFERENCENUMBER,
            BILLPAYBILLING,
            BILLPAYBANKACCOUNTNUMBER,
            BILLPAYPRODTOTAMOU,
            BILLPAYDEPONLPRODTOTAMOU,
            BPNCMMIBILLPAYMN,
            BPNCMMIEVOUCHERS,
            BPNCMMIERECHARGE,
            BPNCMMIDEPONLINE,
            BPNCMMITOTCMMIWITHOUTVAT,
            BPNCMMIVATOFTHECMMI,
            BPNCMMITOTCMMIWITHVAT,
            BPNCMMITOTCMMIWITHVATWITHOUT,
            BPNTAXRENTA,
            BPNTAXICA,
            BPNTAXIVA,
            BILLPAYTOTQUANTITYOWED,
            BILLPAYBILLDUTYACCOUNTBALANCE,
            PREPAIDBILLING,
            PRPBANKACCOUNTNUMBER,
            PRPEVOUCHERPRODTOTAMOU,
            PRPERECHARGEPRODTOTAMOU,
            PRPCMMIBILLPAYMN,
            PRPCMMIEVOUCHERS,
            PRPCMMIERECHARGE,
            PRPCMMIDEPONLINE,
            PRPCMMITOTCMMIWITHOUTVAT,
            PRPCMMIVATOFTHECMMI,
            PRPCMMITOTCMMIWITHVAT,
            PRPCMMITOTCMMIWITHVATWITHOUT,
            PRPTAXRENTA,
            PRPTAXICA,
            PRPTAXIVA,
            PRPTOTQUANTITYOWED,
            PRPCMMONDUTYACCOUNTBALANCE,
            LOTTERYBILLING,
            LOTTPENDINGBALANFIDUCIA,
            LOTTPENDINGBALANGTECH,
            LOTTPREVIOUSBALANTOTAMOUNT,
            LOTTADJUSTMENTS,
            LOTTCONSOLIDATEDTAXIVA,
            LOTTTOTCURRENTWEEK,
            LOTTTOTQUANTITYOWED,
            LOTTOWEDFIDUCIARY,
            LOTTOWEDGTECH,
            LOTTGROSSCMMI,
            LOTTINCOMETAX,
            LOTTTAXINDUSTRYANDCMMERCE,
            LOTTINSURANCEOWED,
            LOTTCMMIFINAL,
            LOTTGTEREFERENCENUMBERGTECH,
            LOTTGTEBANKACCOUNTNUMBERGTECH,
            LOTTGTEPREVIOUSBALANCEGTECH,
            LOTTFIDREFERENCENUMBERFID,
            LOTTFIDBANKACCOUNTNUMBERFID,
            LOTTFIDPREVIOUSBALANCEFID,
            ID_PUNTODEVENTA,
            ID_AGRUPACIONPUNTODEVENTA,
            CODTIPOPUNTODEVENTA,
            CODPUNTODEVENTACABEZA,
            SLIPXML
        )
    VALUES
        (
            @p_LASTBILLINGDATE,
            @p_BILLINGDATE,
            @p_CHAINNUMBER,
            @p_POSNUMBER,
            @p_TERMINALNUMBER,
            @p_ID_MAESTROFACTURACIONTIRILLA,
            @p_REFERENCENUMBER,
            @p_BILLPAYBILLING,
            @p_BILLPAYBANKACCOUNTNUMBER,
            @p_BILLPAYPRODTOTAMOU,
            @p_BILLPAYDEPONLPRODTOTAMOU,
            @p_BPNCMMIBILLPAYMN,
            @p_BPNCMMIEVOUCHERS,
            @p_BPNCMMIERECHARGE,
            @p_BPNCMMIDEPONLINE,
            @p_BPNCMMITOTCMMIWITHOUTVAT,
            @p_BPNCMMIVATOFTHECMMI,
            @p_BPNCMMITOTCMMIWITHVAT,
            @p_BPNCMMITOTCMMIWITHVATWITHOUT,
            @p_BPNTAXRENTA,
            @p_BPNTAXICA,
            @p_BPNTAXIVA,
            @p_BILLPAYTOTQUANTITYOWED,
            @p_BILLPAYBILLDUTYACCOUNTBALA23,
            @p_PREPAIDBILLING,
            @p_PRPBANKACCOUNTNUMBER,
            @p_PRPEVOUCHERPRODTOTAMOU,
            @p_PRPERECHARGEPRODTOTAMOU,
            @p_PRPCMMIBILLPAYMN,
            @p_PRPCMMIEVOUCHERS,
            @p_PRPCMMIERECHARGE,
            @p_PRPCMMIDEPONLINE,
            @p_PRPCMMITOTCMMIWITHOUTVAT,
            @p_PRPCMMIVATOFTHECMMI,
            @p_PRPCMMITOTCMMIWITHVAT,
            @p_PRPCMMITOTCMMIWITHVATWITHOUT,
            @p_PRPTAXRENTA,
            @p_PRPTAXICA,
            @p_PRPTAXIVA,
            @p_PRPTOTQUANTITYOWED,
            @p_PRPCMMONDUTYACCOUNTBALANCE,
            @p_LOTTERYBILLING,
            @p_LOTTPENDINGBALANFIDUCIA,
            @p_LOTTPENDINGBALANGTECH,
            @p_LOTTPREVIOUSBALANTOTAMOUNT,
            @p_LOTTADJUSTMENTS,
            @p_LOTTCONSOLIDATEDTAXIVA,
            @p_LOTTTOTCURRENTWEEK,
            @p_LOTTTOTQUANTITYOWED,
            @p_LOTTOWEDFIDUCIARY,
            @p_LOTTOWEDGTECH,
            @p_LOTTGROSSCMMI,
            @p_LOTTINCOMETAX,
            @p_LOTTTAXINDUSTRYANDCMMERCE,
            @p_LOTTINSURANCEOWED,
            @p_LOTTCMMIFINAL,
            @p_LOTTGTEREFERENCENUMBERGTECH,
            @p_LOTTGTEBANKACCOUNTNUMBERGT57,
            @p_LOTTGTEPREVIOUSBALANCEGTECH,
            @p_LOTTFIDREFERENCENUMBERFID,
            @p_LOTTFIDBANKACCOUNTNUMBERFID,
            @p_LOTTFIDPREVIOUSBALANCEFID,
            @p_ID_PUNTODEVENTA,
            @p_ID_AGRUPACIONPUNTODEVENTA,
            @p_CODTIPOPUNTODEVENTA,
            @p_CODPUNTODEVENTACABEZA,
            @p_SLIPXML
        );

END;
GO

-- Updates a record in the VW_DEPOSITSLIPHEADER table.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_UpdateRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_UpdateRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_UpdateRecord(
        @p_LASTBILLINGDATE DATETIME,
    @p_BILLINGDATE DATETIME,
    @p_CHAINNUMBER NVARCHAR(2000),
    @p_POSNUMBER NVARCHAR(2000),
    @p_TERMINALNUMBER NVARCHAR(2000),
    @p_ID_MAESTROFACTURACIONTIRILLA NUMERIC(22,0),
@pk_ID_MAESTROFACTURACIONTIRILL NUMERIC(22,0),
    @p_REFERENCENUMBER VARCHAR(4000),
    @p_BILLPAYBILLING NUMERIC(22,0),
    @p_BILLPAYBANKACCOUNTNUMBER NVARCHAR(2000),
    @p_BILLPAYPRODTOTAMOU NUMERIC(22,0),
    @p_BILLPAYDEPONLPRODTOTAMOU NUMERIC(22,0),
    @p_BPNCMMIBILLPAYMN NUMERIC(22,0),
    @p_BPNCMMIEVOUCHERS NUMERIC(22,0),
    @p_BPNCMMIERECHARGE NUMERIC(22,0),
    @p_BPNCMMIDEPONLINE NUMERIC(22,0),
    @p_BPNCMMITOTCMMIWITHOUTVAT NUMERIC(22,0),
    @p_BPNCMMIVATOFTHECMMI NUMERIC(22,0),
    @p_BPNCMMITOTCMMIWITHVAT NUMERIC(22,0),
    @p_BPNCMMITOTCMMIWITHVATWITHOUT NUMERIC(22,0),
    @p_BPNTAXRENTA NUMERIC(22,0),
    @p_BPNTAXICA NUMERIC(22,0),
    @p_BPNTAXIVA NUMERIC(22,0),
    @p_BILLPAYTOTQUANTITYOWED NUMERIC(22,0),
    @p_BILLPAYBILLDUTYACCOUNTBALA23 NUMERIC(22,0),
    @p_PREPAIDBILLING NUMERIC(22,0),
    @p_PRPBANKACCOUNTNUMBER NVARCHAR(2000),
    @p_PRPEVOUCHERPRODTOTAMOU NUMERIC(22,0),
    @p_PRPERECHARGEPRODTOTAMOU NUMERIC(22,0),
    @p_PRPCMMIBILLPAYMN NUMERIC(22,0),
    @p_PRPCMMIEVOUCHERS NUMERIC(22,0),
    @p_PRPCMMIERECHARGE NUMERIC(22,0),
    @p_PRPCMMIDEPONLINE NUMERIC(22,0),
    @p_PRPCMMITOTCMMIWITHOUTVAT NUMERIC(22,0),
    @p_PRPCMMIVATOFTHECMMI NUMERIC(22,0),
    @p_PRPCMMITOTCMMIWITHVAT NUMERIC(22,0),
    @p_PRPCMMITOTCMMIWITHVATWITHOUT NUMERIC(22,0),
    @p_PRPTAXRENTA NUMERIC(22,0),
    @p_PRPTAXICA NUMERIC(22,0),
    @p_PRPTAXIVA NUMERIC(22,0),
    @p_PRPTOTQUANTITYOWED NUMERIC(22,0),
    @p_PRPCMMONDUTYACCOUNTBALANCE NUMERIC(22,0),
    @p_LOTTERYBILLING NUMERIC(22,0),
    @p_LOTTPENDINGBALANFIDUCIA NUMERIC(22,0),
    @p_LOTTPENDINGBALANGTECH NUMERIC(22,0),
    @p_LOTTPREVIOUSBALANTOTAMOUNT NUMERIC(22,0),
    @p_LOTTADJUSTMENTS NUMERIC(22,0),
    @p_LOTTCONSOLIDATEDTAXIVA NUMERIC(22,0),
    @p_LOTTTOTCURRENTWEEK NUMERIC(22,0),
    @p_LOTTTOTQUANTITYOWED NUMERIC(22,0),
    @p_LOTTOWEDFIDUCIARY NUMERIC(22,0),
    @p_LOTTOWEDGTECH NUMERIC(22,0),
    @p_LOTTGROSSCMMI NUMERIC(22,0),
    @p_LOTTINCOMETAX NUMERIC(22,0),
    @p_LOTTTAXINDUSTRYANDCMMERCE NUMERIC(22,0),
    @p_LOTTINSURANCEOWED NUMERIC(22,0),
    @p_LOTTCMMIFINAL NUMERIC(22,0),
    @p_LOTTGTEREFERENCENUMBERGTECH VARCHAR(4000),
    @p_LOTTGTEBANKACCOUNTNUMBERGT57 NVARCHAR(2000),
    @p_LOTTGTEPREVIOUSBALANCEGTECH NUMERIC(22,0),
    @p_LOTTFIDREFERENCENUMBERFID VARCHAR(4000),
    @p_LOTTFIDBANKACCOUNTNUMBERFID NVARCHAR(2000),
    @p_LOTTFIDPREVIOUSBALANCEFID NUMERIC(22,0),
    @p_ID_PUNTODEVENTA NUMERIC(22,0),
    @p_ID_AGRUPACIONPUNTODEVENTA NUMERIC(22,0),
    @p_CODTIPOPUNTODEVENTA NUMERIC(22,0),
    @p_CODPUNTODEVENTACABEZA NUMERIC(22,0),
    @p_SLIPXML NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    -- Update the record with the passed parameters
    UPDATE WSXML_SFG.VW_DEPOSITSLIPHEADER
    SET
            LASTBILLINGDATE = @p_LASTBILLINGDATE,
            BILLINGDATE = @p_BILLINGDATE,
            CHAINNUMBER = @p_CHAINNUMBER,
            POSNUMBER = @p_POSNUMBER,
            TERMINALNUMBER = @p_TERMINALNUMBER,
            ID_MAESTROFACTURACIONTIRILLA = @p_ID_MAESTROFACTURACIONTIRILLA,
            REFERENCENUMBER = @p_REFERENCENUMBER,
            BILLPAYBILLING = @p_BILLPAYBILLING,
            BILLPAYBANKACCOUNTNUMBER = @p_BILLPAYBANKACCOUNTNUMBER,
            BILLPAYPRODTOTAMOU = @p_BILLPAYPRODTOTAMOU,
            BILLPAYDEPONLPRODTOTAMOU = @p_BILLPAYDEPONLPRODTOTAMOU,
            BPNCMMIBILLPAYMN = @p_BPNCMMIBILLPAYMN,
            BPNCMMIEVOUCHERS = @p_BPNCMMIEVOUCHERS,
            BPNCMMIERECHARGE = @p_BPNCMMIERECHARGE,
            BPNCMMIDEPONLINE = @p_BPNCMMIDEPONLINE,
            BPNCMMITOTCMMIWITHOUTVAT = @p_BPNCMMITOTCMMIWITHOUTVAT,
            BPNCMMIVATOFTHECMMI = @p_BPNCMMIVATOFTHECMMI,
            BPNCMMITOTCMMIWITHVAT = @p_BPNCMMITOTCMMIWITHVAT,
            BPNCMMITOTCMMIWITHVATWITHOUT = @p_BPNCMMITOTCMMIWITHVATWITHOUT,
            BPNTAXRENTA = @p_BPNTAXRENTA,
            BPNTAXICA = @p_BPNTAXICA,
            BPNTAXIVA = @p_BPNTAXIVA,
            BILLPAYTOTQUANTITYOWED = @p_BILLPAYTOTQUANTITYOWED,
            BILLPAYBILLDUTYACCOUNTBALANCE = @p_BILLPAYBILLDUTYACCOUNTBALA23,
            PREPAIDBILLING = @p_PREPAIDBILLING,
            PRPBANKACCOUNTNUMBER = @p_PRPBANKACCOUNTNUMBER,
            PRPEVOUCHERPRODTOTAMOU = @p_PRPEVOUCHERPRODTOTAMOU,
            PRPERECHARGEPRODTOTAMOU = @p_PRPERECHARGEPRODTOTAMOU,
            PRPCMMIBILLPAYMN = @p_PRPCMMIBILLPAYMN,
            PRPCMMIEVOUCHERS = @p_PRPCMMIEVOUCHERS,
            PRPCMMIERECHARGE = @p_PRPCMMIERECHARGE,
            PRPCMMIDEPONLINE = @p_PRPCMMIDEPONLINE,
            PRPCMMITOTCMMIWITHOUTVAT = @p_PRPCMMITOTCMMIWITHOUTVAT,
            PRPCMMIVATOFTHECMMI = @p_PRPCMMIVATOFTHECMMI,
            PRPCMMITOTCMMIWITHVAT = @p_PRPCMMITOTCMMIWITHVAT,
            PRPCMMITOTCMMIWITHVATWITHOUT = @p_PRPCMMITOTCMMIWITHVATWITHOUT,
            PRPTAXRENTA = @p_PRPTAXRENTA,
            PRPTAXICA = @p_PRPTAXICA,
            PRPTAXIVA = @p_PRPTAXIVA,
            PRPTOTQUANTITYOWED = @p_PRPTOTQUANTITYOWED,
            PRPCMMONDUTYACCOUNTBALANCE = @p_PRPCMMONDUTYACCOUNTBALANCE,
            LOTTERYBILLING = @p_LOTTERYBILLING,
            LOTTPENDINGBALANFIDUCIA = @p_LOTTPENDINGBALANFIDUCIA,
            LOTTPENDINGBALANGTECH = @p_LOTTPENDINGBALANGTECH,
            LOTTPREVIOUSBALANTOTAMOUNT = @p_LOTTPREVIOUSBALANTOTAMOUNT,
            LOTTADJUSTMENTS = @p_LOTTADJUSTMENTS,
            LOTTCONSOLIDATEDTAXIVA = @p_LOTTCONSOLIDATEDTAXIVA,
            LOTTTOTCURRENTWEEK = @p_LOTTTOTCURRENTWEEK,
            LOTTTOTQUANTITYOWED = @p_LOTTTOTQUANTITYOWED,
            LOTTOWEDFIDUCIARY = @p_LOTTOWEDFIDUCIARY,
            LOTTOWEDGTECH = @p_LOTTOWEDGTECH,
            LOTTGROSSCMMI = @p_LOTTGROSSCMMI,
            LOTTINCOMETAX = @p_LOTTINCOMETAX,
            LOTTTAXINDUSTRYANDCMMERCE = @p_LOTTTAXINDUSTRYANDCMMERCE,
            LOTTINSURANCEOWED = @p_LOTTINSURANCEOWED,
            LOTTCMMIFINAL = @p_LOTTCMMIFINAL,
            LOTTGTEREFERENCENUMBERGTECH = @p_LOTTGTEREFERENCENUMBERGTECH,
            LOTTGTEBANKACCOUNTNUMBERGTECH = @p_LOTTGTEBANKACCOUNTNUMBERGT57,
            LOTTGTEPREVIOUSBALANCEGTECH = @p_LOTTGTEPREVIOUSBALANCEGTECH,
            LOTTFIDREFERENCENUMBERFID = @p_LOTTFIDREFERENCENUMBERFID,
            LOTTFIDBANKACCOUNTNUMBERFID = @p_LOTTFIDBANKACCOUNTNUMBERFID,
            LOTTFIDPREVIOUSBALANCEFID = @p_LOTTFIDPREVIOUSBALANCEFID,
            ID_PUNTODEVENTA = @p_ID_PUNTODEVENTA,
            ID_AGRUPACIONPUNTODEVENTA = @p_ID_AGRUPACIONPUNTODEVENTA,
            CODTIPOPUNTODEVENTA = @p_CODTIPOPUNTODEVENTA,
            CODPUNTODEVENTACABEZA = @p_CODPUNTODEVENTACABEZA,
            SLIPXML = @p_SLIPXML
    WHERE ID_MAESTROFACTURACIONTIRILLA = @pk_ID_MAESTROFACTURACIONTIRILL;

	DECLARE @rowcount NUMERIC(22,0) = @@ROWCOUNT;
    -- Make sure only one record is affected
    IF @rowcount = 0
    BEGIN
        RAISERROR ('-20054 The record no longer exists.', 16, 1);
    END 
    IF @rowcount > 1
    BEGIN
        RAISERROR ('-20053 Duplicate object instances.', 16, 1);
    END 

END;
GO

-- Deletes a record from the VW_DEPOSITSLIPHEADER table.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_DeleteRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_DeleteRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_DeleteRecord(
    @pk_ID_MAESTROFACTURACIONTIRILL NUMERIC(22,0)
    )
AS
BEGIN
SET NOCOUNT ON;
    DELETE WSXML_SFG.VW_DEPOSITSLIPHEADER
    WHERE ID_MAESTROFACTURACIONTIRILLA = @pk_ID_MAESTROFACTURACIONTIRILL;
END;
GO

-- Deletes the set of rows from the VW_DEPOSITSLIPHEADER table
-- that match the specified search criteria.
-- Returns the number of rows deleted as an output parameter.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_DeleteRecords', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_DeleteRecords;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_DeleteRecords(
    @p_where_str NVARCHAR(2000),
    @p_num_deleted NUMERIC(22,0) OUT
    )
AS
BEGIN
    DECLARE @l_where_str NVARCHAR(MAX);
    DECLARE @l_query_str NVARCHAR(MAX);
 
SET NOCOUNT ON;
    -- Initialize the where string
    SET @l_where_str = ' ';
    IF @p_where_str IS NOT NULL
    BEGIN
        SET @l_where_str = ' WHERE ' + isnull(@p_where_str, '');
    END 

    SET @p_num_deleted = 0;

    -- Set up the query string
    SET @l_query_str =
'DELETE WSXML_SFG.VW_DEPOSITSLIPHEADER' +
        isnull(@l_where_str, '') + ' ';

    -- Run the query
    EXECUTE sp_executesql @l_query_str;

    -- Return the number of rows affected to the output parameter
    SET @p_num_deleted = @@rowcount;

END;
GO

-- Returns a specific record from the VW_DEPOSITSLIPHEADER table.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_GetRecord', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_GetRecord;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_GetRecord(
   @pk_ID_MAESTROFACTURACIONTIRILL NUMERIC(22,0)

    )
AS
BEGIN
    DECLARE @l_count INTEGER;
 
SET NOCOUNT ON;

    -- Get the rowcount first and make sure
    -- only one row is returned
    SELECT @l_count = count(*)
    FROM WSXML_SFG.VW_DEPOSITSLIPHEADER
    WHERE ID_MAESTROFACTURACIONTIRILLA = @pk_ID_MAESTROFACTURACIONTIRILL;

    IF @l_count = 0
    BEGIN
        RAISERROR ('-20054 The record no longer exists.', 16, 1);
    END 

    IF @l_count > 1
    BEGIN
        RAISERROR ('-20053 Duplicate object instances.', 16, 1);
    END 

    -- Get the row from the query.  Checksum value will be
    -- returned along the row data to support concurrency.
         SELECT
        LASTBILLINGDATE,
        BILLINGDATE,
        CHAINNUMBER,
        POSNUMBER,
        TERMINALNUMBER,
        ID_MAESTROFACTURACIONTIRILLA,
        REFERENCENUMBER,
        BILLPAYBILLING,
        BILLPAYBANKACCOUNTNUMBER,
        BILLPAYPRODTOTAMOU,
        BILLPAYDEPONLPRODTOTAMOU,
        BPNCMMIBILLPAYMN,
        BPNCMMIEVOUCHERS,
        BPNCMMIERECHARGE,
        BPNCMMIDEPONLINE,
        BPNCMMITOTCMMIWITHOUTVAT,
        BPNCMMIVATOFTHECMMI,
        BPNCMMITOTCMMIWITHVAT,
        BPNCMMITOTCMMIWITHVATWITHOUT,
        BPNTAXRENTA,
        BPNTAXICA,
        BPNTAXIVA,
        BILLPAYTOTQUANTITYOWED,
        BILLPAYBILLDUTYACCOUNTBALANCE,
        PREPAIDBILLING,
        PRPBANKACCOUNTNUMBER,
        PRPEVOUCHERPRODTOTAMOU,
        PRPERECHARGEPRODTOTAMOU,
        PRPCMMIBILLPAYMN,
        PRPCMMIEVOUCHERS,
        PRPCMMIERECHARGE,
        PRPCMMIDEPONLINE,
        PRPCMMITOTCMMIWITHOUTVAT,
        PRPCMMIVATOFTHECMMI,
        PRPCMMITOTCMMIWITHVAT,
        PRPCMMITOTCMMIWITHVATWITHOUT,
        PRPTAXRENTA,
        PRPTAXICA,
        PRPTAXIVA,
        PRPTOTQUANTITYOWED,
        PRPCMMONDUTYACCOUNTBALANCE,
        LOTTERYBILLING,
        LOTTPENDINGBALANFIDUCIA,
        LOTTPENDINGBALANGTECH,
        LOTTPREVIOUSBALANTOTAMOUNT,
        LOTTADJUSTMENTS,
        LOTTCONSOLIDATEDTAXIVA,
        LOTTTOTCURRENTWEEK,
        LOTTTOTQUANTITYOWED,
        LOTTOWEDFIDUCIARY,
        LOTTOWEDGTECH,
        LOTTGROSSCMMI,
        LOTTINCOMETAX,
        LOTTTAXINDUSTRYANDCMMERCE,
        LOTTINSURANCEOWED,
        LOTTCMMIFINAL,
        LOTTGTEREFERENCENUMBERGTECH,
        LOTTGTEBANKACCOUNTNUMBERGTECH,
        LOTTGTEPREVIOUSBALANCEGTECH,
        LOTTFIDREFERENCENUMBERFID,
        LOTTFIDBANKACCOUNTNUMBERFID,
        LOTTFIDPREVIOUSBALANCEFID,
        ID_PUNTODEVENTA,
        ID_AGRUPACIONPUNTODEVENTA,
        CODTIPOPUNTODEVENTA,
        CODPUNTODEVENTACABEZA,
        SLIPXML
    FROM WSXML_SFG.VW_DEPOSITSLIPHEADER
    WHERE ID_MAESTROFACTURACIONTIRILLA = @pk_ID_MAESTROFACTURACIONTIRILL;  
END;
GO

-- Returns a query resultset from table VW_DEPOSITSLIPHEADER
-- given the search criteria and sorting condition.
-- It will return a subset of the data based
-- on the current page number and batch size.  Table joins can
-- be performed if the join clause is specified.
--
-- If the resultset is not empty, it will return:
--    1) The total number of rows which match the condition;
--    2) The resultset in the current page
-- If nothing matches the search condition, it will return:
--    1) count is 0 ;
--    2) empty resultset.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_GetList', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_GetList;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_GetList(
    @p_join_str NVARCHAR(2000),
    @p_where_str NVARCHAR(2000),
    @p_sort_str NVARCHAR(2000),
    @p_page_number INTEGER,
    @p_batch_size INTEGER,
   @p_total_size INTEGER OUT

    )
AS
BEGIN
    DECLARE @l_query_from VARCHAR(MAX);
    DECLARE @l_query_where VARCHAR(MAX);
    DECLARE @l_query_cols VARCHAR(MAX);
    DECLARE @l_from_str VARCHAR(MAX);
    DECLARE @l_alias_str VARCHAR(MAX);
    DECLARE @l_join_str VARCHAR(MAX);
    DECLARE @l_sort_str VARCHAR(MAX);
    DECLARE @l_where_str VARCHAR(MAX);
    DECLARE @l_count_query NVARCHAR(MAX);
    DECLARE @l_end_gen_row_num INTEGER;
    DECLARE @l_start_gen_row_num INTEGER;
    DECLARE @sql NVARCHAR(MAX);
 
SET NOCOUNT ON;
    -- Set up the from string as the base table.
    SET @l_from_str = 'WSXML_SFG.VW_DEPOSITSLIPHEADER VW_DEPOSITSLIPHEADER_';
    SET @l_alias_str = 'VW_DEPOSITSLIPHEADER_';

    -- Set up the join string.
    SET @l_join_str = @p_join_str;
    IF @p_join_str is null
    BEGIN
        SET @l_join_str = ' ';
    END 

    -- Set up the where string.
    SET @l_where_str = ' ';
        IF @p_where_str is not null
    BEGIN
        SET @l_where_str = 'WHERE ' + isnull(@p_where_str, '');
    END 

    -- Get the total count of rows the query will return
    IF @p_page_number > 0 and @p_batch_size >= 0
    BEGIN
        SET @l_count_query =
            'SELECT @p_total_size = count(*) ' +
            'FROM ' + isnull(@l_from_str, '') + ' ' + isnull(@l_join_str, '') + ' ' +
            isnull(@l_where_str, '') + ' ';

        -- Run the count query
        EXECUTE sp_executesql @l_count_query, N'@p_total_size INT output',
        @p_total_size output;
    END 

    -- Set up column name variable(s)
    SET @l_query_cols =
        'VW_DEPOSITSLIPHEADER_.LASTBILLINGDATE,
            VW_DEPOSITSLIPHEADER_.BILLINGDATE,
            VW_DEPOSITSLIPHEADER_.CHAINNUMBER,
            VW_DEPOSITSLIPHEADER_.POSNUMBER,
            VW_DEPOSITSLIPHEADER_.TERMINALNUMBER,
            VW_DEPOSITSLIPHEADER_.ID_MAESTROFACTURACIONTIRILLA,
            VW_DEPOSITSLIPHEADER_.REFERENCENUMBER,
            VW_DEPOSITSLIPHEADER_.BILLPAYBILLING,
            VW_DEPOSITSLIPHEADER_.BILLPAYBANKACCOUNTNUMBER,
            VW_DEPOSITSLIPHEADER_.BILLPAYPRODTOTAMOU,
            VW_DEPOSITSLIPHEADER_.BILLPAYDEPONLPRODTOTAMOU,
            VW_DEPOSITSLIPHEADER_.BPNCMMIBILLPAYMN,
            VW_DEPOSITSLIPHEADER_.BPNCMMIEVOUCHERS,
            VW_DEPOSITSLIPHEADER_.BPNCMMIERECHARGE,
            VW_DEPOSITSLIPHEADER_.BPNCMMIDEPONLINE,
            VW_DEPOSITSLIPHEADER_.BPNCMMITOTCMMIWITHOUTVAT,
            VW_DEPOSITSLIPHEADER_.BPNCMMIVATOFTHECMMI,
            VW_DEPOSITSLIPHEADER_.BPNCMMITOTCMMIWITHVAT,
            VW_DEPOSITSLIPHEADER_.BPNCMMITOTCMMIWITHVATWITHOUT,
            VW_DEPOSITSLIPHEADER_.BPNTAXRENTA,
            VW_DEPOSITSLIPHEADER_.BPNTAXICA,
            VW_DEPOSITSLIPHEADER_.BPNTAXIVA,
            VW_DEPOSITSLIPHEADER_.BILLPAYTOTQUANTITYOWED,
            VW_DEPOSITSLIPHEADER_.BILLPAYBILLDUTYACCOUNTBALANCE,
            VW_DEPOSITSLIPHEADER_.PREPAIDBILLING,
            VW_DEPOSITSLIPHEADER_.PRPBANKACCOUNTNUMBER,
            VW_DEPOSITSLIPHEADER_.PRPEVOUCHERPRODTOTAMOU,
            VW_DEPOSITSLIPHEADER_.PRPERECHARGEPRODTOTAMOU,
            VW_DEPOSITSLIPHEADER_.PRPCMMIBILLPAYMN,
            VW_DEPOSITSLIPHEADER_.PRPCMMIEVOUCHERS,
            VW_DEPOSITSLIPHEADER_.PRPCMMIERECHARGE,
            VW_DEPOSITSLIPHEADER_.PRPCMMIDEPONLINE,
            VW_DEPOSITSLIPHEADER_.PRPCMMITOTCMMIWITHOUTVAT,
            VW_DEPOSITSLIPHEADER_.PRPCMMIVATOFTHECMMI,
            VW_DEPOSITSLIPHEADER_.PRPCMMITOTCMMIWITHVAT,
            VW_DEPOSITSLIPHEADER_.PRPCMMITOTCMMIWITHVATWITHOUT,
            VW_DEPOSITSLIPHEADER_.PRPTAXRENTA,
            VW_DEPOSITSLIPHEADER_.PRPTAXICA,
            VW_DEPOSITSLIPHEADER_.PRPTAXIVA,
            VW_DEPOSITSLIPHEADER_.PRPTOTQUANTITYOWED,
            VW_DEPOSITSLIPHEADER_.PRPCMMONDUTYACCOUNTBALANCE,
            VW_DEPOSITSLIPHEADER_.LOTTERYBILLING,
            VW_DEPOSITSLIPHEADER_.LOTTPENDINGBALANFIDUCIA,
            VW_DEPOSITSLIPHEADER_.LOTTPENDINGBALANGTECH,
            VW_DEPOSITSLIPHEADER_.LOTTPREVIOUSBALANTOTAMOUNT,
            VW_DEPOSITSLIPHEADER_.LOTTADJUSTMENTS,
            VW_DEPOSITSLIPHEADER_.LOTTCONSOLIDATEDTAXIVA,
            VW_DEPOSITSLIPHEADER_.LOTTTOTCURRENTWEEK,
            VW_DEPOSITSLIPHEADER_.LOTTTOTQUANTITYOWED,
            VW_DEPOSITSLIPHEADER_.LOTTOWEDFIDUCIARY,
            VW_DEPOSITSLIPHEADER_.LOTTOWEDGTECH,
            VW_DEPOSITSLIPHEADER_.LOTTGROSSCMMI,
            VW_DEPOSITSLIPHEADER_.LOTTINCOMETAX,
            VW_DEPOSITSLIPHEADER_.LOTTTAXINDUSTRYANDCMMERCE,
            VW_DEPOSITSLIPHEADER_.LOTTINSURANCEOWED,
            VW_DEPOSITSLIPHEADER_.LOTTCMMIFINAL,
            VW_DEPOSITSLIPHEADER_.LOTTGTEREFERENCENUMBERGTECH,
            VW_DEPOSITSLIPHEADER_.LOTTGTEBANKACCOUNTNUMBERGTECH,
            VW_DEPOSITSLIPHEADER_.LOTTGTEPREVIOUSBALANCEGTECH,
            VW_DEPOSITSLIPHEADER_.LOTTFIDREFERENCENUMBERFID,
            VW_DEPOSITSLIPHEADER_.LOTTFIDBANKACCOUNTNUMBERFID,
            VW_DEPOSITSLIPHEADER_.LOTTFIDPREVIOUSBALANCEFID,
            VW_DEPOSITSLIPHEADER_.ID_PUNTODEVENTA,
            VW_DEPOSITSLIPHEADER_.ID_AGRUPACIONPUNTODEVENTA,
            VW_DEPOSITSLIPHEADER_.CODTIPOPUNTODEVENTA,
            VW_DEPOSITSLIPHEADER_.CODPUNTODEVENTACABEZA,
            VW_DEPOSITSLIPHEADER_.SLIPXML';

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY VW_DEPOSITSLIPHEADER_.ID_MAESTROFACTURACIONTIRILLA ASC ';

        END 

        -- Calculate the rows to be included in the list
        -- before geting the list.
        SET @l_end_gen_row_num = @p_page_number * @p_batch_size;
        SET @l_start_gen_row_num = @l_end_gen_row_num - (@p_batch_size-1);

        -- Run the query
        SET @sql = 
        ' SELECT ' +
            isnull(@l_query_cols, '') + ' ' +
 ' ' +
            'FROM ( SELECT ' +
                isnull(@l_query_cols, '') + ' ' +
 ' ' +
                ', ROW_NUMBER() OVER('+isnull(@l_sort_str, '')+') ISD_ROW_NUMBER '+
                'FROM ( SELECT ' +
                    isnull(@l_query_cols, '') + ' ' +
 ' ' +
                    'FROM ' +
                        isnull(@l_from_str, '') + ' ' +
                        isnull(@l_join_str, '') + ' ' +
                        isnull(@l_where_str, '') + ' ' +
                ') ' + isnull(@l_alias_str, '') + ' ' +
            ') ' + isnull(@l_alias_str, '') + ' ' +
            'WHERE ISD_ROW_NUMBER >= @l_start_gen_row_num ' +
            'AND ISD_ROW_NUMBER <= @l_end_gen_row_num ' +
            'ORDER BY ISD_ROW_NUMBER; ';
        EXECUTE sp_executesql @sql, N'@l_start_gen_row_num INT, @l_end_gen_row_num INT', @l_start_gen_row_num, @l_end_gen_row_num;
    END
    ELSE BEGIN
        -- If page number and batch size are not valid numbers
        -- return an empty result set
        SET @sql = 
        ' SELECT ' +
            isnull(@l_query_cols, '') + ' ' +
 ' ' +
            'FROM ' + isnull(@l_from_str, '') + ' ' +
            'WHERE 1=2; ';
        EXECUTE sp_executesql @sql;
    END 

END;
GO

-- Returns a query result from table VW_DEPOSITSLIPHEADER
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_DrillDown', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_DrillDown;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_DrillDown(
    @p_select_str NVARCHAR(2000),
    @p_is_distinct INTEGER,
    @p_select_str_b NVARCHAR(2000),
    @p_join_str NVARCHAR(2000),
    @p_where_str NVARCHAR(2000),
    @p_sort_str NVARCHAR(2000),
    @p_page_number INTEGER,
    @p_batch_size INTEGER,
   @p_total_size INTEGER OUT

    )
AS
BEGIN
    DECLARE @l_query_select VARCHAR(MAX);
    DECLARE @l_query_select_b VARCHAR(MAX);
    DECLARE @l_query_from VARCHAR(MAX);
    DECLARE @l_query_where VARCHAR(MAX);
    DECLARE @l_from_str VARCHAR(MAX);
    DECLARE @l_alias_str VARCHAR(MAX);
    DECLARE @l_join_str VARCHAR(MAX);
    DECLARE @l_sort_str VARCHAR(MAX);
    DECLARE @l_where_str VARCHAR(MAX);
    DECLARE @l_count_query NVARCHAR(MAX);
    DECLARE @l_end_gen_row_num INTEGER;
    DECLARE @l_start_gen_row_num INTEGER;
    DECLARE @sql NVARCHAR(MAX);
 
SET NOCOUNT ON;
    -- Set up the from string as the base table.
	SET @l_query_select = @p_select_str;
    SET @l_from_str = 'WSXML_SFG.VW_DEPOSITSLIPHEADER VW_DEPOSITSLIPHEADER_';
    SET @l_alias_str = 'VW_DEPOSITSLIPHEADER_';

    -- Set up the join string.
    SET @l_join_str = @p_join_str;
    IF @p_join_str is null
    BEGIN
        SET @l_join_str = ' ';
    END 

    -- Set up the where string.
    SET @l_where_str = ' ';
    IF @p_where_str is not null
    BEGIN
        SET @l_where_str = 'WHERE ' + isnull(@p_where_str, '');
    END 

    -- Get the total count of rows the query will return
    IF @p_page_number > 0 and @p_batch_size >= 0
    BEGIN
        IF @p_is_distinct = 0
        BEGIN
            SET @l_count_query =
                'SELECT @p_total_size = count(*) FROM ( SELECT ' + isnull(@p_select_str, '') + ' ' +
                'FROM ' + isnull(@l_from_str, '') + ' ' + isnull(@l_join_str + ' ' +
                isnull(@l_where_str, '') + ' ) countAlias', '');
        END
        ELSE BEGIN
            SET @l_count_query =
                'SELECT @p_total_size = COUNT(*) FROM ( SELECT DISTINCT ' + isnull(@p_select_str, '') + ', 1 As count1  ' +
                'FROM ' + isnull(@l_from_str, '') + ' ' + isnull(@l_join_str, '') + ' ' +
                isnull(@l_where_str, '') + ' ) pass1 ';
        END 
    END
    ELSE BEGIN
        SET @l_count_query = ' ';
    END 

    -- Run the count query
    EXECUTE sp_executesql @l_count_query, N'@p_total_size INT output',
    @p_total_size output;

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY ' + @l_query_select;
        END 

        -- Calculate the rows to be included in the list
        -- before geting the list.
        SET @l_end_gen_row_num = @p_page_number * @p_batch_size;
        SET @l_start_gen_row_num = @l_end_gen_row_num - (@p_batch_size-1);

        IF @p_is_distinct = 0
        BEGIN
            SET @l_query_select_b = @p_select_str_b;
        END
        ELSE BEGIN
            SET @l_query_select_b = 'DISTINCT ' + isnull(@p_select_str_b, '');
        END 

        -- Run the query
        SET @sql = 
        ' SELECT ' +
            isnull(@l_query_select, '') + ' ' +
            'FROM ( SELECT ' +
                isnull(@l_query_select, '') + ' ' +
                ', ROW_NUMBER() OVER('+isnull(@l_sort_str, '')+') ISD_ROW_NUMBER '+
                'FROM ( SELECT ' +
                    isnull(@l_query_select_b, '') + ' ' +
                    'FROM ' +
                        isnull(@l_from_str, '') + ' ' +
                        isnull(@l_join_str, '') + ' ' +
                        isnull(@l_where_str, '') + ' ' +
                ') ' + isnull(@l_alias_str, '') + ' ' +
            ') ' + isnull(@l_alias_str, '') + ' ' +
            'WHERE ISD_ROW_NUMBER >= @l_start_gen_row_num ' +
            'AND ISD_ROW_NUMBER <= @l_end_gen_row_num ' +
            'ORDER BY ISD_ROW_NUMBER; ';
        EXECUTE sp_executesql @sql, N'@l_start_gen_row_num INT, @l_end_gen_row_num INT', @l_start_gen_row_num, @l_end_gen_row_num;
    END
    ELSE BEGIN
        -- If page number and batch size are not valid numbers
        -- return an empty result set
        SET @sql = 
        ' SELECT ' +
            isnull(@l_query_select, '') + ' ' +
            'FROM ' + isnull(@l_from_str, '') + ' ' +
            'WHERE 1=2; ';
        EXECUTE sp_executesql @sql;
    END 

END;
GO

-- Returns a query result from table VW_DEPOSITSLIPHEADER
-- given the search criteria and sorting condition.
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_GetStats', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_GetStats;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_GetStats(
    @p_select_str NVARCHAR(2000),
    @p_join_str NVARCHAR(2000),
    @p_where_str NVARCHAR(2000),
    @p_sort_str NVARCHAR(2000),
    @p_page_number INTEGER,
   @p_batch_size INTEGER

    )
AS
BEGIN
    DECLARE @l_query_select VARCHAR(MAX);
    DECLARE @l_query_from VARCHAR(MAX);
    DECLARE @l_query_where VARCHAR(MAX);
    DECLARE @l_from_str VARCHAR(MAX);
    DECLARE @l_alias_str VARCHAR(MAX);
    DECLARE @l_join_str VARCHAR(MAX);
    DECLARE @l_sort_str VARCHAR(MAX);
    DECLARE @l_where_str VARCHAR(MAX);
    DECLARE @l_stat_col VARCHAR(MAX);
    DECLARE @l_select_col VARCHAR(MAX);
    DECLARE @l_end_gen_row_num INTEGER;
    DECLARE @l_start_gen_row_num INTEGER;
    DECLARE @sql NVARCHAR(MAX);
 
SET NOCOUNT ON;
    -- Extract the col only that we need to run statistics on.
    -- First extract the content in the function call.
    SET @l_stat_col = @p_select_str;
    SET @l_stat_col = SUBSTRING(@l_stat_col,
                CHARINDEX('(', @l_stat_col) + 1,
                CHARINDEX(')', @l_stat_col) - CHARINDEX('(', @l_stat_col) - 1);

    -- Then extract the column from the distinct clause.
    SET @l_stat_col = LTRIM(RTRIM(@l_stat_col));
    IF CHARINDEX('DISTINCT ', UPPER(@l_stat_col)) = 1
    BEGIN
        SET @l_stat_col = SUBSTRING(@l_stat_col, CHARINDEX(' ', @l_stat_col) + 1, LEN(@l_stat_col));
    END 

    -- Get the select column name without alias.
SET @l_query_select = @l_stat_col;
SET @l_select_col = @l_stat_col;
IF CHARINDEX(' ', @l_stat_col) > 0
BEGIN
SET @l_stat_col = SUBSTRING(@l_stat_col, 0, CHARINDEX(' ', @l_stat_col));
SET @l_select_col = @l_stat_col;
END


    -- Set up the from string as the base table.

    SET @l_from_str = 'WSXML_SFG.VW_DEPOSITSLIPHEADER VW_DEPOSITSLIPHEADER_';
    SET @l_alias_str = 'VW_DEPOSITSLIPHEADER_';

    -- Set up the join string.
    SET @l_join_str = @p_join_str;
    IF @p_join_str is null
    BEGIN
        SET @l_join_str = ' ';
    END 

    -- Set up the where string.
    SET @l_where_str = ' ';
    IF @p_where_str is not null
    BEGIN
        SET @l_where_str = 'WHERE ' + isnull(@p_where_str, '');
    END 

    -- Get the list.
    IF @p_page_number > 0 AND @p_batch_size > 0
    BEGIN
        -- If the caller did not pass a sort string, use a default value
        IF @p_sort_str IS NOT NULL
        BEGIN
            SET @l_sort_str = 'ORDER BY ' + isnull(@p_sort_str, '');
        END
        ELSE BEGIN
            SET @l_sort_str = 'ORDER BY ' + @l_stat_col;
        END 

        -- Calculate the rows to be included in the list
        -- before geting the list.
        SET @l_end_gen_row_num = @p_page_number * @p_batch_size;
        SET @l_start_gen_row_num = @l_end_gen_row_num - (@p_batch_size-1);

        -- Run the query
        SET @sql = 
        ' SELECT ' +
            isnull(@l_query_select, '') + ' ' +
            'FROM ( SELECT ' +
                isnull(@l_stat_col, '') + ' ' +
                ', ROW_NUMBER() OVER('+isnull(@l_sort_str, '')+') ISD_ROW_NUMBER '+
                'FROM ( SELECT ' +
                    isnull(@l_select_col, '') + ' ' +
                    'FROM ' +
                        isnull(@l_from_str, '') + ' ' +
                        isnull(@l_join_str, '') + ' ' +
                        isnull(@l_where_str, '') + ' ' +
                ') ' + isnull(@l_alias_str, '') + ' ' +
            ') ' + isnull(@l_alias_str, '') + ' ' +
            'WHERE ISD_ROW_NUMBER >= @l_start_gen_row_num ' +
            'AND ISD_ROW_NUMBER <= @l_end_gen_row_num ' +
            'ORDER BY ISD_ROW_NUMBER; ';
        EXECUTE sp_executesql @sql, N'@l_start_gen_row_num INT, @l_end_gen_row_num INT', @l_start_gen_row_num, @l_end_gen_row_num;
    END
    ELSE BEGIN
        -- If page number and batch size are not valid numbers
        -- return an empty result set
        SET @sql = 
        ' SELECT ' +
            isnull(@l_query_select, '') + ' ' +
            'FROM ' + isnull(@l_from_str, '') + ' ' +
            'WHERE 1=2; ';
        EXECUTE sp_executesql @sql;
    END 

END;
GO

-- Returns the query result set in a CSV format
-- so that the data can be exported to a CSV file
IF OBJECT_ID('WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_Export', 'P') IS NOT NULL
  DROP PROCEDURE WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_Export;
GO

CREATE PROCEDURE WSXML_SFG.SFGWEBVW_DEPOSITSLIPHEADER_Export(
    @p_separator_str NVARCHAR(2000),
    @p_title_str NVARCHAR(2000),
    @p_select_str NVARCHAR(2000),
    @p_join_str NVARCHAR(2000),
    @p_where_str NVARCHAR(2000),
   @p_num_exported INTEGER OUT

    )
AS
BEGIN
    DECLARE @l_title_str VARCHAR(MAX);
    DECLARE @l_select_str VARCHAR(MAX);
    DECLARE @l_from_str VARCHAR(MAX);
    DECLARE @l_join_str VARCHAR(MAX);
    DECLARE @l_where_str VARCHAR(MAX);
    DECLARE @l_query_select VARCHAR(MAX);
    DECLARE @l_query_union VARCHAR(MAX);
    DECLARE @l_query_from VARCHAR(MAX);
    DECLARE @sql NVARCHAR(MAX);
 
SET NOCOUNT ON;
    -- Set up the title string from the column names.  Excel
    -- will complain if the first column value is ID. So wrap
    -- the value with .
    SET @l_title_str = isnull(@p_title_str, '') + isnull(char(13), '');
    IF @p_title_str IS NULL
    BEGIN
        SET @l_title_str =
                'LASTBILLINGDATE' + isnull(@p_separator_str, '') +
                'BILLINGDATE' + isnull(@p_separator_str, '') +
                'CHAINNUMBER' + isnull(@p_separator_str, '') +
                'POSNUMBER' + isnull(@p_separator_str, '') +
                'TERMINALNUMBER' + isnull(@p_separator_str, '') +
                'XID_MAESTROFACTURACIONTIRILLA' + isnull(@p_separator_str, '') +
                'REFERENCENUMBER' + isnull(@p_separator_str, '') +
                'BILLPAYBILLING' + isnull(@p_separator_str, '') +
                'BILLPAYBANKACCOUNTNUMBER' + isnull(@p_separator_str, '') +
                'BILLPAYPRODTOTAMOU' + isnull(@p_separator_str, '') +
                'BILLPAYDEPONLPRODTOTAMOU' + isnull(@p_separator_str, '') +
                'BPNCMMIBILLPAYMN' + isnull(@p_separator_str, '') +
                'BPNCMMIEVOUCHERS' + isnull(@p_separator_str, '') +
                'BPNCMMIERECHARGE' + isnull(@p_separator_str, '') +
                'BPNCMMIDEPONLINE' + isnull(@p_separator_str, '') +
                'BPNCMMITOTCMMIWITHOUTVAT' + isnull(@p_separator_str, '') +
                'BPNCMMIVATOFTHECMMI' + isnull(@p_separator_str, '') +
                'BPNCMMITOTCMMIWITHVAT' + isnull(@p_separator_str, '') +
                'BPNCMMITOTCMMIWITHVATWITHOUT' + isnull(@p_separator_str, '') +
                'BPNTAXRENTA' + isnull(@p_separator_str, '') +
                'BPNTAXICA' + isnull(@p_separator_str, '') +
                'BPNTAXIVA' + isnull(@p_separator_str, '') +
                'BILLPAYTOTQUANTITYOWED' + isnull(@p_separator_str, '') +
                'BILLPAYBILLDUTYACCOUNTBALANCE' + isnull(@p_separator_str, '') +
                'PREPAIDBILLING' + isnull(@p_separator_str, '') +
                'PRPBANKACCOUNTNUMBER' + isnull(@p_separator_str, '') +
                'PRPEVOUCHERPRODTOTAMOU' + isnull(@p_separator_str, '') +
                'PRPERECHARGEPRODTOTAMOU' + isnull(@p_separator_str, '') +
                'PRPCMMIBILLPAYMN' + isnull(@p_separator_str, '') +
                'PRPCMMIEVOUCHERS' + isnull(@p_separator_str, '') +
                'PRPCMMIERECHARGE' + isnull(@p_separator_str, '') +
                'PRPCMMIDEPONLINE' + isnull(@p_separator_str, '') +
                'PRPCMMITOTCMMIWITHOUTVAT' + isnull(@p_separator_str, '') +
                'PRPCMMIVATOFTHECMMI' + isnull(@p_separator_str, '') +
                'PRPCMMITOTCMMIWITHVAT' + isnull(@p_separator_str, '') +
                'PRPCMMITOTCMMIWITHVATWITHOUT' + isnull(@p_separator_str, '') +
                'PRPTAXRENTA' + isnull(@p_separator_str, '') +
                'PRPTAXICA' + isnull(@p_separator_str, '') +
                'PRPTAXIVA' + isnull(@p_separator_str, '') +
                'PRPTOTQUANTITYOWED' + isnull(@p_separator_str, '') +
                'PRPCMMONDUTYACCOUNTBALANCE' + isnull(@p_separator_str, '') +
                'LOTTERYBILLING' + isnull(@p_separator_str, '') +
                'LOTTPENDINGBALANFIDUCIA' + isnull(@p_separator_str, '') +
                'LOTTPENDINGBALANGTECH' + isnull(@p_separator_str, '') +
                'LOTTPREVIOUSBALANTOTAMOUNT' + isnull(@p_separator_str, '') +
                'LOTTADJUSTMENTS' + isnull(@p_separator_str, '') +
                'LOTTCONSOLIDATEDTAXIVA' + isnull(@p_separator_str, '') +
                'LOTTTOTCURRENTWEEK' + isnull(@p_separator_str, '') +
                'LOTTTOTQUANTITYOWED' + isnull(@p_separator_str, '') +
                'LOTTOWEDFIDUCIARY' + isnull(@p_separator_str, '') +
                'LOTTOWEDGTECH' + isnull(@p_separator_str, '') +
                'LOTTGROSSCMMI' + isnull(@p_separator_str, '') +
                'LOTTINCOMETAX' + isnull(@p_separator_str, '') +
                'LOTTTAXINDUSTRYANDCMMERCE' + isnull(@p_separator_str, '') +
                'LOTTINSURANCEOWED' + isnull(@p_separator_str, '') +
                'LOTTCMMIFINAL' + isnull(@p_separator_str, '') +
                'LOTTGTEREFERENCENUMBERGTECH' + isnull(@p_separator_str, '') +
                'LOTTGTEBANKACCOUNTNUMBERGTECH' + isnull(@p_separator_str, '') +
                'LOTTGTEPREVIOUSBALANCEGTECH' + isnull(@p_separator_str, '') +
                'LOTTFIDREFERENCENUMBERFID' + isnull(@p_separator_str, '') +
                'LOTTFIDBANKACCOUNTNUMBERFID' + isnull(@p_separator_str, '') +
                'LOTTFIDPREVIOUSBALANCEFID' + isnull(@p_separator_str, '') +
                'XID_PUNTODEVENTA' + isnull(@p_separator_str, '') +
                'XID_PUNTODEVENTA NOMPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'ID_AGRUPACIONPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'ID_AGRUPACIONPUNTODEVENTA NOMAGRUPACIONPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODTIPOPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODTIPOPUNTODEVENTA NOMTIPOPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'CODPUNTODEVENTACABEZA' + isnull(@p_separator_str, '') +
                'CODPUNTODEVENTACABEZA CODIGOGTECHPUNTODEVENTA' + isnull(@p_separator_str, '') +
                'SLIPXML' + ' ';
    END 

    IF SUBSTRING(@l_title_str, 1, 2) = 'ID'
    BEGIN
        SET @l_title_str =
            '' +
            ISNULL(SUBSTRING(@l_title_str, 1, CHARINDEX(',', @l_title_str)-1), '') +
            '' +
            ISNULL(SUBSTRING(@l_title_str, CHARINDEX(',', @l_title_str), LEN(@l_title_str)), '');
    END 

    -- Set up the select string
    SET @l_select_str = @p_select_str;
    IF @p_select_str IS NULL
    BEGIN
        SET @l_select_str =
                ' isnull(VW_DEPOSITSLIPHEADER_.LASTBILLINGDATE, ''mm/dd/yyyy hh24:mi'', '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.BILLINGDATE, ''mm/dd/yyyy hh24:mi'', '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_DEPOSITSLIPHEADER_.CHAINNUMBER, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_DEPOSITSLIPHEADER_.POSNUMBER, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_DEPOSITSLIPHEADER_.TERMINALNUMBER, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_DEPOSITSLIPHEADER_.ID_MAESTROFACTURACIONTIRILLA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_DEPOSITSLIPHEADER_.REFERENCENUMBER, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.BILLPAYBILLING, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_DEPOSITSLIPHEADER_.BILLPAYBANKACCOUNTNUMBER, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.BILLPAYPRODTOTAMOU, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.BILLPAYDEPONLPRODTOTAMOU, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.BPNCMMIBILLPAYMN, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.BPNCMMIEVOUCHERS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.BPNCMMIERECHARGE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_DEPOSITSLIPHEADER_.BPNCMMIDEPONLINE AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.BPNCMMITOTCMMIWITHOUTVAT, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.BPNCMMIVATOFTHECMMI, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.BPNCMMITOTCMMIWITHVAT, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.BPNCMMITOTCMMIWITHVATWITHOUT, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.BPNTAXRENTA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.BPNTAXICA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.BPNTAXIVA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.BILLPAYTOTQUANTITYOWED, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.BILLPAYBILLDUTYACCOUNTBALANCE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_DEPOSITSLIPHEADER_.PREPAIDBILLING AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_DEPOSITSLIPHEADER_.PRPBANKACCOUNTNUMBER, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.PRPEVOUCHERPRODTOTAMOU, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.PRPERECHARGEPRODTOTAMOU, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.PRPCMMIBILLPAYMN, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.PRPCMMIEVOUCHERS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.PRPCMMIERECHARGE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_DEPOSITSLIPHEADER_.PRPCMMIDEPONLINE AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.PRPCMMITOTCMMIWITHOUTVAT, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.PRPCMMIVATOFTHECMMI, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.PRPCMMITOTCMMIWITHVAT, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.PRPCMMITOTCMMIWITHVATWITHOUT, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.PRPTAXRENTA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.PRPTAXICA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.PRPTAXIVA, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.PRPTOTQUANTITYOWED, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.PRPCMMONDUTYACCOUNTBALANCE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.LOTTERYBILLING, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_DEPOSITSLIPHEADER_.LOTTPENDINGBALANFIDUCIA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.LOTTPENDINGBALANGTECH, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.LOTTPREVIOUSBALANTOTAMOUNT, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.LOTTADJUSTMENTS, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_DEPOSITSLIPHEADER_.LOTTCONSOLIDATEDTAXIVA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.LOTTTOTCURRENTWEEK, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.LOTTTOTQUANTITYOWED, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_DEPOSITSLIPHEADER_.LOTTOWEDFIDUCIARY AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.LOTTOWEDGTECH, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.LOTTGROSSCMMI, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.LOTTINCOMETAX, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.LOTTTAXINDUSTRYANDCMMERCE, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.LOTTINSURANCEOWED, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.LOTTCMMIFINAL, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_DEPOSITSLIPHEADER_.LOTTGTEREFERENCENUMBERGTECH, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(VW_DEPOSITSLIPHEADER_.LOTTGTEBANKACCOUNTNUMBERGTECH, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.LOTTGTEPREVIOUSBALANCEGTECH, '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_DEPOSITSLIPHEADER_.LOTTFIDREFERENCENUMBERFID) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR(VW_DEPOSITSLIPHEADER_.LOTTFIDBANKACCOUNTNUMBERFID) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_DEPOSITSLIPHEADER_.LOTTFIDPREVIOUSBALANCEFID AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_DEPOSITSLIPHEADER_.ID_PUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t0.NOMPUNTODEVENTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_DEPOSITSLIPHEADER_.ID_AGRUPACIONPUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t1.NOMAGRUPACIONPUNTODEVENTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_DEPOSITSLIPHEADER_.CODTIPOPUNTODEVENTA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull( t2.NOMTIPOPUNTODEVENTA, ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(CAST(VW_DEPOSITSLIPHEADER_.CODPUNTODEVENTACABEZA AS VARCHAR(MAX)), '''') + ''' + isnull(@p_separator_str, '') + ''' +' +
                ''''' + REPLACE( isnull(CAST(TO_NCHAR( t3.CODIGOGTECHPUNTODEVENTA) AS VARCHAR(MAX)), ''''), '''', '''') + ''''  + ''' + isnull(@p_separator_str, '') + ''' +' +
                ' isnull(VW_DEPOSITSLIPHEADER_.SLIPXML, '''') + '' ''';
    END 

    -- Set up the from string (with table alias) and the join string
    SET @l_from_str = 'WSXML_SFG.VW_DEPOSITSLIPHEADER VW_DEPOSITSLIPHEADER_ LEFT OUTER JOIN WSXML_SFG.PUNTODEVENTA t0 ON (VW_DEPOSITSLIPHEADER_.ID_PUNTODEVENTA =  t0.ID_PUNTODEVENTA) LEFT OUTER JOIN WSXML_SFG.AGRUPACIONPUNTODEVENTA t1 ON (VW_DEPOSITSLIPHEADER_.ID_AGRUPACIONPUNTODEVENTA =  t1.ID_AGRUPACIONPUNTODEVENTA) LEFT OUTER JOIN WSXML_SFG.TIPOPUNTODEVENTA t2 ON (VW_DEPOSITSLIPHEADER_.CODTIPOPUNTODEVENTA =  t2.ID_TIPOPUNTODEVENTA) LEFT OUTER JOIN WSXML_SFG.PUNTODEVENTA t3 ON (VW_DEPOSITSLIPHEADER_.CODPUNTODEVENTACABEZA =  t3.ID_PUNTODEVENTA)';

    SET @l_join_str = @p_join_str;
    IF @p_join_str IS NULL
    BEGIN
        SET @l_join_str = ' ';
    END 

    -- Set up the where string
    SET @l_where_str = ' ';
    IF @p_where_str IS NOT NULL
    BEGIN
        SET @l_where_str = isnull(@l_where_str, '') + 'WHERE ' + isnull(@p_where_str, '');
    END 

    -- Construct the query string.  Append the result set with the title.
    SET @l_query_select =
'SELECT ';
    SET @l_query_union =
' UNION ALL ' +
            'SELECT ';
    SET @l_query_from =
            ' FROM ' + isnull(@l_from_str, '') + ' ' + isnull(@l_join_str, '') + ' ' +
            isnull(@l_where_str, '');

    -- Run the query
    SET @sql = 
    (' '+isnull(@l_query_select, '') + isnull(@l_title_str, '') + isnull(@l_query_union, '') + isnull(@l_select_str, '')+ isnull(@l_query_from, '')+' ');
    EXECUTE sp_executesql @sql;

END;
GO






