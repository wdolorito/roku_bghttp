function GetPosts() as String
  postsUrl = m.api_base + m.posts
  header = { Acept : "application/json" }

  return SendRequest(postsUrl, header)
end function

function GetComments(id) as String
  commentsUrl = m.api_base + m.posts + "/" + id + m.comments
  header = { Accept : "application/json" }

  return SendRequest(commentsUrl, header)
end function


function GetAlbums() as String
  albumsUrl = m.api_base + m.albums
  header = { Accept : "application/json" }

  return SendRequest(albumsUrl, header)
end function

function GetPhotos(id) as String
  photosUrl = m.api_base + m.albums + "/" + id + m.photos
  header = { Accept : "application/json" }

  return SendRequest(photosUrl, header)
end function


function GetUsers() as String
  usersUrl = m.api_base + m.users
  header = { Accept : "application/json" }

  return SendRequest(usersUrl, header)
end function

function GetUserAlbums(id) as String
  usersUrl = m.api_base + m.users + "/" + id + m.useralbums
  header = { Accept : "application/json" }

  return SendRequest(usersUrl, header)
end function

function GetUserTodos(id) as String
  usersUrl = m.api_base + m.users + "/" + id + m.todos
  header = { Accept : "application/json" }

  return SendRequest(usersUrl, header)
end function

function GetUserPosts(id) as String
  usersUrl = m.api_base + m.users + "/" + id + m.userposts
  header = { Accept : "application/json" }

  return SendRequest(usersUrl, header)
end function
