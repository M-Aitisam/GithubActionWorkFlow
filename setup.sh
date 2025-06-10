#!/bin/bash

# Create project structure
mkdir -p .github/workflows public/css public/images views/partials

# Create files
touch .github/workflows/nodejs.yml
touch public/css/style.css
touch views/index.ejs views/partials/header.ejs views/partials/footer.ejs
touch app.js .gitignore

# Initialize Node.js project
echo "Initializing Node.js project..."
npm init -y

# Install dependencies
echo "Installing dependencies..."
npm install express ejs

# Create .gitignore
echo "node_modules/" > .gitignore
echo ".DS_Store" >> .gitignore

# Create GitHub Actions workflow
cat > .github/workflows/nodejs.yml << 'EOF'
name: Node.js CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [18.x]

    steps:
    - uses: actions/checkout@v4
    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v4
      with:
        node-version: ${{ matrix.node-version }}
        cache: 'npm'
    - run: npm ci
    - run: npm test
EOF

# Create app.js
cat > app.js << 'EOF'
const express = require('express');
const app = express();
const path = require('path');

// Set EJS as view engine
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Serve static files
app.use(express.static(path.join(__dirname, 'public')));

// Restaurant data
const restaurant = {
  name: "Gourmet Box",
  description: "Exquisite dining experience in a luxurious setting",
  images: [
    "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80",
    "https://images.unsplash.com/photo-1552566626-52f8b828add9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80",
    "https://images.unsplash.com/photo-1554679665-f5537f187268?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80"
  ],
  menu: [
    { name: "Truffle Pasta", price: "$24" },
    { name: "Seafood Platter", price: "$38" },
    { name: "Chocolate Soufflé", price: "$12" }
  ]
};

// Routes
app.get('/', (req, res) => {
  res.render('index', { restaurant });
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
EOF

# Create EJS templates
cat > views/partials/header.ejs << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= restaurant.name %></title>
    <link rel="stylesheet" href="/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Poppins:wght@300;400;500&display=swap" rel="stylesheet">
</head>
<body>
    <header class="main-header">
        <div class="container">
            <h1><%= restaurant.name %></h1>
            <p><%= restaurant.description %></p>
        </div>
    </header>
EOF

cat > views/index.ejs << 'EOF'
<%- include('partials/header') %>

    <main class="container">
        <section class="gallery">
            <% restaurant.images.forEach(image => { %>
                <div class="gallery-item">
                    <img src="<%= image %>" alt="Restaurant ambiance">
                </div>
            <% }); %>
        </section>

        <section class="menu">
            <h2>Signature Dishes</h2>
            <div class="menu-grid">
                <% restaurant.menu.forEach(item => { %>
                    <div class="menu-item">
                        <h3><%= item.name %></h3>
                        <p><%= item.price %></p>
                    </div>
                <% }); %>
            </div>
        </section>
    </main>

<%- include('partials/footer') %>
EOF

cat > views/partials/footer.ejs << 'EOF'
    <footer>
        <div class="container">
            <p>&copy; 2023 Gourmet Box Restaurant. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
EOF

# Create CSS file
cat > public/css/style.css << 'EOF'
:root {
    --primary: #d4af37;
    --dark: #1a1a1a;
    --light: #f5f5f5;
    --accent: #8b0000;
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Poppins', sans-serif;
    background-color: var(--light);
    color: var(--dark);
    line-height: 1.6;
}

.container {
    width: 90%;
    max-width: 1200px;
    margin: 0 auto;
    padding: 2rem 0;
}

.main-header {
    background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)), 
                url('https://images.unsplash.com/photo-1514933651103-005eec06c04b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80');
    background-size: cover;
    background-position: center;
    color: white;
    text-align: center;
    padding: 5rem 0;
}

.main-header h1 {
    font-family: 'Playfair Display', serif;
    font-size: 4rem;
    margin-bottom: 1rem;
}

.main-header p {
    font-size: 1.2rem;
    max-width: 800px;
    margin: 0 auto;
}

.gallery {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 2rem;
    margin: 3rem 0;
}

.gallery-item {
    border-radius: 10px;
    overflow: hidden;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    transition: transform 0.3s ease;
}

.gallery-item:hover {
    transform: translateY(-10px);
}

.gallery-item img {
    width: 100%;
    height: 250px;
    object-fit: cover;
    display: block;
}

.menu h2 {
    text-align: center;
    font-family: 'Playfair Display', serif;
    font-size: 2.5rem;
    margin-bottom: 2rem;
    color: var(--accent);
}

.menu-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 2rem;
}

.menu-item {
    background: white;
    padding: 1.5rem;
    border-radius: 10px;
    text-align: center;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
    border-top: 4px solid var(--primary);
}

.menu-item h3 {
    font-size: 1.5rem;
    margin-bottom: 0.5rem;
}

.menu-item p {
    color: var(--primary);
    font-weight: 500;
    font-size: 1.2rem;
}

footer {
    background: var(--dark);
    color: white;
    text-align: center;
    padding: 2rem 0;
    margin-top: 3rem;
}

@media (max-width: 768px) {
    .main-header h1 {
        font-size: 2.5rem;
    }
    
    .gallery {
        grid-template-columns: 1fr;
    }
}
EOF

echo "Setup complete! Run 'node app.js' to start the server."