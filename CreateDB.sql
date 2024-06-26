USE [NorthernBordersProvinceDB]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Get12HoursTimeFormat]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_Get12HoursTimeFormat]
(
	@Time time(0)
)
RETURNS nvarchar(MAX)
As
BEGIN
	IF(@Time IS NULL) RETURN ''
	RETURN REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(VARCHAR(20), @Time, 100), 7)),'AM',N' ص'),'PM',N' م')
END

GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetGeorgianDate]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_GetGeorgianDate](@HijiriiDate_DD_MM_YYYY nvarchar(MAX)) RETURNS date
As
BEGIN
	DECLARE @GeorgianDate date
	
	DECLARE @HijiriDate nvarchar(MAX) = (SELECT TOP 1 Item FROM dbo.SplitString(@HijiriiDate_DD_MM_YYYY,'/') WHERE [Index] = 3) +
	'/' + (SELECT TOP 1 Item FROM dbo.SplitString(@HijiriiDate_DD_MM_YYYY,'/') WHERE [Index] = 2) +
	'/' + (SELECT TOP 1 Item FROM dbo.SplitString(@HijiriiDate_DD_MM_YYYY,'/') WHERE [Index] = 1)

	SET		@GeorgianDate = (SELECT CONVERT(date, @HijiriDate, 131))

	RETURN	@GeorgianDate
END

GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetHijiriDate]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_GetHijiriDate](@GeorgianDate date) RETURNS nvarchar(MAX)
As
BEGIN
	IF(@GeorgianDate IS NULL) RETURN ''
	DECLARE @HD nvarchar(MAX) = CONVERT(nvarchar(MAX), @GeorgianDate, 131)

	IF (@HD LIKE '__/__/____')
	BEGIN
		SET @HD = RTRIM(LTRIM(RIGHT(@HD,4))) + '/' + RTRIM(LTRIM(LEFT(RIGHT(@HD,7),2))) + '/' + RTRIM(LTRIM(LEFT(@HD,2)))
	END

	RETURN @HD
END

GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetHijiriLongDate]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_GetHijiriLongDate](@GeorgianDate date) RETURNS nvarchar(MAX)
As
BEGIN
	IF(@GeorgianDate IS NULL) RETURN ''
	DECLARE @HD nvarchar(MAX) = CONVERT(nvarchar(MAX), @GeorgianDate, 131)

	IF (@HD LIKE '__/__/____')
	BEGIN
		
		SET @HD = RTRIM(LTRIM(LEFT(@HD,2))) + ' ' + dbo.sp_GetHijiriMonthName(CAST(RTRIM(LTRIM(LEFT(RIGHT(@HD,7),2))) as int)) + ' ' + RTRIM(LTRIM(RIGHT(@HD,4)))
	END

	RETURN @HD
END

