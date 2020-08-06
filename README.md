# Ignium Sitecore Demo Solution

This solution demonstrates how to configure EXM for Custom SMTP.  It also shows how to create custom modules for EXM and creating customized templates for sending personalized e-mails for your organization.

## Initial Setup

This solution uses the Sitecore Docker images to run.  Follow the steps below to get setup and working with this demo.

1) This repository uses Sitecore Docker images hosted in our Azure Container Register
2) Ensure that you are running Windows Docker in Windows Container mode
3) Ensure you have a license of Sitecore located at `C:\license\license.xml`

   - You can change the path if needed in the `.env`, just make sure you do not commit your changes.

4) Login to ACR using the following command:

    ```
    docker login igniumdigital.azurecr.io --username "9505e2b1-0755-4a53-9f18-4d6901ca864d" --password "c812c932-1805-4d2b-934b-2ffb2abec406"
    ```
    (Do not share this repository or service principal)

3) If this is your first time running the steps, skip this step.  Run ./CleanData.ps1
 
4) Spin up the Docker Images based on the configurations defined below:

   - [9.2.0 SXA](/documentation/9.2.x/sxa.md)
   - [9.2.0 JSS](/documentation/9.2.x/jss.md)
   - [9.3.0 XC](/documentation/9.3.x/xc.md)

5. Publish all the projects of the Solution (Currently there isn't an automated way, you'll need to go to each project in the solution and publish the `Debug` Publishing Profile)

6. Go to your `CM` instance, by going to http://localhost:44001/sitecore.  Refer to the docker-compose file to confirm the path.

7. Login to Sitecore and then go to http://localhost:44001/unicorn.aspx and `Sync all the things`.

8. You should be all set!

9. If you are done with your examples, be sure remove the docker images:

    ``` (DOWN)
    c:\Development\Exm-Example> docker-compose --file "docker-compose.xp.yml" down
    ```

    Refer to my Docker cheatsheet if you have any troubles with docker commands.


## Using Different Configuration

If you are hoping to run a different docker compose after already running one, or you want a fresh install, please run the following powershell script:

1) .\CleanData.ps1

