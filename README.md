# OSM to GeoJson

Convert osm xml to osm GeoJson

[![GitHub license](https://img.shields.io/badge/license-EUPL-blue.svg)](https://raw.githubusercontent.com/herotc/hero-rotation/master/LICENSE)

## Getting Started

* Download data
or
* Use example

### Data

1. Download [osm.bz2](http://download.geofabrik.de/) file
2. Split file between 1gb and 2gb chunk with xml_split from [xml-twig-tools](https://packages.ubuntu.com/xenial/all/xml-twig-tools/filelist) or other tools _For better performance_

Ex:

```sh
xml_split -s 1gb ile-de-france-latest.osm
```

### Prerequisites

Download this repository

#### Local Compiler

You need to have dub installed on your computer.

Installation of a compiler sometimes is cumbersome.
This Docker image should take this pain and allow you to easily switch between Versions of the same compiler and even different compilers.

In case a native installation is required, `curl -fsS https://dlang.org/install.sh | bash -s dmd` could be used.

* windows
* linux
* macos

#### Docker

1. Docker must be installed on your computer

[Docker dub/dmd](https://hub.docker.com/r/neudinger/dubdmd)

Then execute:
**linux**

```sh
docker build . -t dubdmd:latest
```

**OR**

```sh
docker pull neudinger/dubdmd:latest
```

**OR**

```sh
docker build --rm . --build-arg buildtypes=debug -t dubdmd:latest
```

~~windows and mac~~</br>
use linux or find by your self how tu use docker</br>
[Mac](https://docs.docker.com/docker-for-mac/install/)</br>
[Windows](https://docs.docker.com/docker-for-windows/)


## Running

### Local

```sh
./osmtogeojson -i ./examples/ex.xml
```

**OR**

```sh
./osmtogeojson -i ./examples/ile-de-france-latest-01.osm -o ile-de-france-latest-geo.json
```

**OR**

```sh
./osmtogeojson -h
```

### Docker

```sh
docker run --rm -ti -v $(pwd):/home/src dubdmd
```

## Example

```xml
<?xml version='1.0' encoding='UTF-8'?>
<xml_split:root xmlns:xml_split="http://xmltwig.com/xml_split">
    <bounds minlat="48.11918" minlon="1.445097" maxlat="49.24271" maxlon="3.560409"/>
    <node id="199040487" lat="48.7444381" lon="2.2220969" version="7" timestamp="2018-11-10T19:04:27Z" changeset="0">
        <tag k="addr:city" v="Igny"/>
        <tag k="addr:street" v="Route Nationale 444"/>
        <tag k="amenity" v="fuel"/>
        <tag k="compressed_air" v="yes"/>
        <tag k="fuel:diesel" v="yes"/>
        <tag k="fuel:e10" v="yes"/>
        <tag k="is_in" v="Igny"/>
        <tag k="name" v="BP"/>
        <tag k="opening_hours" v="24/7"/>
        <tag k="operator" v="BP"/>
        <tag k="ref:FR:prix-carburants" v="91430003"/>
        <tag k="shop" v="convenience;gas"/>
        <tag k="source" v="Ministère de l&#39;Economie, de l&#39;Industrie et du Numérique - 08/04/2018"/>
        <tag k="toilets" v="yes"/>
    </node>
</xml_split:root>
```

**TO**

```json
{
    "geometry": {
        "coordinates": [
            2.22209689999999993,
            48.7444381000000035
        ],
        "type": "Point"
    },
    "id": "199040487",
    "meta": {
        "changeset": "0",
        "id": "199040487",
        "lat": "48.7444381",
        "lon": "2.2220969",
        "timestamp": "2018-11-10T19:04:27Z",
        "type": "node",
        "version": "7"
    },
    "properties": {
        "addr:city": "Igny",
        "addr:street": "Route Nationale 444",
        "amenity": "fuel",
        "compressed_air": "yes",
        "fuel:diesel": "yes",
        "fuel:e10": "yes",
        "is_in": "Igny",
        "name": "BP",
        "opening_hours": "24\/7",
        "operator": "BP",
        "ref:FR:prix-carburants": "91430003",
        "shop": "convenience;gas",
        "source": "Ministère de l'Economie, de l'Industrie et du Numérique - 08\/04\/2018",
        "toilets": "yes"
    },
    "type": "Feature"
}
```

## Limitation

little bit slow if file > 2GB

## Authors

* **Barre Kevin** - *Initial work* - [neudinger](https://github.com/neudinger)

## Code Style and Optimisation

I use all garbage collector features.

So speed and memory allocation are not optimized.

## License

This project is licensed under the European Union Public License 1.2 see the :eu: [eupl-1.2](https://choosealicense.com/licenses/eupl-1.2/) file for details.</br>
[European Union Public Licence](https://eupl.eu/)</br>
[:eu: Official EUPL website](https://joinup.ec.europa.eu/collection/eupl/eupl-text-11-12)

## Future work

* [ ] Str2Array "convenience;gas" :arrow_right: ["convenience", "gas"]
* [ ] Str2Double "48.7444381" :arrow_right: 48.7444381
* [ ] Str2Bool "yes" :arrow_right: True
* [ ] Str2Int "91430003" :arrow_right: 91430003
