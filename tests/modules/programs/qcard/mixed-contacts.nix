{ pkgs, lib, ... }: {
  programs.qcard.enable = true;
  accounts.contact.accounts = {
    test = {
      qcard.enable = true;
      remote = {
        url = "https://card.example.com/anton/work";
        userName = "anton";
        passwordCommand = [ "pass" "show" "contact" ];
      };
    };
    sample = {
      qcard.enable = true;
      remote.url = "https://example.com/contact.vcf";
    };
  };

  test.stubs = { qcard = { }; };

  nmt.script = ''
    assertFileExists home-files/.config/qcard/config.json
    assertFileContent home-files/.config/qcard/config.json ${
      ./mixed-contacts.json-expected
    }
  '';
}
