{ pkgs, lib, ... }:

{
  programs.qcard = {
    enable = true;
    detailThreshold = 5;
    sortByLastName = true;
  };
  accounts.contact.accounts.test = {
    qcard.enable = true;
    remote = {
      url = "https://card.example.com/anton/work";
      userName = "anton";
      passwordCommand = [ "pass" "show" "contact" ];
    };
  };

  test.stubs = { qcard = { }; };

  nmt.script = ''
    assertFileExists home-files/.config/qcard/config.json
    assertFileContent home-files/.config/qcard/config.json ${
      ./webdav-contacts.json-expected
    }
  '';
}
