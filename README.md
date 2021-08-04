# LICCiA Apps and System Deployment Recipes 

Open Repository with free recipes easily implemented for a first run-once system installation and deployment on a Linux OS with a preconfigured services and softwares.

## Steps

- Clone this repo
- Use the tool `gitlab_curl.sh` to fetch [LICCiA Scripts](https://gitlab.univ-nantes.fr/liccia/setup-env/-/tree/main/bin) (Need authentication)
  ```
  FILE=
  bash ./gitlab_curl.sh $LICCIA_GITLAB_TOKEN bin%2F${FILE} | sh -
  ```
