# homebrew-chaff

Homebrew tap for [chaff](https://github.com/gulsahsarsilmaz/chaff): separate the live work
from the dead weight on a developer machine, with tiered safe cleanup.

```sh
brew tap gulsahsarsilmaz/chaff
brew install chaff
```

The formula installs the published npm package
[`@gulsahsarsilmaz/chaff`](https://www.npmjs.com/package/@gulsahsarsilmaz/chaff), pinned by
sha256. A daily workflow moves it to each new release on its own, after verifying the
tarball against npm and installing it on macOS and Linux.

Issues with chaff itself belong in the [main repo](https://github.com/gulsahsarsilmaz/chaff/issues).
