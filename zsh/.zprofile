# miseのPathをツール側で読めるようにshimsだけPathを通す
echo "zprofile start"
eval "$(mise activate zsh --shims)"
echo "zprofile finish"
