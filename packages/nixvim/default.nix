{ inputs, lib, nixvim, ... }:
let
  modules = inputs.self.nixvimModules;

  enabled = { enable = true; };
  autoCmd = {
    indentOverride = pattern: expandTab: spaces: {
      inherit pattern;
      event = [ "FileType" ];
      command = lib.concatStringsSep " " [
        "setlocal"
        "tabstop=${toString spaces}"
        "softtabstop=${toString spaces}"
        "shiftwidth=${toString spaces}"
        (if expandTab then "expandtab" else "noexpandtab")
      ];
    };
  };

in
nixvim.makeNixvimWithModule {
  module = {
    imports = lib.attrValues modules;

    config = {
      olistrik.plugins = {
        lsp = enabled;
        copilot = enabled; # temp; until I can make it a little less intrusive.
        gitblame = enabled;
        lualine = enabled;
        telescope = enabled;
        treesitter = enabled;
      };

      plugins = {
        # luasnip = enabled;
        gitsigns = enabled;
        nvim-autopairs = enabled;
        nvim-colorizer = enabled;
        comment = enabled;
        # harpoon = enabled;
        todo-comments = enabled;
        vim-surround = enabled;
        fugitive = enabled;

        dressing = {
          enable = true;
          settings = {
            input = {
              insert_only = false;
            };
          };
        };

        avante = {
          enable = true;
          settings = {
            provider = "copilot";
            auto_suggestion_provider = "copilot";
          };
        };
        # abolish = enabled;
        # easy-align = enabled;
        # vim-repeat = enabled;
      };

      colorschemes.ayu = {
        enable = true;
        settings.mirage = true;
      };

      editorconfig.enable = true;

      clipboard = {
        register = [ "unnamed" "unnamedplus" ];
        providers.wl-copy.enable = true;
      };

      globals.mapleader = " ";

      opts = {
        number = true;
        relativenumber = true;
        laststatus = 1;
        scrolloff = 5;
        incsearch = true;
        hlsearch = false;
        mouse = "nvchr";
        signcolumn = "yes";
        tabstop = 2;
        softtabstop = 2;
        shiftwidth = 2;
        expandtab = false;
      };

      autoCmd = with autoCmd; [
        (indentOverride [ "nix" ] true 2)
      ];
    };
  };
}
