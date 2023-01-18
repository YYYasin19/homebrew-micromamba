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
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <tl/expected.hpp>

      tl::expected<int, std::string> divide(int a, int b) {
        if (b == 0) {
          return tl::make_unexpected("Division by zero");
        }
        return a / b;
      }

      int main() {
        auto result = divide(10, 5);
        if (result) {
          std::cout << "Result: " << *result << std::endl;
        } else {
          std::cout << "Error: " << result.error() << std::endl;
        }

        result = divide(2, 0);
        if (result) {
          std::cout << "Result: " << *result << std::endl;
        } else {
          std::cout << "Error: " << result.error() << std::endl;
        }
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-o", "test"
    assert_equal "Result: 2\nError: Division by zero", shell_output("./test").strip
  end
end
