<%--
  Created by IntelliJ IDEA.
  User: monster
  Date: 2026/1/9
  Time: 12:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>贴吧</title>
    <link rel="stylesheet" type="text/css" href="CSS/style.css">
    <link rel="stylesheet" type="text/css" href="CSS/bootstrap.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg bg-body-tertiary fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">Navbar</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="#">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Link</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            Dropdown
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="#">Action</a></li>
                            <li><a class="dropdown-item" href="#">Another action</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="#">Something else here</a></li>
                        </ul>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link disabled">Disabled</a>
                    </li>
                </ul>
                <form class="d-flex" role="search">
                    <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
                    <button class="btn btn-outline-success" type="submit">Search</button>
                </form>
            </div>
        </div>
    </nav>

   <section class="p-5"> <%-- p-5 pading--%>
        <div class="container">
            <div class="d-flex ">
                <div>
                    <h1>there is <span class="text-warning">postbar</span></h1>
                    <p>
                        Lorem ipsum dolor sit amet, consectetur adipisicing elit. At consectetur cumque dignissimos dolore quam quibusdam quisquam reiciendis! Ad cum cupiditate, deleniti id minima perspiciatis voluptatibus! At consectetur et nulla voluptatum.
                    </p>
                </div>
                <img src="https://tse3.mm.bing.net/th/id/OIP.rii81IFcIMchHImhYWANmwHaKe?rs=1&pid=ImgDetMain&o=7&rm=3" class="w-25">
            </div>
        </div>
   </section>
    <section>
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <div class="card" style="width: 18rem;">
                        <div class="card-body">
                            <div class="text-center">
                                abababababab
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <div class="main">
        <div id="disp_index_"></div>
    </div>
    <script src="JS/jquery-3.7.1.min.js"></script>
    <script src="JS/bootstrap.js"></script>
</body>
</html>