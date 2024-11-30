{ outputs, ... }:
{
  imports = [
    ./gitconfig
    ./desktop
    ./shell
    ./nvim
    ./kubernetes
  ];
}
