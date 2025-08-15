#!/bin/bash -xe

# 1. Update system and install dependencies
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y curl gnupg2 software-properties-common openjdk-17-jdk lsb-release ca-certificates

# 2. Verify Java
java -version

# 3. Create Jenkins user and directories
sudo useradd -m -d /var/lib/jenkins -s /bin/bash jenkins || true
sudo mkdir -p /opt/jenkins
sudo chown -R jenkins:jenkins /opt/jenkins /var/lib/jenkins

# 4. Download latest stable Jenkins WAR
sudo -u jenkins curl -L -o /opt/jenkins/jenkins.war https://get.jenkins.io/war-stable/latest/jenkins.war

# 5. Create systemd service for Jenkins
sudo tee /etc/systemd/system/jenkins.service > /dev/null <<EOF
[Unit]
Description=Jenkins CI
After=network.target

[Service]
Type=simple
User=jenkins
Group=jenkins
Environment="JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64"
Environment="JENKINS_HOME=/var/lib/jenkins"
ExecStart=/usr/bin/java -jar /opt/jenkins/jenkins.war --httpListenAddress=0.0.0.0 --httpPort=8080
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# 6. Reload systemd and start Jenkins
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins
sleep 10
sudo systemctl status jenkins -l

# 7. Install Git
sudo apt-get install -y git

# 8. Install Terraform (using new signed-by method)
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update -y
sudo apt-get install -y terraform

# 9. Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl

echo "Setup complete! Jenkins on port 8080, Git, Terraform, kubectl installed."
