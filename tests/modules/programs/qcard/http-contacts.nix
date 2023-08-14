{ pkgs, lib, ... }:

{
  programs.qcard = { enable = true; };
  accounts.contact.accounts.test = {
    qcard.enable = true;
    remote.url = "https://example.com/contact.vcf";
  };

  test.stubs = { qcard = { }; };

  nmt.script = ''
    assertFileExists home-files/.config/qcard/config.json
    assertFileContent home-files/.config/qcard/config.json ${
      ./http-contacts.json-expected
    }
  '';
}
