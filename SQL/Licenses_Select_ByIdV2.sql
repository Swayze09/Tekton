USE [Flow]
GO
/****** Object:  StoredProcedure [dbo].[Licenses_Select_ByIdV2]    Script Date: 8/31/2022 3:13:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Josue Alvarez
-- Create date: 07/27/2022
-- Description:	Table to get all Licenses by Id.
-- Code Reviewer: Travis Lindsey

-- MODIFIED BY: Freddy Valdez
-- MODIFIED DATE:08/19/2022
-- Code Reviewer: Kenneth Garcia
-- Note: Can now view ValidationType ValidatedBy,FileId,FileUrl,FileType
-- =============================================


ALTER proc [dbo].[Licenses_Select_ByIdV2]
			@Id int
as
/*---Test Code---
			Declare @Id int = 52;

			Execute [dbo].[Licenses_Select_ByIdV2] @Id
				

			Select *
			From [dbo].[Licenses]
			Where Id = @Id

*/

BEGIN

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
	Where l.Id = @Id



END