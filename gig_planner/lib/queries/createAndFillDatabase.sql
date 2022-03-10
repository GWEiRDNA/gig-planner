drop database gigplanner;
create database gigplanner;
\c gigplanner;
\i createTables.sql
\i fillTables.sql

CREATE USER appuser;
GRANT SELECT, INSERT, UPDATE, DELETE
 ON
 songs,
 songs_tags,
 songs_authors,
 tags,
 tag_groups,
 authors,
 users,
 events,
 users_permissions,
 permissions,
 roles_permissions,
 roles,
 song_transitions,
 set_elements,
 sets,
 playlists,
 playlist_elements
 TO appuser;

GRANT USAGE, SELECT ON
    authors_id_seq,
    events_id_seq,
    permissions_id_seq,
    playlists_id_seq,
    roles_id_seq,
    sets_id_seq,
    songs_id_seq,
    tag_groups_id_seq,
    tags_id_seq,
    users_id_seq
TO appuser;