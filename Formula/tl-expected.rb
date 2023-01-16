class TlExpected < Formula
  desc "C++11/14/17 std::expected with functional-style extensions"
  homepage "https://github.com/TartanLlama/expected"
  url "https://github.com/TartanLlama/expected/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "8f5124085a124113e75e3890b4e923e3a4de5b26a973b891b3deb40e19c03cee"
  license "CC0-1.0"

  depends_on "cmake" => :build

  def install
    args = %w[
      -DEXPECTED_ENABLE_TESTS=OFF
      -DCMAKE_INSTALL_LIBDIR=#{lib}
    ]

    mkdir "build" do
      system "cmake", "..", *args, *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
