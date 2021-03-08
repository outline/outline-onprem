<p align="center">
<img src="https://user-images.githubusercontent.com/31465/34380645-bd67f474-eb0b-11e7-8d03-0151c1730654.png" height="29" />
</p>

<p align="center">
  <i>An open, extensible, wiki for your team built using React and Node.js.<br/>Try out Outline using our hosted version at <a href="https://www.getoutline.com">www.getoutline.com</a>.</i>
</p>

<br/>

# Deploying Outline on-prem

Deploy Outline on-premises to manage all of your data within your own cloud environment. You can configure many aspects of how Outline is setup within your infrastructure.

---

## Simple reference deployment

In this guide, we will walk through a simple, straightforward, setup on AWS EC2. Outline comes with images for a Postgres DB instance, as well a Minio for file storage. For production deployments, we recommend you use something like RDS and S3 for these purposes.

Spin up a new EC2 instance:
1. Choose **Launch Instance** from the EC2 dashboard.
1. Select Ubuntu. Outline should work on any modern version.
1. Select an instance type of `t2.small` or higher. 
1. If you plan on connecting to an instance of RDS or S3 to manage Outline's data, select the VPC to match where you have those resources provisioned.
1. Set the network security groups for ports `22`, `80`, `443`, and `3000`. Set sources set to `0.0.0.0/0` and `::/0`, and click **Review and Launch**.
1. On the next screen, click **Launch** to start your instance.
1. Before proceeding, go to your DNS provider and provision a subdomain where you would like to locate your Outline instance. For example `wiki.mycompany.com`. Point this subdomain at the public IPv4 address of your EC2 instance. 
1. From your command line tool, SSH into your EC2 instance. You will need to clone this repository into your instance, so we recommend you use [SSH agent forwarding](https://docs.github.com/en/developers/overview/using-ssh-agent-forwarding)
1. Clone this repo on your instance: `git clone git@github.com:outline/outline-onprem.git`.
1. Go into the cloned repo directory: `cd outline-onprem`.
1. Run `./install.sh`. This will install Docker and Docker-Compose, and initiate some configuration files.
1. Follow the instruction prompts. You will be asked to provide your provisioned subdomain at the end of this process.
1. Run `sudo docker-compose pull` to download images.
1. **If you are using your own database and/or file storage**, open `docker.env` and modify the Postgres and S3 related configuration values.
1. Run `./database-setup.sh` to initialize your database.
1. Now you're read to start your Outline server with: `sudo docker-compose up -d`.
1. Navigate to your server's address in a web browser. You will see a login screen with a placeholder Slack authentication method. 
1. To configure authentication for your org, open `docker.env` and add your keys there for the identity providers you will be using.
