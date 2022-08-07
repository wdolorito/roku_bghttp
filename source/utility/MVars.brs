function MVars() as Void
  m.api_base = "https://jsonplaceholder.typicode.com"

  ' Endpoints
  m.posts = "/posts"
  m.albums = "/albums"
  m.users = "/users"

  ' Secondary endpoints
  m.comments = "/comments" ' e.g. /posts/1/comments
  m.photos = "/photos"     ' e.g. /albums/1/photos
  m.useralbums = "/albums"     ' e.g. /users/1/albums
  m.todos = "/todos"       ' e.g. /users/1/todos
  m.userposts = "/posts"   ' e.g. /users/1/posts

  ' Initialize http service object
  m.bg_service = BGHTTPService()
end function
