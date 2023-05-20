{...}: {
  sops.secrets."certificates/work_root_proxy.pem" = {
    sopsFile = ./certificates/work_root_proxy.pem;
    format = "binary";
  };

  sops.secrets."certificates/work_root_tls.crt" = {
    sopsFile = ./certificates/work_root_tls.crt;
    format = "binary";
  };

  sops.secrets."certificates/work_root_user.crt" = {
    sopsFile = ./certificates/work_root_user.crt;
    format = "binary";
  };

  sops.secrets."certificates/work_private_key.pfx" = {
    sopsFile = ./certificates/work_private_key.pfx;
    format = "binary";
  };
}
