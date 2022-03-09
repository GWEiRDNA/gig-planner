
String loginQuery =
""" 
  SELECT 
    * 
  FROM 
    users u 
  WHERE 
    email = @email and password = @passwordHash
""";

//TAG GROUPS
String selectTagGroupsQuery =
""" 
  SELECT 
    * 
  FROM 
    tag_groups
  WHERE 
    users_id = @userId
  ORDER BY
    name
""";
String insertTagGroupsQuery =
"""
  INSERT INTO tag_groups (Users_ID, name, color) VALUES (@userId, @name, @color)
  RETURNING *;
""";
String updateTagGroupsQuery =
"""
  UPDATE tag_groups SET name = @name, color = @color WHERE id = @id
  RETURNING *;
""";
String deleteTagGroupsQuery =
"""
  DELETE FROM tag_groups WHERE id = @id
  RETURNING *;
""";

//TAGS
String selectTagsQuery =
""" 
  SELECT 
    * 
  FROM 
    tags 
  WHERE 
    users_id = @userId OR users_id IS NULL
  ORDER BY
    name
""";
String insertTagQuery =
"""
  INSERT INTO tags (tag_groups_id, users_id, name) VALUES (@tagGroupsId, @userId, @name)
  RETURNING *;
""";
String deleteTagQuery =
"""
  DELETE FROM tags WHERE id = @id AND users_id = @userId
  RETURNING *;
""";

//AUTHORS
String selectAuthorsQuery =
""" 
  SELECT 
    * 
  FROM 
    authors
  WHERE 
    users_id = @userId OR users_id IS NULL
  ORDER BY
    name
""";
String insertAuthorQuery =
"""
  INSERT INTO authors (users_id, name) VALUES (@userId, @name)
  RETURNING *;
""";
String updateAuthorQuery =
"""
  UPDATE authors SET name = @name WHERE id = @id AND users_id = @userId
  RETURNING *;
""";
String deleteAuthorQuery =
"""
  DELETE FROM authors WHERE id = @id AND users_id = @userId
  RETURNING *;
""";


//SONGS
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
    users_id = @userId
  ORDER BY
    s.title
""";
String insertSongQuery =
"""
  INSERT INTO songs (users_id, title, album, date_of_release, bpm, lyrics, sheet_music, mp3, length) 
  VALUES (@userId, @title, @album, @dateOfRelease, @bpm, @lyrics, @sheetMusic, @mp3, @length)
  RETURNING *;
""";
String updateSongQuery =
"""
  UPDATE songs 
  SET 
    title = @title,
    album = @album,
    date_of_release = @dateOfRelease,
    bpm = @bpm,
    lyrics = @lyrics,
    sheet_music = @sheetMusic,
    mp3 = @mp3,
    length = @length
  WHERE id = @id
  RETURNING *;
""";
String deleteSongQuery =
"""
  DELETE FROM songs WHERE id = @id
  RETURNING *;
""";

//SETS
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
    users_id = @userId
  ORDER BY
    name
""";
String insertSetQuery =
"""
  INSERT INTO sets (users_id, name, color) VALUES (@userId, @name, @color)
  RETURNING *;
""";
String updateSetQuery =
"""
  UPDATE sets SET name = @name, color = @color WHERE id = @id
  RETURNING *;
""";
String deleteSetQuery =
"""
  DELETE FROM sets WHERE id = @id
  RETURNING *;
""";
String insertSetElementQuery =
"""
  INSERT INTO set_elements (sets_id, "Order", song_id) VALUES (@setId, (SELECT COALESCE(MAX("Order")+1,1) FROM set_elements WHERE sets_id = @setId), @songId)
  RETURNING *;
""";
String deleteSetElementQuery =
"""
  DELETE FROM set_elements WHERE sets_id = @setId AND song_id = @songId
  RETURNING *;
""";

//PLAYLISTS
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
    users_id = @userId
  ORDER BY
    p.id
""";
String insertPlaylistElementQuery =
"""
  INSERT INTO playlist_elements (playlist_id, "Order", song_id, sets_id, played) VALUES (@playlistId, (SELECT COALESCE(MAX("Order")+1,1) FROM playlist_elements WHERE playlist_id = @playlistId), @songId, @setsId, @played)
  RETURNING *;
""";
String deletePlaylistSongQuery =
"""
  DELETE FROM playlist_elements WHERE playlist_id = @playlistId AND song_id = @songId
  RETURNING *;
""";
String deletePlaylistSetQuery =
"""
  DELETE FROM playlist_elements WHERE playlist_id = @playlistId AND sets_id = @setsId
  RETURNING *;
""";


//EVENTS
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
      up.users_id = @userId
    GROUP BY
      e2.id
   ) ep ON ep.id = e.id
   ORDER BY
    e.name
""";
String insertEventQuery =
"""
  INSERT INTO events (playlist_id, name, start_date, end_date, description) VALUES (@playListId, @name, @startDate, @endDate, @description)
  RETURNING *;
""";
String updateEventQuery =
"""
  UPDATE events SET playlist_id = @playListId, name = @name, start_date = @startDate, end_date = @endDate, description = @description WHERE id = @id
  RETURNING *;
""";
String deleteEventQuery =
"""
  DELETE FROM events WHERE id = @id
  RETURNING *;
""";
String insertPermissionsQuery =
"""
  INSERT INTO users_permissions (user_id, events_id, permissions_id) VALUES (@userId, @eventId, @permissionId)
  RETURNING *;
""";
String deletePermissionsQuery =
"""
  DELETE FROM users_permissions WHERE user_id = @userId AND events_id = @eventId AND permissions_id = @permissionId
  RETURNING *;
""";