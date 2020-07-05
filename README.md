# Exm Example

This solution demonstrates how to configure EXM for Custom SMTP.  It also shows how to create custom modules for EXM and creating customized templates for sending personalized e-mails for your organization.

## Setup

This solution uses the Sitecore Docker images to run.  Follow the steps below to get setup and working with this demo.

1) Setup Sitecore Docker Images, for the version of Sitecore you want to use.  This solution supports 9.2 and 9.3.
2) Spin up the Docker images: (Run in the root of the solution)

``` (UP)
c:\Development\Exm-Example> docker-compose --file "docker-compose.xp.yml" up -d
```

> To Change the version, open the `.env` file and change the version you wish to use.

3. Publish all the projects of the Solution (Currently there isn't an automated way, you'll need to go to each project in the solution and publish the `Debug` Publishing Profile)

4. Go to your `CM` instance, by going to http://localhost:44001/sitecore.  Refer to the docker-compose file to confirm the path.

5. Login to Sitecore and then go to http://localhost:44001/unicorn.aspx and `Sync all the things`.

6. You should be all set!

7. If you are done with your examples, be sure remove the docker images:

``` (DOWN)
c:\Development\Exm-Example> docker-compose --file "docker-compose.xp.yml" down
```

Refer to my Docker cheatsheet if you have any troubles with docker commands.


## Future Enhancements

- Need to automate first time solution setup.


## Configuration Changes

- Access the `ExmExample.Foundation.Email` module and update the `Foundation.Email.CustomSmtp.config` to use the SMTP information for your e-mail relay.  This solution depends on a Custom SMTP server, and doesn't use EmailCloud.  I will enhance in the future to add configuration options for `EmailCloud`, although it's recommended not to use this locally.