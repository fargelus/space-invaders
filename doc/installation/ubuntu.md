1. Install dependencies for using Gosu lib

    ```sh
    sudo apt-get install -y build-essential libsdl2-dev libgl1-mesa-dev \
                            libopenal-dev libgmp-dev libfontconfig1-dev \
                            libmpg123-dev libsndfile1-dev
    ```

   __WARNING__: This commands will works only on Debian
   based distros (Ubuntu, Mint, elementary OS...).<br>
   For other Linux distros you must find following packages
   by your own. For additional help check this guide <https://github.com/gosu/gosu/wiki/Getting-Started-on-Linux>.

2. Install required gems:

    ```sh
    bundle install
    ```

3. Install MongoDB. Installation instructions: <https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/><br>
   After success installation add mongod.service to init startup loading system and check
   that mongo is starting. Commands for systemd based systems:

    ```sh
    sudo systemctl enable --now mongod
    sudo systemctl status mongod
    ```

4. Copy .env.sample to .env file and specify your mongodb settings if it need.

    ```sh
    cp .env.sample .env
    ```