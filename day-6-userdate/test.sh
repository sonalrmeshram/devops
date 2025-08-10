#!/bin/bash
sudo yum update -y
sudo yum install -y httpd

sudo systemctl start httpd
systemctl enable httpd

# Write HTML to index.html
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Nature Background Page</title>
  <style>
    body {
      margin: 0;
      padding: 0;
      background: url('https://images.unsplash.com/photo-1501785888041-af3ef285b470') no-repeat center center fixed;
      background-size: cover;
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      color: white;
      font-family: Arial, sans-serif;
      text-shadow: 1px 1px 4px rgba(0,0,0,0.7);
    }
    h1 {
      font-size: 3em;
    }
  </style>
</head>
<body>
  <h1>Hello from EC2!</h1>
</body>
</html>
EOF
