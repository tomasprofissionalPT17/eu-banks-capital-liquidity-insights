# EU Banks: Capital & Liquidity Insights (ECB CBD2)

Power BI dashboard tracking CET1, Tier 1, Own Funds, LCR, liquidity buffer and net liquidity outflow for EU countries, built on a minimal PostgreSQL pipeline + ECB CBD2 data.

## Files
- **ECB_CBD2_Bank_Metrics.pbix** – Power BI report
- **ecb_cbd2_pipeline.sql** – SQL for raw landing + analytics table (obs_value_std, period_start_date)
- **sample_bank_data.csv** – tiny sample to open the PBIX without full data
- **dashboard_main.pdf** – static preview
- **/screenshots** – report screenshots

## Data & scope
- Source: European Central Bank, Consolidated Banking Data (CBD2).
- Scope: sector **67** (domestic groups & stand-alone banks **plus** foreign-controlled subs/branches).
- Frequencies: quarterly (P3M) and annual (P1Y). Measures normalize `%` to fractions via `obs_value_std`.

## How to run
1. Run `ecb_cbd2_pipeline.sql` in Postgres to create `raw.bank_data_raw` and `analytics.bank_data`.
2. Import CSV to `raw.bank_data_raw` (pgAdmin `Import/Export` or `\copy`).
3. Point Power BI to `analytics.bank_data` (or the labeled view if you added one).
4. Use `dim_Date` and small *dim_* lookups in the PBIX for tidy slicers.

## Key measures
- **Total No of CIs (Q4, R0100)** – Q4 count of resident credit institutions (item `R0100`, sector `67`).
- **Average Value** – context-aware average using `obs_value_std`.
- **Avg Amount per Institution (EUR, Q4)** – total capital (EUR) / number of institutions.

## Notes
- Large files: track `.pbix` with Git LFS or omit and use PDF/screenshots.
- Licensing: see repo LICENSE. ECB data terms apply.
