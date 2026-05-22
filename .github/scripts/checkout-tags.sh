#!/bin/bash

mkdir -p HEAD
mv ./specifications/schemas .
mv * HEAD

git fetch --all --tags
tags_string=$(git tag)
echo got tag string
echo $tags_string
tags_array=($tags_string)

for tag in "${tags_array[@]}"
do
  echo starting with tag $tag
  mkdir $tag
  cd $tag
  git clone $GITHUB_SERVER_URL/$GITHUB_REPOSITORY.git --depth 1 --branch ${tag} --quiet
  pwd
  mv ./dataplane-signaling/* .
  mv ./specifications/schemas .
  rm -rf dataplane-signaling
  cd ..
done

pwd