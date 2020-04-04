# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[Unreleased]: https://github.com/y0hy0h/ordered-containers/compare/2.0.0...HEAD
[2.0.0]: https://github.com/y0hy0h/ordered-containers/compare/1.0.0...2.0.0
[1.0.0]: https://github.com/y0hy0h/ordered-containers/releases/tag/1.0.0