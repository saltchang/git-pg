#!/bin/bash

git_pg_echo() {
    echo -e "$*" 2>/dev/null
}

git_pg_try_user_profile() {
    if [ -z "${1-}" ] || [ ! -f "${1}" ]; then
        return 1
    fi
    git_pg_echo "${1}"
}

git_pg_detect_user_profile() {
    if [ -n "${PROFILE}" ] && [ -f "${PROFILE}" ]; then
        git_pg_echo "${PROFILE}"
        return
    fi

    local DETECTED
    DETECTED=''

    if [ "${SHELL#*bash}" != "$SHELL" ]; then
        if [ -f "$HOME/.bash_profile" ]; then
            DETECTED="$HOME/.bash_profile"
        elif [ -f "$HOME/.bashrc" ]; then
            DETECTED="$HOME/.bashrc"
        fi
    elif [ "${SHELL#*zsh}" != "$SHELL" ]; then
        if [ -f "$HOME/.zshrc" ]; then
            DETECTED="$HOME/.zshrc"
        fi
    fi

    if [ -z "$DETECTED" ]; then
        for EACH_PROFILE in ".profile" ".bashrc" ".bash_profile" ".zshrc"; do
            if DETECTED="$(git_pg_try_user_profile "${HOME}/${EACH_PROFILE}")"; then
                break
            fi
        done
    fi

    if [ -n "$DETECTED" ]; then
        git_pg_echo "$DETECTED"
    fi
}

install() {
    # Text colors
    LIGHT_GREEN="\033[1;32m"
    LIGHT_CYAN="\033[1;36m"
    # PURPLE="\033[0;35m"
    ORANGE="\033[0;33m"
    NORMAL="\033[0m"

    local USER_BIN_DIR
    USER_BIN_DIR="$HOME/bin"

    git_pg_echo

    if [ ! -d "$USER_BIN_DIR" ]; then
        git_pg_echo "${LIGHT_GREEN}> Creating directory: \`${USER_BIN_DIR}/\` ...${NORMAL}"
        mkdir -v -p "$USER_BIN_DIR"
        git_pg_echo
    fi

    git_pg_echo "${LIGHT_GREEN}> Copy file \`./git-pg\` to \`${USER_BIN_DIR}/\`...${NORMAL}"
    cp -v ./git-pg "$USER_BIN_DIR"

    git_pg_echo

    local GIT_PG_USER_PROFILE
    GIT_PG_USER_PROFILE="$(git_pg_detect_user_profile)"

    # Add git-pg into PATH
    local GIT_PG_SOURCE_PATH

    # shellcheck disable=SC2016
    GIT_PG_SOURCE_PATH='export PATH=$PATH:$HOME/bin'

    if [ -z "${GIT_PG_USER_PROFILE-}" ]; then
        git_pg_echo "${ORANGE}User profile not found.${NORMAL}"
        git_pg_echo "${ORANGE}Please add the following lines to your profile manually:${NORMAL}"
        git_pg_echo "\n${ORANGE}${GIT_PG_SOURCE_PATH}${NORMAL}"
        git_pg_echo
    else
        # shellcheck disable=SC2016
        if ! command grep -qc '$HOME/bin' "$GIT_PG_USER_PROFILE"; then
            git_pg_echo "${LIGHT_GREEN}> Adding git-pg to your PATH...${NORMAL}"
            git_pg_echo "${GIT_PG_SOURCE_PATH}\n" >>"$GIT_PG_USER_PROFILE"
        else
            git_pg_echo "${LIGHT_GREEN}> git-pg has already added in your \$PATH.${NORMAL}"
        fi
    fi

    local GIT_PG_ALIAS_STR
    GIT_PG_ALIAS_STR="!f() { $USER_BIN_DIR/git-pg; } f;"

    git config --global alias.pg "${GIT_PG_ALIAS_STR}"

    git_pg_echo

    git_pg_echo "${LIGHT_GREEN}> Set \`pg\` as an git alias for \`git-pg\`.${NORMAL}"

    git_pg_echo

    git_pg_echo "If the ${LIGHT_CYAN}\`git-pg\`${NORMAL} command is not found, please try adding the following line to your shell profile:"
    git_pg_echo
    git_pg_echo "\t${ORANGE}${GIT_PG_SOURCE_PATH}${NORMAL}"
    git_pg_echo

    git_pg_echo "If you can't use ${LIGHT_CYAN}\`git pg\`${NORMAL} as the alias to ${LIGHT_CYAN}\`git-pg\`${NORMAL}, please check if the following line is in your ${ORANGE}\`\$HOME/.gitconfig\`${NORMAL}:"
    git_pg_echo
    git_pg_echo "\t${ORANGE}[alias]
\t    pg = ${GIT_PG_ALIAS_STR}${NORMAL}"
    git_pg_echo

    git_pg_echo "┌─────────────────────────────────────────────────────────────────┐"
    git_pg_echo "│                                                                 │"
    git_pg_echo "│                    ${LIGHT_CYAN}git-pg ${LIGHT_GREEN}installed sucessfully!${NORMAL}                │"
    git_pg_echo "│                                                                 │"
    git_pg_echo "│          Please run ${LIGHT_CYAN}\`git pg --usage\`${NORMAL} to see the usage.          │"
    git_pg_echo "│                                                                 │"
    git_pg_echo "└─────────────────────────────────────────────────────────────────┘"
    git_pg_echo
}

install
