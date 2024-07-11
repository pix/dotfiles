function __can_run_with_compose() {
  # Look for a service using the image $1 inside docker-compose.yml
  image_name=''
  if [ -f "docker-compose.yml" ];
  then
    image_name=$(grep -B1 -A0 "image: $1" docker-compose.yml | head -n1 | awk -F ":" '{print $1}' | tr -d '[:space:]')
  fi
}

# doc:function:drun:docker:Run a container with docker.\n    $ drun "php" "latest" "php" "-v"
function drun() {
  docker run --rm -it -u $UID -v $PWD:/sandbox -v $HOME:$HOME -e HOME=$HOME -w /sandbox --entrypoint=$3 $1:$2 ${@:4}
}

# doc:function:dcrun:docker:Run a container (with docker-compose support)\n    $ dcrun "php" "latest" "php" "-v"
function dcrun() {
  docker-compose run --rm --entrypoint=$1 ${@:2}
}

# doc:function:docker-run:docker:Run a container with docker or docker-compose.\n    function docker-php() { docker-run "php" "latest" "php" "$@"; }
function docker-run() {
  __can_run_with_compose $1

  if [[ ! -z "${image_name// }" ]];
  then
    dcrun $3 $image_name ${@:4}
  else
    drun $1 $2 $3 ${@:4}
  fi
}

# doc:function:docker-print:docker:Print docker containers, images, volumes and networks.
function docker-print() {
  # Check if the argument "full" is passed
  if [[ "$1" == "full" ]]; then
    {
      printf "🟡CONTAINERS\n"
      docker container ls --all --size --no-trunc
      printf "\n🟡IMAGES\n"
      docker images --all --digests --no-trunc
      printf "\n🟡VOLUMES\n"
      docker volume ls
      printf "\n🟡NETWORKS\n"
      docker network ls --no-trunc
    } | less -S
  else
    {
      printf "🟡CONTAINERS\n"
      docker container ls --all --size
      printf "\n🟡IMAGES\n"
      docker images --all --digests
      printf "\n🟡VOLUMES\n"
      docker volume ls
      printf "\n🟡NETWORKS\n"
      docker network ls --no-trunc
    } | less -S
  fi
}