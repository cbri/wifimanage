--
-- Tabella dei canali di chat paltalk express
--
CREATE TABLE IF NOT EXISTS paltalk_exps (
  id INTEGER NOT NULL PRIMARY KEY,
  sol_id INTEGER NOT NULL REFERENCES sols(id) ON DELETE CASCADE ON UPDATE CASCADE,
  pol_id INTEGER NOT NULL REFERENCES pols(id) ON DELETE CASCADE ON UPDATE CASCADE,
  source_id INTEGER NOT NULL REFERENCES sources(id) ON DELETE CASCADE ON UPDATE CASCADE,
  capture_date TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
  decoding_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  viewed_date TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
  first_visualization_user_id INTEGER,
  flow_info VARCHAR( 255 ) NOT NULL,
  user_nick VARCHAR( 255 ),
  end_date TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
  channel_path VARCHAR( 255 )
);