USE replicated_data;

CREATE TABLE IF NOT EXISTS counts (
  name        varchar,
  type        varchar,
  value       counter,
  PRIMARY KEY (name, type)
);
