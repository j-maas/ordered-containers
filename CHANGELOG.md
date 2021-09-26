# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.3] - 2021-09-26
### Changed
- Renamed GitHub account to be easier to spell. This means this package has to move to [j-maas/elm-ordered-containers](https://package.elm-lang.org/packages/j-maas/elm-ordered-containers/latest/).

## [2.0.2] - 2021-05-12
### Fixed
- Fix `OrderedDict.fromList` retaining duplicate keys ([#22](https://github.com/j-maas/ordered-containers/issues/22)). If there are duplicate keys, only the last one is kept now.

## [2.0.1] - 2020-05-16
### Added
- Documentation on how it works in README.

## [2.0.0] - 2020-02-16
### Added
- `OrderedDict.toDict` and `OrderedSet.toSet`.

### Changed
- All functions were reimplemented and documented to handle reinsertion of existing keys in a clearly defined manner.

### Removed
- "Combine" methods, `diff`, `intersect`, and `union`, because their behavior was not obvious.

## [1.0.0] - 2018-08-28
### Added
- `OrderedDict` and `OrderedSet` implementations.

[Unreleased]: https://github.com/j-maas/ordered-containers/compare/2.0.3...HEAD
[2.0.3]: https://github.com/j-maas/ordered-containers/compare/2.0.2...2.0.3
[2.0.2]: https://github.com/j-maas/ordered-containers/compare/2.0.1...2.0.2
[2.0.1]: https://github.com/j-maas/ordered-containers/compare/2.0.0...2.0.1
[2.0.0]: https://github.com/j-maas/ordered-containers/compare/1.0.0...2.0.0
[1.0.0]: https://github.com/j-maas/ordered-containers/releases/tag/1.0.0