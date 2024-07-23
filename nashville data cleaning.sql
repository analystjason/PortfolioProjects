 /*Cleaning data in Sql Queries

 */

Select*
FROM [PortofolioProject].[dbo].[nashville]


--Standardize date format

Select saledateconverted, convert(date,saledate)
FROM [PortofolioProject].[dbo].[nashville]

update nashville
set saledate = convert(date,saledate)

alter table nashville
add saledateconverted date;


update nashville
set saledateconverted = convert(date,saledate)

---------------------------------------------------------------

--Populated Property Address Data

Select *
FROM [PortofolioProject].[dbo].[nashville]
--Where PropertyAddress is null
order by 2


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress,b.PropertyAddress)
FROM [PortofolioProject].[dbo].[nashville] a
join [PortofolioProject].[dbo].[nashville] b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

UPDATE a
SET propertyaddress = ISNULL(a.propertyaddress,b.PropertyAddress)
FROM [PortofolioProject].[dbo].[nashville] a
join [PortofolioProject].[dbo].[nashville] b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

----------------------------------------------------------------------------
--Breaking out Address into Invidual Colunms(Address,City,State)

Select PropertyAddress
FROM [PortofolioProject].[dbo].[nashville]
--Where PropertyAddress is null
--order by 2

select
SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress)-1) as Address,
SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) +1, len(propertyaddress))as Address

alter table nashville
add propertysplitAddress nvarchar(255);


update nashville
set propertysplitAddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress)-1)

alter table nashville
add propertysplitCity nvarchar(255) ;


update nashville
set propertysplitCity= SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) +1, len(propertyaddress))

select*
FROM [PortofolioProject].[dbo].[nashville]


select OwnerAddress
FROM [PortofolioProject].[dbo].[nashville]


select
parsename(replace(OwnerAddress, ',','.' ),3),
parsename(replace(OwnerAddress, ',','.' ),2),
parsename(replace(OwnerAddress, ',','.' ),1)
FROM [PortofolioProject].[dbo].[nashville]


alter table nashville
add ownwersplitAddress nvarchar(255);

update nashville
set ownwersplitAddress = parsename(replace(OwnerAddress, ',','.' ),3)


alter table nashville
add ownersplitCity nvarchar(255) ;

update nashville
set ownersplitCity= parsename(replace(OwnerAddress, ',','.' ),2)



alter table nashville
add ownersplitState nvarchar(255) ;

update nashville
set  ownersplitState = parsename(replace(OwnerAddress, ',','.' ),1)

select*
FROM [PortofolioProject].[dbo].[nashville]

-----------------------------------------------------------------------------------

--Change Y and N to yes and no in "Sold as Vacant" field

select distinct(SoldAsVacant), count(SoldAsVacant)
FROM [PortofolioProject].[dbo].[nashville]
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
,case When SoldAsVacant = 'Y' Then 'Yes'
when SoldAsVacant ='N' Then 'No'
Else SoldAsVacant
End
FROM [PortofolioProject].[dbo].[nashville]

Update nashville
Set SoldAsVacant = case When SoldAsVacant = 'Y' Then 'Yes'
when SoldAsVacant ='N' Then 'No'
Else SoldAsVacant
End
--------------------------------------------------------

--Remove Duplicates

WITH RowNumCTE as(
Select*,
	row_number() OVER (
	Partition By parcelID,
				propertyaddress,
				salePrice,
				saleDate,
				LegalReference
				Order By
				UniqueId
				) Row_num


FROM [PortofolioProject].[dbo].[nashville]
--order by parcelId
)
Select*
FROM RowNumCTE
Where row_num > 1
Order by PropertyAddress


-----------------------------------------------
--Delect Unused Columns
select*
FROM [PortofolioProject].[dbo].[nashville]

ALTER TABLE [PortofolioProject].[dbo].[nashville]
DROP COLUMN  owneraddress, taxdistrict, propertyAddress

ALTER TABLE [PortofolioProject].[dbo].[nashville]
DROP COLUMN saledate