GO
/****** Object:  UserDefinedFunction [dbo].[sp_GetHijiriMonthName]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[sp_GetHijiriMonthName](@Month int) RETURNS nvarchar(50)
As
BEGIN
	DECLARE @HijiriMonths TABLE
	(
		Month_Id bigint IDENTITY(1,1),
		Name nvarchar(50)
	)
	
	INSERT INTO @HijiriMonths VALUES('محرم')
	INSERT INTO @HijiriMonths VALUES('صفر')
	INSERT INTO @HijiriMonths VALUES('ربيع الأول')
	INSERT INTO @HijiriMonths VALUES('ربيع الثاني')
	INSERT INTO @HijiriMonths VALUES('جمادي الأول')
	INSERT INTO @HijiriMonths VALUES('جمادي الثاني')
	INSERT INTO @HijiriMonths VALUES('رجب')
	INSERT INTO @HijiriMonths VALUES('شعبان')
	INSERT INTO @HijiriMonths VALUES('رمضان')
	INSERT INTO @HijiriMonths VALUES('شوال')
	INSERT INTO @HijiriMonths VALUES('ذو القعدة')
	INSERT INTO @HijiriMonths VALUES('ذو الحجة')

	RETURN (SELECT Name FROM @HijiriMonths WHERE Month_Id = @Month)
END

GO
/****** Object:  UserDefinedFunction [dbo].[SplitString]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[SplitString]
(    
      @Input NVARCHAR(MAX),
      @Character CHAR(1)
)
RETURNS @Output TABLE (
      [Index] bigint IDENTITY(1,1) PRIMARY KEY,
	  Item NVARCHAR(1000)
)
AS
BEGIN
      DECLARE @StartIndex INT, @EndIndex INT
 
      SET @StartIndex = 1
      IF SUBSTRING(@Input, LEN(@Input) - 1, LEN(@Input)) <> @Character
      BEGIN
            SET @Input = @Input + @Character
      END
 
      WHILE CHARINDEX(@Character, @Input) > 0
      BEGIN
            SET @EndIndex = CHARINDEX(@Character, @Input)
           
            INSERT INTO @Output(Item)
            SELECT SUBSTRING(@Input, @StartIndex, @EndIndex - 1)
           
            SET @Input = SUBSTRING(@Input, @EndIndex + 1, LEN(@Input))
      END
 
      RETURN
END

GO
/****** Object:  Table [dbo].[Announcement]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Announcement](
	[Announcement_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
	[Link] [nvarchar](max) NULL,
	[Number] [nvarchar](max) NULL,
	[Date] [date] NULL,
	[ViewCount] [bigint] NULL,
 CONSTRAINT [PK__Announce__43F88D50CE6B7CB6] PRIMARY KEY CLUSTERED 
(
	[Announcement_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EducationLevel]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EducationLevel](
	[EducationLevel_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[EducationLevel_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EService]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EService](
	[EService_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
	[Link] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[EService_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[HomeSlide]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HomeSlide](
	[HomeSlide_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ImageUrl] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[RedirectingLink] [nvarchar](max) NULL,
 CONSTRAINT [PK_HomeSlide] PRIMARY KEY CLUSTERED 
(
	[HomeSlide_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ImportantLink]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ImportantLink](
	[ImportantLink_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
	[Link] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ImportantLink_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[News]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[News](
	[News_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ImageUrl] [nvarchar](max) NULL,
	[Title] [nvarchar](max) NULL,
	[Contents] [nvarchar](max) NULL,
	[NewsDate] [date] NULL,
	[ViewCount] [bigint] NULL DEFAULT ((0)),
 CONSTRAINT [PK_News] PRIMARY KEY CLUSTERED 
(
	[News_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PeopleData]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PeopleData](
	[PeopleData_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[FullName] [nvarchar](max) NULL,
	[SSN] [nvarchar](max) NULL,
	[DOB] [date] NULL,
	[BirthPlace] [nvarchar](max) NULL,
	[ResidencePlace] [nvarchar](max) NULL,
	[EducationLevel_Id] [bigint] NULL,
	[JobTitle] [nvarchar](max) NULL,
	[WorkPlace] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[PeopleData_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PeopleDataAttachment]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PeopleDataAttachment](
	[PeopleDataAttachment_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Url] [nvarchar](max) NULL,
	[UploadedDate] [date] NULL,
	[UploadedTime] [time](0) NULL,
	[PeopleData_Id] [bigint] NULL,
 CONSTRAINT [PK__PeopleDa__2C5894A499FDAB7B] PRIMARY KEY CLUSTERED 
(
	[PeopleDataAttachment_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PeopleDataNote]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PeopleDataNote](
	[PeopeDataNote_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Content] [nvarchar](max) NULL,
	[PeopleData_Id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[PeopeDataNote_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PortalSettingsPage]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PortalSettingsPage](
	[PortalSettingsPage_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[PortalSettingsPage_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PortalSettingsUser]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PortalSettingsUser](
	[PortalSettingsUser_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](max) NULL,
	[LocalLoginPassword] [nvarchar](max) NULL,
	[Activated] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[PortalSettingsUser_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PortalSettingsUserPermission]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PortalSettingsUserPermission](
	[PortalSettingsUserPermission_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PortalSettingsUser_Id] [bigint] NULL,
	[PortalSettingsPage_Id] [bigint] NULL,
	[CanView] [bit] NULL,
	[CanAdd] [bit] NULL,
	[CanEdit] [bit] NULL,
	[CanDelete] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[PortalSettingsUserPermission_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProvisionsMonitoringPage]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProvisionsMonitoringPage](
	[ProvisionsMonitoringPage_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ProvisionsMonitoringPage_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProvisionsMonitoringPageRole]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProvisionsMonitoringPageRole](
	[ProvisionsMonitoringPageRole_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ProvisionsMonitoringPage_Id] [bigint] NULL,
	[ProvisionsMonitoringRole_Id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[ProvisionsMonitoringPageRole_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProvisionsMonitoringRole]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProvisionsMonitoringRole](
	[ProvisionsMonitoringRole_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ProvisionsMonitoringRole_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProvisionsMonitoringUser]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProvisionsMonitoringUser](
	[ProvisionsMonitoringUser_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](max) NULL,
	[LocalLoginPassword] [nvarchar](max) NULL,
	[Activated] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ProvisionsMonitoringUser_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProvisionsMonitoringUserLog]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProvisionsMonitoringUserLog](
	[ProvisionsMonitoringUserLog_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ProvisionsMonitoringUser_Id] [bigint] NULL,
	[ProvisionsMonitoringPageRole_Id] [bigint] NULL,
	[LogDate] [date] NULL,
	[LogTime] [time](0) NULL,
	[Note] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ProvisionsMonitoringUserLog_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProvisionsMonitoringUserRole]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProvisionsMonitoringUserRole](
	[ProvisionsMonitoringUserRole_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ProvisionsMonitoringUser_Id] [bigint] NULL,
	[ProvisionsMonitoringPageRole_Id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[ProvisionsMonitoringUserRole_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RuleData]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RuleData](
	[RuleData_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CaseNumber] [nvarchar](max) NULL,
	[IssuedLetterNumber] [nvarchar](max) NULL,
	[IssuedLetterDate] [date] NULL,
	[AccusedName] [nvarchar](max) NULL,
	[AccusedSSN] [nvarchar](max) NULL,
	[LegalDecisionNumber] [nvarchar](max) NULL,
	[LegalDecisionDate] [date] NULL,
	[SupportingDecisionNumber] [nvarchar](max) NULL,
	[SupportingDecisionDate] [date] NULL,
	[RuleStatus_Id] [bigint] NULL,
 CONSTRAINT [PK_RuleData] PRIMARY KEY CLUSTERED 
(
	[RuleData_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RuleDataAttachment]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RuleDataAttachment](
	[RuleDataAttachment_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Url] [nvarchar](max) NULL,
	[UploadedDate] [date] NULL,
	[UploadedTime] [time](0) NULL,
	[RuleData_Id] [bigint] NULL,
 CONSTRAINT [PK__RuleDa__2C5894A499FDAB7B] PRIMARY KEY CLUSTERED 
(
	[RuleDataAttachment_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RuleStatus]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RuleStatus](
	[RuleStatus_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
 CONSTRAINT [PK_RileStatus] PRIMARY KEY CLUSTERED 
(
	[RuleStatus_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SecurityAffairsPage]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SecurityAffairsPage](
	[SecurityAffairsPage_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[SecurityAffairsPage_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SecurityAffairsPageRole]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SecurityAffairsPageRole](
	[SecurityAffairsPageRole_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[SecurityAffairsPage_Id] [bigint] NULL,
	[SecurityAffairsRole_Id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[SecurityAffairsPageRole_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SecurityAffairsRole]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SecurityAffairsRole](
	[SecurityAffairsRole_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[SecurityAffairsRole_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SecurityAffairsUser]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SecurityAffairsUser](
	[SecurityAffairsUser_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](max) NULL,
	[LocalLoginPassword] [nvarchar](max) NULL,
	[Activated] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[SecurityAffairsUser_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SecurityAffairsUserLog]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SecurityAffairsUserLog](
	[SecurityAffairsUserLog_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[SecurityAffairsUser_Id] [bigint] NULL,
	[SecurityAffairsPageRole_Id] [bigint] NULL,
	[LogDate] [date] NULL,
	[LogTime] [time](0) NULL,
	[Note] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[SecurityAffairsUserLog_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SecurityAffairsUserRole]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SecurityAffairsUserRole](
	[SecurityAffairsUserRole_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[SecurityAffairsUser_Id] [bigint] NULL,
	[SecurityAffairsPageRole_Id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[SecurityAffairsUserRole_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[Announcement] ON 

GO
INSERT [dbo].[Announcement] ([Announcement_Id], [Title], [Link], [Number], [Date], [ViewCount]) VALUES (4, N'فترات إجازة عيد الفطر وعيد الأضحى', N'Files/Announcements/4.pdf', N'130813/د', CAST(N'2016-06-13' AS Date), 3)
GO
INSERT [dbo].[Announcement] ([Announcement_Id], [Title], [Link], [Number], [Date], [ViewCount]) VALUES (6, N'أهم إنجازات الأمارة لعام 1437 هـ', N'Files/Announcements/6.pdf', N'55123/أ', CAST(N'2016-10-16' AS Date), 3)
GO
SET IDENTITY_INSERT [dbo].[Announcement] OFF
GO
SET IDENTITY_INSERT [dbo].[EducationLevel] ON 

GO
INSERT [dbo].[EducationLevel] ([EducationLevel_Id], [Title]) VALUES (3, N'غير متعلم')
GO
INSERT [dbo].[EducationLevel] ([EducationLevel_Id], [Title]) VALUES (4, N'إبتدائي')
GO
INSERT [dbo].[EducationLevel] ([EducationLevel_Id], [Title]) VALUES (5, N'متوسط')
GO
INSERT [dbo].[EducationLevel] ([EducationLevel_Id], [Title]) VALUES (6, N'ثانوي')
GO
INSERT [dbo].[EducationLevel] ([EducationLevel_Id], [Title]) VALUES (7, N'بكالوريوس')
GO
INSERT [dbo].[EducationLevel] ([EducationLevel_Id], [Title]) VALUES (9, N'ماجستير')
GO
INSERT [dbo].[EducationLevel] ([EducationLevel_Id], [Title]) VALUES (12, N'دكتوراه')
GO
INSERT [dbo].[EducationLevel] ([EducationLevel_Id], [Title]) VALUES (13, N'دبلوم')
GO
SET IDENTITY_INSERT [dbo].[EducationLevel] OFF
GO
SET IDENTITY_INSERT [dbo].[EService] ON 

GO
INSERT [dbo].[EService] ([EService_Id], [Title], [Link]) VALUES (2580, N'قاعدة بيانات متابعة تنفيذ الأحكام', N'/LoginPage.aspx?Mode=ProvisionsMonitoring')
GO
INSERT [dbo].[EService] ([EService_Id], [Title], [Link]) VALUES (2581, N'قاعدة بيانات الشؤون الأمنية', N'/LoginPage.aspx?Mode=SecurityAffairs')
GO
SET IDENTITY_INSERT [dbo].[EService] OFF
GO
SET IDENTITY_INSERT [dbo].[HomeSlide] ON 

GO
INSERT [dbo].[HomeSlide] ([HomeSlide_Id], [ImageUrl], [Description], [RedirectingLink]) VALUES (15, N'Images/Slides/15.JPG', N'أمير الحدود الشمالية يرعى احتفاء تعليم المنطقة باليوم الوطني ', N'http://localhost:49158/NewsPage.aspx?ID=59')
GO
INSERT [dbo].[HomeSlide] ([HomeSlide_Id], [ImageUrl], [Description], [RedirectingLink]) VALUES (16, N'Images/Slides/16.jpg', N'أمير الشمالية يلتقي رئيس وأعضاء لجنة أصدقاء المرضى  ', N'http://localhost:49158/NewsPage.aspx?ID=60')
GO
INSERT [dbo].[HomeSlide] ([HomeSlide_Id], [ImageUrl], [Description], [RedirectingLink]) VALUES (20, N'Images/Slides/20.jpg', N'أمير الحدود الشمالية ينوه بالخدمات الجليلة التي وفرتها القيادة الرشيدة لضيوف الرحمن', NULL)
GO
SET IDENTITY_INSERT [dbo].[HomeSlide] OFF
GO
SET IDENTITY_INSERT [dbo].[ImportantLink] ON 

GO
INSERT [dbo].[ImportantLink] ([ImportantLink_Id], [Title], [Link]) VALUES (1, N'موقع وزارة الداخلية', N'https://www.moi.gov.sa/')
GO
INSERT [dbo].[ImportantLink] ([ImportantLink_Id], [Title], [Link]) VALUES (3, N'الإستعلام عن المعاملات', N'https://www.moi.gov.sa/wps/portal/Home/emirates/northernborders/contents/!ut/p/z1/pVNNb4JAEP0rXDySHVi-PK4YAaWtaKiyF7PAqjQFdEFt--sLRtP0oLRxbzt5782blxlE0RLRgh2zDauzsmDvzT-ixgo8TXMVTZ1Y2nQEJFDHNrE9FXRAizOgHzi26zYARyEGEM9UX8DTFcdTEf0L33aIq5k-gOU7OnjEDWf9AGMg-C7fVS98uPEIdPFfEUU0KepdvUVRUYp6y0UhxaVIuah6cK1cChITPdgfuPiUWFweaonLtWBFxZI2r6rV2iVZiiLNWsfKGifyOk0SWcPckuPUMGRd4Szl3DAg1s_o6tTCqfnj0bFmeuPxCZtzGGFnolxnvB0ivR_Bou3UkXKXBv0dpEOGAyAEB_2J7inga2jOBIruTmI3To4ZP6GwSTVvlmv-z7xc6OpgPNihQx4_KD_uuobm3LK3_Z6SZifLouYfNVo-vJS7PAzD3MK5vIRsut3kq-HgWY7Gxy-ffAMqT0y5/dz/d5/L2dBISEvZ0FBIS9nQSEh/')
GO
INSERT [dbo].[ImportantLink] ([ImportantLink_Id], [Title], [Link]) VALUES (4, N'موقع الإمارة التابع لوزارة الداخلية', N'https://www.moi.gov.sa/wps/portal/Home/emirates/northernborders/!ut/p/z1/04_iUlDg4tKPAFJABjKBwtGPykssy0xPLMnMz0vM0Y_Qj4wyizfwNDHxMDQx8rYwCXAzcAw08nJ2dPY0MvAw0vfSj8KvIDixSL8gO1ARAL0R5oU!/')
GO
SET IDENTITY_INSERT [dbo].[ImportantLink] OFF
GO
SET IDENTITY_INSERT [dbo].[News] ON 

GO
INSERT [dbo].[News] ([News_Id], [ImageUrl], [Title], [Contents], [NewsDate], [ViewCount]) VALUES (58, NULL, N'أمير الشمالية يرعى حفل الإدارة العامة للتعليم بمناسبة اليوم الوطني 86', N' رعى صاحب السمو الامير الدكتور مشعل بن عبدالله بن عبدالعزيز بن مساعد أمير منطقة الحدود الشمالية اليوم الحفل الذي نظمته الادارة العامة للتعليم بالمنطقة بمناسبة احتفال المملكة باليوم الوطني السادس والثمانين وذلك على مسرح الادارة.
وفور وصول سموه عزف السلام الملكي، ثم القى مدير عام التعليم بالمنطقة عبدالرحمن بن سعد القريشي شكر فيها بسمو امير منطقة الحدود الشمالية على رعايته حفل الادارة العامة للتعليم ورافعا من خلالها التهاني للقيادة الرشيدة بمناسبة اليوم الوطني السادس والثمانين مبرزا الاعمال البطولية التي قام بها الملك عبدالعزيز - طيب الله ثراه - ابان مرحلة التوحيد التي مرت بها البلاد حتى تمكن رحمه الله من تأسيس هذا الكيان العظيم في ظل دستورها المستمد من الكتاب والسنه مبيناً الإنجازات العظيمة التي تحققت لهذه البلاد وأهلها من خلال أبنائه البررة الذين ساروا على نهجه المبارك حتى وصلت القيادة لخادم الحرمين الشريفين الملك سلمان بن عبدالعزيز آل سعود -حفظه الله - الذي شهدت المملكة في عهده المبارك نقله عظيمه في مختلف المجالات داعياً الله أن يديم على بلادنا أمنها ورخاءها في ظل القيادة الحكيمة .
بعد ذلك شاهد سموه والحضور أوبريت وطني بهذه المناسبة من آداء طلاب المدارس نال على استحسان سموه ثم تشرف مدير عام التعليم بتقديم هديه تذكاريه لسموه ثم غادر سموه مقر الحفل مودعاً بالحفاوة والتكريم .
حضر الحفل معالي مدير جامعة الحدود الشمالية الدكتور سعيد بن عمر آل عمر وعدد من المسؤولين المدنيين والعسكريين .', CAST(N'2016-10-13' AS Date), 24)
GO
INSERT [dbo].[News] ([News_Id], [ImageUrl], [Title], [Contents], [NewsDate], [ViewCount]) VALUES (59, N'Images/NewsImages/59.JPG', N'أمير الحدود الشمالية يرعى احتفاء تعليم المنطقة باليوم الوطني', N'رعى صاحب السمو الأمير الدكتور مشعل بن عبدالله بن عبد العزيز بن مساعد أمير منطقة الحدود الشمالية اليوم، احتفاء تعليم المنطقة بذكرى اليوم الوطني الـ 86 للمملكة "رؤية وطن"، وذلك في قاعة الاحتفالات الكبرى بإدارة التعليم .
وكان في استقبال سموه مدير عام التعليم في المنطقة عبدالرحمن بن سعد القريشي, وعدد من المسؤولين العسكريين والمدنيين في المنطقة يتقدمهم معالي مدير جامعة الحدود الشمالية الدكتور سعيد آل عمر ووكيل الإمارة المساعد عبدالعزيز الزمام ومدير شرطة الحدود الشمالية اللواء ضيف الله العتيبي.
وبدأ الحفل المعد لهذه المناسبة بتلاوة آيات من القرآن الكريم, ثم ألقى مدير عام التعليم بالمنطقة، كلمة رفع من خلالها التهنئة إلى القيادة الرشيدة، وإلى الشعب السعودي الكريم بمناسبة اليوم الوطني الـ 86 للمملكة، مشيرا إلى البطولات العظيمة، التي قام بها الملك عبدالعزيز ـ رحمه الله ـ, إبان مرحلة التوحيد حتى أصبحت بلادنا ولله الحمد تنعم بالأمن والأمان منذ ذلك الوقت حتى يومنا هذا تحت قيادة خادم الحرمين الشريفين الملك سلمان بن عبدالعزيز آل سعود ـ حفظه الله ـ, الذي شهدت المملكة في عهده نقله شاملة من الإنجازات الكبيرة، داعيًا الله أن يديم على بلادنا نعمة الأمن والرخاء .
وأوضح القريشي أن هذا اليوم يتوافق مع مناسبة اليوم العالمي للمعلم, الذي يحتفي فيه العالم بالمعلم عرفاناً وتقديراً وتكريماً للدور الذي يقوم به, مؤكداً مكانة المعلم وضرورة حفظ مكانته ووضعه في المنزلة اللائقة به التي رفع من شأنها ديننا الحنيف وولاة الأمر ـ حفظهم الله ـ, الذين ما زالوا يكرمون ويجلون العلم والعلماء في جميع المجالات .
بعد ذلك توالت فقرات الحفل, حيث قدم الطلاب عدد من اللوحات والعروض الإنشادية.', CAST(N'2016-10-09' AS Date), 31)
GO
INSERT [dbo].[News] ([News_Id], [ImageUrl], [Title], [Contents], [NewsDate], [ViewCount]) VALUES (60, N'Images/NewsImages/60.jpg', N'أمير الشمالية يلتقي رئيس وأعضاء لجنة أصدقاء المرضى', N'التقى صاحب السمو الأمير الدكتور مشعل بن عبدالله بن عبدالعزيز بن مساعد أمير منطقة الحدود الشمالية، بمكتبه في الإمارة اليوم، رئيس وأعضاء لجنة أصدقاء المرضى بالمنطقة يتقدمهم رئيس اللجنة مدير عام الشئون الصحية بالمنطقة عبدالله بن ولمان العازمي ، الذين قدموا للسلام على سموه بمناسبة تشكيل الأعضاء الجدد .
ورحب سمو أمير المنطقة بهم ، متمنياً لهم التوفيق والنجاح ، مؤكداً ضرورة تكاتف الجميع حيال تفعيل اللجنة بما يكفل تقديم خدمة أفضل للمرضى .
من جانبه أعرب العازمي باسمه ونيابة عن أعضاء اللجنة عن شكرهم لسمو أمير منطقة الحدود الشمالية على دعمه مع اللجنة وتذليل ما يعترض مهامها الإنسانية .
وفي نهاية اللقاء قدم مدير عام الشئون الصحية تقريراً عن أعمال اللجنة ومشاريعها، ثم التقطت الصور التذكارية مع سموه .', CAST(N'2016-10-11' AS Date), 13)
GO
SET IDENTITY_INSERT [dbo].[News] OFF
GO
SET IDENTITY_INSERT [dbo].[PeopleDataAttachment] ON 

GO
INSERT [dbo].[PeopleDataAttachment] ([PeopleDataAttachment_Id], [Description], [Url], [UploadedDate], [UploadedTime], [PeopleData_Id]) VALUES (1, N'ملف 1', N'1.PNG', CAST(N'2016-10-20' AS Date), CAST(N'19:54:18' AS Time), NULL)
GO
INSERT [dbo].[PeopleDataAttachment] ([PeopleDataAttachment_Id], [Description], [Url], [UploadedDate], [UploadedTime], [PeopleData_Id]) VALUES (2, N'ملف 4', N'2.pdf', CAST(N'2016-10-20' AS Date), CAST(N'19:56:00' AS Time), NULL)
GO
INSERT [dbo].[PeopleDataAttachment] ([PeopleDataAttachment_Id], [Description], [Url], [UploadedDate], [UploadedTime], [PeopleData_Id]) VALUES (3, N'ملف أ', N'3.sql', CAST(N'2016-10-20' AS Date), CAST(N'19:57:33' AS Time), NULL)
GO
INSERT [dbo].[PeopleDataAttachment] ([PeopleDataAttachment_Id], [Description], [Url], [UploadedDate], [UploadedTime], [PeopleData_Id]) VALUES (7, N'ملف 1', N'7.PNG', CAST(N'2016-10-20' AS Date), CAST(N'20:36:59' AS Time), NULL)
GO
INSERT [dbo].[PeopleDataAttachment] ([PeopleDataAttachment_Id], [Description], [Url], [UploadedDate], [UploadedTime], [PeopleData_Id]) VALUES (8, N'ملف 2', N'8.sql', CAST(N'2016-10-20' AS Date), CAST(N'20:37:12' AS Time), NULL)
GO
INSERT [dbo].[PeopleDataAttachment] ([PeopleDataAttachment_Id], [Description], [Url], [UploadedDate], [UploadedTime], [PeopleData_Id]) VALUES (10, N'ملف 1', N'10.PNG', CAST(N'2016-10-24' AS Date), CAST(N'19:21:41' AS Time), NULL)
GO
INSERT [dbo].[PeopleDataAttachment] ([PeopleDataAttachment_Id], [Description], [Url], [UploadedDate], [UploadedTime], [PeopleData_Id]) VALUES (12, N'شهادة', N'12.pdf', CAST(N'2016-10-25' AS Date), CAST(N'16:50:22' AS Time), NULL)
GO
INSERT [dbo].[PeopleDataAttachment] ([PeopleDataAttachment_Id], [Description], [Url], [UploadedDate], [UploadedTime], [PeopleData_Id]) VALUES (13, N'تىتىتى', N'13.pdf', CAST(N'2016-10-25' AS Date), CAST(N'22:58:21' AS Time), NULL)
GO
SET IDENTITY_INSERT [dbo].[PeopleDataAttachment] OFF
GO
SET IDENTITY_INSERT [dbo].[PortalSettingsPage] ON 

GO
INSERT [dbo].[PortalSettingsPage] ([PortalSettingsPage_Id], [Title]) VALUES (1, N'شرائح العرض بالصفحة الرئيسية')
GO
INSERT [dbo].[PortalSettingsPage] ([PortalSettingsPage_Id], [Title]) VALUES (2, N'الأخبار')
GO
INSERT [dbo].[PortalSettingsPage] ([PortalSettingsPage_Id], [Title]) VALUES (3, N'التعاميم')
GO
INSERT [dbo].[PortalSettingsPage] ([PortalSettingsPage_Id], [Title]) VALUES (4, N'روابط هامة')
GO
INSERT [dbo].[PortalSettingsPage] ([PortalSettingsPage_Id], [Title]) VALUES (5, N'الخدمات الإلكترونية')
GO
INSERT [dbo].[PortalSettingsPage] ([PortalSettingsPage_Id], [Title]) VALUES (6, N'مسؤولين البوابة')
GO
SET IDENTITY_INSERT [dbo].[PortalSettingsPage] OFF
GO
SET IDENTITY_INSERT [dbo].[PortalSettingsUser] ON 

GO
INSERT [dbo].[PortalSettingsUser] ([PortalSettingsUser_Id], [Username], [LocalLoginPassword], [Activated]) VALUES (1, N'HMMAKKI', N'QQl2se1N+7ZqXxuUGcivww==', 1)
GO
INSERT [dbo].[PortalSettingsUser] ([PortalSettingsUser_Id], [Username], [LocalLoginPassword], [Activated]) VALUES (3, N'FSHAFAL', N'QQl2se1N+7ZqXxuUGcivww==', 1)
GO
INSERT [dbo].[PortalSettingsUser] ([PortalSettingsUser_Id], [Username], [LocalLoginPassword], [Activated]) VALUES (4, N'HMMAKKI2', NULL, 1)
GO
INSERT [dbo].[PortalSettingsUser] ([PortalSettingsUser_Id], [Username], [LocalLoginPassword], [Activated]) VALUES (5, N'FSHAFAL2', NULL, 0)
GO
INSERT [dbo].[PortalSettingsUser] ([PortalSettingsUser_Id], [Username], [LocalLoginPassword], [Activated]) VALUES (7, N'ADMIN', N'+MROCkdHZNNoTcM7sg4VzA==', 1)
GO
SET IDENTITY_INSERT [dbo].[PortalSettingsUser] OFF
GO
SET IDENTITY_INSERT [dbo].[PortalSettingsUserPermission] ON 

GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (1, 1, 1, 1, 1, 1, 1)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (2, 1, 2, 1, 1, 1, 1)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (3, 1, 3, 1, 1, 1, 1)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (4, 1, 4, 1, 1, 1, 1)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (5, 1, 5, 1, 1, 1, 1)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (6, 1, 6, 1, 1, 1, 1)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (7, 3, 1, 1, 1, 1, 1)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (8, 3, 2, 0, 0, 0, 0)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (9, 3, 3, 1, 0, 0, 1)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (10, 3, 4, 1, 1, 0, 0)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (11, 3, 5, 1, 1, 0, 1)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (12, 3, 6, 1, 0, 0, 1)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (13, 4, 1, 1, 1, 1, 1)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (14, 4, 2, 1, 1, 1, 1)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (15, 4, 3, 0, 0, 0, 0)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (16, 4, 4, 1, 1, 1, 1)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (17, 4, 5, 0, 0, 0, 0)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (18, 4, 6, 1, 1, 1, 1)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (19, 5, 1, 1, 1, 1, 1)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (20, 5, 2, 0, 0, 0, 0)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (21, 5, 3, 0, 0, 0, 0)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (22, 5, 4, 0, 0, 0, 0)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (23, 5, 5, 0, 0, 0, 0)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (24, 5, 6, 1, 1, 1, 1)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (25, 7, 1, 1, 1, 1, 1)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (26, 7, 2, 1, 1, 1, 1)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (27, 7, 3, 1, 1, 1, 1)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (28, 7, 4, 1, 1, 1, 1)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (29, 7, 5, 1, 1, 1, 1)
GO
INSERT [dbo].[PortalSettingsUserPermission] ([PortalSettingsUserPermission_Id], [PortalSettingsUser_Id], [PortalSettingsPage_Id], [CanView], [CanAdd], [CanEdit], [CanDelete]) VALUES (30, 7, 6, 1, 1, 1, 1)
GO
SET IDENTITY_INSERT [dbo].[PortalSettingsUserPermission] OFF
GO
SET IDENTITY_INSERT [dbo].[ProvisionsMonitoringPage] ON 

GO
INSERT [dbo].[ProvisionsMonitoringPage] ([ProvisionsMonitoringPage_Id], [Title]) VALUES (1, N'الأحكام')
GO
INSERT [dbo].[ProvisionsMonitoringPage] ([ProvisionsMonitoringPage_Id], [Title]) VALUES (2, N'مرفقات الأحكام')
GO
INSERT [dbo].[ProvisionsMonitoringPage] ([ProvisionsMonitoringPage_Id], [Title]) VALUES (3, N'تقرير متابعة الأحكام ')
GO
INSERT [dbo].[ProvisionsMonitoringPage] ([ProvisionsMonitoringPage_Id], [Title]) VALUES (4, N'تقرير سجلات (عمليات) المستخدمين')
GO
INSERT [dbo].[ProvisionsMonitoringPage] ([ProvisionsMonitoringPage_Id], [Title]) VALUES (5, N'إعدادات حالات تنفيذ الأحكام')
GO
INSERT [dbo].[ProvisionsMonitoringPage] ([ProvisionsMonitoringPage_Id], [Title]) VALUES (6, N'إعدادات مستخدمين النظام')
GO
SET IDENTITY_INSERT [dbo].[ProvisionsMonitoringPage] OFF
GO
SET IDENTITY_INSERT [dbo].[ProvisionsMonitoringPageRole] ON 

GO
INSERT [dbo].[ProvisionsMonitoringPageRole] ([ProvisionsMonitoringPageRole_Id], [ProvisionsMonitoringPage_Id], [ProvisionsMonitoringRole_Id]) VALUES (1, 1, 1)
GO
INSERT [dbo].[ProvisionsMonitoringPageRole] ([ProvisionsMonitoringPageRole_Id], [ProvisionsMonitoringPage_Id], [ProvisionsMonitoringRole_Id]) VALUES (2, 1, 2)
GO
INSERT [dbo].[ProvisionsMonitoringPageRole] ([ProvisionsMonitoringPageRole_Id], [ProvisionsMonitoringPage_Id], [ProvisionsMonitoringRole_Id]) VALUES (3, 1, 3)
GO
INSERT [dbo].[ProvisionsMonitoringPageRole] ([ProvisionsMonitoringPageRole_Id], [ProvisionsMonitoringPage_Id], [ProvisionsMonitoringRole_Id]) VALUES (4, 1, 4)
GO
INSERT [dbo].[ProvisionsMonitoringPageRole] ([ProvisionsMonitoringPageRole_Id], [ProvisionsMonitoringPage_Id], [ProvisionsMonitoringRole_Id]) VALUES (5, 2, 1)
GO
INSERT [dbo].[ProvisionsMonitoringPageRole] ([ProvisionsMonitoringPageRole_Id], [ProvisionsMonitoringPage_Id], [ProvisionsMonitoringRole_Id]) VALUES (6, 2, 2)
GO
INSERT [dbo].[ProvisionsMonitoringPageRole] ([ProvisionsMonitoringPageRole_Id], [ProvisionsMonitoringPage_Id], [ProvisionsMonitoringRole_Id]) VALUES (7, 2, 4)
GO
INSERT [dbo].[ProvisionsMonitoringPageRole] ([ProvisionsMonitoringPageRole_Id], [ProvisionsMonitoringPage_Id], [ProvisionsMonitoringRole_Id]) VALUES (8, 3, 1)
GO
INSERT [dbo].[ProvisionsMonitoringPageRole] ([ProvisionsMonitoringPageRole_Id], [ProvisionsMonitoringPage_Id], [ProvisionsMonitoringRole_Id]) VALUES (9, 4, 1)
GO
INSERT [dbo].[ProvisionsMonitoringPageRole] ([ProvisionsMonitoringPageRole_Id], [ProvisionsMonitoringPage_Id], [ProvisionsMonitoringRole_Id]) VALUES (10, 5, 1)
GO
INSERT [dbo].[ProvisionsMonitoringPageRole] ([ProvisionsMonitoringPageRole_Id], [ProvisionsMonitoringPage_Id], [ProvisionsMonitoringRole_Id]) VALUES (11, 5, 2)
GO
INSERT [dbo].[ProvisionsMonitoringPageRole] ([ProvisionsMonitoringPageRole_Id], [ProvisionsMonitoringPage_Id], [ProvisionsMonitoringRole_Id]) VALUES (12, 5, 3)
GO
INSERT [dbo].[ProvisionsMonitoringPageRole] ([ProvisionsMonitoringPageRole_Id], [ProvisionsMonitoringPage_Id], [ProvisionsMonitoringRole_Id]) VALUES (13, 5, 4)
GO
INSERT [dbo].[ProvisionsMonitoringPageRole] ([ProvisionsMonitoringPageRole_Id], [ProvisionsMonitoringPage_Id], [ProvisionsMonitoringRole_Id]) VALUES (14, 6, 1)
GO
INSERT [dbo].[ProvisionsMonitoringPageRole] ([ProvisionsMonitoringPageRole_Id], [ProvisionsMonitoringPage_Id], [ProvisionsMonitoringRole_Id]) VALUES (15, 6, 2)
GO
INSERT [dbo].[ProvisionsMonitoringPageRole] ([ProvisionsMonitoringPageRole_Id], [ProvisionsMonitoringPage_Id], [ProvisionsMonitoringRole_Id]) VALUES (16, 6, 3)
GO
INSERT [dbo].[ProvisionsMonitoringPageRole] ([ProvisionsMonitoringPageRole_Id], [ProvisionsMonitoringPage_Id], [ProvisionsMonitoringRole_Id]) VALUES (17, 6, 4)
GO
SET IDENTITY_INSERT [dbo].[ProvisionsMonitoringPageRole] OFF
GO
SET IDENTITY_INSERT [dbo].[ProvisionsMonitoringRole] ON 

GO
INSERT [dbo].[ProvisionsMonitoringRole] ([ProvisionsMonitoringRole_Id], [Title]) VALUES (1, N'عرض')
GO
INSERT [dbo].[ProvisionsMonitoringRole] ([ProvisionsMonitoringRole_Id], [Title]) VALUES (2, N'إضافة')
GO
INSERT [dbo].[ProvisionsMonitoringRole] ([ProvisionsMonitoringRole_Id], [Title]) VALUES (3, N'تعديل')
GO
INSERT [dbo].[ProvisionsMonitoringRole] ([ProvisionsMonitoringRole_Id], [Title]) VALUES (4, N'حذف')
GO
SET IDENTITY_INSERT [dbo].[ProvisionsMonitoringRole] OFF
GO
SET IDENTITY_INSERT [dbo].[ProvisionsMonitoringUser] ON 

GO
INSERT [dbo].[ProvisionsMonitoringUser] ([ProvisionsMonitoringUser_Id], [Username], [LocalLoginPassword], [Activated]) VALUES (1, N'hmmakki', N'QQl2se1N+7ZqXxuUGcivww==', 1)
GO
INSERT [dbo].[ProvisionsMonitoringUser] ([ProvisionsMonitoringUser_Id], [Username], [LocalLoginPassword], [Activated]) VALUES (3, N'ADMIN', N'+MROCkdHZNNoTcM7sg4VzA==', 1)
GO
SET IDENTITY_INSERT [dbo].[ProvisionsMonitoringUser] OFF
GO
SET IDENTITY_INSERT [dbo].[ProvisionsMonitoringUserRole] ON 

GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (1, 1, 1)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (2, 1, 2)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (3, 1, 3)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (4, 1, 4)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (5, 1, 5)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (6, 1, 6)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (7, 1, 7)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (8, 1, 8)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (9, 1, 9)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (10, 1, 10)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (11, 1, 11)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (12, 1, 12)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (13, 1, 13)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (14, 1, 14)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (15, 1, 15)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (16, 1, 16)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (17, 1, 17)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (35, 3, 1)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (36, 3, 2)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (37, 3, 3)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (38, 3, 4)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (39, 3, 5)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (40, 3, 6)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (41, 3, 7)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (42, 3, 8)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (43, 3, 9)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (44, 3, 10)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (45, 3, 11)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (46, 3, 12)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (47, 3, 13)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (48, 3, 14)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (49, 3, 15)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (50, 3, 16)
GO
INSERT [dbo].[ProvisionsMonitoringUserRole] ([ProvisionsMonitoringUserRole_Id], [ProvisionsMonitoringUser_Id], [ProvisionsMonitoringPageRole_Id]) VALUES (51, 3, 17)
GO
SET IDENTITY_INSERT [dbo].[ProvisionsMonitoringUserRole] OFF
GO
SET IDENTITY_INSERT [dbo].[RuleDataAttachment] ON 

GO
INSERT [dbo].[RuleDataAttachment] ([RuleDataAttachment_Id], [Description], [Url], [UploadedDate], [UploadedTime], [RuleData_Id]) VALUES (1, N'ملف أ', N'1.pdf', CAST(N'2016-10-25' AS Date), CAST(N'19:17:33' AS Time), NULL)
GO
INSERT [dbo].[RuleDataAttachment] ([RuleDataAttachment_Id], [Description], [Url], [UploadedDate], [UploadedTime], [RuleData_Id]) VALUES (2, N'ملف ب', N'2.jpg', CAST(N'2016-10-25' AS Date), CAST(N'19:18:07' AS Time), NULL)
GO
INSERT [dbo].[RuleDataAttachment] ([RuleDataAttachment_Id], [Description], [Url], [UploadedDate], [UploadedTime], [RuleData_Id]) VALUES (10002, N'ملف 1', N'10002.pdf', CAST(N'2016-10-27' AS Date), CAST(N'13:37:39' AS Time), NULL)
GO
SET IDENTITY_INSERT [dbo].[RuleDataAttachment] OFF
GO
SET IDENTITY_INSERT [dbo].[RuleStatus] ON 

GO
INSERT [dbo].[RuleStatus] ([RuleStatus_Id], [Title]) VALUES (1, N'لم يتم التنفيذ')
GO
INSERT [dbo].[RuleStatus] ([RuleStatus_Id], [Title]) VALUES (2, N'تم التنفيذ')
GO
SET IDENTITY_INSERT [dbo].[RuleStatus] OFF
GO
SET IDENTITY_INSERT [dbo].[SecurityAffairsPage] ON 

GO
INSERT [dbo].[SecurityAffairsPage] ([SecurityAffairsPage_Id], [Title]) VALUES (1, N'معلومات الأشخاص')
GO
INSERT [dbo].[SecurityAffairsPage] ([SecurityAffairsPage_Id], [Title]) VALUES (2, N'ملاحظات على الأشخاص')
GO
INSERT [dbo].[SecurityAffairsPage] ([SecurityAffairsPage_Id], [Title]) VALUES (3, N'مرفقات معلومات الأشخاص')
GO
INSERT [dbo].[SecurityAffairsPage] ([SecurityAffairsPage_Id], [Title]) VALUES (4, N'تقرير الأشخاص')
GO
INSERT [dbo].[SecurityAffairsPage] ([SecurityAffairsPage_Id], [Title]) VALUES (5, N'تقرير سجلات (عمليات) المستخدمين')
GO
INSERT [dbo].[SecurityAffairsPage] ([SecurityAffairsPage_Id], [Title]) VALUES (6, N'إعدادات المؤهلات الدراسية')
GO
INSERT [dbo].[SecurityAffairsPage] ([SecurityAffairsPage_Id], [Title]) VALUES (7, N'إعدادات مستخدمين النظام')
GO
SET IDENTITY_INSERT [dbo].[SecurityAffairsPage] OFF
GO
SET IDENTITY_INSERT [dbo].[SecurityAffairsPageRole] ON 

GO
INSERT [dbo].[SecurityAffairsPageRole] ([SecurityAffairsPageRole_Id], [SecurityAffairsPage_Id], [SecurityAffairsRole_Id]) VALUES (20, 1, 1)
GO
INSERT [dbo].[SecurityAffairsPageRole] ([SecurityAffairsPageRole_Id], [SecurityAffairsPage_Id], [SecurityAffairsRole_Id]) VALUES (21, 1, 2)
GO
INSERT [dbo].[SecurityAffairsPageRole] ([SecurityAffairsPageRole_Id], [SecurityAffairsPage_Id], [SecurityAffairsRole_Id]) VALUES (22, 1, 3)
GO
INSERT [dbo].[SecurityAffairsPageRole] ([SecurityAffairsPageRole_Id], [SecurityAffairsPage_Id], [SecurityAffairsRole_Id]) VALUES (23, 1, 4)
GO
INSERT [dbo].[SecurityAffairsPageRole] ([SecurityAffairsPageRole_Id], [SecurityAffairsPage_Id], [SecurityAffairsRole_Id]) VALUES (24, 2, 2)
GO
INSERT [dbo].[SecurityAffairsPageRole] ([SecurityAffairsPageRole_Id], [SecurityAffairsPage_Id], [SecurityAffairsRole_Id]) VALUES (25, 2, 4)
GO
INSERT [dbo].[SecurityAffairsPageRole] ([SecurityAffairsPageRole_Id], [SecurityAffairsPage_Id], [SecurityAffairsRole_Id]) VALUES (26, 3, 1)
GO
INSERT [dbo].[SecurityAffairsPageRole] ([SecurityAffairsPageRole_Id], [SecurityAffairsPage_Id], [SecurityAffairsRole_Id]) VALUES (27, 3, 2)
GO
INSERT [dbo].[SecurityAffairsPageRole] ([SecurityAffairsPageRole_Id], [SecurityAffairsPage_Id], [SecurityAffairsRole_Id]) VALUES (28, 3, 4)
GO
INSERT [dbo].[SecurityAffairsPageRole] ([SecurityAffairsPageRole_Id], [SecurityAffairsPage_Id], [SecurityAffairsRole_Id]) VALUES (29, 4, 1)
GO
INSERT [dbo].[SecurityAffairsPageRole] ([SecurityAffairsPageRole_Id], [SecurityAffairsPage_Id], [SecurityAffairsRole_Id]) VALUES (30, 5, 1)
GO
INSERT [dbo].[SecurityAffairsPageRole] ([SecurityAffairsPageRole_Id], [SecurityAffairsPage_Id], [SecurityAffairsRole_Id]) VALUES (31, 6, 1)
GO
INSERT [dbo].[SecurityAffairsPageRole] ([SecurityAffairsPageRole_Id], [SecurityAffairsPage_Id], [SecurityAffairsRole_Id]) VALUES (32, 6, 2)
GO
INSERT [dbo].[SecurityAffairsPageRole] ([SecurityAffairsPageRole_Id], [SecurityAffairsPage_Id], [SecurityAffairsRole_Id]) VALUES (33, 6, 3)
GO
INSERT [dbo].[SecurityAffairsPageRole] ([SecurityAffairsPageRole_Id], [SecurityAffairsPage_Id], [SecurityAffairsRole_Id]) VALUES (34, 6, 4)
GO
INSERT [dbo].[SecurityAffairsPageRole] ([SecurityAffairsPageRole_Id], [SecurityAffairsPage_Id], [SecurityAffairsRole_Id]) VALUES (35, 7, 1)
GO
INSERT [dbo].[SecurityAffairsPageRole] ([SecurityAffairsPageRole_Id], [SecurityAffairsPage_Id], [SecurityAffairsRole_Id]) VALUES (36, 7, 2)
GO
INSERT [dbo].[SecurityAffairsPageRole] ([SecurityAffairsPageRole_Id], [SecurityAffairsPage_Id], [SecurityAffairsRole_Id]) VALUES (37, 7, 3)
GO
INSERT [dbo].[SecurityAffairsPageRole] ([SecurityAffairsPageRole_Id], [SecurityAffairsPage_Id], [SecurityAffairsRole_Id]) VALUES (38, 7, 4)
GO
SET IDENTITY_INSERT [dbo].[SecurityAffairsPageRole] OFF
GO
SET IDENTITY_INSERT [dbo].[SecurityAffairsRole] ON 

GO
INSERT [dbo].[SecurityAffairsRole] ([SecurityAffairsRole_Id], [Title]) VALUES (1, N'عرض')
GO
INSERT [dbo].[SecurityAffairsRole] ([SecurityAffairsRole_Id], [Title]) VALUES (2, N'إضافة')
GO
INSERT [dbo].[SecurityAffairsRole] ([SecurityAffairsRole_Id], [Title]) VALUES (3, N'تعديل')
GO
INSERT [dbo].[SecurityAffairsRole] ([SecurityAffairsRole_Id], [Title]) VALUES (4, N'حذف')
GO
SET IDENTITY_INSERT [dbo].[SecurityAffairsRole] OFF
GO
SET IDENTITY_INSERT [dbo].[SecurityAffairsUser] ON 

GO
INSERT [dbo].[SecurityAffairsUser] ([SecurityAffairsUser_Id], [Username], [LocalLoginPassword], [Activated]) VALUES (1, N'hmmakki', N'QQl2se1N+7ZqXxuUGcivww==', 1)
GO
INSERT [dbo].[SecurityAffairsUser] ([SecurityAffairsUser_Id], [Username], [LocalLoginPassword], [Activated]) VALUES (3, N'ADMIN', N'+MROCkdHZNNoTcM7sg4VzA==', 1)
GO
SET IDENTITY_INSERT [dbo].[SecurityAffairsUser] OFF
GO
SET IDENTITY_INSERT [dbo].[SecurityAffairsUserRole] ON 

GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (1, 1, 20)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (2, 1, 21)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (3, 1, 22)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (4, 1, 23)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (5, 1, 24)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (6, 1, 25)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (7, 1, 26)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (8, 1, 27)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (9, 1, 28)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (10, 1, 29)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (11, 1, 30)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (12, 1, 31)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (13, 1, 32)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (14, 1, 33)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (15, 1, 34)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (16, 1, 35)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (17, 1, 36)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (18, 1, 37)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (19, 1, 38)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (20, 3, 20)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (21, 3, 21)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (22, 3, 22)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (23, 3, 23)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (24, 3, 24)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (25, 3, 25)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (26, 3, 26)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (27, 3, 27)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (28, 3, 28)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (29, 3, 29)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (30, 3, 30)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (31, 3, 31)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (32, 3, 32)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (33, 3, 33)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (34, 3, 34)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (35, 3, 35)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (36, 3, 36)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (37, 3, 37)
GO
INSERT [dbo].[SecurityAffairsUserRole] ([SecurityAffairsUserRole_Id], [SecurityAffairsUser_Id], [SecurityAffairsPageRole_Id]) VALUES (38, 3, 38)
GO
SET IDENTITY_INSERT [dbo].[SecurityAffairsUserRole] OFF
GO
ALTER TABLE [dbo].[PeopleData]  WITH CHECK ADD FOREIGN KEY([EducationLevel_Id])
REFERENCES [dbo].[EducationLevel] ([EducationLevel_Id])
GO
ALTER TABLE [dbo].[PeopleDataAttachment]  WITH CHECK ADD  CONSTRAINT [FK__PeopleDat__Peopl__59063A47] FOREIGN KEY([PeopleData_Id])
REFERENCES [dbo].[PeopleData] ([PeopleData_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PeopleDataAttachment] CHECK CONSTRAINT [FK__PeopleDat__Peopl__59063A47]
GO
ALTER TABLE [dbo].[PeopleDataNote]  WITH CHECK ADD FOREIGN KEY([PeopleData_Id])
REFERENCES [dbo].[PeopleData] ([PeopleData_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PortalSettingsUserPermission]  WITH CHECK ADD FOREIGN KEY([PortalSettingsUser_Id])
REFERENCES [dbo].[PortalSettingsUser] ([PortalSettingsUser_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PortalSettingsUserPermission]  WITH CHECK ADD FOREIGN KEY([PortalSettingsPage_Id])
REFERENCES [dbo].[PortalSettingsPage] ([PortalSettingsPage_Id])
GO
ALTER TABLE [dbo].[ProvisionsMonitoringPageRole]  WITH CHECK ADD FOREIGN KEY([ProvisionsMonitoringPage_Id])
REFERENCES [dbo].[ProvisionsMonitoringPage] ([ProvisionsMonitoringPage_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProvisionsMonitoringPageRole]  WITH CHECK ADD FOREIGN KEY([ProvisionsMonitoringRole_Id])
REFERENCES [dbo].[ProvisionsMonitoringRole] ([ProvisionsMonitoringRole_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProvisionsMonitoringUserLog]  WITH CHECK ADD FOREIGN KEY([ProvisionsMonitoringUser_Id])
REFERENCES [dbo].[ProvisionsMonitoringUser] ([ProvisionsMonitoringUser_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProvisionsMonitoringUserLog]  WITH CHECK ADD FOREIGN KEY([ProvisionsMonitoringPageRole_Id])
REFERENCES [dbo].[ProvisionsMonitoringPageRole] ([ProvisionsMonitoringPageRole_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProvisionsMonitoringUserRole]  WITH CHECK ADD FOREIGN KEY([ProvisionsMonitoringUser_Id])
REFERENCES [dbo].[ProvisionsMonitoringUser] ([ProvisionsMonitoringUser_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProvisionsMonitoringUserRole]  WITH CHECK ADD FOREIGN KEY([ProvisionsMonitoringPageRole_Id])
REFERENCES [dbo].[ProvisionsMonitoringPageRole] ([ProvisionsMonitoringPageRole_Id])
GO
ALTER TABLE [dbo].[RuleData]  WITH CHECK ADD  CONSTRAINT [FK_RuleData_RuleStatus] FOREIGN KEY([RuleStatus_Id])
REFERENCES [dbo].[RuleStatus] ([RuleStatus_Id])
GO
ALTER TABLE [dbo].[RuleData] CHECK CONSTRAINT [FK_RuleData_RuleStatus]
GO
ALTER TABLE [dbo].[RuleDataAttachment]  WITH CHECK ADD  CONSTRAINT [FK__RuleDat__Peopl__59063A47] FOREIGN KEY([RuleData_Id])
REFERENCES [dbo].[RuleData] ([RuleData_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RuleDataAttachment] CHECK CONSTRAINT [FK__RuleDat__Peopl__59063A47]
GO
ALTER TABLE [dbo].[SecurityAffairsPageRole]  WITH CHECK ADD FOREIGN KEY([SecurityAffairsPage_Id])
REFERENCES [dbo].[SecurityAffairsPage] ([SecurityAffairsPage_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SecurityAffairsPageRole]  WITH CHECK ADD FOREIGN KEY([SecurityAffairsRole_Id])
REFERENCES [dbo].[SecurityAffairsRole] ([SecurityAffairsRole_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SecurityAffairsUserLog]  WITH CHECK ADD FOREIGN KEY([SecurityAffairsUser_Id])
REFERENCES [dbo].[SecurityAffairsUser] ([SecurityAffairsUser_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SecurityAffairsUserLog]  WITH CHECK ADD FOREIGN KEY([SecurityAffairsPageRole_Id])
REFERENCES [dbo].[SecurityAffairsPageRole] ([SecurityAffairsPageRole_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SecurityAffairsUserRole]  WITH CHECK ADD FOREIGN KEY([SecurityAffairsUser_Id])
REFERENCES [dbo].[SecurityAffairsUser] ([SecurityAffairsUser_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SecurityAffairsUserRole]  WITH CHECK ADD FOREIGN KEY([SecurityAffairsPageRole_Id])
REFERENCES [dbo].[SecurityAffairsPageRole] ([SecurityAffairsPageRole_Id])
GO
/****** Object:  StoredProcedure [dbo].[sp_AddProvisionsMonitoringUserLog]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_AddProvisionsMonitoringUserLog](@ProvisionsMonitoringUser_Id bigint, @ProvisionsMonitoringPageRole_Id bigint, @Note nvarchar(MAX))
As
BEGIN
	IF (SELECT COUNT(*) FROM ProvisionsMonitoringUser WHERE ProvisionsMonitoringUser_Id = @ProvisionsMonitoringUser_Id AND LocalLoginPassword IS NULL) > 0
	BEGIN
		INSERT INTO ProvisionsMonitoringUserLog VALUES(@ProvisionsMonitoringUser_Id,@ProvisionsMonitoringPageRole_Id, GETDATE(), CURRENT_TIMESTAMP, @Note)
	END
END

GO
/****** Object:  StoredProcedure [dbo].[sp_AddSecurityAffairsUserLog]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_AddSecurityAffairsUserLog](@SecurityAffairsUser_Id bigint, @SecurityAffairsPageRole_Id bigint, @Note nvarchar(MAX))
As
BEGIN
	IF (SELECT COUNT(*) FROM SecurityAffairsUser WHERE SecurityAffairsUser_Id = @SecurityAffairsUser_Id AND LocalLoginPassword IS NULL) > 0
	BEGIN
		INSERT INTO SecurityAffairsUserLog VALUES(@SecurityAffairsUser_Id,@SecurityAffairsPageRole_Id, GETDATE(), CURRENT_TIMESTAMP, @Note)
	END
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAnnouncementById]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetAnnouncementById] (@Announcement_Id bigint)
As
BEGIN
	DECLARE @RESULT TABLE
	(
		Announcement_Id bigint,
		Title nvarchar(MAX),
		Number nvarchar(MAX),
		AnnounementDate nvarchar(MAX),
		ViewCount bigint,
		Link nvarchar(MAX)
	)

	INSERT INTO @RESULT
	SELECT	TOP 100 PERCENT 
			Announcement_Id,
			Title,
			Number,
			dbo.fn_GetHijiriLongDate(Date),
			ViewCount,
			Link
	FROM	Announcement
	WHERE	Announcement_Id = @Announcement_Id

	SELECT * FROM @RESULT
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAnnouncements]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetAnnouncements]
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		Announcement_Id bigint,
		Title nvarchar(MAX),
		Number nvarchar(MAX),
		AnnouncementDate nvarchar(MAX),
		AnnouncementDate_date date,
		ViewCount bigint,
		Link nvarchar(MAX),
		FileLink nvarchar(MAX)
	)

	INSERT INTO @RESULTS
	SELECT	TOP 100 PERCENT 
			Announcement_Id,
			Title,
			Number,
			dbo.fn_GetHijiriDate(Date),
			Date,
			ViewCount,
			'AnnouncementPage.aspx?ID=' + CAST(Announcement_Id as nvarchar(MAX)),
			Link
	FROM	Announcement

	SELECT TOP 100 PERCENT * FROM @RESULTS ORDER BY AnnouncementDate_Date DESC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetEducationLevels]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetEducationLevels](@Search nvarchar(MAX))
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		EducationLevel_Id bigint,
		EducationLevel_Id_string nvarchar(MAX),
		Title nvarchar(MAX)
	)

	INSERT INTO @RESULTS
	SELECT	el.EducationLevel_Id,
			REPLACE(STR(CAST(el.EducationLevel_Id as nvarchar(MAX)), 5), SPACE(1), '0'),
			el.Title
	FROM	EducationLevel el
	WHERE	(
				@Search = 'Empty%%^^&*(('
				OR
				(CAST(el.EducationLevel_Id as nvarchar(MAX)) LIKE @Search + '%')
				OR
				(el.Title LIKE '%' + @Search + '%')
			)

	SELECT * FROM @RESULTS
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetEducationLevelsForFilter]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetEducationLevelsForFilter]
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		EducationLevel_Id bigint,
		Title nvarchar(MAX)
	)
	INSERT INTO @RESULTS VALUES(0,N'--الكل--');
	
	INSERT INTO @RESULTS
	SELECT	TOP 100 PERCENT EducationLevel_Id,
			Title
	FROM	EducationLevel
	ORDER BY Title

	SELECT   *
	FROM	 @RESULTS
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetEducationLevelsForSelect]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetEducationLevelsForSelect]
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		EducationLevel_Id bigint,
		Title nvarchar(MAX)
	)
	INSERT INTO @RESULTS VALUES(0,N'--الرجاء الإختيار--');
	
	INSERT INTO @RESULTS
	SELECT	TOP 100 PERCENT EducationLevel_Id,
			Title
	FROM	EducationLevel
	ORDER BY Title

	SELECT   *
	FROM	 @RESULTS
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetEServices]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetEServices]
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		EService_Id bigint,
		Title nvarchar(MAX),
		Link nvarchar(MAX)
	)

	INSERT INTO @RESULTS
	SELECT  TOP 100 PERCENT  
			EService_Id,
			Title,
			Link
	FROM	EService
	ORDER BY Title

	SELECT TOP 100 PERCENT * FROM @RESULTS ORDER BY Title
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetGeorgianDate]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetGeorgianDate](@HijiriiDate_DD_MM_YYYY nvarchar(MAX))
As
BEGIN
	DECLARE @GeorgianDate date
	
	DECLARE @HijiriDate nvarchar(MAX) = (SELECT TOP 1 Item FROM dbo.SplitString(@HijiriiDate_DD_MM_YYYY,'/') WHERE [Index] = 3) +
	'/' + (SELECT TOP 1 Item FROM dbo.SplitString(@HijiriiDate_DD_MM_YYYY,'/') WHERE [Index] = 2) +
	'/' + (SELECT TOP 1 Item FROM dbo.SplitString(@HijiriiDate_DD_MM_YYYY,'/') WHERE [Index] = 1)

	SET		@GeorgianDate = (SELECT CONVERT(date, @HijiriDate, 131))

	SELECT	@GeorgianDate As 'Date'
END



GO
/****** Object:  StoredProcedure [dbo].[sp_GetHijiriDate]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetHijiriDate](@Date date)
As
BEGIN
	SELECT dbo.fn_GetHijiriDate(@Date) as Date
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetHomeSlides]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetHomeSlides]
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		RowNum bigint,
		HomeSlide_Id bigint,
		ImageUrl nvarchar(MAX),
		Description nvarchar(MAX),
		RedirectingLink nvarchar(MAX)
	)

	INSERT INTO @RESULTS
	SELECT ROW_NUMBER() OVER(ORDER BY HomeSlide_Id), * FROM HomeSlide

	SELECT * FROM @RESULTS
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetImportantLinks]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetImportantLinks]
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		ImportantLink_Id bigint,
		Title nvarchar(MAX),
		Link nvarchar(MAX)
	)

	INSERT INTO @RESULTS
	SELECT  TOP 100 PERCENT  
			ImportantLink_Id,
			CAST(ROW_NUMBER() OVER(ORDER BY Title) as nvarchar(MAX)) + N') ' + Title,
			Link
	FROM	ImportantLink
	ORDER BY Title

	SELECT TOP 100 PERCENT * FROM @RESULTS ORDER BY Title
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetImportantLinks2]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetImportantLinks2]
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		ImportantLink_Id bigint,
		Title nvarchar(MAX),
		Link nvarchar(MAX)
	)

	INSERT INTO @RESULTS
	SELECT  TOP 100 PERCENT  
			ImportantLink_Id,
			Title,
			Link
	FROM	ImportantLink
	ORDER BY Title

	SELECT TOP 100 PERCENT * FROM @RESULTS ORDER BY Title
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetNews]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetNews]
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		News_Id bigint,
		ImageUrl nvarchar(MAX),
		Title nvarchar(MAX),
		Contents nvarchar(MAX),
		NewsDate nvarchar(MAX),
		NewsDate_date date,
		ViewCount bigint,
		Link nvarchar(MAX)
	)

	DECLARE @DefaultImageUrl nvarchar(MAX) = 'Images\NewsImages\Default.jpg'

	INSERT INTO @RESULTS
	SELECT	TOP 100 PERCENT 
			News_Id,
			CASE
			WHEN ImageUrl IS NULL THEN @DefaultImageUrl
			ELSE ImageUrl
			END,
			Title,
			CASE
			WHEN LEN(Contents) > 220 THEN LEFT(Contents,220)
			ELSE Contents
			END,
			dbo.fn_GetHijiriDate(NewsDate),
			NewsDate,
			ViewCount,
			'NewsPage.aspx?ID=' + CAST(News_Id as nvarchar(MAX))
	FROM	News

	SELECT TOP 100 PERCENT * FROM @RESULTS ORDER BY NewsDate_date DESC
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetNewsById]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetNewsById] (@News_Id bigint)
As
BEGIN
	DECLARE @RESULT TABLE
	(
		News_Id bigint,
		ImageUrl nvarchar(MAX),
		Title nvarchar(MAX),
		Contents nvarchar(MAX),
		NewsDate nvarchar(MAX),
		ViewCount bigint
	)

	INSERT INTO @RESULT
	SELECT	TOP 100 PERCENT 
			News_Id,
			ImageUrl,
			Title,
			Contents,
			dbo.fn_GetHijiriLongDate(NewsDate),
			ViewCount
	FROM	News
	WHERE	News_Id = @News_Id

	SELECT * FROM @RESULT
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetPeopleData]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetPeopleData](@Search nvarchar(MAX))
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		PeopleData_Id bigint,
		PeopleData_Id_string nvarchar(MAX),
		FullName nvarchar(MAX),
		SSN nvarchar(MAX),
		DOB_string nvarchar(MAX),
		DOB date,
		BirthPlace nvarchar(MAX),
		ResidencePlace nvarchar(MAX),
		EducationLevelTitle nvarchar(MAX),
		Jobtitle nvarchar(MAX),
		WorkPlace nvarchar(MAX),
		HasNotes nvarchar(MAX)
	)

	INSERT INTO @RESULTS
	SELECT	p.PeopleData_Id,
			REPLACE(STR(CAST(p.PeopleData_Id as nvarchar(MAX)), 5), SPACE(1), '0'),
			p.FullName,
			p.SSN,
			dbo.fn_GetHijiriDate(p.DOB),
			DOB,
			p.BirthPlace,
			p.ResidencePlace,
			e.Title,
			p.JobTitle,
			p.WorkPlace,
			CASE
			WHEN (SELECT COUNT(*) FROM PeopleDataNote n WHERE n.PeopleData_Id = p.PeopleData_Id) > 0 THEN N'نعم'
			ELSE N'لا'
			END
	FROM	PeopleData p INNER JOIN
			EducationLevel e ON p.EducationLevel_Id = e.EducationLevel_Id
	WHERE	(
				@Search = 'Empty%%^^&*(('
				OR
				(CAST(p.PeopleData_Id as nvarchar(MAX)) LIKE @Search + '%')
				OR
				(p.FullName LIKE '%' + @Search + '%')
				OR
				(p.SSN LIKE @Search + '%')
				OR
				(p.BirthPlace LIKE '%' + @Search + '%')
				OR
				(p.ResidencePlace LIKE '%' + @Search + '%')
				OR
				(e.Title LIKE '%' + @Search + '%')
				OR
				(p.JobTitle LIKE '%' + @Search + '%')
				OR
				(p.WorkPlace LIKE '%' + @Search + '%')
			)

	SELECT * FROM @RESULTS
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetPeopleDataAttachments]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetPeopleDataAttachments]
(
	@PeopleData_Id bigint
)
As
BEGIN
	SELECT	PeopleDataAttachment_Id,
			dbo.fn_GetHijiriDate(UploadedDate) As 'UploadDate',
			dbo.fn_Get12HoursTimeFormat(UploadedTime) As 'UploadTime',
			Description,
			Url
	FROM	PeopleDataAttachment
	WHERE	PeopleData_Id = @PeopleData_Id
	ORDER BY UploadDate, UploadTime
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetPeopleDataReport]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetPeopleDataReport]
(
	@SearchName nvarchar(MAX),
	@SSN nvarchar(MAX),
	@DOBFrom date,
	@DOBTo date,
	@BirthPlace nvarchar(MAX),
	@ResidencePlace nvarchar(MAX),
	@EducationLevel_Id bigint,
	@JobTitle nvarchar(MAX),
	@WorkPlace nvarchar(MAX),
	@HasNotes bit,
	@HasNotNotes bit
)
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		PeopleDate_Id bigint,
		PeopleDate_Id_string nvarchar(MAX),
		FullName nvarchar(MAX),
		SSN nvarchar(MAX),
		DOB date,
		DOB_string nvarchar(MAX),
		BirthPlace nvarchar(MAX),
		ResidencePlace nvarchar(MAX),
		EducationLevelString nvarchar(MAX),
		JobTitle nvarchar(MAX),
		WorkPlace nvarchar(MAX),
		HasNotes nvarchar(MAX)
	)

	INSERT INTO @RESULTS
	SELECT	pd.PeopleData_Id,
			REPLACE(STR(CAST(pd.PeopleData_Id as nvarchar(MAX)), 5), SPACE(1), '0'),
			pd.FullName,
			pd.SSN,
			pd.DOB,
			dbo.fn_GetHijiriDate(pd.DOB),
			pd.BirthPlace,
			pd.ResidencePlace,
			el.Title,
			pd.JobTitle,
			pd.WorkPlace,
			CASE 
			WHEN (SELECT COUNT(*) FROM PeopleDataNote pdn WHERE pdn.PeopleData_Id = pd.PeopleData_Id) > 0 THEN N'نعم'
			ELSE N'لا'
			END
	FROM	PeopleData pd INNER JOIN
			EducationLevel el ON pd.EducationLevel_Id = el.EducationLevel_Id
	WHERE	(@SearchName = '' OR pd.FullName LIKE '%' + @SearchName + '%')
	AND		(@SSN = '' OR pd.SSN LIKE @SSN + '%')
	AND		(pd.DOB BETWEEN @DOBFrom AND @DOBTo)
	AND		(@BirthPlace = '' OR pd.BirthPlace LIKE '%' + @BirthPlace + '%')
	AND		(@ResidencePlace = '' OR pd.ResidencePlace LIKE '%' + @ResidencePlace + '%')
	AND		(@EducationLevel_Id = 0 OR pd.EducationLevel_Id = @EducationLevel_Id)
	AND		(@JobTitle = '' OR pd.JobTitle = '%' + @JobTitle + '%')
	AND		(@WorkPlace = '' OR pd.WorkPlace = '%' + @WorkPlace + '%')
	AND		(
				(((SELECT COUNT(*) FROM PeopleDataNote pdn WHERE pdn.PeopleData_Id = pd.PeopleData_Id) > 0) AND @HasNotes = 1)
				OR
				(((SELECT COUNT(*) FROM PeopleDataNote pdn WHERE pdn.PeopleData_Id = pd.PeopleData_Id) = 0) AND @HasNotNotes = 1)
			)

	SELECT * FROM @RESULTS
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetPortalAdminUsers]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetPortalAdminUsers](@CurrentUsername nvarchar(MAX))
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		PortalSettingsUser_Id bigint,
		Username nvarchar(MAX),
		Activated nvarchar(MAX)
	)

	INSERT INTO @RESULTS
	SELECT  TOP 100 PERCENT  
			PortalSettingsUser_Id,
			Username,
			CASE
			WHEN Activated = 1 THEN N'مفعل'
			ELSE N'معطل'
			END
	FROM	PortalSettingsUser
	WHERE	LocalLoginPassword IS NULL
	AND		LOWER(@CurrentUsername) <> LOWER(Username)
	ORDER BY Username

	SELECT TOP 100 PERCENT * FROM @RESULTS ORDER BY Username
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetPortalSettingsUserPermission]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetPortalSettingsUserPermission] (@PortalSettingsUser_Id bigint, @PortalSettingsPage_Id bigint, @PermissionType_Id bigint)
As
BEGIN

	-- @PermissionType_Id = 1:View , 2:Add , 3:Edit , 4:Delete

	DECLARE @IsAuthorized bit = 0

	IF
	(
	SELECT	COUNT(*)
	FROM	PortalSettingsUserPermission pr
	WHERE	pr.PortalSettingsUser_Id = @PortalSettingsUser_Id 
	AND		pr.PortalSettingsPage_Id = @PortalSettingsPage_Id
	AND		(
				(@PermissionType_Id = 1 AND pr.CanView = 1)
				OR
				(@PermissionType_Id = 2 AND pr.CanAdd = 1)
				OR
				(@PermissionType_Id = 3 AND pr.CanEdit = 1)
				OR
				(@PermissionType_Id = 4 AND pr.CanDelete = 1)
			)
	) > 0
	BEGIN
		SET @IsAuthorized = 1
	END

	SELECT @IsAuthorized as IsAuthorized
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetPortalSettingsUserPermissions]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetPortalSettingsUserPermissions] (@PortalSettingsUser_Id bigint)
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		PortalSettingsUser_Id bigint,
		PortalSettingsPage_Id bigint,
		PortalSettingsUserPermission_Id bigint,
		PortalSettingsPageTitle nvarchar(255),
		AllPermissions bit,
		CanView bit,
		CanAdd bit,
		CanEdit bit,
		CanDelete bit
	)

	INSERT INTO @RESULTS
	SELECT	@PortalSettingsUser_Id,
			p.PortalSettingsPage_Id,
			ISNULL(PortalSettingsUserPermission_Id,0),
			p.Title,
			CASE
			WHEN pr.CanView = 1 AND pr.CanAdd = 1 AND pr.CanEdit = 1 AND pr.CanDelete = 1 THEN 1
			ELSE 0
			END,
			ISNULL(pr.CanView,0),
			ISNULL(pr.CanAdd,0),
			ISNULL(pr.CanEdit,0),
			ISNULL(pr.CanDelete,0)
	FROM	PortalSettingsPage p LEFT OUTER JOIN
			PortalSettingsUserPermission pr ON p.PortalSettingsPage_Id = pr.PortalSettingsPage_Id AND pr.PortalSettingsUser_Id = @PortalSettingsUser_Id

	SELECT * FROM @RESULTS
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetProvisionsMonitoringPagesForFilter]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetProvisionsMonitoringPagesForFilter]
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		ProvisionsMonitoringPage_Id bigint,
		Title nvarchar(MAX)
	)
	INSERT INTO @RESULTS VALUES(0,N'--الكل--');
	
	INSERT INTO @RESULTS
	SELECT	TOP 100 PERCENT ProvisionsMonitoringPage_Id,
			Title
	FROM	ProvisionsMonitoringPage
	ORDER BY Title

	SELECT   *
	FROM	 @RESULTS
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetProvisionsMonitoringRolesForFilter]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetProvisionsMonitoringRolesForFilter]
(
	@Page_Id bigint
)
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		ProvisionsMonitoringRole_Id bigint,
		Title nvarchar(MAX)
	)
	INSERT INTO @RESULTS VALUES(0,N'--الكل--');
	
	IF(@Page_Id = 0)
	BEGIN
		INSERT INTO @RESULTS
		SELECT	TOP 100 PERCENT ProvisionsMonitoringRole_Id,
				Title
		FROM	ProvisionsMonitoringRole
		ORDER BY Title
	END
	ELSE
	BEGIN
		INSERT INTO @RESULTS
		SELECT	TOP 100 PERCENT r.ProvisionsMonitoringRole_Id,
				r.Title
		FROM	ProvisionsMonitoringPageRole pr INNER JOIN
				ProvisionsMonitoringRole r ON pr.ProvisionsMonitoringRole_Id = r.ProvisionsMonitoringRole_Id
		WHERE	pr.ProvisionsMonitoringPage_Id = @Page_Id
		ORDER BY Title
	END

	SELECT   *
	FROM	 @RESULTS
END


GO
/****** Object:  StoredProcedure [dbo].[sp_GetProvisionsMonitoringUserPermission]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetProvisionsMonitoringUserPermission] (@ProvisionsMonitoringUser_Id bigint, @ProvisionsMonitoringPageRole_Id bigint)
As
BEGIN
	DECLARE @IsAuthorized bit = 0

	IF
	(
	SELECT	COUNT(*)
	FROM	ProvisionsMonitoringUserRole ur
	WHERE	ur.ProvisionsMonitoringUser_Id = @ProvisionsMonitoringUser_Id
	AND		ur.ProvisionsMonitoringPageRole_Id = @ProvisionsMonitoringPageRole_Id
	) > 0
	BEGIN
		SET @IsAuthorized = 1
	END

	SELECT @IsAuthorized as IsAuthorized
END


GO
/****** Object:  StoredProcedure [dbo].[sp_GetProvisionsMonitoringUserPermissions]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetProvisionsMonitoringUserPermissions] (@ProvisionsMonitoringUser_Id bigint)
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		Serial bigint IDENTITY(1,1),
		ProvisionsMonitoringUser_Id bigint,
		ProvisionsMonitoringPage_Id bigint,
		ProvisionsMonitoringPageTitle nvarchar(255),
		AllPermissions bit,
		CanView bit,
		ViewEnabled bit,
		CanAdd bit,
		AddEnabled bit,
		CanEdit bit,
		EditEnabled bit,
		CanDelete bit,
		DeleteEnabled bit
	)

	INSERT INTO @RESULTS
	SELECT	@ProvisionsMonitoringUser_Id,
			p.ProvisionsMonitoringPage_Id,
			p.Title,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0
	FROM	ProvisionsMonitoringPage p
			
	DECLARE @CurrentIndex bigint = (SELECT MIN(Serial) FROM @RESULTS)
	DECLARE @EndIndex bigint = (SELECT MAX(Serial) FROM @RESULTS)

	WHILE @CurrentIndex <= @EndIndex
	BEGIN
		DECLARE @ProvisionsMonitoringPage_Id bigint = (SELECT TOP 1 ProvisionsMonitoringPage_Id FROM @RESULTS WHERE Serial = @CurrentIndex)
		
		UPDATE @RESULTS
		SET ViewEnabled = 
		CASE
			WHEN (SELECT COUNT(*) FROM ProvisionsMonitoringPageRole pr WHERE pr.ProvisionsMonitoringPage_Id = @ProvisionsMonitoringPage_Id AND pr.ProvisionsMonitoringRole_Id = 1) > 0 THEN 1
			ELSE 0
		END
		WHERE Serial = @CurrentIndex

		UPDATE @RESULTS
		SET AddEnabled = 
		CASE
			WHEN (SELECT COUNT(*) FROM ProvisionsMonitoringPageRole pr WHERE pr.ProvisionsMonitoringPage_Id = @ProvisionsMonitoringPage_Id AND pr.ProvisionsMonitoringRole_Id = 2) > 0 THEN 1
			ELSE 0
		END
		WHERE Serial = @CurrentIndex

		UPDATE @RESULTS
		SET EditEnabled = 
		CASE
			WHEN (SELECT COUNT(*) FROM ProvisionsMonitoringPageRole pr WHERE pr.ProvisionsMonitoringPage_Id = @ProvisionsMonitoringPage_Id AND pr.ProvisionsMonitoringRole_Id = 3) > 0 THEN 1
			ELSE 0
		END
		WHERE Serial = @CurrentIndex

		UPDATE @RESULTS
		SET DeleteEnabled = 
		CASE
			WHEN (SELECT COUNT(*) FROM ProvisionsMonitoringPageRole pr WHERE pr.ProvisionsMonitoringPage_Id = @ProvisionsMonitoringPage_Id AND pr.ProvisionsMonitoringRole_Id = 4) > 0 THEN 1
			ELSE 0
		END
		WHERE Serial = @CurrentIndex

		SET @CurrentIndex = @CurrentIndex + 1
	END
			
	SET @CurrentIndex = (SELECT MIN(Serial) FROM @RESULTS)
	SET @EndIndex = (SELECT MAX(Serial) FROM @RESULTS)

	WHILE @CurrentIndex <= @EndIndex
	BEGIN
		SET @ProvisionsMonitoringPage_Id = (SELECT TOP 1 ProvisionsMonitoringPage_Id FROM @RESULTS WHERE Serial = @CurrentIndex)
		DECLARE @ViewEnabled bit = (SELECT TOP 1 ViewEnabled FROM @RESULTS WHERE Serial = @CurrentIndex)
		DECLARE @AddEnabled bit = (SELECT TOP 1 AddEnabled FROM @RESULTS WHERE Serial = @CurrentIndex)
		DECLARE @EditEnabled bit = (SELECT TOP 1 EditEnabled FROM @RESULTS WHERE Serial = @CurrentIndex)
		DECLARE @DeleteEnabled bit = (SELECT TOP 1 DeleteEnabled FROM @RESULTS WHERE Serial = @CurrentIndex)
		DECLARE @ProvisionsMonitoringPageRole_Id bigint

		IF (@ViewEnabled = 1)
		BEGIN
			SET @ProvisionsMonitoringPageRole_Id = (SELECT TOP 1 ProvisionsMonitoringPageRole_Id FROM ProvisionsMonitoringPageRole pr WHERE pr.ProvisionsMonitoringPage_Id = @ProvisionsMonitoringPage_Id AND pr.ProvisionsMonitoringRole_Id = 1)

			UPDATE @RESULTS
			SET CanView = 
			CASE
				WHEN (SELECT COUNT(*) FROM ProvisionsMonitoringUserRole ur WHERE ur.ProvisionsMonitoringPageRole_Id = @ProvisionsMonitoringPageRole_Id AND ur.ProvisionsMonitoringUser_Id = @ProvisionsMonitoringUser_Id) > 0 THEN 1
				ELSE 0
			END
			WHERE Serial = @CurrentIndex
		END

		IF (@AddEnabled = 1)
		BEGIN
			SET @ProvisionsMonitoringPageRole_Id = (SELECT TOP 1 ProvisionsMonitoringPageRole_Id FROM ProvisionsMonitoringPageRole pr WHERE pr.ProvisionsMonitoringPage_Id = @ProvisionsMonitoringPage_Id AND pr.ProvisionsMonitoringRole_Id = 2)

			UPDATE @RESULTS
			SET CanAdd = 
			CASE
				WHEN (SELECT COUNT(*) FROM ProvisionsMonitoringUserRole ur WHERE ur.ProvisionsMonitoringPageRole_Id = @ProvisionsMonitoringPageRole_Id AND ur.ProvisionsMonitoringUser_Id = @ProvisionsMonitoringUser_Id) > 0 THEN 1
				ELSE 0
			END
			WHERE Serial = @CurrentIndex
		END

		IF (@EditEnabled = 1)
		BEGIN
			SET @ProvisionsMonitoringPageRole_Id = (SELECT TOP 1 ProvisionsMonitoringPageRole_Id FROM ProvisionsMonitoringPageRole pr WHERE pr.ProvisionsMonitoringPage_Id = @ProvisionsMonitoringPage_Id AND pr.ProvisionsMonitoringRole_Id = 3)

			UPDATE @RESULTS
			SET CanEdit = 
			CASE
				WHEN (SELECT COUNT(*) FROM ProvisionsMonitoringUserRole ur WHERE ur.ProvisionsMonitoringPageRole_Id = @ProvisionsMonitoringPageRole_Id AND ur.ProvisionsMonitoringUser_Id = @ProvisionsMonitoringUser_Id) > 0 THEN 1
				ELSE 0
			END
			WHERE Serial = @CurrentIndex
		END

		IF (@DeleteEnabled = 1)
		BEGIN
			SET @ProvisionsMonitoringPageRole_Id = (SELECT TOP 1 ProvisionsMonitoringPageRole_Id FROM ProvisionsMonitoringPageRole pr WHERE pr.ProvisionsMonitoringPage_Id = @ProvisionsMonitoringPage_Id AND pr.ProvisionsMonitoringRole_Id = 4)

			UPDATE @RESULTS
			SET CanDelete = 
			CASE
				WHEN (SELECT COUNT(*) FROM ProvisionsMonitoringUserRole ur WHERE ur.ProvisionsMonitoringPageRole_Id = @ProvisionsMonitoringPageRole_Id AND ur.ProvisionsMonitoringUser_Id = @ProvisionsMonitoringUser_Id) > 0 THEN 1
				ELSE 0
			END
			WHERE Serial = @CurrentIndex
		END

		UPDATE @RESULTS SET AllPermissions = 
		CASE
			WHEN (ViewEnabled = CanView) AND (AddEnabled = CanAdd) AND (EditEnabled = CanEdit) AND (DeleteEnabled = CanDelete) THEN 1
			ELSE 0
		END

		SET @CurrentIndex = @CurrentIndex + 1
	END

	SELECT * FROM @RESULTS
END


GO
/****** Object:  StoredProcedure [dbo].[sp_GetProvisionsMonitoringUsers]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetProvisionsMonitoringUsers](@CurrentUsername nvarchar(MAX))
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		ProvisionsMonitoringUser_Id bigint,
		Username nvarchar(MAX),
		Activated nvarchar(MAX)
	)

	INSERT INTO @RESULTS
	SELECT  TOP 100 PERCENT  
			ProvisionsMonitoringUser_Id,
			Username,
			CASE
			WHEN Activated = 1 THEN N'مفعل'
			ELSE N'معطل'
			END
	FROM	ProvisionsMonitoringUser
	WHERE	LocalLoginPassword IS NULL
	AND		LOWER(@CurrentUsername) <> LOWER(Username)
	ORDER BY Username

	SELECT TOP 100 PERCENT * FROM @RESULTS ORDER BY Username
END


GO
/****** Object:  StoredProcedure [dbo].[sp_GetProvisionsMonitoringUsersForFilter]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetProvisionsMonitoringUsersForFilter]
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		ProvisionsMonitoringUser_Id bigint,
		Title nvarchar(MAX)
	)
	INSERT INTO @RESULTS VALUES(0,N'--الكل--');
	
	INSERT INTO @RESULTS
	SELECT	TOP 100 PERCENT ProvisionsMonitoringUser_Id,
			Username
	FROM	ProvisionsMonitoringUser
	WHERE	LocalLoginPassword IS NULL
	ORDER BY Username

	SELECT   *
	FROM	 @RESULTS
END


GO
/****** Object:  StoredProcedure [dbo].[sp_GetProvisionsMonitoringUsersLogsReport]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetProvisionsMonitoringUsersLogsReport]
(
	@User_Id bigint,
	@Page_Id bigint,
	@Role_Id bigint,
	@FromDate date,
	@ToDate date
)
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		UserLog_Id bigint,
		Date_string nvarchar(MAX),
		Time_string nvarchar(MAX),
		Username nvarchar(MAX),
		PageTitle nvarchar(MAX),
		RoleTitle nvarchar(MAX),
		Note nvarchar(MAX)
	)

	INSERT INTO @RESULTS
	SELECT	ul.ProvisionsMonitoringUserLog_Id,
			dbo.fn_GetHijiriDate(ul.LogDate),
			dbo.fn_Get12HoursTimeFormat(ul.LogTime),
			u.Username,
			p.Title,
			r.Title,
			ul.Note
	FROM	ProvisionsMonitoringUserLog ul INNER JOIN
			ProvisionsMonitoringUser u ON ul.ProvisionsMonitoringUser_Id = u.ProvisionsMonitoringUser_Id INNER JOIN
			ProvisionsMonitoringPageRole pr ON ul.ProvisionsMonitoringPageRole_Id = pr.ProvisionsMonitoringPageRole_Id INNER JOIN
			ProvisionsMonitoringPage p ON pr.ProvisionsMonitoringPage_Id = p.ProvisionsMonitoringPage_Id INNER JOIN
			ProvisionsMonitoringRole r ON pr.ProvisionsMonitoringRole_Id = r.ProvisionsMonitoringRole_Id
	WHERE	(@User_Id = 0 OR ul.ProvisionsMonitoringUser_Id = @User_Id)
	AND		(@Page_Id = 0 OR p.ProvisionsMonitoringPage_Id = @Page_Id)
	AND		(@Role_Id = 0 OR r.ProvisionsMonitoringRole_Id = @Role_Id)
	AND		(ul.LogDate BETWEEN @FromDate AND @ToDate)

	SELECT * FROM @RESULTS
END


GO
/****** Object:  StoredProcedure [dbo].[sp_GetRuleData]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetRuleData](@Search nvarchar(MAX))
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		RuleData_Id bigint,
		RuleData_Id_string nvarchar(MAX),
		CaseNumber nvarchar(MAX),
		IssuedLetterNumber nvarchar(MAX),
		IssuedLetterDate_string nvarchar(MAX),
		IssuedLetterDate date,
		AccusedName nvarchar(MAX),
		AccusedSSN nvarchar(MAX),
		LegalDecisionNumber nvarchar(MAX),
		LegalDecisionDate_string nvarchar(MAX),
		LegalDecisionDate date,
		SupportingDecisionNumber nvarchar(MAX),
		SupportingDecisionDate_string nvarchar(MAX),
		SupportingDecisionDate date,
		RuleStatus_Id bigint,
		RuleStatusTitle nvarchar(MAX)
	)

	INSERT INTO @RESULTS
	SELECT	rd.RuleData_Id,
			REPLACE(STR(CAST(rd.RuleData_Id as nvarchar(MAX)), 5), SPACE(1), '0'),
			rd.CaseNumber,
			rd.IssuedLetterNumber,
			dbo.fn_GetHijiriDate(rd.IssuedLetterDate),
			rd.IssuedLetterDate,
			rd.AccusedName,
			rd.AccusedSSN,
			rd.LegalDecisionNumber,
			dbo.fn_GetHijiriDate(rd.LegalDecisionDate),
			rd.LegalDecisionDate,
			rd.SupportingDecisionNumber,
			dbo.fn_GetHijiriDate(rd.SupportingDecisionDate),
			rd.SupportingDecisionDate,
			s.RuleStatus_Id,
			s.Title
	FROM	RuleData rd INNER JOIN
			RuleStatus s ON s.RuleStatus_Id = rd.RuleStatus_Id
	WHERE	(
				@Search = 'Empty%%^^&*(('
				OR
				(CAST(rd.RuleData_Id as nvarchar(MAX)) LIKE @Search + '%')
				OR
				(rd.CaseNumber LIKE @Search + '%')
				OR
				(rd.IssuedLetterNumber LIKE @Search + '%')
				OR
				(rd.AccusedName LIKE '%' + @Search + '%')
				OR
				(rd.LegalDecisionNumber LIKE @Search + '%')
				OR
				(rd.SupportingDecisionNumber LIKE @Search + '%')
				OR
				(s.Title LIKE @Search + '%')
			)

	SELECT * FROM @RESULTS
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetRuleDataAttachments]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetRuleDataAttachments]
(
	@RuleData_Id bigint
)
As
BEGIN
	SELECT	RuleDataAttachment_Id,
			dbo.fn_GetHijiriDate(UploadedDate) As 'UploadDate',
			dbo.fn_Get12HoursTimeFormat(UploadedTime) As 'UploadTime',
			Description,
			Url
	FROM	RuleDataAttachment
	WHERE	RuleData_Id = @RuleData_Id
	ORDER BY UploadDate, UploadTime
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetRuleDataReport]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetRuleDataReport]
(
	@CaseNumber nvarchar(MAX),
	@IssuedLetterNumber nvarchar(MAX),
	@IssuedLetterDateFrom date,
	@IssuedLetterDateTo date,
	@AccusedName nvarchar(MAX),
	@AccusedSSN nvarchar(MAX),
	@LegalDecisionNumber nvarchar(MAX),
	@LegalDecisionDateFrom date,
	@LegalDecisionDateTo date,
	@SupportingDecisionNumber nvarchar(MAX),
	@SupportingDecisionDateFrom date,
	@SupportingDecisionDateTo date,
	@RuleStatus_Id bigint
)
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		RuleDate_Id bigint,
		RuleDate_Id_string nvarchar(MAX),
		CaseNumber nvarchar(MAX),
		IssuedLetterNumber nvarchar(MAX),
		IssuedLetterDate date,
		IssuedLetterDate_string nvarchar(MAX),
		AccusedName nvarchar(MAX),
		AccusedSSN nvarchar(MAX),
		LegalDecisionNumber nvarchar(MAX),
		LegalDecisionDate date,
		LegalDecisionDate_string nvarchar(MAX),
		SupportingDecisionNumber nvarchar(MAX),
		SupportingDecisionDate date,
		SupportingDecisionDate_string nvarchar(MAX),
		RuleStatusTitle nvarchar(MAX)
	)

	INSERT INTO @RESULTS
	SELECT	pd.RuleData_Id,
			REPLACE(STR(CAST(pd.RuleData_Id as nvarchar(MAX)), 5), SPACE(1), '0'),
			pd.CaseNumber,
			pd.IssuedLetterNumber,
			pd.IssuedLetterDate,
			dbo.fn_GetHijiriDate(pd.IssuedLetterDate),
			pd.AccusedName,
			pd.AccusedSSN,
			pd.LegalDecisionNumber,
			pd.LegalDecisionDate,
			dbo.fn_GetHijiriDate(pd.LegalDecisionDate),
			pd.SupportingDecisionNumber,
			pd.SupportingDecisionDate,
			dbo.fn_GetHijiriDate(pd.SupportingDecisionDate),
			el.Title
	FROM	RuleData pd INNER JOIN
			RuleStatus el ON pd.RuleStatus_Id = el.RuleStatus_Id
	AND		(@CaseNumber = '' OR pd.CaseNumber LIKE @CaseNumber + '%')
	AND		(@IssuedLetterNumber = '' OR pd.IssuedLetterNumber LIKE @IssuedLetterNumber + '%')
	AND		(
				(@IssuedLetterDateFrom IS NULL AND @IssuedLetterDateTo IS NULL)
				OR
				(@IssuedLetterDateFrom IS NULL AND @IssuedLetterDateTo IS NOT NULL AND pd.IssuedLetterDate BETWEEN GETDATE()-21000 AND @IssuedLetterDateTo)
				OR
				(@IssuedLetterDateFrom IS NOT NULL AND @IssuedLetterDateTo IS NULL AND pd.IssuedLetterDate BETWEEN @IssuedLetterDateFrom AND GETDATE()+21000)
				OR
				(@IssuedLetterDateFrom IS NOT NULL AND @IssuedLetterDateFrom IS NOT NULL AND pd.IssuedLetterDate BETWEEN @IssuedLetterDateFrom AND @IssuedLetterDateTo)
			)
	AND		(@AccusedName = '' OR pd.AccusedName LIKE '%' + @AccusedName + '%')
	AND		(@AccusedSSN = '' OR pd.AccusedSSN LIKE @AccusedSSN + '%')
	AND		(@LegalDecisionNumber = '' OR pd.LegalDecisionNumber LIKE @LegalDecisionNumber + '%')
	AND		(
				(@LegalDecisionDateFrom IS NULL AND @LegalDecisionDateTo IS NULL)
				OR
				(@LegalDecisionDateFrom IS NULL AND @LegalDecisionDateTo IS NOT NULL AND pd.LegalDecisionDate BETWEEN GETDATE()-21000 AND @LegalDecisionDateTo)
				OR
				(@LegalDecisionDateFrom IS NOT NULL AND @LegalDecisionDateTo IS NULL AND pd.LegalDecisionDate BETWEEN @LegalDecisionDateFrom AND GETDATE()+21000)
				OR
				(@LegalDecisionDateFrom IS NOT NULL AND @LegalDecisionDateTo IS NOT NULL AND pd.LegalDecisionDate BETWEEN @LegalDecisionDateFrom AND @LegalDecisionDateTo)
			)
	AND		(@SupportingDecisionNumber = '' OR pd.SupportingDecisionNumber LIKE @SupportingDecisionNumber + '%')
	AND		(@LegalDecisionNumber = '' OR pd.LegalDecisionNumber LIKE @LegalDecisionNumber + '%')
	AND		(
				(@SupportingDecisionDateFrom IS NULL AND @LegalDecisionDateTo IS NULL)
				OR
				(@SupportingDecisionDateFrom IS NULL AND @LegalDecisionDateTo IS NOT NULL AND pd.SupportingDecisionDate BETWEEN GETDATE()-21000 AND @SupportingDecisionDateTo)
				OR
				(@SupportingDecisionDateFrom IS NOT NULL AND @LegalDecisionDateTo IS NULL AND pd.SupportingDecisionDate BETWEEN @SupportingDecisionDateFrom AND GETDATE()+21000)
				OR
				(@SupportingDecisionDateFrom IS NOT NULL AND @LegalDecisionDateTo IS NOT NULL AND pd.SupportingDecisionDate BETWEEN @SupportingDecisionDateFrom AND @SupportingDecisionDateTo)
			)
	AND		(@RuleStatus_Id = 0 OR pd.RuleStatus_Id = @RuleStatus_Id)

	SELECT * FROM @RESULTS
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetRuleStatuses]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetRuleStatuses](@Search nvarchar(MAX))
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		RuleStatus_Id bigint,
		RuleStatus_Id_string nvarchar(MAX),
		Title nvarchar(MAX)
	)

	INSERT INTO @RESULTS
	SELECT	el.RuleStatus_Id,
			REPLACE(STR(CAST(el.RuleStatus_Id as nvarchar(MAX)), 5), SPACE(1), '0'),
			el.Title
	FROM	RuleStatus el
	WHERE	(
				@Search = 'Empty%%^^&*(('
				OR
				(CAST(el.RuleStatus_Id as nvarchar(MAX)) LIKE @Search + '%')
				OR
				(el.Title LIKE '%' + @Search + '%')
			)

	SELECT * FROM @RESULTS
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetRuleStatusesForFilter]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetRuleStatusesForFilter]
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		RuleStatus_Id bigint,
		Title nvarchar(MAX)
	)
	INSERT INTO @RESULTS VALUES(0,N'--الكل--');
	
	INSERT INTO @RESULTS
	SELECT	TOP 100 PERCENT RuleStatus_Id,
			Title
	FROM	RuleStatus
	ORDER BY Title

	SELECT   *
	FROM	 @RESULTS
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetRuleStatusForSelect]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetRuleStatusForSelect]
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		RuleStatus_Id bigint,
		Title nvarchar(MAX)
	)
	INSERT INTO @RESULTS VALUES(0,N'--الرجاء الإختيار--');
	
	INSERT INTO @RESULTS
	SELECT	TOP 100 PERCENT RuleStatus_Id,
			Title
	FROM	RuleStatus
	ORDER BY Title

	SELECT   *
	FROM	 @RESULTS
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetSecurityAffairsPagesForFilter]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetSecurityAffairsPagesForFilter]
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		SecurityAffairsPage_Id bigint,
		Title nvarchar(MAX)
	)
	INSERT INTO @RESULTS VALUES(0,N'--الكل--');
	
	INSERT INTO @RESULTS
	SELECT	TOP 100 PERCENT SecurityAffairsPage_Id,
			Title
	FROM	SecurityAffairsPage
	ORDER BY Title

	SELECT   *
	FROM	 @RESULTS
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetSecurityAffairsRolesForFilter]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetSecurityAffairsRolesForFilter]
(
	@Page_Id bigint
)
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		SecurityAffairsRole_Id bigint,
		Title nvarchar(MAX)
	)
	INSERT INTO @RESULTS VALUES(0,N'--الكل--');
	
	IF(@Page_Id = 0)
	BEGIN
		INSERT INTO @RESULTS
		SELECT	TOP 100 PERCENT SecurityAffairsRole_Id,
				Title
		FROM	SecurityAffairsRole
		ORDER BY Title
	END
	ELSE
	BEGIN
		INSERT INTO @RESULTS
		SELECT	TOP 100 PERCENT r.SecurityAffairsRole_Id,
				r.Title
		FROM	SecurityAffairsPageRole pr INNER JOIN
				SecurityAffairsRole r ON pr.SecurityAffairsRole_Id = r.SecurityAffairsRole_Id
		WHERE	pr.SecurityAffairsPage_Id = @Page_Id
		ORDER BY Title
	END

	SELECT   *
	FROM	 @RESULTS
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetSecurityAffairsUserPermission]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetSecurityAffairsUserPermission] (@SecurityAffairsUser_Id bigint, @SecurityAffairsPageRole_Id bigint)
As
BEGIN
	DECLARE @IsAuthorized bit = 0

	IF
	(
	SELECT	COUNT(*)
	FROM	SecurityAffairsUserRole ur
	WHERE	ur.SecurityAffairsUser_Id = @SecurityAffairsUser_Id
	AND		ur.SecurityAffairsPageRole_Id = @SecurityAffairsPageRole_Id
	) > 0
	BEGIN
		SET @IsAuthorized = 1
	END

	SELECT @IsAuthorized as IsAuthorized
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetSecurityAffairsUserPermissions]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetSecurityAffairsUserPermissions] (@SecurityAffairsUser_Id bigint)
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		Serial bigint IDENTITY(1,1),
		SecurityAffairsUser_Id bigint,
		SecurityAffairsPage_Id bigint,
		SecurityAffairsPageTitle nvarchar(255),
		AllPermissions bit,
		CanView bit,
		ViewEnabled bit,
		CanAdd bit,
		AddEnabled bit,
		CanEdit bit,
		EditEnabled bit,
		CanDelete bit,
		DeleteEnabled bit
	)

	INSERT INTO @RESULTS
	SELECT	@SecurityAffairsUser_Id,
			p.SecurityAffairsPage_Id,
			p.Title,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0
	FROM	SecurityAffairsPage p
			
	DECLARE @CurrentIndex bigint = (SELECT MIN(Serial) FROM @RESULTS)
	DECLARE @EndIndex bigint = (SELECT MAX(Serial) FROM @RESULTS)

	WHILE @CurrentIndex <= @EndIndex
	BEGIN
		DECLARE @SecurityAffairsPage_Id bigint = (SELECT TOP 1 SecurityAffairsPage_Id FROM @RESULTS WHERE Serial = @CurrentIndex)
		
		UPDATE @RESULTS
		SET ViewEnabled = 
		CASE
			WHEN (SELECT COUNT(*) FROM SecurityAffairsPageRole pr WHERE pr.SecurityAffairsPage_Id = @SecurityAffairsPage_Id AND pr.SecurityAffairsRole_Id = 1) > 0 THEN 1
			ELSE 0
		END
		WHERE Serial = @CurrentIndex

		UPDATE @RESULTS
		SET AddEnabled = 
		CASE
			WHEN (SELECT COUNT(*) FROM SecurityAffairsPageRole pr WHERE pr.SecurityAffairsPage_Id = @SecurityAffairsPage_Id AND pr.SecurityAffairsRole_Id = 2) > 0 THEN 1
			ELSE 0
		END
		WHERE Serial = @CurrentIndex

		UPDATE @RESULTS
		SET EditEnabled = 
		CASE
			WHEN (SELECT COUNT(*) FROM SecurityAffairsPageRole pr WHERE pr.SecurityAffairsPage_Id = @SecurityAffairsPage_Id AND pr.SecurityAffairsRole_Id = 3) > 0 THEN 1
			ELSE 0
		END
		WHERE Serial = @CurrentIndex

		UPDATE @RESULTS
		SET DeleteEnabled = 
		CASE
			WHEN (SELECT COUNT(*) FROM SecurityAffairsPageRole pr WHERE pr.SecurityAffairsPage_Id = @SecurityAffairsPage_Id AND pr.SecurityAffairsRole_Id = 4) > 0 THEN 1
			ELSE 0
		END
		WHERE Serial = @CurrentIndex

		SET @CurrentIndex = @CurrentIndex + 1
	END
			
	SET @CurrentIndex = (SELECT MIN(Serial) FROM @RESULTS)
	SET @EndIndex = (SELECT MAX(Serial) FROM @RESULTS)

	WHILE @CurrentIndex <= @EndIndex
	BEGIN
		SET @SecurityAffairsPage_Id = (SELECT TOP 1 SecurityAffairsPage_Id FROM @RESULTS WHERE Serial = @CurrentIndex)
		DECLARE @ViewEnabled bit = (SELECT TOP 1 ViewEnabled FROM @RESULTS WHERE Serial = @CurrentIndex)
		DECLARE @AddEnabled bit = (SELECT TOP 1 AddEnabled FROM @RESULTS WHERE Serial = @CurrentIndex)
		DECLARE @EditEnabled bit = (SELECT TOP 1 EditEnabled FROM @RESULTS WHERE Serial = @CurrentIndex)
		DECLARE @DeleteEnabled bit = (SELECT TOP 1 DeleteEnabled FROM @RESULTS WHERE Serial = @CurrentIndex)
		DECLARE @SecurityAffairsPageRole_Id bigint

		IF (@ViewEnabled = 1)
		BEGIN
			SET @SecurityAffairsPageRole_Id = (SELECT TOP 1 SecurityAffairsPageRole_Id FROM SecurityAffairsPageRole pr WHERE pr.SecurityAffairsPage_Id = @SecurityAffairsPage_Id AND pr.SecurityAffairsRole_Id = 1)

			UPDATE @RESULTS
			SET CanView = 
			CASE
				WHEN (SELECT COUNT(*) FROM SecurityAffairsUserRole ur WHERE ur.SecurityAffairsPageRole_Id = @SecurityAffairsPageRole_Id AND ur.SecurityAffairsUser_Id = @SecurityAffairsUser_Id) > 0 THEN 1
				ELSE 0
			END
			WHERE Serial = @CurrentIndex
		END

		IF (@AddEnabled = 1)
		BEGIN
			SET @SecurityAffairsPageRole_Id = (SELECT TOP 1 SecurityAffairsPageRole_Id FROM SecurityAffairsPageRole pr WHERE pr.SecurityAffairsPage_Id = @SecurityAffairsPage_Id AND pr.SecurityAffairsRole_Id = 2)

			UPDATE @RESULTS
			SET CanAdd = 
			CASE
				WHEN (SELECT COUNT(*) FROM SecurityAffairsUserRole ur WHERE ur.SecurityAffairsPageRole_Id = @SecurityAffairsPageRole_Id AND ur.SecurityAffairsUser_Id = @SecurityAffairsUser_Id) > 0 THEN 1
				ELSE 0
			END
			WHERE Serial = @CurrentIndex
		END

		IF (@EditEnabled = 1)
		BEGIN
			SET @SecurityAffairsPageRole_Id = (SELECT TOP 1 SecurityAffairsPageRole_Id FROM SecurityAffairsPageRole pr WHERE pr.SecurityAffairsPage_Id = @SecurityAffairsPage_Id AND pr.SecurityAffairsRole_Id = 3)

			UPDATE @RESULTS
			SET CanEdit = 
			CASE
				WHEN (SELECT COUNT(*) FROM SecurityAffairsUserRole ur WHERE ur.SecurityAffairsPageRole_Id = @SecurityAffairsPageRole_Id AND ur.SecurityAffairsUser_Id = @SecurityAffairsUser_Id) > 0 THEN 1
				ELSE 0
			END
			WHERE Serial = @CurrentIndex
		END

		IF (@DeleteEnabled = 1)
		BEGIN
			SET @SecurityAffairsPageRole_Id = (SELECT TOP 1 SecurityAffairsPageRole_Id FROM SecurityAffairsPageRole pr WHERE pr.SecurityAffairsPage_Id = @SecurityAffairsPage_Id AND pr.SecurityAffairsRole_Id = 4)

			UPDATE @RESULTS
			SET CanDelete = 
			CASE
				WHEN (SELECT COUNT(*) FROM SecurityAffairsUserRole ur WHERE ur.SecurityAffairsPageRole_Id = @SecurityAffairsPageRole_Id AND ur.SecurityAffairsUser_Id = @SecurityAffairsUser_Id) > 0 THEN 1
				ELSE 0
			END
			WHERE Serial = @CurrentIndex
		END

		UPDATE @RESULTS SET AllPermissions = 
		CASE
			WHEN (ViewEnabled = CanView) AND (AddEnabled = CanAdd) AND (EditEnabled = CanEdit) AND (DeleteEnabled = CanDelete) THEN 1
			ELSE 0
		END

		SET @CurrentIndex = @CurrentIndex + 1
	END

	SELECT * FROM @RESULTS
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetSecurityAffairsUsers]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetSecurityAffairsUsers](@CurrentUsername nvarchar(MAX))
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		SecurityAffairsUser_Id bigint,
		Username nvarchar(MAX),
		Activated nvarchar(MAX)
	)

	INSERT INTO @RESULTS
	SELECT  TOP 100 PERCENT  
			SecurityAffairsUser_Id,
			Username,
			CASE
			WHEN Activated = 1 THEN N'مفعل'
			ELSE N'معطل'
			END
	FROM	SecurityAffairsUser
	WHERE	LocalLoginPassword IS NULL
	AND		LOWER(@CurrentUsername) <> LOWER(Username)
	ORDER BY Username

	SELECT TOP 100 PERCENT * FROM @RESULTS ORDER BY Username
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetSecurityAffairsUsersForFilter]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetSecurityAffairsUsersForFilter]
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		SecurityAffairsUser_Id bigint,
		Title nvarchar(MAX)
	)
	INSERT INTO @RESULTS VALUES(0,N'--الكل--');
	
	INSERT INTO @RESULTS
	SELECT	TOP 100 PERCENT SecurityAffairsUser_Id,
			Username
	FROM	SecurityAffairsUser
	WHERE	LocalLoginPassword IS NULL
	ORDER BY Username

	SELECT   *
	FROM	 @RESULTS
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetSecurityAffairsUsersLogsReport]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetSecurityAffairsUsersLogsReport]
(
	@User_Id bigint,
	@Page_Id bigint,
	@Role_Id bigint,
	@FromDate date,
	@ToDate date
)
As
BEGIN
	DECLARE @RESULTS TABLE
	(
		UserLog_Id bigint,
		Date_string nvarchar(MAX),
		Time_string nvarchar(MAX),
		Username nvarchar(MAX),
		PageTitle nvarchar(MAX),
		RoleTitle nvarchar(MAX),
		Note nvarchar(MAX)
	)

	INSERT INTO @RESULTS
	SELECT	ul.SecurityAffairsUserLog_Id,
			dbo.fn_GetHijiriDate(ul.LogDate),
			dbo.fn_Get12HoursTimeFormat(ul.LogTime),
			u.Username,
			p.Title,
			r.Title,
			ul.Note
	FROM	SecurityAffairsUserLog ul INNER JOIN
			SecurityAffairsUser u ON ul.SecurityAffairsUser_Id = u.SecurityAffairsUser_Id INNER JOIN
			SecurityAffairsPageRole pr ON ul.SecurityAffairsPageRole_Id = pr.SecurityAffairsPageRole_Id INNER JOIN
			SecurityAffairsPage p ON pr.SecurityAffairsPage_Id = p.SecurityAffairsPage_Id INNER JOIN
			SecurityAffairsRole r ON pr.SecurityAffairsRole_Id = r.SecurityAffairsRole_Id
	WHERE	(@User_Id = 0 OR ul.SecurityAffairsUser_Id = @User_Id)
	AND		(@Page_Id = 0 OR p.SecurityAffairsPage_Id = @Page_Id)
	AND		(@Role_Id = 0 OR r.SecurityAffairsRole_Id = @Role_Id)
	AND		(ul.LogDate BETWEEN @FromDate AND @ToDate)

	SELECT * FROM @RESULTS
END

GO
/****** Object:  StoredProcedure [dbo].[sp_IncreaseAnnouncementView]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_IncreaseAnnouncementView](@Announcement_Id bigint)
As
BEGIN
	UPDATE Announcement SET ViewCount = ViewCount + 1 WHERE Announcement_Id = @Announcement_Id
END

GO
/****** Object:  StoredProcedure [dbo].[sp_IncreaseNewsView]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_IncreaseNewsView](@News_Id bigint)
As
BEGIN
	UPDATE News SET ViewCount = ViewCount + 1 WHERE News_Id = @News_Id
END

GO
/****** Object:  StoredProcedure [dbo].[sp_PortalSettingsAuthentication]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_PortalSettingsAuthentication](@Username nvarchar(MAX), @Password nvarchar(MAX))
As
BEGIN
	SELECT	*
	FROM	PortalSettingsUser
	WHERE	Username = UPPER(@Username)
	AND		(
				@Password IS NULL
				OR
				@Password = LocalLoginPassword
			)
	AND		Activated = 1
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ProvisionsMonitoringAuthentication]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ProvisionsMonitoringAuthentication](@Username nvarchar(MAX), @Password nvarchar(MAX))
As
BEGIN
	SELECT	*
	FROM	ProvisionsMonitoringUser
	WHERE	Username = UPPER(@Username)
	AND		(
				@Password IS NULL
				OR
				@Password = LocalLoginPassword
			)
	AND		Activated = 1
END

GO
/****** Object:  StoredProcedure [dbo].[sp_SecurityAffairsAuthentication]    Script Date: 4/28/2024 7:36:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_SecurityAffairsAuthentication](@Username nvarchar(MAX), @Password nvarchar(MAX))
As
BEGIN
	SELECT	*
	FROM	SecurityAffairsUser
	WHERE	Username = UPPER(@Username)
	AND		(
				@Password IS NULL
				OR
				@Password = LocalLoginPassword
			)
	AND		Activated = 1
END

GO
