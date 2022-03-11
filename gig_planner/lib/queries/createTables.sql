

CREATE TABLE authors (
    id       SERIAL NOT NULL,
    users_id INTEGER,
    name     VARCHAR(60) NOT NULL
);

ALTER TABLE authors ADD CONSTRAINT authors_pk PRIMARY KEY ( id );

CREATE TABLE events (
    id          SERIAL NOT NULL,
    playlist_id INTEGER,
    name        VARCHAR(30) NOT NULL,
    start_date  TIMESTAMP,
    end_date    TIMESTAMP,
    description text
);

ALTER TABLE events ADD CONSTRAINT events_pk PRIMARY KEY ( id );

CREATE TABLE permissions (
    id   SERIAL NOT NULL,
    name VARCHAR(50) NOT NULL
);

ALTER TABLE permissions ADD CONSTRAINT permissions_pk PRIMARY KEY ( id );

CREATE TABLE playlist_elements (
    playlist_id INTEGER NOT NULL,
    "Order"     INTEGER NOT NULL,
    song_id     INTEGER,
    sets_id     INTEGER,
    played      boolean NOT NULL
);

ALTER TABLE playlist_elements
    ADD CONSTRAINT fkarc_2 CHECK ( ( ( sets_id IS NOT NULL )
                                     AND ( song_id IS NULL ) )
                                   OR ( ( song_id IS NOT NULL )
                                        AND ( sets_id IS NULL ) )
                                   OR ( ( sets_id IS NULL )
                                        AND ( song_id IS NULL ) ) );

ALTER TABLE playlist_elements ADD CONSTRAINT playlist_elements_pk PRIMARY KEY ( playlist_id,
                                                                                "Order" );

CREATE TABLE playlists (
    id       SERIAL NOT NULL,
    users_id INTEGER NOT NULL
);

ALTER TABLE playlists ADD CONSTRAINT playlists_pk PRIMARY KEY ( id );

CREATE TABLE roles (
    id   SERIAL NOT NULL,
    name VARCHAR(50) NOT NULL
);

ALTER TABLE roles ADD CONSTRAINT roles_pk PRIMARY KEY ( id );

CREATE TABLE roles_permissions (
    permissions_id INTEGER NOT NULL,
    roles_id       INTEGER NOT NULL
);

ALTER TABLE roles_permissions ADD CONSTRAINT roles_permissions_pk PRIMARY KEY ( permissions_id,
                                                                                roles_id );

CREATE TABLE set_elements (
    sets_id INTEGER NOT NULL,
    "Order" INTEGER NOT NULL,
    song_id INTEGER NOT NULL
);

ALTER TABLE set_elements ADD CONSTRAINT set_elements_pk PRIMARY KEY ( sets_id,
                                                                      "Order" );

CREATE TABLE sets (
    id       SERIAL NOT NULL,
    users_id INTEGER NOT NULL,
    name     VARCHAR(30) NOT NULL,
    color    CHAR(7) NOT NULL
);

ALTER TABLE sets ADD CONSTRAINT sets_pk PRIMARY KEY ( id );

CREATE TABLE song_transitions (
    pervious_song_id INTEGER NOT NULL,
    next_song_id     INTEGER NOT NULL,
    power            INTEGER NOT NULL,
    created_manualy  boolean NOT NULL
);

ALTER TABLE song_transitions ADD CONSTRAINT song_transitions_pk PRIMARY KEY ( pervious_song_id,
                                                                              next_song_id );

CREATE TABLE songs (
    id              SERIAL NOT NULL,
    users_id        INTEGER NOT NULL,
    title           VARCHAR(30) NOT NULL,
    album           VARCHAR(30),
    date_of_release DATE,
    bpm             FLOAT NOT NULL,
    lyrics          text,
    sheet_music     text,
    mp3             varchar,
    length          SMALLINT
);


ALTER TABLE songs ADD CONSTRAINT songs_pk PRIMARY KEY ( id );

CREATE TABLE songs_authors (
    songs_id   INTEGER NOT NULL,
    authors_id INTEGER NOT NULL
);

ALTER TABLE songs_authors ADD CONSTRAINT songs_authors_pk PRIMARY KEY ( songs_id,
                                                                        authors_id );

CREATE TABLE songs_tags (
    songs_id INTEGER NOT NULL,
    tags_id  INTEGER NOT NULL
);

ALTER TABLE songs_tags ADD CONSTRAINT songs_tags_pk PRIMARY KEY ( songs_id,
                                                                  tags_id );

