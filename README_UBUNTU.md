# A Super Easy Tutorial for Installing Amplification on Ubuntu 24.04 LTS

Requirements (as of July 11, 2024):
* Node.js 18.12.1
* npm 9.0.0
* Docker
* Docker Compose 2+
* GitHub Account (optional, for contributing)

### Setup 1 - Installing Node.js 18.12.1

We'll use Node Version Manager (NVM) to manage future upgrades seamlessly, even if you already have an older or newer version of Node.js installed.

1. **Install NVM (if not already installed):**
   ```sh
   wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
   ```

2. **Source the NVM script (if not already sourced):**
   ```sh
   export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
   [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
   ```

3. **Install Node.js 18.12.1:**
   ```sh
   nvm install v18.12.1
   ```

4. **Verify the Node.js version:**
   ```sh
   node -v
   ```

### Setup 2 - Installing npm 9.0.0

```sh
npm install -g npm@9.0.0
```

### Setup 3 - Install Docker (from docker.com)

1. **Remove previous Docker Ubuntu packages:**
   ```sh
   sudo apt-get remove docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc
   ```

2. **Configure Docker APT Repository (from official Docker site):**
   ```sh
   # Add Docker's official GPG key:
   sudo apt-get update
   sudo apt-get install ca-certificates curl
   sudo install -m 0755 -d /etc/apt/keyrings
   sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
   sudo chmod a+r /etc/apt/keyrings/docker.asc

   # Add the repository to Apt sources:
   echo \
     "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
     $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
     sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   sudo apt-get update
   ```

3. **Install Docker:**
   ```sh
   sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

   # Verify the Docker version
   docker -v
   ```

### Setup 4 - Install Docker Compose (v27)

1. **Download Docker Compose:**
   ```sh
   # Download version 2.27.2
   wget https://github.com/docker/compose/releases/download/v2.27.2/docker-compose-linux-x86_64
   ```

2. **Move it to the user's bin path:**
   ```sh
   sudo mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose
   ```

3. **Make it executable:**
   ```sh
   sudo chmod +x /usr/local/bin/docker-compose

   # Verify the Docker Compose version
   docker-compose -v
   ```

### Setup 5 - Forking Amplification

1. **For contributing to Amplification (fixing issues, etc.):**
   - Go to [invalid URL removed].
   - Click the "Fork" button.
   - Clone your forked repository using `git clone https://github.com/yourGitUserNameHere/amplification/tree/master` (replace `yourGitUserNameHere` with your username).

2. **For self-hosting:**
   - Go to [https://github.com/amplication/amplication](https://github.com/amplication/amplication)
   - Clone the repository:
     ```sh
     git clone https://github.com/amplication/amplication
     ```

### Setup 6 - Connect GitHub App...

This step is crucial. Follow the instructions here: [Connect Server to GitHub](https://docs.amplication.com/running-amplication-platform/connect-server-to-github/) AND AFTER THIS:

```sh
# Find the correct path for your file and edit it
nano .../amplication/packages/amplication-client/.env
# Modify the variable inside the file from
# NX_REACT_APP_GITHUB_AUTH_ENABLED="true"
# to
NX_REACT_APP_GITHUB_AUTH_ENABLED="false"
NX_REACT_APP_BILLING_ENABLED="false"
```

### Setup 7 - Amplification Installation

For the original step-by-step guide, visit [Amplication GitHub Repository](https://github.com/amplication/amplication). Ensure you have completed the necessary configurations.

```sh
# Navigate to your Amplification directory and run:
npm install
npm run setup:dev

# Before running docker:dev, ensure permissions are set correctly:
sudo chmod 666 /var/run/docker.sock
sudo setfacl --modify user:<user name or ID>:rw /var/run/docker.sock

npm run docker:dev
npm run db:migrate:deploy
```

**Starting Amplification**

You might encounter the following error when running `npm run serve:server`: 
> Watchpack Error (watcher): Error: ENOSPC: System limit for number of file watchers reached

[Solution](https://stackoverflow.com/questions/55763428/react-native-error-enospc-system-limit-for-number-of-file-watchers-reached):
```sh
# Set a new value for the system config
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

# Verify the new value
cat /proc/sys/fs/inotify/max_user_watches

# Config variable name (not runnable)
fs.inotify.max_user_watches=524288
```

Finally...
```sh
npm run serve:server
npm run serve:client
npm run serve:dsg
npm run serve:git
npm run serve:plugins
```

### Setup 8 - Sing Up

1. Make a account and get a error about Git Hub ID
2. Try Login with account and get error
3. 
```sql
UPDATE public."Account"
set "currentUserId" = sub."id"
FROM (SELECT "id", "accountId" FROM public."User")  as sub
where sub."accountId" = "accountId";


INSERT INTO public."Subscription"
SELECT 
	'clyj6bycn00019s1j46f1x722', '2024-07-12T22:09:50', '2024-07-12T22:09:50'
	, ws."id", 'Pro','Active', '2600-07-12T22:09:50+0000'	
from public."Workspace" ws;


INSERT INTO public."UserRole"
SELECT 
	'clyj6bycn00019s1j46f1x722',
	'2024-07-12T22:09:50', 
	'2024-07-12T22:09:50'
	, uu."id"
	, 'Admin'
from public."User" uu;
```

### Contributing

After completing the final commands, you can open VSCode, navigate to the Amplification directory, click the run button, and then press attach to debug the code.