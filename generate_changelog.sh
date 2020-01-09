#!/bin/sh

printf "# ChangeLog\n\n"

for current_tag in $(git tag --sort=-creatordate) ; do
    tag_date=$(git log -1 --pretty=format:'%ad' --date=short ${current_tag})
	printf "## [${current_tag}](https://gitlab.haskell.org/haskell/ghcup/-/tags/0.0.8) (${tag_date})\n\n"
	git --no-pager tag -l --format='%(contents)' ${current_tag} | sed -e '/BEGIN PGP/,$d'
    printf "\n\n"
done

