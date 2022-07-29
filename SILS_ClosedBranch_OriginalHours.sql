USE [Polaris]
GO

/****** Object:  Table [Polaris].[SILS_ClosedBranch_OriginalHours]    Script Date: 18/03/2021 2:12:50 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Polaris].[SILS_ClosedBranch_OriginalHours](
	[OrganizationID] [int] NOT NULL,
	[BranchHours] [nchar](255) NULL,
	[AddedDate] [datetime] NULL,
	[RestoredDate] [datetime] NULL
) ON [PRIMARY]
GO


