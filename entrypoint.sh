#!/usr/bin/env sh

create() {
    bin/create
}

migrate() {
    bin/migrate
}

rollback() {
    bin/rollback Repo "$1"
}

deploy () {
    set -e
    create
    migrate
    echo ========= Starting server ==========
    exec bin/server
}

case $1 in
    deploy) "$@"; exit;;
    create) "$@"; exit;;
    migrate) "$@"; exit;;
    rollback) "$@"; exit;;
esac

