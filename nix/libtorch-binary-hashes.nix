version : builtins.getAttr version {
  "1.11.0" = {
    x86_64-darwin-cpu = {
      name = "libtorch-macos-1.11.0.zip";
      url = "https://download.pytorch.org/libtorch/cpu/libtorch-macos-1.11.0.zip";
      hash = "sha256-oTbvPjrREXPQanSjxzHbgJOtY5Yzb9FFgQsUG78o6eQ=";
    };
    x86_64-linux-cpu = {
      name = "libtorch-cxx11-abi-shared-with-deps-1.11.0-cpu.zip";
      url = "https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-1.11.0%2Bcpu.zip";
      hash = "sha256-zC3lyeQrZJAkwingIbbjTkLXngsEaVv6VCl3QbAjOMQ=";
    };
    x86_64-linux-cuda-10 = {
      name = "libtorch-cxx11-abi-shared-with-deps-1.11.0-cu102.zip";
      url = "https://download.pytorch.org/libtorch/cu102/libtorch-cxx11-abi-shared-with-deps-1.11.0%2Bcu102.zip";
      hash = "sha256-0IYyWOOuDuzl15YOE6zoXK8fvhKcS+RRPJHvm1V9s58=";
    };
    x86_64-linux-cuda-11 = {
      name = "libtorch-cxx11-abi-shared-with-deps-1.11.0-cu113.zip";
      url = "https://download.pytorch.org/libtorch/cu113/libtorch-cxx11-abi-shared-with-deps-1.11.0%2Bcu113.zip";
      hash = "sha256-0J2X76XeWaDn0SaptehYsFVInMTwyzgYxAdshn4wZXM=";
    };
    aarch64-darwin-cpu = {
      name = "libtorch-v2.0.0.zip";
      url = "https://github.com/mlverse/libtorch-mac-m1/releases/download/LibTorch/libtorch-v2.0.0.zip";
      hash = "sha256-BKDTrRj/QSAP5slJ/op6Q76wChx1eHfNFHc9YyKEm9g=";
    };
  };
}
