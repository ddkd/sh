#!/usr/bin/env bash
# todo: port to sh

unused=true
project=false
everything=false
show_help=false
quiet=false
force=""

while [[ $# -gt 0 ]]; do
key="$1"
case $key in
    -f|--force)
    force="-f "
    shift
    ;;
    -p|--project)
    project=true
    shift
    ;;
    --everything)
    everything=true
    shift
    ;;
    -q|--quiet)
    quiet=true
    shift
    ;;
    -h|--help|help)
    show_help=true
    shift
    ;;
    *)
    show_help=true
    echo "unsupported argument: $key"
    shift
    ;;
esac
done

if [ "$show_help" ]; then
    echo
    echo "Cleanup docker images/containers/volumes."
    echo "By default removes only dangling images and exited containers."
    echo
    echo "Usage:"
    echo "  -p|--project - remove project related images (node-ops-tools / sf-backend-node)"
    echo "  -f|--force   - pass -f flag to docker rm/rmi"
    echo "  -q|--quiet   - do not show stats when done"
    echo "  --everything - delete all images/containers"
    exit 0
fi

if [ "$unused" = true ]; then
    docker rm $force -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
    docker rmi $force $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
fi
if [ "$project" = true ]; then
    for name in "sf-backend" "node-ops-tools"; do
        docker rmi $force $(docker images *$name* -q 2>/dev/null) 2>/dev/null
        docker rmi $force $(docker images */$name* -q 2>/dev/null) 2>/dev/null
    done
fi
if [ "$everything" = true ]; then
    echo "This will delete all containers, images and volumes"
    read -p "Are you sure? (y/n)" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        docker rm $force $(docker ps -a -q)
        docker rmi $force $(docker images -q)
        docker volume rm $force $(docker volume ls -qf dangling=true)
    fi
fi
if [ "$quiet" == false ]; then
    docker images
    echo
    docker ps
fi