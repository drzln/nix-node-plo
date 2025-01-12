{ requirements, ... }: {
  imports = [
    requirements.outputs.nixosModules.blackmatter
  ];

  blackmatter.components.microservices.application_reverse_proxy = {
    enable = true;
    namespace = "plo";
    # traefik.enable = true;
    # consul.enable = true;

    # traefik.extraConfig = ''
    #   # Custom Traefik configuration
    #   entryPoints:
    #     web:
    #       address: ":80"
    #   providers:
    #     file:
    #       directory: /etc/traefik/custom/
    #       watch: true
    # '';

    # consul.extraConfig = ''
    #   # Custom Consul configuration or notes
    #   # This configuration string is stored but may need specific handling in your setup.
    # '';
  };
}

