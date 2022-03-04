
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
    sets
  WHERE 
    users_id = '@userId'
""";

String selectPlaylistsQuery =
""" 
  SELECT 
    * 
  FROM 
    playlists
  WHERE 
    users_id = '@userId'
""";

String selectEventsQuery =
""" 
  SELECT 
    * 
  FROM 
    users_permissions up
    JOIN permissions p ON up.permissions_id = p.id
    JOIN events e ON up.events_id = e.id
    JOIN users u ON up.users_id = u.id
  WHERE 
    u.users_id = '@userId'
""";