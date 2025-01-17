---
external help file: Microsoft.Azure.PowerShell.Cmdlets.Resources.dll-Help.xml
Module Name: Az.Resources
online version: https://docs.microsoft.com/powershell/module/az.resources/get-azentities/
schema: 2.0.0
---

# Get-AzManagementGroupEntity

## SYNOPSIS
Lists all Entities under the current Tenant

## SYNTAX

### GetOperation
```
Get-AzManagementGroupEntity [-DefaultProfile <IAzureContextContainer>] [-Expand] [-Recurse] [-WhatIf] 
[-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The **Get-AzManagementGroupEntity** cmdlet gets all entities (Management Groups and Subscriptions) under the current tenant.
## EXAMPLES

### Example 1: Get all Management Groups
```powershell
Get-AzManagementGroupEntity
```

```output
Id          : /providers/Microsoft.Management/managementGroups/TestGroup
Type        : Microsoft.Management/managementGroups
Name        : TestGroup
TenantId    : 6b2064b9-34bd-46e6-9092-52f2dd5f7fc0
DisplayName : TestGroupDisplayName

Id          : /providers/Microsoft.Management/managementGroups/TestGroupChild
Type        : /providers/Microsoft.Management/managementGroups
Name        : TestGroupChild
TenantId    : 6b2064b9-34bd-46e6-9092-52f2dd5f7fc0
DisplayName : TestGroupChildDisplayName
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### Microsoft.Azure.Commands.Resources.Models.ManagementGroups.PSEntityInfo

### Microsoft.Azure.Commands.Resources.Models.ManagementGroups.PSEntityInfo

## NOTES

## RELATED LINKS

