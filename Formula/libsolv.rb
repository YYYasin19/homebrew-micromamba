class Libsolv < Formula
  desc "Library for solving packages and reading repositories"
  homepage "https://github.com/openSUSE/libsolv"
  url "https://github.com/openSUSE/libsolv/archive/refs/tags/0.7.23.tar.gz"
  sha256 "0286155964373c6cc3802d025750786c3ee79608d5cb884598e110e3918bb2fe"
  license "BSD-3-Clause"

  depends_on "cmake" => :build
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "zlib"

  def install
    args = %w[
      -DENABLE_STATIC=ON
      -DENABLE_SUSEREPO=ON
      -DENABLE_COMPS=ON
      -DENABLE_HELIXREPO=ON
      -DENABLE_DEBIAN=ON
      -DENABLE_MDKREPO=ON
      -DENABLE_ARCHREPO=ON
      -DENABLE_CUDFREPO=ON
      -DENABLE_CONDA=ON
      -DENABLE_APPDATA=ON
      -DMULTI_SEMANTICS=ON
      -DENABLE_LZMA_COMPRESSION=ON
      -DENABLE_BZIP2_COMPRESSION=ON
      -DENABLE_ZSTD_COMPRESSION=ON
      -DENABLE_ZCHUNK_COMPRESSION=ON
    ]

    mkdir "build" do
      system "cmake", "..", *args, *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    # TODO: this is not the specification of a .solv file??
    (testpath/"test.solv").write <<~EOS
      solv

      pool

      solvable
      name mypackage
      version 1.0
      arch x86_64
      end

      solvable
      name mypackage
      version 2.0
      arch x86_64
      end

      repo

      end
    EOS

    # no idea how the tools work
    # system #{bin}/testsolv, "test.solv"

    (testpath/"test.cpp").write <<~EOS
      #include <solv/pool.h>
      #include <solv/repo.h>

      int main(int argc, char **argv) {
        Pool *pool = pool_create();

        Repo *repo = repo_create(pool, "test.solv");

        pool_free(pool);
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lsolv", "-o", "test"
    system "./test"
  end
end
