# README

This project uses GitHub as a source of data and requires a token with read access. Follow these steps to set up the project:

## Generate a token with read access on GitHub
1. Go to your GitHub settings page by clicking on your profile picture in the top right corner of the page and selecting Settings.
2. In the left sidebar, click on Developer settings.
3. In the top menu, click on Personal access tokens.
4. Click on Generate new token (Personal Access Token).
5. In the Note field, enter a descriptive name for the token, such as "Project token".
6. Check the box under the `project` -> `read:project` scope and also check the box next to `repo` and next to `workflow`.
7. Click on Generate token.
8. Copy the generated token, you will need it in the next step.

## Configure the .env file
1. Populate ".env" file replacing the placeholder <username> and <token> with the information gathered at previous steps
2. Save and close the file.

## Run the Docker file
1. Open a terminal window in the root of the project directory.
2. Run the following command to build the Docker image and start the container:

`docker compose -f "docker-compose-prov.yml" up -d --build`

3. Wait for the container to start up.

The project should now be running and using the data from GitHub.

>Note: Make sure you have Docker installed in your machine before running the command `docker-compose up`