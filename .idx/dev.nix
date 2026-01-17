{ pkgs, ... }: {
  channel = "stable-24.05"; # Version de nixpkgs
  packages = [
    pkgs.flutter
    pkgs.dart
    pkgs.jdk17
  ];
  idx = {
    extensions = [
      "Dart-Code.flutter"
      "Dart-Code.dart-code"
    ];
    previews = {
      enable = true;
      previews = {
        web = {
          command = ["flutter" "run" "--machine" "-d" "web-server" "--web-hostname" "0.0.0.0" "--web-port" "$PORT"];
          manager = "flutter";
        };
      };
    };
  };
}