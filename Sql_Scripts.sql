			
/*Find a string by searching all tables in SQL Server*/

DECLARE @SearchStr nvarchar(100)
SET @SearchStr = 'Back-To-Wall-WC-Unit'
 
CREATE TABLE #Results (ColumnName nvarchar(370), ColumnValue nvarchar(3630))
 
SET NOCOUNT ON
 
DECLARE @TableName nvarchar(256), @ColumnName nvarchar(128), @SearchStr2 nvarchar(110)
SET  @TableName = ''
SET @SearchStr2 = QUOTENAME('%' + @SearchStr + '%','''')
 
WHILE @TableName IS NOT NULL
 
BEGIN
    SET @ColumnName = ''
    SET @TableName = 
    (
        SELECT MIN(QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME))
        FROM     INFORMATION_SCHEMA.TABLES
        WHERE         TABLE_TYPE = 'BASE TABLE'
            AND    QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) > @TableName
            AND    OBJECTPROPERTY(
                    OBJECT_ID(
                        QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME)
                         ), 'IsMSShipped'
                           ) = 0
    )
 
    WHILE (@TableName IS NOT NULL) AND (@ColumnName IS NOT NULL)
         
    BEGIN
        SET @ColumnName =
        (
            SELECT MIN(QUOTENAME(COLUMN_NAME))
            FROM     INFORMATION_SCHEMA.COLUMNS
            WHERE         TABLE_SCHEMA    = PARSENAME(@TableName, 2)
                AND    TABLE_NAME    = PARSENAME(@TableName, 1)
                AND    DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar', 'int', 'decimal')
                AND    QUOTENAME(COLUMN_NAME) > @ColumnName
        )
 
        IF @ColumnName IS NOT NULL
         
        BEGIN
            INSERT INTO #Results
            EXEC
            (
                'SELECT ''' + @TableName + '.' + @ColumnName + ''', LEFT(' + @ColumnName + ', 3630) FROM ' + @TableName + ' (NOLOCK) ' +
                ' WHERE ' + @ColumnName + ' LIKE ' + @SearchStr2
            )
        END
    END   
END
 
SELECT ColumnName, ColumnValue FROM #Results
 
DROP TABLE #Results
----------------------------------------------------------------
--Identify all stored procedures referring a particular table
SELECT Name
FROM sys.procedures
WHERE OBJECT_DEFINITION(OBJECT_ID) LIKE '%tblBestSeller%'

----------------------------------------------------------------
/* Update user role */
update 	Qs_MemeberRoles 
set 	RoleId = 'c35f46a6-983a-43b7-9a62-050475c541cc' 
where 	UserId = '984dcf80-6b72-4862-8495-6a8c593ab6d4'
----------------------------------------------------------------
/* Insert New Claim */
INSERT INTO Qs_MemeberClaims (UserId, ClaimType, ClaimValue)
VALUES 		(
				'984dcf80-6b72-4862-8495-6a8c593ab6d4', 
				'RoleList', 
				'RoleList.cshtml'
			);
----------------------------------------------------------------
/*
Id	Name
b2dc1ce1-3d35-4a78-845b-3b64119f51b0	PRODUCT
c35f46a6-983a-43b7-9a62-050475c541cc	ADMINISTRATOR


604573aa-160e-4eb5-8845-226840b252e2	ferrywalter
984dcf80-6b72-4862-8495-6a8c593ab6d4	TomFernandis
*/
----------------------------------------------------------------
/* List all the tables in a database */
SELECT table_name
FROM INFORMATION_SCHEMA.TABLES
WHERE table_type = 'BASE TABLE'
AND	  table_name like '%best%'
---------------------------------------------------------------
--Search from all store procedures, functions, views and triggers
SELECT DISTINCT so.name
FROM syscomments sc
INNER JOIN sysobjects so ON sc.id=so.id
WHERE sc.TEXT LIKE '%tblProductColorOptions%'
ORDER BY so.name

----------------------------------------------------------------
/* Find all tables containing column with specified name */
SELECT      c.name  AS 'ColumnName'
            ,t.name AS 'TableName'
FROM        sys.columns c
JOIN        sys.tables  t   ON c.object_id = t.object_id
WHERE       c.name LIKE '%SKU%'
ORDER BY    TableName
            ,ColumnName;
			
-------------------------------------------------------------------------------------------------
/* Insert IP Address */
INSERT INTO tblLoginIPConfig (vcLoginIP, dtAddedOn, vcDescription)
VALUES ('152.57.168.232', '2023-04-29 07:16:28.233', 'sarang');

INSERT INTO tblLoginIPConfig (vcLoginIP, dtCreatedOn, vcDescription, dtValidTill)
VALUES ('45.115.55.13', '2023-04-29 07:16:28.233', 'sarang', '2025-04-29 07:16:28.2330000');

-------------------------------------------------------------------------------------------------
/* column names and its type lists */

SELECT Column_Name, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = N'tblProducts' AND COLUMN_NAME IN(
'vcOPPriceGroup','intOPQty','ftPrice','ftListPrice','frWeekEndPrice','intItemInStock','vcPacking','vcMfcCode'
)
-------------------------------------------------------------------------------------------------
/* Select option by name */
select * from tblOptions where vcOptionDescr = 'ztest 111'

-------------------------------------------------------------------------------------------------
SELECT * FROM tblOptionCosting where vcSupplier = 'zzSupplier' --intOptionCostingID - 69985

SELECT * FROM tblProducts where vcSupplier = 'zzSupplier'
------------------------------------------------------------------------------------------------
/* Get common products and options Data */
SELECT		TOP 100 * 
FROM		tblOptions op
INNER JOIN	tblProducts pr
ON			op.intProductID = pr.intProductID
----------------------------------------------------------------------------------------------
/* Get product and option by name */
DECLARE			 @optionaName 
NVARCHAR(MAX) = '215X200 mm'

SELECT	intProductID,* 
FROM	tblOptions 
WHERE	vcOptionDescr = @optionaName

SELECT	* 
FROM	tblProducts 
WHERE	vcTitle = @optionaName
----------------------------------------------------------------------------------------------
/*Linq query for get Options */
from t in TblOptions
join p in TblProducts
on t.IntProductID equals p.IntProductID
select new
{
    p.VcSKU,
    p.VcTitle,
    p.VcOPPriceGroup,
    p.VcBrandTitle,
    p.VcMfcCode,
    t.FtPrice,
    p.FtListPrice,
    p.FtWeekEndPrice,
    p.IntItemsInStock,
    t.BtActive,
    p.VcPaking,
    p.IntParcelSizeID,
    t.VcImagePath
}
----------------------------------------------------------------------------------------------

from t in TblOptions
join p in TblProducts
on t.IntProductID equals p.IntProductID
where(p.VcSKU.Contains("2286") && p.BtActive != 2)
orderby p.VcSKU
select new
{
	p.BtActive,
	p.VcSKU,
	p.VcTitle,
	p.VcOPPriceGroup,
	p.VcBrandTitle,
	p.VcMfcCode,
	t.FtPrice,
	p.FtListPrice,
	p.FtWeekEndPrice,
	p.IntItemsInStock,
	//t.BtActive,
	p.VcPaking,
	p.IntParcelSizeID,
	t.VcImagePath
}
-------------------------------------------------------------------------------------------------
SELECT		p.vcOPPriceGroup,		--Option Group
			oc.vcSupplier,			--Supplier
			p.vcSupplier as p_vcSupplier,
			oc.vcBrand,				--Brand
			-- Product S.P. Ex VAT??	
			-- Product Margin ??
			oc.ftListPrice,			--Supplier RRP
			oc.ftRRP,				--List Price
			oc.ftDiscount,			--Discount 1 %
			oc.ftDiscount2,			--Discount 2 %
			oc.ftDiscount3,			--Discount 3 % 
			oc.ftItemCost,			--Item Cost				(CALCULATIVE)
			oc.ftPackCost,			--Packing and Handling
			oc.ftWastagePercent,	--Wastage %
			oc.ftWastage,			--Wastage				(CALCULATIVE)
			oc.ftFreeShipping,		--Free Shipping Cost
			oc.ftNetCost,			--Net Cost				(CALCULATIVE)
			p.ftPrice,				--Selling Price			(CALCULATIVE)
			oc.ftCostingSellPrice,	--Costing Selling Price (CALCULATIVE)
			--VAT Price??
			-- Selling Price Inc. VAT??
			oc.ftNetProfit,			--Net Profit			(CALCULATIVE)
			oc.ftGrossProfit,		--Gross Profit % 
			oc.ftCommission,		--Commission
			oc.ntCostingComments,	--Comments
			oc.*,
			p.*
FROM		tblOptionCosting	oc
INNER JOIN	tblProducts p
ON			oc.intProductID = p.intProductID
WHERE		oc.intProductID = 314608

/*
Similiar fields

intProductID
ntCostingComments
ftNetProfit
ftNetCost
ftSellPrice
ftFreeShipping
ftPackCost
ftWastage
ftDiscount3
ftRRP
ftDiscount
ftDiscount2
vcSupplier

*/

----------------------------------------------------------------------------------------
void Main()
{
	int? categoryid = 108,
	subcategoryid = 612,
	subsubcategoryid = null;
	string groupName = "Group For";
	var result = (from g in TblGroupCategoryMappings
	join c in MstCategoryGroups
	on g.IntCategoryGroupId equals c.IntCategoryGroupId
	where g.IntCategoryID == (categoryid != null && categoryid > 0 ? categoryid: g.IntCategoryID) &&
	g.IntSubCatID == (subcategoryid != null && subcategoryid > 0 ? subcategoryid: g.IntSubCatID) &&
	c.VcCategoryGroup.Contains(!string.IsNullOrWhiteSpace(c.VcCategoryGroup)? groupName: c.VcCategoryGroup)
	select new
	{
		g.IntGrpCategoryID,
		g.IntCategoryID,
		g.IntSubCatID,
		g.IntSubSubCatID,
		c.VcCategoryGroup,
		c.VcLink,
		c.IntSortOrder
	});
	result.Dump();
}

// You can define other methods, fields, classes and namespaces here
----------------------------------------------------------------------------------------
--Get all stored procedures
SELECT 
  SCHEMA_NAME(schema_id) AS [Schema],
  Name
FROM sys.procedures;
----------------------------------------------------------------------------------------
--Get all foreign key table information
EXEC sp_fkeys 'tblProducts'
----------------------------------------------------------------------------------------
-- Update Best Seller brand wise Command
void Main()
{
	DateTime targetDate = new DateTime(2019, 6, 1);
	int intBrandID = 123;
	 
	var result = (from oi in TblOrderItems
	join o in TblOrders on oi.IntOrderID equals o.IntOrderID
	join p in TblProducts on oi.IntProductID equals p.IntProductID
	where		o.IntOrderStatus == 5  
	&&			o.BtPaidStatus == 2 
	&&			p.IntBrandID == intBrandID
	&&			p.BtActive == 1 
	&& 			p.BtOption == false
	&&			(o.DtOrderOn >= targetDate)
	group oi by oi.IntProductID into g
	select new
	{
		intProductID = g.Key,
	    COUNTS = g.Sum(oi => oi.IntQty)
	}
	)
	.OrderByDescending(g => g.COUNTS)
	.Take(30);
	
	
	result.Dump();
	
}

----------------------------------------------------------------------------------------
-- Update Best Seller brand wise Command
select		top 30 A.intProductID,Sum(A.intQty) AS COUNTS
from		tblOrderItems A
INNER JOIN	tblOrder C 
on			A.intOrderID=C.intOrderID 
INNER JOIN	tblProducts E 
on			A.intProductID = E.intProductID
WHERE		c.intOrderStatus = 5  
AND			c.btPaidStatus=2 
AND			E.intBrandID = intBrandID
AND			E.btActive=1 and E.btOption=0
AND			(C.dtOrderOn >='06/01/2019 00:00:00')
AND			E.intProductID = 5910
GROUP BY	A.intProductID order by COUNTS desc  
----------------------------------------------------------
-- Get all brands but using inner join
(from m in MstBrands
        join t in TblProducts on m.IntBrandID equals t.IntBrandID
        where t.BtActive == 1 
        group t by new
        {
            m.IntBrandID,
            m.VcBrandName,
            m.BtShowOnBottom,
            m.BtActive,
            m.VcBrandImage,
        } into g
		orderby g.Key.VcBrandName ascending
        select new
        {
            g.Key.IntBrandID,
            g.Key.VcBrandName,
            g.Key.BtShowOnBottom,
            g.Key.BtActive,
            g.Key.VcBrandImage,
            CountProduct = g.Count()
        })
        .Take(100)
----------------------------------------------------------
-- Brand Categories 

(from bc in MstBrandCategories
join b in MstBrands
on bc.IntBrandID equals b.IntBrandID
join p in TblProducts on bc.IntBrandCategoryID equals p.IntBrandCategoryID into joinedProducts
from product in joinedProducts.DefaultIfEmpty()
where b.BtActive == true &&
(product.BtActive == 1 || product.BtActive == null)
group product by new
{
  bc.IntBrandCategoryID,
  b.VcBrandName,
  bc.VcBrandCatName,
  b.BtActive,
  bc.IntSortOrder
} into g
orderby g.Key.VcBrandName ascending
select new 
{
 BrandCategoryID = g.Key.IntBrandCategoryID,
 BrandName = g.Key.VcBrandName,
 BrandCatName = g.Key.VcBrandCatName,
 ProductCount = g.Count(),
 Active = g.Key.BtActive != null && g.Key.BtActive.Value  ? "Y" : "N" ,
 SortOrder = g.Key.IntSortOrder,
}).Take(400)


entityQuery = (from bc in _context.AppBrandCategory
                                                              join b in _context.AppBrand
                                                              on bc.intBrandID equals b.intBrandID
                                                              join p in _context.AppProduct on bc.intBrandCategoryID equals p.intBrandCategoryID into joinedProducts
                                                              from product in joinedProducts.DefaultIfEmpty()
                                                              where b.btActive == true &&
                                                              (product.btActive == 1) &&
                                                              bc.btActive == true &&
                                                              bc.intBrandID == (request.brand != null && request.brand > 0 ? request.brand : bc.intBrandID) &&
                                                              bc.vcBrandCatName.Contains(!string.IsNullOrWhiteSpace(request.SearchBrandCategory) ? request.SearchBrandCategory : bc.vcBrandCatName)


                                                              group product by new
                                                              {
                                                                  bc.intBrandCategoryID,
                                                                  b.vcBrandName,
                                                                  bc.vcBrandCatName,
                                                                  bc.btActive,
                                                                  bc.intSortOrder
                                                              } into g
                                                              orderby g.Key.vcBrandName ascending
                                                              select new BrandResponseModel()
                                                              {
                                                                  BrandCategoryID = g.Key.intBrandCategoryID,
                                                                  BrandName = g.Key.vcBrandName,
                                                                  BrandCatName = g.Key.vcBrandCatName,
                                                                  ProductCount = g.Count(),
                                                                  Active = g.Key.btActive,
                                                                  SortOrder = g.Key.intSortOrder,
                                                              }).AsNoTracking().ToList().AsQueryable();
--------------------------------------------------------------------
--insert mstSupplier
INSERT INTO mstSupplier(vcCompanyName,vcAddress,vcCountry,vcPostalCode,vcPhoneNo,vcFaxNo,vcEmail,vcOtherEmail,vcURL,vcSupplierName,vcNMBSName,ftMonthlyRebatePercent,ftQuaterlyRebatePercent,ftAnnualRebatePercent,ftMktgAnnualRebatePercent,btHideInOrder,vcLast_Access_Ip,vcCreatedBy,dtCreatedOn,vcModified_By,dtModified_Date) VALUES ('Aqualux21','Universal Point,  Steelmans Road,  Off Park Lane,  Wednesbury','West Midlands','WS10 9UZ','0121 395 2000','0870 241 6132','Salesadmin@aqualux.co.uk','c.grey@uk.fetimgroup.com','www.aqualux.co.uk','Aqualux Products Limited','Aqualux',1,1,1,0,1,0,0,'2023-06-20 07:35:38.0930000',0,GETUTCDATE());
---------------------------------------------------------------------
DECLARE @PageSize INT = 10;
DECLARE @PageNumber INT = 2;

SELECT *
FROM (
    SELECT *,
        ROW_NUMBER() OVER (ORDER BY intOptionID) AS RowNumber,
        COUNT(*) OVER () AS TotalCount
    FROM [tblOptions]
) AS TempTable
WHERE RowNumber BETWEEN ((@PageNumber - 1) * @PageSize) + 1 AND @PageNumber * @PageSize;
---------------------------------------------------------------------
int pageSize = 10;
int pageNumber = 2;

var query = (
    from option in dbContext.tblOptions
    orderby option.intOptionID
    select option
).AsEnumerable()
 .Select((option, index) => new { Option = option, RowNumber = index + 1 });

int totalCount = query.Count();

var result = query
    .Where(temp => temp.RowNumber >= ((pageNumber - 1) * pageSize) + 1 && temp.RowNumber <= pageNumber * pageSize)
    .Select(temp => temp.Option)
    .ToList();
---------------------------------------------------------------------
--Final script for pagination
int pageSize = 10;
int pageNumber = 3;

var query = (
    from option in TblOptions
    orderby option.IntOptionID
    select new 
	{
		option.IntOptionID,
		option.VcOptionDescr
	}
).Skip((pageNumber - 1) * pageSize).Take(pageSize);
var result = query.ToList();
result.Dump();

--respected SQL
-- Region Parameters
-- @__p_0='10'
-- EndRegion
SELECT [t].[intOptionID] AS [IntOptionID], [t].[vcOptionDescr] AS [VcOptionDescr]
FROM [tblOptions] AS [t]
ORDER BY [t].[intOptionID]
OFFSET 20 ROWS FETCH NEXT 10 ROWS ONLY
GO
---------------------------------------------------------------------
--Standard pagination records
DECLARE @PageSize INT = 10;
DECLARE @PageNumber INT = 3;

SELECT *
FROM (
    SELECT *,
        ROW_NUMBER() OVER (ORDER BY intOptionID) AS RowNumber,
        COUNT(*) OVER () AS TotalCount
    FROM [tblOptions]
) AS TempTable
WHERE RowNumber BETWEEN ((@PageNumber - 1) * @PageSize) + 1 AND @PageNumber * @PageSize;

------------------------------------------------------------------
--Update Product Step 2 Fields
SELECT	ntMFCInfo,
		vcThumbnailURL,
		vcImageURL,
		vcColorImageURL1,
		vcColorImageTitle1,
		vcImagePrefixKey1,
		vcColorImageURL2,
		vcColorImageTitle2,
		vcImagePrefixKey2,
		vcColorImageURL3,
		vcColorImageTitle3,
		vcImagePrefixKey3,
		vcColorImageURL4,
		vcColorImageTitle4,
		vcImagePrefixKey4,
		vcColorImageURL5,
		vcColorImageTitle5,
		vcImagePrefixKey5,
		vcBrandCategoryPrefixImageURL1,
		vcBrandCategoryPrefixTitle1,
		intBrandCategoryPrefixId1,
		vcBrandCategoryPrefixImageURL2,
		vcBrandCategoryPrefixTitle2,
		intBrandCategoryPrefixId2,
		vcBrandCategoryPrefixImageURL3,
		vcBrandCategoryPrefixTitle3,
		intBrandCategoryPrefixId3,
		vcBrandCategoryPrefixImageURL4,
		vcBrandCategoryPrefixTitle4,
		intBrandCategoryPrefixId4
FROM	tblProducts 
WHERE	intProductID = 74
------------------------------------------------------------------
var user = await _userManager.FindByNameAsync(User.Identity.Name);
var roll = await _userManager.GetRolesAsync(user);
------------------------------------------------------------------
--Get Supplier order with different color boxes
SELECT TOP(1) [t0].[DtExpDelDate], [t0].[DtPlaceOn], [t0].[VcDType], [t2].[vcTitle] AS [VcTitle], [t].[BtRecieved], [m].[vcComanyName] AS [VcCompanyName]
FROM [tblSupplierOrder_Items] AS [t]
INNER JOIN [tblSupplierOrders] AS [t0] ON [t].[IntSupplierOrderID] = [t0].[IntSupplierOrderID]
INNER JOIN [tblOrderItems] AS [t1] ON [t].[IntOrderItemID] = [t1].[IntOrderItemID]
INNER JOIN [tblProducts] AS [t2] ON [t1].[IntProductID] = [t2].[intProductID]
LEFT JOIN [mstSupplier] AS [m] ON [t0].[IntSupplierID] = [m].[intSupplierID]
WHERE ([t].[IntOrderItemID] = 2089096) AND [t].[IntOrderItemOptionID] IS NULL

------------------------------------------------------------------
--Display order details
DECLARE @orderID INT = 3215550

select		ItemValue=('ORDItem-'+Cast(A.intOrderItemID as varchar)),
			ItemText=(vcParentSKU + ' # ' + vcMergedTitle) 
from		tblOrderItems A 
Inner join	tblOrder O 
on			A.intOrderId=O.intOrderId 
inner join	tblProducts B 
on			A.intProductID=B.intProductID 
where		ISNULL(A.vcMFC,'NULL')<>'NULL' 
AND			A.btIsMerged=1 
AND			O.dtOrderOn >='25 Feb 2023 00:00:00' 
AND			A.intOrderID=@orderID 
and			intOrderItemID not in(
									select	intOrderItemID 
									from	tblSupplierOrder_Items 
									where	A.intOrderID=@orderID 
									and		intOrderItemOptionID is NULL
								) 
								
UNION ALL	

select		ItemValue=('ORDItem-'+Cast(A.intOrderItemID as varchar)),
			ItemText=(B.vcSKU + ' # ' + B.vcPromotion3) 
from		tblOrderItems A 
Inner join	tblOrder O 
on			A.intOrderId=O.intOrderId 
inner join	tblProducts B 
on			A.intProductID=B.intProductID 
where		O.dtOrderOn <'25 Feb 2023 00:00:00' 
AND			A.intOrderID=@orderID 
and			intOrderItemID not in (
										select	intOrderItemID 
										from	tblSupplierOrder_Items 
										where	A.intOrderID=@orderID 
										and		intOrderItemOptionID is NULL
									) 
UNION  

select		ItemValue=('ORDItemOption-'+ Cast(A.intOrderItemID as varchar) + '-' + Cast(A.intOrderItemOptionID as varchar)),
			ItemText=(B.vcOptionOrderDescr + ' # ') 
from		tblOrderItemOptions A 
inner join	tblOptions B 
on			A.intOptionID=B.intOptionID 
where		A.intOrderID=@orderID 
and			A.intOrderItemOptionID in ( 
											select distinct intOrderItemOptionID 
											from			tblOrderItemOptions 
											where			intOrderID=@orderID and 
															((intOrderItemOptionID not in( 
																							select	intOrderItemOptionID 
																							from	tblSupplierOrder_Items 
																							where	intOrderID=@orderID 
																							and		intOrderItemOptionID is not NULL
																							) 
															)) 
										)

----------------------------------------------------------------------------------------------------------------------------
/* Create script for add columns into existing table */
--Store table list 
Create Table #TableList(TableName NVARCHAR(MAX))
insert into #TableList values ('mstCategorySideGroup');
insert into #TableList values ('mstOptionFilter');
insert into #TableList values ('mstParcelSize');
insert into #TableList values ('mstProductColorFamily');
insert into #TableList values ('mstProductFeature');
insert into #TableList values ('mstProductFeaturesExplained');
insert into #TableList values ('mstProductParameters');
insert into #TableList values ('mstProductParameterValues');
insert into #TableList values ('mstPromotion');
insert into #TableList values ('mstRoleGroup');
insert into #TableList values ('mstRoles');
insert into #TableList values ('mstStockAvailable');
insert into #TableList values ('mstSubcategory');
insert into #TableList values ('mstSubcategoryFilter');
insert into #TableList values ('mstSubSubCategory');
insert into #TableList values ('mstSupplier');
insert into #TableList values ('mstZone');
insert into #TableList values ('tblBrandCategories');
insert into #TableList values ('tblBrandCategoryRange');
insert into #TableList values ('tblBrandRange');
insert into #TableList values ('tblBrandRelated');
insert into #TableList values ('tblBrandTopProducts');
insert into #TableList values ('tblCategorySideGroups');
insert into #TableList values ('tblCrossSaleSubCatMapping');
insert into #TableList values ('tblCustomers');
insert into #TableList values ('tblFeatureCategory');
insert into #TableList values ('tblGroupCategoryMapping');
insert into #TableList values ('tblLoginlPConfig');
insert into #TableList values ('tblOfferCategory');
insert into #TableList values ('tblOptionCategory');
insert into #TableList values ('tblOptionCosting');
insert into #TableList values ('tblOptionGroupRef');
insert into #TableList values ('tblOptionGroups');
insert into #TableList values ('tblOptionlmages');
insert into #TableList values ('tblOptions');
insert into #TableList values ('tblOrder');
insert into #TableList values ('tblOrderltemOptions');
insert into #TableList values ('tblOrderltems');
insert into #TableList values ('tblOrders_PackingList');
insert into #TableList values ('tblPaftRefundOrderltemOptions');
insert into #TableList values ('tblProductColorOptions');
insert into #TableList values ('tblProductDiscount');
insert into #TableList values ('tblProductFeatures');
insert into #TableList values ('tblProductFeaturesExplained');
insert into #TableList values ('tblProductlmage');
insert into #TableList values ('tblProductMFC');
insert into #TableList values ('tblProductOptionGroups');
insert into #TableList values ('tblProductOptionSortOrder');
insert into #TableList values ('tblProductRatings');
insert into #TableList values ('tblProducts');
insert into #TableList values ('tblProductSimilar');
insert into #TableList values ('tblProductUpdate');
insert into #TableList values ('tblRecommendedProducts');
insert into #TableList values ('tblReleatedLink');
insert into #TableList values ('tblSearchKeywords');
insert into #TableList values ('tblStock');

-- Declare variables for the cursor
DECLARE @table_name NVARCHAR(MAX);

-- Declare the cursor
DECLARE table_cursor CURSOR FOR
Select TableName from #TableList


-- Variables to store column details
DECLARE @column1_name NVARCHAR(MAX);
DECLARE @column2_name NVARCHAR(MAX);
DECLARE @column3_name NVARCHAR(MAX);
DECLARE @column4_name NVARCHAR(MAX);
DECLARE @column5_name NVARCHAR(MAX);
DECLARE @data_type NVARCHAR(MAX);
DECLARE @dateTimetype NVARCHAR(MAX);

-- Initialize the column details
SET @column1_name = 'vcLast_Access_Ip';
SET @column2_name = 'vcCreatedBy';
SET @column3_name = 'dtCreatedOn';
SET @column4_name = 'vcModified_By';
SET @column5_name = 'dtModified_Date';
SET @data_type = 'VARCHAR(255)'; -- Adjust the data type as needed
SET @dateTimetype = 'DATETIME2(7)';
-- Loop through the tables and add the columns
OPEN table_cursor;
FETCH NEXT FROM table_cursor INTO @table_name;
WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @sql_statement NVARCHAR(MAX);
    SET @sql_statement = '
	
	--table use to data should be already exists
	Create Table #AlreadyExists(TableName NVARCHAR(MAX), ColumnName NVARCHAR(MAX))
	
	IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = '''+ @table_name +''' AND column_name = ''' + @column1_name +''')
	BEGIN
		PRINT(''Column exists'')
		insert into #AlreadyExists values (''' + @table_name +''', '''+ @column1_name +''');
	END
	ELSE
	BEGIN
		--if column does not exist
		ALTER TABLE ' + @table_name + '
		ADD ' + @column1_name + ' ' + @data_type + ';	
	END
	
	IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = '''+ @table_name +''' AND column_name = ''' + @column2_name +''')
	BEGIN
		PRINT(''Column exists'')
		insert into #AlreadyExists values (''' + @table_name +''', '''+ @column2_name +''');
	END
	ELSE
	BEGIN
		--if column does not exist
		ALTER TABLE ' + @table_name + '
		ADD ' + @column2_name + ' ' + @data_type + ';	
	END
    
	IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = '''+ @table_name +''' AND column_name = ''' + @column3_name +''')
	BEGIN
		PRINT(''Column exists'')
		insert into #AlreadyExists values (''' + @table_name +''', '''+ @column3_name +''');
	END
	ELSE
	BEGIN
		--if column does not exist
		ALTER TABLE ' + @table_name + '
		ADD ' + @column3_name + ' ' + @dateTimetype + ';
	END
    
	IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = '''+ @table_name +''' AND column_name = ''' + @column4_name +''')
	BEGIN
		PRINT(''Column exists'')
		insert into #AlreadyExists values (''' + @table_name +''', '''+ @column4_name +''');
	END
	ELSE
	BEGIN
		--if column does not exist
		ALTER TABLE ' + @table_name + '
		ADD ' + @column4_name + ' ' + @data_type  + ';
	END
    
	IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = '''+ @table_name +''' AND column_name = ''' + @column5_name +''')
	BEGIN
		PRINT(''Column exists'')
		insert into #AlreadyExists values (''' + @table_name +''', '''+ @column5_name +''');
	END
	ELSE
	BEGIN
		--if column does not exist
		ALTER TABLE ' + @table_name + '
		ADD ' + @column5_name + ' ' + @dateTimetype +'
	END
	SELECT * FROM #AlreadyExists
	DROP Table #AlreadyExists
	'
    EXEC sp_executesql @sql_statement;
    FETCH NEXT FROM table_cursor INTO @table_name;
END

-- Close and deallocate the cursor
CLOSE table_cursor;
DEALLOCATE table_cursor;
DROP Table #TableList
-------------------------------------------------------------------------------------------------------------------------------------
/* Cursor that update dtCreatedOn column all over the database */

-- Declare variables for the cursor
DECLARE @table_name NVARCHAR(MAX);

-- Declare the cursor
DECLARE table_cursor CURSOR FOR
--get those tables which having dtCreatedOn column
SELECT table_name FROM information_schema.columns WHERE column_name = 'dtCreatedOn'

-- Variables to store column details
DECLARE @columnCreatedOn NVARCHAR(MAX);

-- Initialize the column details
SET @columnCreatedOn = 'dtCreatedOn';
-- Loop through the tables and add the columns
OPEN table_cursor;
FETCH NEXT FROM table_cursor INTO @table_name;
WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @sql_statement NVARCHAR(MAX);
    SET @sql_statement = '
		Update '+ @table_name +' set '+ @columnCreatedOn +' = ''01/01/1753'' where '+@columnCreatedOn+' IS NULL'
	--PRINT @sql_statement;
    EXEC sp_executesql @sql_statement;
    FETCH NEXT FROM table_cursor INTO @table_name;
END

-- Close and deallocate the cursor
CLOSE table_cursor;
DEALLOCATE table_cursor;
--------------------------------------------------------------------------------------------
/* Following table and column name that having already dtCreatedOn table

mstOptionFilter	dtCreatedOn
mstPromotion	dtCreatedOn
mstRoleGroup	dtCreatedOn
mstRoles	dtCreatedOn
tblOptionCategory	dtCreatedOn
tblStock	dtCreatedOn

*/
---------------------------------------------------------------------------------------------
--Alter table - add column
ALTER TABLE tblLoginIPConfig
ADD vcLast_Access_Ip NVARCHAR(255);

ALTER TABLE tblLoginIPConfig
ADD vcCreatedBy NVARCHAR(255);

ALTER TABLE tblLoginIPConfig
ADD dtCreatedOn DATETIME2(7) NOT NULL DEFAULT GETUTCDATE();

ALTER TABLE tblLoginIPConfig
ADD vcModified_By NVARCHAR(255);

ALTER TABLE tblLoginIPConfig
ADD dtModified_Date DATETIME2(7);
---------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'mstAssuredTypes')
BEGIN

	CREATE TABLE mstAssuredTypes
	(
		intAssuredId int IDENTITY(1,1) NOT NULL,
		vcAssuredType NVARCHAR(255)
	);

	insert into mstAssuredTypes (vcAssuredType) values('Appointee')
	insert into mstAssuredTypes (vcAssuredType) values('LA')
	insert into mstAssuredTypes (vcAssuredType) values('Nominee')
	insert into mstAssuredTypes (vcAssuredType) values('Payer')
	insert into mstAssuredTypes (vcAssuredType) values('Proposer')

END
ELSE
BEGIN
	PRINT 'mstAssuredTypes table already exists'
END

IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'mstFormSeries')
BEGIN

	CREATE TABLE mstFormSeries
	(
		intSeriesId int IDENTITY(1,1) NOT NULL PRIMARY KEY,
		vcSeriesCode NVARCHAR(255),
		vcSeriesName NVARCHAR(MAX)
	);

	insert into mstFormSeries(vcSeriesCode, vcSeriesName) values('O', 'Omni series')
	insert into mstFormSeries(vcSeriesCode, vcSeriesName) values('TR', 'TROP')
	insert into mstFormSeries(vcSeriesCode, vcSeriesName) values('P', 'POS')
	insert into mstFormSeries(vcSeriesCode, vcSeriesName) values('H', 'HEALTH')
	insert into mstFormSeries(vcSeriesCode, vcSeriesName) values('C', 'Combi1')
	insert into mstFormSeries(vcSeriesCode, vcSeriesName) values('PA', 'PASA')
	insert into mstFormSeries(vcSeriesCode, vcSeriesName) values('CH', 'Combi Health')
	insert into mstFormSeries(vcSeriesCode, vcSeriesName) values('CA', 'Combi All Series')
	insert into mstFormSeries(vcSeriesCode, vcSeriesName) values('T', 'Extra Protect Term')
	

END
ELSE
BEGIN
	PRINT 'mstFormSeries table already exists'
END





IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'mstFormSections')
BEGIN

	CREATE TABLE mstFormSections
	(
		intSectionId int IDENTITY(1,1) NOT NULL PRIMARY KEY,,
		vcSectionName NVARCHAR(MAX),
		intSeriesId INT FOREIGN KEY REFERENCES mstFormSeries(intSeriesId)
	);

	insert into mstFormSections(vcSectionName) values('Health Details')
	insert into mstFormSections(vcSectionName) values('Life Style Details')
	insert into mstFormSections(vcSectionName) values('Personal Info')
	insert into mstFormSections(vcSectionName) values('Proposer Other Details')
	insert into mstFormSections(vcSectionName) values('Others')
	insert into mstFormSections(vcSectionName) values('Payer Other Details')
	insert into mstFormSections(vcSectionName) values('FATCA')
	insert into mstFormSections(vcSectionName) values('Family History')
END
ELSE
BEGIN
	PRINT 'mstFormSections table already exists'
END






IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'mstFormSubSections')
BEGIN

	CREATE TABLE mstFormSubSections
	(
		intSubSectionId int IDENTITY(1,1) NOT NULL,
		vcSubSectionName NVARCHAR(MAX)
	);
	insert into mstFormSubSections(vcSubSectionName) values('Health Question')
	insert into mstFormSubSections(vcSubSectionName) values('Life Style Details')
	insert into mstFormSubSections(vcSubSectionName) values('Financial Questionnaire')
	insert into mstFormSubSections(vcSubSectionName) values('Basic Info')
	insert into mstFormSubSections(vcSubSectionName) values('Communication Address')
	insert into mstFormSubSections(vcSubSectionName) values('Minor Life Questionnaire')
	insert into mstFormSubSections(vcSubSectionName) values('Form 60 Questionnaire')
	insert into mstFormSubSections(vcSubSectionName) values('Other Details')
	insert into mstFormSubSections(vcSubSectionName) values('Permanent Address')
	insert into mstFormSubSections(vcSubSectionName) values('Foreign Nationals Employed in India Questionnaire')
	insert into mstFormSubSections(vcSubSectionName) values('Non-Resident Indian Questionnaire')
	insert into mstFormSubSections(vcSubSectionName) values('Telephone')
	insert into mstFormSubSections(vcSubSectionName) values('Father''s Name')
	insert into mstFormSubSections(vcSubSectionName) values('Mother''s Name')
	insert into mstFormSubSections(vcSubSectionName) values('Spouse Details')
	insert into mstFormSubSections(vcSubSectionName) values('Occupation Details')
	insert into mstFormSubSections(vcSubSectionName) values('COVID-19 QUESTIONNAIRE')
	insert into mstFormSubSections(vcSubSectionName) values('Name Before Marriage (If changed )')
	insert into mstFormSubSections(vcSubSectionName) values('Fatca Details')
	insert into mstFormSubSections(vcSubSectionName) values('Family History Details')
END
ELSE
BEGIN
	PRINT 'mstFormSubSections table already exists'
END



IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'mstFieldDependencyType')
BEGIN

	CREATE TABLE mstFieldDependencyType
	(
		intDependencyTypeId int IDENTITY(1,1) NOT NULL,
		vcDependencyType NVARCHAR(MAX)
	);

	insert into mstFieldDependencyType(vcDependencyType) values('Field')
	insert into mstFieldDependencyType(vcDependencyType) values('Section')
	
END
ELSE
BEGIN
	PRINT 'mstFieldDependencyType table already exists'
END

IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'mstDependentFieldFilters')
BEGIN

	CREATE TABLE mstDependentFieldFilters
	(
		intOperatorId int IDENTITY(1,1) NOT NULL,
		vcOperator NVARCHAR(MAX),
		vcDescription NVARCHAR(MAX)
	);

	insert into mstDependentFieldFilters(vcOperator, vcDescription) values('LT', 'Less than')
	insert into mstDependentFieldFilters(vcOperator, vcDescription) values('LTE', 'Less than or equal to')
	insert into mstDependentFieldFilters(vcOperator, vcDescription) values('GT', 'Greater than')
	insert into mstDependentFieldFilters(vcOperator, vcDescription) values('GTE', 'Greater than or equal to')
	insert into mstDependentFieldFilters(vcOperator, vcDescription) values('EQ', 'Equal to')
	insert into mstDependentFieldFilters(vcOperator, vcDescription) values('NEQ', 'Not equal to')
	insert into mstDependentFieldFilters(vcOperator, vcDescription) values('BETWEEN', 'Within the specified range.')
	insert into mstDependentFieldFilters(vcOperator, vcDescription) values('IN', 'Included within the specified list.')
	insert into mstDependentFieldFilters(vcOperator, vcDescription) values('NOT_IN', 'Not included within the specified list.')
	insert into mstDependentFieldFilters(vcOperator, vcDescription) values('HAS_PROPERTY', 'Has a value for the specified property')
	insert into mstDependentFieldFilters(vcOperator, vcDescription) values('NOT_HAS_PROPERTY', 'Doesn''t have a value for the specified property')
END
ELSE
BEGIN
	PRINT 'mstDependentFieldFilters table already exists'
END

IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'tblFormFields')
BEGIN

	CREATE TABLE tblFormFields
	(
		intFormFieldId int IDENTITY(1,1) NOT NULL,
		vcFieldControlName NVARCHAR(255),
		vcFieldLabel NVARCHAR(255),
		vcFieldType NVARCHAR(255),
		vcValidations NVARCHAR(MAX),
		vcFieldOptions NVARCHAR(MAX),
		vcFieldAPI NVARCHAR(MAX),
		intDisplayOrder INT,
		btShowByDefault bit,
		btIsEditable bit,
		--foreign keys start from here
		intFormSeriesID INT,
		intFormSectionID INT,
		intFormSubSectionID INT,
		intAssuredType INT,

		--dependent columns
		intDependencyTypeId INT,
		intDependentOperatorId INT,
		vcDependentStringValues NVARCHAR(MAX),
		intChildId INT NULL
	);


	/* CASE 1: Normal Text field */
	INSERT INTO tblFormFields(vcFieldControlName ,vcFieldLabel ,vcFieldType ,vcValidations ,vcFieldOptions ,vcFieldAPI ,intDisplayOrder ,btShowByDefault ,btIsEditable ,intFormSeriesID ,intFormSectionID ,intFormSubSectionID ,intAssuredType ,intDependencyTypeId ,intDependentOperatorId ,vcDependentStringValues ,intChildId)
	VALUES(		'Title',		-- vcFieldControlName
				'Title',		-- vcFieldLabel
				'text',			-- vcFieldType
				'"[\"Req\"]"',	-- vcValidations
				null,			-- vcFieldOptions
				null,			-- vcFieldAPI
				1,				-- intDisplayOrder
				1,				-- btShowByDefault
				1,				-- btIsEditable
				1,				-- intFormSeriesID
				3,				-- intFormSectionID
				4,				-- intFormSubSectionID
				2,				-- intAssuredType
				null,			-- intDependencyTypeId
				null,			-- intDependentOperatorId
				null,			-- vcDependentStringValues
				null			-- intChildId
			)

	/* CASE 2: Radio Fields */
	INSERT INTO tblFormFields(vcFieldControlName ,vcFieldLabel ,vcFieldType ,vcValidations ,vcFieldOptions ,vcFieldAPI ,intDisplayOrder ,btShowByDefault ,btIsEditable ,intFormSeriesID ,intFormSectionID ,intFormSubSectionID ,intAssuredType ,intDependencyTypeId ,intDependentOperatorId ,vcDependentStringValues ,intChildId)
	VALUES(		'gender',		-- vcFieldControlName
				'Gender',		-- vcFieldLabel
				'radio',			-- vcFieldType
				'"[\"Req\"]"',	-- vcValidations
				'[{"value":"yes","label":"Yes"},{"value":"no","label":"No"}]',			-- vcFieldOptions
				null,			-- vcFieldAPI
				2,				-- intDisplayOrder
				1,				-- btShowByDefault
				1,				-- btIsEditable
				1,				-- intFormSeriesID
				3,				-- intFormSectionID
				4,				-- intFormSubSectionID
				2,				-- intAssuredType
				null,			-- intDependencyTypeId
				null,			-- intDependentOperatorId
				null,			-- vcDependentStringValues
				null			-- intChildId
			)


	/* CASE 3: Normal Fields */
	INSERT INTO tblFormFields(vcFieldControlName ,vcFieldLabel ,vcFieldType ,vcValidations ,vcFieldOptions ,vcFieldAPI ,intDisplayOrder ,btShowByDefault ,btIsEditable ,intFormSeriesID ,intFormSectionID ,intFormSubSectionID ,intAssuredType ,intDependencyTypeId ,intDependentOperatorId ,vcDependentStringValues ,intChildId)
	VALUES(		'workOutsideCountry',		-- vcFieldControlName
				'Do you work outside your current country?',		-- vcFieldLabel
				'radio',			-- vcFieldType
				'"[\"Req\"]"',	-- vcValidations
				'[{"value":"yes","label":"Yes"},{"value":"no","label":"No"}]',			-- vcFieldOptions
				null,			-- vcFieldAPI
				3,				-- intDisplayOrder
				1,				-- btShowByDefault
				1,				-- btIsEditable
				1,				-- intFormSeriesID
				3,				-- intFormSectionID
				5,				-- intFormSubSectionID
				2,				-- intAssuredType
				1,				-- intDependencyTypeId
				5,				-- intDependentOperatorId
				'yes',			-- vcDependentStringValues
				4			-- intChildId
			)

	/* CASE 4: Dependent Fields */
	INSERT INTO tblFormFields(vcFieldControlName ,vcFieldLabel ,vcFieldType ,vcValidations ,vcFieldOptions ,vcFieldAPI ,intDisplayOrder ,btShowByDefault ,btIsEditable ,intFormSeriesID ,intFormSectionID ,intFormSubSectionID ,intAssuredType ,intDependencyTypeId ,intDependentOperatorId ,vcDependentStringValues ,intChildId)
	VALUES(		'countryLocation',		-- vcFieldControlName
				'Country location',		-- vcFieldLabel
				'text',			-- vcFieldType
				'"[\"Req\"]"',	-- vcValidations
				null,			-- vcFieldOptions
				null,			-- vcFieldAPI
				3,				-- intDisplayOrder
				0,				-- btShowByDefault
				1,				-- btIsEditable
				1,				-- intFormSeriesID
				3,				-- intFormSectionID
				4,				-- intFormSubSectionID
				2,				-- intAssuredType
				1,				-- intDependencyTypeId
				null,			-- intDependentOperatorId
				null,			-- vcDependentStringValues
				null				-- intChildId
	)

	/* CASE 5: Dependent Section */
	INSERT INTO tblFormFields(vcFieldControlName ,vcFieldLabel ,vcFieldType ,vcValidations ,vcFieldOptions ,vcFieldAPI ,intDisplayOrder ,btShowByDefault ,btIsEditable ,intFormSeriesID ,intFormSectionID ,intFormSubSectionID ,intAssuredType ,intDependencyTypeId ,intDependentOperatorId ,vcDependentStringValues ,intChildId)
	VALUES(		'IslifeStyleSection',		-- vcFieldControlName
				'Life Style Selection',		-- vcFieldLabel
				'radio',			-- vcFieldType
				'"[\"Req\"]"',	-- vcValidations
				'[{"value":"yes","label":"Yes"},{"value":"no","label":"No"}]',			-- vcFieldOptions
				null,			-- vcFieldAPI
				3,				-- intDisplayOrder
				0,				-- btShowByDefault
				1,				-- btIsEditable
				1,				-- intFormSeriesID
				3,				-- intFormSectionID
				5,				-- intFormSubSectionID
				2,				-- intAssuredType
				2,				-- intDependencyTypeId
				5,				-- intDependentOperatorId
				'yes',			-- vcDependentStringValues
				2				-- intChildId
	)

/* CASE 6: checkbox field */
INSERT INTO tblFormFields(vcFieldControlName ,vcFieldLabel ,vcFieldType ,vcValidations ,vcFieldOptions ,vcFieldAPI ,intDisplayOrder ,btShowByDefault ,btIsEditable ,intFormSeriesID ,intFormSectionID ,intFormSubSectionID ,intAssuredType ,intDependencyTypeId ,intDependentOperatorId ,vcDependentStringValues ,intChildId)
VALUES(		'isBelow18',		-- vcFieldControlName
			'Is Nominee below 18 years of age?',		-- vcFieldLabel
			'checkbox',			-- vcFieldType
			'["Req"]',	-- vcValidations
			'[{"value":"yes","label":"Yes"},{"value":"no","label":"No"}]',			-- vcFieldOptions
			null,			-- vcFieldAPI
			1,				-- intDisplayOrder
			1,				-- btShowByDefault
			1,				-- btIsEditable
			1,				-- intFormSeriesID
			3,				-- intFormSectionID
			4,				-- intFormSubSectionID
			2,				-- intAssuredType
			null,			-- intDependencyTypeId
			null,			-- intDependentOperatorId
			null,			-- vcDependentStringValues
			null			-- intChildId
)

/* CASE 7: number field */
INSERT INTO tblFormFields(vcFieldControlName ,vcFieldLabel ,vcFieldType ,vcValidations ,vcFieldOptions ,vcFieldAPI ,intDisplayOrder ,btShowByDefault ,btIsEditable ,intFormSeriesID ,intFormSectionID ,intFormSubSectionID ,intAssuredType ,intDependencyTypeId ,intDependentOperatorId ,vcDependentStringValues ,intChildId)
VALUES(		'annualIncome',		-- vcFieldControlName
			'Annual Income (in Rupees)',		-- vcFieldLabel
			'number',			-- vcFieldType
			'["REQ","INPUTNUMBER"]',	-- vcValidations
			null,			-- vcFieldOptions
			null,			-- vcFieldAPI
			1,				-- intDisplayOrder
			1,				-- btShowByDefault
			1,				-- btIsEditable
			1,				-- intFormSeriesID
			3,				-- intFormSectionID
			4,				-- intFormSubSectionID
			2,				-- intAssuredType
			null,			-- intDependencyTypeId
			null,			-- intDependentOperatorId
			null,			-- vcDependentStringValues
			null			-- intChildId
)

/* CASE 8: date field */
INSERT INTO tblFormFields(vcFieldControlName ,vcFieldLabel ,vcFieldType ,vcValidations ,vcFieldOptions ,vcFieldAPI ,intDisplayOrder ,btShowByDefault ,btIsEditable ,intFormSeriesID ,intFormSectionID ,intFormSubSectionID ,intAssuredType ,intDependencyTypeId ,intDependentOperatorId ,vcDependentStringValues ,intChildId)
VALUES(		'smokingStopDate',		-- vcFieldControlName
			'If you have stopped smoking, please state the date stopped.',		-- vcFieldLabel
			'datetime',			-- vcFieldType
			'["PATDATE"]',	-- vcValidations
			null,			-- vcFieldOptions
			null,			-- vcFieldAPI
			1,				-- intDisplayOrder
			1,				-- btShowByDefault
			1,				-- btIsEditable
			1,				-- intFormSeriesID
			3,				-- intFormSectionID
			4,				-- intFormSubSectionID
			2,				-- intAssuredType
			null,			-- intDependencyTypeId
			null,			-- intDependentOperatorId
			null,			-- vcDependentStringValues
			null			-- intChildId
)
	

/* CASE 9: Get option details by external API */
INSERT INTO tblFormFields(vcFieldControlName ,vcFieldLabel ,vcFieldType ,vcValidations ,vcFieldOptions ,vcFieldAPI ,intDisplayOrder ,btShowByDefault ,btIsEditable ,intFormSeriesID ,intFormSectionID ,intFormSubSectionID ,intAssuredType ,intDependencyTypeId ,intDependentOperatorId ,vcDependentStringValues ,intChildId)
VALUES(		'country',		-- vcFieldControlName
			'Select country',		-- vcFieldLabel
			'dropdown',			-- vcFieldType
			'REQ',	-- vcValidations
			null,			-- vcFieldOptions
			'https://restcountries.com/v3.1/currency/cop',			-- vcFieldAPI
			1,				-- intDisplayOrder
			1,				-- btShowByDefault
			1,				-- btIsEditable
			1,				-- intFormSeriesID
			3,				-- intFormSectionID
			4,				-- intFormSubSectionID
			2,				-- intAssuredType
			null,			-- intDependencyTypeId
			null,			-- intDependentOperatorId
			null,			-- vcDependentStringValues
			null			-- intChildId
)


END
ELSE
BEGIN
	PRINT 'tblFormFields table already exists'
END

IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'tblDependentFieldDetails')
BEGIN

	CREATE TABLE tblDependentFieldDetails
	(
		intDependtId int IDENTITY(1,1) NOT NULL,
		intDependencyTypeId int,
		intDependentOperatorId int,
		DependentStringValues NVARCHAR(MAX),
		intChildId int,
		intFormFieldId int
	);

	insert into tblDependentFieldDetails (intDependencyTypeId,intDependentOperatorId,DependentStringValues,intChildId,intFormFieldId) 
	values(1,5,'yes', 4, 3)
	insert into tblDependentFieldDetails (intDependencyTypeId,intDependentOperatorId,DependentStringValues,intChildId,intFormFieldId) 
	values(2,5,'no', 5, 3)

END
ELSE
BEGIN
	PRINT 'tblDependentFieldDetails table already exists'
END

IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'tblFormFieldData')
BEGIN

	CREATE TABLE tblFormFieldData
	(
		intFieldDataId int IDENTITY(1,1) NOT NULL,
		intFormFieldId int,
		vcFieldValue  NVARCHAR(MAX),
		vcApplicationNumber NVARCHAR(MAX)
	);

	insert into tblFormFieldData(intFormFieldId, vcFieldValue, vcApplicationNumber) values(1,'Sarang', 'X253')
	
END
ELSE
BEGIN
	PRINT 'tblFormFieldData table already exists'
END
----------------------------------------------------------------------
--FGLI tables

IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'tblBenifitIllustration')
BEGIN

	CREATE TABLE tblBenifitIllustration
	(
		Id int IDENTITY(1,1) NOT NULL,
		IllustrationNo NVARCHAR(255),
		SessionId NVARCHAR(255),
		UserId NVARCHAR(255),
		UserName NVARCHAR(255),
		Gender NVARCHAR(255),
		DateOfBirth DATETIME,
		Age INT,
		Smoker BIT,
		StandardAgeProof NVARCHAR(MAX),
		IsCustomerNRI BIT,
		MobileNumber NVARCHAR(255),
		EmailAddress NVARCHAR(255),
		InternaltionMobile NVARCHAR(255),
		IsProposerSame BIT,
		ProposerName NVARCHAR(255),
		ProposerGender NVARCHAR(255),
		RelationshipWithLA NVARCHAR(255), 
		ProposerDateOfBirth DATETIME,
		ProposerAge INT,
		ProposerIsCustomerNRI BIT,
		PropserMobileNumber NVARCHAR(255),
		PropserEmail NVARCHAR(255),
		ProposerInternaltionMobile NVARCHAR(255),
		IllustrationStatus NVARCHAR(255),
		IllustrationDate DATETIME,
		QuotationId INT,
		ProductCode NVARCHAR(255),
		TransactionId NVARCHAR(255),
		SumAssured INT,
		InstallmentPremium INT,
		GST INT,
		TotalPremium INT,
		IsExistingPolicy BIT,
		ExistingPolicyNo NVARCHAR(255),
		NvestProductCode NVARCHAR(100)
	);

END
ELSE
BEGIN
	PRINT 'tblBenifitIllustration table already exists'
END
---------------------------------------------------------------------------------------
--constraint format for primary key
CONSTRAINT [PK_<tableName>] PRIMARY KEY CLUSTERED 
		(
			[<id>] ASC
		)	WITH (
					PAD_INDEX = OFF, 
					STATISTICS_NORECOMPUTE = OFF, 
					IGNORE_DUP_KEY = OFF, 
					ALLOW_ROW_LOCKS = ON, 
					ALLOW_PAGE_LOCKS = ON, 
					OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
				) ON [PRIMARY]
	) ON [PRIMARY]
-----------------------------------------------------
--StandardField

vcLastAccessIP nvarchar(50) NOT NULL,
vcCreatedBy nvarchar(50) NOT NULL,
dtCreateDate datetime2(7) NOT NULL,
vcModifiedBy nvarchar(50) NULL,
dtModifiedDate datetime2(7) NULL,
dtDeletedOn datetime2(7) NULL
----------------------------------------------
USE [fgli]
GO

INSERT INTO [fgli].[tblTicketSizeExceptions]
           ([vcAgentCode]
           ,[vcAgentName]
           ,[intExceptionStatus]
           ,[intChannelMode]
           ,[btIsManagerApproval]
           ,[dtStartDate]
           ,[dtEndDate]
           ,[vcLastAccessIP]
           ,[vcCreatedBy]
           ,[dtCreateDate]
           ,[dtModifiedBy]
           ,[dtModifiedDate]
           ,[dtDeletedOn])
     VALUES
           ('123123'
           ,'Test'
           ,1
           ,1
           ,1
           ,'2023-11-29 19:00:27.4174414'
           ,'2023-11-30 19:00:27.4174414'
           ,'test'
           ,''
           ,'2023-11-29 19:00:27.4174414'
           ,'2023-11-29 19:00:27.4174414'
           ,NULL
           ,NULL)
GO

------------------------------------------------------------------
ALTER TABLE tblPF_HealthDetails
ADD vcLastAccessIP nvarchar(50) NOT NULL

ALTER TABLE tblPF_HealthDetails
ADD vcCreatedBy nvarchar(50) NOT NULL

ALTER TABLE tblPF_HealthDetails
ADD dtCreateDate datetime2(7) NOT NULL

ALTER TABLE tblPF_HealthDetails
ADD vcModifiedBy nvarchar(50) NULL

ALTER TABLE tblPF_HealthDetails
ADD dtModifiedDate datetime2(7) NULL

ALTER TABLE tblPF_HealthDetails
ADD dtDeletedOn datetime2(7) NULL
---------------------------------------------------
