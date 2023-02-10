EXPORTED=$(awk -F= '/^export PATH/{print $1}' ~/.bashrc)
echo "::$EXPORTED::"
if ! [ "$EXPORTED" == "export PATH" ]; then
    echo path not added
    echo 'export PATH=${PATH}:${HOME}/.bin' >> ~/.bashrc
    ln -s ~/setup-ubuntu/resources/bin/files ~/.bin
fi

sudo cp -rf ~/setup-ubuntu/resources/bin/share/** /usr/bin
source ~/.bashrc