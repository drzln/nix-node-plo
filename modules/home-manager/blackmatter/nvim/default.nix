{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.blackmatter.programs.nvim;
  plugs = cfg.plugin.groups;
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;

  #############################################################################
  # plugin groups:
  # toggle which groups of plugins are on
  # 
  # TODO: implement override to enable/disable each plugin
  #############################################################################

  groups.toggles = {
    common.enable = true;
    languages.enable = true;
    lsp.enable = true;
    theming.enable = true;
    tmux.enable = true;
    completion.enable = true;
    debugging.enable = false;
  };

  # end plugin groups

  plugins.toggles =
    {
      jpmcb."nvim-llama".enable = false;
      # enabled plugins
      NvChad."nvim-colorizer.lua".enable = false;
      jay-babu."mason-null-ls.nvim".enable = false;
      # tree-sitter for nix is bugged with OOM
      LnL7.vim-nix.enable = false;
      simrat39."rust-tools.nvim".enable = false;
      willothy."veil.nvim".enable = false;

      # TODO: has bug, so turning off for now
      jcdickinson."codeium.nvim".enable = false;

      # disabled plugins
      Wansmer.treesj.enable = false;
      EtiamNullam."relative-source.nvim".enable = false;
      ziontee113."icon-picker.nvim".enable = false;
      windwp.nvim-projectconfig.enable = false;
      yamatsum.nvim-nonicons.enable = false;
      RishabhRD.nvim-lsputils.enable = false;
      RRethy.vim-illuminate.enable = false;
      rafcamlet.nvim-luapad.enable = false;
      rafcamlet."tabline-framework.nvim".enable = false;
      nanotee.nvim-lsp-basics.enable = false;
      rest-nvim."rest.nvim".enable = false;
      # TODO: requires python3 that cannot be found
      ms-jpq.chadtree.enable = false;
      nanotee.nvim-lua-guide.enable = false;
      niuiic."divider.nvim".enable = false;
      NTBBloodbath."galaxyline.nvim".enable = false;

      # markdown

      nfrid.markdown-togglecheck.enable = false;
      godlygeek.tabular.enable = false;
      preservim.vim-markdown.enable = false;
      iamcco."markdown-preview.nvim".enable = false;


      # end markdown

      MunifTanjim."nui.nvim".enable = false;
      LudoPinelli."comment-box.nvim".enable = false;
      madskjeldgaard.reaper-nvim.enable = false;
      lotabout.skim.enable = false;
      drybalka."tree-climber.nvim".enable = false;
      jubnzv."mdeval.nvim".enable = false;
      kkharji."sqlite.lua".enable = false;
      kosayoda.nvim-lightbulb.enable = false;
      idanarye.nvim-buffls.enable = false;
      gwatcha.reaper-keys.enable = false;
      LeonHeidelbach."trailblazer.nvim".enable = false;
      lewis6991."gitsigns.nvim".enable = false;
      jghauser."follow-md-links.nvim".enable = false;
      declancm."cinnamon.nvim".enable = false;
      ibhagwan.fzf-lua.enable = false;
      glepnir."lspsaga.nvim".enable = false;
      glepnir.dashboard-nvim.enable = false;
      chrisgrieser.nvim-various-textobjs.enable = false;
      esensar.nvim-dev-container.enable = false;
      nvim-lua."lsp-status.nvim".enable = false;
      bennypowers.nvim-regexplainer.enable = false;
      cuducos."yaml.nvim".enable = false;
      cbochs."grapple.nvim".enable = false;
      akinsho."git-conflict.nvim".enable = false;
      jose-elias-alvarez."typescript.nvim".enable = false;
      simrat39."symbols-outline.nvim".enable = false;
      mfussenegger.nvim-jdtls.enable = false;
      nvim-lua."popup.nvim".enable = false;
      ldelossa."gh.nvim".enable = false;
      ldelossa."litee.nvim".enable = false;
      nvim-orgmode.orgmode.enable = false;
      ray-x."navigator.lua".enable = false;
      amrbashir.nvim-docs-view.enable = false;
      p00f."cphelper.nvim".enable = false;
      lewis6991."impatient.nvim".enable = false;
      f-person."git-blame.nvim".enable = false;
      folke."noice.nvim".enable = false;
      frabjous.knap.enable = false;
      aserowy."tmux.nvim".enable = false;
      michaelb.sniprun.enable = false;
      mrjones2014."legendary.nvim".enable = false;
      MarcHamamji."runner.nvim".enable = false;
      tpope.vim-fugitive.enable = false;
      tpope.vim-repeat.enable = false;
      mfussenegger.nvim-lint.enable = false;
      camspiers."animate.vim".enable = false;
      tpope.vim-rhubarb.enable = false;
      numToStr."Navigator.nvim".enable = false;
      camspiers."lens.vim".enable = false;
      gnikdroy."projections.nvim".enable = false;
      nvim-neorg.neorg.enable = false;
      nvim-neorocks.luarocks-tag-release.enable = false;
      gennaro-tedesco."nvim-possession".enable = false;
      ojroques.nvim-lspfuzzy.enable = false;
      phaazon."hop.nvim".enable = false;
      pwntester."octo.nvim".enable = false;
      SchemaStore.schemastore.enable = false;
      smjonas."inc-rename.nvim".enable = false;
      someone-stole-my-name."yaml-companion.nvim".enable = false;
      sudormrfbin."cheatsheet.nvim".enable = false;
      svermeulen.vimpeccable.enable = false;
      tjdevries."vlog.nvim".enable = false;
      ellisonleao."glow.nvim".enable = false;

      # KittyCAD
      "kcl-lang"."kcl.nvim".enable = false;
    } //

    # unfortunately macos has some sandbox issue
    # that makes loading many plugins at once
    # somewhat impossible, separating this to linux
    # only for now.
    lib.optionalAttrs isLinux {

      # testing
      nvim-neotest.neotest.enable = false;
      nvim-neotest.neotest-python.enable = false;
      nvim-neotest.neotest-plenary.enable = false;
      nvim-neotest.neotest-go.enable = false;
      nvim-neotest.neotest-jest.enable = false;
      rouge8.neotest-rust.enable = false;
      stevearc."overseer.nvim".enable = false;

      # improved motion
      andymass.vim-matchup.enable = false;
      chaoren.vim-wordmotion.enable = false;
      wellle."targets.vim".enable = false;
      ggandor."leap.nvim".enable = false;
      unblevable.quick-scope.enable = false;

      # snippets
      rafamadriz.friendly-snippets.enable = false;

      # refactoring
      ThePrimeagen."refactoring.nvim".enable = false;

      # annotating
      kkoomen.vim-doge.enable = false;
      danymat.neogen.enable = false;

      # rest calls
      diepm.vim-rest-console.enable = false;
      NTBBloodbath."rest.nvim".enable = false;
    };
in
{
  imports =
    [
      ##################################
      # groups
      ##################################

      ./groups/common
      ./groups/lsp
      ./groups/languages
      ./groups/completion
      ./groups/theming
      ./groups/debugging
      ./groups/tmux

      # end groups

      ./plugins/maaslalani/nordbuddy
      ./plugins/kkoomen/vim-doge
      ./plugins/danymat/neogen
      ./plugins/ThePrimeagen/refactoring.nvim
      ./plugins/diepm/vim-rest-console
      ./plugins/ravenxrz/DAPInstall.nvim
      ./plugins/Pocco81/dap-buddy.nvim
      ./plugins/willothy/veil.nvim
      ./plugins/jcdickinson/codeium.nvim
      ./plugins/yriveiro/dap-go.nvim
      ./plugins/mfussenegger/nvim-dap
      ./plugins/leoluz/nvim-dap-go
      ./plugins/mfussenegger/nvim-dap-python
      ./plugins/NvChad/nvim-colorizer.lua
      ./plugins/svermeulen/vimpeccable
      ./plugins/tjdevries/vlog.nvim
      ./plugins/someone-stole-my-name/yaml-companion.nvim
      ./plugins/RRethy/vim-illuminate
      ./plugins/sudormrfbin/cheatsheet.nvim
      ./plugins/SchemaStore/schemastore
      ./plugins/pwntester/octo.nvim
      ./plugins/phaazon/hop.nvim
      ./plugins/ojroques/nvim-lspfuzzy
      ./plugins/nvim-neorocks/luarocks-tag-release
      ./plugins/simrat39/symbols-outline.nvim
      ./plugins/smjonas/inc-rename.nvim
      ./plugins/nvim-neotest/neotest
      ./plugins/nvim-neotest/neotest-python
      ./plugins/nvim-neotest/neotest-plenary
      ./plugins/nvim-neotest/neotest-jest
      ./plugins/nvim-neotest/neotest-go
      ./plugins/rouge8/neotest-rust
      ./plugins/stevearc/overseer.nvim
      ./plugins/aserowy/tmux.nvim
      ./plugins/frabjous/knap
      ./plugins/glepnir/lspsaga.nvim
      ./plugins/gnikdroy/projections.nvim
      ./plugins/glepnir/dashboard-nvim
      ./plugins/gennaro-tedesco/nvim-possession
      ./plugins/esensar/nvim-dev-container
      ./plugins/bennypowers/nvim-regexplainer
      ./plugins/theHamsta/nvim-dap-virtual-text
      ./plugins/wellle/targets.vim
      ./plugins/amrbashir/nvim-docs-view
      ./plugins/nfrid/markdown-togglecheck
      ./plugins/jose-elias-alvarez/typescript.nvim
      ./plugins/akinsho/git-conflict.nvim
      ./plugins/niuiic/divider.nvim
      ./plugins/simrat39/rust-tools.nvim
      ./plugins/mfussenegger/nvim-jdtls
      ./plugins/nvim-orgmode/orgmode
      ./plugins/suketa/nvim-dap-ruby
      ./plugins/ray-x/navigator.lua
      ./plugins/rcarriga/nvim-dap-ui
      ./plugins/lewis6991/impatient
      ./plugins/nvim-lua/popup.nvim
      ./plugins/tpope/vim-fugitive
      ./plugins/tpope/vim-repeat
      ./plugins/lewis6991/gitsigns.nvim
      ./plugins/lotabout/skim
      ./plugins/p00f/cphelper.nvim
      ./plugins/camspiers/animate
      ./plugins/tpope/vim-rhubarb
      ./plugins/folke/noice.nvim
      ./plugins/f-person/git-blame.nvim
      ./plugins/numToStr/Navigator.nvim
      ./plugins/camspiers/lens
      ./plugins/LnL7/vim-nix
      ./plugins/cbochs/grapple.nvim
      ./plugins/declancm/cinnamon.nvim
      ./plugins/cuducos/yaml.nvim
      ./plugins/drybalka/tree-climber.nvim
      ./plugins/chrisgrieser/nvim-various-textobjs
      ./plugins/ggandor/leap.nvim
      ./plugins/ibhagwan/fzf-lua
      ./plugins/gwatcha/reaper-keys
      ./plugins/idanarye/nvim-buffls
      ./plugins/ldelossa/gh.nvim
      ./plugins/ldelossa/litee.nvim
      ./plugins/jubnzv/mdeval.nvim
      ./plugins/jbyuki/one-small-step-for-vimkind
      ./plugins/jghauser/follow-md-links.nvim
      ./plugins/kkharji/sqlite.lua
      ./plugins/kosayoda/nvim-lightbulb
      ./plugins/LeonHeidelbach/trailblazer.nvim
      ./plugins/LudoPinelli/comment-box.nvim
      ./plugins/madskjeldgaard/reaper-nvim
      ./plugins/MarcHamamji/runner.nvim
      ./plugins/mfussenegger/nvim-lint
      ./plugins/michaelb/sniprun
      ./plugins/mrjones2014/legendary.nvim
      ./plugins/ms-jpq/chadtree
      ./plugins/MunifTanjim/nui.nvim
      ./plugins/nanotee/nvim-lsp-basics
      ./plugins/nanotee/nvim-lua-guide
      ./plugins/NTBBloodbath/galaxyline.nvim
      ./plugins/NTBBloodbath/rest.nvim
      ./plugins/nvim-lua/lsp-status.nvim
      ./plugins/nvim-neorg/neorg
      ./plugins/rafcamlet/nvim-luapad
      ./plugins/rafcamlet/tabline-framework.nvim
      ./plugins/rest-nvim/rest.nvim
      ./plugins/RishabhRD/nvim-lsputils
      ./plugins/Wansmer/treesj
      ./plugins/windwp/nvim-projectconfig
      ./plugins/yamatsum/nvim-nonicons
      ./plugins/ziontee113/icon-picker.nvim
      ./plugins/EtiamNullam/relative-source.nvim
      ./plugins/ellisonleao/glow.nvim
      ./plugins/andymass/vim-matchup
      ./plugins/chaoren/vim-wordmotion
      ./plugins/unblevable/quick-scope
      ./plugins/rafamadriz/friendly-snippets
      ./plugins/preservim/vim-markdown
      ./plugins/godlygeek/tabular
      ./plugins/iamcco/markdown-preview.nvim
      ./plugins/kcl-lang/vim-kcl
      ./plugins/jay-babu/mason-null-ls.nvim
      ./plugins/jpmcb/nvim-llama
    ];

  options = {
    blackmatter = {
      programs = {
        nvim.enable = mkEnableOption "nvim";
        nvim.package = mkOption {
          type = types.package;
          description = lib.mdDoc "neovim package/derivation";
        };
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = [ cfg.package ];

      # place some lua programming that calls plugins
      # that you place in the correct spot.
      xdg.configFile."nvim/init.lua".source = ./conf/init.lua;
      xdg.configFile."nvim/lua/plugins/init.lua".source = ./conf/lua/plugins/init.lua;
      xdg.configFile."nvim/lua/utils".source = ./conf/lua/utils;
      xdg.configFile."nvim/lua/lsp".source = ./conf/lua/lsp;

      # this is where you can drop lua code that executes after
      # plugins load.
      xdg.configFile."nvim/after".source = ./conf/after;

      blackmatter = {
        programs = {
          nvim = {
            plugins = plugins.toggles;
            plugin.groups = groups.toggles;
          };
        };
      };
    })
  ];
}
