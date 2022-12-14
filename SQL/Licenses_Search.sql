USE [Flow]
GO
/****** Object:  StoredProcedure [dbo].[Licenses_Search]    Script Date: 8/31/2022 3:13:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Josue Alvarez
-- Create date: 08/19/2022
-- Description: Selects paginated results that match with the @Query parameter.
-- Code Reviewer: Mohammad (Saif)

-- MODIFIED BY:Josue Alvarez
-- MODIFIED DATE:08/25/2022
-- Code Reviewer:Freddy Valdez
-- Note:Added new columns to table as well as joins
-- =============================================

ALTER proc [dbo].[Licenses_Search]
			@PageIndex int
			,@PageSize int
			,@Query nvarchar(100) 
as
/*---Test Code---
	Declare @PageIndex int = 0
			,@PageSize int = 5
			,@Query nvarchar(100) = 'Romeo'

	Execute dbo.Licenses_Search
			@PageIndex
			,@PageSize
			,@Query

	Select* 
	From dbo.Licenses

*/

BEGIN

	Declare @Offset int = @PageIndex * @PageSize	

	SELECT l.[Id]
		  ,s.Id as [LicenseStateId]
		  ,s.Name as [State]
		  ,lt.Id as [LicenseTypeId]
		  ,lt.Name as [LicenseType]
		  ,l.[LicenseNumber]
		  ,vt.Id as [ValidationTypeId]
		  ,vt.Name as [ValidationType]
		  ,l.ValidatedBy
		  ,l.RejectMessage
		  ,l.[DateExpires]
		  ,u.Id as [CreatedBy]
		  ,up.FirstName
		  ,up.LastName
		  ,l.[DateCreated]
		  ,f.Id as [FileId]
		  ,f.Url as [FileUrl]
		  ,TotalCount = COUNT(1) OVER()
	FROM [dbo].[Licenses] as l inner join dbo.LicenseTypes as lt
			on lt.Id = l.LicenseTypeId
			inner join dbo.States as s
			on s.Id = l.LicenseStateId
			inner join dbo.Users as u
			on u.Id = l.CreatedBy
			inner join dbo.Files as f
			on f.Id = l.FileId
			inner join dbo.UserProfiles as up
			on up.UserId = l.CreatedBy
			inner join dbo.ValidationTypes as vt
			on l.ValidationTypeId = vt.Id
	WHERE CONCAT(FirstName,' ', LastName) LIKE '%' + @Query + '%'
		
	ORDER by l.DateExpires

	OFFSET @offset Rows
	Fetch Next @PageSize Rows ONLY
END