CREATE TABLE tag_groups (
    id       SERIAL NOT NULL,
    users_id INTEGER NOT NULL,
    name     VARCHAR(30) NOT NULL,
    color    CHAR(7) NOT NULL
);

ALTER TABLE tag_groups ADD CONSTRAINT tag_groups_pk PRIMARY KEY ( id );

CREATE TABLE tags (
    id            SERIAL NOT NULL,
    tag_groups_id INTEGER,
    users_id      INTEGER,
    name          VARCHAR(15) NOT NULL
);

ALTER TABLE tags ADD CONSTRAINT tags_pk PRIMARY KEY ( id );

CREATE TABLE users (
    id       SERIAL NOT NULL,
    email    VARCHAR(50) NOT NULL UNIQUE,
    password CHAR(64) NOT NULL,
    name     VARCHAR(30) NOT NULL UNIQUE
);


ALTER TABLE users ADD CONSTRAINT users_pk PRIMARY KEY ( id );

CREATE TABLE users_permissions (
    users_id       INTEGER NOT NULL,
    events_id      INTEGER NOT NULL,
    permissions_id INTEGER NOT NULL
);

ALTER TABLE users_permissions
    ADD CONSTRAINT users_permissions_pk PRIMARY KEY ( events_id,
                                                      permissions_id,
                                                      users_id );

ALTER TABLE authors
    ADD CONSTRAINT authors_users_fk FOREIGN KEY ( users_id )
        REFERENCES users ( id ) ON DELETE CASCADE;

ALTER TABLE events
    ADD CONSTRAINT events_playlists_fk FOREIGN KEY ( playlist_id )
        REFERENCES playlists ( id ) ON DELETE CASCADE;

ALTER TABLE playlist_elements
    ADD CONSTRAINT playlist_elements_playlists_fk FOREIGN KEY ( playlist_id )
        REFERENCES playlists ( id ) ON DELETE CASCADE;

ALTER TABLE playlist_elements
    ADD CONSTRAINT playlist_elements_sets_fk FOREIGN KEY ( sets_id )
        REFERENCES sets ( id ) ON DELETE CASCADE;

ALTER TABLE playlist_elements
    ADD CONSTRAINT playlist_elements_songs_fk FOREIGN KEY ( song_id )
        REFERENCES songs ( id ) ON DELETE CASCADE;

ALTER TABLE playlists
    ADD CONSTRAINT playlists_users_fk FOREIGN KEY ( users_id )
        REFERENCES users ( id ) ON DELETE CASCADE;

--  ERROR: FK name length exceeds maximum allowed length(30)
ALTER TABLE roles_permissions
    ADD CONSTRAINT roles_permissions_permissions_fk FOREIGN KEY ( permissions_id )
        REFERENCES permissions ( id ) ON DELETE CASCADE;

ALTER TABLE roles_permissions
    ADD CONSTRAINT roles_permissions_roles_fk FOREIGN KEY ( roles_id )
        REFERENCES roles ( id ) ON DELETE CASCADE;

ALTER TABLE set_elements
    ADD CONSTRAINT set_elements_sets_fk FOREIGN KEY ( sets_id )
        REFERENCES sets ( id ) ON DELETE CASCADE;

ALTER TABLE set_elements
    ADD CONSTRAINT set_elements_songs_fk FOREIGN KEY ( song_id )
        REFERENCES songs ( id ) ON DELETE CASCADE;

ALTER TABLE sets
    ADD CONSTRAINT sets_users_fk FOREIGN KEY ( users_id )
        REFERENCES users ( id ) ON DELETE CASCADE;

ALTER TABLE song_transitions
    ADD CONSTRAINT song_transitions_songs_next FOREIGN KEY ( next_song_id )
        REFERENCES songs ( id ) ON DELETE CASCADE;

--  ERROR: FK name length exceeds maximum allowed length(30)
ALTER TABLE song_transitions
    ADD CONSTRAINT song_transitions_songs_pervious FOREIGN KEY ( pervious_song_id )
        REFERENCES songs ( id ) ON DELETE CASCADE;

ALTER TABLE songs_authors
    ADD CONSTRAINT songs_authors_authors_fk FOREIGN KEY ( authors_id )
        REFERENCES authors ( id ) ON DELETE CASCADE;

