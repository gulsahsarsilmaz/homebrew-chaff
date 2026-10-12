#!/usr/bin/env bash
# Point Formula/chaff.rb at the newest chaff on npm. Prints "changed <version>" or
# "unchanged <version>". Refuses (non-zero) rather than writing a digest it cannot verify.
set -euo pipefail
PKG='@gulsahsarsilmaz/chaff'
F=Formula/chaff.rb
META=$(curl -fsS "https://registry.npmjs.org/@gulsahsarsilmaz%2fchaff/latest")
V=$(node -p 'JSON.parse(process.argv[1]).version' "$META")
INTEGRITY=$(node -p 'JSON.parse(process.argv[1]).dist.integrity' "$META")
# Plain x.y.z only: a prerelease on `latest` is a mistake to wait out, not to ship.
[[ "$V" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "::error::latest is '$V', not x.y.z"; exit 1; }
CUR=$(sed -nE 's|.*/chaff-([0-9.]+)\.tgz".*|\1|p' "$F")
if [ "$CUR" = "$V" ]; then echo "unchanged $V"; exit 0; fi
# Only move forward.
[ "$(printf '%s\n%s\n' "$CUR" "$V" | sort -V | tail -1)" = "$V" ] || { echo "unchanged $CUR (npm has older $V)"; exit 0; }
URL="https://registry.npmjs.org/$PKG/-/chaff-$V.tgz"
# A fresh tarball can 404 for minutes after publishing; wait it out.
for i in $(seq 1 30); do curl -fsSL "$URL" -o chaff.tgz && break; rm -f chaff.tgz; sleep 20; done
[ -s chaff.tgz ] || { echo "::error::$URL unavailable"; exit 1; }
GOT="sha512-$(openssl dgst -sha512 -binary chaff.tgz | base64 | tr -d '\n')"
[ "$GOT" = "$INTEGRITY" ] || { echo "::error::tarball $GOT != registry $INTEGRITY"; exit 1; }
SHA=$(shasum -a 256 chaff.tgz | cut -d' ' -f1)
rm -f chaff.tgz
sed -i.bak -E "s|^  url \".*\"|  url \"$URL\"|; s|^  sha256 \".*\"|  sha256 \"$SHA\"|" "$F" && rm -f "$F.bak"
grep -q "chaff-$V.tgz" "$F" && grep -q "$SHA" "$F" || { echo "::error::formula edit failed"; exit 1; }
echo "changed $V"
