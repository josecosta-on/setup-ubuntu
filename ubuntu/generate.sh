#!/bin/bash

rm -f ./releases/lib.zip; zip -FSrqq ./releases/lib.zip ./lib

source ./variables.sh $1 $2

echo $VERSION
echo '#!/bin/bash' > releases/$VERSION-$PROFILE.sh
chmod +x releases/$VERSION-$PROFILE.sh

tail +3 variables.sh >> releases/$VERSION-$PROFILE.sh
tail +3 lib.sh >> releases/$VERSION-$PROFILE.sh
tail +3 resources/_essentials.sh >> releases/$VERSION-$PROFILE.sh



source ./profiles/$PROFILE.sh

mkdir -p ./dist
cp -f ./releases/$VERSION-$PROFILE.sh ./dist/$VERSION-$PROFILE.sh
cp -f ./releases/lib.zip ./dist/lib.zip