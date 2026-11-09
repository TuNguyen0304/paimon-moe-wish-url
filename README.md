# paimon-moe-wish-url

A PowerShell utility for extracting the latest Genshin Impact wish-history URL for use with Paimon.moe.

## Usage

1. Open PowerShell.
2. Run:

```powershell
Set-ExecutionPolicy Bypass -Scope CurrentUser -Force;
iex (irm 'https://raw.githubusercontent.com/TuNguyen0304/paimon-moe-wish-url/main/Get-WishUrl.ps1')
```

3. Open Genshin Impact and visit the Wish History page at least once before running the script.
4. Paste the copied URL into Paimon.moe.

The script supports both Global and China installations and is officially supported on PowerShell 5.1 or newer.

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
