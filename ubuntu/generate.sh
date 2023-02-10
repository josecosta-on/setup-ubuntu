#!/bin/bash

source ./variables.sh $1 $2

echo $VERSION

echo '#!/bin/bash' > releases/$VERSION-$PROFILE.sh
chmod +x releases/$VERSION-$PROFILE.sh
tail +2 resources/_essentials.sh >> releases/$VERSION-$PROFILE.sh

source ./profiles/$PROFILE.sh