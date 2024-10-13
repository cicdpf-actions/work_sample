create table sample (
      id   INT         AUTO_INCREMENT NOT NULL
    , name VARCHAR(30) NOT NULL
    , ts   TIMESTAMP   DEFAULT CURRENT_TIMESTAMP
    , dt   DATETIME    DEFAULT CURRENT_TIMESTAMP
    , PRIMARY KEY (id)
)
;