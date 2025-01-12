{ requirements, ... }:
let
  namespace = "plo";
in
{
  imports = [
    requirements.outputs.nixosModules.blackmatter
  ];

  blackmatter.components.microservices.application_reverse_proxy = {
    enable = false;
    traefik.namespace = namespace;
    consul.namespace = namespace;
    traefik.settings = {
      entryPoints = {
        web = {
          address = ":80";
        };
        websecure = {
          address = ":443";
        };
        mysql = {
          address = ":3306";
        };
      };
      providers = {
        consulCatalog = {
          endpoint = {
            address = "127.0.0.1:8500";
            scheme = "http";
          };
          exposedByDefault = false;
        };
      };
      log = {
        level = "INFO";
      };
      api = {
        insecure = true;
      };
    };
    # consul.extraConfig = ''
    #   # Custom Consul configuration or notes
    #   # This configuration string is stored but may need specific handling in your setup.
    # '';
  };

  services.dnsmasq.settings = {
    address = [
      "/lilith.local/127.0.0.1"
    ];
		domainNeeded = false;
  };
}
