# paimon-moe-wish-url

A PowerShell utility for extracting the latest Genshin Impact wish-history URL for use with Paimon.moe.

## Usage

1. Open Wish History in Genshin Impact on Windows and wait for the page to load.
2. Open the [web importer](https://paimon-moe.vercel.app/wish/import). Copy the displayed command and paste it into Windows PowerShell from any directory.
3. The command downloads a pinned revision of this repository to a temporary file, verifies its SHA-256 and runs it. Paste the link it copies into the importer. The link contains a private session key.

For manual review, open [Get-WishUrl.ps1](./Get-WishUrl.ps1) on GitHub.

The script supports Global and China on PowerShell 5.1 and newer. It reads the local cache with your ordinary user permissions and validates the URL with the official game service.

## Sources and attribution

This repository is a personal mirror/customized distribution used by the Paimon.moe frontend. It is not the original upstream repository.

- Main script author and upstream maintainer: [jogerj](https://github.com/jogerj).
- Upstream project: [jogerj/genshin-wish-url](https://github.com/jogerj/genshin-wish-url).
- Original method and script source: [MadeBaruna's Genshin wish-history URL Gist](https://gist.github.com/MadeBaruna/1d75c1d37d19eca71591ec8a31178235).
- Additional cache-path research credited in the upstream changelog to [PrimeCicada](https://github.com/PrimeCicada).
- Paimon.moe integration: [MadeBaruna/paimon-moe](https://github.com/MadeBaruna/paimon-moe).

Please preserve the upstream credits and license when modifying or redistributing this script.

## Related links

- [Paimon.moe](https://paimon.moe/)
- [Paimon.moe Discord](https://discord.com/channels/820601523125747712/820601523125747715/1012175730873991228)

## License

The upstream project is licensed under the MIT License. See the [upstream repository](https://github.com/jogerj/genshin-wish-url) for the authoritative license and history.

This project is not affiliated with or endorsed by HoYoverse. Genshin Impact, game content and materials are trademarks and copyrights of HoYoverse.
