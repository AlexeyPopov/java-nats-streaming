#!/bin/sh

echo "executing deploy.sh"
echo "decrypting keyrings"
openssl aes-256-cbc -K $encrypted_ddc2c9dfa8f8_key -iv $encrypted_ddc2c9dfa8f8_iv -in $GPG_DIR/deploy_key.pem.enc -out $GPG_DIR/deploy_key.pem -d
openssl aes-256-cbc -K $encrypted_ddc2c9dfa8f8_key -iv $encrypted_ddc2c9dfa8f8_iv -in $GPG_DIR/pubring.gpg.enc -out $GPG_DIR/pubring.gpg -d
openssl aes-256-cbc -K $encrypted_ddc2c9dfa8f8_key -iv $encrypted_ddc2c9dfa8f8_iv -in $GPG_DIR/secring.gpg.enc -out $GPG_DIR/secring.gpg -d

#openssl aes-256-cbc -pass pass:$ENCRYPTION_PASSWORD -in $GPG_DIR/pubring.gpg.enc -out $GPG_DIR/pubring.gpg -d
#openssl aes-256-cbc -pass pass:$ENCRYPTION_PASSWORD -in $GPG_DIR/secring.gpg.enc -out $GPG_DIR/secring.gpg -d

if [ ! -z "$TRAVIS_TAG" ]
then
    echo "on a tag -> set pom.xml <version> to $TRAVIS_TAG"
    mvn --settings .travis/settings.xml versions:set -DnewVersion=$TRAVIS_TAG 1>/dev/null 2>/dev/null
else
    echo "not on a tag -> keep snapshot version in pom.xml"
fi

mvn --settings .travis/settings.xml -B -U -Dmaven.test.skip=true clean package deploy:deploy

${TRAVIS_BUILD_DIR}/.travis/publish-javadoc.sh
