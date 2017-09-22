USE replicated_data;

UPDATE counts SET value=value+1 WHERE name='metric_1' AND type='counter';
UPDATE counts SET value=value+1 WHERE name='metric_1' AND type='counter';
UPDATE counts SET value=value+1 WHERE name='metric_1' AND type='counter';
UPDATE counts SET value=value+1 WHERE name='metric_1' AND type='counter';
UPDATE counts SET value=value+1 WHERE name='metric_1' AND type='counter';

