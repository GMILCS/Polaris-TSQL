USE [Polaris]
GO

/****** Object:  Table [Polaris].[SILS_HoldDenials_Suspension]    Script Date: 18/03/2021 2:37:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Polaris].[SILS_HoldDenials_Suspension](
	[SysholdrequestID] [int] NOT NULL,
	[ItemRecordID] [int] NOT NULL,
	[DateDenied] [datetime] NULL,
	[Undenied] [bit] NULL
) ON [PRIMARY]
GO


