use housing;
-- Exploring the dataset
select * from nashville;
-- Standardise Date Format- Not needed in MySQL
-- If need be, use:
-- select SaleDate, CONVERT(Date, SaleDate) from nashville;
-- Checking "Null" values
select * from nashville where PropertyAddress IS NULL;
-- Populate "Null" Property Address Data
-- Since there are no null values, there is no need to populate.
-- If need be, use:
-- select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) from nashville a JOIN nashville b ON a.ParcelID = b.ParcelID AND a.UniqueID = b.UniqueID;
-- To update statement (if needed), use:
-- UPDATE nashville a JOIN nashville b ON a.ParcelID = b.ParcelID AND a.UniqueID = b.UniqueID SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress) WHERE a.PropertyAddress IS NULL;
-- Breaking address into individual columns (Address, City, State)
SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(PropertyAddress, ',', 1), ',', -1) as Address,
SUBSTRING_INDEX(SUBSTRING_INDEX(PropertyAddress, ',', 2), ',', -1) as City,
SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 3), ',', -1) as State from nashville;
-- Set to off warning to include "Where" as a compulsory function in Update Table function
SET GLOBAL sql_safe_updates=0;
-- Update table to include new columns: 'Address', 'City', 'State'
ALTER TABLE nashville Add Address varchar(255);
UPDATE nashville SET Address = SUBSTRING_INDEX(SUBSTRING_INDEX(PropertyAddress, ',', 1), ',', -1);
ALTER TABLE nashville Add City varchar(255);
UPDATE nashville SET City = SUBSTRING_INDEX(SUBSTRING_INDEX(PropertyAddress, ',', 2), ',', -1);
ALTER TABLE nashville Add State varchar(255);
UPDATE nashville SET State = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 3), ',', -1);
-- Checking the elements in SoldAsVacant column
select Distinct (SoldAsVacant) from nashville;
-- Transform "Y" and "N" to "Yes" and "No"
select SoldAsVacant, 
CASE WHEN SoldAsVacant = 'Y' THEN 'YES' WHEN SoldAsVacant = 'N' THEN 'No'ELSE SoldAsVacant END From nashville;
-- Update Table
UPDATE nashville SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES' WHEN SoldAsVacant = 'N' THEN 'No'ELSE SoldAsVacant END;
-- Remove Row Duplicates (Note: this is not often used to raw data)
-- With RowNumCTE AS(Select * , ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) row_num from nashville ORDER BY ParcelID) DELETE FROM RowNumCTE WHERE row_num > 1; --> Error received--> Error Code: 1288. The target table RowNumCTE of the DELETE is not updatable
-- Delete columns (Note: this is not often used to raw data)
ALTER TABLE nashville DROP COLUMN PropertyAddress;
ALTER TABLE nashville DROP COLUMN OwnerAddress;