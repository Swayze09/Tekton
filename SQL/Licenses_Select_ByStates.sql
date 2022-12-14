USE [Flow]
GO
/****** Object:  StoredProcedure [dbo].[Licenses_Select_ByStates]    Script Date: 8/31/2022 3:13:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Josue
-- Create date: 07/28/2022
-- Description:	Procedure to get licenses by state.
-- Code Reviewer: 

-- MODIFIED BY:
-- MODIFIED DATE:
-- Code Reviewer: 
-- Note:
-- =============================================

ALTER proc [dbo].[Licenses_Select_ByStates]
		@PageIndex int
		,@PageSize int
		,@State nvarchar(32)
as
/*---Test Code---
	Declare @PageIndex int = 0;
	Declare @PageSize int = 5;
	Declare @State nvarchar(32) = 'Alaska'

	Execute dbo.Licenses_Select_ByStates
			@PageIndex
			,@PageSize
			,@State

	Select*
	From [dbo].[Licenses]
	


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
	Where s.Name = @State
	ORDER by l.DateExpires

	OFFSET @offset Rows
	Fetch Next @PageSize Rows ONLY

END

