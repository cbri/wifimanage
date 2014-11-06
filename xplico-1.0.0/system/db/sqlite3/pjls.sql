--
-- Tabella delle stampe eseguite con pjl
--
CREATE TABLE IF NOT EXISTS pjls (
  id INTEGER NOT NULL PRIMARY KEY,
  sol_id INTEGER NOT NULL REFERENCES sols(id) ON DELETE CASCADE ON UPDATE CASCADE,
  pol_id INTEGER NOT NULL REFERENCES pols(id) ON DELETE CASCADE ON UPDATE CASCADE,
  source_id INTEGER NOT NULL REFERENCES sources(id) ON DELETE CASCADE ON UPDATE CASCADE,
  capture_date TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
  decoding_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  viewed_date TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
  first_visualization_user_id INTEGER,
  flow_info VARCHAR( 255 ) NOT NULL,
  url VARCHAR( 255 ),
  pdf_path VARCHAR( 255 ),
  pdf_size INTEGER,
  pcl_path VARCHAR( 255 ),
  pcl_size INTEGER,
  error INTEGER DEFAULT 0
);