function Main() as Void
  MVars()

  FetchMain()
end function

function FetchMain() as Void
  posts = GetPosts()
  albums = GetAlbums()
  users = GetUsers()

  m.bg_service.StartTask(posts)
  m.bg_service.StartTask(albums)
  m.bg_service.StartTask(users)

  while m.bg_service.GetTaskStatus(posts) = False
    m.bg_service.CheckTasks()
  end while

  while m.bg_service.GetTaskStatus(albums) = False
    m.bg_service.CheckTasks()
  end while
  
  while m.bg_service.GetTaskStatus(users) = False
    m.bg_service.CheckTasks()
  end while

  postsRaw = m.bg_service.GetTaskResponse(posts)
  retrievedPosts = ParseJson(postsRaw)
  firstPost = retrievedPosts[0]
  Print(firstPost)
  postComments = FetchComments(firstPost)

  albumsRaw = m.bg_service.GetTaskResponse(albums)
  retrievedAlbums = ParseJson(albumsRaw)
  firstAlbum = retrievedAlbums[0]
  Print(firstAlbum)
  albumPhotos = FetchPhotos(firstAlbum)

  usersRaw = m.bg_service.GetTaskResponse(users)
  retrievedUsers = ParseJson(usersRaw)
  firstUser = retrievedUsers[0]
  Print(firstUser)
  userAlbums = FetchUserAlbums(firstUser)
  userTodos = FetchUserTodos(firstUser)
  userPosts = FetchUserPosts(firstUser)
end function

function FetchComments(post) as Object
  id = itostr(post.id)

  comments = GetComments(id)
  m.bg_service.StartTask(comments)

  while m.bg_service.GetTaskStatus(comments) = False
    m.bg_service.CheckTasks()
  end while

  commentsRaw = m.bg_service.GetTaskResponse(comments)
  retrievedComments = ParseJson(commentsRaw)
  firstComment = retrievedComments[0]
  Print(firstComment)

  return retrievedComments
end function

function FetchPhotos(album) as Object
  id = itostr(album.id)

  photos = GetPhotos(id)
  m.bg_service.StartTask(photos)

  while m.bg_service.GetTaskStatus(photos) = False
    m.bg_service.CheckTasks()
  end while

  photosRaw = m.bg_service.GetTaskResponse(photos)
  retrievedPhotos = ParseJson(photosRaw)
  firstPhoto = retrievedPhotos[0]
  Print(firstPhoto)

  return retrievedPhotos
end function

function FetchUserAlbums(user) as Object
  id = itostr(user.id)

  userAlbums = GetUserAlbums(id)
  m.bg_service.StartTask(userAlbums)

  while m.bg_service.GetTaskStatus(userAlbums) = False
    m.bg_service.CheckTasks()
  end while

  userAlbumsRaw = m.bg_service.GetTaskResponse(userAlbums)
  retrievedUserAlbums = ParseJson(userAlbumsRaw)
  firstUserAlbum = retrievedUserAlbums[0]
  Print(firstUserAlbum)

  return retrievedUserAlbums
end function

function FetchUserTodos(user) as Object
  id = itostr(user.id)

  userTodos = GetUserTodos(id)
  m.bg_service.StartTask(userTodos)

  while m.bg_service.GetTaskStatus(userTodos) = False
    m.bg_service.CheckTasks()
  end while

  userTodosRaw = m.bg_service.GetTaskResponse(userTodos)
  retrievedUserTodos = ParseJson(userTodosRaw)
  firstUserTodo = retrievedUserTodos[0]
  Print(firstUserTodo)

  return retrievedUserTodos
end function

function FetchUserPosts(user) as Object
  id = itostr(user.id)

  userPosts = GetUserPosts(id)
  m.bg_service.StartTask(userPosts)

  while m.bg_service.GetTaskStatus(userPosts) = False
    m.bg_service.CheckTasks()
  end while

  userPostsRaw = m.bg_service.GetTaskResponse(userPosts)
  retrievedUserPosts = ParseJson(userPostsRaw)
  firstUserPost = retrievedUserPosts[0]
  Print(firstUserPost)

  return retrievedUserPosts
end function
