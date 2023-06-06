{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "kakoune";
  version = "unstable";
  src = fetchFromGitHub {
    repo = "kakoune";
    owner = "mawww";
    rev = "5a31d331b979f865e1ab1a637bcde9451866ff9f";
    sha256 = "sha256-5DueKPWdaG73czbrHsSnuBHoDfh/Dl2Oiy9pEmqfjnk=";
  };
  makeFlags = [ "debug=no" "PREFIX=${placeholder "out"}" ];

  preConfigure = ''
    export version="${version}"
  '';

  enableParallelBuilding = true;

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/kak -ui json -e "kill 0"
  '';

  postInstall = ''
    # make share/kak/autoload a directory, so we can use symlinkJoin with plugins
    cd "$out/share/kak"
    autoload_target=$(readlink autoload)
    rm autoload
    mkdir autoload
    ln -s --relative "$autoload_target" autoload
  '';

  meta = with lib; {
    homepage = "http://kakoune.org/";
    description = "A vim inspired text editor";
    license = licenses.publicDomain;
    mainProgram = "kak";
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
