enum Routes {
  splash(name: "splash", path: "/"),
  authWrapper(name: "auth-wrapper", path: "/auth-wrapper"),
  login(name: "login", path: "/login"),
  signup(name: "signup", path: "/signup"),
  dashboard(name: "dashboard", path: "/dashboard"),
  userProfile(name: "user-profile", path: "/user-profile"),
  blogDetails(name: "blog-details", path: "/blog-details"),
  addBlog(name: "add-blog", path: "/add-blog"),
  editBlog(name: "edit-blog", path: "/edit-blog");

  const Routes({required this.path, required this.name});

  final String path;
  final String name;
}
