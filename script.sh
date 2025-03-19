#cloud-config
package_update: true
package_upgrade: true

runcmd:
  - echo "Configuring sudo without password..."
  - echo "cloud-user ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/cloud-user

  - echo "Installing Dependencies..."
  - sudo dnf install -y python3 python3-pip python3-virtualenv
  - sudo dnf module reset -y nodejs
  - sudo dnf module enable -y nodejs:20
  - sudo dnf install -y nodejs

  - echo "Creating Python Virtual Environment..."
  - sudo python3 -m venv /opt/flowise_env
  - source /opt/flowise_env/bin/activate

  - echo "Upgrading Pip and Installing LangChain..."
  - sudo pip install --upgrade pip
  - sudo pip install langchain

  - echo "Installing Flowise..."
  - sudo npm install -g flowise

  - echo "Starting Flowise in Background..."
  - nohup sudo npx flowise start --host 0.0.0.0 --port 3000 > /root/flowise.log 2>&1 &

  - echo "Installing NGINX..."
  - sudo dnf install -y nginx
  - sudo systemctl start nginx
  - sudo systemctl enable nginx

  - echo "Installation Completed Successfully!"
