-- RAW landing table (1:1 with ECB CSV)
CREATE SCHEMA IF NOT EXISTS raw;

DROP TABLE IF EXISTS raw.bank_data_raw;
CREATE TABLE raw.bank_data_raw (
    key               TEXT,
    freq              TEXT,
    ref_area          TEXT,
    count_area        TEXT,
    cb_rep_sector     TEXT,
    bs_count_sector   TEXT,
    bs_nfc_activity   TEXT,
    cb_sector_size    TEXT,
    cb_rep_framewrk   TEXT,
    cb_item           TEXT,
    cb_portfolio      TEXT,
    cb_exp_type       TEXT,
    cb_val_method     TEXT,
    maturity_res      TEXT,
    data_type         TEXT,
    currency_trans    TEXT,
    unit_measure      TEXT,
    time_period       TEXT,
    obs_value         TEXT,
    obs_status        TEXT,
    conf_status       TEXT,
    pre_break_value   TEXT,
    comment_obs       TEXT,
    time_format       TEXT,
    breaks            TEXT,
    comment_ts        TEXT,
    compiling_org     TEXT,
    coverage          TEXT,
    currency          TEXT,
    data_comp         TEXT,
    decimals          TEXT,
    diss_org          TEXT,
    publ_ecb          TEXT,
    publ_mu           TEXT,
    publ_public       TEXT,
    time_per_collect  TEXT,
    title             TEXT,
    title_compl       TEXT,
    unit_mult         TEXT
);

-- ANALYTICS table (typed helpers)
CREATE SCHEMA IF NOT EXISTS analytics;

DROP TABLE IF EXISTS analytics.bank_data;
CREATE TABLE analytics.bank_data AS
WITH src AS (
  SELECT
    r.*,
    CASE
      WHEN r.time_period ~ '^\d{4}$'
        THEN make_date(r.time_period::int, 1, 1)
      WHEN r.time_period ~ '^\d{4}-Q[1-4]$'
        THEN make_date(substr(r.time_period,1,4)::int,
                       ((substr(r.time_period,7,1)::int - 1) * 3) + 1, 1)
      WHEN r.time_period ~ '^\d{4}-(0[1-9]|1[0-2])$'
        THEN make_date(substr(r.time_period,1,4)::int,
                       substr(r.time_period,6,2)::int, 1)
      ELSE NULL
    END AS period_start_date,
    CASE
      WHEN r.obs_value ~ '^\s*-?\d+(\.\d+)?\s*$'
        THEN NULLIF(trim(r.obs_value), '')::numeric
      ELSE NULL
    END AS obs_value_num
  FROM raw.bank_data_raw r
)
SELECT
  s.*,
  CASE
    WHEN lower(s.unit_measure) = 'pc' AND s.obs_value_num IS NOT NULL
      THEN s.obs_value_num / 100.0
    ELSE s.obs_value_num
  END AS obs_value_std
FROM src s;
