# Install dotfiles with:

    stow --dotfiles .


## Godot + Neovim:

**Editor Settings > Text Editor > External**

1. set exec path to:

        nvim

2. set exec flags to:

        --server 127.0.0.1:55432 --remote-send "<C-\><C-N>:n {file}<CR>:call cursor({line},{col})<CR>"

## Commands I Always Forget

        sudo grub-install --efi-directory=/boot/ && sudo grub-mkconfig -o /boot/grub/grub.cfg
