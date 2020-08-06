# Ignium Sitecore Demo Solution

This solution demonstrates how to configure EXM for Custom SMTP.  It also shows how to create custom modules for EXM and creating customized templates for sending personalized e-mails for your organization.

## Initial Setup

This solution uses the Sitecore Docker images to run.  Follow the steps below to get setup and working with this demo.

1) This repository uses Sitecore Docker images hosted in our Azure Container Register
2) Login to ACR using the following command:

```
docker login igniumdigital.azurecr.io --username "9505e2b1-0755-4a53-9f18-4d6901ca864d" --password "c812c932-1805-4d2b-934b-2ffb2abec406"
```
(Do not share this repository or service principal)

3) Review contents of `.env` locally and ensure paths etc are correct.  Currently this solution has been tested for:

    * 9.2.0 SXA
    * 9.2.0 SXA JSS
    * 9.3.0 XC (Make sure you update `.env` with 9.3.0 before trying to run this configuration)
  
4) Spin up the Docker images: (Run in the root of the solution)

``` (UP)
c:\Development\Exm-Example> docker-compose --file "docker-compose.xp.yml" up -d
```

5. Publish all the projects of the Solution (Currently there isn't an automated way, you'll need to go to each project in the solution and publish the `Debug` Publishing Profile)

2. Go to your `CM` instance, by going to http://localhost:44001/sitecore.  Refer to the docker-compose file to confirm the path.

3. Login to Sitecore and then go to http://localhost:44001/unicorn.aspx and `Sync all the things`.

4. You should be all set!

5. If you are done with your examples, be sure remove the docker images:

``` (DOWN)
c:\Development\Exm-Example> docker-compose --file "docker-compose.xp.yml" down
```

Refer to my Docker cheatsheet if you have any troubles with docker commands.

## Using Different Configuration

If you are hoping to run a different docker compose after already running one, or you want a fresh install, please follow the following steps:

1) .\CleanData.ps1

## Future Enhancements

- Need to automate first time solution setup.


## Configuration Changes

- Access the `ExmExample.Foundation.Email` module and update the `Foundation.Email.CustomSmtp.config` to use the SMTP information for your e-mail relay.  This solution depends on a Custom SMTP server, and doesn't use EmailCloud.  I will enhance in the future to add configuration options for `EmailCloud`, although it's recommended not to use this locally.