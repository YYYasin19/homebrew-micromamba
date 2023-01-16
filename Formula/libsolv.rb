class Libsolv < Formula
  desc "Library for solving packages and reading repositories"
  homepage "https://github.com/openSUSE/libsolv"
  url "https://github.com/openSUSE/libsolv/archive/refs/tags/0.7.23.tar.gz"
  sha256 "0286155964373c6cc3802d025750786c3ee79608d5cb884598e110e3918bb2fe"
  license "TODO"
  head "https://github.com/openSUSE/libsolv"

  depends_on "cmake" => :build
  depends_on "swig" => :build

  uses_from_macos "zlib"

  def install
    args = %W[
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
      system "cmake", "..", *args
      system "make"
      lib.install "src/libsolv.dylib"
      lib.install "src/libsolv.a"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <solv/pool.h>
      #include <solv/repo.h>
      #include <solv/repo_solv.h>
      #include <solv/repo_rpmdb.h>

      int main() {
        Pool *pool = pool_create();
        Repo *repo = repo_create(pool, "test");
        repo_add_solv(repo, "test.solv", 0);
        repo_add_rpmdb(repo, 0, 0);
        pool_free(pool);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lsolv", "-o", "test"
    system "./test"
  end
end
