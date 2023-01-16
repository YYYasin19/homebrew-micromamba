class TlExpected < Formula
  desc "C++11/14/17 std::expected with functional-style extensions"
  homepage "https://github.com/TartanLlama/expected"
  url "https://github.com/TartanLlama/expected/archive/refs/tags/v1.0.0.tar.gz"
  sha256 ""
  license "TODO"

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    # todo this is not the specification of a .solv file??
    system "false"
  end
end
