class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://github.com/mamba-org/mamba/archive/refs/tags/2023.01.16.tar.gz"
  version "1.2.0"
  sha256 "a4e4cafb1e76c618db24953f5307557e5a506d682714d0ef0c700929c38411c5"
  license "BSD-3-Clause"

  depends_on "cmake" => :build
  depends_on "cli11"
  depends_on "curl"
  depends_on "fmt"
  depends_on "krb5"
  depends_on "libarchive"
  depends_on "libsolv"
  depends_on "libssh2"
  depends_on "lz4"
  depends_on "nlohmann-json"
  depends_on "openssl"
  depends_on "reproc"
  depends_on "spdlog"
  depends_on "tl-expected"
  depends_on "xz"
  depends_on "yaml-cpp"
  depends_on "zstd"

  uses_from_macos "zlib"

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
