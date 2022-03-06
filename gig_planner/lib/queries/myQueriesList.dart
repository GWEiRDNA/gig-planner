
String myquery =
""" 
  SELECT 
    * 
  FROM 
    users u 
  WHERE 
    id < '@idmax'
""";

String loginQuery =
""" 
  SELECT 
    * 
  FROM 
    users u 
  WHERE 
    email = '@email' and password = '@passwordHash'
""";

String selectTagsQuery =
""" 
  SELECT 
    * 
  FROM 
    tags 
  WHERE 
    users_id = '@userId' OR users_id IS NULL
""";

String selectTagGroupsQuery =
""" 
  SELECT 
    * 
  FROM 
    tag_groups
  WHERE 
    users_id = '@userId'
""";

String selectSongsQuery =
""" 
  SELECT 
    s.*,
    st.tags,
    sa.authors
  FROM
    songs s
    LEFT JOIN 
    (
      SELECT
        s2.id id,
        STRING_AGG(t.id::character varying, ' ') tags
      FROM
        songs_tags st
        JOIN songs s2 ON st.songs_id = s2.id
        JOIN tags t ON st.tags_id = t.id
      GROUP BY
        s2.id
    ) st ON st.id = s.id
    LEFT JOIN 
    (
      SELECT
        s3.id id,
        STRING_AGG(a.id::character varying, ' ') authors
      FROM
        songs_authors sa
        JOIN songs s3 ON sa.songs_id = s3.id
        JOIN authors a ON sa.authors_id = a.id
      GROUP BY
        s3.id
    ) sa ON sa.id = s.id
  WHERE 
    users_id = '@userId'
""";

String selectAuthorsQuery =
""" 
  SELECT 
    * 
  FROM 
    authors
  WHERE 
    users_id = '@userId' OR users_id IS NULL
""";

String selectSetsQuery =
""" 
  SELECT 
    * 
  FROM 
    sets s
    LEFT JOIN 
    (
      select
        sets_id,
        STRING_AGG(song_id::character varying, ' ' ORDER BY "Order") songs
      FROM
        set_elements
      GROUP BY
        sets_id
    ) se ON se.sets_id = s.id
  WHERE
    users_id = '@userId'
""";

String selectPlaylistsQuery =
""" 
  SELECT 
    * 
  FROM 
    playlists p
    LEFT JOIN 
    (
      select
        playlist_id,
        STRING_AGG(
          (COALESCE(song_id, sets_id, -100))::character varying 
          || '|' || 
          CASE WHEN song_id IS NOT NULL THEN 'song' WHEN sets_id IS NOT NULL THEN 'set' ELSE 'wrong' END
          || '|' ||
          played::character varying
        , ' ' ORDER BY "Order") elements
      FROM
        playlist_elements
      GROUP BY
        playlist_id
    ) pe ON pe.playlist_id = p.id
  WHERE 
    users_id = '@userId'
""";

String selectEventsQuery =
""" 
  SELECT
  *
  FROM
  events e
  JOIN
  (
    SELECT 
      e2.id,
      STRING_AGG(p.name, ' ' ORDER BY p.name) permissions
    FROM 
      users_permissions up
      JOIN permissions p ON up.permissions_id = p.id
      JOIN events e2 ON up.events_id = e2.id
    WHERE 
      up.users_id = '@userId'
    GROUP BY
      e2.id
   ) ep ON ep.id = e.id
""";