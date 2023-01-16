# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Micromamba < Formula
  desc ""
  homepage ""
  license ""
  head "https://github.com/mamba-org/mamba.git", branch: "main"
  # url "https://github.com/mamba-org/mamba/archive/refs/tags/2023.01.16.tar.gz"
  # url "https://github.com/mamba-org/mamba.git", :using => :git, :head => true
  url "https://github.com/mamba-org/mamba/archive/refs/tags/2023.01.16.tar.gz"
  # version "1.2"

  # dependencies as in 
  # https://github.com/mamba-org/mamba/blob/3390da9ab93424fd40d7584ea869b6ef27e212f8/micromamba/recipe/meta.yaml#L11
  
  # build dependencies
  # needs c/cxx compiler -> already installed?
  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # marked as 'win'(dows)
  depends_on "vcpkg" => :build
  depends_on "python" => :build
  uses_from_macos "curl" # depends_on "curlpp" => :build # c++ wrapper for libCURL
  uses_from_macos "zlib"

  # host dependencies
  depends_on "cli11" # TODO: specify version
  depends_on "tl-expected" # TODO: add formula as well
  depends_on "nlohmann-json"
  depends_on "spdlog" # TODO: specify version
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
  # depends_on "reproc-cpp" # not available 

  def install

    # install vcpkg and tl-expected
    # system "git clone https://github.com/Microsoft/vcpkg.git"
    # system "./vcpkg/bootstrap-vcpkg.sh"
    # ENV["VCPKG_ROOT"] = './vcpkg'
    # system "vcpkg install tl-expected"

    build_args = %W[
      -DBUILD_LIBMAMBA=ON
      -DBUILD_SHARED=ON
      -DBUILD_MICROMAMBA=ON
      -DMICROMAMBA_LINKAGE=DYNAMIC
    ]
    # -DCMAKE_TOOLCHAIN_FILE=./vcpkg/scripts/buildsystems/vcpkg.cmake

    # mkdir "build"
    system "cmake", "-B", "build/", *(std_cmake_args + build_args)
    system "cmake", "--build", "build/"

    # move final executable to the correct location
    lib.install "build/micromamba/micromamba"

    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    # https://rubydoc.brew.sh/Formula.html#std_configure_args-instance_method
    # system "./configure", *std_configure_args, "--disable-silent-rules"
    # system "cmake", "-S", ".", "-B", "build", *std_cmake_args
  end
end
