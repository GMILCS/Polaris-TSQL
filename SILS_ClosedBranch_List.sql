USE [Polaris]
GO

/****** Object:  Table [Polaris].[SILS_ClosedBranch_List]    Script Date: 18/03/2021 2:12:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Polaris].[SILS_ClosedBranch_List](
	[OrganizationID] [int] NOT NULL,
	[OrganizationCodeID] [int] NOT NULL,
	[Exception] [bit] NOT NULL,
	[HoldInactivation] [bit] NULL,
	[HoldUntilDates] [bit] NULL,
	[DueDates] [bit] NULL,
	[DatesClosed] [bit] NULL,
	[Restored] [bit] NULL
) ON [PRIMARY]
GO


