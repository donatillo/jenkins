# giveandtake

Steps to build for your environment:

# Preparation

Create a domain:

- Register a new domain (suggestion: [Freenom](https://freenom.com/) has free domains)

Create an AWS account

- Register a new account on AWS
  - On the AWS console, create a new user (IAM > Users > Add user)
    - On the "Set permissions" screen, mark the "AdministratorAccess" checkbox.
  - Go to the created user (IAM > Users > name of the user), go to "Security credentials" and click in
     "Create access key"
    - Click on "Show" and take note of the "Access key ID" and "Secret access key". This is the only
     oportunty you will have to see this information.

Create Github repositories:
 
- Create two new Github repositories, one for frontend and the other for backend
- Optional step to have Github commits to trigger builds on github:
  - In each repository, create a webook that points to `http://jenkins.mydomain.com:8080/git/notifyCommit?url=REPOSITORY_URL` (replace "mydomain.com" with your domain and `REPOSITORY_URL` with the repostiory URL that ends with `.git`)

# Configuration

- Edit the file `terraform/variables.tf` and change the following keys:
  - `domain`: with the domain name you created
  - `git_repo_frontend` and `git_repo_frontend`: the name of the forked repository.

# Create bucket for the backend in S3

- Run the following commands:

```sh
cd backend
terraform init
terraform apply -var "access_key=MY_ACCESS_KEY" -var "secret-key=MY_SECRET_KEY"
```

(replace `MY_ACCESS_KEY` and `MY_SECRET_KEY` with the key pair you got from AWS earlier)

# Create Jenkins

- Run the following commands:

```sh
cd terraform
terraform init
terraform apply -var "access_key=MY_ACCESS_KEY" -var "secret-key=MY_SECRET_KEY" -var "jenkins_password=JENKINS_PASSWORD"
```

(`JENKINS_PASSWORD` can be anything you want)

Configure DNS:

- The "apply" command should output a list of nameservers.
- Go to where you registered your domain (for example Freenom), and set the outputed nameservers there.

Configure Jenkins:

- Your Jenkins server is now ready. You can login on it on https://jenkins.my-domain.com:8080/ 
   (replace "mydomain.com" with your domain). Sometimes it can take up to 48 hours for the domain
   to take effect, so you can also log into Jenkins using the outputed address.
- On Jenkins, you have read-only access by default. Click on "Enter" in the top-right corner.
- Login with the user "admin" and the password you set earlier.
- Click on the only job, and then on "Scan Multibranch Pipeline Now". This will make Jenkins identify
   the branches on the Github repository, and build them.

# Access website

- After the build, the website should be available at https://www.my-domain.com/ .
