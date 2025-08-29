#!/bin/bash
exec > /var/log/user_data.log 2>&1
set -x

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
  <title>Cricket Experience</title>
  <style>
    html, body {
      margin: 0;
      padding: 0;
      height: 100%;
      width: 100%;
      font-family: Arial, sans-serif;
      background: url('https://assets.gqindia.com/photos/65799eb51147c91e95b7ff01/16:9/w_2560%2Cc_limit/most-searched-cricketer-of-2023_001.jpg') no-repeat center center fixed;
      background-size: cover;
      display: flex;
      justify-content: center;
      align-items: center;
      flex-direction: column;
      color: white;
      text-align: center;
    }

    h1 {
      font-size: 2.5em;
      text-shadow: 2px 2px 8px #000;
      margin-bottom: 30px;
    }

    .action-button {
      width: 200px;
      padding: 12px;
      margin: 10px;
      font-size: 1em;
      font-weight: bold;
      background-color: #0047ab;
      color: white;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      transition: background-color 0.3s ease;
    }

    .action-button:hover {
      background-color: #003380;
    }
  </style>
</head>
<body>
  <h1>🏏 Welcome to the Cricket Experience</h1>
  <button class="action-button">Login</button>
  <button class="action-button">Create Account</button>
</body>
</html>
EOF
