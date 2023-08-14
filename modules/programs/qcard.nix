{ config, lib, pkgs, ... }:

let
  cfg = config.programs.qcard;

  qcardAccounts = lib.attrValues
    (lib.filterAttrs (_: a: a.qcard.enable) config.accounts.contact.accounts);

  filteredAccounts = let
    mkAccount = account:
      lib.filterAttrs (_: v: v != null) (with account.remote; {
        Url = url;
        Username = if userName == null then null else userName;
        PasswordCmd =
          if passwordCommand == null then null else toString passwordCommand;
      });
  in map mkAccount qcardAccounts;
in {
  meta.maintainers = with lib.maintainers; [ antonmosich ];

  options = {
    programs.qcard = {
      enable = lib.mkEnableOption "qcard, a CLI addressbook application";

      detailThreshold = lib.mkOption {
        type = lib.types.ints.positive;
        default = 3;
        description =
          "The count of entries that a search result needs to contain to display less detail";
      };

      sortByLastName = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to sort by last name or by first name";
      };
    };

    accounts.contact.accounts = lib.mkOption {
      type = with lib.types;
        attrsOf (submodule {
          options.qcard.enable = lib.mkEnableOption "qcard access";
        });
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.qcard ];

    xdg.configFile."qcard/config.json".source =
      let jsonFormat = pkgs.formats.json { };
      in jsonFormat.generate "qcard.json" {
        Addressbooks = filteredAccounts;
        DetailThreshold = cfg.detailThreshold;
        SortByLastname = cfg.sortByLastName;
      };
  };

}
