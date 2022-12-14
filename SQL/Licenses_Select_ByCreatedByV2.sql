USE [Flow]
GO
/****** Object:  StoredProcedure [dbo].[Licenses_Select_ByCreatedByV2]    Script Date: 8/31/2022 3:13:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Josue
-- Create date: 07/28/2022
-- Description:	Procedure to insert licenses
-- Code Reviewer: Travis Lindsey

-- MODIFIED BY: Josue Alvarez
-- MODIFIED DATE:08/25/2022
-- Code Reviewer: Freddy Valdez
-- Note: Added new columns ValidationTypeId, ValidationType, RejectMessage
-- =============================================

ALTER proc [dbo].[Licenses_Select_ByCreatedByV2]
		@PageIndex int
		,@PageSize int
		,@CreatedBy int

as
/*---Test Code---
		Declare @PageIndex int = 0;
		Declare @PageSize int = 5;
		Declare @CreatedBy int = 9;

		Execute [dbo].[Licenses_Select_ByCreatedByV2]
				@PageIndex
				,@PageSize
				,@CreatedBy

		Select *
		From [dbo].[Licenses]
		Where CreatedBy = @CreatedBy
*/

BEGIN

	Declare @offset int = @PageIndex * @PageSize	

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
	Where l.CreatedBy = @CreatedBy
	ORDER by l.DateExpires
	
	OFFSET @offset Rows
	Fetch Next @PageSize Rows ONLY
END


