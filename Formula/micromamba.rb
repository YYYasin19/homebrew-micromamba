class Micromamba < Formula
  desc "The Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://github.com/mamba-org/mamba/archive/refs/tags/2023.01.16.tar.gz"
  sha256 "a4e4cafb1e76c618db24953f5307557e5a506d682714d0ef0c700929c38411c5"
  license "BSC-3-Clause"
  version "1.2.0"

  depends_on "cmake" => :build

  uses_from_macos "curl"
  # depends_on "curlpp" => :build TODO?
  uses_from_macos "zlib"

  depends_on "cli11"
  depends_on "tl-expected"
  depends_on "nlohmann-json"
  depends_on "spdlog"
  depends_on "fmt"
  depends_on "yaml-cpp"
  depends_on "xz"
  depends_on "libssh2"
  depends_on "libarchive"
  depends_on "krb5"
  depends_on "libsolv"
  depends_on "openssl" # TODO: libopenssl
  depends_on "zstd"
  depends_on "lz4"
  depends_on "reproc"

  def install
    args = %w[
      -DBUILD_LIBMAMBA=ON
      -DBUILD_SHARED=ON
      -DBUILD_MICROMAMBA=ON
      -DMICROMAMBA_LINKAGE=DYNAMIC
    ]

    mkdir "build" do
      system "cmake", "..", *args, *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match version, shell_output("#{bin}/micromamba --version").strip

    system "#{bin}/micromamba", "create", "-n", "test", "python=3.9", "-y"
    system "#{bin}/micromamba", "run", "-n", "test", "python", "-c", "import sys; sys.exit(0)"
  end
end
