-- Table: tax_norm_threshold

-- DROP TABLE tax_norm_threshold;

CREATE TABLE tax_norm_threshold
(
  tax_id bigint,
  threshold numeric,
  organism character varying(150),
  constraint tax_norm_threshold_pk primary key(tax_id)
)
;

