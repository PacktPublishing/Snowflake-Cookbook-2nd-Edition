# Chapter 5 Governance Recipes – Execution Notes

This README supports the governance-focused recipes in Chapter 5. These recipes build on one another and reuse objects created in earlier recipes.

## Recommended Execution Order

The following recipes are designed to build progressively:

1. r7 – Implementing Column-Level Security with Masking Policies
2. r8 – Implementing Row-Level Security with Row Access Policies
3. r9 – Classifying and Tagging Sensitive Data

## Required Roles

| Role | Purpose |
|---|---|
| SYSADMIN | Creates databases, schemas, and tables |
| USERADMIN | Creates roles |
| SECURITYADMIN | Grants privileges and creates governance policies |
| ACCOUNTADMIN | Grants account-level governance privileges |

## Governance Recipe Dependencies

### r7 – Column-Level Security

Creates:

- GOVERNANCE_DB
- GOVERNANCE_DB.SECURITY
- GOVERNANCE_DB.SECURITY.CUSTOMER_DATA
- GOVERNANCE_DB.SECURITY.EMAIL_MASK
- PII_MASKED
- PII_FULL

### r8 – Row-Level Security

Reuses the objects from r7 and creates:

- REGION_EAST
- REGION_WEST
- REGION_ALL
- GOVERNANCE_DB.SECURITY.REGION_FILTER_POLICY

### r9 – Classifying and Tagging Sensitive Data

Reuses the CUSTOMER_DATA table and EMAIL_MASK masking policy from r7 and creates:

- GOVERNANCE_DB.SECURITY.SENSITIVITY_LEVEL

Before tag-based masking can be tested, the direct masking policy on the EMAIL column is unset because direct column masking policies take precedence over tag-based masking policies.

## Placeholders to Replace

Replace the following placeholder before running the SQL:

```sql
<YOUR_USER_NAME>
```

Use the Snowflake username you want to grant roles to for validation.

## Cleanup

To rerun the governance recipes from scratch, drop the governance database and roles:

```sql
DROP DATABASE IF EXISTS GOVERNANCE_DB;

DROP ROLE IF EXISTS PII_MASKED;
DROP ROLE IF EXISTS PII_FULL;
DROP ROLE IF EXISTS REGION_EAST;
DROP ROLE IF EXISTS REGION_WEST;
DROP ROLE IF EXISTS REGION_ALL;
```
