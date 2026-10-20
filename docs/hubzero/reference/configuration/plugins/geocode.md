---
tags:
- HUBzero
render_macros: false
hubzero:
  upstream: docs/reference/configuration/plugins/geocode.md
  commit: 9c1a8c678002bdfb41860f90915a3589ab60339e
  status: generated
  source: core/plugins/geocode/*/*.xml
---

# Geocode plugins

Parameters of every plugin in the `geocode` group, from each plugin's manifest. Set them under **Extensions > Plugins** in the administrator interface.

## Geocode - ArcGISOnline (`plg_geocode_arcgisonline`) { #geocode-arcgisonline-plg-geocode-arcgisonline }

ArcGISOnline provider for geocode

### Basic

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `sourceCountry` | Source Country | text | — | Source Country |
| `useSsl` | Use SSL | list | `0 (No)` | Use SSL?. Options: `0` No, `1` Yes. |

## Geocode - BingMaps (`plg_geocode_bingmaps`) { #geocode-bingmaps-plg-geocode-bingmaps }

BingMaps provider for geocode

### Basic { #basic-2 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `apiKey` | API Key | text | — | API key |

## Geocode - Geonames (`plg_geocode_geonames`) { #geocode-geonames-plg-geocode-geonames }

Geonames provider for geocode

### Basic { #basic-3 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `username` | Username | text | — | Geonames username |

## Geocode - Geoplugin (`plg_geocode_geoplugin`) { #geocode-geoplugin-plg-geocode-geoplugin }

Geoplugin provider for Geocode

This plugin has no parameters.

## Geocode - GoogleMaps (`plg_geocode_googlemaps`) { #geocode-googlemaps-plg-geocode-googlemaps }

GoogleMaps provider for geocode

This plugin has no parameters.

## Geocode - HostIp (`plg_geocode_hostip`) { #geocode-hostip-plg-geocode-hostip }

HostIp provider for geocode

This plugin has no parameters.

## Geocode - IpInfoDb (`plg_geocode_ipinfodb`) { #geocode-ipinfodb-plg-geocode-ipinfodb }

IpInfoDb provider for geocode

### Basic { #basic-4 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `apiKey` | API Key | text | — | API key |

## Geocode - IPstack (`plg_geocode_ipstack`) { #geocode-ipstack-plg-geocode-ipstack }

IPstack provider for geocode

### Basic { #basic-5 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `apiKey` | API Key | text | — | API key |

## Geocode - Local (`plg_geocode_local`) { #geocode-local-plg-geocode-local }

Geocode events for local

This plugin has no parameters.

## Geocode - MapQuest (`plg_geocode_mapquest`) { #geocode-mapquest-plg-geocode-mapquest }

MapQuest provider for geocode

### Basic { #basic-6 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `apiKey` | API Key | text | — | API key |

## Geocode - MaxMind (`plg_geocode_maxmind`) { #geocode-maxmind-plg-geocode-maxmind }

MaxMind provider for geocode

### Basic { #basic-7 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `apiKey` | API Key | text | — | API key |

## Geocode - MaxMindBinary (`plg_geocode_maxmindbinary`) { #geocode-maxmindbinary-plg-geocode-maxmindbinary }

MaxMindBinary provider for geocode

This plugin has no parameters.

## Geocode - Nominatim (`plg_geocode_nominatim`) { #geocode-nominatim-plg-geocode-nominatim }

Nominatim provider for geocode

### Basic { #basic-8 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `rootUrl` | Root URL | text | `http://nominatim.openstreetmap.org` | Root URL of the nominatim server |

## Geocode - TomTom (`plg_geocode_tomtom`) { #geocode-tomtom-plg-geocode-tomtom }

TomTom provider for geocode

### Basic { #basic-9 }

| Parameter | Label | Type | Default | Description |
|---|---|---|---|---|
| `apiKey` | API Key | text | — | API key |

## Geocode - Yandex (`plg_geocode_yandex`) { #geocode-yandex-plg-geocode-yandex }

Yandex provider for geocode

This plugin has no parameters.
