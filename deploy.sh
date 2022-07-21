# install git

sudo apt install git-all -y

# install docker

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

sudo service docker start

# clone environment

mkdir exercism

cd exercism

git clone https://github.com/universidad-austral-prog2/development-environment.git
git clone https://github.com/universidad-austral-prog2/website

cd development-environment

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

unzip awscliv2.zip

sudo ./aws/install

sudo docker compose pull

sudo docker tag exercism/python-test-runner  exercism/prog2-test-runner

sudo aws --endpoint-url=http://localhost:3040 --no-sign-request s3 mb s3://exercism-v3-submissions

sudo docker compose up -d

