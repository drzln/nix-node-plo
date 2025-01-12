{ requirements, ... }: {
  imports = [
    requirements.outputs.nixosModules.blackmatter
  ];

  blackmatter.components.microservices.application_reverse_proxy = {
    enable = true;
    traefik.namespace = "plo";
    consul.namespace = "plo";
    traefik.settings = {
      entryPoints = {
        web = {
          address = ":80";
        };
      };
      providers = {
        file = {
          directory = "/etc/traefik/custom/";
          watch = true;
        };
      };
    };
    # consul.extraConfig = ''
    #   # Custom Consul configuration or notes
    #   # This configuration string is stored but may need specific handling in your setup.
    # '';
  };
}

