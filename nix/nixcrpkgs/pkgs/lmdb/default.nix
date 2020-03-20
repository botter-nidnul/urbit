{ crossenv }:

crossenv.make_derivation rec {
  name = "lmdb-${version}";
  version = "0.9.25";
  builder = ./builder.sh;

  src = crossenv.nixpkgs.fetchFromGitHub {
    owner = "botter-nidnul";
    repo = "lmdb";
    rev = "LMDB_${version}";
    sha256 = "0i60zlca8r6fib23gdgl4c80gxpx24772ggpvz94yr7zaai4k11w";
  };
}
