function Main() as Void
  MVars()

  RunMainLoop()
end function

function RunMainLoop() as Void
  posts = GetPosts()
  albums = GetAlbums()
  users = GetUsers()

  m.bg_service.StartTask(posts)
  m.bg_service.StartTask(albums)
  m.bg_service.StartTask(users)

  while m.bg_service.GetTaskStatus(posts) = False 'and (albumsRes = False) and (usersRes = False)
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
  Print(retrievedPosts[0])

  albumsRaw = m.bg_service.GetTaskResponse(albums)
  retrievedAlbums = ParseJson(albumsRaw)
  Print(retrievedAlbums[0])

  usersRaw = m.bg_service.GetTaskResponse(users)
  retrievedUsers = ParseJson(usersRaw)
  Print(retrievedUsers[0])
end function

