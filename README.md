# paimon-moe-wish-url

A PowerShell utility for extracting the latest Genshin Impact wish-history URL for use with Paimon.moe.

## Usage

1. Open Wish History in Genshin Impact.
2. Download [Get-WishUrl.ps1](./Get-WishUrl.ps1), inspect the file and open PowerShell in its folder.
3. Run the local file with `.\Get-WishUrl.ps1`. Windows may ask you to unblock the downloaded file in its Properties after reviewing it.
4. Paste the copied URL directly into the import page. The URL contains a private session key.

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
- [Android wish URL instructions](https://gist.github.com/jogerj/2372d0e5bee51e001a6d8956240d527b)

## License

The upstream project is licensed under the MIT License. See the [upstream repository](https://github.com/jogerj/genshin-wish-url) for the authoritative license and history.

This project is not affiliated with or endorsed by HoYoverse. Genshin Impact, game content and materials are trademarks and copyrights of HoYoverse.
