class Chaff < Formula
  desc "Find and safely clean dead build output, caches and worktrees on a dev machine"
  homepage "https://github.com/gulsahsarsilmaz/chaff"
  url "https://registry.npmjs.org/@gulsahsarsilmaz/chaff/-/chaff-0.4.0.tgz"
  sha256 "42ab78b4bf136e2fbb0e15eca48233b1b4c2689ec73dbacb3dc8e2097865dd61"
  license "MIT"

  # chaff is dependency-free JavaScript; it needs a Node runtime and nothing else.
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # `help` needs no filesystem scan, so it is the one command guaranteed to work in a
    # sandbox with no repos, no home directory state and no network.
    assert_match "chaff", shell_output("#{bin}/chaff help")

    # A scan must survive a directory that contains nothing chaff recognises.
    system bin/"chaff", "plan", "--json"
  end
end
