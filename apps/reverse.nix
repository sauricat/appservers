{ pkgs, lib, config, ... }:
let
  live-website = ./live-website;
in
{
  services.caddy = {
    enable = true;
    extraConfig = ''
      transacademic.org {
        reverse_proxy * https://oau.edu.kg {
          header_up Host {http.reverse_proxy.upstream.hostport}
        }
      }

      live.oau.app {
        tls info@oneamongus.ca
        root * ${live-website}
        file_server
        handle_errors {
          @404 {
            expression {http.error.status_code}==404
          }
          rewrite @404 /index.html
        }
      }
    '';
  };
}
