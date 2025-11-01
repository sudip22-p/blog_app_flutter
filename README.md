# Blog App

**A Flutter Blog App to share your thoughts, add posts, and engage with others in real time.**  
Create, like, comment, and connect — all in one smooth, modern app.

---

## Project Overview

A **Flutter Blog App** built with a scalable clean architecture.  
It integrates **Firebase Auth** (Email & Google), **Cloud Firestore** for data,  
**Firebase Realtime Database** for engagement (likes, comments, views),  
**Cloudinary** for image hosting, **HydratedBloc** for offline persistence, and  
**Clean Architecture** with **Dependency Injection (get_it)** and **Bloc** for state management.

---

## Highlights

- **Authentication:** Firebase Auth (Email/Password + Google Sign-In)
- **State Management:** flutter_bloc + hydrated_bloc
- **Offline Persistence:** HydratedBloc
- **Realtime Engagement:** Firebase Realtime Database (views, likes, comments)
- **Data Store:** Cloud Firestore (posts, users)
- **Image Hosting:** Cloudinary
- **Architecture:** Clean Architecture
- **Dependency Injection:** get_it / injectable
- **Theme Support:** Light & Dark modes
- **Post Management:** Search and filtering

---

## Features

### Authentication

- Email & password sign up / sign in
- Google Sign-In integration
- Session persistence and secure sign out

### Posts & Media

- Create / Read / Update / Delete posts (Firestore)
- Upload and manage images with Cloudinary (URL stored in Firestore)
- Search and filter posts by title, tag, or author

### Realtime Engagement

- **Views:** Auto-incremented and streamed from Realtime Database
- **Likes:** Per-user toggle with live count updates
- **Comments:** Live comment stream powered by Realtime Database

### Personalization

- Light and dark theme support
- Offline persistence via HydratedBloc

---

## Next Steps

- Implement real-time notifications for post likes and comments
- Add bookmarking and user following features

---

## Screenshots

<table>
  <tr>
    <td><img src="assets/screenshots/ss_light_login.jpg" width="300" alt="Login"></td>
    <td><img src="assets/screenshots/ss_dark_login.jpg" width="300" alt="Login"></td>
  </tr>
  <tr>
    <td><img src="assets/screenshots/ss_light_register.jpg" width="300" alt="Register"></td>
    <td><img src="assets/screenshots/ss_dark_register.jpg" width="300" alt="Register"></td>
  </tr>
  <tr>
    <td><img src="assets/screenshots/ss_light_latest-blogs.jpg" width="300" alt="Latest Blogs"></td>
    <td><img src="assets/screenshots/ss_dark_latest-blogs.jpg" width="300" alt="Latest Blogs"></td>
  </tr>
  <tr>
    <td><img src="assets/screenshots/ss_light_explore-blogs.jpg" width="300" alt="Explore Blogs"></td>
    <td><img src="assets/screenshots/ss_dark_explore-blogs.jpg" width="300" alt="Explore Blogs"></td>
  </tr>
  <tr>
    <td><img src="assets/screenshots/ss_light_explore-blogs-search.jpg" width="300" alt="Explore Blogs Search"></td>
    <td><img src="assets/screenshots/ss_dark_explore-blogs-search.jpg" width="300" alt="Explore Blogs Search"></td>
  </tr>
  <tr>
    <td><img src="assets/screenshots/ss_light_blog-details.jpg" width="300" alt="Blog Details"></td>
    <td><img src="assets/screenshots/ss_dark_blog-details.jpg" width="300" alt="Blog Details"></td>
  </tr>
  <tr>
    <td><img src="assets/screenshots/ss_light_blog-details-stats.jpg" width="300" alt="Blog Details Stats"></td>
    <td><img src="assets/screenshots/ss_dark_blog-details-stats.jpg" width="300" alt="Blog Details Stats"></td>
  </tr>
  <tr>
    <td><img src="assets/screenshots/ss_light_favourites.jpg" width="300" alt="Favourites"></td>
    <td><img src="assets/screenshots/ss_dark_favourites.jpg" width="300" alt="Favourites"></td>
  </tr>
  <tr>
    <td><img src="assets/screenshots/ss_light_my-blogs.jpg" width="300" alt="My Blogs"></td>
    <td><img src="assets/screenshots/ss_dark_my-blogs.jpg" width="300" alt="My Blogs"></td>
  </tr>
  <tr>
    <td><img src="assets/screenshots/ss_light_create-blog.jpg" width="300" alt="Create Blogs"></td>
    <td><img src="assets/screenshots/ss_dark_create-blog.jpg" width="300" alt="Create Blogs"></td>
  </tr>
  <tr>
    <td><img src="assets/screenshots/ss_light_user-profile.jpg" width="300" alt="User Profile"></td>
    <td><img src="assets/screenshots/ss_dark_user-profile.jpg" width="300" alt="User Profile"></td>
  </tr>
  <tr>
    <td><img src="assets/screenshots/ss_light_edit-user-profile.jpg" width="300" alt="Edit User Profile"></td>
    <td><img src="assets/screenshots/ss_dark_edit-user-profile.jpg" width="300" alt="Edit User Profile"></td>
  </tr>
  
</table>
