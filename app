#!/bin/bash
dir=$(dirname $0)

if [[ "$dir" == "." ]];
then
      dir=$(pwd)
      #echo "1 - $dir"
fi

check_images(){
  ID=$(docker images postgres:14.4-alpine --format "{{.ID}}")
  if [[ "$ID" == "" ]];
    then
        docker pull postgres:14.4-alpine
        echo "Download Image postgres:14.4-alpine Successfully"
  else
        echo "Image Exist"
  fi

}

check_red_devopsnx(){
    name=$(docker network ls --format "{{.Name}}" | grep -e "devopsnx$")
    if [[ "$name" == "" ]];
      then
          docker network create devopsnx
          echo "Network Created Successfully"
    else
          echo "Network devopsnx exist!!"
    fi
}

logs(){
	docker logs -f $CONT
}


start(){
    check_images
    check_red_devopsnx
    docker compose -f devel.yml up -d
}

stop(){
    docker compose -f devel.yml down
}

restart(){
    stop
    start
}



help() {

  APP=$(basename "$0")
  echo
  echo "Help: $APP <help|start|stop|restart|logs>"
  echo
  echo "       $APP help                         Show the current use of the script"
  echo "       $APP start                        Start containers of psql"
  echo "       $APP stop                         Delete containers of psql"
  echo "       $APP restart                      Restart containers of psql"
  echo "       $APP logs name_container          Check logs from caontainer"          
  echo
  exit 0
}

# Get action and validate
CMD="$1"
CONT="$2"
echo "$CMD" | grep -Eq '^(help|start|stop|restart|logs)$' || help


# Execute command
"$@"