ALTER TABLE songs_authors
    ADD CONSTRAINT songs_authors_songs_fk FOREIGN KEY ( songs_id )
        REFERENCES songs ( id ) ON DELETE CASCADE;

ALTER TABLE songs_tags
    ADD CONSTRAINT songs_tags_songs_fk FOREIGN KEY ( songs_id )
        REFERENCES songs ( id ) ON DELETE CASCADE;

ALTER TABLE songs_tags
    ADD CONSTRAINT songs_tags_tags_fk FOREIGN KEY ( tags_id )
        REFERENCES tags ( id ) ON DELETE CASCADE;

ALTER TABLE songs
    ADD CONSTRAINT songs_users_fk FOREIGN KEY ( users_id )
        REFERENCES users ( id ) ON DELETE CASCADE;

ALTER TABLE tag_groups
    ADD CONSTRAINT tag_groups_users_fk FOREIGN KEY ( users_id )
        REFERENCES users ( id ) ON DELETE CASCADE;

ALTER TABLE tags
    ADD CONSTRAINT tags_tag_groups_fk FOREIGN KEY ( tag_groups_id )
        REFERENCES tag_groups ( id ) ON DELETE CASCADE;

ALTER TABLE tags
    ADD CONSTRAINT tags_users_fk FOREIGN KEY ( users_id )
        REFERENCES users ( id ) ON DELETE CASCADE;

ALTER TABLE users_permissions
    ADD CONSTRAINT users_permissions_events_fk FOREIGN KEY ( events_id )
        REFERENCES events ( id ) ON DELETE CASCADE;

--  ERROR: FK name length exceeds maximum allowed length(30)
ALTER TABLE users_permissions
    ADD CONSTRAINT users_permissions_permissions_fk FOREIGN KEY ( permissions_id )
        REFERENCES permissions ( id ) ON DELETE CASCADE;

ALTER TABLE users_permissions
    ADD CONSTRAINT users_permissions_users_fk FOREIGN KEY ( users_id )
        REFERENCES users ( id ) ON DELETE CASCADE;

ALTER TABLE tag_groups
ADD CONSTRAINT color_check
CHECK (
   color SIMILAR TO '#[0123456789abcdef]{6}'
);

ALTER TABLE tag_groups
ADD CONSTRAINT name_length_check
CHECK (
   LENGTH(name) >= 1
);

ALTER TABLE users
ADD CONSTRAINT email_check
CHECK (
  email SIMILAR TO '[^@]+@[^@]+\.[^@]+'
);

ALTER TABLE users
ADD CONSTRAINT name_length_check
CHECK (
  LENGTH(name) >= 3
);

ALTER TABLE users
ADD CONSTRAINT password_empty_check
CHECK (
  password <> '$5$v9SferVS2DklThF0$dxNhQ1MwIrsijf/TVaiCqX/COvl0dj2xp9ZZdURYLP3'
);

ALTER TABLE tags
ADD CONSTRAINT name_length_check
CHECK (
  LENGTH(name) >= 1
);

ALTER TABLE authors
ADD CONSTRAINT name_length_check
CHECK (
  LENGTH(name) >= 1
);

ALTER TABLE songs
ADD CONSTRAINT title_length_check
CHECK (
  LENGTH(title) >= 1
);

ALTER TABLE songs
ADD CONSTRAINT album_length_check
CHECK (
  album IS NULL OR LENGTH(album) >= 1
);

ALTER TABLE songs
ADD CONSTRAINT bpm_check
CHECK (
  bpm >= 0
);

ALTER TABLE songs
ADD CONSTRAINT length_check
CHECK (
  length IS NULL OR length >= 0
);

ALTER TABLE sets
ADD CONSTRAINT color_check
CHECK (
   color SIMILAR TO '#[0123456789abcdef]{6}'
);

ALTER TABLE playlist_elements
ADD CONSTRAINT song_set_check
CHECK (
   (song_id IS NULL AND sets_id IS NOT NULL)
   OR
   (song_id IS NOT NULL AND sets_id IS NULL)
);

ALTER TABLE events
ADD CONSTRAINT name_length_check
CHECK (
  LENGTH(name) >= 1
);

ALTER TABLE events
ADD CONSTRAINT date_length_check
CHECK (
  end_date >= start_date
);

ALTER TABLE permissions
ADD CONSTRAINT name_length_check
CHECK (
  LENGTH(name) >= 1
);

ALTER TABLE roles
ADD CONSTRAINT name_length_check
CHECK (
  LENGTH(name) >= 1
);
