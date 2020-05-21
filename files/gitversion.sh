#!/bin/bash

if ! [ -n "$GIT_VERSION" ]; then
	# We try to get the highest version of type: dd.d+.d+
	# Currently at 8.0.5
	GIT_VERSION=$(git tag | egrep "^[0-9]{1,2}\.[0-9]+\.[0-9]+$" | sort -V -r | head -1)
fi

echo "$GIT_VERSION" > .gitversion.txt

echo "GIT_VERSION: $GIT_VERSION"