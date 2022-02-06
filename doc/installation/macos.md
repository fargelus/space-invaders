1. Gosu depends on the SDL 2 library. Install Homebrew and run:
    ```sh
    brew install sdl2
    ```
    And then install gosu via gem:
    ```sh
    gem install gosu
    ```
    Some useful info you can find here <https://github.com/gosu/gosu/wiki/Getting-Started-on-OS-X>.   
2. Install required gems:
    ```sh
    bundle install
    ```
3. Install MongoDB. Installation instructions: <https://docs.mongodb.com/manual/tutorial/install-mongodb-on-os-x/><br>
   After success installation you need to run MongoDB as macOS service and check that its running:
   ```sh
   brew services start mongodb-community@5.0
   brew services list
   ```

4. Copy .env.sample to .env file and specify your mongodb settings if it need.

    ```sh
    cp .env.sample .env
    ```