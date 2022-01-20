<p align="center">
<img src="https://user-images.githubusercontent.com/31465/34380645-bd67f474-eb0b-11e7-8d03-0151c1730654.png" height="29" />
</p>

<p align="center">
  <i>An open, extensible, knowledge base for your team.<br/>Try out Outline using our hosted version at <a href="https://www.getoutline.com">www.getoutline.com</a>.</i>
</p>

<br/>

## Outline on-prem

Deploy Outline on-premises to manage all of your data within your own cloud environment. This repository contains all the necessary scripts to install and run the enterprise edition of Outline on-prem. Please refer to the [On Premise Guide](https://wiki.generaloutline.com/share/13dec265-c002-4c73-8025-75981f29b0d0) during installation.

## Simple reference deployment (15-20 min)

In this guide, we will walk through a simple, straightforward, setup on AWS EC2. Outline comes with images for a Postgres DB instance, as well a Minio for file storage. 

**For production deployments, we highly recommend you use something like RDS and S3 for these purposes.** This can be done during the initial install process or configured after setup is complete.

#### Spin up a new EC2 instance:
1. Choose **Launch Instance** from the EC2 dashboard.
1. Select Ubuntu. Outline should work on any modern version.
1. Select an instance type of `t2.small` or higher.
1. Set the network security groups for ports `22`, `80`, `443`, and `3000`. Set sources set to `0.0.0.0/0` and `::/0`, and click **Review and Launch**. <img width="1420" alt="sshscreen" src="https://user-images.githubusercontent.com/427579/110394638-9eb6fa80-8021-11eb-9b2e-c0574d185a45.png">
1. On the next screen, click **Launch** to start your instance.

#### Set up your DNS and other services:
1. Before proceeding, go to your DNS provider and provision a subdomain where you would like to locate your Outline instance. For example `wiki.mycompany.com`. Point this subdomain at the public IPv4 address of your EC2 instance. 
1. If you're planning on using a managed database and file storage (like RDS and S3), this would be a good time to provision those as well:
    1. Our [setup guide for S3](https://wiki.generaloutline.com/share/13dec265-c002-4c73-8025-75981f29b0d0/doc/aws-s3-N4M0T6Ypu7)
    1. Our [setup guide for RDS](https://wiki.generaloutline.com/share/13dec265-c002-4c73-8025-75981f29b0d0/doc/aws-rds-etUZYyP2jV)

#### Configure your EC2 instance and start Outline:
1. From your command line tool, SSH into your EC2 instance. You will need to clone this repository into your instance, so we recommend you use [SSH agent forwarding](https://docs.github.com/en/developers/overview/using-ssh-agent-forwarding)
1. Clone this repo on your instance: `git clone git@github.com:outline/outline-onprem.git`.
1. Go into the cloned repo directory: `cd outline-onprem`.
1. Run `./install.sh`. This will install **Docker** and **Docker Compose**, and initialize some configuration files to be edited later.
1. Follow the instruction prompts. You will be asked to provide your provisioned subdomain at the end of this process.
1. Run `sudo docker-compose pull` to download images.
1. Open the configuration file `docker.env` and add your **license key** as the value for the variable `LICENSE_KEY`. If you don't yet have a key because you're setting up a proof-of-concept or a trial, set the value to `trial`.
1. **If you are using your own database and/or file storage**, open `docker.env` and modify the Postgres and S3 related configuration values.
1. Run `./database-setup.sh` to initialize your database.
1. Now you're read to start your Outline server with: `sudo docker-compose up -d`.
1. Navigate to your server's address in a web browser. You will see a login screen with a placeholder Slack authentication method. 
1. To configure authentication for your org, open `docker.env` and add your keys there for the identity providers you will be using.

## Customizing your install

Configuration for your installation of Outline is located in `docker.env`. Here, you can set up authentication (SSO and SAML), database, and file storage.

If you are using your own database and file storage, you can optimize your install footprint by modifying `docker-compose.yml` and removing the dependencies on `postgres` and `minio`.

## Configuring SAML

Adding SAML to your outline install is a simple configuration change. Open `docker.env` and modify `SAML_SSO_ENDPOINT` and `SAML_CERT` to values provided by your IdP. 

For an example setup guide using One Login, see the article below:
- [One Login Setup](https://wiki.generaloutline.com/share/13dec265-c002-4c73-8025-75981f29b0d0/doc/onelogin-setup-hCmJIfmAjt)

---

## Updating your instance

When there is patch or an update available for Outline, you can apply the updates to your instance by stopping your server and running the included update script: `./update.sh`. We recommend backing up your database before updating.

## Docker reference

Below is a list of common Docker commands. Note that you may need to prefix with `sudo`, depending on your setup 

| Command                     | Description                                                                                                                     
| ----------------------------|-------------------------------------------------------------------------------------------------------------------------------| 
| `docker-compose up -d`      | Starts containers `-d` means "detached", so containers continue to run in the background.                                     | 
| `docker-compose down`       | Stops containers                                                                                                              |
| `docker-compose logs -f`    | Stream all container logs to stdout                                                                                           |
