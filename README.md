# giveandtake

Steps to build for your environment:

# Preparation

- Register a new domain (suggestion: [Freenom](https://freenom.com/) has free domains)
- Register a new account on AWS
  - On the AWS console, create a new user (IAM > Users > Add user)
    - On the "Set permissions" screen, mark the "AdministratorAccess" checkbox.
  - Go to the created user (IAM > Users > name of the user), go to "Security credentials" and click in
     "Create access key"
    - Click on "Show" and take note of the "Access key ID" and "Secret access key". This is the only
     oportunty you will have to see this information.
- Fork the [main Github repository](https://github.com/andrenho/giveandtake)
- Clone the repository

# Configuration

- Edit the file `variables.tf` and change the following keys:
  - `domain`: with the domain name you created
  - `jenkins_job_name`: the name you want to give the job on Jenkins (it can be anything)
  - `git_repo`: the name of the forked repository.

# Create DNS entry on AWS

- Run the following commands:

```sh
cd dns
terraform init
terraform apply -var "access_key=MY_ACCESS_KEY" -var "secret-key=MY_SECRET_KEY"
```

(replace `MY_ACCESS_KEY` and `MY_SECRET_KEY` with the key pair you got from AWS earlier)

- The "apply" command should output a list of nameservers.
- Go to where you registered your domain, and set the outputed nameservers there.

# Create Jenkins

- Run the following commands:

```sh
cd jenkins
./create_jenkins.sh MY_ACCESS_KEY MY_SECRET_KEY JENKINS_PASSWORD
```

(`JENKINS_PASSWORD` can be anything you want)

- Your Jenkins server is now ready. You can login on it on https://jenkins.my-domain.com:8080/ 
   (replace "mydomain.com" with your domain). Sometimes it can take up to 48 hours for the domain
   to take effect, so you can also log into Jenkins using the outputed address.
- On Jenkins, you have read-only access by default. Click on "Enter" in the top-right corner.
- Login with the user "admin" and the password you set earlier.
- Click on the only job, and then on "Scan Multibranch Pipeline Now". This will make Jenkins identify
   the branches on the Github repository, and build them.

# Access website

- After the build, the website should be available at https://www.my-domain.com/ .
