/*
============================================================================
Stored Procedure: Loads data from external CSV files into the bronze.

  It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze_layer.load_bronze;
============================================================================
*/

--save frequently used sql code in stored procedures in DB
CREATE OR ALTER PROCEDURE Bronze.load_bronze as 
BEGIN
	DECLARE @start_time DATETIME , @end_time DATETIME, @batch_start_time DATETIME , @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time=GETDATE();
		--Loading data 
		PRINT 'Loading Bronze layer';
		print'---------------------------';
		print'loading CRM tables';

		SET @start_time = GETDATE();
		-- To avoid dublicate , first we are making the table empty and then start loading from scratch (full load)
		print'TRUNCATE Table: Bronze.crm_cust_info';
		TRUNCATE TABLE Bronze.crm_cust_info;
		BULK INSERT Bronze.crm_cust_info
		FROM 'C:\SQL\datasets\source_crm\cust_info.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK --it will lock entire table during loading it ,used commonly during bulk load
		);
		SET @end_time = GETDATE();
		PRINT'>>Loading Duration: '+ CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR)+'sec';
		print'------------------------------------';

		SET @start_time = GETDATE();
		print'TRUNCATE Table: Bronze.crm_prd_info';
		TRUNCATE TABLE Bronze.crm_prd_info;
		BULK INSERT Bronze.crm_prd_info
		FROM 'C:\SQL\datasets\source_crm\prd_info.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>>Loading Duration: '+ CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR)+'sec';
		print'------------------------------------';

		SET @start_time = GETDATE();
		print'TRUNCATE Table: Bronze.crm_sales_details';
		TRUNCATE TABLE Bronze.crm_sales_details;
		BULK INSERT Bronze.crm_sales_details
		FROM 'C:\SQL\datasets\source_crm\sales_details.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>>Loading Duration: '+ CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR)+'sec';
		

		print'------------------------------------';
		print'DONE INSERTING DATA INTO CRM TABLES';
		print'------------------------------------';
	
		print'loading ERP tables';

		SET @start_time = GETDATE();
		print'TRUNCATE Table: Bronze.erp_cust_az12';
		TRUNCATE TABLE Bronze.erp_cust_az12;
		BULK INSERT Bronze.erp_cust_az12
		FROM 'C:\SQL\datasets\source_erp\CUST_AZ12.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		)
		SET @end_time = GETDATE();
		PRINT'>>Loading Duration: '+ CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR)+'sec';
		print'------------------------------------';

		SET @start_time = GETDATE();
		print'TRUNCATE Table: Bronze.erp_loc_a101';
		TRUNCATE TABLE Bronze.erp_loc_a101;
		BULK INSERT Bronze.erp_loc_a101
		FROM 'C:\SQL\datasets\source_erp\LOC_A101.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>>Loading Duration: '+ CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR)+'sec';
		print'------------------------------------';

		SET @start_time = GETDATE();
		print'TRUNCATE Table: Bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE Bronze.erp_px_cat_g1v2;
		BULK INSERT Bronze.erp_px_cat_g1v2
		FROM 'C:\SQL\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>>Loading Duration: '+ CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR)+'sec';
		print'------------------------------------';

		SET @batch_start_time=GETDATE();
		print'------------------------------------';
		print'DONE INSERTING DATA INTO ERP TABLES';
		PRINT'>>Total Load Duration: '+ CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS VARCHAR)+'sec';
		print'------------------------------------';
	END TRY
	BEGIN CATCH 
		PRINT'------------------------------------'
		PRINT'ERROR DURING LOADING BRONZE LAYER'
		PRINT'ERROR MESSAGE:'+ ERROR_MESSAGE();
		PRINT'ERROR MESSAGE:'+ CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT'ERROR MESSAGE:'+ CAST(ERROR_STATE() AS NVARCHAR);
		PRINT'------------------------------------'
	END CATCH

END;
