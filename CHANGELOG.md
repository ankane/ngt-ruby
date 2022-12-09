## 0.4.1 (2022-12-08)

- Added support for `:float16` object type
- Fixed error with `object` method

## 0.4.0 (2022-06-14)

- Updated NGT to 1.14.6
- Added ARM shared library for Linux
- Improved ARM detection
- Removed deprecated options
- Dropped support for Ruby < 2.7

## 0.3.3 (2021-02-15)

- Added ARM shared library for Mac

## 0.3.2 (2020-12-27)

- Updated NGT to 1.12.2

## 0.3.1 (2020-05-17)

- Updated NGT to 1.11.5
- Improved error message when OpenMP not found on Mac

## 0.3.0 (2020-03-25)

- Updated NGT to 1.10.0
- Added support for OpenMP on Mac
- Create index in memory if no path specified
- Added `normalized_angle` and `normalized_cosine`

## 0.2.4 (2020-03-09)

- Updated NGT to 1.9.1
- Added support for passing an index to optimizers
- Added `dimensions`, `distance_type`, `edge_size_for_creation`, `edge_size_for_search`, and `object_type` methods

## 0.2.3 (2020-03-08)

- Added `load` method
- Deprecated `create` and passing path to `new`

## 0.2.2 (2020-02-11)

- Fixed `Could not find NGT` error on some Linux platforms

## 0.2.1 (2020-02-09)

- Fixed illegal instruction error on some Linux platforms

## 0.2.0 (2020-01-26)

- Changed to Apache 2.0 license to match NGT
- Added shared libraries
- Added optimizer
- Improved performance of `batch_insert` for Numo

## 0.1.1 (2019-10-27)

- Fixed `unable to resolve type 'uint32_t'` error on Ubuntu

## 0.1.0 (2019-10-22)

- First release
