#!/bin/bash
yum update -y
yum install -y httpd

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Create HTML file
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Image Upload & Data Form</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f7f9;
      margin: 0;
      padding: 40px;
    }
    h1 {
      text-align: center;
      color: #333;
    }
    .container {
      max-width: 500px;
      margin: auto;
      background: #fff;
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    input[type="text"], input[type="email"], input[type="file"] {
      width: 100%;
      padding: 12px;
      margin: 8px 0 20px;
      border: 1px solid #ccc;
      border-radius: 4px;
    }
    button {
      width: 100%;
      background-color: #4CAF50;
      color: white;
      padding: 14px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }
    button:hover {
      background-color: #45a049;
    }
    label {
      font-weight: bold;
    }
  </style>
</head>
<body>
  <h1>Upload Image & Save User</h1>
  <div class="container">
    <form id="uploadForm" method="POST" enctype="multipart/form-data" action="/upload">
      <label for="name">Name:</label>
      <input type="text" id="name" name="name" required />

      <label for="email">Email:</label>
      <input type="email" id="email" name="email" required />

      <label for="image">Upload Image:</label>
      <input type="file" id="image" name="image" accept="image/*" required />

      <button type="submit">Submit</button>
    </form>
  </div>
</body>
</html>
EOF
