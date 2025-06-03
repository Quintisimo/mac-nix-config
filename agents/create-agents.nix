{ pkgs, jobs }:

builtins.mapAttrs (name: { text, runtimeInputs, StartCalendarInterval }: {
  enable = true;
  config = {
    inherit StartCalendarInterval;
    Program = "${pkgs.writeShellApplication {
      inherit name text runtimeInputs;
    }}/bin/${name}";
  };

}) jobs
