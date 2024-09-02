{...}:{
  security.pam.loginLimits = [
    {
      domain = "*";  # Applies to all users
      type = "soft";
      item = "nofile";
      value = "1048576";  # Set soft limit to a very high number
    }
    {
      domain = "*";
      type = "hard";
      item = "nofile";
      value = "1048576";  # Set hard limit to the same high value
    }
    {
      domain = "*";
      type = "soft";
      item = "nproc";
      value = "65536";  # Example of setting max processes
    }
    {
      domain = "*";
      type = "hard";
      item = "nproc";
      value = "65536";
    }
  ]; 
}
